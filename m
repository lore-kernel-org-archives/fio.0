Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 3/8] server: don't use void* for pointer arithmetic (gcc)
Date: Sat, 24 Jun 2017 01:07:56 +0300
Message-Id: <20170623220801.38178-4-tkusumi@tuxera.com>
In-Reply-To: <20170623220801.38178-1-tkusumi@tuxera.com>
References: <20170623220801.38178-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

I think gcc extension should be avoided when it can be done by
just changing a pointer type.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 server.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/server.c b/server.c
index 8b36e38..2d17df6 100644
--- a/server.c
+++ b/server.c
@@ -252,9 +252,10 @@ static int fio_send_data(int sk, const void *p, unsigned int len)
 	return fio_sendv_data(sk, &iov, 1);
 }
 
-static int fio_recv_data(int sk, void *p, unsigned int len, bool wait)
+static int fio_recv_data(int sk, void *buf, unsigned int len, bool wait)
 {
 	int flags;
+	char *p = buf;
 
 	if (wait)
 		flags = MSG_WAITALL;
@@ -377,7 +378,7 @@ struct fio_net_cmd *fio_net_recv_cmd(int sk, bool wait)
 			break;
 
 		/* There's payload, get it */
-		pdu = (void *) cmdret->payload + pdu_offset;
+		pdu = (char *) cmdret->payload + pdu_offset;
 		ret = fio_recv_data(sk, pdu, cmd.pdu_len, wait);
 		if (ret)
 			break;
-- 
2.9.4


