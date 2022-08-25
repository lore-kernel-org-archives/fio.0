Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 571A7C3F6B0
	for <fio@archiver.kernel.org>; Thu, 25 Aug 2022 08:34:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234505AbiHYIeu (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 25 Aug 2022 04:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233516AbiHYIej (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 25 Aug 2022 04:34:39 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C057A61D8
        for <fio@vger.kernel.org>; Thu, 25 Aug 2022 01:34:36 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220825083430epoutp0187f5cb17666cce986d1d72a98643e93e~OiXpOv5xM3252632526epoutp01W
        for <fio@vger.kernel.org>; Thu, 25 Aug 2022 08:34:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220825083430epoutp0187f5cb17666cce986d1d72a98643e93e~OiXpOv5xM3252632526epoutp01W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1661416470;
        bh=u+1pmLhdVAPjluoQWorJmPgn8zo0wJdFefwM+X9+PxA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PJ4DpcLu9aPrbG71WqRu4HtyXUJEaUNBE1IwBA9AUiVmiC53NvqYMqSmh0HF5Uoi7
         /C312lH2Pf2JCINB1C1LOuUkt7085SuMWuS0320hx/D6A7tdyCwZweUD/qfespN5/U
         kGHqvt8U06KWHsXIfLhkRaFI/EloRaa3dFhiQufA=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220825083430epcas5p2891e76e63ccb3abcf9662f8e01f08d39~OiXo4MSD80744107441epcas5p2P;
        Thu, 25 Aug 2022 08:34:30 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4MCx8h1BP6z4x9Q1; Thu, 25 Aug
        2022 08:34:28 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        49.A2.18001.31437036; Thu, 25 Aug 2022 17:34:27 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220825083426epcas5p3711ee40c6459e51b71442abac66d0c5d~OiXlSfjWt2628726287epcas5p36;
        Thu, 25 Aug 2022 08:34:26 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220825083426epsmtrp24d4ecedf4dbbff9e3b3596058af7a03a~OiXlMQb-s0315303153epsmtrp2Z;
        Thu, 25 Aug 2022 08:34:26 +0000 (GMT)
X-AuditID: b6c32a4a-2c3ff70000004651-7b-6307341330cb
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        28.08.14392.21437036; Thu, 25 Aug 2022 17:34:26 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220825083425epsmtip29ab58334c39e002015c25c99fe81bab2~OiXkOodCm3027730277epsmtip2h;
        Thu, 25 Aug 2022 08:34:25 +0000 (GMT)
Date:   Thu, 25 Aug 2022 13:54:44 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Anuj Gupta <anuj20.g@samsung.com>
Cc:     axboe@kernel.dk, vincentfu@gmail.com, ankit.kumar@samsung.com,
        fio@vger.kernel.org
Subject: Re: [PATCH 2/2] t/io_uring: add support for async-passthru
Message-ID: <20220825082444.GB22496@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220824093109.308791-3-anuj20.g@samsung.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNKsWRmVeSWpSXmKPExsWy7bCmhq6wCXuywZ4uFos1V36zWzRN+Mts
        sfpuP5vFx1kvmC02tAk6sHrsnHWX3ePy2VKPvi2rGD0+b5ILYInKtslITUxJLVJIzUvOT8nM
        S7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2qqkUJaYUwoUCkgsLlbSt7Mpyi8t
        SVXIyC8usVVKLUjJKTAp0CtOzC0uzUvXy0stsTI0MDAyBSpMyM64tTyoYKNFxfLfX5kaGFu0
        uhg5OSQETCS2HtnG1sXIxSEksJtR4u/uLVDOJ0aJ14ueMkE43xgllr+6xQjT8uTqP2aIxF5G
        ian/V0JVPWOU+Lx3CytIFYuAqsTOFV/Zuxg5ONgENCUuTC4FCYsAhU/f3wM2iFkgQuL8pm4w
        W1jAWWJKA4jNwcEroCtxuDsaJMwrIChxcuYTFpAwp4C1xJRH9SBhUQFliQPbjoNtlRB4xC4x
        //pqdojbXCQeHd3IAmELS7w6vgUqLiXx+d1eNgg7WeLSzHNMEHaJxOM9B6Fse4nWU/3MEKdl
        SLxbv40VwuaT6P39hAnkBgkBXomONiGIckWJe5OeskLY4hIPZyyBsj0k1m8COQEUIvsZJVb8
        62GbwCg3C8k7s5CsgLCtJDo/NAHZHEC2tMTyfxwQpqbE+l36CxhZVzFKphYU56anFpsWGOWl
        lsNjODk/dxMjOBVqee1gfPjgg94hRiYOxkOMEhzMSiK8VsdYkoV4UxIrq1KL8uOLSnNSiw8x
        mgIjZyKzlGhyPjAZ55XEG5pYGpiYmZmZWBqbGSqJ807RZkwWEkhPLEnNTk0tSC2C6WPi4JRq
        YCr69GHrWxGX86m+kj5333CcWKYrpx9v4OTzS9agyUNs8vQf4Y+mTRTSunpzdvrFW8U9HEzq
        ob/Tm3QEY13Ndov/eu+8hOPrVIWoaV8dJhZXuBlPjDCYNdEqS/8pe/IPo1mtjPZvTonLs7Nk
        nNr6svvF7yruyQEfYuaU1TUmB3+9Y6u+xOT41ZNbzz0xOrc11JYt9dzNsMyiqCgLo/fljpKt
        vg//ruj55ruj8P+pbxsT+oRYK+UVr2amrJ1VZWTqmOLUpFmUEslgdjij4ffX70eVE3KUZ6/K
        dnr1UpUvws+I376P7/vvL/N0H+kHPF+sndmvxtNm+22yXsIbJauf2eJPZNZXBfm+n+plVMKg
        xFKckWioxVxUnAgAgzgjng4EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsWy7bCSvK6QCXuyQd9VBYs1V36zWzRN+Mts
        sfpuP5vFx1kvmC02tAk6sHrsnHWX3ePy2VKPvi2rGD0+b5ILYInisklJzcksSy3St0vgytj3
        YyljwWPTitu/ljA2MF5Q72Lk5JAQMJF4cvUfcxcjF4eQwG5GiVMzzrNCJMQlmq/9YIewhSVW
        /nvODlH0hFFi89MbLCAJFgFViZ0rvgIlODjYBDQlLkwuBQmLAIVP39/DCGIzC0RInN/UDWYL
        CzhLTGkAsTk4eAV0JQ53R4OEhQT2M0rcnegLYvMKCEqcnPmEBaLVTGLe5ofMIOXMAtISy/9x
        gJicAtYSUx7Vg1SICihLHNh2nGkCo+AsJM2zkDTPQmhewMi8ilEytaA4Nz232LDAMC+1XK84
        Mbe4NC9dLzk/dxMjOLS1NHcwbl/1Qe8QIxMH4yFGCQ5mJRFeq2MsyUK8KYmVValF+fFFpTmp
        xYcYpTlYlMR5L3SdjBcSSE8sSc1OTS1ILYLJMnFwSjUwcZ3bJPr+U8sa2d2WgUEXniodKVnX
        Gfwt9Klkp0zsxSs5u2/ff7Zso8r2TwHdXxZx/Nhy/obg8V9vHO0LT7yom+rwSXR518dPvYo2
        Cm03+S7q6R/oV+85eKr8dNIL2T3zXTvKLkgplD4/93if4dGwaw+nJc4xq1eJf766/UeCJ5vk
        TNHlkg/Z9CRCN73YybU6i2PG++87avQ2zD5csv3Wme2LIlwy7ZKC7m09aifyTd3ylo2Ig5K1
        34sLDQfFF1l41m5M5J1lGGZ25+bcVimRTvNDgVYLPs6WZuJYdCQspG+dkkKmWMnZyt9X3kk0
        VrB/UVbgvzWDlX1T//ueXeLlTs/UNZMnLDmjJnXk4mTVSUosxRmJhlrMRcWJAI3uZQzcAgAA
X-CMS-MailID: 20220825083426epcas5p3711ee40c6459e51b71442abac66d0c5d
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----WgjG.75RCK0vaugoxekoY7._5exx5H51ZqHYxOO8vRDHiV2S=_a95a9_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220824094134epcas5p4b7cacb00484146b5d510ded15a80c712
References: <20220824093109.308791-1-anuj20.g@samsung.com>
        <CGME20220824094134epcas5p4b7cacb00484146b5d510ded15a80c712@epcas5p4.samsung.com>
        <20220824093109.308791-3-anuj20.g@samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

------WgjG.75RCK0vaugoxekoY7._5exx5H51ZqHYxOO8vRDHiV2S=_a95a9_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Wed, Aug 24, 2022 at 03:01:09PM +0530, Anuj Gupta wrote:
>This patch adds support for async-passthru in t/io_uring. User needs to
>specify -u1 option in the command
>
>Example commandline:
>t/io_uring -b512 -d128 -c32 -s32 -p0 -F1 -B0 -O0 -n1 -u1 /dev/ng0n1
>
>Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
>---
> t/io_uring.c | 146 ++++++++++++++++++++++++++++++++++++++++++++++++---
> 1 file changed, 138 insertions(+), 8 deletions(-)
>
>diff --git a/t/io_uring.c b/t/io_uring.c
>index a42abd46..78fedaf1 100644
>--- a/t/io_uring.c
>+++ b/t/io_uring.c
>@@ -35,6 +35,7 @@
> #include "../lib/rand.h"
> #include "../minmax.h"
> #include "../os/linux/io_uring.h"
>+#include "../engines/nvme.h"
>
> struct io_sq_ring {
> 	unsigned *head;
>@@ -139,6 +140,9 @@ static int random_io = 1;	/* random or sequential IO */
> static int register_ring = 1;	/* register ring */
> static int use_sync = 0;	/* use preadv2 */
> static int numa_placement = 0;	/* set to node of device */
>+static int pt = 0;		/* passthrough I/O or not */
>+static unsigned int nsid = 0;	/* nsid field required for nvme-passthrough */
>+static unsigned int lbs = 0;	/* logical_block_size field required for nvme-passthrough */
>
> static unsigned long tsc_rate;
>
>@@ -161,6 +165,54 @@ struct io_uring_map_buffers {
> };
> #endif
>
>+static int nvme_identify(int fd, __u32 nsid, enum nvme_identify_cns cns,
>+			 enum nvme_csi csi, void *data)
>+{
>+	struct nvme_passthru_cmd cmd = {
>+		.opcode         = nvme_admin_identify,
>+		.nsid           = nsid,
>+		.addr           = (__u64)(uintptr_t)data,
>+		.data_len       = NVME_IDENTIFY_DATA_SIZE,
>+		.cdw10          = cns,
>+		.cdw11          = csi << NVME_IDENTIFY_CSI_SHIFT,
>+		.timeout_ms     = NVME_DEFAULT_IOCTL_TIMEOUT,
>+	};
>+
>+	return ioctl(fd, NVME_IOCTL_ADMIN_CMD, &cmd);
>+}
>+
>+static int nvme_get_info(int fd, __u32 *nsid, __u32 *lba_sz, __u64 *nlba)
>+{
>+	struct nvme_id_ns ns;
>+	int namespace_id;
>+	int err;
>+
>+	namespace_id = ioctl(fd, NVME_IOCTL_ID);
>+	if (namespace_id < 0) {
>+		fprintf(stderr, "error failed to fetch namespace-id\n");
>+		close(fd);
>+		return -errno;
>+	}
>+
>+	/*
>+	 * Identify namespace to get namespace-id, namespace size in LBA's
>+	 * and LBA data size.
>+	 */
>+	err = nvme_identify(fd, namespace_id, NVME_IDENTIFY_CNS_NS,
>+				NVME_CSI_NVM, &ns);
>+	if (err) {
>+		fprintf(stderr, "error failed to fetch identify namespace\n");
>+		close(fd);
>+		return err;
>+	}
>+
>+	*nsid = namespace_id;
>+	*lba_sz = 1 << ns.lbaf[(ns.flbas & 0x0f)].ds;
>+	*nlba = ns.nsze;
>+
>+	return 0;
>+}
>+
> static unsigned long cycles_to_nsec(unsigned long cycles)
> {
> 	uint64_t val;
>@@ -457,12 +509,13 @@ static unsigned file_depth(struct submitter *s)
>
> static void init_io(struct submitter *s, unsigned index)
> {
>-	struct io_uring_sqe *sqe = &s->sqes[index];
>+	struct io_uring_sqe *sqe = NULL;
> 	unsigned long offset;
> 	struct file *f;
> 	long r;
>
> 	if (do_nop) {
>+		sqe = &s->sqes[index];

Nit: this and previous change is not must as <see below>

> 		sqe->opcode = IORING_OP_NOP;
> 		return;
> 	}
>@@ -490,6 +543,41 @@ static void init_io(struct submitter *s, unsigned index)
> 			f->cur_off = 0;
> 	}
>
>+	if (pt) {
>+		struct nvme_uring_cmd *cmd;
>+		unsigned long long slba;
>+		unsigned long long nlb;
>+
>+		sqe = &s->sqes[index<<1];

this is enough.

>+		if (register_files) {
>+			sqe->fd = f->fixed_fd;
>+			sqe->flags = IOSQE_FIXED_FILE;
>+		} else {
>+			sqe->fd = f->real_fd;
>+			sqe->flags = 0;
>+		}
>+		sqe->opcode = IORING_OP_URING_CMD;
>+		sqe->user_data = (unsigned long) f->fileno;
>+		if (stats)
>+			sqe->user_data |= ((unsigned long)s->clock_index << 32);
>+		sqe->cmd_op = NVME_URING_CMD_IO;
>+		slba = offset / lbs;
>+		nlb = bs/lbs - 1;
>+		cmd = (struct nvme_uring_cmd *)&sqe->cmd;
>+		memset(cmd, 0, sizeof(struct nvme_uring_cmd));
>+		/* cdw10 and cdw11 represent starting slba*/
>+		cmd->cdw10 = slba & 0xffffffff;
>+		cmd->cdw11 = slba >> 32;
>+		/* cdw12 represent number of lba to be read*/
>+		cmd->cdw12 = nlb;
>+		cmd->addr = (unsigned long) s->iovecs[index].iov_base;
>+		cmd->data_len = bs;
>+		cmd->nsid = nsid;
>+		cmd->opcode = 2;
>+		return;
>+	}
>+
>+	sqe = &s->sqes[index];
> 	if (register_files) {
> 		sqe->flags = IOSQE_FIXED_FILE;
> 		sqe->fd = f->fixed_fd;
>@@ -549,7 +637,22 @@ static int get_file_size(struct file *f)
>
> 	if (fstat(f->real_fd, &st) < 0)
> 		return -1;
>-	if (S_ISBLK(st.st_mode)) {
>+	if (pt) {
>+		__u64 nlba;
>+		int ret;
>+
>+		if (!S_ISCHR(st.st_mode)) {
>+			fprintf(stderr, "passthrough works with only nvme-ns "
>+					"generic devices (/dev/ngXnY)\n");
>+			return -1;
>+		}
>+		ret = nvme_get_info(f->real_fd, &nsid, &lbs, &nlba);
>+		if (ret)
>+			return -1;
>+		f->max_blocks = nlba / bs;
>+		f->max_size = nlba;
>+		return 0;
>+	} else if (S_ISBLK(st.st_mode)) {
> 		unsigned long long bytes;
>
> 		if (ioctl(f->real_fd, BLKGETSIZE64, &bytes) != 0)
>@@ -587,11 +690,14 @@ static int reap_events_uring(struct submitter *s)
>
> 			f = &s->files[fileno];
> 			f->pending_ios--;
>-			if (cqe->res != bs) {
>+			if (!pt && cqe->res != bs) {
> 				printf("io: unexpected ret=%d\n", cqe->res);
> 				if (polled && cqe->res == -EOPNOTSUPP)
> 					printf("Your filesystem/driver/kernel doesn't support polled IO\n");
> 				return -1;
>+			} else if (pt && cqe->res != 0) {
>+				printf("io: unexpected ret=%d\n", cqe->res);
>+				return -1;

Missing inner check (polled one) for pt case?
How about something like this fragement -

                if (!do_nop) {
                        int fileno = cqe->user_data & 0xffffffff;
+                       bool error;

                        f = &s->files[fileno];
                        f->pending_ios--;
-                       if (!pt && cqe->res != bs) {
+                       if (!pt)
+                               error = (cqe->res != bs);
+                       else
+                               error = (cqe->res != 0);
+                       if (error) {
                                printf("io: unexpected ret=%d\n", cqe->res);
                                if (polled && cqe->res == -EOPNOTSUPP)
                                        printf("Your filesystem/driver/kernel doesn't support polled IO\n");
                                return -1;

[...]

>@@ -1512,6 +1638,10 @@ int main(int argc, char *argv[])
> 			printf("failed getting size of device/file\n");
> 			return 1;
> 		}
>+		if (pt && bs < lbs) {
>+			printf("error: bs:%d is less than logical_block_size:%d\n", bs, lbs);
>+			return 1;
>+		}

would it be better to replace the check/print with "bs % lbs" instead?
since io size needs to be multiple of lbs to go through.


------WgjG.75RCK0vaugoxekoY7._5exx5H51ZqHYxOO8vRDHiV2S=_a95a9_
Content-Type: text/plain; charset="utf-8"


------WgjG.75RCK0vaugoxekoY7._5exx5H51ZqHYxOO8vRDHiV2S=_a95a9_--
