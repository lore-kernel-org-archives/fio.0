Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25ED4C433EF
	for <fio@archiver.kernel.org>; Thu, 26 May 2022 16:48:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344914AbiEZQsU (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 26 May 2022 12:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238405AbiEZQsS (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 26 May 2022 12:48:18 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A308A06B
        for <fio@vger.kernel.org>; Thu, 26 May 2022 09:48:16 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220526164811epoutp031016104636beb5328ad5b828630b6189~ytZtL1bTy1491614916epoutp03I
        for <fio@vger.kernel.org>; Thu, 26 May 2022 16:48:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220526164811epoutp031016104636beb5328ad5b828630b6189~ytZtL1bTy1491614916epoutp03I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653583691;
        bh=vl9XBBx50xqKQvSC8ktj/ryTWETPwlbyc0NT2bUz0Vw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S7YT/EjL13n8L4L6C0/g/wSdhEe+rPe7Qs7swaDqcEiKrhRbB2ywbLi+IjQASJ5Ul
         rtpMmVCUTyXUiusjKVdJHEableOWW5rjglEZmyWGTtw3z/fX6p4noOj8WOaxDeggZL
         dgPwE5dOYpT+gnYcLXVZcEzEIH/dEYb98Hh92qvY=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220526164811epcas5p19131890e559847bc010578e46c3aa605~ytZssM4zH1652716527epcas5p1o;
        Thu, 26 May 2022 16:48:11 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4L8DQH3vRWz4x9Pp; Thu, 26 May
        2022 16:48:07 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        8E.61.09762.74FAF826; Fri, 27 May 2022 01:48:07 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220526145400epcas5p348be0238746b1cc70fae627a63a43eba~yr2A1UkXy2998629986epcas5p3i;
        Thu, 26 May 2022 14:54:00 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220526145400epsmtrp1460c528bb53fd282ad742ad429e41134~yr2A0mPbn0379103791epsmtrp1X;
        Thu, 26 May 2022 14:54:00 +0000 (GMT)
X-AuditID: b6c32a4b-1fdff70000002622-e5-628faf478895
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        EF.3E.08924.8849F826; Thu, 26 May 2022 23:54:00 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220526145359epsmtip22ac10712f5085f999a55bab41a66840a~yr1-wRFIL1809618096epsmtip2G;
        Thu, 26 May 2022 14:53:59 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, krish.reddy@samsung.com, joshi.k@samsung.com,
        anuj20.g@samsung.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v2 3/8] nvme: add nvme opcodes, structures and helper
 functions
Date:   Thu, 26 May 2022 20:18:04 +0530
Message-Id: <20220526144809.14877-4-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220526144809.14877-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIKsWRmVeSWpSXmKPExsWy7bCmlq77+v4kg0czZS3WXPnNbtE04S+z
        xeq7/WwWH2e9YLY4+v8tm8XCjcuYHNg8Lp8t9ejbsorR4/MmuQDmqGybjNTElNQihdS85PyU
        zLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKC1SgpliTmlQKGAxOJiJX07m6L8
        0pJUhYz84hJbpdSClJwCkwK94sTc4tK8dL281BIrQwMDI1OgwoTsjHtt71kKTphWTP33mbWB
        sUmri5GTQ0LAROLTjUNMILaQwG5Gie+vbLoYuYDsT4wSu7uPMkM4nxklFk9ZzQjT8e74cXaI
        xC5Gib/TjrJAOK1MEgtuNLODVLEJaEu8enuDGcQWERCW2N/RClbELNDCKNG4ei0LSEJYIFDi
        yb4VYDaLgKrEzkt7wRp4BWwkDi6dxwaxTl5i9YYDYHFOAVuJc7dnsIEMkhDYxC7xqKefFaLI
        ReLozGPMELawxKvjW9ghbCmJl/1tUHa2ROOjv1BDSyR23toOVW8vcXHPX2AIcABdpymxfpc+
        RFhWYuqpdeCAYRbgk+j9/YQJIs4rsWMejK0q8ffebRYIW1ri5rurULaHxP0/k6FhN4FR4uK5
        bywTGOVmIaxYwMi4ilEytaA4Nz212LTAOC+1HB5tyfm5mxjBaUvLewfjowcf9A4xMnEwHmKU
        4GBWEuG98LQ3SYg3JbGyKrUoP76oNCe1+BCjKTAAJzJLiSbnAxNnXkm8oYmlgYmZmZmJpbGZ
        oZI4r8D/xiQhgfTEktTs1NSC1CKYPiYOTqkGpinFpYnLK9bLuBqbTN9nKl/Jw7eb98Xb/OK7
        B61yxfYvl3jZ7mp5aObJWSpn2Yubn1bI1R6fp5LSb3dNRXC/g+vzUxX/VNcysLsuEOAMa1Le
        LKp2WiKiOcnxbk/Y2dbp11JuCfqqnjB+nC/NdPuBm+PMK/4fhZeYbN3S/W+nbNY55Q8fjqxt
        PnPERMGtS9nkz8Qn5bHKtievTI8vmdVi0FfoPnGKWeuE3RICtfbL/dfqls99nuY+bX+X6WYX
        h+hl5svnK92OsVw3QW7qiaWOz32Drqa53/tsv0yTfcHfjBu+Fos4Xiw+6h2X+jY88/Jfy4aL
        FiyhK7fJaYmemdF5Z9pdX8+o0Cau0D/pu2dFKbEUZyQaajEXFScCAE12E8TkAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnluLIzCtJLcpLzFFi42LZdlhJXrdjSn+SweyLBhZrrvxmt2ia8JfZ
        YvXdfjaLj7NeMFsc/f+WzWLhxmVMDmwel8+WevRtWcXo8XmTXABzFJdNSmpOZllqkb5dAlfG
        vbb3LAUnTCum/vvM2sDYpNXFyMkhIWAi8e74cfYuRi4OIYEdjBLrVrWxdDFyACWkJRauT4So
        EZZY+e85VE0zk8SKta+ZQRJsAtoSr97eALNFgIr2d7SygBQxC3QxSvR0nmICSQgL+EvsXHiQ
        BcRmEVCV2HlpL1gDr4CNxMGl89ggNshLrN5wACzOKWArce72DLC4EFDNv30XmSYw8i1gZFjF
        KJlaUJybnltsWGCUl1quV5yYW1yal66XnJ+7iREcVlpaOxj3rPqgd4iRiYPxEKMEB7OSCO+F
        p71JQrwpiZVVqUX58UWlOanFhxilOViUxHkvdJ2MFxJITyxJzU5NLUgtgskycXBKNTDJTfa/
        HdAUHPFf3+O18IIT09Zqnc3lFl7YG2Wu4/gx+3/y/pOlq4yVn7/Prjye+aG6WoL5uo1q+99p
        J9bZ/V8ReaQxazb7j5ZPM2O3m3Y3/Vvw4mZQ2dxplmu+H9sRGrLz8qPbdyeseRB3cdde/ob1
        RXK1tfkqS+Mqr85XXtzxfU3FBu+qNW1Tz1269eXN5sgV14uUEvikXz14IHxhjkPV7MM3f21e
        acn3qNImx5VpA7t9XZrzguZ1JwSvr49vqRBoXvXgTvYTVzVeyVAJu3//ne0TSr0+fOVOu3Zp
        wpLIJP6iu/YXw+QitDdzdb7+vbvHSX5uiusmxz3sk9e1K2obmibtWjzlFZ8C261FdYmOSizF
        GYmGWsxFxYkA/u+zBpoCAAA=
X-CMS-MailID: 20220526145400epcas5p348be0238746b1cc70fae627a63a43eba
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220526145400epcas5p348be0238746b1cc70fae627a63a43eba
References: <20220526144809.14877-1-ankit.kumar@samsung.com>
        <CGME20220526145400epcas5p348be0238746b1cc70fae627a63a43eba@epcas5p3.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Add NVMe specification opcodes, data structures and helper
functions to get identify namespace and form nvme uring command.

This will help the follow up patches to get nvme-ns generic
charcter device size, lba size.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
Co-authored-by: Anuj Gupta <anuj20.g@samsung.com>
---
 Makefile       |   4 +-
 engines/nvme.c | 100 +++++++++++++++++++++++++++++++++++++++
 engines/nvme.h | 125 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 227 insertions(+), 2 deletions(-)
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
index 00000000..296a7e09
--- /dev/null
+++ b/engines/nvme.c
@@ -0,0 +1,100 @@
+/*
+ * nvme structure declarations and helper functions for the
+ * io_uring_cmd engine.
+ */
+
+#include "nvme.h"
+
+void fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
+			     struct iovec *iov)
+{
+	struct nvme_data *data = FILE_ENG_DATA(io_u->file);
+	__u64 slba;
+	__u32 nlb;
+
+	slba = io_u->offset / data->lba_size;
+	nlb = (io_u->xfer_buflen / data->lba_size) - 1;
+
+	memset(cmd, 0, sizeof(struct nvme_uring_cmd));
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
+
+	if (io_u->ddir == DDIR_READ)
+		cmd->opcode = nvme_cmd_read;
+	if (io_u->ddir == DDIR_WRITE)
+		cmd->opcode = nvme_cmd_write;
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
index 00000000..702e230e
--- /dev/null
+++ b/engines/nvme.h
@@ -0,0 +1,125 @@
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
+	__u32 lba_size;
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
+int fio_nvme_get_info(struct fio_file *f, __u32 *nsid, __u32 *lba_sz,
+		      __u64 *nlba);
+
+void fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
+			     struct iovec *iov);
+
+#endif
-- 
2.17.1

