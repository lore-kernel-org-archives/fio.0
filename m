Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 4/7] Fix canonical name for runtime/timeout option
Date: Tue,  3 Jan 2017 23:40:08 +0900
Message-Id: <1483454411-14535-4-git-send-email-tkusumi@tuxera.com>
In-Reply-To: <1483454411-14535-1-git-send-email-tkusumi@tuxera.com>
References: <1483454411-14535-1-git-send-email-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

.name should be set to "runtime" than "timeout".
fio_options[] as well as the existing documentation consider
"runtime" as an option name, and "timeout" as an alias.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 init.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/init.c b/init.c
index d12b75d..9889949 100644
--- a/init.c
+++ b/init.c
@@ -94,7 +94,7 @@ static struct option l_opts[FIO_NR_OPTIONS] = {
 		.val		= 'o' | FIO_CLIENT_FLAG,
 	},
 	{
-		.name		= (char *) "timeout",
+		.name		= (char *) "runtime",
 		.has_arg	= required_argument,
 		.val		= 't' | FIO_CLIENT_FLAG,
 	},
@@ -1984,6 +1984,11 @@ static void show_debug_categories(void)
 #endif
 }
 
+/*
+ * Following options aren't printed by usage().
+ * --append-terse - Equivalent to --output-format=terse, see f6a7df53.
+ * --latency-log - Deprecated option.
+ */
 static void usage(const char *name)
 {
 	printf("%s\n", fio_version_string);
-- 
2.5.5


