Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 6/7] Fix README - change just type "configure" to "./configure"
Date: Tue,  3 Jan 2017 23:40:10 +0900
Message-Id: <1483454411-14535-6-git-send-email-tkusumi@tuxera.com>
In-Reply-To: <1483454411-14535-1-git-send-email-tkusumi@tuxera.com>
References: <1483454411-14535-1-git-send-email-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Literally typing "configure" may or may not work depending on visible paths.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 README | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/README b/README
index d5cc246..fdd5bec 100644
--- a/README
+++ b/README
@@ -97,7 +97,7 @@ and archives for the old list can be found here:
 Building
 --------
 
-Just type 'configure', 'make' and 'make install'.
+Just type './configure', 'make' and 'make install'.
 
 Note that GNU make is required. On BSDs it's available from devel/gmake
 within ports directory; on Solaris it's in the SUNWgmake package.
-- 
2.5.5


