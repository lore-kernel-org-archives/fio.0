Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:50116 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab3DLLNm (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 12 Apr 2013 07:13:42 -0400
Date: Fri, 12 Apr 2013 13:13:18 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Unable to Configure latest build
Message-ID: <20130412111318.GP12244@kernel.dk>
References: <CANUChTygO-6HnaDU+eufAAtJoGCn9J0UgcEd16+7dgeOXa-92Q@mail.gmail.com>
 <20130412081324.GL12244@kernel.dk>
 <CANUChTysujbj-TQR3MK8_CErA68sVP=H9-+3TXri4S4v5Zs9ZA@mail.gmail.com>
 <20130412084236.GM12244@kernel.dk>
 <CANUChTzQ8yhoyD5v8ZetpqDe_9TWmskeR=wi_o4nYHLSUb8Puw@mail.gmail.com>
 <20130412094630.GO12244@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130412094630.GO12244@kernel.dk>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Gavin Martin <gavin_martin@xyratex.com>
Cc: fio@vger.kernel.org

On Fri, Apr 12 2013, Jens Axboe wrote:
> But sounds like it would be a good idea to turn zlib into a soft
> requirement.

The below does that, I have committed it. Please test.


diff --git a/client.c b/client.c
index eb695ff..13e84f6 100644
--- a/client.c
+++ b/client.c
@@ -14,7 +14,9 @@
 #include <arpa/inet.h>
 #include <netdb.h>
 #include <signal.h>
+#ifdef CONFIG_ZLIB
 #include <zlib.h>
+#endif
 
 #include "fio.h"
 #include "client.h"
@@ -296,9 +298,18 @@ int fio_client_add(struct client_ops *ops, const char *hostname, void **cookie)
 
 static void probe_client(struct fio_client *client)
 {
+	struct cmd_client_probe_pdu pdu;
+	uint64_t tag;
+
 	dprint(FD_NET, "client: send probe\n");
 
-	fio_net_send_simple_cmd(client->fd, FIO_NET_CMD_PROBE, 0, &client->cmd_list);
+#ifdef CONFIG_ZLIB
+	pdu.flags = __le64_to_cpu(FIO_PROBE_FLAG_ZLIB);
+#else
+	pdu.flags = 0;
+#endif
+
+	fio_net_send_cmd(client->fd, FIO_NET_CMD_PROBE, &pdu, sizeof(pdu), &tag, &client->cmd_list);
 }
 
 static int fio_client_connect_ip(struct fio_client *client)
@@ -998,7 +1009,7 @@ static void handle_eta(struct fio_client *client, struct fio_net_cmd *cmd)
 
 static void handle_probe(struct fio_client *client, struct fio_net_cmd *cmd)
 {
-	struct cmd_probe_pdu *probe = (struct cmd_probe_pdu *) cmd->payload;
+	struct cmd_probe_reply_pdu *probe = (struct cmd_probe_reply_pdu *) cmd->payload;
 	const char *os, *arch;
 	char bit[16];
 
@@ -1011,10 +1022,11 @@ static void handle_probe(struct fio_client *client, struct fio_net_cmd *cmd)
 		os = "unknown";
 
 	sprintf(bit, "%d-bit", probe->bpp * 8);
+	probe->flags = le64_to_cpu(probe->flags);
 
-	log_info("hostname=%s, be=%u, %s, os=%s, arch=%s, fio=%s\n",
+	log_info("hostname=%s, be=%u, %s, os=%s, arch=%s, fio=%s, flags=%lx\n",
 		probe->hostname, probe->bigendian, bit, os, arch,
-		probe->fio_version);
+		probe->fio_version, (unsigned long) probe->flags);
 
 	if (!client->name)
 		client->name = strdup((char *) probe->hostname);
@@ -1057,19 +1069,15 @@ static void convert_text(struct fio_net_cmd *cmd)
 	pdu->log_usec	= le64_to_cpu(pdu->log_usec);
 }
 
-/*
- * This has been compressed on the server side, since it can be big.
- * Uncompress here.
- */
-static struct cmd_iolog_pdu *convert_iolog(struct fio_net_cmd *cmd)
+static struct cmd_iolog_pdu *convert_iolog_gz(struct fio_net_cmd *cmd,
+					      struct cmd_iolog_pdu *pdu)
 {
-	struct cmd_iolog_pdu *pdu = (struct cmd_iolog_pdu *) cmd->payload;
+#ifdef CONFIG_ZLIB
 	struct cmd_iolog_pdu *ret;
-	uint32_t nr_samples;
-	unsigned long total;
 	z_stream stream;
+	uint32_t nr_samples;
+	size_t total;
 	void *p;
-	int i;
 
 	stream.zalloc = Z_NULL;
 	stream.zfree = Z_NULL;
@@ -1087,10 +1095,9 @@ static struct cmd_iolog_pdu *convert_iolog(struct fio_net_cmd *cmd)
 
 	total = nr_samples * sizeof(struct io_sample);
 	ret = malloc(total + sizeof(*pdu));
-	ret->thread_number = le32_to_cpu(pdu->thread_number);
 	ret->nr_samples = nr_samples;
-	ret->log_type = le32_to_cpu(pdu->log_type);
-	strcpy((char *) ret->name, (char *) pdu->name);
+
+	memcpy(ret, pdu, sizeof(*pdu));
 
 	p = (void *) ret + sizeof(*pdu);
 
@@ -1112,7 +1119,7 @@ static struct cmd_iolog_pdu *convert_iolog(struct fio_net_cmd *cmd)
 			log_err("fio: inflate error %d\n", err);
 			free(ret);
 			ret = NULL;
-			goto out;
+			goto err;
 		}
 
 		this_len = this_chunk - stream.avail_out;
@@ -1120,6 +1127,46 @@ static struct cmd_iolog_pdu *convert_iolog(struct fio_net_cmd *cmd)
 		total -= this_len;
 	}
 
+err:
+	inflateEnd(&stream);
+	return ret;
+#else
+	return NULL;
+#endif
+}
+
+/*
+ * This has been compressed on the server side, since it can be big.
+ * Uncompress here.
+ */
+static struct cmd_iolog_pdu *convert_iolog(struct fio_net_cmd *cmd)
+{
+	struct cmd_iolog_pdu *pdu = (struct cmd_iolog_pdu *) cmd->payload;
+	struct cmd_iolog_pdu *ret;
+	int i;
+
+	/*
+	 * Convert if compressed and we support it. If it's not
+	 * compressed, we need not do anything.
+	 */
+	if (le32_to_cpu(pdu->compressed)) {
+#ifndef CONFIG_ZLIB
+		log_err("fio: server sent compressed data by mistake\n");
+		return NULL;
+#endif
+		ret = convert_iolog_gz(cmd, pdu);
+		if (!ret) {
+			log_err("fio: failed decompressing log\n");
+			return NULL;
+		}
+	} else
+		ret = pdu;
+
+	ret->thread_number	= le32_to_cpu(ret->thread_number);
+	ret->nr_samples		= le32_to_cpu(ret->nr_samples);
+	ret->log_type		= le32_to_cpu(ret->log_type);
+	ret->compressed		= le32_to_cpu(ret->compressed);
+
 	for (i = 0; i < ret->nr_samples; i++) {
 		struct io_sample *s = &ret->samples[i];
 
@@ -1129,8 +1176,6 @@ static struct cmd_iolog_pdu *convert_iolog(struct fio_net_cmd *cmd)
 		s->bs	= le32_to_cpu(s->bs);
 	}
 
-out:
-	inflateEnd(&stream);
 	return ret;
 }
 
diff --git a/configure b/configure
index 87d659c..7be8789 100755
--- a/configure
+++ b/configure
@@ -415,9 +415,6 @@ EOF
 if compile_prog "" "-lz" "zlib" ; then
   zlib=yes
   LIBS="-lz $LIBS"
-else
-  feature_not_found "zlib" "zlib development files"
-  zlib=no
 fi
 echo "zlib                          $zlib"
 
@@ -1083,6 +1080,9 @@ if test "$bigendian" = "yes" ; then
 else
   output_sym "CONFIG_LITTLE_ENDIAN"
 fi
+if test "$zlib" = "yes" ; then
+  output_sym "CONFIG_ZLIB"
+fi
 if test "$libaio" = "yes" ; then
   output_sym "CONFIG_LIBAIO"
 fi
diff --git a/server.c b/server.c
index 8a6275d..020d1d7 100644
--- a/server.c
+++ b/server.c
@@ -16,7 +16,9 @@
 #include <netdb.h>
 #include <syslog.h>
 #include <signal.h>
+#ifdef CONFIG_ZLIB
 #include <zlib.h>
+#endif
 
 #include "fio.h"
 #include "server.h"
@@ -33,6 +35,12 @@ static char *bind_sock;
 static struct sockaddr_in saddr_in;
 static struct sockaddr_in6 saddr_in6;
 static int use_ipv6;
+#ifdef CONFIG_ZLIB
+static unsigned int has_zlib = 1;
+#else
+static unsigned int has_zlib = 0;
+#endif
+static unsigned int use_zlib;
 
 struct fio_fork_item {
 	struct flist_head list;
@@ -616,7 +624,8 @@ static int handle_jobline_cmd(struct fio_net_cmd *cmd)
 
 static int handle_probe_cmd(struct fio_net_cmd *cmd)
 {
-	struct cmd_probe_pdu probe;
+	struct cmd_client_probe_pdu *pdu = (struct cmd_client_probe_pdu *) cmd->payload;
+	struct cmd_probe_reply_pdu probe;
 	uint64_t tag = cmd->tag;
 
 	dprint(FD_NET, "server: sending probe reply\n");
@@ -632,7 +641,17 @@ static int handle_probe_cmd(struct fio_net_cmd *cmd)
 	probe.arch	= FIO_ARCH;
 	probe.bpp	= sizeof(void *);
 	probe.cpus	= __cpu_to_le32(cpus_online());
-	probe.flags	= 0;
+
+	/*
+	 * If the client supports compression and we do too, then enable it
+	 */
+	if (has_zlib && le64_to_cpu(pdu->flags) & FIO_PROBE_FLAG_ZLIB) {
+		probe.flags = __cpu_to_le64(FIO_PROBE_FLAG_ZLIB);
+		use_zlib = 1;
+	} else {
+		probe.flags = 0;
+		use_zlib = 0;
+	}
 
 	return fio_net_send_cmd(server_fd, FIO_NET_CMD_PROBE, &probe, sizeof(probe), &tag, NULL);
 }
@@ -1117,26 +1136,12 @@ static int fio_send_cmd_ext_pdu(int sk, uint16_t opcode, const void *buf,
 	return fio_sendv_data(sk, iov, 2);
 }
 
-int fio_send_iolog(struct thread_data *td, struct io_log *log, const char *name)
+static int fio_send_iolog_gz(struct cmd_iolog_pdu *pdu, struct io_log *log)
 {
-	struct cmd_iolog_pdu pdu;
+	int ret = 0;
+#ifdef CONFIG_ZLIB
 	z_stream stream;
 	void *out_pdu;
-	int i, ret = 0;
-
-	pdu.thread_number = cpu_to_le32(td->thread_number);
-	pdu.nr_samples = __cpu_to_le32(log->nr_samples);
-	pdu.log_type = cpu_to_le32(log->log_type);
-	strcpy((char *) pdu.name, name);
-
-	for (i = 0; i < log->nr_samples; i++) {
-		struct io_sample *s = &log->log[i];
-
-		s->time	= cpu_to_le64(s->time);
-		s->val	= cpu_to_le64(s->val);
-		s->ddir	= cpu_to_le32(s->ddir);
-		s->bs	= cpu_to_le32(s->bs);
-	}
 
 	/*
 	 * Dirty - since the log is potentially huge, compress it into
@@ -1154,14 +1159,6 @@ int fio_send_iolog(struct thread_data *td, struct io_log *log, const char *name)
 		goto err;
 	}
 
-	/*
-	 * Send header first, it's not compressed.
-	 */
-	ret = fio_send_cmd_ext_pdu(server_fd, FIO_NET_CMD_IOLOG, &pdu,
-					sizeof(pdu), 0, FIO_NET_CMD_F_MORE);
-	if (ret)
-		goto err_zlib;
-
 	stream.next_in = (void *) log->log;
 	stream.avail_in = log->nr_samples * sizeof(struct io_sample);
 
@@ -1191,9 +1188,48 @@ err_zlib:
 	deflateEnd(&stream);
 err:
 	free(out_pdu);
+#endif
 	return ret;
 }
 
+int fio_send_iolog(struct thread_data *td, struct io_log *log, const char *name)
+{
+	struct cmd_iolog_pdu pdu;
+	int i, ret = 0;
+
+	pdu.thread_number = cpu_to_le32(td->thread_number);
+	pdu.nr_samples = __cpu_to_le32(log->nr_samples);
+	pdu.log_type = cpu_to_le32(log->log_type);
+	pdu.compressed = cpu_to_le32(use_zlib);
+	strcpy((char *) pdu.name, name);
+
+	for (i = 0; i < log->nr_samples; i++) {
+		struct io_sample *s = &log->log[i];
+
+		s->time	= cpu_to_le64(s->time);
+		s->val	= cpu_to_le64(s->val);
+		s->ddir	= cpu_to_le32(s->ddir);
+		s->bs	= cpu_to_le32(s->bs);
+	}
+
+	/*
+	 * Send header first, it's not compressed.
+	 */
+	ret = fio_send_cmd_ext_pdu(server_fd, FIO_NET_CMD_IOLOG, &pdu,
+					sizeof(pdu), 0, FIO_NET_CMD_F_MORE);
+	if (ret)
+		return ret;
+
+	/*
+	 * Now send actual log, compress if we can, otherwise just plain
+	 */
+	if (use_zlib)
+		return fio_send_iolog_gz(&pdu, log);
+
+	return fio_send_cmd_ext_pdu(server_fd, FIO_NET_CMD_IOLOG, log->log,
+			log->nr_samples * sizeof(struct io_sample), 0, 0);
+}
+
 void fio_server_send_add_job(struct thread_data *td)
 {
 	struct cmd_add_job_pdu pdu;
diff --git a/server.h b/server.h
index 067cdc0..478c283 100644
--- a/server.h
+++ b/server.h
@@ -38,7 +38,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 21,
+	FIO_SERVER_VER			= 22,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 
@@ -71,6 +71,8 @@ enum {
 	FIO_NET_NAME_MAX		= 256,
 
 	FIO_NET_CLIENT_TIMEOUT		= 5000,
+
+	FIO_PROBE_FLAG_ZLIB		= 1UL << 0,
 };
 
 struct cmd_ts_pdu {
@@ -83,7 +85,11 @@ struct cmd_du_pdu {
 	struct disk_util_agg agg;
 };
 
-struct cmd_probe_pdu {
+struct cmd_client_probe_pdu {
+	uint64_t flags;
+};
+
+struct cmd_probe_reply_pdu {
 	uint8_t hostname[64];
 	uint8_t bigendian;
 	uint8_t fio_version[32];
@@ -139,6 +145,7 @@ struct cmd_iolog_pdu {
 	uint32_t thread_number;
 	uint32_t nr_samples;
 	uint32_t log_type;
+	uint32_t compressed;
 	uint8_t name[FIO_NET_NAME_MAX];
 	struct io_sample samples[0];
 };

-- 
Jens Axboe

