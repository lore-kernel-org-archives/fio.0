Return-Path: <prvs=60033e2b9=bart.vanassche@wdc.com>
From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH] Declare debug_levels[] const
Date: Fri,  9 Mar 2018 16:46:02 -0800
Message-Id: <20180310004602.5733-1-bart.vanassche@wdc.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>
List-ID: <fio@vger.kernel.org>

Since debug_levels[] is not modified by any code, declare it const.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
---
 debug.h | 2 +-
 init.c  | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/debug.h b/debug.h
index ac5f2ccdd551..b8718ddc225f 100644
--- a/debug.h
+++ b/debug.h
@@ -53,7 +53,7 @@ struct debug_level {
 	unsigned long shift;
 	unsigned int jobno;
 };
-extern struct debug_level debug_levels[];
+extern const struct debug_level debug_levels[];
 
 extern unsigned long fio_debug;
 
diff --git a/init.c b/init.c
index 28061db8ea8f..bb0627b208a6 100644
--- a/init.c
+++ b/init.c
@@ -2094,7 +2094,7 @@ static int fill_def_thread(void)
 static void show_debug_categories(void)
 {
 #ifdef FIO_INC_DEBUG
-	struct debug_level *dl = &debug_levels[0];
+	const struct debug_level *dl = &debug_levels[0];
 	int curlen, first = 1;
 
 	curlen = 0;
@@ -2184,7 +2184,7 @@ static void usage(const char *name)
 }
 
 #ifdef FIO_INC_DEBUG
-struct debug_level debug_levels[] = {
+const struct debug_level debug_levels[] = {
 	{ .name = "process",
 	  .help = "Process creation/exit logging",
 	  .shift = FD_PROCESS,
@@ -2262,7 +2262,7 @@ struct debug_level debug_levels[] = {
 
 static int set_debug(const char *string)
 {
-	struct debug_level *dl;
+	const struct debug_level *dl;
 	char *p = (char *) string;
 	char *opt;
 	int i;
-- 
2.16.2


