Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 1/3] verify: add missing free(ptr);
Date: Fri, 26 May 2017 22:25:09 +0300
Message-Id: <20170526192511.31502-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 verify.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/verify.c b/verify.c
index cadfe9c..1c39fa2 100644
--- a/verify.c
+++ b/verify.c
@@ -271,6 +271,7 @@ static void dump_buf(char *buf, unsigned int len, unsigned long long offset,
 	fd = open(fname, O_CREAT | O_TRUNC | O_WRONLY, 0644);
 	if (fd < 0) {
 		perror("open verify buf file");
+		free(ptr);
 		return;
 	}
 
-- 
2.9.4


