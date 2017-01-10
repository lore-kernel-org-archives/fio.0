Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 3/4] Fix README regarding fio snapshots
Date: Wed, 11 Jan 2017 02:39:46 +0900
Message-Id: <1484069987-13105-3-git-send-email-tkusumi@tuxera.com>
In-Reply-To: <1484069987-13105-1-git-send-email-tkusumi@tuxera.com>
References: <1484069987-13105-1-git-send-email-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

As of now, fio-git-*.tar.{gz,bz2} are git repositories,
but fio-`version`.tar.gz are archives without .git/ meta data.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 README | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/README b/README
index 875d2be..31d53fe 100644
--- a/README
+++ b/README
@@ -21,7 +21,8 @@ If git:// does not work, use the http protocol instead:
 
 	http://git.kernel.dk/fio.git
 
-Snapshots are frequently generated and include the git meta data as well.
+Snapshots are frequently generated and fio-git-*.tar.gz include the git
+meta data as well. Other tarballs are archives of official fio releases.
 Snapshots can download from:
 
 	http://brick.kernel.dk/snaps/
@@ -262,7 +263,7 @@ the copyright and license requirements currently apply to examples/ files.
 
 
 Client/server
-------------
+-------------
 
 Normally fio is invoked as a stand-alone application on the machine
 where the IO workload should be generated. However, the frontend and
-- 
2.5.5


