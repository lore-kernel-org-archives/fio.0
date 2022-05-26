Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D055C433F5
	for <fio@archiver.kernel.org>; Thu, 26 May 2022 16:48:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242586AbiEZQsl (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 26 May 2022 12:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348191AbiEZQsl (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 26 May 2022 12:48:41 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A1EC636B
        for <fio@vger.kernel.org>; Thu, 26 May 2022 09:48:39 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220526164837epoutp03e3b98a0d47eee90f1ad6d0d78cc50c9b~ytaFaxCQd1093910939epoutp03t
        for <fio@vger.kernel.org>; Thu, 26 May 2022 16:48:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220526164837epoutp03e3b98a0d47eee90f1ad6d0d78cc50c9b~ytaFaxCQd1093910939epoutp03t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653583717;
        bh=AJYGijpJ2lI9AbhvXe3wqVffvGcx8y0m/ZC/2YIYUbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AsDwWhWwVaAwsvg4GMzOkRPRwPLpxroNu/CxSmVvYIbCWRJQfAQZG8tW7sUqs6eaq
         IwXCFTFZlPQ9JdVb1NM9/3hKKg1b6OvxcVuaDw/hJ83SbkLOIrkQQO6jsuXMT79fp8
         1tWqKCfmx4kH6GrLNfSxUD8t/HVIunHr3v4e93Os=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220526164837epcas5p38237040cb203b7b77a67df3f0697a5e4~ytaEt1kyb0670406704epcas5p3O;
        Thu, 26 May 2022 16:48:37 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4L8DQn33Rtz4x9Pq; Thu, 26 May
        2022 16:48:33 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E8.BC.10063.16FAF826; Fri, 27 May 2022 01:48:33 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220526145405epcas5p178fdf7c65f0682369617459e5c2abe51~yr2FQew4y0329003290epcas5p1E;
        Thu, 26 May 2022 14:54:05 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220526145405epsmtrp240be694aa5d0ce224f858eace6619eb8~yr2FPx96L1450114501epsmtrp29;
        Thu, 26 May 2022 14:54:05 +0000 (GMT)
X-AuditID: b6c32a49-4b5ff7000000274f-e5-628faf617715
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        26.93.11276.D849F826; Thu, 26 May 2022 23:54:05 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220526145404epsmtip2f6f81f4a6266a4cc9400d93de7111285~yr2EMrf721808418084epsmtip2I;
        Thu, 26 May 2022 14:54:04 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, krish.reddy@samsung.com, joshi.k@samsung.com,
        anuj20.g@samsung.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v2 7/8] engines/io_uring: Enable zone device support for
 io_uring_cmd I/O engine
Date:   Thu, 26 May 2022 20:18:08 +0530
Message-Id: <20220526144809.14877-8-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220526144809.14877-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLKsWRmVeSWpSXmKPExsWy7bCmlm7i+v4kg8fvRC3WXPnNbtE04S+z
        xeq7/WwWH2e9YLY4+v8tm8XCjcuYHNg8Lp8t9ejbsorR4/MmuQDmqGybjNTElNQihdS85PyU
        zLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKC1SgpliTmlQKGAxOJiJX07m6L8
        0pJUhYz84hJbpdSClJwCkwK94sTc4tK8dL281BIrQwMDI1OgwoTsjM9/H7AUrIyuODRjEksD
        4wH3LkZODgkBE4krWy+wdjFycQgJ7GaUWLdtPzuE84lR4tXBZjaQKiGBb4wSx9YpwHT8e3YP
        qmgvo8TztvlMEE4rk8Sb2a2MIFVsAtoSr97eYAaxRQSEJfZ3tLKAFDELtDBKNK5eywKSEBZI
        kphzbAdQAzsHi4CqxBUZkCivgI3E/B/X2SGWyUus3nAAbAyngK3Eudsz2EDGSAhsYpfYsbIL
        aDEHkOMicXSxNkS9sMSr41ugeqUkPr/bywZhZ0s0PvoLZZdI7Ly1nRnCtpe4uOcv2BhmAU2J
        9bv0IcKyElNPrWMCsZkF+CR6fz9hgojzSuyYB2OrSvy9d5sFwpaWuPnuKgvENR4S34/LQ0Jk
        AqNEy7QDzBMY5WYhbFjAyLiKUTK1oDg3PbXYtMAwL7UcHmXJ+bmbGMHpSstzB+PdBx/0DjEy
        cTAeYpTgYFYS4b3wtDdJiDclsbIqtSg/vqg0J7X4EKMpMPAmMkuJJucDE2ZeSbyhiaWBiZmZ
        mYmlsZmhkjivwP/GJCGB9MSS1OzU1ILUIpg+Jg5OqQamDF6TSSl3tXewXvx3xVxxy75QFcf1
        PrIH7Y231gU0zHvoorzoXZHi+sCJvpP3rH9euzRGfeekixd4Hy3oCzp2ZL/xfIUbB3RmVcrl
        fOK6yZuyJf3Yl4mcS/8IdJwz6t0/532Fl+2FfD+NjojP2UfuiG3gkqrhOrbp+uxZF0Rub9/1
        eC9zseGRKxknm54oreEuExd9l3exSPfelWdphisX/vpz102lSf9E55s/LKVnzV0kp2//ckxZ
        4qD19UO+QluVcgS3f2a9J5r8e1LsxtKsSe9cns/Le6v/mDnD3nD3Q3+eg8vP6zEU9FveaEsM
        eRU/4V3qW56N6g2z++JPX+xq+WNu1rVu64GXRg2XRNwC/iuxFGckGmoxFxUnAgDM6uss4AMA
        AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphluLIzCtJLcpLzFFi42LZdlhJXrd3Sn+SwfWrihZrrvxmt2ia8JfZ
        YvXdfjaLj7NeMFsc/f+WzWLhxmVMDmwel8+WevRtWcXo8XmTXABzFJdNSmpOZllqkb5dAlfG
        578PWApWRlccmjGJpYHxgHsXIyeHhICJxL9n99hBbCGB3YwSN1qCuhg5gOLSEgvXJ0KUCEus
        /PccqIQLqKSZSWLFwwfMIAk2AW2JV29vgNkiQEX7O1pZQIqYBboYJXo6TzGBJIQFEiRWdf4H
        SrBzsAioSlyRAYnyCthIzP9xnR1ivrzE6g0HwMZwCthKnLs9gw3iHBuJf/suMk1g5FvAyLCK
        UTK1oDg3PbfYsMAwL7Vcrzgxt7g0L10vOT93EyM4oLQ0dzBuX/VB7xAjEwfjIUYJDmYlEd4L
        T3uThHhTEiurUovy44tKc1KLDzFKc7AoifNe6DoZLySQnliSmp2aWpBaBJNl4uCUamCqDUm9
        5T1PWdnKsUq9L3z+O/uPPzM98hfIuQmuX/7ArNd5zYSAVZu1cwWaP+iv19p3tepE0gT/m/d6
        ZpXxV0+yvPzksNutM3+PJ68MEf4kttpm/t8ob6+MpWGLnn62yLvlfV+WYyHTQcmVzn0u7D2J
        Z3k9U3c3ln7UWdJ4Pmjexl/b83gexJ18rhDPWDPnwOMbxpckywM3n5n/+2qyXGT0gVfH/sws
        C0z3nqQ/JyZtd8w/Rm/XxaJOsvGZF4XOJ3E8y+tcFcNtLmxy2f7x/TmmJVVl+r7B2iwnec0e
        /vCN22716gzf1Cm7nDY1lEg5Oaes3V1keNf/h6jRCl6tCgc7XmbFSwLz6yJNt97lTVBiKc5I
        NNRiLipOBABf3tDPlwIAAA==
X-CMS-MailID: 20220526145405epcas5p178fdf7c65f0682369617459e5c2abe51
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220526145405epcas5p178fdf7c65f0682369617459e5c2abe51
References: <20220526144809.14877-1-ankit.kumar@samsung.com>
        <CGME20220526145405epcas5p178fdf7c65f0682369617459e5c2abe51@epcas5p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Add zone device specific ioengine_ops for io_uring_cmd.
* get_zoned_model
* report_zones
* reset_wp
* get_max_open_zones

Add the necessary NVMe ZNS specfication opcodes and strcutures. Add
helper functions to submit admin and I/O passthrough commands for these
new NVMe ZNS specific commands.

For write workload iodepth must be set to 1 as there is no IO scheduler

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 engines/io_uring.c |  32 ++++++
 engines/nvme.c     | 238 +++++++++++++++++++++++++++++++++++++++++++++
 engines/nvme.h     |  81 ++++++++++++++-
 3 files changed, 350 insertions(+), 1 deletion(-)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 2088ac47..2457a7a3 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -1150,6 +1150,34 @@ static int fio_ioring_cmd_get_file_size(struct thread_data *td,
 	return generic_get_file_size(td, f);
 }
 
+static int fio_ioring_cmd_get_zoned_model(struct thread_data *td,
+					  struct fio_file *f,
+					  enum zbd_zoned_model *model)
+{
+	return fio_nvme_get_zoned_model(td, f, model);
+}
+
+static int fio_ioring_cmd_report_zones(struct thread_data *td,
+				       struct fio_file *f, uint64_t offset,
+				       struct zbd_zone *zbdz,
+				       unsigned int nr_zones)
+{
+	return fio_nvme_report_zones(td, f, offset, zbdz, nr_zones);
+}
+
+static int fio_ioring_cmd_reset_wp(struct thread_data *td, struct fio_file *f,
+				   uint64_t offset, uint64_t length)
+{
+	return fio_nvme_reset_wp(td, f, offset, length);
+}
+
+static int fio_ioring_cmd_get_max_open_zones(struct thread_data *td,
+					     struct fio_file *f,
+					     unsigned int *max_open_zones)
+{
+	return fio_nvme_get_max_open_zones(td, f, max_open_zones);
+}
+
 static struct ioengine_ops ioengine_uring = {
 	.name			= "io_uring",
 	.version		= FIO_IOOPS_VERSION,
@@ -1186,6 +1214,10 @@ static struct ioengine_ops ioengine_uring_cmd = {
 	.open_file		= fio_ioring_cmd_open_file,
 	.close_file		= fio_ioring_cmd_close_file,
 	.get_file_size		= fio_ioring_cmd_get_file_size,
+	.get_zoned_model	= fio_ioring_cmd_get_zoned_model,
+	.report_zones		= fio_ioring_cmd_report_zones,
+	.reset_wp		= fio_ioring_cmd_reset_wp,
+	.get_max_open_zones	= fio_ioring_cmd_get_max_open_zones,
 	.options		= options,
 	.option_struct_size	= sizeof(struct ioring_options),
 };
diff --git a/engines/nvme.c b/engines/nvme.c
index 296a7e09..20b16eba 100644
--- a/engines/nvme.c
+++ b/engines/nvme.c
@@ -98,3 +98,241 @@ int fio_nvme_get_info(struct fio_file *f, __u32 *nsid, __u32 *lba_sz,
 	close(fd);
 	return 0;
 }
+
+int fio_nvme_get_zoned_model(struct thread_data *td, struct fio_file *f,
+			     enum zbd_zoned_model *model)
+{
+	struct nvme_data *data = FILE_ENG_DATA(f);
+	struct nvme_id_ns ns;
+	struct nvme_passthru_cmd cmd;
+	int fd, ret = 0;
+
+	if (f->filetype != FIO_TYPE_CHAR)
+		return -EINVAL;
+
+	/* File is not yet opened */
+	fd = open(f->file_name, O_RDONLY | O_LARGEFILE);
+	if (fd < 0)
+		return -errno;
+
+	/* Using nvme_id_ns for data as sizes are same */
+	ret = nvme_identify(fd, data->nsid, NVME_IDENTIFY_CNS_CSI_CTRL,
+				NVME_CSI_ZNS, &ns);
+	if (ret) {
+		*model = ZBD_NONE;
+		goto out;
+	}
+
+	memset(&cmd, 0, sizeof(struct nvme_passthru_cmd));
+
+	/* Using nvme_id_ns for data as sizes are same */
+	ret = nvme_identify(fd, data->nsid, NVME_IDENTIFY_CNS_CSI_NS,
+				NVME_CSI_ZNS, &ns);
+	if (ret) {
+		*model = ZBD_NONE;
+		goto out;
+	}
+
+	*model = ZBD_HOST_MANAGED;
+out:
+	close(fd);
+	return 0;
+}
+
+static int nvme_report_zones(int fd, __u32 nsid, __u64 slba, __u32 zras_feat,
+			     __u32 data_len, void *data)
+{
+	struct nvme_passthru_cmd cmd = {
+		.opcode         = nvme_zns_cmd_mgmt_recv,
+		.nsid           = nsid,
+		.addr           = (__u64)(uintptr_t)data,
+		.data_len       = data_len,
+		.cdw10          = slba & 0xffffffff,
+		.cdw11          = slba >> 32,
+		.cdw12		= (data_len >> 2) - 1,
+		.cdw13		= NVME_ZNS_ZRA_REPORT_ZONES | zras_feat,
+		.timeout_ms     = NVME_DEFAULT_IOCTL_TIMEOUT,
+	};
+
+	return ioctl(fd, NVME_IOCTL_IO_CMD, &cmd);
+}
+
+int fio_nvme_report_zones(struct thread_data *td, struct fio_file *f,
+			  uint64_t offset, struct zbd_zone *zbdz,
+			  unsigned int nr_zones)
+{
+	struct nvme_data *data = FILE_ENG_DATA(f);
+	struct nvme_zone_report *zr;
+	struct nvme_zns_id_ns zns_ns;
+	struct nvme_id_ns ns;
+	unsigned int i, lba_size;
+	int fd, ret = 0;
+	int zr_len;
+
+	/* File is not yet opened */
+	fd = open(f->file_name, O_RDONLY | O_LARGEFILE);
+	if (fd < 0)
+		return -errno;
+
+	zr_len = sizeof(*zr);
+	zr = calloc(1, zr_len);
+	if (!zr)
+		return -ENOMEM;
+
+	ret = nvme_identify(fd, data->nsid, NVME_IDENTIFY_CNS_NS,
+				NVME_CSI_NVM, &ns);
+	if (ret) {
+		log_err("%s: nvme_identify_ns failed, err=%d\n", f->file_name,
+			ret);
+		goto out;
+	}
+	lba_size = data->lba_size;
+
+	ret = nvme_report_zones(fd, data->nsid, offset / lba_size,
+				NVME_ZNS_ZRAS_FEAT_RZ, zr_len, (void *)zr);
+	if (ret) {
+		log_err("%s: nvme_zns_report_zones failed, err=%d\n",
+			f->file_name, ret);
+		goto out;
+	}
+	nr_zones = zr->nr_zones;
+
+	ret = nvme_identify(fd, data->nsid, NVME_IDENTIFY_CNS_CSI_NS,
+				NVME_CSI_ZNS, &zns_ns);
+	if (ret) {
+		log_err("%s: nvme_zns_identify_ns failed, err=%d\n",
+			f->file_name, ret);
+		goto out;
+	}
+
+	zr_len = sizeof(*zr) + (nr_zones * sizeof(struct nvme_zns_desc));
+	zr = realloc(zr, zr_len);
+	memset(zr, 0, zr_len);
+
+	ret = nvme_report_zones(fd, data->nsid, offset / lba_size,
+				NVME_ZNS_ZRAS_FEAT_ERZ, zr_len, (void *)zr);
+	if (ret) {
+		log_err("%s: nvme_zns_report_zones failed, err=%d\n",
+			f->file_name, ret);
+		goto out;
+	}
+
+	/* Transform the zone-report */
+	for (i = 0; i < zr->nr_zones; i++) {
+		struct nvme_zns_desc *desc = (struct nvme_zns_desc *)&(zr->entries[i]);
+
+		zbdz[i].start = desc->zslba * lba_size;
+		zbdz[i].len = zns_ns.lbafe[ns.flbas & 0x0f].zsze * lba_size;
+		zbdz[i].wp = desc->wp * lba_size;
+		zbdz[i].capacity = desc->zcap * lba_size;
+
+		/* Zone Type is stored in first 4 bits. */
+		switch (desc->zt & 0x0f) {
+		case NVME_ZONE_TYPE_SEQWRITE_REQ:
+			zbdz[i].type = ZBD_ZONE_TYPE_SWR;
+			break;
+		default:
+			log_err("%s: invalid type for zone at offset %llu.\n",
+				f->file_name, desc->zslba);
+			ret = -EIO;
+			goto out;
+		}
+
+		/* Zone State is stored in last 4 bits. */
+		switch (desc->zs >> 4) {
+		case NVME_ZNS_ZS_EMPTY:
+			zbdz[i].cond = ZBD_ZONE_COND_EMPTY;
+			break;
+		case NVME_ZNS_ZS_IMPL_OPEN:
+			zbdz[i].cond = ZBD_ZONE_COND_IMP_OPEN;
+			break;
+		case NVME_ZNS_ZS_EXPL_OPEN:
+			zbdz[i].cond = ZBD_ZONE_COND_EXP_OPEN;
+			break;
+		case NVME_ZNS_ZS_CLOSED:
+			zbdz[i].cond = ZBD_ZONE_COND_CLOSED;
+			break;
+		case NVME_ZNS_ZS_FULL:
+			zbdz[i].cond = ZBD_ZONE_COND_FULL;
+			break;
+		case NVME_ZNS_ZS_READ_ONLY:
+		case NVME_ZNS_ZS_OFFLINE:
+		default:
+			/* Treat all these conditions as offline (don't use!) */
+			zbdz[i].cond = ZBD_ZONE_COND_OFFLINE;
+			zbdz[i].wp = zbdz[i].start;
+		}
+	}
+
+	ret = zr->nr_zones;
+out:
+	free(zr);
+	close(fd);
+
+	return ret;
+}
+
+int fio_nvme_reset_wp(struct thread_data *td, struct fio_file *f,
+		      uint64_t offset, uint64_t length)
+{
+	struct nvme_data *data = FILE_ENG_DATA(f);
+	unsigned int nr_zones, lba_size;
+	unsigned long long zslba;
+	int i, fd, ret = 0;
+
+	/* If the file is not yet opened, open it for this function. */
+	fd = f->fd;
+	if (fd < 0) {
+		fd = open(f->file_name, O_RDWR | O_LARGEFILE);
+		if (fd < 0)
+			return -errno;
+	}
+
+	lba_size = data->lba_size;
+	zslba = offset / lba_size;
+	nr_zones = (length + td->o.zone_size - 1) / td->o.zone_size;
+
+	for (i = 0; i < nr_zones; i++, zslba += (td->o.zone_size / lba_size)) {
+		struct nvme_passthru_cmd cmd = {
+			.opcode         = nvme_zns_cmd_mgmt_send,
+			.nsid           = data->nsid,
+			.cdw10          = zslba & 0xffffffff,
+			.cdw11          = zslba >> 32,
+			.cdw13          = NVME_ZNS_ZSA_RESET,
+			.addr           = (__u64)(uintptr_t)NULL,
+			.data_len       = 0,
+			.timeout_ms     = NVME_DEFAULT_IOCTL_TIMEOUT,
+		};
+
+		ret = ioctl(fd, NVME_IOCTL_IO_CMD, &cmd);
+	}
+
+	if (f->fd < 0)
+		close(fd);
+	return -ret;
+}
+
+int fio_nvme_get_max_open_zones(struct thread_data *td, struct fio_file *f,
+				unsigned int *max_open_zones)
+{
+	struct nvme_data *data = FILE_ENG_DATA(f);
+	struct nvme_zns_id_ns zns_ns;
+	int fd, ret = 0;
+
+	fd = open(f->file_name, O_RDONLY | O_LARGEFILE);
+	if (fd < 0)
+		return -errno;
+
+	ret = nvme_identify(fd, data->nsid, NVME_IDENTIFY_CNS_CSI_NS,
+				NVME_CSI_ZNS, &zns_ns);
+	if (ret) {
+		log_err("%s: nvme_zns_identify_ns failed, err=%d\n",
+			f->file_name, ret);
+		goto out;
+	}
+
+	*max_open_zones = zns_ns.mor + 1;
+out:
+	close(fd);
+	return ret;
+}
diff --git a/engines/nvme.h b/engines/nvme.h
index 702e230e..6134292e 100644
--- a/engines/nvme.h
+++ b/engines/nvme.h
@@ -43,8 +43,16 @@ struct nvme_uring_cmd {
 #define NVME_IDENTIFY_DATA_SIZE 4096
 #define NVME_IDENTIFY_CSI_SHIFT 24
 
+#define NVME_ZNS_ZRA_REPORT_ZONES 0
+#define NVME_ZNS_ZRAS_FEAT_RZ 0
+#define NVME_ZNS_ZRAS_FEAT_ERZ (1 << 16)
+#define NVME_ZNS_ZSA_RESET 0x4
+#define NVME_ZONE_TYPE_SEQWRITE_REQ 0x2
+
 enum nvme_identify_cns {
-	NVME_IDENTIFY_CNS_NS = 0x00,
+	NVME_IDENTIFY_CNS_NS		= 0x00,
+	NVME_IDENTIFY_CNS_CSI_NS	= 0x05,
+	NVME_IDENTIFY_CNS_CSI_CTRL	= 0x06,
 };
 
 enum nvme_csi {
@@ -60,6 +68,18 @@ enum nvme_admin_opcode {
 enum nvme_io_opcode {
 	nvme_cmd_write			= 0x01,
 	nvme_cmd_read			= 0x02,
+	nvme_zns_cmd_mgmt_send		= 0x79,
+	nvme_zns_cmd_mgmt_recv		= 0x7a,
+};
+
+enum nvme_zns_zs {
+	NVME_ZNS_ZS_EMPTY		= 0x1,
+	NVME_ZNS_ZS_IMPL_OPEN		= 0x2,
+	NVME_ZNS_ZS_EXPL_OPEN		= 0x3,
+	NVME_ZNS_ZS_CLOSED		= 0x4,
+	NVME_ZNS_ZS_READ_ONLY		= 0xd,
+	NVME_ZNS_ZS_FULL		= 0xe,
+	NVME_ZNS_ZS_OFFLINE		= 0xf,
 };
 
 struct nvme_data {
@@ -116,10 +136,69 @@ struct nvme_id_ns {
 	__u8			vs[3712];
 };
 
+struct nvme_zns_lbafe {
+	__le64	zsze;
+	__u8	zdes;
+	__u8	rsvd9[7];
+};
+
+struct nvme_zns_id_ns {
+	__le16			zoc;
+	__le16			ozcs;
+	__le32			mar;
+	__le32			mor;
+	__le32			rrl;
+	__le32			frl;
+	__le32			rrl1;
+	__le32			rrl2;
+	__le32			rrl3;
+	__le32			frl1;
+	__le32			frl2;
+	__le32			frl3;
+	__le32			numzrwa;
+	__le16			zrwafg;
+	__le16			zrwasz;
+	__u8			zrwacap;
+	__u8			rsvd53[2763];
+	struct nvme_zns_lbafe	lbafe[64];
+	__u8			vs[256];
+};
+
+struct nvme_zns_desc {
+	__u8	zt;
+	__u8	zs;
+	__u8	za;
+	__u8	zai;
+	__u8	rsvd4[4];
+	__le64	zcap;
+	__le64	zslba;
+	__le64	wp;
+	__u8	rsvd32[32];
+};
+
+struct nvme_zone_report {
+	__le64			nr_zones;
+	__u8			rsvd8[56];
+	struct nvme_zns_desc	entries[];
+};
+
 int fio_nvme_get_info(struct fio_file *f, __u32 *nsid, __u32 *lba_sz,
 		      __u64 *nlba);
 
 void fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 			     struct iovec *iov);
 
+int fio_nvme_get_zoned_model(struct thread_data *td, struct fio_file *f,
+			     enum zbd_zoned_model *model);
+
+int fio_nvme_report_zones(struct thread_data *td, struct fio_file *f,
+			  uint64_t offset, struct zbd_zone *zbdz,
+			  unsigned int nr_zones);
+
+int fio_nvme_reset_wp(struct thread_data *td, struct fio_file *f,
+		      uint64_t offset, uint64_t length);
+
+int fio_nvme_get_max_open_zones(struct thread_data *td, struct fio_file *f,
+				unsigned int *max_open_zones);
+
 #endif
-- 
2.17.1

