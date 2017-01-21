Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:49646 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750905AbdAUNAP (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 21 Jan 2017 08:00:15 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cUvHD-0001ZP-2F
        for fio@vger.kernel.org; Sat, 21 Jan 2017 13:00:15 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170121130002.82A472C02A5@kernel.dk>
Date: Sat, 21 Jan 2017 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit f70afaca743f2971312d9928f069a9ea7daeccf7:

  Merge branch 'sphinx-doc' of https://github.com/termim/fio (2017-01-19 22:01:48 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 9cf163b0b3f69df8ef70d5a0799d9452e80ee2c4:

  Add missing opt/cat group entries (2017-01-20 10:50:16 -0700)

----------------------------------------------------------------
Tomohiro Kusumi (2):
      Change .category of cpuio to FIO_OPT_C_ENGINE
      Add missing opt/cat group entries

 engines/cpu.c |  6 +++---
 optgroup.c    | 53 ++++++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 49 insertions(+), 10 deletions(-)

---

Diff of recent changes:

diff --git a/engines/cpu.c b/engines/cpu.c
index 3d855e3..d0b4a89 100644
--- a/engines/cpu.c
+++ b/engines/cpu.c
@@ -22,7 +22,7 @@ static struct fio_option options[] = {
 		.type	= FIO_OPT_INT,
 		.off1	= offsetof(struct cpu_options, cpuload),
 		.help	= "Use this percentage of CPU",
-		.category = FIO_OPT_C_GENERAL,
+		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_INVALID,
 	},
 	{
@@ -34,7 +34,7 @@ static struct fio_option options[] = {
 		.def	= "50000",
 		.parent = "cpuload",
 		.hide	= 1,
-		.category = FIO_OPT_C_GENERAL,
+		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_INVALID,
 	},
 	{
@@ -44,7 +44,7 @@ static struct fio_option options[] = {
 		.off1	= offsetof(struct cpu_options, exit_io_done),
 		.help	= "Exit when IO threads finish",
 		.def	= "0",
-		.category = FIO_OPT_C_GENERAL,
+		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_INVALID,
 	},
 	{
diff --git a/optgroup.c b/optgroup.c
index 5f9ca96..122d24e 100644
--- a/optgroup.c
+++ b/optgroup.c
@@ -31,16 +31,16 @@ static const struct opt_group fio_opt_groups[] = {
 		.mask	= FIO_OPT_C_PROFILE,
 	},
 	{
+		.name	= "I/O engines",
+		.mask	= FIO_OPT_C_ENGINE,
+	},
+	{
 		.name	= NULL,
 	},
 };
 
 static const struct opt_group fio_opt_cat_groups[] = {
 	{
-		.name	= "Latency profiling",
-		.mask	= FIO_OPT_G_LATPROF,
-	},
-	{
 		.name	= "Rate",
 		.mask	= FIO_OPT_G_RATE,
 	},
@@ -125,13 +125,52 @@ static const struct opt_group fio_opt_cat_groups[] = {
 		.mask	= FIO_OPT_G_TIOBENCH,
 	},
 	{
-		.name	= "MTD",
+		.name	= "Error handling",
+		.mask	= FIO_OPT_G_ERR,
+	},
+	{
+		.name	= "Ext4 defrag I/O engine", /* e4defrag */
+		.mask	= FIO_OPT_G_E4DEFRAG,
+	},
+	{
+		.name	= "Network I/O engine", /* net */
+		.mask	= FIO_OPT_G_NETIO,
+	},
+	{
+		.name	= "RDMA I/O engine", /* rdma */
+		.mask	= FIO_OPT_G_RDMA,
+	},
+	{
+		.name	= "libaio I/O engine", /* libaio */
+		.mask	= FIO_OPT_G_LIBAIO,
+	},
+	{
+		.name	= "ACT Aerospike like benchmark profile",
+		.mask	= FIO_OPT_G_ACT,
+	},
+	{
+		.name	= "Latency profiling",
+		.mask	= FIO_OPT_G_LATPROF,
+	},
+	{
+		.name	= "RBD I/O engine", /* rbd */
+		.mask	= FIO_OPT_G_RBD,
+	},
+	{
+		.name	= "GlusterFS I/O engine", /* gfapi,gfapi_async */
+		.mask	= FIO_OPT_G_GFAPI,
+	},
+	{
+		.name	= "MTD I/O engine", /* mtd */
 		.mask	= FIO_OPT_G_MTD,
 	},
-
+	{
+		.name	= "libhdfs I/O engine", /* libhdfs */
+		.mask	= FIO_OPT_G_HDFS,
+	},
 	{
 		.name	= NULL,
-	}
+	},
 };
 
 static const struct opt_group *group_from_mask(const struct opt_group *ogs,
