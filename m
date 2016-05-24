Return-Path: <ms@merkaba.lichtvoll.de>
From: Martin Steigerwald <martin.steigerwald@teamix.de>
Subject: [PATCH 4/5] Spelling fix.
Date: Tue, 24 May 2016 11:22:49 +0200
Message-Id: <1464081770-19361-5-git-send-email-martin.steigerwald@teamix.de>
In-Reply-To: <1464081770-19361-1-git-send-email-martin.steigerwald@teamix.de>
References: <1464081770-19361-1-git-send-email-martin.steigerwald@teamix.de>
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Martin Steigerwald <martin.steigerwald@teamix.de>
List-ID: <fio@vger.kernel.org>

---
 idletime.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/idletime.c b/idletime.c
index fab43c5..4c00d80 100644
--- a/idletime.c
+++ b/idletime.c
@@ -260,7 +260,7 @@ void fio_idle_prof_init(void)
 
 		if ((ret = pthread_detach(ipt->thread))) {
 			/* log error and let the thread spin */
-			log_err("fio: pthread_detatch %s\n", strerror(ret));
+			log_err("fio: pthread_detach %s\n", strerror(ret));
 		}
 	}
 
-- 
2.8.1


