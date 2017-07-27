Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH] don't print native_fallocate() error if ENOSYS
Date: Thu, 27 Jul 2017 23:38:37 +0300
Message-Id: <20170727203837.97569-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>

log_err(ENOSYS) on native_fallocate() failure which was newly added
by 2c3e17be('filesetup: add native fallocate') should be silenced
or somehow be printed only once instead of being a per file message.

This happens on a platform like FreeBSD where posix_fallocate(3)
exists, but native_fallocate() is ENOSYS.

This commit just silences it if errno is set to ENOSYS on return.
"native" is the default mode, thus not printing ENOSYS won't be any
confusing unless fallocate=native is explicitly specified, and
native_fallocate() has dprint() for ENOSYS case anyway.

--
 # uname
 FreeBSD
 # ./fio --name=xxx --ioengine=sync --rw=read --bs=4k --size=10m --nrfiles=20
 xxx: (g=0): rw=read, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=sync, iodepth=1
 fio-2.99-23-gdad0
 Starting 1 process
 xxx: Laying out IO files (20 files / total 10MiB)
 fio: native_fallocate call failed: Function not implemented
 fio: native_fallocate call failed: Function not implemented
 fio: native_fallocate call failed: Function not implemented
 fio: native_fallocate call failed: Function not implemented
 fio: native_fallocate call failed: Function not implemented
 fio: native_fallocate call failed: Function not implemented
 fio: native_fallocate call failed: Function not implemented
 fio: native_fallocate call failed: Function not implemented
 fio: native_fallocate call failed: Function not implemented
 fio: native_fallocate call failed: Function not implemented
 ...

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 filesetup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/filesetup.c b/filesetup.c
index 362997c..839aefc 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -67,7 +67,7 @@ static void fallocate_file(struct thread_data *td, struct fio_file *f)
 	switch (td->o.fallocate_mode) {
 	case FIO_FALLOCATE_NATIVE:
 		r = native_fallocate(td, f);
-		if (r != 0)
+		if (r != 0 && errno != ENOSYS)
 			log_err("fio: native_fallocate call failed: %s\n",
 					strerror(errno));
 		break;
-- 
2.9.4


