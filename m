Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 4/4] fix strncpy(3) copy length
Date: Mon, 18 Sep 2017 20:53:50 +0300
Message-Id: <20170918175350.38471-5-tkusumi@tuxera.com>
In-Reply-To: <20170918175350.38471-1-tkusumi@tuxera.com>
References: <20170918175350.38471-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

0 terminate the last byte, and copy at most size-1.
(or 0 terminate the last byte after copying upto size bytes)

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 os/windows/posix.c | 3 ++-
 server.c           | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/os/windows/posix.c b/os/windows/posix.c
index 488d0ed..00f0335 100755
--- a/os/windows/posix.c
+++ b/os/windows/posix.c
@@ -584,7 +584,8 @@ char *basename(char *path)
 	while (path[i] != '\\' && path[i] != '/' && i >= 0)
 		i--;
 
-	strncpy(name, path + i + 1, MAX_PATH);
+	name[MAX_PATH - 1] = '\0';
+	strncpy(name, path + i + 1, MAX_PATH - 1);
 
 	return name;
 }
diff --git a/server.c b/server.c
index 0469cea..e6ea4cd 100644
--- a/server.c
+++ b/server.c
@@ -856,7 +856,7 @@ static int handle_probe_cmd(struct fio_net_cmd *cmd)
 #ifdef CONFIG_BIG_ENDIAN
 	probe.bigendian = 1;
 #endif
-	strncpy((char *) probe.fio_version, fio_version_string, sizeof(probe.fio_version));
+	strncpy((char *) probe.fio_version, fio_version_string, sizeof(probe.fio_version) - 1);
 
 	probe.os	= FIO_OS;
 	probe.arch	= FIO_ARCH;
-- 
2.9.5


