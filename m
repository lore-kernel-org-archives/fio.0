Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 5/7] Add BSD package/building info to README
Date: Tue,  3 Jan 2017 23:40:09 +0900
Message-Id: <1483454411-14535-5-git-send-email-tkusumi@tuxera.com>
In-Reply-To: <1483454411-14535-1-git-send-email-tkusumi@tuxera.com>
References: <1483454411-14535-1-git-send-email-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 README | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/README b/README
index 2fa8e1b..d5cc246 100644
--- a/README
+++ b/README
@@ -68,6 +68,10 @@ Windows:
 Rebecca Cran <rebecca+fio@bluestop.org> has fio packages for Windows at
 http://www.bluestop.org/fio/ .
 
+BSDs:
+Packages for BSDs may be available from their binary package repositories.
+Look for a package "fio" using their binary package managers.
+
 
 Mailing list
 ------------
@@ -95,9 +99,9 @@ Building
 
 Just type 'configure', 'make' and 'make install'.
 
-Note that GNU make is required. On BSD it's available from devel/gmake;
-on Solaris it's in the SUNWgmake package. On platforms where GNU make
-isn't the default, type 'gmake' instead of 'make'.
+Note that GNU make is required. On BSDs it's available from devel/gmake
+within ports directory; on Solaris it's in the SUNWgmake package.
+On platforms where GNU make isn't the default, type 'gmake' instead of 'make'.
 
 Configure will print the enabled options. Note that on Linux based
 platforms, the libaio development packages must be installed to use
-- 
2.5.5


