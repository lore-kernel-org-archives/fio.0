Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84260C76195
	for <fio@archiver.kernel.org>; Tue, 28 Mar 2023 12:00:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232477AbjC1MAT (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 28 Mar 2023 08:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjC1MAS (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 28 Mar 2023 08:00:18 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 961A99006
        for <fio@vger.kernel.org>; Tue, 28 Mar 2023 05:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=XAZcQn/iiPACJ0l1QR3Yicw9HzxDpdamnebkt2Tc50U=; b=TgLe0+yIZcIngQ3vBnGsJVyNUY
        89CleqCBmRA3Z1fAioGJTu9PYZyID74s0+djMDHJ3qEYVroV5sh/Eq+lsw63oImYMemEvxVq+nGIj
        hjkVhMHC8FLrymmt91gSXXesFBInrD7Yd+YwIDLuuaAnQOqNwI7Ra8M6D34wwXiFrkk3RVQOMhMoR
        +BO1JFo+VszagC+ZzTa6QqOAiWKRsfFVWKGMF4xl+cIy3j+LcWWj2PsN8LXJNhbLHwHHwjfy5ytev
        ePR/rgconP0IIrmE4Y4mqyIbJ4pn8rqdQY2h85HyoASizNrg+oZwppgMVi8OjYCulryvcoj25hBTX
        atV8wAzg==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1ph7zg-006Y4g-1V
        for fio@vger.kernel.org;
        Tue, 28 Mar 2023 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 86F3F1BC0177; Tue, 28 Mar 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230328120001.86F3F1BC0177@kernel.dk>
Date:   Tue, 28 Mar 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 2fa0ab21c5726d8242a820ff688de019cc4d2fe2:

  engines/nvme: cast __u64 to unsigned long long for printing (2023-03-21 08:40:14 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d86ac3e9f4c703b7d7c9add96e69f2d02affdc65:

  Merge branch 'trim-support' of https://github.com/ankit-sam/fio (2023-03-27 13:21:25 -0600)

----------------------------------------------------------------
Ankit Kumar (2):
      fdp: drop expensive modulo operation
      io_uring_cmd: suppport for trim operation

Jens Axboe (1):
      Merge branch 'trim-support' of https://github.com/ankit-sam/fio

 engines/io_uring.c | 31 ++++++++++++++++++++++++++++++-
 engines/nvme.c     | 34 ++++++++++++++++++++++++++++++++++
 engines/nvme.h     | 12 ++++++++++++
 fdp.c              |  5 ++++-
 stat.c             |  2 +-
 5 files changed, 81 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 54fdf7f3..f10a4593 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -24,6 +24,7 @@
 #include "../lib/types.h"
 #include "../os/linux/io_uring.h"
 #include "cmdprio.h"
+#include "zbd.h"
 #include "nvme.h"
 
 #include <sys/stat.h>
@@ -409,6 +410,9 @@ static int fio_ioring_cmd_prep(struct thread_data *td, struct io_u *io_u)
 	if (o->cmd_type != FIO_URING_CMD_NVME)
 		return -EINVAL;
 
+	if (io_u->ddir == DDIR_TRIM)
+		return 0;
+
 	sqe = &ld->sqes[(io_u->index) << 1];
 
 	if (o->registerfiles) {
@@ -556,6 +560,27 @@ static inline void fio_ioring_cmdprio_prep(struct thread_data *td,
 		ld->sqes[io_u->index].ioprio = io_u->ioprio;
 }
 
+static int fio_ioring_cmd_io_u_trim(const struct thread_data *td,
+				    struct io_u *io_u)
+{
+	struct fio_file *f = io_u->file;
+	int ret;
+
+	if (td->o.zone_mode == ZONE_MODE_ZBD) {
+		ret = zbd_do_io_u_trim(td, io_u);
+		if (ret == io_u_completed)
+			return io_u->xfer_buflen;
+		if (ret)
+			goto err;
+	}
+
+	return fio_nvme_trim(td, f, io_u->offset, io_u->xfer_buflen);
+
+err:
+	io_u->error = ret;
+	return 0;
+}
+
 static enum fio_q_status fio_ioring_queue(struct thread_data *td,
 					  struct io_u *io_u)
 {
@@ -572,7 +597,11 @@ static enum fio_q_status fio_ioring_queue(struct thread_data *td,
 		if (ld->queued)
 			return FIO_Q_BUSY;
 
-		do_io_u_trim(td, io_u);
+		if (!strcmp(td->io_ops->name, "io_uring_cmd"))
+			fio_ioring_cmd_io_u_trim(td, io_u);
+		else
+			do_io_u_trim(td, io_u);
+
 		io_u_mark_submit(td, 1);
 		io_u_mark_complete(td, 1);
 		return FIO_Q_COMPLETED;
diff --git a/engines/nvme.c b/engines/nvme.c
index 3f6b64a8..ac908687 100644
--- a/engines/nvme.c
+++ b/engines/nvme.c
@@ -43,6 +43,40 @@ int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 	return 0;
 }
 
+static int nvme_trim(int fd, __u32 nsid, __u32 nr_range, __u32 data_len,
+		     void *data)
+{
+	struct nvme_passthru_cmd cmd = {
+		.opcode		= nvme_cmd_dsm,
+		.nsid		= nsid,
+		.addr		= (__u64)(uintptr_t)data,
+		.data_len 	= data_len,
+		.cdw10		= nr_range - 1,
+		.cdw11		= NVME_ATTRIBUTE_DEALLOCATE,
+	};
+
+	return ioctl(fd, NVME_IOCTL_IO_CMD, &cmd);
+}
+
+int fio_nvme_trim(const struct thread_data *td, struct fio_file *f,
+		  unsigned long long offset, unsigned long long len)
+{
+	struct nvme_data *data = FILE_ENG_DATA(f);
+	struct nvme_dsm_range dsm;
+	int ret;
+
+	dsm.nlb = (len >> data->lba_shift);
+	dsm.slba = (offset >> data->lba_shift);
+
+	ret = nvme_trim(f->fd, data->nsid, 1, sizeof(struct nvme_dsm_range),
+			&dsm);
+	if (ret)
+		log_err("%s: nvme_trim failed for offset %llu and len %llu, err=%d\n",
+			f->file_name, offset, len, ret);
+
+	return ret;
+}
+
 static int nvme_identify(int fd, __u32 nsid, enum nvme_identify_cns cns,
 			 enum nvme_csi csi, void *data)
 {
diff --git a/engines/nvme.h b/engines/nvme.h
index 1c0e526b..408594d5 100644
--- a/engines/nvme.h
+++ b/engines/nvme.h
@@ -48,6 +48,8 @@ struct nvme_uring_cmd {
 #define NVME_ZNS_ZSA_RESET 0x4
 #define NVME_ZONE_TYPE_SEQWRITE_REQ 0x2
 
+#define NVME_ATTRIBUTE_DEALLOCATE (1 << 2)
+
 enum nvme_identify_cns {
 	NVME_IDENTIFY_CNS_NS		= 0x00,
 	NVME_IDENTIFY_CNS_CSI_NS	= 0x05,
@@ -67,6 +69,7 @@ enum nvme_admin_opcode {
 enum nvme_io_opcode {
 	nvme_cmd_write			= 0x01,
 	nvme_cmd_read			= 0x02,
+	nvme_cmd_dsm			= 0x09,
 	nvme_cmd_io_mgmt_recv		= 0x12,
 	nvme_zns_cmd_mgmt_send		= 0x79,
 	nvme_zns_cmd_mgmt_recv		= 0x7a,
@@ -207,6 +210,15 @@ struct nvme_fdp_ruh_status {
 	struct nvme_fdp_ruh_status_desc ruhss[];
 };
 
+struct nvme_dsm_range {
+	__le32	cattr;
+	__le32	nlb;
+	__le64	slba;
+};
+
+int fio_nvme_trim(const struct thread_data *td, struct fio_file *f,
+		  unsigned long long offset, unsigned long long len);
+
 int fio_nvme_iomgmt_ruhs(struct thread_data *td, struct fio_file *f,
 			 struct nvme_fdp_ruh_status *ruhs, __u32 bytes);
 
diff --git a/fdp.c b/fdp.c
index 84e04fce..d92dbc67 100644
--- a/fdp.c
+++ b/fdp.c
@@ -119,7 +119,10 @@ void fdp_fill_dspec_data(struct thread_data *td, struct io_u *io_u)
 		return;
 	}
 
-	dspec = ruhs->plis[ruhs->pli_loc++ % ruhs->nr_ruhs];
+	if (ruhs->pli_loc >= ruhs->nr_ruhs)
+		ruhs->pli_loc = 0;
+
+	dspec = ruhs->plis[ruhs->pli_loc++];
 	io_u->dtype = 2;
 	io_u->dspec = dspec;
 }
diff --git a/stat.c b/stat.c
index d779a90f..015b8e28 100644
--- a/stat.c
+++ b/stat.c
@@ -555,7 +555,7 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 
 	iops = (1000 * (uint64_t)ts->total_io_u[ddir]) / runt;
 	iops_p = num2str(iops, ts->sig_figs, 1, 0, N2S_NONE);
-	if (ddir == DDIR_WRITE)
+	if (ddir == DDIR_WRITE || ddir == DDIR_TRIM)
 		post_st = zbd_write_status(ts);
 	else if (ddir == DDIR_READ && ts->cachehit && ts->cachemiss) {
 		uint64_t total;
