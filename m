Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B471FC433FE
	for <fio@archiver.kernel.org>; Wed,  1 Jun 2022 09:41:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351195AbiFAJlB (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 1 Jun 2022 05:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351206AbiFAJkv (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 1 Jun 2022 05:40:51 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 854395D1B7
        for <fio@vger.kernel.org>; Wed,  1 Jun 2022 02:40:43 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220601094041epoutp04a6bd0023e9557b7cc306c1a91cbcff51~0dcKZYJvt0801708017epoutp04l
        for <fio@vger.kernel.org>; Wed,  1 Jun 2022 09:40:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220601094041epoutp04a6bd0023e9557b7cc306c1a91cbcff51~0dcKZYJvt0801708017epoutp04l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1654076441;
        bh=HeQ4ur5qEylNngUr30CDANg/IdDkq0PrxMaOCQpni5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mxbp/+UF56RdbJL606E9NllxDdx6RHLXyqbmWTLCak88zzzvjFYXqAoHcSH6cLYcz
         UXh5SU18ZkBevAit4LeC7kuJNcrMYTAwEqTYzm3GnGKj868dfVPhWqMVrJmIj4HXWg
         ZL1b8oCpRcTc4Du1MAczM/D90V31sLJ6jEVQlaTU=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220601094040epcas5p17503637eccab076cb47fe217115e6633~0dcJiz4Yp1928419284epcas5p1h;
        Wed,  1 Jun 2022 09:40:40 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4LCkfF3whQz4x9Px; Wed,  1 Jun
        2022 09:40:37 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        0B.C0.09762.51437926; Wed,  1 Jun 2022 18:40:37 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220531133750epcas5p1602001843ff6971719f2435faf631cf4~0NB7LPNZ61553815538epcas5p10;
        Tue, 31 May 2022 13:37:50 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220531133749epsmtrp1be447a179d83b9d9df59e0c38518b080~0NB7KSUSM2715827158epsmtrp1g;
        Tue, 31 May 2022 13:37:49 +0000 (GMT)
X-AuditID: b6c32a4b-213ff70000002622-92-62973415a86d
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        C9.F4.11276.D2A16926; Tue, 31 May 2022 22:37:49 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220531133748epsmtip2dc97a208430ecd21887de03f56c367ce~0NB6Lvill2552125521epsmtip2u;
        Tue, 31 May 2022 13:37:48 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, krish.reddy@samsung.com, joshi.k@samsung.com,
        anuj20.g@samsung.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v3 8/9] engines/io_uring: Enable zone device support for
 io_uring_cmd I/O engine
Date:   Tue, 31 May 2022 19:01:54 +0530
Message-Id: <20220531133155.17493-9-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220531133155.17493-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLKsWRmVeSWpSXmKPExsWy7bCmpq6oyfQkgy+ThS3WXPnNbtE04S+z
        xeq7/WwWH2e9YLY4+v8tm8XCjcuYHNg8Lp8t9ejbsorR4/MmuQDmqGybjNTElNQihdS85PyU
        zLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKC1SgpliTmlQKGAxOJiJX07m6L8
        0pJUhYz84hJbpdSClJwCkwK94sTc4tK8dL281BIrQwMDI1OgwoTsjIsn5QoexVas7VvH3sA4
        27OLkYNDQsBE4s/c6i5GLg4hgd2MErtvXmKFcD4xSjx+cJ6xi5ETyPnGKPHyLS9MQ+scA4ia
        vYwS/76fhmpoZZL4+/YYK0gDm4C2xKu3N5hBbBEBYYn9Ha0sIEXMAi2MEo2r17KAJIQFkiTW
        T74PVsQioCpxcctmNhCbV8BG4uiurWCbJQTkJVZvOABWwylgKzFv6nqwbRICm9glHq46xQRR
        5CKx7u0ZKFtY4tXxLewQtpTEy/42KDtbovHRXzYIu0Ri563tzBC2vcTFPX+ZQF5jFtCUWL9L
        HyIsKzH11DqwkcwCfBK9v59AjeeV2DEPxlaV+HvvNguELS1x891VFkgIeUgsPxoMCZQJjBKL
        nvxjn8AoNwthwwJGxlWMkqkFxbnpqcWmBcZ5qeXwKEvOz93ECE5XWt47GB89+KB3iJGJg/EQ
        owQHs5IIb8muqUlCvCmJlVWpRfnxRaU5qcWHGE2B4TeRWUo0OR+YMPNK4g1NLA1MzMzMTCyN
        zQyVxHkF/jcmCQmkJ5akZqemFqQWwfQxcXBKNTDF31/ZV3eeK5I5/OitSas+zV13YHqaKKeR
        14aW8OkGM7i81+w8+Vikaee64kQnNvV1t1fMOfjrgkH63APzdc9FWK91VWmfsXB27kKNfDn3
        3QnNatZac/3TMtSite/l8Wwoullf8/SZ9lz2zEmv5nj+EvTl600W0YusODN7zeuiT3MZGJd+
        8WTZq87mxpeXkO4xteG2rY3jdg+WPIuuCQ9SMrYrbzz2VlL3YNnGeynzP8axdCkf/1v4o40h
        Np/52pZexyaDd60qUkE36+sPp3O737F78f95Rcn27dFXJm24EuW55GTesSbb3h0rNl6XeJta
        tT9y25cyQaPffn4pFflf9d/U3Sx8XHudT/qypJYSS3FGoqEWc1FxIgB8cHv44AMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplluLIzCtJLcpLzFFi42LZdlhJXldXalqSwdHHFhZrrvxmt2ia8JfZ
        YvXdfjaLj7NeMFsc/f+WzWLhxmVMDmwel8+WevRtWcXo8XmTXABzFJdNSmpOZllqkb5dAlfG
        xZNyBY9iK9b2rWNvYJzt2cXIwSEhYCLROsegi5GLQ0hgN6PElQvXGSHi0hIL1yd2MXICmcIS
        K/89Z4eoaWaSuPPsGitIgk1AW+LV2xvMILYIUNH+jlYWkCJmgS5GiZ7OU0wgCWGBBImTPyey
        gNgsAqoSF7dsZgOxeQVsJI7u2soIsUFeYvWGA2CDOAVsJeZNXQ+2QAioZuqLBYwTGPkWMDKs
        YpRMLSjOTc8tNiwwzEst1ytOzC0uzUvXS87P3cQIDiktzR2M21d90DvEyMTBeIhRgoNZSYS3
        ZNfUJCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8F7pOxgsJpCeWpGanphakFsFkmTg4pRqY5iUE
        T2A9bsm9MGh11uxlXMevR6iwBZz1SXD9OKXF5+Zuz60vp1zcxdvzwbnov/X7iKavKc6RZfEP
        DFlW7IuvNT5+Irfd5dfmfO4pvQvtN/l+v3SaUWRui7uHdnLxqzVPJx3tZN3quNXl2Qpu44kt
        G21OREinveG7feTxY8bvAScMF03gWLxYUSTpfudj2/wdXAbe2md9U3hWRHDKe27sWFjK8Njc
        f/uzdxuvcer1LLDJbBY8unv1vM+b+GS2NFpI799R4mKdbNQgHPaSe++JMx/OHIyv5j4nbhp3
        yNHL6no2r8q91vWm++L//KruetCfv2VDseCXzNuX9KWrZcJ8D95ax5LBaF4ld2btpP+1SizF
        GYmGWsxFxYkA09fCipgCAAA=
X-CMS-MailID: 20220531133750epcas5p1602001843ff6971719f2435faf631cf4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220531133750epcas5p1602001843ff6971719f2435faf631cf4
References: <20220531133155.17493-1-ankit.kumar@samsung.com>
        <CGME20220531133750epcas5p1602001843ff6971719f2435faf631cf4@epcas5p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Add zone device specific ioengine_ops for io_uring_cmd.
* get_zoned_model
* report_zones
* reset_wp
* get_max_open_zones

Add the necessary NVMe ZNS specfication opcodes and structures. Add
helper functions to submit admin and I/O passthrough commands for these
new NVMe ZNS specific commands.

For write workload iodepth must be set to 1 as there is no IO scheduler

Tested-by: Vincent Fu <vincent.fu@samsung.com>
Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 engines/io_uring.c |  32 ++++++
 engines/nvme.c     | 242 +++++++++++++++++++++++++++++++++++++++++++++
 engines/nvme.h     |  80 ++++++++++++++-
 3 files changed, 353 insertions(+), 1 deletion(-)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index a7b7b166..5a5406d4 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -1164,6 +1164,34 @@ static int fio_ioring_cmd_get_file_size(struct thread_data *td,
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
@@ -1200,6 +1228,10 @@ static struct ioengine_ops ioengine_uring_cmd = {
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
index 6fecf0ba..59550def 100644
--- a/engines/nvme.c
+++ b/engines/nvme.c
@@ -101,3 +101,245 @@ int fio_nvme_get_info(struct fio_file *f, __u32 *nsid, __u32 *lba_sz,
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
+	unsigned int i = 0, j, zones_fetched = 0;
+	unsigned int max_zones, zones_chunks = 1024;
+	int fd, ret = 0;
+	__u32 zr_len;
+	__u64 zlen;
+
+	/* File is not yet opened */
+	fd = open(f->file_name, O_RDONLY | O_LARGEFILE);
+	if (fd < 0)
+		return -errno;
+
+	zones_fetched = 0;
+	zr_len = sizeof(*zr) + (zones_chunks * sizeof(struct nvme_zns_desc));
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
+
+	ret = nvme_identify(fd, data->nsid, NVME_IDENTIFY_CNS_CSI_NS,
+				NVME_CSI_ZNS, &zns_ns);
+	if (ret) {
+		log_err("%s: nvme_zns_identify_ns failed, err=%d\n",
+			f->file_name, ret);
+		goto out;
+	}
+	zlen = zns_ns.lbafe[ns.flbas & 0x0f].zsze << data->lba_shift;
+
+	max_zones = (f->real_file_size - offset) / zlen;
+	if (max_zones < nr_zones)
+		nr_zones = max_zones;
+
+	if (nr_zones < zones_chunks)
+		zones_chunks = nr_zones;
+
+	while (zones_fetched < nr_zones) {
+		if (zones_fetched + zones_chunks >= nr_zones) {
+			zones_chunks = nr_zones - zones_fetched;
+			zr_len = sizeof(*zr) + (zones_chunks * sizeof(struct nvme_zns_desc));
+		}
+		ret = nvme_report_zones(fd, data->nsid, offset >> data->lba_shift,
+					NVME_ZNS_ZRAS_FEAT_ERZ, zr_len, (void *)zr);
+		if (ret) {
+			log_err("%s: nvme_zns_report_zones failed, err=%d\n",
+				f->file_name, ret);
+			goto out;
+		}
+
+		/* Transform the zone-report */
+		for (j = 0; j < zr->nr_zones; j++, i++) {
+			struct nvme_zns_desc *desc = (struct nvme_zns_desc *)&(zr->entries[j]);
+
+			zbdz[i].start = desc->zslba << data->lba_shift;
+			zbdz[i].len = zlen;
+			zbdz[i].wp = desc->wp << data->lba_shift;
+			zbdz[i].capacity = desc->zcap << data->lba_shift;
+
+			/* Zone Type is stored in first 4 bits. */
+			switch (desc->zt & 0x0f) {
+			case NVME_ZONE_TYPE_SEQWRITE_REQ:
+				zbdz[i].type = ZBD_ZONE_TYPE_SWR;
+				break;
+			default:
+				log_err("%s: invalid type for zone at offset %llu.\n",
+					f->file_name, desc->zslba);
+				ret = -EIO;
+				goto out;
+			}
+
+			/* Zone State is stored in last 4 bits. */
+			switch (desc->zs >> 4) {
+			case NVME_ZNS_ZS_EMPTY:
+				zbdz[i].cond = ZBD_ZONE_COND_EMPTY;
+				break;
+			case NVME_ZNS_ZS_IMPL_OPEN:
+				zbdz[i].cond = ZBD_ZONE_COND_IMP_OPEN;
+				break;
+			case NVME_ZNS_ZS_EXPL_OPEN:
+				zbdz[i].cond = ZBD_ZONE_COND_EXP_OPEN;
+				break;
+			case NVME_ZNS_ZS_CLOSED:
+				zbdz[i].cond = ZBD_ZONE_COND_CLOSED;
+				break;
+			case NVME_ZNS_ZS_FULL:
+				zbdz[i].cond = ZBD_ZONE_COND_FULL;
+				break;
+			case NVME_ZNS_ZS_READ_ONLY:
+			case NVME_ZNS_ZS_OFFLINE:
+			default:
+				/* Treat all these conditions as offline (don't use!) */
+				zbdz[i].cond = ZBD_ZONE_COND_OFFLINE;
+				zbdz[i].wp = zbdz[i].start;
+			}
+		}
+		zones_fetched += zr->nr_zones;
+		offset += zr->nr_zones * zlen;
+	}
+
+	ret = zones_fetched;
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
+	unsigned int nr_zones;
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
+	zslba = offset >> data->lba_shift;
+	nr_zones = (length + td->o.zone_size - 1) / td->o.zone_size;
+
+	for (i = 0; i < nr_zones; i++, zslba += (td->o.zone_size >> data->lba_shift)) {
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
index 8e626bb2..70a89b74 100644
--- a/engines/nvme.h
+++ b/engines/nvme.h
@@ -43,8 +43,15 @@ struct nvme_uring_cmd {
 #define NVME_IDENTIFY_DATA_SIZE 4096
 #define NVME_IDENTIFY_CSI_SHIFT 24
 
+#define NVME_ZNS_ZRA_REPORT_ZONES 0
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
@@ -60,6 +67,18 @@ enum nvme_admin_opcode {
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
@@ -127,10 +146,69 @@ static inline int ilog2(uint32_t i)
 	return log;
 }
 
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
 
 int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
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

