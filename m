Return-Path: <stefanha@redhat.com>
From: Stefan Hajnoczi <stefanha@redhat.com>
Subject: [PATCH 1/2] init: --minimal does not take an optional argument
Date: Tue,  4 Feb 2014 14:27:10 +0100
Message-Id: <1391520431-21732-2-git-send-email-stefanha@redhat.com>
In-Reply-To: <1391520431-21732-1-git-send-email-stefanha@redhat.com>
References: <1391520431-21732-1-git-send-email-stefanha@redhat.com>
To: fio@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init.c b/init.c
index cc35e2b..05c73ef 100644
--- a/init.c
+++ b/init.c
@@ -100,7 +100,7 @@ static struct option l_opts[FIO_NR_OPTIONS] = {
 	},
 	{
 		.name		= (char *) "minimal",
-		.has_arg	= optional_argument,
+		.has_arg	= no_argument,
 		.val		= 'm' | FIO_CLIENT_FLAG,
 	},
 	{
-- 
1.8.5.3


