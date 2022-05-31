Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E498C4332F
	for <fio@archiver.kernel.org>; Wed,  1 Jun 2022 09:40:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350252AbiFAJkW (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 1 Jun 2022 05:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350017AbiFAJkQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 1 Jun 2022 05:40:16 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48AB94924A
        for <fio@vger.kernel.org>; Wed,  1 Jun 2022 02:40:15 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220601094011epoutp044b453fca556ecfd61679f03be35b98ee~0dbuGTBXp0647906479epoutp04D
        for <fio@vger.kernel.org>; Wed,  1 Jun 2022 09:40:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220601094011epoutp044b453fca556ecfd61679f03be35b98ee~0dbuGTBXp0647906479epoutp04D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1654076411;
        bh=j0TSCeufAiWHzUT12udzooUNe/7wrhBxvlcPLNv303A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sBQgiiJ5vy+23hoFqgm+o4JvMw5T/ADXquL52n/lMV9JgODqSt/bTgZOCDhNH1WYr
         xnfoe8yfzoMdy4VlV25PqkTVwdrRylc3M4Rct6tIi4J+UPMK99ju0QlnJQlU4045kv
         whIAPTMcnrr+mlZV+ipH2xmnofkwBSaLaYLviKss=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220601094010epcas5p2a57268a0c9c3bddb4d40eeb8a44107b6~0dbts3tbM0343703437epcas5p2s;
        Wed,  1 Jun 2022 09:40:10 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4LCkdf5nwlz4x9Pw; Wed,  1 Jun
        2022 09:40:06 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        30.77.09827.6F337926; Wed,  1 Jun 2022 18:40:06 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220531133745epcas5p3546b36e799931251c4020e4fe13fa14d~0NB22rCcp2562925629epcas5p3Q;
        Tue, 31 May 2022 13:37:45 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220531133745epsmtrp27b2e7296a65975cd664d00b77b41a0b2~0NB216tBM0338303383epsmtrp2E;
        Tue, 31 May 2022 13:37:45 +0000 (GMT)
X-AuditID: b6c32a4a-b3bff70000002663-5f-629733f67592
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        63.4E.08924.92A16926; Tue, 31 May 2022 22:37:45 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220531133743epsmtip2a889346c98b359efbbcf56072748d040~0NB1FeRG82729427294epsmtip2q;
        Tue, 31 May 2022 13:37:43 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, krish.reddy@samsung.com, joshi.k@samsung.com,
        anuj20.g@samsung.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v3 4/9] nvme: add nvme opcodes, structures and helper
 functions
Date:   Tue, 31 May 2022 19:01:50 +0530
Message-Id: <20220531133155.17493-5-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220531133155.17493-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLKsWRmVeSWpSXmKPExsWy7bCmuu434+lJBtteC1qsufKb3aJpwl9m
        i9V3+9ksPs56wWxx9P9bNouFG5cxObB5XD5b6tG3ZRWjx+dNcgHMUdk2GamJKalFCql5yfkp
        mXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBrlRTKEnNKgUIBicXFSvp2NkX5
        pSWpChn5xSW2SqkFKTkFJgV6xYm5xaV56Xp5qSVWhgYGRqZAhQnZGfdnnWAp+G5WcWByfAPj
        H60uRk4OCQETiZZHvSxdjFwcQgK7GSWOfbvOCuF8YpR49ukQM4TzmVHi/ZUTLDAtjzsms4PY
        QgK7GCXaLydA2K1MEhPfFYPYbALaEq/e3mAGsUUEhCX2d7SCrWAWaGGUaFy9FmyQsECgxIrl
        U8FsFgFViaendgOt5uDgFbCR2HouFGKXvMTqDQfA5nAK2ErMm7oe7DoJgU3sEuuf3WeFKHKR
        mLl+IzOELSzx6vgWdghbSuLzu71sEHa2ROOjv1B2icTOW9uh6u0lLu75ywSyl1lAU2L9Ln2I
        sKzE1FPrmEBsZgE+id7fT5gg4rwSO+bB2KoSf+/dhoaJtMTNd1dZQMZICHhIdL7khYTbBEaJ
        fRufME5glJuFsGEBI+MqRsnUguLc9NRi0wKjvNRyeJQl5+duYgSnKy2vHYwPH3zQO8TIxMF4
        iFGCg1lJhLdk19QkId6UxMqq1KL8+KLSnNTiQ4ymwOCbyCwlmpwPTJh5JfGGJpYGJmZmZiaW
        xmaGSuK8Av8bk4QE0hNLUrNTUwtSi2D6mDg4pRqY1FJVRe8fXJ/pKKL4/xZTATPPlSWnbuve
        ynn3zqG9q+Te9dzsEJP7pUdD/nTM0F16NLC7VuO6/n5P36iIo3/+rPNf8M9r6lcGG5fL7m9+
        9G7/+b2C/9i8J39evA5ObbrfwHTtsN3B/FPfTAsus5gwBbfwPD75fePWVU8TxJuvL1jExTL/
        ufs5wUfTQp5HrTpfeumhmlTegrSYYA327r+qJZFX5OXeKK0+tzL/oVbi7RNr2Q9vCa95sEf6
        36/Z9/s6mitC81e1+MxvdjiXVd+qse77iyY925+Rthm+fvJGCSyPps54yMt3KuZ7Y6iYK3uu
        /7qq97kzpxfp8tRG+aYuODWdPeftf4cClnSR2pwUJZbijERDLeai4kQAJUZOseADAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplluLIzCtJLcpLzFFi42LZdlhJXldTalqSwf0tAhZrrvxmt2ia8JfZ
        YvXdfjaLj7NeMFsc/f+WzWLhxmVMDmwel8+WevRtWcXo8XmTXABzFJdNSmpOZllqkb5dAlfG
        /VknWAq+m1UcmBzfwPhHq4uRk0NCwETiccdk9i5GLg4hgR2MEl++/wZyOIAS0hIL1ydC1AhL
        rPz3HKqmmUli/YvjrCAJNgFtiVdvbzCD2CJARfs7WllAipgFuhglejpPMYEkhAX8JTYe2sMC
        YrMIqEo8PbWbFWQBr4CNxNZzoRAL5CVWbzgANodTwFZi3tT1YPOFgEqmvljAOIGRbwEjwypG
        ydSC4tz03GLDAqO81HK94sTc4tK8dL3k/NxNjOCQ0tLawbhn1Qe9Q4xMHIyHGCU4mJVEeEt2
        TU0S4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuh62S8kEB6YklqdmpqQWoRTJaJg1OqgSlIk+vP
        tfs5986usj29Q4Sp+4jnZn2vcomriW926l9duOi3tb9Y0Evxpn/h9WG7WO+YXev9f3aDlJSB
        59a/Fxv3HVC9dnVNqG5+coDNrkfzYtTuBKnt1jV0SL8U0DP/wXmm6SYpWx0Kv/EdZnZcnnth
        jfDM8gNmrnpN91Rt5ZeeTI2flL72wtfe33c4snQfXRNlPd+sGuBuXainxDVJyPa/0v8lb+f9
        qxfXaJtVYqy/bunsf9b1+e8j9kxc+H7ala3v648FtGw6Nqck0vjpFtkn7Y8VTs3YJLd5T9lr
        9siF2ZffLwr+tzo+eJHEuh//mW4yTTi6Zn2Tn6JT2rb1PLYPzIsWzrFcOmXBrA3rzq+uUmIp
        zkg01GIuKk4EABoRl8+YAgAA
X-CMS-MailID: 20220531133745epcas5p3546b36e799931251c4020e4fe13fa14d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220531133745epcas5p3546b36e799931251c4020e4fe13fa14d
References: <20220531133155.17493-1-ankit.kumar@samsung.com>
        <CGME20220531133745epcas5p3546b36e799931251c4020e4fe13fa14d@epcas5p3.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Add NVMe specification opcodes, data structures and helper
functions to get identify namespace and form nvme uring command.

This will help the follow up patches to get nvme-ns generic
character device size, lba size.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
Co-authored-by: Anuj Gupta <anuj20.g@samsung.com>
---
 Makefile       |   4 +-
 engines/nvme.c | 103 +++++++++++++++++++++++++++++++++++++
 engines/nvme.h | 136 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 241 insertions(+), 2 deletions(-)
 create mode 100644 engines/nvme.c
 create mode 100644 engines/nvme.h

diff --git a/Makefile b/Makefile
index ed66305a..188a74d7 100644
--- a/Makefile
+++ b/Makefile
@@ -231,7 +231,7 @@ ifdef CONFIG_LIBXNVME
 endif
 ifeq ($(CONFIG_TARGET_OS), Linux)
   SOURCE += diskutil.c fifo.c blktrace.c cgroup.c trim.c engines/sg.c \
-		oslib/linux-dev-lookup.c engines/io_uring.c
+		oslib/linux-dev-lookup.c engines/io_uring.c engines/nvme.c
   cmdprio_SRCS = engines/cmdprio.c
 ifdef CONFIG_HAS_BLKZONED
   SOURCE += oslib/linux-blkzoned.c
@@ -241,7 +241,7 @@ endif
 endif
 ifeq ($(CONFIG_TARGET_OS), Android)
   SOURCE += diskutil.c fifo.c blktrace.c cgroup.c trim.c profiles/tiobench.c \
-		oslib/linux-dev-lookup.c engines/io_uring.c
+		oslib/linux-dev-lookup.c engines/io_uring.c engines/nvme.c
   cmdprio_SRCS = engines/cmdprio.c
 ifdef CONFIG_HAS_BLKZONED
   SOURCE += oslib/linux-blkzoned.c
diff --git a/engines/nvme.c b/engines/nvme.c
new file mode 100644
index 00000000..6fecf0ba
--- /dev/null
+++ b/engines/nvme.c
@@ -0,0 +1,103 @@
+/*
+ * nvme structure declarations and helper functions for the
+ * io_uring_cmd engine.
+ */
+
+#include "nvme.h"
+
+int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
+			    struct iovec *iov)
+{
+	struct nvme_data *data = FILE_ENG_DATA(io_u->file);
+	__u64 slba;
+	__u32 nlb;
+
+	memset(cmd, 0, sizeof(struct nvme_uring_cmd));
+
+	if (io_u->ddir == DDIR_READ)
+		cmd->opcode = nvme_cmd_read;
+	else if (io_u->ddir == DDIR_WRITE)
+		cmd->opcode = nvme_cmd_write;
+	else
+		return -ENOTSUP;
+
+	slba = io_u->offset >> data->lba_shift;
+	nlb = (io_u->xfer_buflen >> data->lba_shift) - 1;
+
+	/* cdw10 and cdw11 represent starting lba */
+	cmd->cdw10 = slba & 0xffffffff;
+	cmd->cdw11 = slba >> 32;
+	/* cdw12 represent number of lba's for read/write */
+	cmd->cdw12 = nlb;
+	if (iov) {
+		iov->iov_base = io_u->xfer_buf;
+		iov->iov_len = io_u->xfer_buflen;
+		cmd->addr = (__u64)(uintptr_t)iov;
+		cmd->data_len = 1;
+	} else {
+		cmd->addr = (__u64)(uintptr_t)io_u->xfer_buf;
+		cmd->data_len = io_u->xfer_buflen;
+	}
+	cmd->nsid = data->nsid;
+	return 0;
+}
+
+static int nvme_identify(int fd, __u32 nsid, enum nvme_identify_cns cns,
+			 enum nvme_csi csi, void *data)
+{
+	struct nvme_passthru_cmd cmd = {
+		.opcode         = nvme_admin_identify,
+		.nsid           = nsid,
+		.addr           = (__u64)(uintptr_t)data,
+		.data_len       = NVME_IDENTIFY_DATA_SIZE,
+		.cdw10          = cns,
+		.cdw11          = csi << NVME_IDENTIFY_CSI_SHIFT,
+		.timeout_ms     = NVME_DEFAULT_IOCTL_TIMEOUT,
+	};
+
+	return ioctl(fd, NVME_IOCTL_ADMIN_CMD, &cmd);
+}
+
+int fio_nvme_get_info(struct fio_file *f, __u32 *nsid, __u32 *lba_sz,
+		      __u64 *nlba)
+{
+	struct nvme_id_ns ns;
+	unsigned int namespace_id;
+	int fd, err;
+
+	if (f->filetype != FIO_TYPE_CHAR) {
+		log_err("ioengine io_uring_cmd only works with nvme ns "
+			"generic char devices (/dev/ngXnY)\n");
+		return 1;
+	}
+
+	fd = open(f->file_name, O_RDONLY);
+	if (fd < 0)
+		return -errno;
+
+	namespace_id = ioctl(fd, NVME_IOCTL_ID);
+	if (namespace_id < 0) {
+		log_err("failed to fetch namespace-id");
+		close(fd);
+		return -errno;
+	}
+
+	/*
+	 * Identify namespace to get namespace-id, namespace size in LBA's
+	 * and LBA data size.
+	 */
+	err = nvme_identify(fd, namespace_id, NVME_IDENTIFY_CNS_NS,
+				NVME_CSI_NVM, &ns);
+	if (err) {
+		log_err("failed to fetch identify namespace\n");
+		close(fd);
+		return err;
+	}
+
+	*nsid = namespace_id;
+	*lba_sz = 1 << ns.lbaf[(ns.flbas & 0x0f)].ds;
+	*nlba = ns.nsze;
+
+	close(fd);
+	return 0;
+}
diff --git a/engines/nvme.h b/engines/nvme.h
new file mode 100644
index 00000000..8e626bb2
--- /dev/null
+++ b/engines/nvme.h
@@ -0,0 +1,136 @@
+/*
+ * nvme structure declarations and helper functions for the
+ * io_uring_cmd engine.
+ */
+
+#ifndef FIO_NVME_H
+#define FIO_NVME_H
+
+#include <linux/nvme_ioctl.h>
+#include "../fio.h"
+
+/*
+ * If the uapi headers installed on the system lacks nvme uring command
+ * support, use the local version to prevent compilation issues.
+ */
+#ifndef CONFIG_NVME_URING_CMD
+struct nvme_uring_cmd {
+	__u8	opcode;
+	__u8	flags;
+	__u16	rsvd1;
+	__u32	nsid;
+	__u32	cdw2;
+	__u32	cdw3;
+	__u64	metadata;
+	__u64	addr;
+	__u32	metadata_len;
+	__u32	data_len;
+	__u32	cdw10;
+	__u32	cdw11;
+	__u32	cdw12;
+	__u32	cdw13;
+	__u32	cdw14;
+	__u32	cdw15;
+	__u32	timeout_ms;
+	__u32   rsvd2;
+};
+
+#define NVME_URING_CMD_IO	_IOWR('N', 0x80, struct nvme_uring_cmd)
+#define NVME_URING_CMD_IO_VEC	_IOWR('N', 0x81, struct nvme_uring_cmd)
+#endif /* CONFIG_NVME_URING_CMD */
+
+#define NVME_DEFAULT_IOCTL_TIMEOUT 0
+#define NVME_IDENTIFY_DATA_SIZE 4096
+#define NVME_IDENTIFY_CSI_SHIFT 24
+
+enum nvme_identify_cns {
+	NVME_IDENTIFY_CNS_NS = 0x00,
+};
+
+enum nvme_csi {
+	NVME_CSI_NVM			= 0,
+	NVME_CSI_KV			= 1,
+	NVME_CSI_ZNS			= 2,
+};
+
+enum nvme_admin_opcode {
+	nvme_admin_identify		= 0x06,
+};
+
+enum nvme_io_opcode {
+	nvme_cmd_write			= 0x01,
+	nvme_cmd_read			= 0x02,
+};
+
+struct nvme_data {
+	__u32 nsid;
+	__u32 lba_shift;
+};
+
+struct nvme_lbaf {
+	__le16			ms;
+	__u8			ds;
+	__u8			rp;
+};
+
+struct nvme_id_ns {
+	__le64			nsze;
+	__le64			ncap;
+	__le64			nuse;
+	__u8			nsfeat;
+	__u8			nlbaf;
+	__u8			flbas;
+	__u8			mc;
+	__u8			dpc;
+	__u8			dps;
+	__u8			nmic;
+	__u8			rescap;
+	__u8			fpi;
+	__u8			dlfeat;
+	__le16			nawun;
+	__le16			nawupf;
+	__le16			nacwu;
+	__le16			nabsn;
+	__le16			nabo;
+	__le16			nabspf;
+	__le16			noiob;
+	__u8			nvmcap[16];
+	__le16			npwg;
+	__le16			npwa;
+	__le16			npdg;
+	__le16			npda;
+	__le16			nows;
+	__le16			mssrl;
+	__le32			mcl;
+	__u8			msrc;
+	__u8			rsvd81[11];
+	__le32			anagrpid;
+	__u8			rsvd96[3];
+	__u8			nsattr;
+	__le16			nvmsetid;
+	__le16			endgid;
+	__u8			nguid[16];
+	__u8			eui64[8];
+	struct nvme_lbaf	lbaf[16];
+	__u8			rsvd192[192];
+	__u8			vs[3712];
+};
+
+static inline int ilog2(uint32_t i)
+{
+	int log = -1;
+
+	while (i) {
+		i >>= 1;
+		log++;
+	}
+	return log;
+}
+
+int fio_nvme_get_info(struct fio_file *f, __u32 *nsid, __u32 *lba_sz,
+		      __u64 *nlba);
+
+int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
+			    struct iovec *iov);
+
+#endif
-- 
2.17.1

