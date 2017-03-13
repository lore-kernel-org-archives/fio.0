Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 2/7] HOWTO: Add note/exception on allow_mounted_write=
Date: Mon, 13 Mar 2017 20:14:58 +0200
Message-Id: <20170313181503.33322-2-tkusumi@tuxera.com>
In-Reply-To: <20170313181503.33322-1-tkusumi@tuxera.com>
References: <20170313181503.33322-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

allow_mounted_write= is useful on Linux, but some platforms
just return some error on open(2) for mounted devices.

 # uname
 Linux
 # mkfs.ext4 /dev/loop0 > /dev/null
 mke2fs 1.43.3 (04-Sep-2016)
 # mount /dev/loop0 /mnt
 # mount | grep /dev/loop0
 /dev/loop0 on /mnt type ext4 (rw,relatime,seclabel,data=ordered)
 # fio --name=xxxxx --ioengine=sync --rw=write --bs=32k --size=1m --filename=/dev/loop0
 xxxxx: (g=0): rw=write, bs=32.0KiB-32.0KiB,32.0KiB-32.0KiB,32.0KiB-32.0KiB, ioengine=sync, iodepth=1
 fio-2.18-21-gca205
 fio: /dev/loop0 appears mounted, and 'allow_mounted_write' isn't set. Aborting.
 Run status group 0 (all jobs):
 # fio --name=xxxxx --ioengine=sync --rw=write --bs=32k --size=1m --filename=/dev/loop0 --allow_mounted_write=1 > /dev/null; echo $?
 0

 # uname
 FreeBSD
 # newfs /dev/da1 > /dev/null
 # mount /dev/da1 /mnt
 # mount | grep /dev/da1
 /dev/da1 on /mnt (ufs, local)
 # fio --name=xxxxx --ioengine=sync --rw=write --bs=32k --size=1m --filename=/dev/da1 --allow_mounted_write=1
 fio: this platform does not support process shared mutexes, forcing use of threads. Use the 'thread' option to get rid of this warning.
 xxxxx: (g=0): rw=write, bs=32.0KiB-32.0KiB,32.0KiB-32.0KiB,32.0KiB-32.0KiB, ioengine=sync, iodepth=1
 fio-2.18-21-gca205
 Starting 1 thread
 fio: failed opening chardev /dev/da1 for size check
 file:filesetup.c:654, func=open(/dev/da1), error=Operation not permitted
 fio: pid=0, err=1/file:filesetup.c:654, func=open(/dev/da1), error=Operation not permitted
 Run status group 0 (all jobs)

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 HOWTO | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/HOWTO b/HOWTO
index c2c6509..e376ea5 100644
--- a/HOWTO
+++ b/HOWTO
@@ -886,7 +886,8 @@ Target file/device
 	If this isn't set, fio will abort jobs that are destructive (e.g. that write)
 	to what appears to be a mounted device or partition. This should help catch
 	creating inadvertently destructive tests, not realizing that the test will
-	destroy data on the mounted file system. Default: false.
+	destroy data on the mounted file system. Note that some platforms don't allow
+	writing against a mounted device regardless of this option. Default: false.
 
 .. option:: pre_read=bool
 
-- 
2.9.3


