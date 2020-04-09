Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53002 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgDIMAC (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 Apr 2020 08:00:02 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jMVqk-0003M2-FX
        for fio@vger.kernel.org; Thu, 09 Apr 2020 12:00:02 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200409120001.C661D1BC016D@kernel.dk>
Date: Thu,  9 Apr 2020 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 9d87c646c45227c86c5a15faee2a6717a4bf1b46:

  zbd: Fix build errors on Windows and MacOS (2020-04-07 20:20:36 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 3f2dcb7f855d43244ec178aa2a34bb1475bf6901:

  Merge branch 'zbd-build' of https://github.com/vincentkfu/fio (2020-04-08 08:46:35 -0600)

----------------------------------------------------------------
Damien Le Moal (3):
      zbd: Fix missing mutex unlock and warnings detected with coverity
      examples: add zonemode=zbd example scripts
      examples: add libzbc ioengine example scripts

Jens Axboe (1):
      Merge branch 'zbd-build' of https://github.com/vincentkfu/fio

Vincent Fu (2):
      zbd: fix Windows build errors
      Revert ".travis.yml: remove pip line from xcode11.2 config"

 .travis.yml                    |  3 +--
 examples/libzbc-rand-write.fio | 20 ++++++++++++++++++++
 examples/libzbc-seq-read.fio   | 19 +++++++++++++++++++
 examples/zbd-rand-write.fio    | 20 ++++++++++++++++++++
 examples/zbd-seq-read.fio      | 19 +++++++++++++++++++
 zbd.c                          |  6 ++++++
 6 files changed, 85 insertions(+), 2 deletions(-)
 create mode 100644 examples/libzbc-rand-write.fio
 create mode 100644 examples/libzbc-seq-read.fio
 create mode 100644 examples/zbd-rand-write.fio
 create mode 100644 examples/zbd-seq-read.fio

---

Diff of recent changes:

diff --git a/.travis.yml b/.travis.yml
index 6b710cc3..77c31b77 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -48,9 +48,8 @@ before_install:
         brew install cunit;
         if [[ "$TRAVIS_OSX_IMAGE" == "xcode11.2" ]]; then
             pip3 install scipy;
-        else
-            pip install scipy;
         fi;
+        pip install scipy;
     fi;
 script:
   - ./configure --extra-cflags="${EXTRA_CFLAGS}" && make
diff --git a/examples/libzbc-rand-write.fio b/examples/libzbc-rand-write.fio
new file mode 100644
index 00000000..ce5870e4
--- /dev/null
+++ b/examples/libzbc-rand-write.fio
@@ -0,0 +1,20 @@
+; Using the libzbc ioengine, random write to a (zoned) block device,
+; writing at most 32 zones at a time. Target zones are chosen randomly
+; and writes directed at the write pointer of the chosen zones
+
+[global]
+name=libzbc-rand-write
+group_reporting
+rw=randwrite
+zonemode=zbd
+zonesize=256M
+max_open_zones=32
+bs=512K
+direct=1
+numjobs=16
+time_based=1
+runtime=300
+
+[dev1]
+filename=/dev/sdj
+ioengine=libzbc
diff --git a/examples/libzbc-seq-read.fio b/examples/libzbc-seq-read.fio
new file mode 100644
index 00000000..f4d265a0
--- /dev/null
+++ b/examples/libzbc-seq-read.fio
@@ -0,0 +1,19 @@
+; Using the libzbc ioengine, sequentially read 40 zones of a (zoned)
+; block device, reading only written data from the 524th zone
+; (524 * 256M = 140660178944)
+
+[global]
+name=libzbc-seq-read
+rw=read
+bs=1M
+direct=1
+numjobs=1
+zonemode=zbd
+zonesize=256M
+read_beyond_wp=0
+
+[dev1]
+filename=/dev/sdd
+offset=140660178944
+size=10G
+ioengine=libzbc
diff --git a/examples/zbd-rand-write.fio b/examples/zbd-rand-write.fio
new file mode 100644
index 00000000..1b3f2088
--- /dev/null
+++ b/examples/zbd-rand-write.fio
@@ -0,0 +1,20 @@
+; Using the libaio ioengine, random write to a (zoned) block device,
+; writing at most 32 zones at a time. Target zones are chosen randomly
+; and writes directed at the write pointer of the chosen zones
+
+[global]
+name=zbd-rand-write
+group_reporting
+rw=randwrite
+zonemode=zbd
+zonesize=256M
+max_open_zones=32
+bs=512K
+direct=1
+numjobs=16
+time_based=1
+runtime=180
+
+[dev1]
+filename=/dev/sdj
+ioengine=psync
diff --git a/examples/zbd-seq-read.fio b/examples/zbd-seq-read.fio
new file mode 100644
index 00000000..82f2b1db
--- /dev/null
+++ b/examples/zbd-seq-read.fio
@@ -0,0 +1,19 @@
+; Sequentially read 40 zones of a (zoned) block device, reading only
+; written data from the 524th zone (524 * 256M = 140660178944)
+
+[global]
+name=zbd-seq-read
+rw=read
+bs=256K
+direct=1
+numjobs=1
+zonemode=zbd
+zonesize=256M
+read_beyond_wp=0
+
+[dev1]
+filename=/dev/sdd
+offset=140660178944
+size=10G
+ioengine=libaio
+iodepth=16
diff --git a/zbd.c b/zbd.c
index f4067802..0b0d4f40 100644
--- a/zbd.c
+++ b/zbd.c
@@ -11,6 +11,7 @@
 #include <sys/stat.h>
 #include <unistd.h>
 
+#include "os/os.h"
 #include "file.h"
 #include "fio.h"
 #include "lib/pow2.h"
@@ -704,6 +705,8 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 	bool reset_wp;
 	int res = 0;
 
+	assert(min_bs);
+
 	dprint(FD_ZBD, "%s: examining zones %u .. %u\n", f->file_name,
 		zbd_zone_nr(f->zbd_info, zb), zbd_zone_nr(f->zbd_info, ze));
 	for (z = zb; z < ze; z++) {
@@ -1004,6 +1007,8 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 
 		dprint(FD_ZBD, "%s(%s): no candidate zone\n",
 			__func__, f->file_name);
+		pthread_mutex_unlock(&f->zbd_info->mutex);
+		pthread_mutex_unlock(&z->mutex);
 		return NULL;
 
 found_candidate_zone:
@@ -1332,6 +1337,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 	if (!f->zbd_info)
 		return io_u_accept;
 
+	assert(min_bs);
 	assert(is_valid_offset(f, io_u->offset));
 	assert(io_u->buflen);
 	zone_idx_b = zbd_zone_idx(f, io_u->offset);

