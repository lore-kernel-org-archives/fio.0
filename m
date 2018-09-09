Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:57568 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbeIIQtm (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 9 Sep 2018 12:49:42 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fyyNy-0003dY-Fx
        for fio@vger.kernel.org; Sun, 09 Sep 2018 12:00:14 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180909120001.78C462C00A8@kernel.dk>
Date: Sun,  9 Sep 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 2eca48926723d3ebe8f43d4999302fb826f4a250:

  client: cleanup output types (2018-09-07 15:59:51 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to fd98fb689d5ad7e9977461e961fff3fdd37f9cb8:

  Kill fusion atomic write engine (2018-09-08 08:09:53 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      Rename example job files (*.job -> *.fio)
      Kill fusion atomic write engine

 Makefile                                           |   3 -
 configure                                          |  25 ---
 engines/fusion-aw.c                                | 183 ---------------------
 examples/{fio-rand-RW.job => fio-rand-RW.fio}      |   0
 examples/{fio-rand-read.job => fio-rand-read.fio}  |   0
 .../{fio-rand-write.job => fio-rand-write.fio}     |   0
 examples/{fio-seq-RW.job => fio-seq-RW.fio}        |   0
 examples/{fio-seq-read.job => fio-seq-read.fio}    |   0
 examples/{fio-seq-write.job => fio-seq-write.fio}  |   0
 examples/fusion-aw-sync.fio                        |  18 --
 options.c                                          |   5 -
 os/windows/examples.wxs                            |  28 ++--
 12 files changed, 12 insertions(+), 250 deletions(-)
 delete mode 100644 engines/fusion-aw.c
 rename examples/{fio-rand-RW.job => fio-rand-RW.fio} (100%)
 rename examples/{fio-rand-read.job => fio-rand-read.fio} (100%)
 rename examples/{fio-rand-write.job => fio-rand-write.fio} (100%)
 rename examples/{fio-seq-RW.job => fio-seq-RW.fio} (100%)
 rename examples/{fio-seq-read.job => fio-seq-read.fio} (100%)
 rename examples/{fio-seq-write.job => fio-seq-write.fio} (100%)
 delete mode 100644 examples/fusion-aw-sync.fio

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 7e87b2f..42e5205 100644
--- a/Makefile
+++ b/Makefile
@@ -86,9 +86,6 @@ endif
 ifdef CONFIG_GUASI
   SOURCE += engines/guasi.c
 endif
-ifdef CONFIG_FUSION_AW
-  SOURCE += engines/fusion-aw.c
-endif
 ifdef CONFIG_SOLARISAIO
   SOURCE += engines/solarisaio.c
 endif
diff --git a/configure b/configure
index 5e11195..26c345b 100755
--- a/configure
+++ b/configure
@@ -1149,28 +1149,6 @@ fi
 print_config "GUASI" "$guasi"
 
 ##########################################
-# fusion-aw probe
-if test "$fusion_aw" != "yes" ; then
-  fusion_aw="no"
-fi
-cat > $TMPC << EOF
-#include <nvm/nvm_primitives.h>
-int main(int argc, char **argv)
-{
-  nvm_version_t ver_info;
-  nvm_handle_t handle;
-
-  handle = nvm_get_handle(0, &ver_info);
-  return nvm_atomic_write(handle, 0, 0, 0);
-}
-EOF
-if compile_prog "" "-L/usr/lib/fio -L/usr/lib/nvm -lnvm-primitives -ldl -lpthread" "fusion-aw"; then
-  LIBS="-L/usr/lib/fio -L/usr/lib/nvm -lnvm-primitives -ldl -lpthread $LIBS"
-  fusion_aw="yes"
-fi
-print_config "Fusion-io atomic engine" "$fusion_aw"
-
-##########################################
 # libnuma probe
 if test "$libnuma" != "yes" ; then
   libnuma="no"
@@ -2405,9 +2383,6 @@ fi
 if test "$guasi" = "yes" ; then
   output_sym "CONFIG_GUASI"
 fi
-if test "$fusion_aw" = "yes" ; then
-  output_sym "CONFIG_FUSION_AW"
-fi
 if test "$libnuma_v2" = "yes" ; then
   output_sym "CONFIG_LIBNUMA"
 fi
diff --git a/engines/fusion-aw.c b/engines/fusion-aw.c
deleted file mode 100644
index eb5fdf5..0000000
--- a/engines/fusion-aw.c
+++ /dev/null
@@ -1,183 +0,0 @@
-/*
- * Custom fio(1) engine that submits synchronous atomic writes to file.
- *
- * Copyright (C) 2013 Fusion-io, Inc.
- * Author: Santhosh Kumar Koundinya (skoundinya@fusionio.com).
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; under version 2 of the License.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License version
- * 2 for more details.
- *
- * You should have received a copy of the GNU General Public License Version 2
- * along with this program; if not see <http://www.gnu.org/licenses/>
- */
-
-#include <stdlib.h>
-#include <stdint.h>
-
-#include "../fio.h"
-
-#include <nvm/nvm_primitives.h>
-
-#define NUM_ATOMIC_CAPABILITIES (5)
-
-struct fas_data {
-	nvm_handle_t nvm_handle;
-	size_t xfer_buf_align;
-	size_t xfer_buflen_align;
-	size_t xfer_buflen_max;
-	size_t sector_size;
-};
-
-static enum fio_q_status queue(struct thread_data *td, struct io_u *io_u)
-{
-	struct fas_data *d = FILE_ENG_DATA(io_u->file);
-	int rc;
-
-	if (io_u->ddir != DDIR_WRITE) {
-		td_vmsg(td, EINVAL, "only writes supported", "io_u->ddir");
-		rc = -EINVAL;
-		goto out;
-	}
-
-	if ((size_t) io_u->xfer_buf % d->xfer_buf_align) {
-		td_vmsg(td, EINVAL, "unaligned data buffer", "io_u->xfer_buf");
-		rc = -EINVAL;
-		goto out;
-	}
-
-	if (io_u->xfer_buflen % d->xfer_buflen_align) {
-		td_vmsg(td, EINVAL, "unaligned data size", "io_u->xfer_buflen");
-		rc = -EINVAL;
-		goto out;
-	}
-
-	if (io_u->xfer_buflen > d->xfer_buflen_max) {
-		td_vmsg(td, EINVAL, "data too big", "io_u->xfer_buflen");
-		rc = -EINVAL;
-		goto out;
-	}
-
-	rc = nvm_atomic_write(d->nvm_handle, (uint64_t) io_u->xfer_buf,
-		io_u->xfer_buflen, io_u->offset / d->sector_size);
-	if (rc == -1) {
-		td_verror(td, errno, "nvm_atomic_write");
-		rc = -errno;
-		goto out;
-	}
-	rc = FIO_Q_COMPLETED;
-out:
-	if (rc < 0)
-		io_u->error = -rc;
-
-	return rc;
-}
-
-static int open_file(struct thread_data *td, struct fio_file *f)
-{
-	int rc;
-	int fio_unused close_file_rc;
-	struct fas_data *d;
-	nvm_version_t nvm_version;
-	nvm_capability_t nvm_capability[NUM_ATOMIC_CAPABILITIES];
-
-
-	d = malloc(sizeof(*d));
-	if (!d) {
-		td_verror(td, ENOMEM, "malloc");
-		rc = ENOMEM;
-		goto error;
-	}
-	d->nvm_handle = -1;
-	FILE_SET_ENG_DATA(f, d);
-
-	rc = generic_open_file(td, f);
-
-	if (rc)
-		goto free_engine_data;
-
-	/* Set the version of the library as seen when engine is compiled */
-	nvm_version.major = NVM_PRIMITIVES_API_MAJOR;
-	nvm_version.minor = NVM_PRIMITIVES_API_MINOR;
-	nvm_version.micro = NVM_PRIMITIVES_API_MICRO;
-
-	d->nvm_handle = nvm_get_handle(f->fd, &nvm_version);
-	if (d->nvm_handle == -1) {
-		td_vmsg(td, errno, "nvm_get_handle failed", "nvm_get_handle");
-		rc = errno;
-		goto close_file;
-	}
-
-	nvm_capability[0].cap_id = NVM_CAP_ATOMIC_WRITE_START_ALIGN_ID;
-	nvm_capability[1].cap_id = NVM_CAP_ATOMIC_WRITE_MULTIPLICITY_ID;
-	nvm_capability[2].cap_id = NVM_CAP_ATOMIC_WRITE_MAX_VECTOR_SIZE_ID;
-	nvm_capability[3].cap_id = NVM_CAP_SECTOR_SIZE_ID;
-	nvm_capability[4].cap_id = NVM_CAP_ATOMIC_MAX_IOV_ID;
-	rc = nvm_get_capabilities(d->nvm_handle, nvm_capability,
-                                  NUM_ATOMIC_CAPABILITIES, false);
-	if (rc == -1) {
-		td_vmsg(td, errno, "error in getting atomic write capabilities", "nvm_get_capabilities");
-		rc = errno;
-		goto close_file;
-	} else if (rc < NUM_ATOMIC_CAPABILITIES) {
-		td_vmsg(td, EINVAL, "couldn't get all the atomic write capabilities" , "nvm_get_capabilities");
-		rc = ECANCELED;
-		goto close_file;
-	}
-	/* Reset rc to 0 because we got all capabilities we needed */
-	rc = 0;
-	d->xfer_buf_align = nvm_capability[0].cap_value;
-	d->xfer_buflen_align = nvm_capability[1].cap_value;
-	d->xfer_buflen_max = d->xfer_buflen_align * nvm_capability[2].cap_value * nvm_capability[4].cap_value;
-	d->sector_size = nvm_capability[3].cap_value;
-
-out:
-	return rc;
-close_file:
-	close_file_rc = generic_close_file(td, f);
-free_engine_data:
-	free(d);
-error:
-	f->fd = -1;
-	FILE_SET_ENG_DATA(f, NULL);
-	goto out;
-}
-
-static int close_file(struct thread_data *td, struct fio_file *f)
-{
-	struct fas_data *d = FILE_ENG_DATA(f);
-
-	if (d) {
-		if (d->nvm_handle != -1)
-			nvm_release_handle(d->nvm_handle);
-		free(d);
-		FILE_SET_ENG_DATA(f, NULL);
-	}
-
-	return generic_close_file(td, f);
-}
-
-static struct ioengine_ops ioengine = {
-	.name = "fusion-aw-sync",
-	.version = FIO_IOOPS_VERSION,
-	.queue = queue,
-	.open_file = open_file,
-	.close_file = close_file,
-	.get_file_size = generic_get_file_size,
-	.flags = FIO_SYNCIO | FIO_RAWIO | FIO_MEMALIGN
-};
-
-static void fio_init fio_fusion_aw_init(void)
-{
-	register_ioengine(&ioengine);
-}
-
-static void fio_exit fio_fusion_aw_exit(void)
-{
-	unregister_ioengine(&ioengine);
-}
diff --git a/examples/fio-rand-RW.fio b/examples/fio-rand-RW.fio
new file mode 100644
index 0000000..0df0bc1
--- /dev/null
+++ b/examples/fio-rand-RW.fio
@@ -0,0 +1,18 @@
+; fio-rand-RW.job for fiotest
+
+[global]
+name=fio-rand-RW
+filename=fio-rand-RW
+rw=randrw
+rwmixread=60
+rwmixwrite=40
+bs=4K
+direct=0
+numjobs=4
+time_based=1
+runtime=900
+
+[file1]
+size=10G
+ioengine=libaio
+iodepth=16
diff --git a/examples/fio-rand-RW.job b/examples/fio-rand-RW.job
deleted file mode 100644
index 0df0bc1..0000000
--- a/examples/fio-rand-RW.job
+++ /dev/null
@@ -1,18 +0,0 @@
-; fio-rand-RW.job for fiotest
-
-[global]
-name=fio-rand-RW
-filename=fio-rand-RW
-rw=randrw
-rwmixread=60
-rwmixwrite=40
-bs=4K
-direct=0
-numjobs=4
-time_based=1
-runtime=900
-
-[file1]
-size=10G
-ioengine=libaio
-iodepth=16
diff --git a/examples/fio-rand-read.fio b/examples/fio-rand-read.fio
new file mode 100644
index 0000000..bc15466
--- /dev/null
+++ b/examples/fio-rand-read.fio
@@ -0,0 +1,16 @@
+; fio-rand-read.job for fiotest
+
+[global]
+name=fio-rand-read
+filename=fio-rand-read
+rw=randread
+bs=4K
+direct=0
+numjobs=1
+time_based=1
+runtime=900
+
+[file1]
+size=10G
+ioengine=libaio
+iodepth=16
diff --git a/examples/fio-rand-read.job b/examples/fio-rand-read.job
deleted file mode 100644
index bc15466..0000000
--- a/examples/fio-rand-read.job
+++ /dev/null
@@ -1,16 +0,0 @@
-; fio-rand-read.job for fiotest
-
-[global]
-name=fio-rand-read
-filename=fio-rand-read
-rw=randread
-bs=4K
-direct=0
-numjobs=1
-time_based=1
-runtime=900
-
-[file1]
-size=10G
-ioengine=libaio
-iodepth=16
diff --git a/examples/fio-rand-write.fio b/examples/fio-rand-write.fio
new file mode 100644
index 0000000..bd1b73a
--- /dev/null
+++ b/examples/fio-rand-write.fio
@@ -0,0 +1,16 @@
+; fio-rand-write.job for fiotest
+
+[global]
+name=fio-rand-write
+filename=fio-rand-write
+rw=randwrite
+bs=4K
+direct=0
+numjobs=4
+time_based=1
+runtime=900
+
+[file1]
+size=10G
+ioengine=libaio
+iodepth=16
diff --git a/examples/fio-rand-write.job b/examples/fio-rand-write.job
deleted file mode 100644
index bd1b73a..0000000
--- a/examples/fio-rand-write.job
+++ /dev/null
@@ -1,16 +0,0 @@
-; fio-rand-write.job for fiotest
-
-[global]
-name=fio-rand-write
-filename=fio-rand-write
-rw=randwrite
-bs=4K
-direct=0
-numjobs=4
-time_based=1
-runtime=900
-
-[file1]
-size=10G
-ioengine=libaio
-iodepth=16
diff --git a/examples/fio-seq-RW.fio b/examples/fio-seq-RW.fio
new file mode 100644
index 0000000..8f7090f
--- /dev/null
+++ b/examples/fio-seq-RW.fio
@@ -0,0 +1,18 @@
+; fio-seq-RW.job for fiotest
+
+[global]
+name=fio-seq-RW
+filename=fio-seq-RW
+rw=rw
+rwmixread=60
+rwmixwrite=40
+bs=256K
+direct=0
+numjobs=4
+time_based=1
+runtime=900
+
+[file1]
+size=10G
+ioengine=libaio
+iodepth=16
diff --git a/examples/fio-seq-RW.job b/examples/fio-seq-RW.job
deleted file mode 100644
index 8f7090f..0000000
--- a/examples/fio-seq-RW.job
+++ /dev/null
@@ -1,18 +0,0 @@
-; fio-seq-RW.job for fiotest
-
-[global]
-name=fio-seq-RW
-filename=fio-seq-RW
-rw=rw
-rwmixread=60
-rwmixwrite=40
-bs=256K
-direct=0
-numjobs=4
-time_based=1
-runtime=900
-
-[file1]
-size=10G
-ioengine=libaio
-iodepth=16
diff --git a/examples/fio-seq-read.fio b/examples/fio-seq-read.fio
new file mode 100644
index 0000000..28de93c
--- /dev/null
+++ b/examples/fio-seq-read.fio
@@ -0,0 +1,14 @@
+[global]
+name=fio-seq-reads
+filename=fio-seq-reads
+rw=read
+bs=256K
+direct=1
+numjobs=1
+time_based=1
+runtime=900
+
+[file1]
+size=10G
+ioengine=libaio
+iodepth=16
diff --git a/examples/fio-seq-read.job b/examples/fio-seq-read.job
deleted file mode 100644
index 28de93c..0000000
--- a/examples/fio-seq-read.job
+++ /dev/null
@@ -1,14 +0,0 @@
-[global]
-name=fio-seq-reads
-filename=fio-seq-reads
-rw=read
-bs=256K
-direct=1
-numjobs=1
-time_based=1
-runtime=900
-
-[file1]
-size=10G
-ioengine=libaio
-iodepth=16
diff --git a/examples/fio-seq-write.fio b/examples/fio-seq-write.fio
new file mode 100644
index 0000000..b291a15
--- /dev/null
+++ b/examples/fio-seq-write.fio
@@ -0,0 +1,16 @@
+; fio-seq-write.job for fiotest
+
+[global]
+name=fio-seq-write
+filename=fio-seq-write
+rw=write
+bs=256K
+direct=0
+numjobs=1
+time_based=1
+runtime=900
+
+[file1]
+size=10G
+ioengine=libaio
+iodepth=16
diff --git a/examples/fio-seq-write.job b/examples/fio-seq-write.job
deleted file mode 100644
index b291a15..0000000
--- a/examples/fio-seq-write.job
+++ /dev/null
@@ -1,16 +0,0 @@
-; fio-seq-write.job for fiotest
-
-[global]
-name=fio-seq-write
-filename=fio-seq-write
-rw=write
-bs=256K
-direct=0
-numjobs=1
-time_based=1
-runtime=900
-
-[file1]
-size=10G
-ioengine=libaio
-iodepth=16
diff --git a/examples/fusion-aw-sync.fio b/examples/fusion-aw-sync.fio
deleted file mode 100644
index f2ca313..0000000
--- a/examples/fusion-aw-sync.fio
+++ /dev/null
@@ -1,18 +0,0 @@
-# Example Job File that randomly writes 8k worth of data atomically for
-# 60 seconds.
-[rw_aw_file_sync]
-rw=randwrite
-ioengine=fusion-aw-sync
-blocksize=8k
-blockalign=8k
-
-# if file system supports atomic write
-filename=/mnt/fs/file
-# or test on a direct block device instead
-#filename=/dev/fioa
-randrepeat=1
-fallocate=none
-direct=1
-invalidate=0
-runtime=60
-time_based
diff --git a/options.c b/options.c
index 534233b..6bd7455 100644
--- a/options.c
+++ b/options.c
@@ -1828,11 +1828,6 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .help = "RDMA IO engine",
 			  },
 #endif
-#ifdef CONFIG_FUSION_AW
-			  { .ival = "fusion-aw-sync",
-			    .help = "Fusion-io atomic write engine",
-			  },
-#endif
 #ifdef CONFIG_LINUX_EXT4_MOVE_EXTENT
 			  { .ival = "e4defrag",
 			    .help = "ext4 defrag engine",
diff --git a/os/windows/examples.wxs b/os/windows/examples.wxs
index e8580d9..9308ba8 100755
--- a/os/windows/examples.wxs
+++ b/os/windows/examples.wxs
@@ -45,22 +45,22 @@
                   <File Source="..\..\examples\filecreate-ioengine.fio" />
                 </Component>
                 <Component>
-                  <File Source="..\..\examples\fio-rand-read.job" />
+                  <File Source="..\..\examples\fio-rand-read.fio" />
                 </Component>
                 <Component>
-                  <File Source="..\..\examples\fio-rand-RW.job" />
+                  <File Source="..\..\examples\fio-rand-RW.fio" />
                 </Component>
                 <Component>
-                  <File Source="..\..\examples\fio-rand-write.job" />
+                  <File Source="..\..\examples\fio-rand-write.fio" />
                 </Component>
                 <Component>
-                  <File Source="..\..\examples\fio-seq-read.job" />
+                  <File Source="..\..\examples\fio-seq-read.fio" />
                 </Component>
                 <Component>
-                  <File Source="..\..\examples\fio-seq-RW.job" />
+                  <File Source="..\..\examples\fio-seq-RW.fio" />
                 </Component>
                 <Component>
-                  <File Source="..\..\examples\fio-seq-write.job" />
+                  <File Source="..\..\examples\fio-seq-write.fio" />
                 </Component>
                 <Component>
                   <File Source="..\..\examples\fixed-rate-submission.fio" />
@@ -75,9 +75,6 @@
                   <File Source="..\..\examples\ftruncate.fio" />
                 </Component>
                 <Component>
-                  <File Source="..\..\examples\fusion-aw-sync.fio" />
-                </Component>
-                <Component>
                   <File Source="..\..\examples\gfapi.fio" />
                 </Component>
                 <Component>
@@ -188,17 +185,16 @@
             <ComponentRef Id="enospc_pressure.fio" />
             <ComponentRef Id="falloc.fio" />
             <ComponentRef Id="filecreate_ioengine.fio"/>
-            <ComponentRef Id="fio_rand_read.job"/>
-            <ComponentRef Id="fio_rand_RW.job"/>
-            <ComponentRef Id="fio_rand_write.job"/>
-            <ComponentRef Id="fio_seq_read.job"/>
-            <ComponentRef Id="fio_seq_RW.job"/>
-            <ComponentRef Id="fio_seq_write.job"/>
+            <ComponentRef Id="fio_rand_read.fio"/>
+            <ComponentRef Id="fio_rand_RW.fio"/>
+            <ComponentRef Id="fio_rand_write.fio"/>
+            <ComponentRef Id="fio_seq_read.fio"/>
+            <ComponentRef Id="fio_seq_RW.fio"/>
+            <ComponentRef Id="fio_seq_write.fio"/>
             <ComponentRef Id="fixed_rate_submission.fio" />
             <ComponentRef Id="flow.fio" />
             <ComponentRef Id="fsx.fio" />
             <ComponentRef Id="ftruncate.fio"/>
-            <ComponentRef Id="fusion_aw_sync.fio" />
             <ComponentRef Id="gfapi.fio" />
             <ComponentRef Id="gpudirect_rdmaio_client.fio"/>
             <ComponentRef Id="gpudirect_rdmaio_server.fio"/>

