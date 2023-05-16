Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E1D0C77B7F
	for <fio@archiver.kernel.org>; Tue, 16 May 2023 12:00:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbjEPMAR (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 16 May 2023 08:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231816AbjEPMAQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 16 May 2023 08:00:16 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C83230FE
        for <fio@vger.kernel.org>; Tue, 16 May 2023 05:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=V1/k7XpkBMnOVT3aT+n2tX2hQs9lc8a9V3AJSvqqNI4=; b=fkQXXADkRiV+XqIYL+/16fYklF
        0LlYLwAC4MXXteVWLar1/p3XbNp2SRJAtEvq+Z5HVFUv0dHFL6CqUQ9iHfryoT8tGFqT2T8flVTGa
        vWWpu/6bO7JTHAHGdwiGMdUCXG4l7u3eQemMk1oKJ7/PFPWxQCo4rplkl5hBqFmx1xCsTMzRE5k4B
        57c2lSPQqv42rB4XBl6gAJUlHZQK5oZOFTVyS1jOZUC7RaBLqrT/+tVdw5DH2hqiaAGwp/VT0X35v
        y1qNQLdmLl3txSGUTRRMboFXamIMErvtLSh0eGTvz1gsStfuGTGqo7XZ/DvC8OMcK3+MF23vzpRyU
        m6ei598g==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pytLf-00C6Xs-2O
        for fio@vger.kernel.org;
        Tue, 16 May 2023 12:00:12 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 16B2B1BC016E; Tue, 16 May 2023 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230516120002.16B2B1BC016E@kernel.dk>
Date:   Tue, 16 May 2023 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit f6f80750f75810bdaf56dd9362982055de1d7232:

  docs: expand description for interval-based bw and iops statistics (2023-05-10 20:28:49 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 83b2d4b78374055c3a2261136eedf03b5fbfc335:

  ci: stop testing Linux 32-bit builds (2023-05-15 08:51:27 -0400)

----------------------------------------------------------------
Ankit Kumar (2):
      engines/nvme: support for 64 LBA formats
      engines/io_uring_cmd: add extended LBA support

Vincent Fu (1):
      ci: stop testing Linux 32-bit builds

 .github/workflows/ci.yml |  4 ---
 engines/io_uring.c       | 30 +++++++++++++++++++---
 engines/nvme.c           | 66 ++++++++++++++++++++++++++++++++++++++++--------
 engines/nvme.h           |  6 ++---
 4 files changed, 84 insertions(+), 22 deletions(-)

---

Diff of recent changes:

diff --git a/.github/workflows/ci.yml b/.github/workflows/ci.yml
index dd2997f0..8325a3d9 100644
--- a/.github/workflows/ci.yml
+++ b/.github/workflows/ci.yml
@@ -14,7 +14,6 @@ jobs:
         - linux-gcc
         - linux-clang
         - macos
-        - linux-i686-gcc
         - android
         - windows-cygwin-64
         - windows-cygwin-32
@@ -28,9 +27,6 @@ jobs:
           cc: clang
         - build: macos
           os: macos-12
-        - build: linux-i686-gcc
-          os: ubuntu-22.04
-          arch: i686
         - build: android
           os: ubuntu-22.04
           arch: aarch64-linux-android32
diff --git a/engines/io_uring.c b/engines/io_uring.c
index f5ffe9f4..90e5a856 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -1177,22 +1177,40 @@ static int fio_ioring_cmd_open_file(struct thread_data *td, struct fio_file *f)
 	if (o->cmd_type == FIO_URING_CMD_NVME) {
 		struct nvme_data *data = NULL;
 		unsigned int nsid, lba_size = 0;
+		__u32 ms = 0;
 		__u64 nlba = 0;
 		int ret;
 
 		/* Store the namespace-id and lba size. */
 		data = FILE_ENG_DATA(f);
 		if (data == NULL) {
-			ret = fio_nvme_get_info(f, &nsid, &lba_size, &nlba);
+			ret = fio_nvme_get_info(f, &nsid, &lba_size, &ms, &nlba);
 			if (ret)
 				return ret;
 
 			data = calloc(1, sizeof(struct nvme_data));
 			data->nsid = nsid;
-			data->lba_shift = ilog2(lba_size);
+			if (ms)
+				data->lba_ext = lba_size + ms;
+			else
+				data->lba_shift = ilog2(lba_size);
 
 			FILE_SET_ENG_DATA(f, data);
 		}
+
+		lba_size = data->lba_ext ? data->lba_ext : (1 << data->lba_shift);
+
+		for_each_rw_ddir(ddir) {
+			if (td->o.min_bs[ddir] % lba_size ||
+				td->o.max_bs[ddir] % lba_size) {
+				if (data->lba_ext)
+					log_err("block size must be a multiple of "
+						"(LBA data size + Metadata size)\n");
+				else
+					log_err("block size must be a multiple of LBA data size\n");
+				return 1;
+			}
+                }
 	}
 	if (!ld || !o->registerfiles)
 		return generic_open_file(td, f);
@@ -1243,16 +1261,20 @@ static int fio_ioring_cmd_get_file_size(struct thread_data *td,
 	if (o->cmd_type == FIO_URING_CMD_NVME) {
 		struct nvme_data *data = NULL;
 		unsigned int nsid, lba_size = 0;
+		__u32 ms = 0;
 		__u64 nlba = 0;
 		int ret;
 
-		ret = fio_nvme_get_info(f, &nsid, &lba_size, &nlba);
+		ret = fio_nvme_get_info(f, &nsid, &lba_size, &ms, &nlba);
 		if (ret)
 			return ret;
 
 		data = calloc(1, sizeof(struct nvme_data));
 		data->nsid = nsid;
-		data->lba_shift = ilog2(lba_size);
+		if (ms)
+			data->lba_ext = lba_size + ms;
+		else
+			data->lba_shift = ilog2(lba_size);
 
 		f->real_file_size = lba_size * nlba;
 		fio_file_set_size_known(f);
diff --git a/engines/nvme.c b/engines/nvme.c
index fd2161f3..1047ade2 100644
--- a/engines/nvme.c
+++ b/engines/nvme.c
@@ -21,8 +21,13 @@ int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 	else
 		return -ENOTSUP;
 
-	slba = io_u->offset >> data->lba_shift;
-	nlb = (io_u->xfer_buflen >> data->lba_shift) - 1;
+	if (data->lba_ext) {
+		slba = io_u->offset / data->lba_ext;
+		nlb = (io_u->xfer_buflen / data->lba_ext) - 1;
+	} else {
+		slba = io_u->offset >> data->lba_shift;
+		nlb = (io_u->xfer_buflen >> data->lba_shift) - 1;
+	}
 
 	/* cdw10 and cdw11 represent starting lba */
 	cmd->cdw10 = slba & 0xffffffff;
@@ -65,8 +70,13 @@ int fio_nvme_trim(const struct thread_data *td, struct fio_file *f,
 	struct nvme_dsm_range dsm;
 	int ret;
 
-	dsm.nlb = (len >> data->lba_shift);
-	dsm.slba = (offset >> data->lba_shift);
+	if (data->lba_ext) {
+		dsm.nlb = len / data->lba_ext;
+		dsm.slba = offset / data->lba_ext;
+	} else {
+		dsm.nlb = len >> data->lba_shift;
+		dsm.slba = offset >> data->lba_shift;
+	}
 
 	ret = nvme_trim(f->fd, data->nsid, 1, sizeof(struct nvme_dsm_range),
 			&dsm);
@@ -94,11 +104,12 @@ static int nvme_identify(int fd, __u32 nsid, enum nvme_identify_cns cns,
 }
 
 int fio_nvme_get_info(struct fio_file *f, __u32 *nsid, __u32 *lba_sz,
-		      __u64 *nlba)
+		      __u32 *ms, __u64 *nlba)
 {
 	struct nvme_id_ns ns;
 	int namespace_id;
 	int fd, err;
+	__u32 format_idx;
 
 	if (f->filetype != FIO_TYPE_CHAR) {
 		log_err("ioengine io_uring_cmd only works with nvme ns "
@@ -113,9 +124,8 @@ int fio_nvme_get_info(struct fio_file *f, __u32 *nsid, __u32 *lba_sz,
 	namespace_id = ioctl(fd, NVME_IOCTL_ID);
 	if (namespace_id < 0) {
 		err = -errno;
-		log_err("failed to fetch namespace-id");
-		close(fd);
-		return err;
+		log_err("%s: failed to fetch namespace-id\n", f->file_name);
+		goto out;
 	}
 
 	/*
@@ -125,17 +135,51 @@ int fio_nvme_get_info(struct fio_file *f, __u32 *nsid, __u32 *lba_sz,
 	err = nvme_identify(fd, namespace_id, NVME_IDENTIFY_CNS_NS,
 				NVME_CSI_NVM, &ns);
 	if (err) {
-		log_err("failed to fetch identify namespace\n");
+		log_err("%s: failed to fetch identify namespace\n",
+			f->file_name);
 		close(fd);
 		return err;
 	}
 
 	*nsid = namespace_id;
-	*lba_sz = 1 << ns.lbaf[(ns.flbas & 0x0f)].ds;
+
+	/*
+	 * 16 or 64 as maximum number of supported LBA formats.
+	 * From flbas bit 0-3 indicates lsb and bit 5-6 indicates msb
+	 * of the format index used to format the namespace.
+	 */
+	if (ns.nlbaf < 16)
+		format_idx = ns.flbas & 0xf;
+	else
+		format_idx = (ns.flbas & 0xf) + (((ns.flbas >> 5) & 0x3) << 4);
+
+	*lba_sz = 1 << ns.lbaf[format_idx].ds;
+
+	/*
+	 * Only extended LBA can be supported.
+	 * Bit 4 for flbas indicates if metadata is transferred at the end of
+	 * logical block creating an extended LBA.
+	 */
+	*ms = le16_to_cpu(ns.lbaf[format_idx].ms);
+	if (*ms && !((ns.flbas >> 4) & 0x1)) {
+		log_err("%s: only extended logical block can be supported\n",
+			f->file_name);
+		err = -ENOTSUP;
+		goto out;
+	}
+
+	/* Check for end to end data protection support */
+	if (ns.dps & 0x3) {
+		log_err("%s: end to end data protection not supported\n",
+			f->file_name);
+		err = -ENOTSUP;
+		goto out;
+	}
 	*nlba = ns.nsze;
 
+out:
 	close(fd);
-	return 0;
+	return err;
 }
 
 int fio_nvme_get_zoned_model(struct thread_data *td, struct fio_file *f,
diff --git a/engines/nvme.h b/engines/nvme.h
index 408594d5..f7cb820d 100644
--- a/engines/nvme.h
+++ b/engines/nvme.h
@@ -88,6 +88,7 @@ enum nvme_zns_zs {
 struct nvme_data {
 	__u32 nsid;
 	__u32 lba_shift;
+	__u32 lba_ext;
 };
 
 struct nvme_lbaf {
@@ -134,8 +135,7 @@ struct nvme_id_ns {
 	__le16			endgid;
 	__u8			nguid[16];
 	__u8			eui64[8];
-	struct nvme_lbaf	lbaf[16];
-	__u8			rsvd192[192];
+	struct nvme_lbaf	lbaf[64];
 	__u8			vs[3712];
 };
 
@@ -223,7 +223,7 @@ int fio_nvme_iomgmt_ruhs(struct thread_data *td, struct fio_file *f,
 			 struct nvme_fdp_ruh_status *ruhs, __u32 bytes);
 
 int fio_nvme_get_info(struct fio_file *f, __u32 *nsid, __u32 *lba_sz,
-		      __u64 *nlba);
+		      __u32 *ms, __u64 *nlba);
 
 int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 			    struct iovec *iov);
