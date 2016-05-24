Return-Path: <ms@merkaba.lichtvoll.de>
From: Martin Steigerwald <martin.steigerwald@teamix.de>
Subject: [PATCH 1/5] =?UTF-8?q?Spelling=20fix.=20Reported=20by=20Debian?= =?UTF-8?q?=C2=B4s=20lintian.?=
Date: Tue, 24 May 2016 11:22:46 +0200
Message-Id: <1464081770-19361-2-git-send-email-martin.steigerwald@teamix.de>
In-Reply-To: <1464081770-19361-1-git-send-email-martin.steigerwald@teamix.de>
References: <1464081770-19361-1-git-send-email-martin.steigerwald@teamix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Martin Steigerwald <martin.steigerwald@teamix.de>
List-ID: <fio@vger.kernel.org>

---
 options.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/options.c b/options.c
index 7f0f2c0..3360784 100644
--- a/options.c
+++ b/options.c
@@ -2023,7 +2023,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			  },
 			  { .ival = "normal",
 			    .oval = FIO_RAND_DIST_GAUSS,
-			    .help = "Normal (gaussian) distribution",
+			    .help = "Normal (Gaussian) distribution",
 			  },
 			  { .ival = "zoned",
 			    .oval = FIO_RAND_DIST_ZONED,
-- 
2.8.1


