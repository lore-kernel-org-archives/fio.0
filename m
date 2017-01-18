Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 2/5] Fix typo for "job" in plural
Date: Thu, 19 Jan 2017 02:38:24 +0900
Message-Id: <1484761107-21387-2-git-send-email-tkusumi@tuxera.com>
In-Reply-To: <1484761107-21387-1-git-send-email-tkusumi@tuxera.com>
References: <1484761107-21387-1-git-send-email-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

It seems this message was meant to be 1 or more "job".

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init.c b/init.c
index 324dc7b..2d26c52 100644
--- a/init.c
+++ b/init.c
@@ -2785,7 +2785,7 @@ int parse_options(int argc, char *argv[])
 		if (did_arg)
 			return 0;
 
-		log_err("No jobs(s) defined\n\n");
+		log_err("No job(s) defined\n\n");
 
 		if (!did_arg) {
 			usage(argv[0]);
-- 
2.5.5


