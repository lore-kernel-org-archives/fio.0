Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2178EC433F5
	for <fio@archiver.kernel.org>; Mon, 23 May 2022 16:29:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238699AbiEWQ31 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 23 May 2022 12:29:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238791AbiEWQ3Z (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 23 May 2022 12:29:25 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1848368F8E
        for <fio@vger.kernel.org>; Mon, 23 May 2022 09:29:24 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220523162922epoutp0471413283e39f2722096914eb837889f2~xyNafkoXX0888808888epoutp04l
        for <fio@vger.kernel.org>; Mon, 23 May 2022 16:29:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220523162922epoutp0471413283e39f2722096914eb837889f2~xyNafkoXX0888808888epoutp04l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653323362;
        bh=r/Tsb/aC01IeIiolGWPiYiQexfGSCTqAsuB7wIidDww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oLw1CadV/ewlYIVH5q/FU6pvi1kO9Q9v6EBlx6gYHp1ZgFUSV3fcQ8qYr4RORiZD1
         TbjFwh+wByvGBAoof+7evBk+zwLLE38/fg6yTjgzAJmaq2CYHvlbWoKC22VHM3xVfZ
         dqOzyPPXndgQlubkPIN2JGYOlO54FuuoPWrwAZpk=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220523162921epcas5p315ec71cb9d0ef555edf4762549788c90~xyNZexSJp0505105051epcas5p37;
        Mon, 23 May 2022 16:29:21 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4L6N7y4pBGz4x9Pt; Mon, 23 May
        2022 16:29:18 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        05.B9.10063.E56BB826; Tue, 24 May 2022 01:29:18 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220523131626epcas5p271c6ec917cc65ce1fcfd784c3757597c~xvk9xP9m_0493104931epcas5p2M;
        Mon, 23 May 2022 13:16:26 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220523131626epsmtrp1026e6f1bc903cba0c0bd091db6190fbb~xvk9wkcoe2128021280epsmtrp15;
        Mon, 23 May 2022 13:16:26 +0000 (GMT)
X-AuditID: b6c32a49-4b5ff7000000274f-5a-628bb65e6e61
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        38.6D.08924.A298B826; Mon, 23 May 2022 22:16:26 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220523131625epsmtip289b0ae94c01caf7f48b990844f0cb307~xvk8xRLfw1953619536epsmtip2d;
        Mon, 23 May 2022 13:16:25 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, krish.reddy@samsung.com, joshi.k@samsung.com,
        anuj20.g@samsung.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 6/7] engines/io_uring: Enable zone device support for
 io_uring_cmd I/O engine
Date:   Mon, 23 May 2022 18:40:38 +0530
Message-Id: <20220523131039.17697-7-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220523131039.17697-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPKsWRmVeSWpSXmKPExsWy7bCmum7ctu4kg7X7FS3WXPnNbtE04S+z
        xeq7/WwWH2e9YLY4+v8tm8XCjcuYHNg8Lp8t9ejbsorR4/MmuQDmqGybjNTElNQihdS85PyU
        zLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKC1SgpliTmlQKGAxOJiJX07m6L8
        0pJUhYz84hJbpdSClJwCkwK94sTc4tK8dL281BIrQwMDI1OgwoTsjPvPJzEVPDCvOD95JksD
        4wTtLkZODgkBE4llF1YxdzFycQgJ7GaUePB3OTtIQkjgE6PErptlEInPjBJbfz1igum4c+sz
        VNEuRolNHwQg7FYmiRmri0BsNgFtiVdvbzCD2CICwhL7O1pZQAYxC7QwSjSuXssCkhAWiJdo
        f7gDbBCLgKrE98PPwRp4BWwk1r1dww6xTF5i9YYDYHFOAVuJOx/+gZ0qIbCNXeL54x2MEEUu
        EhOXLmGDsIUlXh3fAtUsJfGyvw3KzpZofPQXqqZEYuet7cwQtr3ExT1/gT7jALpOU2L9Ln2I
        sKzE1FPrwB5mFuCT6P39BOp5Xokd82BsVYm/926zQNjSEjffXYWyPSTuHL/ICAm5CYwSOxa2
        M01glJuFsGIBI+MqRsnUguLc9NRi0wLDvNRyeKQl5+duYgSnLC3PHYx3H3zQO8TIxMF4iFGC
        g1lJhHd7YkeSEG9KYmVValF+fFFpTmrxIUZTYABOZJYSTc4HJs28knhDE0sDEzMzMxNLYzND
        JXFegf+NSUIC6YklqdmpqQWpRTB9TBycUg1Mbf0vt35auPKqaYCFD3eTlZR16oqJL7P9JVpe
        9HmxvvnOoBagYpysfuuyilRCNtPByRKKB/VD39dZ/3yfEbeb5dqBWoNDYqVhZ/6c/xw+83ZI
        3QFNFe+m7X6xMy3mlDfcLv2ilX7f0oz56FtGkR0iCSbH/D9FXGDWO3X44C+zC4p2G0zrOC5y
        bcm+blS/9emsLSxdV9dJp35KeyDlq5M7OYthsthcpp/sJy4L/8nUmOFfKqr/SPFezvGWJG8W
        8Z86fw0NHM5euvng2ArF57NElln3f9Q+uV+hbZfY5ENrdl3atuny/IiZgisXy7fLmlxTkjgn
        J7yQq/ZvpYX+BuGrnidEoniOLa4/3/fCNP2QEktxRqKhFnNRcSIAolIeMOIDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjluLIzCtJLcpLzFFi42LZdlhJXlerszvJ4MoTBYs1V36zWzRN+Mts
        sfpuP5vFx1kvmC2O/n/LZrFw4zImBzaPy2dLPfq2rGL0+LxJLoA5issmJTUnsyy1SN8ugSvj
        /vNJTAUPzCvOT57J0sA4QbuLkZNDQsBE4s6tz+xdjFwcQgI7GCVOdx9h6mLkAEpISyxcnwhR
        Iyyx8t9zqJpmJolb70+xgiTYBLQlXr29wQxiiwAV7e9oZQEpYhboYpTo6TzFBJIQFoiVWNI5
        HayIRUBV4vvh52A2r4CNxLq3a9ghNshLrN5wACzOKWArcefDP2aQI4SAanb8CJnAyLeAkWEV
        o2RqQXFuem6xYYFRXmq5XnFibnFpXrpecn7uJkZwUGlp7WDcs+qD3iFGJg7GQ4wSHMxKIrzb
        EzuShHhTEiurUovy44tKc1KLDzFKc7AoifNe6DoZLySQnliSmp2aWpBaBJNl4uCUamDKZLOc
        sef6+73xPuxfj2z4Vu895e2EeL2PHDMYOxPXBT2X7fE+elb3XX93xYsVnyt/aK05Jp/5KFz3
        unhyXmKISAjHlq69zkfedTbL/Q67foPD94H/Xu2Pm2WS1rSVr5fTm/Joe/VzvvAHq3RyZd9a
        xu22s5+/fjcnF/vZezN/M23dfunUBuEtCwxmLO0U+qS4xvRh6ZN9nhKfC5YbrP69r+dxe+aB
        q+uFgn8/+iD4SWDxLvv9s0L/KvyNPuiXfati2tvi9YddM9KkPxWLLHuydXb0/fs3F0lyeyjV
        LImNfJyl7HlZf3vXiYW7U7Sdb12Re5J88rLDwR/mv1ptcncUlU+IfjXt//KFixgreYvbPimx
        FGckGmoxFxUnAgBLLGvamQIAAA==
X-CMS-MailID: 20220523131626epcas5p271c6ec917cc65ce1fcfd784c3757597c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220523131626epcas5p271c6ec917cc65ce1fcfd784c3757597c
References: <20220523131039.17697-1-ankit.kumar@samsung.com>
        <CGME20220523131626epcas5p271c6ec917cc65ce1fcfd784c3757597c@epcas5p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Add zone device specific ioengine_ops for I/O engine io_uring_cmd.
 * get_zoned_model
 * report_zones
 * reset_wp
 * get_max_open_zones

These engine_ops are guarded by CONFIG_LIBNVME flag.

For write workload iodepth must be set to 1 as there is no IO scheduler

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 engines/io_uring.c | 229 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 229 insertions(+)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 75248624..14e54566 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -1297,6 +1297,229 @@ static int fio_ioring_cmd_get_file_size(struct thread_data *td,
 }
 #endif
 
+#ifdef CONFIG_LIBNVME
+static int fio_ioring_cmd_get_zoned_model(struct thread_data *td,
+					  struct fio_file *f,
+					  enum zbd_zoned_model *model)
+{
+	struct nvme_data *data = FILE_ENG_DATA(f);
+	struct nvme_id_ctrl ctrl;
+	struct nvme_id_ns ns;
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
+	ret = nvme_identify_ctrl_csi(fd, NVME_CSI_ZNS, &ctrl);
+	if (ret) {
+		*model = ZBD_NONE;
+		goto out;
+	}
+
+	ret = nvme_identify_ns_csi(fd, data->nsid, NVME_UUID_NONE,
+					NVME_CSI_ZNS, &ns);
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
+static int fio_ioring_cmd_report_zones(struct thread_data *td,
+				       struct fio_file *f, uint64_t offset,
+				       struct zbd_zone *zbdz,
+				       unsigned int nr_zones)
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
+	ret = nvme_identify_ns(fd, data->nsid, &ns);
+	if (ret) {
+		log_err("%s: nvme_identify_ns failed, err=%d\n", f->file_name,
+			ret);
+		goto out;
+	}
+	lba_size = data->lba_size;
+
+	ret = nvme_zns_report_zones(fd, data->nsid, offset >> lba_size,
+				    NVME_ZNS_ZRAS_REPORT_ALL, false,
+				    false, zr_len, (void *)zr,
+				    NVME_DEFAULT_IOCTL_TIMEOUT, NULL);
+	if (ret) {
+		log_err("%s: nvme_zns_report_zones failed, err=%d\n",
+			f->file_name, ret);
+		goto out;
+	}
+	nr_zones = zr->nr_zones;
+
+	ret = nvme_zns_identify_ns(fd, data->nsid, &zns_ns);
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
+	ret = nvme_zns_report_zones(fd, data->nsid, offset >> lba_size,
+				    NVME_ZNS_ZRAS_REPORT_ALL, false,
+				    true, zr_len, (void *)zr,
+				    NVME_DEFAULT_IOCTL_TIMEOUT, NULL);
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
+static int fio_ioring_cmd_reset_wp(struct thread_data *td, struct fio_file *f,
+				   uint64_t offset, uint64_t length)
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
+		struct nvme_zns_mgmt_send_args args = {
+			.args_size      = sizeof(args),
+			.fd             = fd,
+			.nsid           = data->nsid,
+			.slba           = zslba,
+			.zsa            = NVME_ZNS_ZSA_RESET,
+			.select_all     = 0,
+			.zsaso          = 0,
+			.data_len       = 0,
+			.data           = NULL,
+			.timeout        = NVME_DEFAULT_IOCTL_TIMEOUT,
+			.result         = NULL,
+		};
+		ret = nvme_zns_mgmt_send(&args);
+	}
+
+	if (f->fd < 0)
+		close(fd);
+	return -ret;
+}
+
+static int fio_ioring_cmd_get_max_open_zones(struct thread_data *td,
+					     struct fio_file *f,
+					     unsigned int *max_open_zones)
+{
+	struct nvme_data *data = FILE_ENG_DATA(f);
+	struct nvme_zns_id_ns zns_ns;
+	int fd, ret = 0;
+
+	fd = open(f->file_name, O_RDONLY | O_LARGEFILE);
+	if (fd < 0)
+		return -errno;
+
+	ret = nvme_zns_identify_ns(fd, data->nsid, &zns_ns);
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
+#endif
+
 static struct ioengine_ops ioengine_uring = {
 	.name			= "io_uring",
 	.version		= FIO_IOOPS_VERSION,
@@ -1334,6 +1557,12 @@ static struct ioengine_ops ioengine_uring_cmd = {
 	.open_file		= fio_ioring_cmd_open_file,
 	.close_file		= fio_ioring_cmd_close_file,
 	.get_file_size		= fio_ioring_cmd_get_file_size,
+#ifdef CONFIG_LIBNVME
+	.get_zoned_model	= fio_ioring_cmd_get_zoned_model,
+	.report_zones		= fio_ioring_cmd_report_zones,
+	.reset_wp		= fio_ioring_cmd_reset_wp,
+	.get_max_open_zones	= fio_ioring_cmd_get_max_open_zones,
+#endif
 	.options		= options,
 	.option_struct_size	= sizeof(struct ioring_options),
 };
-- 
2.17.1

