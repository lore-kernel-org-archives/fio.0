Return-Path: <prvs=470d1383e=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH 1/3] configure: improve libzbc version check
Date: Mon, 27 Jul 2020 12:16:36 +0900
Message-Id: <20200727031638.28264-2-dmitry.fomichev@wdc.com>
In-Reply-To: <20200727031638.28264-1-dmitry.fomichev@wdc.com>
References: <20200727031638.28264-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

Avoid parsing pkg-config output and just use --atleast-version to
check if libzbc is present and has an up to date version. Since
this process may fail because pkg-config is not installed, verify
pkg-config presence and warn the user if it was not found.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 configure | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/configure b/configure
index 5925e94f..0c4a96ec 100755
--- a/configure
+++ b/configure
@@ -2467,11 +2467,14 @@ int main(int argc, char **argv)
 }
 EOF
 if compile_prog "" "-lzbc" "libzbc"; then
-  libzbcvermaj=$(pkg-config --modversion libzbc | sed 's/\.[0-9]*\.[0-9]*//')
-  if test "$libzbcvermaj" -ge "5" ; then
+  if $(pkg-config --atleast-version=5 libzbc); then
     libzbc="yes"
+    LIBS="-lzbc $LIBS"
+  elif pkg-config --version > /dev/null 2>&1; then
+    print_config "libzbc engine" "libzbc version 5 or above required"
+    libzbc="no"
   else
-    print_config "libzbc engine" "Unsupported libzbc version (version 5 or above required)"
+    print_config "libzbc engine" "missing pkg-config, can't check library version"
     libzbc="no"
   fi
 else
-- 
2.21.0


