Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 6/6] Fix compile time errors for skeleton_external ioengine
Date: Mon,  9 Jan 2017 23:42:03 +0900
Message-Id: <1483972923-13662-6-git-send-email-tkusumi@tuxera.com>
In-Reply-To: <1483972923-13662-1-git-send-email-tkusumi@tuxera.com>
References: <1483972923-13662-1-git-send-email-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

though this file is not compiled by default.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 engines/skeleton_external.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/engines/skeleton_external.c b/engines/skeleton_external.c
index 5d6a9ed..4bebcc4 100644
--- a/engines/skeleton_external.c
+++ b/engines/skeleton_external.c
@@ -109,11 +109,11 @@ static void fio_skeleton_cleanup(struct thread_data *td)
 
 /*
  * Hook for opening the given file. Unless the engine has special
- * needs, it usually just provides generic_file_open() as the handler.
+ * needs, it usually just provides generic_open_file() as the handler.
  */
 static int fio_skeleton_open(struct thread_data *td, struct fio_file *f)
 {
-	return generic_file_open(td, f);
+	return generic_open_file(td, f);
 }
 
 /*
@@ -121,7 +121,7 @@ static int fio_skeleton_open(struct thread_data *td, struct fio_file *f)
  */
 static int fio_skeleton_close(struct thread_data *td, struct fio_file *f)
 {
-	generic_file_close(td, f);
+	return generic_close_file(td, f);
 }
 
 /*
-- 
2.5.5


