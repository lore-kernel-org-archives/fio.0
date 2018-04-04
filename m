Return-Path: <rebecca@bluestop.org>
From: Rebecca Cran <rebecca@bluestop.org>
Subject: [PATCH] Fix return value checking of fread() in iolog.c
Date: Wed,  4 Apr 2018 17:18:42 -0600
Message-Id: <20180404231842.35916-1-rebecca@bluestop.org>
To: fio@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Rebecca Cran <rebecca@bluestop.org>
List-ID: <fio@vger.kernel.org>

According to http://pubs.opengroup.org/onlinepubs/7908799/xsh/fread.html
fread() returns a size_t, not ssize_t, and returns a value of 0 on
both eof and an error. Therefore, check both feof() and ferror() to
determine whether the call succeeded.
---
 iolog.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/iolog.c b/iolog.c
index 2b5eaf0c..bfafc032 100644
--- a/iolog.c
+++ b/iolog.c
@@ -978,7 +978,7 @@ int iolog_file_inflate(const char *file)
 	struct iolog_compress ic;
 	z_stream stream;
 	struct stat sb;
-	ssize_t ret;
+	size_t ret;
 	size_t total;
 	void *buf;
 	FILE *f;
@@ -1000,12 +1000,12 @@ int iolog_file_inflate(const char *file)
 	ic.seq = 1;
 
 	ret = fread(ic.buf, ic.len, 1, f);
-	if (ret < 0) {
+	if (ret == 0 && ferror(f)) {
 		perror("fread");
 		fclose(f);
 		free(buf);
 		return 1;
-	} else if (ret != 1) {
+	} else if (ferror(f) || (!feof(f) && ret != 1)) {
 		log_err("fio: short read on reading log\n");
 		fclose(f);
 		free(buf);
-- 
2.16.2.windows.1


