Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7488EC00140
	for <fio@archiver.kernel.org>; Wed, 24 Aug 2022 10:18:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236686AbiHXKR6 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 24 Aug 2022 06:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231846AbiHXKR6 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 24 Aug 2022 06:17:58 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E6D72B5B
        for <fio@vger.kernel.org>; Wed, 24 Aug 2022 03:17:56 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220824101752epoutp03ca6951144542415a2925ee6ec3c1ae47~OQImLd_wT0829408294epoutp038
        for <fio@vger.kernel.org>; Wed, 24 Aug 2022 10:17:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220824101752epoutp03ca6951144542415a2925ee6ec3c1ae47~OQImLd_wT0829408294epoutp038
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1661336272;
        bh=7sAGYMX06qG21lgD+xpym81PA/NRpoYkLcJIuyGtST0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pW+VWGwnjEvHJfnQ7xLVhTwJ/m6qDN5bR2mTyD060U+RrE0M8teI6pLXU7E7S42MT
         5gyFvJ4VQppI5BBL0WvSVvNkCPot/bdGry8GyJyiH9iXgIF29G2ShOBbKMv2R5e+y5
         Re6r9aO17oLmV6L0wgqyma9oE3H2A1eAdARZN5k8=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220824101751epcas5p338ab956bb9bc0eb9c97e45c91f091705~OQIlzueKJ3250032500epcas5p3i;
        Wed, 24 Aug 2022 10:17:51 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4MCMVN5TyMz4x9Q7; Wed, 24 Aug
        2022 10:17:48 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        B9.19.15517.CCAF5036; Wed, 24 Aug 2022 19:17:48 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220824094134epcas5p4b7cacb00484146b5d510ded15a80c712~OPo51EtKn2524225242epcas5p4l;
        Wed, 24 Aug 2022 09:41:34 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220824094134epsmtrp1b0860991e93337faef8c772fb2ad4089~OPo50cJEF2558425584epsmtrp1i;
        Wed, 24 Aug 2022 09:41:34 +0000 (GMT)
X-AuditID: b6c32a4b-e37ff70000003c9d-99-6305facc8561
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        F1.D8.18644.D42F5036; Wed, 24 Aug 2022 18:41:33 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220824094131epsmtip11bdca679c111723398e48f1bf9d0f898~OPo3FNmhy2005020050epsmtip1k;
        Wed, 24 Aug 2022 09:41:31 +0000 (GMT)
From:   Anuj Gupta <anuj20.g@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     joshi.k@samsung.com, ankit.kumar@samsung.com, fio@vger.kernel.org,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH 2/2] t/io_uring: add support for async-passthru
Date:   Wed, 24 Aug 2022 15:01:09 +0530
Message-Id: <20220824093109.308791-3-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220824093109.308791-1-anuj20.g@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42LZdlhTS/fML9Zkg5mnNC3WXPnNbtE04S+z
        xeq7/WwWH2e9YLY4+v8tm8WGNkEHNo+ds+6ye1w+W+rRt2UVo8fnTXIBLFHZNhmpiSmpRQqp
        ecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAq5UUyhJzSoFCAYnFxUr6
        djZF+aUlqQoZ+cUltkqpBSk5BSYFesWJucWleel6eaklVoYGBkamQIUJ2RlNx1exF1x0qLhy
        9TpjA+N/wy5GTg4JAROJTX2n2LoYuTiEBHYzSjROfs4C4XxilNg26RczhPOZUeJ4+0I2mJbG
        /qOsEIldjBL3L+5hhKu6MO8HO0gVm4C6xJHnrUAJDg4RAQ2JNXdTQcLMAlkSL39cYAUJCwvY
        S/xsUgEJswioSjw43soMEuYVsJI4dE0IYpW8xMxL38EGcgpYS1xecQPM5hUQlDg58wkLxER5
        ieats8HulBC4xi7x5vRCZohmF4mrL1cxQdjCEq+Ob2GHsKUkXva3QdnpEj8uP4WqKZBoPraP
        EcK2l2g91Q92D7OApsT6XfoQYVmJqafWMUHs5ZPo/f0EqpVXYsc8GFtJon3lHChbQmLvuQYo
        20Ni/aaN0MDtY5Q4e/UI4wRGhVlI/pmF5J9ZCKsXMDKvYpRMLSjOTU8tNi0wzksth8dxcn7u
        JkZwYtTy3sH46MEHvUOMTByMhxglOJiVRHitjrEkC/GmJFZWpRblxxeV5qQWH2I0BYb3RGYp
        0eR8YGrOK4k3NLE0MDEzMzOxNDYzVBLnnaLNmCwkkJ5YkpqdmlqQWgTTx8TBKdXAVN7zZeb7
        KibFNYdUjJ+FnUmc0s1ik2389JThivnL585ZXL3cOOKF3ev1hycFyQZOaKv0OJ7ctldSZe6i
        M25BWZ/Kjx2SsHm6yfS0hMnXvgseQZIqF7OmBMYe+yryxWVmll5vHuu62fFG8p9vPTP+ccKi
        cV6T+W1bn6Myewx9c9M/Nur+uRA2+eCT5ujUJw23b1w+dHzlCdn/zrln5geJ6l9lObQqub5D
        4E8sm+4k3ud8B09fLqh4ML23Zm7trnzOKf5+jSGqaz8ZVTfkuFVqf0p7Ezz3YdHFNZs0dT9N
        NzIwdyk5q7Hw3a5bVveXCVR3G/l96ljVJl17uyP98eI6y/VnN8VZT4u9GbXj+2+uEiWW4oxE
        Qy3mouJEABjHUbEVBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBLMWRmVeSWpSXmKPExsWy7bCSnK7vJ9Zkg0mvrC3WXPnNbtE04S+z
        xeq7/WwWH2e9YLY4+v8tm8WGNkEHNo+ds+6ye1w+W+rRt2UVo8fnTXIBLFFcNimpOZllqUX6
        dglcGU3HV7EXXHSouHL1OmMD43/DLkZODgkBE4nG/qOsILaQwA5GiZtTRCDiEhKnXi5jhLCF
        JVb+e87excgFVPORUeLjzO0sIAk2AXWJI89bwYpEBLQkjq1rYgOxmQXyJLrungOq4eAQFrCX
        +NmkAhJmEVCVeHC8lRkkzCtgJXHomhDEeHmJmZe+s4PYnALWEpdX3GCHOMdK4tibY2CbeAUE
        JU7OfMICMV1eonnrbOYJjAKzkKRmIUktYGRaxSiZWlCcm55bbFhglJdarlecmFtcmpeul5yf
        u4kRHLhaWjsY96z6oHeIkYmD8RCjBAezkgiv1TGWZCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8
        F7pOxgsJpCeWpGanphakFsFkmTg4pRqYanfFLTZoc/17l+/Zv69LjseE203YvXDxwgUuDPcV
        xAPP7D2ZWxzj8OXdOW9dDdkvp9fo7C2vX2jImdmyOMPu+u9ZlcqMUmeDt92aEcp9mmOlhwqf
        09uT5i+3usdE/0udUCBz5ZGBVc/vKcaym15yKfZbhVz6ZBhh4+T2I38yw/HPdYHch28w7628
        93ST9fxF5km7syY8yrxW8XTO1H/JNfs3psc+/PH8hHWIZi2v6ffSCXGf/l/5Prcx6GNtyr5l
        19yb9ur/CMuJadVmFYw4zvi2Tjbxl3z9oX0fGpuTEtP5jsx1K6ubmKcYHV6+3bW17eMrgW1M
        547oKa0M+Rkjl5Gj/HOy5JLfS37cnbdIQImlOCPRUIu5qDgRAG3h08XLAgAA
X-CMS-MailID: 20220824094134epcas5p4b7cacb00484146b5d510ded15a80c712
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220824094134epcas5p4b7cacb00484146b5d510ded15a80c712
References: <20220824093109.308791-1-anuj20.g@samsung.com>
        <CGME20220824094134epcas5p4b7cacb00484146b5d510ded15a80c712@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

This patch adds support for async-passthru in t/io_uring. User needs to
specify -u1 option in the command

Example commandline:
t/io_uring -b512 -d128 -c32 -s32 -p0 -F1 -B0 -O0 -n1 -u1 /dev/ng0n1

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 t/io_uring.c | 146 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 138 insertions(+), 8 deletions(-)

diff --git a/t/io_uring.c b/t/io_uring.c
index a42abd46..78fedaf1 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -35,6 +35,7 @@
 #include "../lib/rand.h"
 #include "../minmax.h"
 #include "../os/linux/io_uring.h"
+#include "../engines/nvme.h"
 
 struct io_sq_ring {
 	unsigned *head;
@@ -139,6 +140,9 @@ static int random_io = 1;	/* random or sequential IO */
 static int register_ring = 1;	/* register ring */
 static int use_sync = 0;	/* use preadv2 */
 static int numa_placement = 0;	/* set to node of device */
+static int pt = 0;		/* passthrough I/O or not */
+static unsigned int nsid = 0;	/* nsid field required for nvme-passthrough */
+static unsigned int lbs = 0;	/* logical_block_size field required for nvme-passthrough */
 
 static unsigned long tsc_rate;
 
@@ -161,6 +165,54 @@ struct io_uring_map_buffers {
 };
 #endif
 
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
+static int nvme_get_info(int fd, __u32 *nsid, __u32 *lba_sz, __u64 *nlba)
+{
+	struct nvme_id_ns ns;
+	int namespace_id;
+	int err;
+
+	namespace_id = ioctl(fd, NVME_IOCTL_ID);
+	if (namespace_id < 0) {
+		fprintf(stderr, "error failed to fetch namespace-id\n");
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
+		fprintf(stderr, "error failed to fetch identify namespace\n");
+		close(fd);
+		return err;
+	}
+
+	*nsid = namespace_id;
+	*lba_sz = 1 << ns.lbaf[(ns.flbas & 0x0f)].ds;
+	*nlba = ns.nsze;
+
+	return 0;
+}
+
 static unsigned long cycles_to_nsec(unsigned long cycles)
 {
 	uint64_t val;
@@ -457,12 +509,13 @@ static unsigned file_depth(struct submitter *s)
 
 static void init_io(struct submitter *s, unsigned index)
 {
-	struct io_uring_sqe *sqe = &s->sqes[index];
+	struct io_uring_sqe *sqe = NULL;
 	unsigned long offset;
 	struct file *f;
 	long r;
 
 	if (do_nop) {
+		sqe = &s->sqes[index];
 		sqe->opcode = IORING_OP_NOP;
 		return;
 	}
@@ -490,6 +543,41 @@ static void init_io(struct submitter *s, unsigned index)
 			f->cur_off = 0;
 	}
 
+	if (pt) {
+		struct nvme_uring_cmd *cmd;
+		unsigned long long slba;
+		unsigned long long nlb;
+
+		sqe = &s->sqes[index<<1];
+		if (register_files) {
+			sqe->fd = f->fixed_fd;
+			sqe->flags = IOSQE_FIXED_FILE;
+		} else {
+			sqe->fd = f->real_fd;
+			sqe->flags = 0;
+		}
+		sqe->opcode = IORING_OP_URING_CMD;
+		sqe->user_data = (unsigned long) f->fileno;
+		if (stats)
+			sqe->user_data |= ((unsigned long)s->clock_index << 32);
+		sqe->cmd_op = NVME_URING_CMD_IO;
+		slba = offset / lbs;
+		nlb = bs/lbs - 1;
+		cmd = (struct nvme_uring_cmd *)&sqe->cmd;
+		memset(cmd, 0, sizeof(struct nvme_uring_cmd));
+		/* cdw10 and cdw11 represent starting slba*/
+		cmd->cdw10 = slba & 0xffffffff;
+		cmd->cdw11 = slba >> 32;
+		/* cdw12 represent number of lba to be read*/
+		cmd->cdw12 = nlb;
+		cmd->addr = (unsigned long) s->iovecs[index].iov_base;
+		cmd->data_len = bs;
+		cmd->nsid = nsid;
+		cmd->opcode = 2;
+		return;
+	}
+
+	sqe = &s->sqes[index];
 	if (register_files) {
 		sqe->flags = IOSQE_FIXED_FILE;
 		sqe->fd = f->fixed_fd;
@@ -549,7 +637,22 @@ static int get_file_size(struct file *f)
 
 	if (fstat(f->real_fd, &st) < 0)
 		return -1;
-	if (S_ISBLK(st.st_mode)) {
+	if (pt) {
+		__u64 nlba;
+		int ret;
+
+		if (!S_ISCHR(st.st_mode)) {
+			fprintf(stderr, "passthrough works with only nvme-ns "
+					"generic devices (/dev/ngXnY)\n");
+			return -1;
+		}
+		ret = nvme_get_info(f->real_fd, &nsid, &lbs, &nlba);
+		if (ret)
+			return -1;
+		f->max_blocks = nlba / bs;
+		f->max_size = nlba;
+		return 0;
+	} else if (S_ISBLK(st.st_mode)) {
 		unsigned long long bytes;
 
 		if (ioctl(f->real_fd, BLKGETSIZE64, &bytes) != 0)
@@ -587,11 +690,14 @@ static int reap_events_uring(struct submitter *s)
 
 			f = &s->files[fileno];
 			f->pending_ios--;
-			if (cqe->res != bs) {
+			if (!pt && cqe->res != bs) {
 				printf("io: unexpected ret=%d\n", cqe->res);
 				if (polled && cqe->res == -EOPNOTSUPP)
 					printf("Your filesystem/driver/kernel doesn't support polled IO\n");
 				return -1;
+			} else if (pt && cqe->res != 0) {
+				printf("io: unexpected ret=%d\n", cqe->res);
+				return -1;
 			}
 		}
 		if (stats) {
@@ -697,6 +803,7 @@ static int setup_ring(struct submitter *s)
 	struct io_uring_params p;
 	int ret, fd;
 	void *ptr;
+	size_t len;
 
 	memset(&p, 0, sizeof(p));
 
@@ -709,6 +816,10 @@ static int setup_ring(struct submitter *s)
 			p.sq_thread_cpu = sq_thread_cpu;
 		}
 	}
+	if (pt) {
+		p.flags |= IORING_SETUP_SQE128;
+		p.flags |= IORING_SETUP_CQE32;
+	}
 
 	fd = io_uring_setup(depth, &p);
 	if (fd < 0) {
@@ -761,11 +872,22 @@ static int setup_ring(struct submitter *s)
 	sring->array = ptr + p.sq_off.array;
 	sq_ring_mask = *sring->ring_mask;
 
-	s->sqes = mmap(0, p.sq_entries * sizeof(struct io_uring_sqe),
+	if (p.flags & IORING_SETUP_SQE128)
+		len = 2 * p.sq_entries * sizeof(struct io_uring_sqe);
+	else
+		len = p.sq_entries * sizeof(struct io_uring_sqe);
+	s->sqes = mmap(0, len,
 			PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE, fd,
 			IORING_OFF_SQES);
 
-	ptr = mmap(0, p.cq_off.cqes + p.cq_entries * sizeof(struct io_uring_cqe),
+	if (p.flags & IORING_SETUP_CQE32) {
+		len = p.cq_off.cqes +
+			2 * p.cq_entries * sizeof(struct io_uring_cqe);
+	} else {
+		len = p.cq_off.cqes +
+			p.cq_entries * sizeof(struct io_uring_cqe);
+	}
+	ptr = mmap(0, len,
 			PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE, fd,
 			IORING_OFF_CQ_RING);
 	cring->head = ptr + p.cq_off.head;
@@ -1306,11 +1428,12 @@ static void usage(char *argv, int status)
 		" -a <bool> : Use legacy aio, default %d\n"
 		" -S <bool> : Use sync IO (preadv2), default %d\n"
 		" -X <bool> : Use registered ring %d\n"
-		" -P <bool> : Automatically place on device home node %d\n",
+		" -P <bool> : Automatically place on device home node %d\n"
+		" -u <bool> : Use nvme-passthrough I/O, default %d\n",
 		argv, DEPTH, BATCH_SUBMIT, BATCH_COMPLETE, BS, polled,
 		fixedbufs, dma_map, register_files, nthreads, !buffered, do_nop,
 		stats, runtime == 0 ? "unlimited" : runtime_str, random_io, aio,
-		use_sync, register_ring, numa_placement);
+		use_sync, register_ring, numa_placement, pt);
 	exit(status);
 }
 
@@ -1369,7 +1492,7 @@ int main(int argc, char *argv[])
 	if (!do_nop && argc < 2)
 		usage(argv[0], 1);
 
-	while ((opt = getopt(argc, argv, "d:s:c:b:p:B:F:n:N:O:t:T:a:r:D:R:X:S:P:h?")) != -1) {
+	while ((opt = getopt(argc, argv, "d:s:c:b:p:B:F:n:N:O:t:T:a:r:D:R:X:S:P:u:h?")) != -1) {
 		switch (opt) {
 		case 'a':
 			aio = !!atoi(optarg);
@@ -1450,6 +1573,9 @@ int main(int argc, char *argv[])
 		case 'P':
 			numa_placement = !!atoi(optarg);
 			break;
+		case 'u':
+			pt = !!atoi(optarg);
+			break;
 		case 'h':
 		case '?':
 		default:
@@ -1512,6 +1638,10 @@ int main(int argc, char *argv[])
 			printf("failed getting size of device/file\n");
 			return 1;
 		}
+		if (pt && bs < lbs) {
+			printf("error: bs:%d is less than logical_block_size:%d\n", bs, lbs);
+			return 1;
+		}
 		if (f.max_blocks <= 1) {
 			printf("Zero file/device size?\n");
 			return 1;
-- 
2.25.1

