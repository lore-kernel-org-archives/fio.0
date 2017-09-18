Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH v3] add fio_set_directio() error message for platforms without direct I/O
Date: Mon, 18 Sep 2017 21:42:50 +0300
Message-Id: <20170918184250.50403-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

This lets platforms without dio (e.g. OpenBSD) fail with an explicit
message, otherwise they fail without a clue about dio even with
--debug=all enabled.

The message modified based on comments from Jens.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 filesetup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/filesetup.c b/filesetup.c
index b51ab35..891a55a 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1868,6 +1868,7 @@ int fio_set_directio(struct thread_data *td, struct fio_file *f)
 
 	return 0;
 #else
+	log_err("fio: direct IO is not supported on this host operating system\n");
 	return -1;
 #endif
 }
-- 
2.9.5


