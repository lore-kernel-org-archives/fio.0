Return-Path: <ms@merkaba.lichtvoll.de>
From: Martin Steigerwald <martin.steigerwald@teamix.de>
Subject: [PATCH 3/5] =?UTF-8?q?Spelling=20fix.=20Reported=20by=20Debian?= =?UTF-8?q?=C2=B4s=20lintian.?=
Date: Tue, 24 May 2016 11:22:48 +0200
Message-Id: <1464081770-19361-4-git-send-email-martin.steigerwald@teamix.de>
In-Reply-To: <1464081770-19361-1-git-send-email-martin.steigerwald@teamix.de>
References: <1464081770-19361-1-git-send-email-martin.steigerwald@teamix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Martin Steigerwald <martin.steigerwald@teamix.de>
List-ID: <fio@vger.kernel.org>

---
 gettime-thread.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/gettime-thread.c b/gettime-thread.c
index 9bf85f0..6dc1486 100644
--- a/gettime-thread.c
+++ b/gettime-thread.c
@@ -81,7 +81,7 @@ int fio_start_gtod_thread(void)
 
 	ret = pthread_detach(gtod_thread);
 	if (ret) {
-		log_err("Can't detatch gtod thread: %s\n", strerror(ret));
+		log_err("Can't detach gtod thread: %s\n", strerror(ret));
 		goto err;
 	}
 
-- 
2.8.1


