Return-Path: <sbates@raithlin.com>
From: sbates@raithlin.com
Subject: [PATCH v3] rdma: Add bind option
Date: Wed,  8 Nov 2017 15:47:33 -0700
Message-Id: <1510181253-7632-1-git-send-email-sbates@raithlin.com>
MIME-Version: 1.0
Content-Type: text/plain
Return-Path: sbates@raithlin.com
To: axboe@kernel.dk, fio@vger.kernel.org, logang@deltatee.com, elliott@hpe.com
Cc: Stephen Bates <sbates@raithlin.com>
List-ID: <fio@vger.kernel.org>

From: Stephen Bates <sbates@raithlin.com>

In certain configurations it can be useful to bind a rdma_cm to a
particular network interface. For example in multi-path or loopback.

Add a bindname option that the local rdma_cm will try and bind too.

The bind code is based off that used in rping [1].

[1] https://github.com/linux-rdma/rdma-core/blob/ \
    master/librdmacm/examples/rping.c

Signed-off-by: Stephen Bates <sbates@raithlin.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>>
---
Changes since v2
  Correct rmda mis-spelling in subject line

Changes since v1
  Renamed ntoa to the more correct aton
  Added reviewed-by tag from Logan
  Removed renyufei83@yahoo.com.cn due to email bounce

 engines/rdma.c | 64 +++++++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 52 insertions(+), 12 deletions(-)

diff --git a/engines/rdma.c b/engines/rdma.c
index da00cba..6b173a8 100644
--- a/engines/rdma.c
+++ b/engines/rdma.c
@@ -59,6 +59,7 @@ struct rdmaio_options {
 	struct thread_data *td;
 	unsigned int port;
 	enum rdma_io_mode verb;
+	char *bindname;
 };
 
 static int str_hostname_cb(void *data, const char *input)
@@ -82,6 +83,16 @@ static struct fio_option options[] = {
 		.group	= FIO_OPT_G_RDMA,
 	},
 	{
+		.name	= "bindname",
+		.lname	= "rdma engine bindname",
+		.type	= FIO_OPT_STR_STORE,
+		.off1	= offsetof(struct rdmaio_options, bindname),
+		.help	= "Bind for RDMA IO engine",
+		.def    = "",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_RDMA,
+	},
+	{
 		.name	= "port",
 		.lname	= "rdma engine port",
 		.type	= FIO_OPT_INT,
@@ -1004,30 +1015,53 @@ static int fio_rdmaio_close_file(struct thread_data *td, struct fio_file *f)
 	return 0;
 }
 
+static int aton(struct thread_data *td, const char *host,
+		     struct sockaddr_in *addr)
+{
+	if (inet_aton(host, &addr->sin_addr) != 1) {
+		struct hostent *hent;
+
+		hent = gethostbyname(host);
+		if (!hent) {
+			td_verror(td, errno, "gethostbyname");
+			return 1;
+		}
+
+		memcpy(&addr->sin_addr, hent->h_addr, 4);
+	}
+	return 0;
+}
+
 static int fio_rdmaio_setup_connect(struct thread_data *td, const char *host,
 				    unsigned short port)
 {
 	struct rdmaio_data *rd = td->io_ops_data;
+	struct rdmaio_options *o = td->eo;
+	struct sockaddr_storage addrb;
 	struct ibv_recv_wr *bad_wr;
 	int err;
 
 	rd->addr.sin_family = AF_INET;
 	rd->addr.sin_port = htons(port);
 
-	if (inet_aton(host, &rd->addr.sin_addr) != 1) {
-		struct hostent *hent;
+	err = aton(td, host, &rd->addr);
+	if (err)
+		return err;
 
-		hent = gethostbyname(host);
-		if (!hent) {
-			td_verror(td, errno, "gethostbyname");
-			return 1;
-		}
+	/* resolve route */
+	if (strcmp(o->bindname, "") != 0) {
+		addrb.ss_family = AF_INET;
+		err = aton(td, o->bindname, (struct sockaddr_in *)&addrb);
+		if (err)
+			return err;
+		err = rdma_resolve_addr(rd->cm_id, (struct sockaddr *)&addrb,
+					(struct sockaddr *)&rd->addr, 2000);
 
-		memcpy(&rd->addr.sin_addr, hent->h_addr, 4);
+	} else {
+		err = rdma_resolve_addr(rd->cm_id, NULL,
+					(struct sockaddr *)&rd->addr, 2000);
 	}
 
-	/* resolve route */
-	err = rdma_resolve_addr(rd->cm_id, NULL, (struct sockaddr *)&rd->addr, 2000);
 	if (err != 0) {
 		log_err("fio: rdma_resolve_addr: %d\n", err);
 		return 1;
@@ -1072,15 +1106,20 @@ static int fio_rdmaio_setup_connect(struct thread_data *td, const char *host,
 static int fio_rdmaio_setup_listen(struct thread_data *td, short port)
 {
 	struct rdmaio_data *rd = td->io_ops_data;
+	struct rdmaio_options *o = td->eo;
 	struct ibv_recv_wr *bad_wr;
 	int state = td->runstate;
 
 	td_set_runstate(td, TD_SETTING_UP);
 
 	rd->addr.sin_family = AF_INET;
-	rd->addr.sin_addr.s_addr = htonl(INADDR_ANY);
 	rd->addr.sin_port = htons(port);
 
+	if (strcmp(o->bindname, "") == 0)
+		rd->addr.sin_addr.s_addr = htonl(INADDR_ANY);
+	else
+		rd->addr.sin_addr.s_addr = htonl(*o->bindname);
+
 	/* rdma_listen */
 	if (rdma_bind_addr(rd->cm_id, (struct sockaddr *)&rd->addr) != 0) {
 		log_err("fio: rdma_bind_addr fail: %m\n");
@@ -1155,7 +1194,8 @@ static int compat_options(struct thread_data *td)
 {
 	// The original RDMA engine had an ugly / seperator
 	// on the filename for it's options. This function
-	// retains backwards compatibility with it.100
+	// retains backwards compatibility with it. Note we do not
+	// support setting the bindname option is this legacy mode.
 
 	struct rdmaio_options *o = td->eo;
 	char *modep, *portp;
-- 
2.7.4


