Return-Path: <rebecca@bluestop.org>
From: Rebecca Cran <rebecca@bluestop.org>
Subject: [PATCH] Fix 'nice' parameter range: should be -20 to 19, not -19 to 20.
Date: Thu, 26 Oct 2017 15:28:23 -0600
Message-Id: <20171026212823.86536-1-rebecca@bluestop.org>
To: fio@vger.kernel.org
Cc: axboe@kernel.dk, Rebecca Cran <rebecca@bluestop.org>
List-ID: <fio@vger.kernel.org>

---
 options.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/options.c b/options.c
index 8ee986a7..5813a66b 100644
--- a/options.c
+++ b/options.c
@@ -3252,8 +3252,8 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.type	= FIO_OPT_INT,
 		.off1	= offsetof(struct thread_options, nice),
 		.help	= "Set job CPU nice value",
-		.minval	= -19,
-		.maxval	= 20,
+		.minval	= -20,
+		.maxval	= 19,
 		.def	= "0",
 		.interval = 1,
 		.category = FIO_OPT_C_GENERAL,
-- 
2.14.1


