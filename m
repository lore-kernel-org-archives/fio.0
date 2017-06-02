Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 2/2] use correct syscall name in log_err()
Date: Fri,  2 Jun 2017 22:21:27 +0300
Message-Id: <20170602192127.6930-2-tkusumi@tuxera.com>
In-Reply-To: <20170602192127.6930-1-tkusumi@tuxera.com>
References: <20170602192127.6930-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 server.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/server.c b/server.c
index 1e269c2..8a5e75d 100644
--- a/server.c
+++ b/server.c
@@ -1279,7 +1279,7 @@ static int get_my_addr_str(int sk)
 
 	ret = getsockname(sk, sockaddr_p, &len);
 	if (ret) {
-		log_err("fio: getsockaddr: %s\n", strerror(errno));
+		log_err("fio: getsockname: %s\n", strerror(errno));
 		return -1;
 	}
 
-- 
2.9.4


