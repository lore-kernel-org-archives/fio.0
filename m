Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 13/17] Minor fixup for "Layint out IO file..." message
Date: Tue,  7 Mar 2017 22:13:04 +0200
Message-Id: <20170307201308.66814-14-tkusumi@tuxera.com>
In-Reply-To: <20170307201308.66814-1-tkusumi@tuxera.com>
References: <20170307201308.66814-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

This is the same as what run_threads() does for threads/processes.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 filesetup.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/filesetup.c b/filesetup.c
index f42f5d8..b240891 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1008,9 +1008,15 @@ int setup_files(struct thread_data *td)
 	 */
 	if (need_extend) {
 		temp_stall_ts = 1;
-		if (output_format & FIO_OUTPUT_NORMAL)
-			log_info("%s: Laying out IO file(s) (%u file(s) / %lluMiB)\n",
-				 o->name, need_extend, extend_size >> 20);
+		if (output_format & FIO_OUTPUT_NORMAL) {
+			log_info("%s: Laying out IO file%s (%u file%s / %s%lluMiB)\n",
+				 o->name,
+				 need_extend > 1 ? "s" : "",
+				 need_extend,
+				 need_extend > 1 ? "s" : "",
+				 need_extend > 1 ? "total " : "",
+				 extend_size >> 20);
+		}
 
 		for_each_file(td, f, i) {
 			unsigned long long old_len = -1ULL, extend_len = -1ULL;
-- 
2.9.3


