Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 1/7] Fix trivial calloc argument order
Date: Tue,  3 Jan 2017 23:40:05 +0900
Message-Id: <1483454411-14535-1-git-send-email-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 engines/sg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/engines/sg.c b/engines/sg.c
index c1fe602..001193d 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -579,7 +579,7 @@ static char *fio_sgio_errdetails(struct io_u *io_u)
 	char *msg, msgchunk[MAXMSGCHUNK], *ret = NULL;
 	int i;
 
-	msg = calloc(MAXERRDETAIL, 1);
+	msg = calloc(1, MAXERRDETAIL);
 
 	/*
 	 * can't seem to find sg_err.h, so I'll just echo the define values
-- 
2.5.5


