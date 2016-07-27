Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 05/15] Use sizeof(char*) instead of sizeof(void*)
Date: Wed, 27 Jul 2016 22:37:10 +0900
Message-Id: <1469626640-13335-5-git-send-email-kusumi.tomohiro@gmail.com>
In-Reply-To: <1469626640-13335-1-git-send-email-kusumi.tomohiro@gmail.com>
References: <1469626640-13335-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

Conform to the exact data type though both pointers are
normally expected to be the same size on various archs.

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 options.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/options.c b/options.c
index df28a19..db5912a 100644
--- a/options.c
+++ b/options.c
@@ -258,7 +258,7 @@ static int str2error(char *str)
 			    "EINVAL", "ENFILE", "EMFILE", "ENOTTY",
 			    "ETXTBSY","EFBIG", "ENOSPC", "ESPIPE",
 			    "EROFS","EMLINK", "EPIPE", "EDOM", "ERANGE" };
-	int i = 0, num = sizeof(err) / sizeof(void *);
+	int i = 0, num = sizeof(err) / sizeof(char *);
 
 	while (i < num) {
 		if (!strcmp(err[i], str))
-- 
2.5.5


