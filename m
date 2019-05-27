Return-Path: <helmut@subdivi.de>
Date: Mon, 27 May 2019 21:32:49 +0200
From: Helmut Grohne <helmut@subdivi.de>
Subject: [PATCH 1/2] configure: apply ${cross_prefix} to pkg-config calls
Message-ID: <20190527193249.GA15169@alf.mars>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
To: Martin Steigerwald <Martin.Steigerwald@proact.de>, 929579@bugs.debian.org, fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Otherwise, we're searching for build architecture libraries which is not
what we want.

Signed-off-by: Helmut Grohne <helmut@subdivi.de>
---
 configure | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/configure b/configure
index b0052dc1..82bd432e 100755
--- a/configure
+++ b/configure
@@ -1344,14 +1344,14 @@ int main(void)
   return GTK_CHECK_VERSION(2, 18, 0) ? 0 : 1; /* 0 on success */
 }
 EOF
-GTK_CFLAGS=$(pkg-config --cflags gtk+-2.0 gthread-2.0)
+GTK_CFLAGS=$(${cross_prefix}pkg-config --cflags gtk+-2.0 gthread-2.0)
 ORG_LDFLAGS=$LDFLAGS
 LDFLAGS=$(echo $LDFLAGS | sed s/"-static"//g)
 if test "$?" != "0" ; then
   echo "configure: gtk and gthread not found"
   exit 1
 fi
-GTK_LIBS=$(pkg-config --libs gtk+-2.0 gthread-2.0)
+GTK_LIBS=$(${cross_prefix}pkg-config --libs gtk+-2.0 gthread-2.0)
 if test "$?" != "0" ; then
   echo "configure: gtk and gthread not found"
   exit 1
-- 
2.20.1


