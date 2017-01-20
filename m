Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 1/2] Change .category of cpuio to FIO_OPT_C_ENGINE
Date: Sat, 21 Jan 2017 02:46:42 +0900
Message-Id: <1484934403-16963-1-git-send-email-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

This is supposed to be ENGINE instead of GENERAL.

 # grep "\.category" engines -rI | grep -v ENGINE
 engines/cpu.c:          .category = FIO_OPT_C_GENERAL,
 engines/cpu.c:          .category = FIO_OPT_C_GENERAL,
 engines/cpu.c:          .category = FIO_OPT_C_GENERAL,

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 engines/cpu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

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
-- 
2.5.5


