Return-Path: <tkusumi@tuxera.com>
From: Tomohiro Kusumi <tkusumi@tuxera.com>
Subject: [PATCH 6/6] Revert "configure: Drop default CONFIG_LITTLE_ENDIAN for Cygwin"
Date: Sun, 19 Feb 2017 20:24:44 +0200
Message-ID: <20170219182444.120609-1-tkusumi@tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

This reverts commit d0f2828f6e49613d944a980e018cbfc02901264b
to unbreak on Cygwin.

As mentioned at below, it also needed to remove "exit 0",
but I'd rather like to revert this commit for now since there are
some other small niche to be fixed if we remove "exit 0".

https://github.com/axboe/fio/issues/314

The orginal commit was to get rid of redundant config setup on
endianness on Cygwin, but it turned out many of the unconditional
output_sym() calls in this CYGWIN*) case were done under Cygwin
specific way without going through regular configure procedure
(see "Forcing known good options on Windows" part for details),
although there are some unconditional output_sym() calls that need
to be there (e.g. CONFIG_WINDOWSAIO).

Since fixing endianness alone (by removing "exit 0") doesn't
have much meaning as a whole, it makes more sense to just revert
this for the time being.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 configure | 1 +
 1 file changed, 1 insertion(+)

diff --git a/configure b/configure
index 584ebc2..44d215f 100755
--- a/configure
+++ b/configure
@@ -306,6 +306,7 @@ CYGWIN*)
       fi
     fi
   fi
+  output_sym "CONFIG_LITTLE_ENDIAN"
   if test ! -z "$build_32bit_win" && test "$build_32bit_win" = "yes"; then
     output_sym "CONFIG_32BIT"
   else
-- 
2.9.3


