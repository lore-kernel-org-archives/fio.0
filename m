Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 01/13] Fix return value of make_filename() when no filename_format
Date: Tue, 28 Mar 2017 23:02:49 +0300
Message-Id: <20170328200301.8622-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

This is unlikely to happen in the first place since ->filename_format
has a default value, and option parser can also detect an empty string,
but it should return buf which is sprintf'd right before returning.

A caller expects this function to return filename string (which is
buf arg itself in this case), and it also doesn't handle NULL return.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init.c b/init.c
index 4a72255..6af6c45 100644
--- a/init.c
+++ b/init.c
@@ -1121,7 +1121,7 @@ static char *make_filename(char *buf, size_t buf_size,struct thread_options *o,
 
 	if (!o->filename_format || !strlen(o->filename_format)) {
 		sprintf(buf, "%s.%d.%d", jobname, jobnum, filenum);
-		return NULL;
+		return buf;
 	}
 
 	for (f = &fpre_keywords[0]; f->keyword; f++)
-- 
2.9.3


