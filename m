Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 3/6] add ifdef __sun__ for Solaris specific code
Date: Wed, 30 Aug 2017 00:12:13 +0300
Message-Id: <20170829211216.42347-4-tkusumi@tuxera.com>
In-Reply-To: <20170829211216.42347-1-tkusumi@tuxera.com>
References: <20170829211216.42347-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

ENOTTY on direct I/O setup failure via directio(3C) is Solaris (ZFS)
specific (as also mentioned in ZoL commit[1]).

Linux and many others which support O_DIRECT never come here, but
others supporting direct I/O via OS specific way don't necessarily
have the same ENOTTY behavior or ZFS itself.

This commit brings back the original log before 42f1ee68 for others.

[1] https://github.com/zfsonlinux/zfs/commit/a08c76a8ad63c28384ead72b53a3d7ef73f39357

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 ioengines.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/ioengines.c b/ioengines.c
index 6e6e3de..6e135af 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -505,12 +505,15 @@ int td_io_open_file(struct thread_data *td, struct fio_file *f)
 
 		if (ret) {
 			td_verror(td, ret, "fio_set_odirect");
+#if defined(__sun__)
 			if (ret == ENOTTY) { /* ENOTTY suggests RAW device or ZFS */
 				log_err("fio: doing directIO to RAW devices or ZFS not supported\n");
 			} else {
 				log_err("fio: the file system does not seem to support direct IO\n");
 			}
-
+#else
+			log_err("fio: the file system does not seem to support direct IO\n");
+#endif
 			goto err;
 		}
 	}
-- 
2.9.5


