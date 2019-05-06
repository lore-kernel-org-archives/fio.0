Return-Path: <rebecca@bluestop.org>
From: Rebecca Cran <rebecca@bluestop.org>
Subject: [PATCH] Update CFLAGS and LDFLAGS for FreeBSD builds
Date: Mon,  6 May 2019 16:12:41 -0600
Message-Id: <20190506221241.9951-1-rebecca@bluestop.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Rebecca Cran <rebecca@bluestop.org>
List-ID: <fio@vger.kernel.org>

FreeBSD installs third-party headers into /usr/local/include
and libraries into /usr/local/lib.
Update CFLAGS and LDFLAGS to look there.
---
 configure | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/configure b/configure
index c7a7c0ae..d71387c0 100755
--- a/configure
+++ b/configure
@@ -307,6 +307,10 @@ AIX|OpenBSD|NetBSD)
     force_no_lex_o="yes"
   fi
   ;;
+FreeBSD)
+  CFLAGS="$CFLAGS -I/usr/local/include"
+  LDFLAGS="$LDFLAGS -L/usr/local/lib"
+  ;;
 Darwin)
   # on Leopard most of the system is 32-bit, so we have to ask the kernel if
   # we can run 64-bit userspace code.
-- 
2.21.0


