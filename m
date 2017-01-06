Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 1/2] Remove doubled ; in .c
Date: Sat,  7 Jan 2017 03:15:17 +0900
Message-Id: <1483726518-10712-1-git-send-email-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 engines/net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/engines/net.c b/engines/net.c
index 3bdd5cd..37d44fd 100644
--- a/engines/net.c
+++ b/engines/net.c
@@ -1371,7 +1371,7 @@ static int fio_netio_setup(struct thread_data *td)
 	}
 
 	if (!td->io_ops_data) {
-		nd = malloc(sizeof(*nd));;
+		nd = malloc(sizeof(*nd));
 
 		memset(nd, 0, sizeof(*nd));
 		nd->listenfd = -1;
-- 
2.5.5


