Return-Path: <rjones@redhat.com>
From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: [PATCH] nbd: Remove copy and paste error in example.
Date: Sat,  3 Aug 2019 16:51:06 +0100
Message-Id: <20190803155106.19525-1-rjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org
Cc: eblake@redhat.com, axboe@kernel.dk, sitsofe@gmail.com
List-ID: <fio@vger.kernel.org>

Fixes a copy and paste error introduced in commit d643a1e29d
("engines: Add Network Block Device (NBD) support using libnbd.").

Thanks: Sitsofe Wheeler

Signed-off-by: Richard W.M. Jones <rjones@redhat.com>
---
 examples/nbd.fio | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/examples/nbd.fio b/examples/nbd.fio
index 27e15086..6900ebe7 100644
--- a/examples/nbd.fio
+++ b/examples/nbd.fio
@@ -26,7 +26,7 @@ iodepth=64
 offset=0
 
 [job1]
-offset=064m
+offset=64m
 
 [job2]
 offset=128m
-- 
2.22.0


