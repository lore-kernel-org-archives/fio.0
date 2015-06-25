Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:44131 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbbFYMAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 25 Jun 2015 08:00:06 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Z85p6-0003fW-H3
	for fio@vger.kernel.org; Thu, 25 Jun 2015 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150625120001.A58082C00CB@kernel.dk>
Date: Thu, 25 Jun 2015 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit b01af66b13f0594617602b61d31b1495292e5fd2:

  add eta and elapsed to root of json output (2015-06-22 14:34:04 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to cdf91594d537b59588f3a95c4cc44336326faaf3:

  Modify rdma engine to use proper arguments. (2015-06-23 16:28:03 -0600)

----------------------------------------------------------------
Logan Gunthorpe (1):
      Modify rdma engine to use proper arguments.

 engines/rdma.c             | 212 +++++++++++++++++++++++++++++++++------------
 examples/rdmaio-client.fio |   6 +-
 examples/rdmaio-server.fio |   4 +-
 options.h                  |   2 +
 4 files changed, 163 insertions(+), 61 deletions(-)

---

Diff of recent changes:

diff --git a/engines/rdma.c b/engines/rdma.c
index c59d5dd..2ba34e4 100644
--- a/engines/rdma.c
+++ b/engines/rdma.c
@@ -55,6 +55,77 @@ enum rdma_io_mode {
 	FIO_RDMA_CHA_RECV
 };
 
+struct rdmaio_options {
+	struct thread_data *td;
+	unsigned int port;
+	enum rdma_io_mode verb;
+};
+
+static int str_hostname_cb(void *data, const char *input)
+{
+	struct rdmaio_options *o = data;
+
+	if (o->td->o.filename)
+		free(o->td->o.filename);
+	o->td->o.filename = strdup(input);
+	return 0;
+}
+
+static struct fio_option options[] = {
+	{
+		.name	= "hostname",
+		.lname	= "rdma engine hostname",
+		.type	= FIO_OPT_STR_STORE,
+		.cb	= str_hostname_cb,
+		.help	= "Hostname for RDMA IO engine",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_RDMA,
+	},
+	{
+		.name	= "port",
+		.lname	= "rdma engine port",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct rdmaio_options, port),
+		.minval	= 1,
+		.maxval	= 65535,
+		.help	= "Port to use for RDMA connections",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_RDMA,
+	},
+	{
+		.name	= "verb",
+		.lname	= "RDMA engine verb",
+		.alias	= "proto",
+		.type	= FIO_OPT_STR,
+		.off1	= offsetof(struct rdmaio_options, verb),
+		.help	= "RDMA engine verb",
+		.def	= "write",
+		.posval = {
+			  { .ival = "write",
+			    .oval = FIO_RDMA_MEM_WRITE,
+			    .help = "Memory Write",
+			  },
+			  { .ival = "read",
+			    .oval = FIO_RDMA_MEM_READ,
+			    .help = "Memory Read",
+			  },
+			  { .ival = "send",
+			    .oval = FIO_RDMA_CHA_SEND,
+			    .help = "Posted Send",
+			  },
+			  { .ival = "recv",
+			    .oval = FIO_RDMA_CHA_RECV,
+			    .help = "Posted Recieve",
+			  },
+		},
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_RDMA,
+	},
+	{
+		.name	= NULL,
+	},
+};
+
 struct remote_u {
 	uint64_t buf;
 	uint32_t rkey;
@@ -1046,66 +1117,88 @@ static int check_set_rlimits(struct thread_data *td)
 	return 0;
 }
 
-static int fio_rdmaio_init(struct thread_data *td)
+static int compat_options(struct thread_data *td)
 {
-	struct rdmaio_data *rd = td->io_ops->data;
-	unsigned int max_bs;
-	unsigned int port;
-	char host[64], buf[128];
-	char *sep, *portp, *modep;
-	int ret, i;
+	// The original RDMA engine had an ugly / seperator
+	// on the filename for it's options. This function
+	// retains backwards compatibility with it.100
 
-	if (td_rw(td)) {
-		log_err("fio: rdma connections must be read OR write\n");
-		return 1;
-	}
-	if (td_random(td)) {
-		log_err("fio: RDMA network IO can't be random\n");
-		return 1;
-	}
+	struct rdmaio_options *o = td->eo;
+	char *modep, *portp;
+	char *filename = td->o.filename;
 
-	if (check_set_rlimits(td))
-		return 1;
+	if (!filename)
+		return 0;
 
-	strcpy(buf, td->o.filename);
+	portp = strchr(filename, '/');
+	if (portp == NULL)
+		return 0;
 
-	sep = strchr(buf, '/');
-	if (!sep)
-		goto bad_host;
+	*portp = '\0';
+	portp++;
 
-	*sep = '\0';
-	sep++;
-	strcpy(host, buf);
-	if (!strlen(host))
+	o->port = strtol(portp, NULL, 10);
+	if (!o->port || o->port > 65535)
 		goto bad_host;
 
-	modep = NULL;
-	portp = sep;
-	sep = strchr(portp, '/');
-	if (sep) {
-		*sep = '\0';
-		modep = sep + 1;
+	modep = strchr(portp, '/');
+	if (modep != NULL) {
+		*modep = '\0';
+		modep++;
 	}
 
-	port = strtol(portp, NULL, 10);
-	if (!port || port > 65535)
-		goto bad_host;
-
 	if (modep) {
 		if (!strncmp("rdma_write", modep, strlen(modep)) ||
 		    !strncmp("RDMA_WRITE", modep, strlen(modep)))
-			rd->rdma_protocol = FIO_RDMA_MEM_WRITE;
+			o->verb = FIO_RDMA_MEM_WRITE;
 		else if (!strncmp("rdma_read", modep, strlen(modep)) ||
 			 !strncmp("RDMA_READ", modep, strlen(modep)))
-			rd->rdma_protocol = FIO_RDMA_MEM_READ;
+			o->verb = FIO_RDMA_MEM_READ;
 		else if (!strncmp("send", modep, strlen(modep)) ||
 			 !strncmp("SEND", modep, strlen(modep)))
-			rd->rdma_protocol = FIO_RDMA_CHA_SEND;
+			o->verb = FIO_RDMA_CHA_SEND;
 		else
 			goto bad_host;
 	} else
-		rd->rdma_protocol = FIO_RDMA_MEM_WRITE;
+		o->verb = FIO_RDMA_MEM_WRITE;
+
+
+	return 0;
 
+bad_host:
+	log_err("fio: bad rdma host/port/protocol: %s\n", td->o.filename);
+	return 1;
+}
+
+static int fio_rdmaio_init(struct thread_data *td)
+{
+	struct rdmaio_data *rd = td->io_ops->data;
+	struct rdmaio_options *o = td->eo;
+	unsigned int max_bs;
+	int ret, i;
+
+	if (td_rw(td)) {
+		log_err("fio: rdma connections must be read OR write\n");
+		return 1;
+	}
+	if (td_random(td)) {
+		log_err("fio: RDMA network IO can't be random\n");
+		return 1;
+	}
+
+	if (compat_options(td))
+		return 1;
+
+	if (!o->port) {
+		log_err("fio: no port has been specified which is required "
+			"for the rdma engine\n");
+		return 1;
+	}
+
+	if (check_set_rlimits(td))
+		return 1;
+
+	rd->rdma_protocol = o->verb;
 	rd->cq_event_num = 0;
 
 	rd->cm_channel = rdma_create_event_channel();
@@ -1144,10 +1237,10 @@ static int fio_rdmaio_init(struct thread_data *td)
 	if (td_read(td)) {	/* READ as the server */
 		rd->is_client = 0;
 		/* server rd->rdma_buf_len will be setup after got request */
-		ret = fio_rdmaio_setup_listen(td, port);
+		ret = fio_rdmaio_setup_listen(td, o->port);
 	} else {		/* WRITE as the client */
 		rd->is_client = 1;
-		ret = fio_rdmaio_setup_connect(td, host, port);
+		ret = fio_rdmaio_setup_connect(td, td->o.filename, o->port);
 	}
 
 	max_bs = max(td->o.max_bs[DDIR_READ], td->o.max_bs[DDIR_WRITE]);
@@ -1181,9 +1274,6 @@ static int fio_rdmaio_init(struct thread_data *td)
 	rd->send_buf.nr = htonl(i);
 
 	return ret;
-bad_host:
-	log_err("fio: bad rdma host/port/protocol: %s\n", td->o.filename);
-	return 1;
 }
 
 static void fio_rdmaio_cleanup(struct thread_data *td)
@@ -1198,6 +1288,12 @@ static int fio_rdmaio_setup(struct thread_data *td)
 {
 	struct rdmaio_data *rd;
 
+	if (!td->files_index) {
+		add_file(td, td->o.filename ?: "rdma", 0, 0);
+		td->o.nr_files = td->o.nr_files ?: 1;
+		td->o.open_files++;
+	}
+
 	if (!td->io_ops->data) {
 		rd = malloc(sizeof(*rd));
 
@@ -1210,19 +1306,21 @@ static int fio_rdmaio_setup(struct thread_data *td)
 }
 
 static struct ioengine_ops ioengine_rw = {
-	.name		= "rdma",
-	.version	= FIO_IOOPS_VERSION,
-	.setup		= fio_rdmaio_setup,
-	.init		= fio_rdmaio_init,
-	.prep		= fio_rdmaio_prep,
-	.queue		= fio_rdmaio_queue,
-	.commit		= fio_rdmaio_commit,
-	.getevents	= fio_rdmaio_getevents,
-	.event		= fio_rdmaio_event,
-	.cleanup	= fio_rdmaio_cleanup,
-	.open_file	= fio_rdmaio_open_file,
-	.close_file	= fio_rdmaio_close_file,
-	.flags		= FIO_DISKLESSIO | FIO_UNIDIR | FIO_PIPEIO,
+	.name			= "rdma",
+	.version		= FIO_IOOPS_VERSION,
+	.setup			= fio_rdmaio_setup,
+	.init			= fio_rdmaio_init,
+	.prep			= fio_rdmaio_prep,
+	.queue			= fio_rdmaio_queue,
+	.commit			= fio_rdmaio_commit,
+	.getevents		= fio_rdmaio_getevents,
+	.event			= fio_rdmaio_event,
+	.cleanup		= fio_rdmaio_cleanup,
+	.open_file		= fio_rdmaio_open_file,
+	.close_file		= fio_rdmaio_close_file,
+	.flags			= FIO_DISKLESSIO | FIO_UNIDIR | FIO_PIPEIO,
+	.options		= options,
+	.option_struct_size	= sizeof(struct rdmaio_options),
 };
 
 static void fio_init fio_rdmaio_register(void)
diff --git a/examples/rdmaio-client.fio b/examples/rdmaio-client.fio
index 7c660c9..286aa21 100644
--- a/examples/rdmaio-client.fio
+++ b/examples/rdmaio-client.fio
@@ -1,11 +1,13 @@
 # Example rdma client job
 [global]
 ioengine=rdma
-filename=[ip_addr]/[port]/[RDMA_WRITE/RDMA_READ/SEND]
+hostname=[hostname]
+port=[port]
+verb=[read/write/send/recv]
 bs=1m
 size=100g
 
 [sender]
 rw=write
 iodepth=1
-iodepth_batch_complete=1
\ No newline at end of file
+iodepth_batch_complete=1
diff --git a/examples/rdmaio-server.fio b/examples/rdmaio-server.fio
index 9348859..ee30856 100644
--- a/examples/rdmaio-server.fio
+++ b/examples/rdmaio-server.fio
@@ -1,10 +1,10 @@
 # Example rdma server job
 [global]
 ioengine=rdma
-filename=[ip_addr]/[port]
+port=[port]
 bs=1m
 size=100g
 
 [receiver]
 rw=read
-iodepth=16
\ No newline at end of file
+iodepth=16
diff --git a/options.h b/options.h
index 6805b31..fd6ad92 100644
--- a/options.h
+++ b/options.h
@@ -112,6 +112,7 @@ enum opt_category_group {
 	__FIO_OPT_G_ERR,
 	__FIO_OPT_G_E4DEFRAG,
 	__FIO_OPT_G_NETIO,
+	__FIO_OPT_G_RDMA,
 	__FIO_OPT_G_LIBAIO,
 	__FIO_OPT_G_ACT,
 	__FIO_OPT_G_LATPROF,
@@ -144,6 +145,7 @@ enum opt_category_group {
 	FIO_OPT_G_ERR		= (1U << __FIO_OPT_G_ERR),
 	FIO_OPT_G_E4DEFRAG	= (1U << __FIO_OPT_G_E4DEFRAG),
 	FIO_OPT_G_NETIO		= (1U << __FIO_OPT_G_NETIO),
+	FIO_OPT_G_RDMA		= (1U << __FIO_OPT_G_RDMA),
 	FIO_OPT_G_LIBAIO	= (1U << __FIO_OPT_G_LIBAIO),
 	FIO_OPT_G_ACT		= (1U << __FIO_OPT_G_ACT),
 	FIO_OPT_G_LATPROF	= (1U << __FIO_OPT_G_LATPROF),
