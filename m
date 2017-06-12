Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 3/6] sg: drop redundant void* cast
Date: Mon, 12 Jun 2017 23:02:08 +0300
Message-Id: <20170612200211.17022-4-tkusumi@tuxera.com>
In-Reply-To: <20170612200211.17022-1-tkusumi@tuxera.com>
References: <20170612200211.17022-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

No need to cast to void*.
This is the only void* cast for memcpy(3) in the entire fio.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 engines/sg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/engines/sg.c b/engines/sg.c
index b924ca3..833d920 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -184,7 +184,7 @@ re_read:
 			if (hdr->info & SG_INFO_CHECK) {
 				struct io_u *io_u;
 				io_u = (struct io_u *)(hdr->usr_ptr);
-				memcpy((void*)&(io_u->hdr), (void*)hdr, sizeof(struct sg_io_hdr));
+				memcpy(&io_u->hdr, hdr, sizeof(struct sg_io_hdr));
 				sd->events[i]->error = EIO;
 			}
 		}
-- 
2.9.4


