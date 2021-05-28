Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233262AbhE1MBu (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 28 May 2021 08:01:50 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB121C061574
        for <fio@vger.kernel.org>; Fri, 28 May 2021 05:00:15 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lmb9p-006ZkR-BW
        for fio@vger.kernel.org; Fri, 28 May 2021 12:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210528120002.027101BC017F@kernel.dk>
Date: Fri, 28 May 2021 06:00:02 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 0313e938c9c8bb37d71dade239f1f5326677b079:

  Fio 3.27 (2021-05-26 10:10:32 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 575686bb85fa36f326524c505e83c54abc0d2f2b:

  zbd: add a new --ignore_zone_limits option (2021-05-27 16:04:58 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'fix-libpmem' of https://github.com/lukaszstolarczuk/fio

Niklas Cassel (2):
      zbd: add missing client/server support for option max_open_zones
      zbd: add a new --ignore_zone_limits option

��ukasz Stolarczuk (3):
      engines/libpmem: set file open/create mode always to RW
      engines/libpmem: cleanup a little code, comments and example
      engines/libpmem: do not call drain on close

 cconv.c              |  4 ++++
 engines/libpmem.c    | 64 +++++++++++++++++-----------------------------------
 examples/libpmem.fio | 35 ++++++++++++++--------------
 fio.1                |  5 ++++
 options.c            | 10 ++++++++
 server.h             |  2 +-
 thread_options.h     |  3 +++
 zbd.c                |  2 +-
 8 files changed, 63 insertions(+), 62 deletions(-)

---

Diff of recent changes:

diff --git a/cconv.c b/cconv.c
index aa06e3ea..74c24106 100644
--- a/cconv.c
+++ b/cconv.c
@@ -231,6 +231,8 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->zone_capacity = le64_to_cpu(top->zone_capacity);
 	o->zone_skip = le64_to_cpu(top->zone_skip);
 	o->zone_mode = le32_to_cpu(top->zone_mode);
+	o->max_open_zones = __le32_to_cpu(top->max_open_zones);
+	o->ignore_zone_limits = le32_to_cpu(top->ignore_zone_limits);
 	o->lockmem = le64_to_cpu(top->lockmem);
 	o->offset_increment_percent = le32_to_cpu(top->offset_increment_percent);
 	o->offset_increment = le64_to_cpu(top->offset_increment);
@@ -573,6 +575,8 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->zone_capacity = __cpu_to_le64(o->zone_capacity);
 	top->zone_skip = __cpu_to_le64(o->zone_skip);
 	top->zone_mode = __cpu_to_le32(o->zone_mode);
+	top->max_open_zones = __cpu_to_le32(o->max_open_zones);
+	top->ignore_zone_limits = cpu_to_le32(o->ignore_zone_limits);
 	top->lockmem = __cpu_to_le64(o->lockmem);
 	top->ddir_seq_add = __cpu_to_le64(o->ddir_seq_add);
 	top->file_size_low = __cpu_to_le64(o->file_size_low);
diff --git a/engines/libpmem.c b/engines/libpmem.c
index 2338f0fa..ab29a453 100644
--- a/engines/libpmem.c
+++ b/engines/libpmem.c
@@ -2,7 +2,7 @@
  * libpmem: IO engine that uses PMDK libpmem to read and write data
  *
  * Copyright (C) 2017 Nippon Telegraph and Telephone Corporation.
- * Copyright 2018-2020, Intel Corporation
+ * Copyright 2018-2021, Intel Corporation
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License,
@@ -18,7 +18,8 @@
 /*
  * libpmem engine
  *
- * IO engine that uses libpmem to write data (and memcpy to read)
+ * IO engine that uses libpmem (part of PMDK collection) to write data
+ *	and libc's memcpy to read. It requires PMDK >= 1.5.
  *
  * To use:
  *   ioengine=libpmem
@@ -43,25 +44,13 @@
  *     mkdir /mnt/pmem0
  *     mount -o dax /dev/pmem0 /mnt/pmem0
  *
- * See examples/libpmem.fio for more.
- *
- *
- * libpmem.so
- *   By default, the libpmem engine will let the system find the libpmem.so
- *   that it uses. You can use an alternative libpmem by setting the
- *   FIO_PMEM_LIB environment variable to the full path to the desired
- *   libpmem.so. This engine requires PMDK >= 1.5.
+ * See examples/libpmem.fio for complete usage example.
  */
 
 #include <stdio.h>
-#include <limits.h>
 #include <stdlib.h>
 #include <unistd.h>
 #include <errno.h>
-#include <sys/mman.h>
-#include <sys/stat.h>
-#include <sys/sysmacros.h>
-#include <libgen.h>
 #include <libpmem.h>
 
 #include "../fio.h"
@@ -77,8 +66,8 @@ static int fio_libpmem_init(struct thread_data *td)
 {
 	struct thread_options *o = &td->o;
 
-	dprint(FD_IO,"o->rw_min_bs %llu \n o->fsync_blocks %u \n o->fdatasync_blocks %u \n",
-			o->rw_min_bs,o->fsync_blocks,o->fdatasync_blocks);
+	dprint(FD_IO, "o->rw_min_bs %llu\n o->fsync_blocks %u\n o->fdatasync_blocks %u\n",
+			o->rw_min_bs, o->fsync_blocks, o->fdatasync_blocks);
 	dprint(FD_IO, "DEBUG fio_libpmem_init\n");
 
 	if ((o->rw_min_bs & page_mask) &&
@@ -91,23 +80,17 @@ static int fio_libpmem_init(struct thread_data *td)
 }
 
 /*
- * This is the pmem_map_file execution function
+ * This is the pmem_map_file execution function, a helper to
+ * fio_libpmem_open_file function.
  */
 static int fio_libpmem_file(struct thread_data *td, struct fio_file *f,
 			    size_t length, off_t off)
 {
 	struct fio_libpmem_data *fdd = FILE_ENG_DATA(f);
-	mode_t mode = 0;
+	mode_t mode = S_IWUSR | S_IRUSR;
 	size_t mapped_len;
 	int is_pmem;
 
-	if(td_rw(td))
-		mode = S_IWUSR | S_IRUSR;
-	else if (td_write(td))
-		mode = S_IWUSR;
-	else
-		mode = S_IRUSR;
-
 	dprint(FD_IO, "DEBUG fio_libpmem_file\n");
 	dprint(FD_IO, "f->file_name = %s td->o.verify = %d \n", f->file_name,
 			td->o.verify);
@@ -142,11 +125,11 @@ static int fio_libpmem_open_file(struct thread_data *td, struct fio_file *f)
 {
 	struct fio_libpmem_data *fdd;
 
-	dprint(FD_IO,"DEBUG fio_libpmem_open_file\n");
-	dprint(FD_IO,"f->io_size=%ld \n",f->io_size);
-	dprint(FD_IO,"td->o.size=%lld \n",td->o.size);
-	dprint(FD_IO,"td->o.iodepth=%d\n",td->o.iodepth);
-	dprint(FD_IO,"td->o.iodepth_batch=%d \n",td->o.iodepth_batch);
+	dprint(FD_IO, "DEBUG fio_libpmem_open_file\n");
+	dprint(FD_IO, "f->io_size=%ld\n", f->io_size);
+	dprint(FD_IO, "td->o.size=%lld\n", td->o.size);
+	dprint(FD_IO, "td->o.iodepth=%d\n", td->o.iodepth);
+	dprint(FD_IO, "td->o.iodepth_batch=%d\n", td->o.iodepth_batch);
 
 	if (fio_file_open(f))
 		td_io_close_file(td, f);
@@ -167,8 +150,8 @@ static int fio_libpmem_prep(struct thread_data *td, struct io_u *io_u)
 	struct fio_file *f = io_u->file;
 	struct fio_libpmem_data *fdd = FILE_ENG_DATA(f);
 
-	dprint(FD_IO, "DEBUG fio_libpmem_prep\n" );
-	dprint(FD_IO," io_u->offset %llu : fdd->libpmem_off %ld : "
+	dprint(FD_IO, "DEBUG fio_libpmem_prep\n");
+	dprint(FD_IO, "io_u->offset %llu : fdd->libpmem_off %ld : "
 			"io_u->buflen %llu : fdd->libpmem_sz %ld\n",
 			io_u->offset, fdd->libpmem_off,
 			io_u->buflen, fdd->libpmem_sz);
@@ -192,8 +175,9 @@ static enum fio_q_status fio_libpmem_queue(struct thread_data *td,
 	io_u->error = 0;
 
 	dprint(FD_IO, "DEBUG fio_libpmem_queue\n");
-	dprint(FD_IO,"td->o.odirect %d td->o.sync_io %d \n",td->o.odirect, td->o.sync_io);
-	/* map both O_SYNC / DSYNC to not using NODRAIN */
+	dprint(FD_IO, "td->o.odirect %d td->o.sync_io %d\n",
+			td->o.odirect, td->o.sync_io);
+	/* map both O_SYNC / DSYNC to not use NODRAIN */
 	flags = td->o.sync_io ? 0 : PMEM_F_MEM_NODRAIN;
 	flags |= td->o.odirect ? PMEM_F_MEM_NONTEMPORAL : PMEM_F_MEM_TEMPORAL;
 
@@ -203,7 +187,7 @@ static enum fio_q_status fio_libpmem_queue(struct thread_data *td,
 		break;
 	case DDIR_WRITE:
 		dprint(FD_IO, "DEBUG mmap_data=%p, xfer_buf=%p\n",
-				io_u->mmap_data, io_u->xfer_buf );
+				io_u->mmap_data, io_u->xfer_buf);
 		pmem_memcpy(io_u->mmap_data,
 					io_u->xfer_buf,
 					io_u->xfer_buflen,
@@ -227,13 +211,7 @@ static int fio_libpmem_close_file(struct thread_data *td, struct fio_file *f)
 	struct fio_libpmem_data *fdd = FILE_ENG_DATA(f);
 	int ret = 0;
 
-	dprint(FD_IO,"DEBUG fio_libpmem_close_file\n");
-	dprint(FD_IO,"td->o.odirect %d \n",td->o.odirect);
-
-	if (!td->o.odirect) {
-		dprint(FD_IO,"pmem_drain\n");
-		pmem_drain();
-	}
+	dprint(FD_IO, "DEBUG fio_libpmem_close_file\n");
 
 	if (fdd->libpmem_ptr)
 		ret = pmem_unmap(fdd->libpmem_ptr, fdd->libpmem_sz);
diff --git a/examples/libpmem.fio b/examples/libpmem.fio
index 0ff681f0..3b854a32 100644
--- a/examples/libpmem.fio
+++ b/examples/libpmem.fio
@@ -1,6 +1,6 @@
 [global]
 bs=4k
-size=8g
+size=10g
 ioengine=libpmem
 norandommap
 time_based
@@ -17,16 +17,6 @@ thread
 numjobs=1
 runtime=300
 
-#
-# In case of 'scramble_buffers=1', the source buffer
-# is rewritten with a random value every write operations.
-#
-# But when 'scramble_buffers=0' is set, the source buffer isn't
-# rewritten. So it will be likely that the source buffer is in CPU
-# cache and it seems to be high performance.
-#
-scramble_buffers=0
-
 #
 # depends on direct option, flags are set for pmem_memcpy() call:
 # direct=1 - PMEM_F_MEM_NONTEMPORAL,
@@ -39,9 +29,19 @@ direct=1
 #
 sync=1
 
+#
+# In case of 'scramble_buffers=1', the source buffer
+# is rewritten with a random value every write operation.
+#
+# But when 'scramble_buffers=0' is set, the source buffer isn't
+# rewritten. So it will be likely that the source buffer is in CPU
+# cache and it seems to be high write performance.
+#
+scramble_buffers=1
 
 #
-# Setting for fio process's CPU Node and Memory Node
+# Setting for fio process's CPU Node and Memory Node.
+# Set proper node below or use `numactl` command along with FIO.
 #
 numa_cpu_nodes=0
 numa_mem_policy=bind:0
@@ -53,21 +53,22 @@ cpus_allowed_policy=split
 
 #
 # The libpmem engine does IO to files in a DAX-mounted filesystem.
-# The filesystem should be created on an NVDIMM (e.g /dev/pmem0)
+# The filesystem should be created on a Non-Volatile DIMM (e.g /dev/pmem0)
 # and then mounted with the '-o dax' option.  Note that the engine
 # accesses the underlying NVDIMM directly, bypassing the kernel block
 # layer, so the usual filesystem/disk performance monitoring tools such
 # as iostat will not provide useful data.
 #
-directory=/mnt/pmem0
+#filename=/mnt/pmem/somefile
+directory=/mnt/pmem
 
 [libpmem-seqwrite]
 rw=write
 stonewall
 
-#[libpmem-seqread]
-#rw=read
-#stonewall
+[libpmem-seqread]
+rw=read
+stonewall
 
 #[libpmem-randwrite]
 #rw=randwrite
diff --git a/fio.1 b/fio.1
index ab08cb01..5aa54a4d 100644
--- a/fio.1
+++ b/fio.1
@@ -835,6 +835,11 @@ threads/processes.
 .BI job_max_open_zones \fR=\fPint
 Limit on the number of simultaneously opened zones per single thread/process.
 .TP
+.BI ignore_zone_limits \fR=\fPbool
+If this isn't set, fio will query the max open zones limit from the zoned block
+device, and exit if the specified \fBmax_open_zones\fR value is larger than the
+limit reported by the device. Default: false.
+.TP
 .BI zone_reset_threshold \fR=\fPfloat
 A number between zero and one that indicates the ratio of logical blocks with
 data to the total number of logical blocks in the test above which zones
diff --git a/options.c b/options.c
index b82a10aa..a8986d11 100644
--- a/options.c
+++ b/options.c
@@ -3492,6 +3492,16 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_INVALID,
 	},
+	{
+		.name	= "ignore_zone_limits",
+		.lname	= "Ignore zone resource limits",
+		.type	= FIO_OPT_BOOL,
+		.off1	= offsetof(struct thread_options, ignore_zone_limits),
+		.def	= "0",
+		.help	= "Ignore the zone resource limits (max open/active zones) reported by the device",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_INVALID,
+	},
 	{
 		.name	= "zone_reset_threshold",
 		.lname	= "Zone reset threshold",
diff --git a/server.h b/server.h
index b45b319b..c128df28 100644
--- a/server.h
+++ b/server.h
@@ -48,7 +48,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 89,
+	FIO_SERVER_VER			= 91,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index 5ecc72d7..05c2d138 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -355,6 +355,7 @@ struct thread_options {
 	unsigned int read_beyond_wp;
 	int max_open_zones;
 	unsigned int job_max_open_zones;
+	unsigned int ignore_zone_limits;
 	fio_fp64_t zrt;
 	fio_fp64_t zrf;
 };
@@ -656,6 +657,8 @@ struct thread_options_pack {
 	uint32_t allow_mounted_write;
 
 	uint32_t zone_mode;
+	int32_t max_open_zones;
+	uint32_t ignore_zone_limits;
 } __attribute__((packed));
 
 extern void convert_thread_options_to_cpu(struct thread_options *o, struct thread_options_pack *top);
diff --git a/zbd.c b/zbd.c
index 68cd58e1..5d9e331a 100644
--- a/zbd.c
+++ b/zbd.c
@@ -588,7 +588,7 @@ static int zbd_set_max_open_zones(struct thread_data *td, struct fio_file *f)
 	unsigned int max_open_zones;
 	int ret;
 
-	if (zbd->model != ZBD_HOST_MANAGED) {
+	if (zbd->model != ZBD_HOST_MANAGED || td->o.ignore_zone_limits) {
 		/* Only host-managed devices have a max open limit */
 		zbd->max_open_zones = td->o.max_open_zones;
 		goto out;

