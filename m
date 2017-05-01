Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 05/11] configure: output_sym CONFIG_GFIO
Date: Mon,  1 May 2017 21:48:14 +0300
Message-Id: <20170501184820.31025-5-tkusumi@tuxera.com>
In-Reply-To: <20170501184820.31025-1-tkusumi@tuxera.com>
References: <20170501184820.31025-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

No reason not to output_sym CONFIG_GFIO, when all others do this.
Having CONFIG_GFIO in config-host.h doesn't harm anything.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 configure | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/configure b/configure
index 0b72f45..b2120ec 100755
--- a/configure
+++ b/configure
@@ -180,8 +180,7 @@ for opt do
   ;;
   --build-static) build_static="yes"
   ;;
-  --enable-gfio)
-  gfio_check="yes"
+  --enable-gfio) gfio_check="yes"
   ;;
   --disable-numa) disable_numa="yes"
   ;;
@@ -2153,7 +2152,7 @@ if test "$rusage_thread" = "yes" ; then
   output_sym "CONFIG_RUSAGE_THREAD"
 fi
 if test "$gfio" = "yes" ; then
-  echo "CONFIG_GFIO=y" >> $config_host_mak
+  output_sym "CONFIG_GFIO"
 fi
 if test "$esx" = "yes" ; then
   output_sym "CONFIG_ESX"
-- 
2.9.3


