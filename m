Return-Path: <ms@merkaba.lichtvoll.de>
From: Martin Steigerwald <martin.steigerwald@teamix.de>
Subject: [PATCH 2/5] =?UTF-8?q?Spelling=20fix.=20Reported=20by=20Debian?= =?UTF-8?q?=C2=B4s=20lintian.?=
Date: Tue, 24 May 2016 11:22:47 +0200
Message-Id: <1464081770-19361-3-git-send-email-martin.steigerwald@teamix.de>
In-Reply-To: <1464081770-19361-1-git-send-email-martin.steigerwald@teamix.de>
References: <1464081770-19361-1-git-send-email-martin.steigerwald@teamix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Martin Steigerwald <martin.steigerwald@teamix.de>
List-ID: <fio@vger.kernel.org>

---
 memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/memory.c b/memory.c
index c04d7df..af4d5ef 100644
--- a/memory.c
+++ b/memory.c
@@ -89,7 +89,7 @@ static int alloc_mem_shm(struct thread_data *td, unsigned int total_mem)
 					" support huge pages.\n");
 			} else if (errno == ENOMEM) {
 				log_err("fio: no huge pages available, do you"
-					" need to alocate some? See HOWTO.\n");
+					" need to allocate some? See HOWTO.\n");
 			}
 		}
 
-- 
2.8.1


