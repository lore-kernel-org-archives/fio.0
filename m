Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 10/17] Drop fio_unused attribute from used variable
Date: Tue,  7 Mar 2017 22:13:01 +0200
Message-Id: <20170307201308.66814-11-tkusumi@tuxera.com>
In-Reply-To: <20170307201308.66814-1-tkusumi@tuxera.com>
References: <20170307201308.66814-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

This is actually used.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 io_u.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_u.c b/io_u.c
index 46d9731..8d520ab 100644
--- a/io_u.c
+++ b/io_u.c
@@ -643,7 +643,7 @@ int io_u_quiesce(struct thread_data *td)
 	}
 
 	while (td->io_u_in_flight) {
-		int fio_unused ret;
+		int ret;
 
 		ret = io_u_queued_complete(td, 1);
 		if (ret > 0)
-- 
2.9.3


