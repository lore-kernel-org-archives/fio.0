Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238064AbhHNMBR (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 14 Aug 2021 08:01:17 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 683EEC061764
        for <fio@vger.kernel.org>; Sat, 14 Aug 2021 05:00:49 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mEsKa-00GfLW-UA
        for fio@vger.kernel.org; Sat, 14 Aug 2021 12:00:25 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210814120002.425301BC015D@kernel.dk>
Date: Sat, 14 Aug 2021 06:00:02 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 543196617ce45b6a04fb039a3b9c6d06c9b58309:

  t/io_uring: allow multiple IO threads (2021-08-11 16:57:19 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to df9e8b65a52fdab5a1ac48847c44d7201faa3cf1:

  Merge branch 'dfs_update_13_api' of https://github.com/johannlombardi/fio (2021-08-13 10:01:31 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'dfs_update_13_api' of https://github.com/johannlombardi/fio

Johann Lombardi (1):
      engines/dfs: add support for 1.3 DAOS API

 HOWTO         |  4 ++--
 engines/dfs.c | 24 ++++++++++++++++++------
 fio.1         |  4 ++--
 3 files changed, 22 insertions(+), 10 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 04ea284b..9bfd38b4 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2561,11 +2561,11 @@ with the caveat that when used on the command line, they must come after the
 
 .. option:: pool=str : [dfs]
 
-	Specify the UUID of the DAOS pool to connect to.
+	Specify the label or UUID of the DAOS pool to connect to.
 
 .. option:: cont=str : [dfs]
 
-	Specify the UUID of the DAOS container to open.
+	Specify the label or UUID of the DAOS container to open.
 
 .. option:: chunk_size=int : [dfs]
 
diff --git a/engines/dfs.c b/engines/dfs.c
index 0343b101..664e8b13 100644
--- a/engines/dfs.c
+++ b/engines/dfs.c
@@ -49,19 +49,19 @@ struct daos_fio_options {
 static struct fio_option options[] = {
 	{
 		.name		= "pool",
-		.lname		= "pool uuid",
+		.lname		= "pool uuid or label",
 		.type		= FIO_OPT_STR_STORE,
 		.off1		= offsetof(struct daos_fio_options, pool),
-		.help		= "DAOS pool uuid",
+		.help		= "DAOS pool uuid or label",
 		.category	= FIO_OPT_C_ENGINE,
 		.group		= FIO_OPT_G_DFS,
 	},
 	{
 		.name           = "cont",
-		.lname          = "container uuid",
+		.lname          = "container uuid or label",
 		.type           = FIO_OPT_STR_STORE,
 		.off1           = offsetof(struct daos_fio_options, cont),
-		.help           = "DAOS container uuid",
+		.help           = "DAOS container uuid or label",
 		.category	= FIO_OPT_C_ENGINE,
 		.group		= FIO_OPT_G_DFS,
 	},
@@ -103,7 +103,6 @@ static struct fio_option options[] = {
 static int daos_fio_global_init(struct thread_data *td)
 {
 	struct daos_fio_options	*eo = td->eo;
-	uuid_t			pool_uuid, co_uuid;
 	daos_pool_info_t	pool_info;
 	daos_cont_info_t	co_info;
 	int			rc = 0;
@@ -124,6 +123,10 @@ static int daos_fio_global_init(struct thread_data *td)
 		return rc;
 	}
 
+#if !defined(DAOS_API_VERSION_MAJOR) || \
+    (DAOS_API_VERSION_MAJOR == 1 && DAOS_API_VERSION_MINOR < 3)
+	uuid_t pool_uuid, co_uuid;
+
 	rc = uuid_parse(eo->pool, pool_uuid);
 	if (rc) {
 		log_err("Failed to parse 'Pool uuid': %s\n", eo->pool);
@@ -137,6 +140,7 @@ static int daos_fio_global_init(struct thread_data *td)
 		td_verror(td, EINVAL, "uuid_parse(eo->cont)");
 		return EINVAL;
 	}
+#endif
 
 	/* Connect to the DAOS pool */
 #if !defined(DAOS_API_VERSION_MAJOR) || DAOS_API_VERSION_MAJOR < 1
@@ -152,9 +156,12 @@ static int daos_fio_global_init(struct thread_data *td)
 	rc = daos_pool_connect(pool_uuid, NULL, svcl, DAOS_PC_RW,
 			&poh, &pool_info, NULL);
 	d_rank_list_free(svcl);
-#else
+#elif (DAOS_API_VERSION_MAJOR == 1 && DAOS_API_VERSION_MINOR < 3)
 	rc = daos_pool_connect(pool_uuid, NULL, DAOS_PC_RW, &poh, &pool_info,
 			       NULL);
+#else
+	rc = daos_pool_connect(eo->pool, NULL, DAOS_PC_RW, &poh, &pool_info,
+			       NULL);
 #endif
 	if (rc) {
 		log_err("Failed to connect to pool %d\n", rc);
@@ -163,7 +170,12 @@ static int daos_fio_global_init(struct thread_data *td)
 	}
 
 	/* Open the DAOS container */
+#if !defined(DAOS_API_VERSION_MAJOR) || \
+    (DAOS_API_VERSION_MAJOR == 1 && DAOS_API_VERSION_MINOR < 3)
 	rc = daos_cont_open(poh, co_uuid, DAOS_COO_RW, &coh, &co_info, NULL);
+#else
+	rc = daos_cont_open(poh, eo->cont, DAOS_COO_RW, &coh, &co_info, NULL);
+#endif
 	if (rc) {
 		log_err("Failed to open container: %d\n", rc);
 		td_verror(td, rc, "daos_cont_open");
diff --git a/fio.1 b/fio.1
index ff100a1c..382cebfc 100644
--- a/fio.1
+++ b/fio.1
@@ -2326,10 +2326,10 @@ the use of cudaMemcpy.
 .RE
 .TP
 .BI (dfs)pool
-Specify the UUID of the DAOS pool to connect to.
+Specify the label or UUID of the DAOS pool to connect to.
 .TP
 .BI (dfs)cont
-Specify the UUID of the DAOS DAOS container to open.
+Specify the label or UUID of the DAOS container to open.
 .TP
 .BI (dfs)chunk_size
 Specificy a different chunk size (in bytes) for the dfs file.

