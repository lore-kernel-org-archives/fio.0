Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC860C04FDF
	for <fio@archiver.kernel.org>; Mon, 14 Aug 2023 09:41:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233843AbjHNJlV (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 14 Aug 2023 05:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234127AbjHNJlI (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 14 Aug 2023 05:41:08 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 680E6DA
        for <fio@vger.kernel.org>; Mon, 14 Aug 2023 02:41:05 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20230814094103epoutp014f6af66084ee868833f8ae9095a56dd9~7NozuDDl91215812158epoutp01G
        for <fio@vger.kernel.org>; Mon, 14 Aug 2023 09:41:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20230814094103epoutp014f6af66084ee868833f8ae9095a56dd9~7NozuDDl91215812158epoutp01G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1692006063;
        bh=BBtPKsb4U9vzbYwIPEmuFxBaYqwEm3HhF/QlgjHIYr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HKajOfITf949Qn/kBb/wU2T7Ut4WIaRrqt7DJ2t7gZReleZqszRgtF3vrpfByY/ku
         81c0wjfklt88pE4nHnPbRwmqtjSae7+mTl/gHgVzFjHiJU4d6elInGn767sDx/7FcH
         5zM4peGSs3mwjmwoQdg0lVRMA0t9tSG9TFw0Ege0=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20230814094103epcas5p2f9bb19a3237cfbdda3c500660345647b~7NozcsdfD1264112641epcas5p2t;
        Mon, 14 Aug 2023 09:41:03 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4RPTt566Gwz4x9Pr; Mon, 14 Aug
        2023 09:41:01 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        77.93.06099.DA6F9D46; Mon, 14 Aug 2023 18:41:01 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20230814093844epcas5p2a8eddaeddfbfd01e219491c2c4d79cd7~7Nmx1dFfm3200132001epcas5p2D;
        Mon, 14 Aug 2023 09:38:44 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230814093844epsmtrp296f21e5d87944fe5c8a1dc47fe190b91~7Nmx0TPul1844018440epsmtrp2I;
        Mon, 14 Aug 2023 09:38:44 +0000 (GMT)
X-AuditID: b6c32a4b-cafff700000017d3-2f-64d9f6ad6797
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        AC.CF.14748.426F9D46; Mon, 14 Aug 2023 18:38:44 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230814093842epsmtip11f10d1d2a631a42916a2d9400df23fca~7NmwD7wT11006510065epsmtip1C;
        Mon, 14 Aug 2023 09:38:42 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     fio@vger.kernel.org, kbusch@kernel.org, joshi.k@samsung.com,
        martin.petersen@oracle.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v3 04/10] engines:io_uring: uring_cmd add support for
 protection info
Date:   Mon, 14 Aug 2023 20:27:41 +0530
Message-Id: <20230814145747.114725-5-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230814145747.114725-1-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCJsWRmVeSWpSXmKPExsWy7bCmuu7abzdTDK4u17ZYc+U3u8Xqu/1s
        Fh9nvWC2OPr/LZvFpEPXGC2WH//HZLGhTdCB3WPnrLvsHpfPlnpsWtXJ5vHx6S0Wj74tqxg9
        Pm+SC2CLyrbJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvM
        AbpESaEsMacUKBSQWFyspG9nU5RfWpKqkJFfXGKrlFqQklNgUqBXnJhbXJqXrpeXWmJlaGBg
        ZApUmJCdce36E9aCU3MZK16dnsrewDitpouRk0NCwETi0suv7F2MXBxCArsZJY6tOsUC4Xxi
        lPgz7SEbSJWQwDdGiVePBWE6Jsy4zwhRtJdR4tC5bVDtnUwSky4cYAGpYhPQlnj19gZzFyMH
        h4iAhsSau6kgNcwCLYwSu7tns4LUCAuES7xf3AdWzyKgKjHhyRMwm1fAVmLrt2Y2iG3yEjMv
        fWcHsTkF7CT+T/nNDlEjKHFyJkQ9M1BN89bZzCALJAQ+sku8+fmNGaLZRWLP6TVMELawxKvj
        W9ghbCmJz+/2Qi3Iltj08CdUTYHEkRe9UL32Eq2n+sEeYBbQlFi/Sx8iLCsx9dQ6Joi9fBK9
        v59AtfJK7JgHY6tK/L13mwXClpa4+e4qlO0hMfP0B2ZIYE1klGj/eJZpAqPCLCT/zELyzyyE
        1QsYmVcxSqYWFOempxabFhjnpZbDozk5P3cTIzh5annvYHz04IPeIUYmDsZDjBIczEoivLfc
        r6UI8aYkVlalFuXHF5XmpBYfYjQFBvhEZinR5Hxg+s4riTc0sTQwMTMzM7E0NjNUEud93To3
        RUggPbEkNTs1tSC1CKaPiYNTqoGp4ftV+ZnLH/256rLrX8nqf3s6GD4odb0XY7Xhkjix0sjn
        UsMhp/vKN5u+vbU8Gax4+8HMRDe77c/svFcyWcwWmV2X94NP1uG8Qdnri3fqFW8H6DgtWjvj
        m/kJgeA7097qs0w1Nf3z9pJaaVDbvOMPswtkPiWKCDNM65h+wpKrbcOExs55NiUze6fUcdX1
        p82K/vA17PKvd5H7500QPjg/zTSqxZd7qZr5spQPO5Mk2tO5vjCyen1TzeCebplg6tz9xq6N
        bd6jjYUqxrdY1pQaS1f8iz5+KKJvwrzt7rOXurW+nmZ7TKnwVajaR7W+YxN/H5zfemnpw9/C
        sx5ozD4UdX+tt5/EQq6G6Wyb7M4HK7EUZyQaajEXFScCAA3W9ZQnBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsWy7bCSnK7Kt5spBt9vC1msufKb3WL13X42
        i4+zXjBbHP3/ls1i0qFrjBbLj/9jstjQJujA7rFz1l12j8tnSz02repk8/j49BaLR9+WVYwe
        nzfJBbBFcdmkpOZklqUW6dslcGVcu/6EteDUXMaKV6ensjcwTqvpYuTkkBAwkZgw4z5jFyMX
        h5DAbkaJ2c2NrF2MHEAJaYmF6xMhaoQlVv57zg5iCwm0M0n86M8CsdkEtCVevb3BDGKLCGhJ
        HFvXxAYyh1mgi1Fi7+5pbCAJYYFQiS2/IGwWAVWJCU+esIDYvAK2Elu/NbNBLJCXmHnpO9gC
        TgE7if9TfkMts5VYtXAvK0S9oMTJmRC9zED1zVtnM09gFJiFJDULSWoBI9MqRsnUguLc9Nxk
        wwLDvNRyveLE3OLSvHS95PzcTYzg4NbS2MF4b/4/vUOMTByMhxglOJiVRHhvuV9LEeJNSays
        Si3Kjy8qzUktPsQozcGiJM5rOGN2ipBAemJJanZqakFqEUyWiYNTqoEp4HTLGp2uP268O/93
        rKue6Jc3ky/pu9j0bxcmdmvOK5J/9/Jh5C7tqum7so/lvsvjLHE85m9WrZGh2rzit+eJumeN
        1Q3hay6wOnQ3svg6qbWWH5VwSL9YOqvbdNZC+fcL3Jbuepx1NX0bc6XzaR7nnQt/vHD5JOd1
        PkQ4a4cti9+H05cvOaxs/r8mTbvgvjbP22+3c54cfTVDd9GpOXe/8xesknnzJZnBSiKG4xxL
        RvLPA642uw3VNrz9/ubegeZ/oqsnJ12oOXfCoYOzYiJvSKe8m6+PU1Sv5+aACzfKF1/eez5t
        0SfFpruC7YtVRWeX5O5Vi2s8zPjMwkNvtcrvI/XSd70dRB156tLdN8YosRRnJBpqMRcVJwIA
        /FKFHt0CAAA=
X-CMS-MailID: 20230814093844epcas5p2a8eddaeddfbfd01e219491c2c4d79cd7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230814093844epcas5p2a8eddaeddfbfd01e219491c2c4d79cd7
References: <20230814145747.114725-1-ankit.kumar@samsung.com>
        <CGME20230814093844epcas5p2a8eddaeddfbfd01e219491c2c4d79cd7@epcas5p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

This patch enables support for protection information to nvme command
backend of io_uring_cmd ioengine. The patch only supports protection
information action bit set to 1, for read and write operation.

This adds 4 new ioengine specific options
 * pi_act - Protection information action. Default: 1
 * pi_chk - Can be set to GUARD, APPTAG or REFTAG
 * apptag - Sets apptag field of command dword 15
 * apptag_mask - Sets apptag_mask field of command dword 15

For the sake of consistency these options are the same as the ones used
by SPDK's external ioengine.

For pi_act=1, if namespace is formatted with metadata size equal to
protection information size, the nvme controller inserts and removes
protection information for write and read command respectively.
Added a check so that fio doesn't send metadata for such cases.

Storage tag support is not present, so return an error for that.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 HOWTO.rst          |  35 +++++++++
 engines/io_uring.c |  95 +++++++++++++++++++++-
 engines/nvme.c     | 112 +++++++++++++++++++++++---
 engines/nvme.h     | 191 ++++++++++++++++++++++++++++++++++++++++++++-
 fio.1              |  35 +++++++++
 5 files changed, 454 insertions(+), 14 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 6e0677f2..89032941 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2491,6 +2491,41 @@ with the caveat that when used on the command line, they must come after the
 
 	Size in bytes for separate metadata buffer per IO. Default: 0.
 
+.. option:: pi_act=int : [io_uring_cmd]
+
+	Action to take when nvme namespace is formatted with protection
+	information. If this is set to 1 and namespace is formatted with
+	metadata size equal to protection information size, fio won't use
+	separate metadata buffer or extended logical block. If this is set to
+	1 and namespace is formatted with metadata size greater than protection
+	information size, fio will not generate or verify the protection
+	information portion of metadata for write or read case respectively.
+	If this is set to 0, fio generates protection information for
+	write case and verifies for read case. Default: 1.
+
+.. option:: pi_chk=str[,str][,str] : [io_uring_cmd]
+
+	Controls the protection information check. This can take one or more
+	of these values. Default: none.
+
+	**GUARD**
+		Enables protection information checking of guard field.
+	**REFTAG**
+		Enables protection information checking of logical block
+		reference tag field.
+	**APPTAG**
+		Enables protection information checking of application tag field.
+
+.. option:: apptag=int : [io_uring_cmd]
+
+	Specifies logical block application tag value, if namespace is
+	formatted to use end to end protection information. Default: 0x1234.
+
+.. option:: apptag_mask=int : [io_uring_cmd]
+
+	Specifies logical block application tag mask value, if namespace is
+	formatted to use end to end protection information. Default: 0xffff.
+
 .. option:: cpuload=int : [cpuio]
 
 	Attempt to use the specified percentage of CPU cycles. This is a mandatory
diff --git a/engines/io_uring.c b/engines/io_uring.c
index 4916e3b0..376a2a27 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -97,6 +97,11 @@ struct ioring_options {
 	unsigned int nowait;
 	unsigned int force_async;
 	unsigned int md_per_io_size;
+	unsigned int pi_act;
+	unsigned int apptag;
+	unsigned int apptag_mask;
+	unsigned int prchk;
+	char *pi_chk;
 	enum uring_cmd_type cmd_type;
 };
 
@@ -229,6 +234,46 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_IOURING,
 	},
+	{
+		.name	= "pi_act",
+		.lname	= "Protection Information Action",
+		.type	= FIO_OPT_BOOL,
+		.off1	= offsetof(struct ioring_options, pi_act),
+		.def	= "1",
+		.help	= "Protection Information Action bit (pi_act=1 or pi_act=0)",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_IOURING,
+	},
+	{
+		.name	= "pi_chk",
+		.lname	= "Protection Information Check",
+		.type	= FIO_OPT_STR_STORE,
+		.off1	= offsetof(struct ioring_options, pi_chk),
+		.def	= NULL,
+		.help	= "Control of Protection Information Checking (pi_chk=GUARD,REFTAG,APPTAG)",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_IOURING,
+	},
+	{
+		.name	= "apptag",
+		.lname	= "Application Tag used in Protection Information",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct ioring_options, apptag),
+		.def	= "0x1234",
+		.help	= "Application Tag used in Protection Information field (Default: 0x1234)",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_IOURING,
+	},
+	{
+		.name	= "apptag_mask",
+		.lname	= "Application Tag Mask",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct ioring_options, apptag_mask),
+		.def	= "0xffff",
+		.help	= "Application Tag Mask used with Application Tag (Default: 0xffff)",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_IOURING,
+	},
 	{
 		.name	= NULL,
 	},
@@ -486,6 +531,33 @@ static int fio_ioring_getevents(struct thread_data *td, unsigned int min,
 	return r < 0 ? r : events;
 }
 
+static inline void fio_ioring_cmd_nvme_pi(struct thread_data *td,
+					  struct io_u *io_u)
+{
+	struct ioring_data *ld = td->io_ops_data;
+	struct ioring_options *o = td->eo;
+	struct nvme_uring_cmd *cmd;
+	struct io_uring_sqe *sqe;
+	struct nvme_cmd_ext_io_opts ext_opts = {0};
+	struct nvme_data *data = FILE_ENG_DATA(io_u->file);
+
+	if (io_u->ddir == DDIR_TRIM)
+		return;
+
+	sqe = &ld->sqes[(io_u->index) << 1];
+	cmd = (struct nvme_uring_cmd *)sqe->cmd;
+
+	if (data->pi_type) {
+		if (o->pi_act)
+			ext_opts.io_flags |= NVME_IO_PRINFO_PRACT;
+		ext_opts.io_flags |= o->prchk;
+		ext_opts.apptag = o->apptag;
+		ext_opts.apptag_mask = o->apptag_mask;
+	}
+
+	fio_nvme_pi_fill(cmd, io_u, &ext_opts);
+}
+
 static inline void fio_ioring_cmdprio_prep(struct thread_data *td,
 					   struct io_u *io_u)
 {
@@ -500,6 +572,7 @@ static enum fio_q_status fio_ioring_queue(struct thread_data *td,
 					  struct io_u *io_u)
 {
 	struct ioring_data *ld = td->io_ops_data;
+	struct ioring_options *o = td->eo;
 	struct io_sq_ring *ring = &ld->sq_ring;
 	unsigned tail, next_tail;
 
@@ -527,6 +600,10 @@ static enum fio_q_status fio_ioring_queue(struct thread_data *td,
 	if (ld->cmdprio.mode != CMDPRIO_MODE_NONE)
 		fio_ioring_cmdprio_prep(td, io_u);
 
+	if (!strcmp(td->io_ops->name, "io_uring_cmd") &&
+		o->cmd_type == FIO_URING_CMD_NVME)
+		fio_ioring_cmd_nvme_pi(td, io_u);
+
 	ring->array[tail & ld->sq_ring_mask] = io_u->index;
 	atomic_store_release(ring->tail, next_tail);
 
@@ -1025,6 +1102,19 @@ static int fio_ioring_cmd_post_init(struct thread_data *td)
 	return 0;
 }
 
+static void parse_prchk_flags(struct ioring_options *o)
+{
+	if (!o->pi_chk)
+		return;
+
+	if (strstr(o->pi_chk, "GUARD") != NULL)
+		o->prchk = NVME_IO_PRINFO_PRCHK_GUARD;
+	if (strstr(o->pi_chk, "REFTAG") != NULL)
+		o->prchk |= NVME_IO_PRINFO_PRCHK_REF;
+	if (strstr(o->pi_chk, "APPTAG") != NULL)
+		o->prchk |= NVME_IO_PRINFO_PRCHK_APP;
+}
+
 static int fio_ioring_init(struct thread_data *td)
 {
 	struct ioring_options *o = td->eo;
@@ -1071,6 +1161,7 @@ static int fio_ioring_init(struct thread_data *td)
 			return 1;
 		}
 	}
+	parse_prchk_flags(o);
 
 	ld->iovecs = calloc(td->o.iodepth, sizeof(struct iovec));
 
@@ -1139,7 +1230,7 @@ static int fio_ioring_cmd_open_file(struct thread_data *td, struct fio_file *f)
 		data = FILE_ENG_DATA(f);
 		if (data == NULL) {
 			data = calloc(1, sizeof(struct nvme_data));
-			ret = fio_nvme_get_info(f, &nlba, data);
+			ret = fio_nvme_get_info(f, &nlba, o->pi_act, data);
 			if (ret) {
 				free(data);
 				return ret;
@@ -1225,7 +1316,7 @@ static int fio_ioring_cmd_get_file_size(struct thread_data *td,
 		int ret;
 
 		data = calloc(1, sizeof(struct nvme_data));
-		ret = fio_nvme_get_info(f, &nlba, data);
+		ret = fio_nvme_get_info(f, &nlba, o->pi_act, data);
 		if (ret) {
 			free(data);
 			return ret;
diff --git a/engines/nvme.c b/engines/nvme.c
index 65725e3c..8793d742 100644
--- a/engines/nvme.c
+++ b/engines/nvme.c
@@ -87,6 +87,39 @@ int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 	return 0;
 }
 
+void fio_nvme_pi_fill(struct nvme_uring_cmd *cmd, struct io_u *io_u,
+		      struct nvme_cmd_ext_io_opts *opts)
+{
+	struct nvme_data *data = FILE_ENG_DATA(io_u->file);
+	__u64 slba;
+
+	slba = get_slba(data, io_u);
+	cmd->cdw12 |= opts->io_flags;
+
+	switch (data->pi_type) {
+	case NVME_NS_DPS_PI_TYPE1:
+	case NVME_NS_DPS_PI_TYPE2:
+		switch (data->guard_type) {
+		case NVME_NVM_NS_16B_GUARD:
+			cmd->cdw14 = (__u32)slba;
+			break;
+		case NVME_NVM_NS_64B_GUARD:
+			cmd->cdw14 = (__u32)slba;
+			cmd->cdw3 = ((slba >> 32) & 0xffff);
+			break;
+		default:
+			break;
+		}
+		cmd->cdw15 = (opts->apptag_mask << 16 | opts->apptag);
+		break;
+	case NVME_NS_DPS_PI_TYPE3:
+		cmd->cdw15 = (opts->apptag_mask << 16 | opts->apptag);
+		break;
+	case NVME_NS_DPS_PI_NONE:
+		break;
+	}
+}
+
 static int nvme_identify(int fd, __u32 nsid, enum nvme_identify_cns cns,
 			 enum nvme_csi csi, void *data)
 {
@@ -103,12 +136,15 @@ static int nvme_identify(int fd, __u32 nsid, enum nvme_identify_cns cns,
 	return ioctl(fd, NVME_IOCTL_ADMIN_CMD, &cmd);
 }
 
-int fio_nvme_get_info(struct fio_file *f, __u64 *nlba, struct nvme_data *data)
+int fio_nvme_get_info(struct fio_file *f, __u64 *nlba, __u32 pi_act,
+		      struct nvme_data *data)
 {
 	struct nvme_id_ns ns;
+	struct nvme_id_ctrl ctrl;
+	struct nvme_nvm_id_ns nvm_ns;
 	int namespace_id;
 	int fd, err;
-	__u32 format_idx;
+	__u32 format_idx, elbaf;
 
 	if (f->filetype != FIO_TYPE_CHAR) {
 		log_err("ioengine io_uring_cmd only works with nvme ns "
@@ -127,6 +163,12 @@ int fio_nvme_get_info(struct fio_file *f, __u64 *nlba, struct nvme_data *data)
 		goto out;
 	}
 
+	err = nvme_identify(fd, 0, NVME_IDENTIFY_CNS_CTRL, NVME_CSI_NVM, &ctrl);
+	if (err) {
+		log_err("%s: failed to fetch identify ctrl\n", f->file_name);
+		goto out;
+	}
+
 	/*
 	 * Identify namespace to get namespace-id, namespace size in LBA's
 	 * and LBA data size.
@@ -136,8 +178,7 @@ int fio_nvme_get_info(struct fio_file *f, __u64 *nlba, struct nvme_data *data)
 	if (err) {
 		log_err("%s: failed to fetch identify namespace\n",
 			f->file_name);
-		close(fd);
-		return err;
+		goto out;
 	}
 
 	data->nsid = namespace_id;
@@ -155,6 +196,62 @@ int fio_nvme_get_info(struct fio_file *f, __u64 *nlba, struct nvme_data *data)
 	data->lba_size = 1 << ns.lbaf[format_idx].ds;
 	data->ms = le16_to_cpu(ns.lbaf[format_idx].ms);
 
+	/* Check for end to end data protection support */
+	if (data->ms && (ns.dps & NVME_NS_DPS_PI_MASK))
+		data->pi_type = (ns.dps & NVME_NS_DPS_PI_MASK);
+
+	if (!data->pi_type)
+		goto check_elba;
+
+	if (ctrl.ctratt & NVME_CTRL_CTRATT_ELBAS) {
+		err = nvme_identify(fd, namespace_id, NVME_IDENTIFY_CNS_CSI_NS,
+					NVME_CSI_NVM, &nvm_ns);
+		if (err) {
+			log_err("%s: failed to fetch identify nvm namespace\n",
+				f->file_name);
+			goto out;
+		}
+
+		elbaf = le32_to_cpu(nvm_ns.elbaf[format_idx]);
+
+		/* Currently we don't support storage tags */
+		if (elbaf & NVME_ID_NS_NVM_STS_MASK) {
+			log_err("%s: Storage tag not supported\n",
+				f->file_name);
+			err = -ENOTSUP;
+			goto out;
+		}
+
+		data->guard_type = (elbaf >> NVME_ID_NS_NVM_GUARD_SHIFT) &
+				NVME_ID_NS_NVM_GUARD_MASK;
+
+		/* No 32 bit guard, as storage tag is mandatory for it */
+		switch (data->guard_type) {
+		case NVME_NVM_NS_16B_GUARD:
+			data->pi_size = sizeof(struct nvme_16b_guard_pif);
+			break;
+		case NVME_NVM_NS_64B_GUARD:
+			data->pi_size = sizeof(struct nvme_64b_guard_pif);
+			break;
+		default:
+			break;
+		}
+	} else {
+		data->guard_type = NVME_NVM_NS_16B_GUARD;
+		data->pi_size = sizeof(struct nvme_16b_guard_pif);
+	}
+
+	/*
+	 * when PRACT bit is set to 1, and metadata size is equal to protection
+	 * information size, controller inserts and removes PI for write and
+	 * read commands respectively.
+	 */
+	if (pi_act && data->ms == data->pi_size)
+		data->ms = 0;
+
+	data->pi_loc = (ns.dps & NVME_NS_DPS_PI_FIRST);
+
+check_elba:
 	/*
 	 * Bit 4 for flbas indicates if metadata is transferred at the end of
 	 * logical block creating an extended LBA.
@@ -164,13 +261,6 @@ int fio_nvme_get_info(struct fio_file *f, __u64 *nlba, struct nvme_data *data)
 	else
 		data->lba_shift = ilog2(data->lba_size);
 
-	/* Check for end to end data protection support */
-	if (ns.dps & 0x3) {
-		log_err("%s: end to end data protection not supported\n",
-			f->file_name);
-		err = -ENOTSUP;
-		goto out;
-	}
 	*nlba = ns.nsze;
 
 out:
diff --git a/engines/nvme.h b/engines/nvme.h
index e742b14f..f3598352 100644
--- a/engines/nvme.h
+++ b/engines/nvme.h
@@ -42,6 +42,7 @@ struct nvme_uring_cmd {
 #define NVME_DEFAULT_IOCTL_TIMEOUT 0
 #define NVME_IDENTIFY_DATA_SIZE 4096
 #define NVME_IDENTIFY_CSI_SHIFT 24
+#define NVME_NQN_LENGTH	256
 
 #define NVME_ZNS_ZRA_REPORT_ZONES 0
 #define NVME_ZNS_ZRAS_FEAT_ERZ (1 << 16)
@@ -52,6 +53,7 @@ struct nvme_uring_cmd {
 
 enum nvme_identify_cns {
 	NVME_IDENTIFY_CNS_NS		= 0x00,
+	NVME_IDENTIFY_CNS_CTRL		= 0x01,
 	NVME_IDENTIFY_CNS_CSI_NS	= 0x05,
 	NVME_IDENTIFY_CNS_CSI_CTRL	= 0x06,
 };
@@ -85,12 +87,48 @@ enum nvme_zns_zs {
 	NVME_ZNS_ZS_OFFLINE		= 0xf,
 };
 
+enum nvme_id_ctrl_ctratt {
+	NVME_CTRL_CTRATT_ELBAS		= 1 << 15,
+};
+
+enum {
+	NVME_ID_NS_NVM_STS_MASK		= 0x7f,
+	NVME_ID_NS_NVM_GUARD_SHIFT	= 7,
+	NVME_ID_NS_NVM_GUARD_MASK	= 0x3,
+};
+
+enum {
+	NVME_NVM_NS_16B_GUARD		= 0,
+	NVME_NVM_NS_32B_GUARD		= 1,
+	NVME_NVM_NS_64B_GUARD		= 2,
+};
+
 struct nvme_data {
 	__u32 nsid;
 	__u32 lba_shift;
 	__u32 lba_size;
 	__u32 lba_ext;
 	__u16 ms;
+	__u16 pi_size;
+	__u8 pi_type;
+	__u8 guard_type;
+	__u8 pi_loc;
+};
+
+enum nvme_id_ns_dps {
+	NVME_NS_DPS_PI_NONE		= 0,
+	NVME_NS_DPS_PI_TYPE1		= 1,
+	NVME_NS_DPS_PI_TYPE2		= 2,
+	NVME_NS_DPS_PI_TYPE3		= 3,
+	NVME_NS_DPS_PI_MASK		= 7 << 0,
+	NVME_NS_DPS_PI_FIRST		= 1 << 3,
+};
+
+enum nvme_io_control_flags {
+	NVME_IO_PRINFO_PRCHK_REF	= 1U << 26,
+	NVME_IO_PRINFO_PRCHK_APP	= 1U << 27,
+	NVME_IO_PRINFO_PRCHK_GUARD	= 1U << 28,
+	NVME_IO_PRINFO_PRACT		= 1U << 29,
 };
 
 struct nvme_lbaf {
@@ -99,6 +137,20 @@ struct nvme_lbaf {
 	__u8			rp;
 };
 
+/* 16 bit guard protection Information format */
+struct nvme_16b_guard_pif {
+	__be16 guard;
+	__be16 apptag;
+	__be32 srtag;
+};
+
+/* 64 bit guard protection Information format */
+struct nvme_64b_guard_pif {
+	__be64 guard;
+	__be16 apptag;
+	__u8 srtag[6];
+};
+
 struct nvme_id_ns {
 	__le64			nsze;
 	__le64			ncap;
@@ -141,6 +193,133 @@ struct nvme_id_ns {
 	__u8			vs[3712];
 };
 
+struct nvme_id_psd {
+	__le16			mp;
+	__u8			rsvd2;
+	__u8			flags;
+	__le32			enlat;
+	__le32			exlat;
+	__u8			rrt;
+	__u8			rrl;
+	__u8			rwt;
+	__u8			rwl;
+	__le16			idlp;
+	__u8			ips;
+	__u8			rsvd19;
+	__le16			actp;
+	__u8			apws;
+	__u8			rsvd23[9];
+};
+
+struct nvme_id_ctrl {
+	__le16			vid;
+	__le16			ssvid;
+	char			sn[20];
+	char			mn[40];
+	char			fr[8];
+	__u8			rab;
+	__u8			ieee[3];
+	__u8			cmic;
+	__u8			mdts;
+	__le16			cntlid;
+	__le32			ver;
+	__le32			rtd3r;
+	__le32			rtd3e;
+	__le32			oaes;
+	__le32			ctratt;
+	__le16			rrls;
+	__u8			rsvd102[9];
+	__u8			cntrltype;
+	__u8			fguid[16];
+	__le16			crdt1;
+	__le16			crdt2;
+	__le16			crdt3;
+	__u8			rsvd134[119];
+	__u8			nvmsr;
+	__u8			vwci;
+	__u8			mec;
+	__le16			oacs;
+	__u8			acl;
+	__u8			aerl;
+	__u8			frmw;
+	__u8			lpa;
+	__u8			elpe;
+	__u8			npss;
+	__u8			avscc;
+	__u8			apsta;
+	__le16			wctemp;
+	__le16			cctemp;
+	__le16			mtfa;
+	__le32			hmpre;
+	__le32			hmmin;
+	__u8			tnvmcap[16];
+	__u8			unvmcap[16];
+	__le32			rpmbs;
+	__le16			edstt;
+	__u8			dsto;
+	__u8			fwug;
+	__le16			kas;
+	__le16			hctma;
+	__le16			mntmt;
+	__le16			mxtmt;
+	__le32			sanicap;
+	__le32			hmminds;
+	__le16			hmmaxd;
+	__le16			nsetidmax;
+	__le16			endgidmax;
+	__u8			anatt;
+	__u8			anacap;
+	__le32			anagrpmax;
+	__le32			nanagrpid;
+	__le32			pels;
+	__le16			domainid;
+	__u8			rsvd358[10];
+	__u8			megcap[16];
+	__u8			rsvd384[128];
+	__u8			sqes;
+	__u8			cqes;
+	__le16			maxcmd;
+	__le32			nn;
+	__le16			oncs;
+	__le16			fuses;
+	__u8			fna;
+	__u8			vwc;
+	__le16			awun;
+	__le16			awupf;
+	__u8			icsvscc;
+	__u8			nwpc;
+	__le16			acwu;
+	__le16			ocfs;
+	__le32			sgls;
+	__le32			mnan;
+	__u8			maxdna[16];
+	__le32			maxcna;
+	__u8			rsvd564[204];
+	char			subnqn[NVME_NQN_LENGTH];
+	__u8			rsvd1024[768];
+
+	/* Fabrics Only */
+	__le32			ioccsz;
+	__le32			iorcsz;
+	__le16			icdoff;
+	__u8			fcatt;
+	__u8			msdbd;
+	__le16			ofcs;
+	__u8			dctype;
+	__u8			rsvd1807[241];
+
+	struct nvme_id_psd	psd[32];
+	__u8			vs[1024];
+};
+
+struct nvme_nvm_id_ns {
+	__le64			lbstm;
+	__u8			pic;
+	__u8			rsvd9[3];
+	__le32			elbaf[64];
+	__u8			rsvd268[3828];
+};
+
 static inline int ilog2(uint32_t i)
 {
 	int log = -1;
@@ -218,14 +397,24 @@ struct nvme_dsm_range {
 	__le64	slba;
 };
 
+struct nvme_cmd_ext_io_opts {
+	__u32 io_flags;
+	__u16 apptag;
+	__u16 apptag_mask;
+};
+
 int fio_nvme_iomgmt_ruhs(struct thread_data *td, struct fio_file *f,
 			 struct nvme_fdp_ruh_status *ruhs, __u32 bytes);
 
-int fio_nvme_get_info(struct fio_file *f, __u64 *nlba, struct nvme_data *data);
+int fio_nvme_get_info(struct fio_file *f, __u64 *nlba, __u32 pi_act,
+		      struct nvme_data *data);
 
 int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 			    struct iovec *iov, struct nvme_dsm_range *dsm);
 
+void fio_nvme_pi_fill(struct nvme_uring_cmd *cmd, struct io_u *io_u,
+		      struct nvme_cmd_ext_io_opts *opts);
+
 int fio_nvme_get_zoned_model(struct thread_data *td, struct fio_file *f,
 			     enum zbd_zoned_model *model);
 
diff --git a/fio.1 b/fio.1
index 6b49a747..f0dc49ab 100644
--- a/fio.1
+++ b/fio.1
@@ -2250,6 +2250,41 @@ identifier only at indices 0, 2 and 5 specify, you would set `fdp_pli=0,2,5`.
 .BI (io_uring_cmd)md_per_io_size \fR=\fPint
 Size in bytes for separate metadata buffer per IO. Default: 0.
 .TP
+.BI (io_uring_cmd)pi_act \fR=\fPint
+Action to take when nvme namespace is formatted with protection information.
+If this is set to 1 and namespace is formatted with metadata size equal to
+protection information size, fio won't use separate metadata buffer or extended
+logical block. If this is set to 1 and namespace is formatted with metadata
+size greater than protection information size, fio will not generate or verify
+the protection information portion of metadata for write or read case
+respectively. If this is set to 0, fio generates protection information for
+write case and verifies for read case. Default: 1.
+.TP
+.BI (io_uring_cmd)pi_chk \fR=\fPstr[,str][,str]
+Controls the protection information check. This can take one or more of these
+values. Default: none.
+.RS
+.RS
+.TP
+.B GUARD
+Enables protection information checking of guard field.
+.TP
+.B REFTAG
+Enables protection information checking of logical block reference tag field.
+.TP
+.B APPTAG
+Enables protection information checking of application tag field.
+.RE
+.RE
+.TP
+.BI (io_uring_cmd)apptag \fR=\fPint
+Specifies logical block application tag value, if namespace is formatted to use
+end to end protection information. Default: 0x1234.
+.TP
+.BI (io_uring_cmd)apptag_mask \fR=\fPint
+Specifies logical block application tag mask value, if namespace is formatted
+to use end to end protection information. Default: 0xffff.
+.TP
 .BI (cpuio)cpuload \fR=\fPint
 Attempt to use the specified percentage of CPU cycles. This is a mandatory
 option when using cpuio I/O engine.
-- 
2.25.1

