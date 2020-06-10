Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728480AbgFJMAR (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 10 Jun 2020 08:00:17 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE7AC03E96B
        for <fio@vger.kernel.org>; Wed, 10 Jun 2020 05:00:17 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jizOt-0000bo-7p
        for fio@vger.kernel.org; Wed, 10 Jun 2020 12:00:11 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200610120001.8729B1BC0CF5@kernel.dk>
Date: Wed, 10 Jun 2020 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c9beb194ef608dc49dd2f7537b90951f3c8b432d:

  t/run-fio-tests.py: Accept a wider range of IOPS values (2020-06-07 17:30:42 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 14060ebb90ce5a0a164d0e5e52c13e31b53b282d:

  Merge branch 'latency_window' of https://github.com/liu-song-6/fio (2020-06-09 19:43:52 -0600)

----------------------------------------------------------------
Bart Van Assche (5):
      Make json_object_add_value_string() duplicate its 'value' argument
      client: Fix two memory leaks in handle_job_opt()
      client: Make skipping option appending in handle_job_opt() more selective
      client: Fix a memory leak in an error path
      client: Fix another memory leak in an error path

Jens Axboe (4):
      Merge branch 'client-leak-fix' of https://github.com/bvanassche/fio
      Merge branch 'master' of https://github.com/bvanassche/fio
      Merge branch 'nowait' of https://github.com/koct9i/fio
      Merge branch 'latency_window' of https://github.com/liu-song-6/fio

Konstantin Khlebnikov (1):
      engines: pvsync2 libaio io_uring: add support for RWF_NOWAIT

Song Liu (1):
      init: fix unit of latency_window

 HOWTO              | 20 ++++++++++++++++++++
 client.c           | 37 ++++++++++++++-----------------------
 configure          | 20 ++++++++++++++++++++
 engines/io_uring.c | 12 ++++++++++++
 engines/libaio.c   | 22 +++++++++++++++++++++-
 engines/sync.c     | 12 ++++++++++++
 fio.1              | 16 ++++++++++++++++
 init.c             |  1 -
 json.h             |  2 +-
 os/os-linux.h      |  3 +++
 stat.c             |  6 +-----
 11 files changed, 120 insertions(+), 31 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 9e71a619..9e339bb8 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2097,6 +2097,26 @@ with the caveat that when used on the command line, they must come after the
 	When hipri is set this determines the probability of a pvsync2 I/O being high
 	priority. The default is 100%.
 
+.. option:: nowait : [pvsync2] [libaio] [io_uring]
+
+	By default if a request cannot be executed immediately (e.g. resource starvation,
+	waiting on locks) it is queued and the initiating process will be blocked until
+	the required resource becomes free.
+
+	This option sets the RWF_NOWAIT flag (supported from the 4.14 Linux kernel) and
+	the call will return instantly with EAGAIN or a partial result rather than waiting.
+
+	It is useful to also use ignore_error=EAGAIN when using this option.
+
+	Note: glibc 2.27, 2.28 have a bug in syscall wrappers preadv2, pwritev2.
+	They return EOPNOTSUP instead of EAGAIN.
+
+	For cached I/O, using this option usually means a request operates only with
+	cached data. Currently the RWF_NOWAIT flag does not supported for cached write.
+
+	For direct I/O, requests will only succeed if cache invalidation isn't required,
+	file blocks are fully allocated and the disk request could be issued immediately.
+
 .. option:: cpuload=int : [cpuio]
 
 	Attempt to use the specified percentage of CPU cycles. This is a mandatory
diff --git a/client.c b/client.c
index b7575596..29d8750a 100644
--- a/client.c
+++ b/client.c
@@ -390,8 +390,6 @@ struct fio_client *fio_client_add_explicit(struct client_ops *ops,
 
 	client = get_new_client();
 
-	client->hostname = strdup(hostname);
-
 	if (type == Fio_client_socket)
 		client->is_sock = true;
 	else {
@@ -410,6 +408,7 @@ struct fio_client *fio_client_add_explicit(struct client_ops *ops,
 	client->ops = ops;
 	client->refs = 1;
 	client->type = ops->client_type;
+	client->hostname = strdup(hostname);
 
 	__fio_client_add_cmd_option(client, "fio");
 
@@ -471,8 +470,10 @@ int fio_client_add(struct client_ops *ops, const char *hostname, void **cookie)
 					&client->is_sock, &client->port,
 					&client->addr.sin_addr,
 					&client->addr6.sin6_addr,
-					&client->ipv6))
+					&client->ipv6)) {
+		fio_put_client(client);
 		return -1;
+	}
 
 	client->fd = -1;
 	client->ops = ops;
@@ -1140,37 +1141,27 @@ static void handle_gs(struct fio_client *client, struct fio_net_cmd *cmd)
 static void handle_job_opt(struct fio_client *client, struct fio_net_cmd *cmd)
 {
 	struct cmd_job_option *pdu = (struct cmd_job_option *) cmd->payload;
-	struct print_option *p;
-
-	if (!job_opt_object)
-		return;
 
 	pdu->global = le16_to_cpu(pdu->global);
 	pdu->truncated = le16_to_cpu(pdu->truncated);
 	pdu->groupid = le32_to_cpu(pdu->groupid);
 
-	p = malloc(sizeof(*p));
-	p->name = strdup((char *) pdu->name);
-	if (pdu->value[0] != '\0')
-		p->value = strdup((char *) pdu->value);
-	else
-		p->value = NULL;
-
 	if (pdu->global) {
-		const char *pos = "";
+		if (!job_opt_object)
+			return;
 
-		if (p->value)
-			pos = p->value;
-
-		json_object_add_value_string(job_opt_object, p->name, pos);
+		json_object_add_value_string(job_opt_object,
+					     (const char *)pdu->name,
+					     (const char *)pdu->value);
 	} else if (client->opt_lists) {
 		struct flist_head *opt_list = &client->opt_lists[pdu->groupid];
+		struct print_option *p;
 
+		p = malloc(sizeof(*p));
+		p->name = strdup((const char *)pdu->name);
+		p->value = pdu->value[0] ? strdup((const char *)pdu->value) :
+			NULL;
 		flist_add_tail(&p->list, opt_list);
-	} else {
-		free(p->value);
-		free(p->name);
-		free(p);
 	}
 }
 
diff --git a/configure b/configure
index cf8b88e4..3ee8aaf2 100755
--- a/configure
+++ b/configure
@@ -617,8 +617,25 @@ EOF
     libaio=no
     libaio_uring=no
   fi
+
+  cat > $TMPC <<EOF
+#include <libaio.h>
+#include <stddef.h>
+int main(void)
+{
+  io_prep_preadv2(NULL, 0, NULL, 0, 0, 0);
+  io_prep_pwritev2(NULL, 0, NULL, 0, 0, 0);
+  return 0;
+}
+EOF
+  if compile_prog "" "" "libaio rw flags" ; then
+    libaio_rw_flags=yes
+  else
+    libaio_rw_flags=no
+  fi
 fi
 print_config "Linux AIO support" "$libaio"
+print_config "Linux AIO support rw flags" "$libaio_rw_flags"
 print_config "Linux AIO over io_uring" "$libaio_uring"
 
 ##########################################
@@ -2646,6 +2663,9 @@ if test "$zlib" = "yes" ; then
 fi
 if test "$libaio" = "yes" ; then
   output_sym "CONFIG_LIBAIO"
+  if test "$libaio_rw_flags" = "yes" ; then
+    output_sym "CONFIG_LIBAIO_RW_FLAGS"
+  fi
   if test "$libaio_uring" = "yes" ; then
     output_sym "CONFIG_LIBAIO_URING"
   fi
diff --git a/engines/io_uring.c b/engines/io_uring.c
index ac57af8f..cab7ecaf 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -80,6 +80,7 @@ struct ioring_options {
 	unsigned int sqpoll_cpu;
 	unsigned int nonvectored;
 	unsigned int uncached;
+	unsigned int nowait;
 };
 
 static const int ddir_to_op[2][2] = {
@@ -185,6 +186,15 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_IOURING,
 	},
+	{
+		.name	= "nowait",
+		.lname	= "RWF_NOWAIT",
+		.type	= FIO_OPT_BOOL,
+		.off1	= offsetof(struct ioring_options, nowait),
+		.help	= "Use RWF_NOWAIT for reads/writes",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_IOURING,
+	},
 	{
 		.name	= NULL,
 	},
@@ -235,6 +245,8 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 		}
 		if (!td->o.odirect && o->uncached)
 			sqe->rw_flags = RWF_UNCACHED;
+		if (o->nowait)
+			sqe->rw_flags |= RWF_NOWAIT;
 		if (ld->ioprio_class_set)
 			sqe->ioprio = td->o.ioprio_class << 13;
 		if (ld->ioprio_set)
diff --git a/engines/libaio.c b/engines/libaio.c
index 299798ae..daa576da 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -21,6 +21,11 @@
 #define IOCB_FLAG_IOPRIO    (1 << 1)
 #endif
 
+/* Hack for libaio < 0.3.111 */
+#ifndef CONFIG_LIBAIO_RW_FLAGS
+#define aio_rw_flags __pad2
+#endif
+
 static int fio_libaio_commit(struct thread_data *td);
 static int fio_libaio_init(struct thread_data *td);
 
@@ -51,6 +56,7 @@ struct libaio_options {
 	void *pad;
 	unsigned int userspace_reap;
 	unsigned int cmdprio_percentage;
+	unsigned int nowait;
 };
 
 static struct fio_option options[] = {
@@ -83,6 +89,15 @@ static struct fio_option options[] = {
 		.help	= "Your platform does not support I/O priority classes",
 	},
 #endif
+	{
+		.name	= "nowait",
+		.lname	= "RWF_NOWAIT",
+		.type	= FIO_OPT_BOOL,
+		.off1	= offsetof(struct libaio_options, nowait),
+		.help	= "Set RWF_NOWAIT for reads/writes",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_LIBAIO,
+	},
 	{
 		.name	= NULL,
 	},
@@ -97,15 +112,20 @@ static inline void ring_inc(struct libaio_data *ld, unsigned int *val,
 		*val = (*val + add) % ld->entries;
 }
 
-static int fio_libaio_prep(struct thread_data fio_unused *td, struct io_u *io_u)
+static int fio_libaio_prep(struct thread_data *td, struct io_u *io_u)
 {
+	struct libaio_options *o = td->eo;
 	struct fio_file *f = io_u->file;
 	struct iocb *iocb = &io_u->iocb;
 
 	if (io_u->ddir == DDIR_READ) {
 		io_prep_pread(iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->offset);
+		if (o->nowait)
+			iocb->aio_rw_flags |= RWF_NOWAIT;
 	} else if (io_u->ddir == DDIR_WRITE) {
 		io_prep_pwrite(iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->offset);
+		if (o->nowait)
+			iocb->aio_rw_flags |= RWF_NOWAIT;
 	} else if (ddir_sync(io_u->ddir))
 		io_prep_fsync(iocb, f->fd);
 
diff --git a/engines/sync.c b/engines/sync.c
index 65fd210c..339ba999 100644
--- a/engines/sync.c
+++ b/engines/sync.c
@@ -40,6 +40,7 @@ struct psyncv2_options {
 	unsigned int hipri;
 	unsigned int hipri_percentage;
 	unsigned int uncached;
+	unsigned int nowait;
 };
 
 static struct fio_option options[] = {
@@ -73,6 +74,15 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_INVALID,
 	},
+	{
+		.name	= "nowait",
+		.lname	= "RWF_NOWAIT",
+		.type	= FIO_OPT_BOOL,
+		.off1	= offsetof(struct psyncv2_options, nowait),
+		.help	= "Set RWF_NOWAIT for pwritev2/preadv2",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_INVALID,
+	},
 	{
 		.name	= NULL,
 	},
@@ -164,6 +174,8 @@ static enum fio_q_status fio_pvsyncio2_queue(struct thread_data *td,
 		flags |= RWF_HIPRI;
 	if (!td->o.odirect && o->uncached)
 		flags |= RWF_UNCACHED;
+	if (o->nowait)
+		flags |= RWF_NOWAIT;
 
 	iov->iov_base = io_u->xfer_buf;
 	iov->iov_len = io_u->xfer_buflen;
diff --git a/fio.1 b/fio.1
index 47bc1592..f469c46e 100644
--- a/fio.1
+++ b/fio.1
@@ -1857,6 +1857,22 @@ than normal.
 When hipri is set this determines the probability of a pvsync2 I/O being high
 priority. The default is 100%.
 .TP
+.BI (pvsync2,libaio,io_uring)nowait
+By default if a request cannot be executed immediately (e.g. resource starvation,
+waiting on locks) it is queued and the initiating process will be blocked until
+the required resource becomes free.
+This option sets the RWF_NOWAIT flag (supported from the 4.14 Linux kernel) and
+the call will return instantly with EAGAIN or a partial result rather than waiting.
+
+It is useful to also use \fBignore_error\fR=EAGAIN when using this option.
+Note: glibc 2.27, 2.28 have a bug in syscall wrappers preadv2, pwritev2.
+They return EOPNOTSUP instead of EAGAIN.
+
+For cached I/O, using this option usually means a request operates only with
+cached data. Currently the RWF_NOWAIT flag does not supported for cached write.
+For direct I/O, requests will only succeed if cache invalidation isn't required,
+file blocks are fully allocated and the disk request could be issued immediately.
+.TP
 .BI (cpuio)cpuload \fR=\fPint
 Attempt to use the specified percentage of CPU cycles. This is a mandatory
 option when using cpuio I/O engine.
diff --git a/init.c b/init.c
index e220c323..e53be35a 100644
--- a/init.c
+++ b/init.c
@@ -956,7 +956,6 @@ static int fixup_options(struct thread_data *td)
 	 */
 	o->max_latency *= 1000ULL;
 	o->latency_target *= 1000ULL;
-	o->latency_window *= 1000ULL;
 
 	return ret;
 }
diff --git a/json.h b/json.h
index 1544ed76..d9824263 100644
--- a/json.h
+++ b/json.h
@@ -82,7 +82,7 @@ static inline int json_object_add_value_string(struct json_object *obj,
 		.type = JSON_TYPE_STRING,
 	};
 
-	arg.string = (char *)val;
+	arg.string = strdup(val ? : "");
 	return json_object_add_value_type(obj, name, &arg);
 }
 
diff --git a/os/os-linux.h b/os/os-linux.h
index 0f0bcc3a..6ec7243d 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -325,6 +325,9 @@ static inline int fio_set_sched_idle(void)
 #ifndef RWF_SYNC
 #define RWF_SYNC	0x00000004
 #endif
+#ifndef RWF_NOWAIT
+#define RWF_NOWAIT	0x00000008
+#endif
 
 #ifndef RWF_UNCACHED
 #define RWF_UNCACHED	0x00000040
diff --git a/stat.c b/stat.c
index 2cf11947..b3951199 100644
--- a/stat.c
+++ b/stat.c
@@ -1506,12 +1506,8 @@ static void json_add_job_opts(struct json_object *root, const char *name,
 	json_object_add_value_object(root, name, dir_object);
 
 	flist_for_each(entry, opt_list) {
-		const char *pos = "";
-
 		p = flist_entry(entry, struct print_option, list);
-		if (p->value)
-			pos = p->value;
-		json_object_add_value_string(dir_object, p->name, pos);
+		json_object_add_value_string(dir_object, p->name, p->value);
 	}
 }
 

