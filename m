Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 2/4] add fio_set_directio() error message for platforms without direct I/O
Date: Mon, 18 Sep 2017 20:53:48 +0300
Message-Id: <20170918175350.38471-3-tkusumi@tuxera.com>
In-Reply-To: <20170918175350.38471-1-tkusumi@tuxera.com>
References: <20170918175350.38471-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

This lets platforms without dio (e.g. OpenBSD) fail with an explicit
message, otherwise they fail without a clue about dio even with
--debug=all enabled.

"if (!OS_O_DIRECT)" is needed so that only platforms without both
O_DIRECT and FIO_OS_DIRECTIO print this message if/when called.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 filesetup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/filesetup.c b/filesetup.c
index b51ab35..c5eb7cf 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1868,6 +1868,8 @@ int fio_set_directio(struct thread_data *td, struct fio_file *f)
 
 	return 0;
 #else
+	if (!OS_O_DIRECT)
+		log_err("fio: the file system does not seem to support direct IO\n");
 	return -1;
 #endif
 }
-- 
2.9.5


