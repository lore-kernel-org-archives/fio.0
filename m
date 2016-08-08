Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 4/6] Add missing FIO_NET_CMD entry to fio_server_ops[]
Date: Tue,  9 Aug 2016 02:27:29 +0900
Message-Id: <1470677251-8292-4-git-send-email-kusumi.tomohiro@gmail.com>
In-Reply-To: <1470677251-8292-1-git-send-email-kusumi.tomohiro@gmail.com>
References: <1470677251-8292-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 server.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/server.c b/server.c
index 667a66c..2fd9b45 100644
--- a/server.c
+++ b/server.c
@@ -114,6 +114,7 @@ static const char *fio_server_ops[FIO_NET_CMD_NR] = {
 	"LOAD_FILE",
 	"VTRIGGER",
 	"SENDFILE",
+	"JOB_OPT",
 };
 
 static void sk_lock(struct sk_out *sk_out)
-- 
2.5.5


