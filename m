Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9874DEB64D9
	for <fio@archiver.kernel.org>; Thu,  6 Jul 2023 12:00:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbjGFMAP (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 6 Jul 2023 08:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232002AbjGFMAO (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 6 Jul 2023 08:00:14 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F4071723
        for <fio@vger.kernel.org>; Thu,  6 Jul 2023 05:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=++CJm3mwhtWCiGkfuXT0pbqeUN+1ESLX/uEzZHk8bVE=; b=RvAydAzCWM847aLohy/jOgCuZw
        WMbTWyhBe46h94V5HY8Ux2q+j/SRycyfBrf9jSxOQQQ0nhGsHF7ZrPARLkaYVdWSP6SICOpD1kNCZ
        H7/DCNto2M0eqNIEQTEhoiOUuaunha7OsBCbp8HJ6VWnpj7TlI3j0D94+W12ethDFQrD7CeKKSF+l
        L6aoA4d5tBNa0Ufg0g6I4E17dPQcgkimRoy6YFF+sjpV3L6H4vLHJKJeoT8FhyYsamqljUdilm82l
        KsNBrOoVotamRWq+eEku6Lhel8g7n0MyTf3O0RxbIZGOO2ZRNlHaoU30FQF864B6eQLFR9QwEuRkh
        q9AQZfjg==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qHNea-00DZjM-1o
        for fio@vger.kernel.org;
        Thu, 06 Jul 2023 12:00:08 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 3697F1BC0130; Thu,  6 Jul 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230706120001.3697F1BC0130@kernel.dk>
Date:   Thu,  6 Jul 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 41508de67c06661ff1d473d108a8a01912ade114:

  fio/server: fix confusing sk_out check (2023-07-03 09:16:45 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 8e2b81b854286f32eae7951a434dddebd968f9d5:

  zbd: Support finishing zones on Android (2023-07-05 15:48:11 -0600)

----------------------------------------------------------------
Bart Van Assche (1):
      zbd: Support finishing zones on Android

Jens Axboe (1):
      Merge branch 'makefile-hardening-cpp-flags' of https://github.com/proact-de/fio

Martin Steigerwald (1):
      Keep C pre processor hardening build flags.

Vincent Fu (4):
      engines/io_uring_cmd: make trims async
      engines/io_uring: remove dead code related to trim
      t/nvmept: add check for iodepth
      t/nvmept: add trim test with ioengine options enabled

 Makefile               |  2 +-
 engines/io_uring.c     | 49 ++++++++++----------------
 engines/nvme.c         | 96 ++++++++++++++++++++++++--------------------------
 engines/nvme.h         |  5 +--
 oslib/linux-blkzoned.c | 24 ++++++-------
 t/nvmept.py            | 21 +++++++++++
 6 files changed, 100 insertions(+), 97 deletions(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 6d7fd4e2..cc8164b2 100644
--- a/Makefile
+++ b/Makefile
@@ -20,7 +20,7 @@ include config-host.mak
 endif
 
 DEBUGFLAGS = -DFIO_INC_DEBUG
-CPPFLAGS= -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DFIO_INTERNAL $(DEBUGFLAGS)
+CPPFLAGS+= -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DFIO_INTERNAL $(DEBUGFLAGS)
 OPTFLAGS= -g -ffast-math
 FIO_CFLAGS= -std=gnu99 -Wwrite-strings -Wall -Wdeclaration-after-statement $(OPTFLAGS) $(EXTFLAGS) $(BUILD_CFLAGS) -I. -I$(SRCDIR)
 LIBS	+= -lm $(EXTLIBS)
diff --git a/engines/io_uring.c b/engines/io_uring.c
index 73e4a27a..5021239e 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -78,6 +78,8 @@ struct ioring_data {
 	struct ioring_mmap mmap[3];
 
 	struct cmdprio cmdprio;
+
+	struct nvme_dsm_range *dsm;
 };
 
 struct ioring_options {
@@ -410,7 +412,7 @@ static int fio_ioring_cmd_prep(struct thread_data *td, struct io_u *io_u)
 	if (o->cmd_type != FIO_URING_CMD_NVME)
 		return -EINVAL;
 
-	if (io_u->ddir == DDIR_TRIM)
+	if (io_u->ddir == DDIR_TRIM && td->io_ops->flags & FIO_ASYNCIO_SYNC_TRIM)
 		return 0;
 
 	sqe = &ld->sqes[(io_u->index) << 1];
@@ -444,7 +446,8 @@ static int fio_ioring_cmd_prep(struct thread_data *td, struct io_u *io_u)
 
 	cmd = (struct nvme_uring_cmd *)sqe->cmd;
 	return fio_nvme_uring_cmd_prep(cmd, io_u,
-			o->nonvectored ? NULL : &ld->iovecs[io_u->index]);
+			o->nonvectored ? NULL : &ld->iovecs[io_u->index],
+			&ld->dsm[io_u->index]);
 }
 
 static struct io_u *fio_ioring_event(struct thread_data *td, int event)
@@ -561,27 +564,6 @@ static inline void fio_ioring_cmdprio_prep(struct thread_data *td,
 		ld->sqes[io_u->index].ioprio = io_u->ioprio;
 }
 
-static int fio_ioring_cmd_io_u_trim(struct thread_data *td,
-				    struct io_u *io_u)
-{
-	struct fio_file *f = io_u->file;
-	int ret;
-
-	if (td->o.zone_mode == ZONE_MODE_ZBD) {
-		ret = zbd_do_io_u_trim(td, io_u);
-		if (ret == io_u_completed)
-			return io_u->xfer_buflen;
-		if (ret)
-			goto err;
-	}
-
-	return fio_nvme_trim(td, f, io_u->offset, io_u->xfer_buflen);
-
-err:
-	io_u->error = ret;
-	return 0;
-}
-
 static enum fio_q_status fio_ioring_queue(struct thread_data *td,
 					  struct io_u *io_u)
 {
@@ -594,14 +576,11 @@ static enum fio_q_status fio_ioring_queue(struct thread_data *td,
 	if (ld->queued == ld->iodepth)
 		return FIO_Q_BUSY;
 
-	if (io_u->ddir == DDIR_TRIM) {
+	if (io_u->ddir == DDIR_TRIM && td->io_ops->flags & FIO_ASYNCIO_SYNC_TRIM) {
 		if (ld->queued)
 			return FIO_Q_BUSY;
 
-		if (!strcmp(td->io_ops->name, "io_uring_cmd"))
-			fio_ioring_cmd_io_u_trim(td, io_u);
-		else
-			do_io_u_trim(td, io_u);
+		do_io_u_trim(td, io_u);
 
 		io_u_mark_submit(td, 1);
 		io_u_mark_complete(td, 1);
@@ -734,6 +713,7 @@ static void fio_ioring_cleanup(struct thread_data *td)
 		free(ld->io_u_index);
 		free(ld->iovecs);
 		free(ld->fds);
+		free(ld->dsm);
 		free(ld);
 	}
 }
@@ -1146,6 +1126,16 @@ static int fio_ioring_init(struct thread_data *td)
 		return 1;
 	}
 
+	/*
+	 * For io_uring_cmd, trims are async operations unless we are operating
+	 * in zbd mode where trim means zone reset.
+	 */
+	if (!strcmp(td->io_ops->name, "io_uring_cmd") && td_trim(td) &&
+	    td->o.zone_mode == ZONE_MODE_ZBD)
+		td->io_ops->flags |= FIO_ASYNCIO_SYNC_TRIM;
+	else
+		ld->dsm = calloc(ld->iodepth, sizeof(*ld->dsm));
+
 	return 0;
 }
 
@@ -1361,8 +1351,7 @@ static struct ioengine_ops ioengine_uring = {
 static struct ioengine_ops ioengine_uring_cmd = {
 	.name			= "io_uring_cmd",
 	.version		= FIO_IOOPS_VERSION,
-	.flags			= FIO_ASYNCIO_SYNC_TRIM | FIO_NO_OFFLOAD |
-					FIO_MEMALIGN | FIO_RAWIO |
+	.flags			= FIO_NO_OFFLOAD | FIO_MEMALIGN | FIO_RAWIO |
 					FIO_ASYNCIO_SETS_ISSUE_TIME,
 	.init			= fio_ioring_init,
 	.post_init		= fio_ioring_cmd_post_init,
diff --git a/engines/nvme.c b/engines/nvme.c
index 1047ade2..b18ad4c2 100644
--- a/engines/nvme.c
+++ b/engines/nvme.c
@@ -5,8 +5,41 @@
 
 #include "nvme.h"
 
+static inline __u64 get_slba(struct nvme_data *data, struct io_u *io_u)
+{
+	if (data->lba_ext)
+		return io_u->offset / data->lba_ext;
+	else
+		return io_u->offset >> data->lba_shift;
+}
+
+static inline __u32 get_nlb(struct nvme_data *data, struct io_u *io_u)
+{
+	if (data->lba_ext)
+		return io_u->xfer_buflen / data->lba_ext - 1;
+	else
+		return (io_u->xfer_buflen >> data->lba_shift) - 1;
+}
+
+void fio_nvme_uring_cmd_trim_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
+				  struct nvme_dsm_range *dsm)
+{
+	struct nvme_data *data = FILE_ENG_DATA(io_u->file);
+
+	cmd->opcode = nvme_cmd_dsm;
+	cmd->nsid = data->nsid;
+	cmd->cdw10 = 0;
+	cmd->cdw11 = NVME_ATTRIBUTE_DEALLOCATE;
+	cmd->addr = (__u64) (uintptr_t) dsm;
+	cmd->data_len = sizeof(*dsm);
+
+	dsm->slba = get_slba(data, io_u);
+	/* nlb is a 1-based value for deallocate */
+	dsm->nlb = get_nlb(data, io_u) + 1;
+}
+
 int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
-			    struct iovec *iov)
+			    struct iovec *iov, struct nvme_dsm_range *dsm)
 {
 	struct nvme_data *data = FILE_ENG_DATA(io_u->file);
 	__u64 slba;
@@ -14,21 +47,23 @@ int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 
 	memset(cmd, 0, sizeof(struct nvme_uring_cmd));
 
-	if (io_u->ddir == DDIR_READ)
+	switch (io_u->ddir) {
+	case DDIR_READ:
 		cmd->opcode = nvme_cmd_read;
-	else if (io_u->ddir == DDIR_WRITE)
+		break;
+	case DDIR_WRITE:
 		cmd->opcode = nvme_cmd_write;
-	else
+		break;
+	case DDIR_TRIM:
+		fio_nvme_uring_cmd_trim_prep(cmd, io_u, dsm);
+		return 0;
+	default:
 		return -ENOTSUP;
-
-	if (data->lba_ext) {
-		slba = io_u->offset / data->lba_ext;
-		nlb = (io_u->xfer_buflen / data->lba_ext) - 1;
-	} else {
-		slba = io_u->offset >> data->lba_shift;
-		nlb = (io_u->xfer_buflen >> data->lba_shift) - 1;
 	}
 
+	slba = get_slba(data, io_u);
+	nlb = get_nlb(data, io_u);
+
 	/* cdw10 and cdw11 represent starting lba */
 	cmd->cdw10 = slba & 0xffffffff;
 	cmd->cdw11 = slba >> 32;
@@ -48,45 +83,6 @@ int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 	return 0;
 }
 
-static int nvme_trim(int fd, __u32 nsid, __u32 nr_range, __u32 data_len,
-		     void *data)
-{
-	struct nvme_passthru_cmd cmd = {
-		.opcode		= nvme_cmd_dsm,
-		.nsid		= nsid,
-		.addr		= (__u64)(uintptr_t)data,
-		.data_len 	= data_len,
-		.cdw10		= nr_range - 1,
-		.cdw11		= NVME_ATTRIBUTE_DEALLOCATE,
-	};
-
-	return ioctl(fd, NVME_IOCTL_IO_CMD, &cmd);
-}
-
-int fio_nvme_trim(const struct thread_data *td, struct fio_file *f,
-		  unsigned long long offset, unsigned long long len)
-{
-	struct nvme_data *data = FILE_ENG_DATA(f);
-	struct nvme_dsm_range dsm;
-	int ret;
-
-	if (data->lba_ext) {
-		dsm.nlb = len / data->lba_ext;
-		dsm.slba = offset / data->lba_ext;
-	} else {
-		dsm.nlb = len >> data->lba_shift;
-		dsm.slba = offset >> data->lba_shift;
-	}
-
-	ret = nvme_trim(f->fd, data->nsid, 1, sizeof(struct nvme_dsm_range),
-			&dsm);
-	if (ret)
-		log_err("%s: nvme_trim failed for offset %llu and len %llu, err=%d\n",
-			f->file_name, offset, len, ret);
-
-	return ret;
-}
-
 static int nvme_identify(int fd, __u32 nsid, enum nvme_identify_cns cns,
 			 enum nvme_csi csi, void *data)
 {
diff --git a/engines/nvme.h b/engines/nvme.h
index f7cb820d..238471dd 100644
--- a/engines/nvme.h
+++ b/engines/nvme.h
@@ -216,9 +216,6 @@ struct nvme_dsm_range {
 	__le64	slba;
 };
 
-int fio_nvme_trim(const struct thread_data *td, struct fio_file *f,
-		  unsigned long long offset, unsigned long long len);
-
 int fio_nvme_iomgmt_ruhs(struct thread_data *td, struct fio_file *f,
 			 struct nvme_fdp_ruh_status *ruhs, __u32 bytes);
 
@@ -226,7 +223,7 @@ int fio_nvme_get_info(struct fio_file *f, __u32 *nsid, __u32 *lba_sz,
 		      __u32 *ms, __u64 *nlba);
 
 int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
-			    struct iovec *iov);
+			    struct iovec *iov, struct nvme_dsm_range *dsm);
 
 int fio_nvme_get_zoned_model(struct thread_data *td, struct fio_file *f,
 			     enum zbd_zoned_model *model);
diff --git a/oslib/linux-blkzoned.c b/oslib/linux-blkzoned.c
index c3130d0e..722e0992 100644
--- a/oslib/linux-blkzoned.c
+++ b/oslib/linux-blkzoned.c
@@ -22,6 +22,9 @@
 #include "zbd_types.h"
 
 #include <linux/blkzoned.h>
+#ifndef BLKFINISHZONE
+#define BLKFINISHZONE _IOW(0x12, 136, struct blk_zone_range)
+#endif
 
 /*
  * If the uapi headers installed on the system lacks zone capacity support,
@@ -312,7 +315,6 @@ int blkzoned_reset_wp(struct thread_data *td, struct fio_file *f,
 int blkzoned_finish_zone(struct thread_data *td, struct fio_file *f,
 			 uint64_t offset, uint64_t length)
 {
-#ifdef BLKFINISHZONE
 	struct blk_zone_range zr = {
 		.sector         = offset >> 9,
 		.nr_sectors     = length >> 9,
@@ -327,21 +329,19 @@ int blkzoned_finish_zone(struct thread_data *td, struct fio_file *f,
 			return -errno;
 	}
 
-	if (ioctl(fd, BLKFINISHZONE, &zr) < 0)
+	if (ioctl(fd, BLKFINISHZONE, &zr) < 0) {
 		ret = -errno;
+		/*
+		 * Kernel versions older than 5.5 do not support BLKFINISHZONE
+		 * and return the ENOTTY error code. These old kernels only
+		 * support block devices that close zones automatically.
+		 */
+		if (ret == ENOTTY)
+			ret = 0;
+	}
 
 	if (f->fd < 0)
 		close(fd);
 
 	return ret;
-#else
-	/*
-	 * Kernel versions older than 5.5 does not support BLKFINISHZONE. These
-	 * old kernels assumed zones are closed automatically at max_open_zones
-	 * limit. Also they did not support max_active_zones limit. Then there
-	 * was no need to finish zones to avoid errors caused by max_open_zones
-	 * or max_active_zones. For those old versions, just do nothing.
-	 */
-	return 0;
-#endif
 }
diff --git a/t/nvmept.py b/t/nvmept.py
index e235d160..cc26d152 100755
--- a/t/nvmept.py
+++ b/t/nvmept.py
@@ -80,6 +80,10 @@ class PassThruTest(FioJobCmdTest):
             print(f"Unhandled rw value {self.fio_opts['rw']}")
             self.passed = False
 
+        if job['iodepth_level']['8'] < 95:
+            print("Did not achieve requested iodepth")
+            self.passed = False
+
 
 TEST_LIST = [
     {
@@ -232,6 +236,23 @@ TEST_LIST = [
             },
         "test_class": PassThruTest,
     },
+    {
+        # We can't enable fixedbufs because for trim-only
+        # workloads fio actually does not allocate any buffers
+        "test_id": 15,
+        "fio_opts": {
+            "rw": 'randtrim',
+            "timebased": 1,
+            "runtime": 3,
+            "fixedbufs": 0,
+            "nonvectored": 1,
+            "force_async": 1,
+            "registerfiles": 1,
+            "sqthread_poll": 1,
+            "output-format": "json",
+            },
+        "test_class": PassThruTest,
+    },
 ]
 
 def parse_args():
