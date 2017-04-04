Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 3/8] Add assert(0) to DDIR_DATASYNC sync path if fdatasync(2) is unsupported
Date: Tue,  4 Apr 2017 23:22:13 +0300
Message-Id: <20170404202218.52260-3-tkusumi@tuxera.com>
In-Reply-To: <20170404202218.52260-1-tkusumi@tuxera.com>
References: <20170404202218.52260-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

If ddir is DDIR_DATASYNC, it means fio supports fdatasync(2), or it
at least compiled on ./configure. If a platform without fdatasync(2)
happens to take DDIR_DATASYNC path in do_io_u_sync(), it's simply wrong
(because ddir should never be DDIR_DATASYNC due to td->o.fdatasync_blocks == 0)
thus should be aborted rather than continue with EINVAL.

This commit also leaves the existing code from #else path to avoid
compilers complain for uninitialized ret variable.

Tested on FreeBSD and DragonFlyBSD.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 HOWTO  | 3 ++-
 init.c | 4 ++++
 io_u.c | 1 +
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/HOWTO b/HOWTO
index 80b9e75..b9114b4 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1109,7 +1109,8 @@ I/O type
 
 	Like :option:`fsync` but uses :manpage:`fdatasync(2)` to only sync data and
 	not metadata blocks.  In Windows, FreeBSD, and DragonFlyBSD there is no
-	:manpage:`fdatasync(2)`, this falls back to using :manpage:`fsync(2)`.
+	:manpage:`fdatasync(2)`, this falls back to using :manpage:`fsync(2)`
+	by overwriting :manpage:`fsync(2)` value with this option.
 	Defaults to 0, which means no sync data every certain number of writes.
 
 .. option:: write_barrier=int
diff --git a/init.c b/init.c
index 2f9433b..90aaea3 100644
--- a/init.c
+++ b/init.c
@@ -782,6 +782,10 @@ static int fixup_options(struct thread_data *td)
 	}
 
 #ifndef CONFIG_FDATASYNC
+	/*
+	 * If the platform doesn't support fdatasync(2) (e.g. FreeBSD),
+	 * force fsync= using fdatasync= value specified.
+	 */
 	if (o->fdatasync_blocks) {
 		log_info("fio: this platform does not support fdatasync()"
 			 " falling back to using fsync().  Use the 'fsync'"
diff --git a/io_u.c b/io_u.c
index 88f35c9..86c5fc1 100644
--- a/io_u.c
+++ b/io_u.c
@@ -2115,6 +2115,7 @@ int do_io_u_sync(const struct thread_data *td, struct io_u *io_u)
 #else
 		ret = io_u->xfer_buflen;
 		io_u->error = EINVAL;
+		assert(0); /* should be falling back to fsync(2) */
 #endif
 	} else if (io_u->ddir == DDIR_SYNC_FILE_RANGE)
 		ret = do_sync_file_range(td, io_u->file);
-- 
2.9.3


