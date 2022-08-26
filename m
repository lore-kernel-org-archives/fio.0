Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9409ECAAD4
	for <fio@archiver.kernel.org>; Fri, 26 Aug 2022 11:45:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245632AbiHZLpC (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 26 Aug 2022 07:45:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243750AbiHZLpB (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 26 Aug 2022 07:45:01 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3710F67C8E
        for <fio@vger.kernel.org>; Fri, 26 Aug 2022 04:44:58 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220826114456epoutp01214174a430f041125ad7006d95da7e11~O4nMat-Wd0152101521epoutp01b
        for <fio@vger.kernel.org>; Fri, 26 Aug 2022 11:44:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220826114456epoutp01214174a430f041125ad7006d95da7e11~O4nMat-Wd0152101521epoutp01b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1661514296;
        bh=8UYrAaqBE9EpSVMM8/V96f02+D8DR/n4DfQcb/W4Jnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R4IY6LMY5O1BL0i1vofIdxLSKvlVjg/Luq4iPeueF/rtZkDzUt9anLxxBJs+K4VPY
         56/mtlfaLNFN6YpqhfbG/K7yIyXk2FiFwqbrKEe3MiMYOyok+ECuPLJ46w8jXcp6iK
         nruU86m2ZoAL8rWEAUigfJgAoJyp9P5j4vbTOV8s=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220826114455epcas5p153be9655eaa2a19e81c83a5fd5d65d0b~O4nLwcK-A2886828868epcas5p1H;
        Fri, 26 Aug 2022 11:44:55 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.179]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4MDdKx1R2qz4x9Pv; Fri, 26 Aug
        2022 11:44:53 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        5D.E8.54060.532B8036; Fri, 26 Aug 2022 20:44:53 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220826114312epcas5p3adb78ca25ec4dae7655940e96f5cdd85~O4lrgx_Vc2547825478epcas5p3f;
        Fri, 26 Aug 2022 11:43:12 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220826114312epsmtrp291218f70ea7d244d0f547fa58a6b8ddf~O4lrf9QXD2360523605epsmtrp2b;
        Fri, 26 Aug 2022 11:43:12 +0000 (GMT)
X-AuditID: b6c32a4b-be1ff7000000d32c-76-6308b2356645
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D8.F7.14392.0D1B8036; Fri, 26 Aug 2022 20:43:12 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220826114311epsmtip250cb0c06f4d2702b081eb0954fecca9f~O4lqV1G2I2750827508epsmtip2V;
        Fri, 26 Aug 2022 11:43:11 +0000 (GMT)
From:   Anuj Gupta <anuj20.g@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     joshi.k@samsung.com, ankit.kumar@samsung.com, fio@vger.kernel.org,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v2 2/2] t/io_uring: add support for async-passthru
Date:   Fri, 26 Aug 2022 17:03:06 +0530
Message-Id: <20220826113306.4139-3-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220826113306.4139-1-anuj20.g@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42LZdlhTQ9d0E0eywf8j7BZrrvxmt2ia8JfZ
        YvXdfjaLj7NeMFsc/f+WzWJDm6ADm8fOWXfZPS6fLfXo27KK0ePzJrkAlqhsm4zUxJTUIoXU
        vOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg1UoKZYk5pUChgMTiYiV9
        O5ui/NKSVIWM/OISW6XUgpScApMCveLE3OLSvHS9vNQSK0MDAyNToMKE7IxzTz8yFlwJqLj1
        fiVLA+Msuy5GTg4JAROJrc9PsHQxcnEICexmlOiesoAJwvnEKHFsfSMbhPONUaLpXjsrTMvy
        mfegWvYySpzf+x4sISTwmVHi0uwiEJtNQF3iyPNWxi5GDg4RAQ2JNXdTQcLMAlkSL39cACsX
        FnCSeDb9DBuIzSKgKvGzYQE7iM0rYCFx7HMD1C55iZmXvoPFOQUsJa4c/8ICUSMocXLmExaI
        mfISzVtnM4PcIyFwiV3iyM4PzCB7JQRcJObs0YSYIyzx6vgWdghbSuLzu71sEHa6xI/LT5kg
        7AKJ5mP7GCFse4nWU/1gY5gFNCXW79KHCMtKTD21jgliLZ9E7+8nUK28EjvmwdhKEu0r50DZ
        EhJ7zzVA2R4Sn28cZYQEWw+jxK4/69kmMCrMQvLOLCTvzEJYvYCReRWjZGpBcW56arFpgXFe
        ajk8jpPzczcxghOjlvcOxkcPPugdYmTiYDzEKMHBrCTCa3WMJVmINyWxsiq1KD++qDQntfgQ
        oykwvCcyS4km5wNTc15JvKGJpYGJmZmZiaWxmaGSOO8UbcZkIYH0xJLU7NTUgtQimD4mDk6p
        BqYYl5S1RqkfPeWCq5hV+0VzS56F3fu79eeN1CMZqz7v7xc4YNzb0zTt4UuLFdo8wbdlXtra
        CJsuFJ4c82D9GaX4/qcnD7805kmctGcdp+ja5tyetbbL7Za4cb3l8xaVmfsxoOLC+6MmtdNj
        F4RceLV+4nsBnbUmH9/Ym57VTn64JOaH7OtgI33/Gn774sNs0tMsFNOuczIu26yvdGJX7osc
        tWzX13dsub893zD/Z9Rbgwjpp0tC5FZuitaLbL/ybcH3F6YRzW1Mwpvbtpwpv9N5yL9B+7JD
        0KuzNiXCd70+vt5wr7DU7o/rUouXf25XM8451pHM/OtbUEL0wjq//TcOzAxJbVLaP4t1247p
        +d1KLMUZiYZazEXFiQAwLlD7FQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsWy7bCSvO6FjRzJBitnC1usufKb3aJpwl9m
        i9V3+9ksPs56wWxx9P9bNosNbYIObB47Z91l97h8ttSjb8sqRo/Pm+QCWKK4bFJSczLLUov0
        7RK4Ms49/chYcCWg4tb7lSwNjLPsuhg5OSQETCSWz7zH0sXIxSEksJtR4tL686wQCQmJUy+X
        MULYwhIr/z1nhyj6yCjR9PozG0iCTUBd4sjzVrAiEQEtiWPrmsDizAJ5El13z7GA2MICThLP
        pp8Bi7MIqEr8bFjADmLzClhIHPvcALVMXmLmpe9gcU4BS4krx7+A9QoB1Zxc/YkJol5Q4uTM
        JywQ8+UlmrfOZp7AKDALSWoWktQCRqZVjJKpBcW56bnFhgWGeanlesWJucWleel6yfm5mxjB
        4auluYNx+6oPeocYmTgYDzFKcDArifBaHWNJFuJNSaysSi3Kjy8qzUktPsQozcGiJM57oetk
        vJBAemJJanZqakFqEUyWiYNTqoEpv52p1fbSzYqaiUa1Ucc6llS5ZF03OrJByevaLy6zeXY8
        5zZF2GXv3HZWkmkl6+bbpXJztZw1thp335034TH7SvXmguMHNHMnxz3/cr9z2gs71uhb/za+
        udYZlD/7Qv3y3zsPbJd8ZvStyV5tz+2bxzc5CO9MzZY5zc1xrnpG4E22ZFYPwdRrr/tNTJct
        uax66aX0ORa7wA9JotLCkzdeTPC81/VLZl2FisuhNUV8okkdG4w6V2dN3urYFu767kxZNc+5
        G9/djt1Sff5702Eu8arZtTu9p+XVlTU9fveva52CuOydSROfZm7cZ63lUn9cWWXVz4wIvsVT
        dYOnMXrdFHzNvPmZmvHRgiv9ru+ElViKMxINtZiLihMBSAftMM4CAAA=
X-CMS-MailID: 20220826114312epcas5p3adb78ca25ec4dae7655940e96f5cdd85
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220826114312epcas5p3adb78ca25ec4dae7655940e96f5cdd85
References: <20220826113306.4139-1-anuj20.g@samsung.com>
        <CGME20220826114312epcas5p3adb78ca25ec4dae7655940e96f5cdd85@epcas5p3.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

This patch adds support for async-passthru in t/io_uring. User needs to
specify -u1 option in the command

Example commandline:
t/io_uring -b512 -d128 -c32 -s32 -p0 -F1 -B0 -O0 -n1 -u1 /dev/ng0n1

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 t/io_uring.c | 238 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 230 insertions(+), 8 deletions(-)

diff --git a/t/io_uring.c b/t/io_uring.c
index a42abd46..4e1d617f 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -35,6 +35,7 @@
 #include "../lib/rand.h"
 #include "../minmax.h"
 #include "../os/linux/io_uring.h"
+#include "../engines/nvme.h"
 
 struct io_sq_ring {
 	unsigned *head;
@@ -67,6 +68,8 @@ struct file {
 	unsigned long max_size;
 	unsigned long cur_off;
 	unsigned pending_ios;
+	unsigned int nsid;	/* nsid field required for nvme-passthrough */
+	unsigned int lba_shift;	/* lba_shift field required for nvme-passthrough */
 	int real_fd;
 	int fixed_fd;
 	int fileno;
@@ -139,6 +142,7 @@ static int random_io = 1;	/* random or sequential IO */
 static int register_ring = 1;	/* register ring */
 static int use_sync = 0;	/* use preadv2 */
 static int numa_placement = 0;	/* set to node of device */
+static int pt = 0;		/* passthrough I/O or not */
 
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
@@ -520,6 +572,65 @@ static void init_io(struct submitter *s, unsigned index)
 		sqe->user_data |= ((uint64_t)s->clock_index << 32);
 }
 
+static void init_io_pt(struct submitter *s, unsigned index)
+{
+	struct io_uring_sqe *sqe = &s->sqes[index << 1];
+	unsigned long offset;
+	struct file *f;
+	struct nvme_uring_cmd *cmd;
+	unsigned long long slba;
+	unsigned long long nlb;
+	long r;
+
+	if (s->nr_files == 1) {
+		f = &s->files[0];
+	} else {
+		f = &s->files[s->cur_file];
+		if (f->pending_ios >= file_depth(s)) {
+			s->cur_file++;
+			if (s->cur_file == s->nr_files)
+				s->cur_file = 0;
+			f = &s->files[s->cur_file];
+		}
+	}
+	f->pending_ios++;
+
+	if (random_io) {
+		r = __rand64(&s->rand_state);
+		offset = (r % (f->max_blocks - 1)) * bs;
+	} else {
+		offset = f->cur_off;
+		f->cur_off += bs;
+		if (f->cur_off + bs > f->max_size)
+			f->cur_off = 0;
+	}
+
+	if (register_files) {
+		sqe->fd = f->fixed_fd;
+		sqe->flags = IOSQE_FIXED_FILE;
+	} else {
+		sqe->fd = f->real_fd;
+		sqe->flags = 0;
+	}
+	sqe->opcode = IORING_OP_URING_CMD;
+	sqe->user_data = (unsigned long) f->fileno;
+	if (stats)
+		sqe->user_data |= ((unsigned long)s->clock_index << 32);
+	sqe->cmd_op = NVME_URING_CMD_IO;
+	slba = offset >> f->lba_shift;
+	nlb = (bs >> f->lba_shift) - 1;
+	cmd = (struct nvme_uring_cmd *)&sqe->cmd;
+	/* cdw10 and cdw11 represent starting slba*/
+	cmd->cdw10 = slba & 0xffffffff;
+	cmd->cdw11 = slba >> 32;
+	/* cdw12 represent number of lba to be read*/
+	cmd->cdw12 = nlb;
+	cmd->addr = (unsigned long) s->iovecs[index].iov_base;
+	cmd->data_len = bs;
+	cmd->nsid = f->nsid;
+	cmd->opcode = 2;
+}
+
 static int prep_more_ios_uring(struct submitter *s, int max_ios)
 {
 	struct io_sq_ring *ring = &s->sq_ring;
@@ -532,7 +643,10 @@ static int prep_more_ios_uring(struct submitter *s, int max_ios)
 			break;
 
 		index = tail & sq_ring_mask;
-		init_io(s, index);
+		if (pt)
+			init_io_pt(s, index);
+		else
+			init_io(s, index);
 		ring->array[index] = index;
 		prepped++;
 		tail = next_tail;
@@ -549,7 +663,29 @@ static int get_file_size(struct file *f)
 
 	if (fstat(f->real_fd, &st) < 0)
 		return -1;
-	if (S_ISBLK(st.st_mode)) {
+	if (pt) {
+		__u64 nlba;
+		__u32 lbs;
+		int ret;
+
+		if (!S_ISCHR(st.st_mode)) {
+			fprintf(stderr, "passthrough works with only nvme-ns "
+					"generic devices (/dev/ngXnY)\n");
+			return -1;
+		}
+		ret = nvme_get_info(f->real_fd, &f->nsid, &lbs, &nlba);
+		if (ret)
+			return -1;
+		if ((bs % lbs) != 0) {
+			printf("error: bs:%d should be a multiple logical_block_size:%d\n",
+					bs, lbs);
+			return -1;
+		}
+		f->max_blocks = nlba / bs;
+		f->max_size = nlba;
+		f->lba_shift = ilog2(lbs);
+		return 0;
+	} else if (S_ISBLK(st.st_mode)) {
 		unsigned long long bytes;
 
 		if (ioctl(f->real_fd, BLKGETSIZE64, &bytes) != 0)
@@ -620,6 +756,60 @@ static int reap_events_uring(struct submitter *s)
 	return reaped;
 }
 
+static int reap_events_uring_pt(struct submitter *s)
+{
+	struct io_cq_ring *ring = &s->cq_ring;
+	struct io_uring_cqe *cqe;
+	unsigned head, reaped = 0;
+	int last_idx = -1, stat_nr = 0;
+	unsigned index;
+	int fileno;
+
+	head = *ring->head;
+	do {
+		struct file *f;
+
+		read_barrier();
+		if (head == atomic_load_acquire(ring->tail))
+			break;
+		index = head & cq_ring_mask;
+		cqe = &ring->cqes[index << 1];
+		fileno = cqe->user_data & 0xffffffff;
+		f = &s->files[fileno];
+		f->pending_ios--;
+
+		if (cqe->res != 0) {
+			printf("io: unexpected ret=%d\n", cqe->res);
+			if (polled && cqe->res == -EINVAL)
+				printf("passthrough doesn't support polled IO\n");
+			return -1;
+		}
+		if (stats) {
+			int clock_index = cqe->user_data >> 32;
+
+			if (last_idx != clock_index) {
+				if (last_idx != -1) {
+					add_stat(s, last_idx, stat_nr);
+					stat_nr = 0;
+				}
+				last_idx = clock_index;
+			}
+			stat_nr++;
+		}
+		reaped++;
+		head++;
+	} while (1);
+
+	if (stat_nr)
+		add_stat(s, last_idx, stat_nr);
+
+	if (reaped) {
+		s->inflight -= reaped;
+		atomic_store_release(ring->head, head);
+	}
+	return reaped;
+}
+
 static void set_affinity(struct submitter *s)
 {
 #ifdef CONFIG_LIBNUMA
@@ -697,6 +887,7 @@ static int setup_ring(struct submitter *s)
 	struct io_uring_params p;
 	int ret, fd;
 	void *ptr;
+	size_t len;
 
 	memset(&p, 0, sizeof(p));
 
@@ -709,6 +900,10 @@ static int setup_ring(struct submitter *s)
 			p.sq_thread_cpu = sq_thread_cpu;
 		}
 	}
+	if (pt) {
+		p.flags |= IORING_SETUP_SQE128;
+		p.flags |= IORING_SETUP_CQE32;
+	}
 
 	fd = io_uring_setup(depth, &p);
 	if (fd < 0) {
@@ -761,11 +956,22 @@ static int setup_ring(struct submitter *s)
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
@@ -856,7 +1062,16 @@ static int submitter_init(struct submitter *s)
 		s->plat = NULL;
 		nr_batch = 0;
 	}
+	/* perform the expensive command initialization part for passthrough here
+	 * rather than in the fast path
+	 */
+	if (pt) {
+		for (i = 0; i < roundup_pow2(depth); i++) {
+			struct io_uring_sqe *sqe = &s->sqes[i << 1];
 
+			memset(&sqe->cmd, 0, sizeof(struct nvme_uring_cmd));
+		}
+	}
 	return nr_batch;
 }
 
@@ -1112,7 +1327,10 @@ submit:
 		do {
 			int r;
 
-			r = reap_events_uring(s);
+			if (pt)
+				r = reap_events_uring_pt(s);
+			else
+				r = reap_events_uring(s);
 			if (r == -1) {
 				s->finish = 1;
 				break;
@@ -1306,11 +1524,12 @@ static void usage(char *argv, int status)
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
 
@@ -1369,7 +1588,7 @@ int main(int argc, char *argv[])
 	if (!do_nop && argc < 2)
 		usage(argv[0], 1);
 
-	while ((opt = getopt(argc, argv, "d:s:c:b:p:B:F:n:N:O:t:T:a:r:D:R:X:S:P:h?")) != -1) {
+	while ((opt = getopt(argc, argv, "d:s:c:b:p:B:F:n:N:O:t:T:a:r:D:R:X:S:P:u:h?")) != -1) {
 		switch (opt) {
 		case 'a':
 			aio = !!atoi(optarg);
@@ -1450,6 +1669,9 @@ int main(int argc, char *argv[])
 		case 'P':
 			numa_placement = !!atoi(optarg);
 			break;
+		case 'u':
+			pt = !!atoi(optarg);
+			break;
 		case 'h':
 		case '?':
 		default:
-- 
2.25.1

