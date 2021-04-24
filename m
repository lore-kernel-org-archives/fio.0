Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237225AbhDXMBA (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 24 Apr 2021 08:01:00 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2438BC06174A
        for <fio@vger.kernel.org>; Sat, 24 Apr 2021 05:00:21 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1laGxB-003mSO-5K
        for fio@vger.kernel.org; Sat, 24 Apr 2021 12:00:18 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210424120001.B5BEC1BC0139@kernel.dk>
Date: Sat, 24 Apr 2021 06:00:01 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 1b65668b6a50392436947802a49896e891feb0f8:

  Merge branch 'zbd-no-parallel-init' of https://github.com/floatious/fio (2021-04-22 11:18:23 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 14691a4df98b85621b07dd2bdc0f0a960acbb8ba:

  Merge branch 'gpspm-add-optional-use-rpma_conn_completion_wait-function' of https://github.com/ldorau/fio (2021-04-23 08:39:21 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'gpspm-add-optional-use-rpma_conn_completion_wait-function' of https://github.com/ldorau/fio

Oksana Salyk (1):
      rpma: gpspm: introduce the busy_wait_polling toggle

 HOWTO                             |  5 +++++
 engines/librpma_fio.c             | 11 +++++++++++
 engines/librpma_fio.h             |  2 ++
 engines/librpma_gpspm.c           | 25 +++++++++++++++++++++++--
 examples/librpma_gpspm-server.fio |  2 ++
 fio.1                             |  4 ++++
 6 files changed, 47 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index e6078c5f..889526d9 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2237,6 +2237,11 @@ with the caveat that when used on the command line, they must come after the
 	Set to 1 only when Direct Write to PMem from the remote host is possible.
 	Otherwise, set to 0.
 
+.. option:: busy_wait_polling=bool : [librpma_*_server]
+
+	Set to 0 to wait for completion instead of busy-wait polling completion.
+	Default: 1.
+
 .. option:: interface=str : [netsplice] [net]
 
 	The IP address of the network interface used to send or receive UDP
diff --git a/engines/librpma_fio.c b/engines/librpma_fio.c
index 810b55e2..3d605ed6 100644
--- a/engines/librpma_fio.c
+++ b/engines/librpma_fio.c
@@ -49,6 +49,17 @@ struct fio_option librpma_fio_options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_LIBRPMA,
 	},
+	{
+		.name	= "busy_wait_polling",
+		.lname	= "Set to 0 to wait for completion instead of busy-wait polling completion.",
+		.type	= FIO_OPT_BOOL,
+		.off1	= offsetof(struct librpma_fio_options_values,
+					busy_wait_polling),
+		.help	= "Set to false if you want to reduce CPU usage",
+		.def	= "1",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_LIBRPMA,
+	},
 	{
 		.name	= NULL,
 	},
diff --git a/engines/librpma_fio.h b/engines/librpma_fio.h
index 8cfb2e2d..fb89d99d 100644
--- a/engines/librpma_fio.h
+++ b/engines/librpma_fio.h
@@ -41,6 +41,8 @@ struct librpma_fio_options_values {
 	char *port;
 	/* Direct Write to PMem is possible */
 	unsigned int direct_write_to_pmem;
+	/* Set to 0 to wait for completion instead of busy-wait polling completion. */
+	unsigned int busy_wait_polling;
 };
 
 extern struct fio_option librpma_fio_options[];
diff --git a/engines/librpma_gpspm.c b/engines/librpma_gpspm.c
index ac614f46..74147709 100644
--- a/engines/librpma_gpspm.c
+++ b/engines/librpma_gpspm.c
@@ -683,12 +683,33 @@ static int server_cmpl_process(struct thread_data *td)
 	struct librpma_fio_server_data *csd = td->io_ops_data;
 	struct server_data *sd = csd->server_data;
 	struct rpma_completion *cmpl = &sd->msgs_queued[sd->msg_queued_nr];
+	struct librpma_fio_options_values *o = td->eo;
 	int ret;
 
 	ret = rpma_conn_completion_get(csd->conn, cmpl);
 	if (ret == RPMA_E_NO_COMPLETION) {
-		/* lack of completion is not an error */
-		return 0;
+		if (o->busy_wait_polling == 0) {
+			ret = rpma_conn_completion_wait(csd->conn);
+			if (ret == RPMA_E_NO_COMPLETION) {
+				/* lack of completion is not an error */
+				return 0;
+			} else if (ret != 0) {
+				librpma_td_verror(td, ret, "rpma_conn_completion_wait");
+				goto err_terminate;
+			}
+
+			ret = rpma_conn_completion_get(csd->conn, cmpl);
+			if (ret == RPMA_E_NO_COMPLETION) {
+				/* lack of completion is not an error */
+				return 0;
+			} else if (ret != 0) {
+				librpma_td_verror(td, ret, "rpma_conn_completion_get");
+				goto err_terminate;
+			}
+		} else {
+			/* lack of completion is not an error */
+			return 0;
+		}
 	} else if (ret != 0) {
 		librpma_td_verror(td, ret, "rpma_conn_completion_get");
 		goto err_terminate;
diff --git a/examples/librpma_gpspm-server.fio b/examples/librpma_gpspm-server.fio
index d618f2db..67e92a28 100644
--- a/examples/librpma_gpspm-server.fio
+++ b/examples/librpma_gpspm-server.fio
@@ -20,6 +20,8 @@ thread
 # set to 1 (true) ONLY when Direct Write to PMem from the remote host is possible
 # (https://pmem.io/rpma/documentation/basic-direct-write-to-pmem.html)
 direct_write_to_pmem=0
+# set to 0 (false) to wait for completion instead of busy-wait polling completion.
+busy_wait_polling=1
 numjobs=1 # number of expected incomming connections
 iodepth=2 # number of parallel GPSPM requests
 size=100MiB # size of workspace for a single connection
diff --git a/fio.1 b/fio.1
index 18dc156a..c3916168 100644
--- a/fio.1
+++ b/fio.1
@@ -1999,6 +1999,10 @@ The IP address to be used for RDMA-CM based I/O.
 .BI (librpma_*_server)direct_write_to_pmem \fR=\fPbool
 Set to 1 only when Direct Write to PMem from the remote host is possible. Otherwise, set to 0.
 .TP
+.BI (librpma_*_server)busy_wait_polling \fR=\fPbool
+Set to 0 to wait for completion instead of busy-wait polling completion.
+Default: 1.
+.TP
 .BI (netsplice,net)interface \fR=\fPstr
 The IP address of the network interface used to send or receive UDP
 multicast.

