Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 2/2] Add missing opt/cat group entries
Date: Sat, 21 Jan 2017 02:46:43 +0900
Message-Id: <1484934403-16963-2-git-send-email-tkusumi@tuxera.com>
In-Reply-To: <1484934403-16963-1-git-send-email-tkusumi@tuxera.com>
References: <1484934403-16963-1-git-send-email-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 optgroup.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 46 insertions(+), 7 deletions(-)

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
-- 
2.5.5


