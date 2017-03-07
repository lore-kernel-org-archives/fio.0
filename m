Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 02/17] HOWTO: Add platforms without fdatasync(2)
Date: Tue,  7 Mar 2017 22:12:53 +0200
Message-Id: <20170307201308.66814-3-tkusumi@tuxera.com>
In-Reply-To: <20170307201308.66814-1-tkusumi@tuxera.com>
References: <20170307201308.66814-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Added DragonFlyBSD which is a fork of FreeBSD.
FreeBSD seems to have fdatasync(2) in their upstream, but not yet
in the latest release version if I checked correctly.

Btw, having "Windows" here sounds a bit ambiguous.
Cygwin with gcc (not MinGW) compiles below taken from ./configure
by linking against POSIX compat dll.

--
 $ uname
 CYGWIN_NT-10.0
 $ cat ./fdatasync1.c
 #include <stdio.h>
 #include <unistd.h>
 int main(int argc, char **argv)
 {
 	  return fdatasync(0);
 }
 $ gcc -Wall -g ./fdatasync1.c ; echo $?
 0

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 HOWTO | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/HOWTO b/HOWTO
index a72d868..04752d5 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1104,7 +1104,7 @@ I/O type
 .. option:: fdatasync=int
 
 	Like :option:`fsync` but uses :manpage:`fdatasync(2)` to only sync data and
-	not metadata blocks.  In FreeBSD and Windows there is no
+	not metadata blocks.  In Windows, FreeBSD, and DragonFlyBSD there is no
 	:manpage:`fdatasync(2)`, this falls back to using :manpage:`fsync(2)`.
 
 .. option:: write_barrier=int
-- 
2.9.3


