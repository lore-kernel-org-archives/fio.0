Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: Vincent Fu <vincentfu@gmail.com>
Subject: [PATCH 3/6] server: update server version for the addition of the --stats option
Date: Sun, 16 Apr 2017 15:04:25 -0400
Message-Id: <1492369468-29448-3-git-send-email-vincentfu@gmail.com>
In-Reply-To: <1492369468-29448-1-git-send-email-vincentfu@gmail.com>
References: <1492369468-29448-1-git-send-email-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <Vincent.Fu@sandisk.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <Vincent.Fu@sandisk.com>

---
 server.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/server.h b/server.h
index 798d5a8..5c720d4 100644
--- a/server.h
+++ b/server.h
@@ -49,7 +49,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 60,
+	FIO_SERVER_VER			= 61,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
-- 
2.7.4


