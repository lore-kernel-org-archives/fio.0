Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 4/6] Turn off lex by default on OpenBSD
Date: Sun, 30 Apr 2017 20:35:09 +0300
Message-Id: <20170430173511.44593-5-tkusumi@tuxera.com>
In-Reply-To: <20170430173511.44593-1-tkusumi@tuxera.com>
References: <20170430173511.44593-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Do the same as what AIX does. OpenBSD (at least recent ones) hits
below syntax error. Feel free to revert this commit and properly
fix this if possible.

CC y.tab.c
exp/expression-parser.y:68: syntax error
%parse-param { long long *result }
^
gmake: *** [Makefile:341: y.tab.c] Error 1

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 configure | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/configure b/configure
index 83a6702..bcb898a 100755
--- a/configure
+++ b/configure
@@ -257,8 +257,9 @@ fi
 # cross-compiling to one of these OSes then you'll need to specify
 # the correct CPU with the --cpu option.
 case $targetos in
-AIX)
+AIX|OpenBSD)
   # Unless explicitly enabled, turn off lex.
+  # OpenBSD will hit syntax error when enabled.
   if test -z "$disable_lex" ; then
     disable_lex="yes"
   else
-- 
2.9.3


