Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH v2 2/2] add fio_set_directio() error message for platforms without direct I/O
Date: Mon, 18 Sep 2017 21:23:55 +0300
Message-Id: <20170918182355.45590-3-tkusumi@tuxera.com>
In-Reply-To: <20170918182355.45590-1-tkusumi@tuxera.com>
References: <20170918182355.45590-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

This lets platforms without dio (e.g. OpenBSD) fail with an explicit
message, otherwise they fail without a clue about dio even with
--debug=all enabled.

The message assumes platforms with O_DIRECT do not call this function
(and in fact they don't so it's not really a problem).

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 filesetup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/filesetup.c b/filesetup.c
index b51ab35..9813873 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1868,6 +1868,7 @@ int fio_set_directio(struct thread_data *td, struct fio_file *f)
 
 	return 0;
 #else
+	log_err("fio: the file system does not seem to support direct IO\n");
 	return -1;
 #endif
 }
-- 
2.9.5


