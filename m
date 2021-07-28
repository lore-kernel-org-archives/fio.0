Return-Path: <prvs=83632cbba=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH] Makefile: update libzbc git repository
Date: Wed, 28 Jul 2021 16:05:42 +0900
Message-Id: <20210728070542.259051-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Update the GIT repository used for libzbc in the fulltes directive from
pointing to the now deprecated hgst reporitory to the currentxi
https://github.com/westerndigitalcorporation/libzbc repository.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 6b4b4122..5198f70e 100644
--- a/Makefile
+++ b/Makefile
@@ -651,7 +651,7 @@ test: fio
 fulltest:
 	sudo modprobe null_blk &&				 	\
 	if [ ! -e /usr/include/libzbc/zbc.h ]; then			\
-	  git clone https://github.com/hgst/libzbc &&		 	\
+	  git clone https://github.com/westerndigitalcorporation/libzbc && \
 	  (cd libzbc &&						 	\
 	   ./autogen.sh &&					 	\
 	   ./configure --prefix=/usr &&				 	\
-- 
2.31.1


