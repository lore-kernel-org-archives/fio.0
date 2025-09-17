Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5275C2D7DD8
	for <fio@vger.kernel.org>; Wed, 17 Sep 2025 07:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758093068; cv=none; b=aI53P+FX1rh6ccQo2EqooNMkjzcy0Ux7kliVGpcO5hO+5BQTOfl6mA/CMmpxBwc8K/jjt4NxUQLXdogM1/6msbgZQHdR3NcEbdrfFGr1u38KKD379BVMp7pyHGcAA2KizhpM8uVLTNDYFlga2rrYTuU/wENCi3z5tcfSW3kre+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758093068; c=relaxed/simple;
	bh=G3YYGRbb4l3V1tBHZsK/3ugdHfZro1XGJA+v73oonSw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=diiSnQf6s7g4xzpxYJs1+pG8H32GLnDioTkL+F1m4XcgxTSnxCcGVXWzahVB5upLtSaw2D0JksxuyXrCbbbzHsLObaMHX1cyL2+zhpv6EZxdwt3QA+TxmNozG0+R3U8XO1LxO7H4YTXtbpiaH6Q8/O0B9V4abXEDrhZPO2U7yAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=fDKt41/r; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="fDKt41/r"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250917071104epoutp03591b30f2c603b753c84786e685e975bf~mAFPM8qnr0172701727epoutp03d
	for <fio@vger.kernel.org>; Wed, 17 Sep 2025 07:11:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250917071104epoutp03591b30f2c603b753c84786e685e975bf~mAFPM8qnr0172701727epoutp03d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1758093064;
	bh=T0dtxvqVLjnrcR4SM7q3fR9WyCSssVQN+673Uf0LQgI=;
	h=From:To:Cc:Subject:Date:References:From;
	b=fDKt41/rmBv+twPCfWCgyoAE1k+IZELGF4LFoKQi+0fvTTUOokOZCFMsthL4AQJUm
	 opn5B4L9PeqcCmgsUtS+L0y0U+pchiQARmZ/Z6luCCQ9SzYOXqXF3ldMFI5E/sC09v
	 UCE0WDmTGDJ1PZx9HlEH2V4Gepo1C7SOuXBsSe7I=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250917071104epcas5p39848feb04e78e46835a4814ab28beac7~mAFO16t5p2679126791epcas5p3m;
	Wed, 17 Sep 2025 07:11:04 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.95]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4cRVKy6v5qz2SSL0; Wed, 17 Sep
	2025 07:11:02 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250917070310epcas5p37da73fbce2e0571548a0d840e20a445f~l-_Vd2Qlw1346713467epcas5p3g;
	Wed, 17 Sep 2025 07:03:10 +0000 (GMT)
Received: from node122.. (unknown [109.105.118.122]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20250917070308epsmtip2b36a731d2c205df72a27f4acbc036b3b~l-_UCCpce2310623106epsmtip29;
	Wed, 17 Sep 2025 07:03:08 +0000 (GMT)
From: Xiaobing Li <xiaobing.li@samsung.com>
To: fio@vger.kernel.org, axboe@kernel.dk, vincentfu@gmail.com
Cc: asml.silence@gmail.com, kun.dou@samsung.com, peiwei.li@samsung.com,
	joshi.k@samsung.com, xue01.he@samsung.com, Xiaobing Li
	<xiaobing.li@samsung.com>
Subject: [PATCH v2] t/io_uring: Vectored fixed buffer test support for nvme
 passthrough path
Date: Wed, 17 Sep 2025 06:58:38 +0000
Message-Id: <20250917065838.6204-1-xiaobing.li@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250917070310epcas5p37da73fbce2e0571548a0d840e20a445f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-505,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250917070310epcas5p37da73fbce2e0571548a0d840e20a445f
References: <CGME20250917070310epcas5p37da73fbce2e0571548a0d840e20a445f@epcas5p3.samsung.com>

The current kernel NVMe passthrough path already supports vectored IO
when using fixed buffers, but fio has not yet adapted it. This patch
aims to add a corresponding test interface in fio.

Test results:

taskset -c 1 t/io_uring -b512 -d64 -c2 -s2 -p1 -F1 -B1 -O0 -n1 -V1 -u1 -r4 /dev/ng1n1
submitter=0, tid=6179, file=/dev/ng1n1, nfiles=1, node=-1
polled=1, fixedbufs=1, register_files=1, buffered=1, QD=64
Engine=io_uring, sq_ring=64, cq_ring=64
IOPS=289.78K, BW=141MiB/s, IOS/call=1/1
IOPS=294.68K, BW=143MiB/s, IOS/call=1/1
IOPS=295.26K, BW=144MiB/s, IOS/call=1/1
Exiting on timeout
Maximum IOPS=295.26K

taskset -c 1 t/io_uring -b512 -d64 -c2 -s2 -p1 -F1 -B1 -O0 -n1 -V0 -u1 -r4 /dev/ng1n1
submitter=0, tid=6183, file=/dev/ng1n1, nfiles=1, node=-1
polled=1, fixedbufs=1, register_files=1, buffered=1, QD=64
Engine=io_uring, sq_ring=64, cq_ring=64
IOPS=292.31K, BW=142MiB/s, IOS/call=1/1
IOPS=295.79K, BW=144MiB/s, IOS/call=1/1
IOPS=290.78K, BW=141MiB/s, IOS/call=1/1
Exiting on timeout
Maximum IOPS=295.79K

Signed-off-by: Xiaobing Li <xiaobing.li@samsung.com>
---
 t/io_uring.c | 41 +++++++++++++----------------------------
 1 file changed, 13 insertions(+), 28 deletions(-)

diff --git a/t/io_uring.c b/t/io_uring.c
index 581cfe53..2a5d0c81 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -146,14 +146,13 @@ static int random_io = 1;	/* random or sequential IO */
 static int register_ring = 1;	/* register ring */
 static int use_sync = 0;	/* use preadv2 */
 static int numa_placement = 0;	/* set to node of device */
+static int vectored = 0;	/* use vectored IO */
 static int pt = 0;		/* passthrough I/O or not */
 
 static unsigned long tsc_rate;
 
 #define TSC_RATE_FILE	"tsc-rate"
 
-static int vectored = 1;
-
 static float plist[] = { 1.0, 5.0, 10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0,
 			80.0, 90.0, 95.0, 99.0, 99.5, 99.9, 99.95, 99.99 };
 static int plist_len = 17;
@@ -461,28 +460,6 @@ retry:
 	return ret;
 }
 
-static void io_uring_probe(int fd)
-{
-	struct io_uring_probe *p;
-	int ret;
-
-	p = calloc(1, sizeof(*p) + 256 * sizeof(struct io_uring_probe_op));
-	if (!p)
-		return;
-
-	ret = syscall(__NR_io_uring_register, fd, IORING_REGISTER_PROBE, p, 256);
-	if (ret < 0)
-		goto out;
-
-	if (IORING_OP_READ > p->ops_len)
-		goto out;
-
-	if ((p->ops[IORING_OP_READ].flags & IO_URING_OP_SUPPORTED))
-		vectored = 0;
-out:
-	free(p);
-}
-
 static int io_uring_enter(struct submitter *s, unsigned int to_submit,
 			  unsigned int min_complete, unsigned int flags)
 {
@@ -630,6 +607,12 @@ static void init_io_pt(struct submitter *s, unsigned index)
 		sqe->uring_cmd_flags = IORING_URING_CMD_FIXED;
 		sqe->buf_index = 0;
 	}
+	if (vectored) {
+		sqe->cmd_op = NVME_URING_CMD_IO_VEC;
+		cmd->addr = (unsigned long) &s->iovecs[index];
+		cmd->data_len = 1;
+		sqe->buf_index = 0;
+	}
 	cmd->nsid = f->nsid;
 	cmd->opcode = 2;
 }
@@ -927,8 +910,6 @@ static int setup_ring(struct submitter *s)
 	}
 	s->ring_fd = s->enter_ring_fd = fd;
 
-	io_uring_probe(fd);
-
 	if (fixedbufs) {
 		struct rlimit rlim;
 
@@ -1521,11 +1502,12 @@ static void usage(char *argv, int status)
 		" -S <bool> : Use sync IO (preadv2), default %d\n"
 		" -X <bool> : Use registered ring %d\n"
 		" -P <bool> : Automatically place on device home node %d\n"
+		" -V <bool> : Vectored IO, default %d\n"
 		" -u <bool> : Use nvme-passthrough I/O, default %d\n",
 		argv, DEPTH, BATCH_SUBMIT, BATCH_COMPLETE, BS, polled,
 		fixedbufs, register_files, nthreads, !buffered, do_nop,
 		stats, runtime == 0 ? "unlimited" : runtime_str, random_io, aio,
-		use_sync, register_ring, numa_placement, pt);
+		use_sync, register_ring, numa_placement, vectored, pt);
 	exit(status);
 }
 
@@ -1584,7 +1566,7 @@ int main(int argc, char *argv[])
 	if (!do_nop && argc < 2)
 		usage(argv[0], 1);
 
-	while ((opt = getopt(argc, argv, "d:s:c:b:p:B:F:n:N:O:t:T:a:r:D:R:X:S:P:u:h?")) != -1) {
+	while ((opt = getopt(argc, argv, "d:s:c:b:p:B:F:n:N:O:t:T:a:r:D:R:X:S:P:V:u:h?")) != -1) {
 		switch (opt) {
 		case 'a':
 			aio = !!atoi(optarg);
@@ -1662,6 +1644,9 @@ int main(int argc, char *argv[])
 		case 'P':
 			numa_placement = !!atoi(optarg);
 			break;
+		case 'V':
+			vectored = !!atoi(optarg);
+			break;
 		case 'u':
 			pt = !!atoi(optarg);
 			break;
-- 
2.34.1

