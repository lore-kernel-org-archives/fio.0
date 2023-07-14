Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCCF8EB64DA
	for <fio@archiver.kernel.org>; Fri, 14 Jul 2023 12:00:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234066AbjGNMAL (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 14 Jul 2023 08:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbjGNMAL (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 14 Jul 2023 08:00:11 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12AF9211C
        for <fio@vger.kernel.org>; Fri, 14 Jul 2023 05:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=YRfgMOOmAGdMxXWekB19KAyfXcXjf2tFdXcR2UbIcr0=; b=q8vIgfBxkRmlYOK+USbAAyzosy
        gBvTPXm+bVy3P8zQQx8CyRRWrNsL8f8lKCO9IV4ZYsSmgxOjh1nO3HdYliFPLXa+A3uTlx5lFsObt
        Sv9ymm8txYjZjDWoUywfm5MU6DxZwisF6ZHdO788cdzyxcNT0yTQcadycqXuWOELT9iIDa0wkPFJb
        hIE9WUIsBU/vrFhi9DZWwJ74MkddhaBkjd7Ec6LVYznE5ncyh9drKEx56qadhslQiKR8CtS81Ungj
        WO/vVHOZNlvEIA7FxE6cuYnVyNLFC2ZcHkk/BXxfnDrCvimC3kvIvK6jJKhbeeUD5lZfwUNIy8yJB
        5sc67Yyg==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qKHSv-006HSS-2G
        for fio@vger.kernel.org;
        Fri, 14 Jul 2023 12:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 25D511BC0165; Fri, 14 Jul 2023 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230714120002.25D511BC0165@kernel.dk>
Date:   Fri, 14 Jul 2023 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 8e2b81b854286f32eae7951a434dddebd968f9d5:

  zbd: Support finishing zones on Android (2023-07-05 15:48:11 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 270316dd2566346a12cfdf3cbe9996a88307f87d:

  Merge branch 'master' of https://github.com/bvanassche/fio (2023-07-13 15:28:20 -0600)

----------------------------------------------------------------
Ankit Kumar (4):
      fdp: use macros
      fdp: fix placement id check
      fdp: support random placement id selection
      engines/xnvme: add support for fdp

Bart Van Assche (5):
      diskutil: Improve disk utilization data structure documentation
      diskutil: Remove casts from get_io_ticks()
      diskutil: Simplify get_io_ticks()
      diskutil: Fix a debug statement in get_io_ticks()
      diskutil: Report how many sectors have been read and written

Jens Axboe (1):
      Merge branch 'master' of https://github.com/bvanassche/fio

Vincent Fu (1):
      options: add code for FDP pli selection use in client/server mode

 HOWTO.rst              | 23 +++++++++++++--
 cconv.c                |  2 ++
 configure              |  2 +-
 diskutil.c             | 29 +++++++------------
 diskutil.h             | 12 +++++++-
 engines/io_uring.c     |  2 +-
 engines/xnvme.c        | 78 +++++++++++++++++++++++++++++++++++++++++++++++++-
 examples/xnvme-fdp.fio | 36 +++++++++++++++++++++++
 fdp.c                  | 22 ++++++++------
 fdp.h                  | 13 +++++++++
 fio.1                  | 22 ++++++++++++--
 fio.h                  |  2 ++
 init.c                 |  2 ++
 options.c              | 20 +++++++++++++
 stat.c                 |  7 +++--
 thread_options.h       |  2 ++
 16 files changed, 236 insertions(+), 38 deletions(-)
 create mode 100644 examples/xnvme-fdp.fio

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 2e1e55c2..7ae8ea7b 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2431,11 +2431,26 @@ with the caveat that when used on the command line, they must come after the
 	For direct I/O, requests will only succeed if cache invalidation isn't required,
 	file blocks are fully allocated and the disk request could be issued immediately.
 
-.. option:: fdp=bool : [io_uring_cmd]
+.. option:: fdp=bool : [io_uring_cmd] [xnvme]
 
 	Enable Flexible Data Placement mode for write commands.
 
-.. option:: fdp_pli=str : [io_uring_cmd]
+.. option:: fdp_pli_select=str : [io_uring_cmd] [xnvme]
+
+	Defines how fio decides which placement ID to use next. The following
+	types are defined:
+
+		**random**
+			Choose a placement ID at random (uniform).
+
+		**roundrobin**
+			Round robin over available placement IDs. This is the
+			default.
+
+	The available placement ID index/indices is defined by the option
+	:option:`fdp_pli`.
+
+.. option:: fdp_pli=str : [io_uring_cmd] [xnvme]
 
 	Select which Placement ID Index/Indicies this job is allowed to use for
 	writes. By default, the job will cycle through all available Placement
@@ -4513,13 +4528,15 @@ For each data direction it prints:
 And finally, the disk statistics are printed. This is Linux specific. They will look like this::
 
   Disk stats (read/write):
-    sda: ios=16398/16511, merge=30/162, ticks=6853/819634, in_queue=826487, util=100.00%
+    sda: ios=16398/16511, sectors=32321/65472, merge=30/162, ticks=6853/819634, in_queue=826487, util=100.00%
 
 Each value is printed for both reads and writes, with reads first. The
 numbers denote:
 
 **ios**
 		Number of I/Os performed by all groups.
+**sectors**
+		Amount of data transferred in units of 512 bytes for all groups.
 **merge**
 		Number of merges performed by the I/O scheduler.
 **ticks**
diff --git a/cconv.c b/cconv.c
index 9095d519..1bfa770f 100644
--- a/cconv.c
+++ b/cconv.c
@@ -351,6 +351,7 @@ int convert_thread_options_to_cpu(struct thread_options *o,
 		o->merge_blktrace_iters[i].u.f = fio_uint64_to_double(le64_to_cpu(top->merge_blktrace_iters[i].u.i));
 
 	o->fdp = le32_to_cpu(top->fdp);
+	o->fdp_pli_select = le32_to_cpu(top->fdp_pli_select);
 	o->fdp_nrpli = le32_to_cpu(top->fdp_nrpli);
 	for (i = 0; i < o->fdp_nrpli; i++)
 		o->fdp_plis[i] = le32_to_cpu(top->fdp_plis[i]);
@@ -645,6 +646,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 		top->merge_blktrace_iters[i].u.i = __cpu_to_le64(fio_double_to_uint64(o->merge_blktrace_iters[i].u.f));
 
 	top->fdp = cpu_to_le32(o->fdp);
+	top->fdp_pli_select = cpu_to_le32(o->fdp_pli_select);
 	top->fdp_nrpli = cpu_to_le32(o->fdp_nrpli);
 	for (i = 0; i < o->fdp_nrpli; i++)
 		top->fdp_plis[i] = cpu_to_le32(o->fdp_plis[i]);
diff --git a/configure b/configure
index 74416fd4..6c938251 100755
--- a/configure
+++ b/configure
@@ -2651,7 +2651,7 @@ fi
 ##########################################
 # Check if we have xnvme
 if test "$xnvme" != "no" ; then
-  if check_min_lib_version xnvme 0.2.0; then
+  if check_min_lib_version xnvme 0.7.0; then
     xnvme="yes"
     xnvme_cflags=$(pkg-config --cflags xnvme)
     xnvme_libs=$(pkg-config --libs xnvme)
diff --git a/diskutil.c b/diskutil.c
index ace7af3d..cf4ede85 100644
--- a/diskutil.c
+++ b/diskutil.c
@@ -1,3 +1,4 @@
+#include <inttypes.h>
 #include <stdio.h>
 #include <string.h>
 #include <sys/types.h>
@@ -44,8 +45,6 @@ static void disk_util_free(struct disk_util *du)
 
 static int get_io_ticks(struct disk_util *du, struct disk_util_stat *dus)
 {
-	unsigned in_flight;
-	unsigned long long sectors[2];
 	char line[256];
 	FILE *f;
 	char *p;
@@ -65,23 +64,17 @@ static int get_io_ticks(struct disk_util *du, struct disk_util_stat *dus)
 
 	dprint(FD_DISKUTIL, "%s: %s", du->path, p);
 
-	ret = sscanf(p, "%llu %llu %llu %llu %llu %llu %llu %llu %u %llu %llu\n",
-				(unsigned long long *) &dus->s.ios[0],
-				(unsigned long long *) &dus->s.merges[0],
-				&sectors[0],
-				(unsigned long long *) &dus->s.ticks[0],
-				(unsigned long long *) &dus->s.ios[1],
-				(unsigned long long *) &dus->s.merges[1],
-				&sectors[1],
-				(unsigned long long *) &dus->s.ticks[1],
-				&in_flight,
-				(unsigned long long *) &dus->s.io_ticks,
-				(unsigned long long *) &dus->s.time_in_queue);
+	ret = sscanf(p, "%"SCNu64" %"SCNu64" %"SCNu64" %"SCNu64" "
+		     "%"SCNu64" %"SCNu64" %"SCNu64" %"SCNu64" "
+		     "%*u %"SCNu64" %"SCNu64"\n",
+		     &dus->s.ios[0], &dus->s.merges[0], &dus->s.sectors[0],
+		     &dus->s.ticks[0],
+		     &dus->s.ios[1], &dus->s.merges[1], &dus->s.sectors[1],
+		     &dus->s.ticks[1],
+		     &dus->s.io_ticks, &dus->s.time_in_queue);
 	fclose(f);
-	dprint(FD_DISKUTIL, "%s: stat read ok? %d\n", du->path, ret == 1);
-	dus->s.sectors[0] = sectors[0];
-	dus->s.sectors[1] = sectors[1];
-	return ret != 11;
+	dprint(FD_DISKUTIL, "%s: stat read ok? %d\n", du->path, ret == 10);
+	return ret != 10;
 }
 
 static void update_io_tick_disk(struct disk_util *du)
diff --git a/diskutil.h b/diskutil.h
index 7d7ef802..9dca42c4 100644
--- a/diskutil.h
+++ b/diskutil.h
@@ -7,6 +7,16 @@
 #include "helper_thread.h"
 #include "fio_sem.h"
 
+/**
+ * @ios: Number of I/O operations that have been completed successfully.
+ * @merges: Number of I/O operations that have been merged.
+ * @sectors: I/O size in 512-byte units.
+ * @ticks: Time spent on I/O in milliseconds.
+ * @io_ticks: CPU time spent on I/O in milliseconds.
+ * @time_in_queue: Weighted time spent doing I/O in milliseconds.
+ *
+ * For the array members, index 0 refers to reads and index 1 refers to writes.
+ */
 struct disk_util_stats {
 	uint64_t ios[2];
 	uint64_t merges[2];
@@ -18,7 +28,7 @@ struct disk_util_stats {
 };
 
 /*
- * Disk utils as read in /sys/block/<dev>/stat
+ * Disk utilization as read from /sys/block/<dev>/stat
  */
 struct disk_util_stat {
 	uint8_t name[FIO_DU_NAME_SZ];
diff --git a/engines/io_uring.c b/engines/io_uring.c
index 5021239e..407d65ce 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -1310,7 +1310,7 @@ static int fio_ioring_cmd_fetch_ruhs(struct thread_data *td, struct fio_file *f,
 	struct nvme_fdp_ruh_status *ruhs;
 	int bytes, ret, i;
 
-	bytes = sizeof(*ruhs) + 128 * sizeof(struct nvme_fdp_ruh_status_desc);
+	bytes = sizeof(*ruhs) + FDP_MAX_RUHS * sizeof(struct nvme_fdp_ruh_status_desc);
 	ruhs = scalloc(1, bytes);
 	if (!ruhs)
 		return -ENOMEM;
diff --git a/engines/xnvme.c b/engines/xnvme.c
index bb92a121..ce7b2bdd 100644
--- a/engines/xnvme.c
+++ b/engines/xnvme.c
@@ -16,6 +16,7 @@
 #include <libxnvme_spec_fs.h>
 #include "fio.h"
 #include "zbd_types.h"
+#include "fdp.h"
 #include "optgroup.h"
 
 static pthread_mutex_t g_serialize = PTHREAD_MUTEX_INITIALIZER;
@@ -509,6 +510,7 @@ static enum fio_q_status xnvme_fioe_queue(struct thread_data *td, struct io_u *i
 	uint16_t nlb;
 	int err;
 	bool vectored_io = ((struct xnvme_fioe_options *)td->eo)->xnvme_iovec;
+	uint32_t dir = io_u->dtype;
 
 	fio_ro_check(td, io_u);
 
@@ -524,6 +526,10 @@ static enum fio_q_status xnvme_fioe_queue(struct thread_data *td, struct io_u *i
 	ctx->cmd.common.nsid = nsid;
 	ctx->cmd.nvm.slba = slba;
 	ctx->cmd.nvm.nlb = nlb;
+	if (dir) {
+		ctx->cmd.nvm.dtype = io_u->dtype;
+		ctx->cmd.nvm.cdw13.dspec = io_u->dspec;
+	}
 
 	switch (io_u->ddir) {
 	case DDIR_READ:
@@ -947,6 +953,72 @@ exit:
 	return err;
 }
 
+static int xnvme_fioe_fetch_ruhs(struct thread_data *td, struct fio_file *f,
+				 struct fio_ruhs_info *fruhs_info)
+{
+	struct xnvme_opts opts = xnvme_opts_from_fioe(td);
+	struct xnvme_dev *dev;
+	struct xnvme_spec_ruhs *ruhs;
+	struct xnvme_cmd_ctx ctx;
+	uint32_t ruhs_nbytes;
+	uint32_t nsid;
+	int err = 0, err_lock;
+
+	if (f->filetype != FIO_TYPE_CHAR) {
+		log_err("ioeng->fdp_ruhs(): ignoring filetype: %d\n", f->filetype);
+		return -EINVAL;
+	}
+
+	err = pthread_mutex_lock(&g_serialize);
+	if (err) {
+		log_err("ioeng->fdp_ruhs(): pthread_mutex_lock(), err(%d)\n", err);
+		return -err;
+	}
+
+	dev = xnvme_dev_open(f->file_name, &opts);
+	if (!dev) {
+		log_err("ioeng->fdp_ruhs(): xnvme_dev_open(%s) failed, errno: %d\n",
+			f->file_name, errno);
+		err = -errno;
+		goto exit;
+	}
+
+	ruhs_nbytes = sizeof(*ruhs) + (FDP_MAX_RUHS * sizeof(struct xnvme_spec_ruhs_desc));
+	ruhs = xnvme_buf_alloc(dev, ruhs_nbytes);
+	if (!ruhs) {
+		err = -errno;
+		goto exit;
+	}
+	memset(ruhs, 0, ruhs_nbytes);
+
+	ctx = xnvme_cmd_ctx_from_dev(dev);
+	nsid = xnvme_dev_get_nsid(dev);
+
+	err = xnvme_nvm_mgmt_recv(&ctx, nsid, XNVME_SPEC_IO_MGMT_RECV_RUHS, 0, ruhs, ruhs_nbytes);
+
+	if (err || xnvme_cmd_ctx_cpl_status(&ctx)) {
+		err = err ? err : -EIO;
+		log_err("ioeng->fdp_ruhs(): err(%d), sc(%d)", err, ctx.cpl.status.sc);
+		goto free_buffer;
+	}
+
+	fruhs_info->nr_ruhs = ruhs->nruhsd;
+	for (uint32_t idx = 0; idx < fruhs_info->nr_ruhs; ++idx) {
+		fruhs_info->plis[idx] = le16_to_cpu(ruhs->desc[idx].pi);
+	}
+
+free_buffer:
+	xnvme_buf_free(dev, ruhs);
+exit:
+	xnvme_dev_close(dev);
+
+	err_lock = pthread_mutex_unlock(&g_serialize);
+	if (err_lock)
+		log_err("ioeng->fdp_ruhs(): pthread_mutex_unlock(), err(%d)\n", err_lock);
+
+	return err;
+}
+
 static int xnvme_fioe_get_file_size(struct thread_data *td, struct fio_file *f)
 {
 	struct xnvme_opts opts = xnvme_opts_from_fioe(td);
@@ -971,7 +1043,9 @@ static int xnvme_fioe_get_file_size(struct thread_data *td, struct fio_file *f)
 
 	f->real_file_size = xnvme_dev_get_geo(dev)->tbytes;
 	fio_file_set_size_known(f);
-	f->filetype = FIO_TYPE_BLOCK;
+
+	if (td->o.zone_mode == ZONE_MODE_ZBD)
+		f->filetype = FIO_TYPE_BLOCK;
 
 exit:
 	xnvme_dev_close(dev);
@@ -1011,6 +1085,8 @@ FIO_STATIC struct ioengine_ops ioengine = {
 	.get_zoned_model = xnvme_fioe_get_zoned_model,
 	.report_zones = xnvme_fioe_report_zones,
 	.reset_wp = xnvme_fioe_reset_wp,
+
+	.fdp_fetch_ruhs = xnvme_fioe_fetch_ruhs,
 };
 
 static void fio_init fio_xnvme_register(void)
diff --git a/examples/xnvme-fdp.fio b/examples/xnvme-fdp.fio
new file mode 100644
index 00000000..86fbe0d3
--- /dev/null
+++ b/examples/xnvme-fdp.fio
@@ -0,0 +1,36 @@
+; README
+;
+; This job-file is intended to be used either as:
+;
+; # Use the xNVMe io-engine engine io_uring_cmd async. impl.
+; fio examples/xnvme-fdp.fio \
+;   --section=default \
+;   --ioengine=xnvme \
+;   --xnvme_async=io_uring_cmd \
+;   --filename=/dev/ng0n1
+;
+; # Use the xNVMe io-engine engine with nvme sync. impl.
+; fio examples/xnvme-fdp.fio \
+;   --section=default \
+;   --ioengine=xnvme \
+;   --xnvme_sync=nvme \
+;   --filename=/dev/ng0n1
+;
+; FIO_BS="512" FIO_RW="read" FIO_IODEPTH=16 fio examples/xnvme-fdp.fio \
+;   --section=override --ioengine=xnvme --xnvme_sync=nvme --filename=/dev/ng0n1
+;
+[global]
+rw=randwrite
+size=2M
+iodepth=1
+bs=4K
+thread=1
+fdp=1
+fdp_pli=4,5
+
+[default]
+
+[override]
+rw=${FIO_RW}
+iodepth=${FIO_IODEPTH}
+bs=${FIO_BS}
diff --git a/fdp.c b/fdp.c
index d92dbc67..49c80d2c 100644
--- a/fdp.c
+++ b/fdp.c
@@ -45,7 +45,7 @@ static int init_ruh_info(struct thread_data *td, struct fio_file *f)
 	struct fio_ruhs_info *ruhs, *tmp;
 	int i, ret;
 
-	ruhs = scalloc(1, sizeof(*ruhs) + 128 * sizeof(*ruhs->plis));
+	ruhs = scalloc(1, sizeof(*ruhs) + FDP_MAX_RUHS * sizeof(*ruhs->plis));
 	if (!ruhs)
 		return -ENOMEM;
 
@@ -56,8 +56,8 @@ static int init_ruh_info(struct thread_data *td, struct fio_file *f)
 		goto out;
 	}
 
-	if (ruhs->nr_ruhs > 128)
-		ruhs->nr_ruhs = 128;
+	if (ruhs->nr_ruhs > FDP_MAX_RUHS)
+		ruhs->nr_ruhs = FDP_MAX_RUHS;
 
 	if (td->o.fdp_nrpli == 0) {
 		f->ruhs_info = ruhs;
@@ -65,7 +65,7 @@ static int init_ruh_info(struct thread_data *td, struct fio_file *f)
 	}
 
 	for (i = 0; i < td->o.fdp_nrpli; i++) {
-		if (td->o.fdp_plis[i] > ruhs->nr_ruhs) {
+		if (td->o.fdp_plis[i] >= ruhs->nr_ruhs) {
 			ret = -EINVAL;
 			goto out;
 		}
@@ -119,10 +119,16 @@ void fdp_fill_dspec_data(struct thread_data *td, struct io_u *io_u)
 		return;
 	}
 
-	if (ruhs->pli_loc >= ruhs->nr_ruhs)
-		ruhs->pli_loc = 0;
+	if (td->o.fdp_pli_select == FIO_FDP_RR) {
+		if (ruhs->pli_loc >= ruhs->nr_ruhs)
+			ruhs->pli_loc = 0;
 
-	dspec = ruhs->plis[ruhs->pli_loc++];
-	io_u->dtype = 2;
+		dspec = ruhs->plis[ruhs->pli_loc++];
+	} else {
+		ruhs->pli_loc = rand_between(&td->fdp_state, 0, ruhs->nr_ruhs - 1);
+		dspec = ruhs->plis[ruhs->pli_loc];
+	}
+
+	io_u->dtype = FDP_DIR_DTYPE;
 	io_u->dspec = dspec;
 }
diff --git a/fdp.h b/fdp.h
index 81691f62..accbac38 100644
--- a/fdp.h
+++ b/fdp.h
@@ -3,6 +3,19 @@
 
 #include "io_u.h"
 
+#define FDP_DIR_DTYPE	2
+#define FDP_MAX_RUHS	128
+
+/*
+ * How fio chooses what placement identifier to use next. Choice of
+ * uniformly random, or roundrobin.
+ */
+
+enum {
+	FIO_FDP_RANDOM	= 0x1,
+	FIO_FDP_RR	= 0x2,
+};
+
 struct fio_ruhs_info {
 	uint32_t nr_ruhs;
 	uint32_t pli_loc;
diff --git a/fio.1 b/fio.1
index 73b7e8c9..da875276 100644
--- a/fio.1
+++ b/fio.1
@@ -2192,10 +2192,26 @@ cached data. Currently the RWF_NOWAIT flag does not supported for cached write.
 For direct I/O, requests will only succeed if cache invalidation isn't required,
 file blocks are fully allocated and the disk request could be issued immediately.
 .TP
-.BI (io_uring_cmd)fdp \fR=\fPbool
+.BI (io_uring_cmd,xnvme)fdp \fR=\fPbool
 Enable Flexible Data Placement mode for write commands.
 .TP
-.BI (io_uring_cmd)fdp_pli \fR=\fPstr
+.BI (io_uring_cmd,xnvme)fdp_pli_select \fR=\fPstr
+Defines how fio decides which placement ID to use next. The following types
+are defined:
+.RS
+.RS
+.TP
+.B random
+Choose a placement ID at random (uniform).
+.TP
+.B roundrobin
+Round robin over available placement IDs. This is the default.
+.RE
+.P
+The available placement ID index/indices is defined by \fBfdp_pli\fR option.
+.RE
+.TP
+.BI (io_uring_cmd,xnvme)fdp_pli \fR=\fPstr
 Select which Placement ID Index/Indicies this job is allowed to use for writes.
 By default, the job will cycle through all available Placement IDs, so use this
 to isolate these identifiers to specific jobs. If you want fio to use placement
@@ -4168,7 +4184,7 @@ They will look like this:
 .P
 .nf
 		  Disk stats (read/write):
-		    sda: ios=16398/16511, merge=30/162, ticks=6853/819634, in_queue=826487, util=100.00%
+		    sda: ios=16398/16511, sectors=32321/65472, merge=30/162, ticks=6853/819634, in_queue=826487, util=100.00%
 .fi
 .P
 Each value is printed for both reads and writes, with reads first. The
diff --git a/fio.h b/fio.h
index c5453d13..a54f57c9 100644
--- a/fio.h
+++ b/fio.h
@@ -144,6 +144,7 @@ enum {
 	FIO_RAND_POISSON3_OFF,
 	FIO_RAND_PRIO_CMDS,
 	FIO_RAND_DEDUPE_WORKING_SET_IX,
+	FIO_RAND_FDP_OFF,
 	FIO_RAND_NR_OFFS,
 };
 
@@ -262,6 +263,7 @@ struct thread_data {
 	struct frand_state verify_state_last_do_io;
 	struct frand_state trim_state;
 	struct frand_state delay_state;
+	struct frand_state fdp_state;
 
 	struct frand_state buf_state;
 	struct frand_state buf_state_prev;
diff --git a/init.c b/init.c
index 10e63cca..105339fa 100644
--- a/init.c
+++ b/init.c
@@ -1082,6 +1082,8 @@ void td_fill_rand_seeds(struct thread_data *td)
 
 	init_rand_seed(&td->buf_state, td->rand_seeds[FIO_RAND_BUF_OFF], use64);
 	frand_copy(&td->buf_state_prev, &td->buf_state);
+
+	init_rand_seed(&td->fdp_state, td->rand_seeds[FIO_RAND_FDP_OFF], use64);
 }
 
 static int setup_random_seeds(struct thread_data *td)
diff --git a/options.c b/options.c
index a7c4ef6e..0f739317 100644
--- a/options.c
+++ b/options.c
@@ -3679,6 +3679,26 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group  = FIO_OPT_G_INVALID,
 	},
+	{
+		.name	= "fdp_pli_select",
+		.lname	= "FDP Placement ID select",
+		.type	= FIO_OPT_STR,
+		.off1	= offsetof(struct thread_options, fdp_pli_select),
+		.help	= "Select which FDP placement ID to use next",
+		.def	= "roundrobin",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_INVALID,
+		.posval	= {
+			  { .ival = "random",
+			    .oval = FIO_FDP_RANDOM,
+			    .help = "Choose a Placement ID at random (uniform)",
+			  },
+			  { .ival = "roundrobin",
+			    .oval = FIO_FDP_RR,
+			    .help = "Round robin select Placement IDs",
+			  },
+		},
+	},
 	{
 		.name	= "fdp_pli",
 		.lname	= "FDP Placement ID indicies",
diff --git a/stat.c b/stat.c
index 015b8e28..ced73645 100644
--- a/stat.c
+++ b/stat.c
@@ -1030,11 +1030,14 @@ void print_disk_util(struct disk_util_stat *dus, struct disk_util_agg *agg,
 		if (agg->slavecount)
 			log_buf(out, "  ");
 
-		log_buf(out, "  %s: ios=%llu/%llu, merge=%llu/%llu, "
-			 "ticks=%llu/%llu, in_queue=%llu, util=%3.2f%%",
+		log_buf(out, "  %s: ios=%llu/%llu, sectors=%llu/%llu, "
+			"merge=%llu/%llu, ticks=%llu/%llu, in_queue=%llu, "
+			"util=%3.2f%%",
 				dus->name,
 				(unsigned long long) dus->s.ios[0],
 				(unsigned long long) dus->s.ios[1],
+				(unsigned long long) dus->s.sectors[0],
+				(unsigned long long) dus->s.sectors[1],
 				(unsigned long long) dus->s.merges[0],
 				(unsigned long long) dus->s.merges[1],
 				(unsigned long long) dus->s.ticks[0],
diff --git a/thread_options.h b/thread_options.h
index a24ebee6..1715b36c 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -388,6 +388,7 @@ struct thread_options {
 
 #define FIO_MAX_PLIS 16
 	unsigned int fdp;
+	unsigned int fdp_pli_select;
 	unsigned int fdp_plis[FIO_MAX_PLIS];
 	unsigned int fdp_nrpli;
 
@@ -703,6 +704,7 @@ struct thread_options_pack {
 	uint32_t log_prio;
 
 	uint32_t fdp;
+	uint32_t fdp_pli_select;
 	uint32_t fdp_plis[FIO_MAX_PLIS];
 	uint32_t fdp_nrpli;
 
