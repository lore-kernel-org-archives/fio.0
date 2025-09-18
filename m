Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330D3308F09
	for <fio@vger.kernel.org>; Thu, 18 Sep 2025 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758196812; cv=none; b=kDxV55DJ+5VM4M6JKn0fhEzq2o0NgGNu9byqOyZZRn7OIFm/wREF7zwjzq91MzUEK0DKfxRN5Eem6pF62ekyz5Hauwq4yRop2aIJXZudbmSxws0nbySttUf2bZU3zfoxVo4nJ4Omhs8AA3XcVTpIAnFgg94wTxzJ4eqEKMBOhss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758196812; c=relaxed/simple;
	bh=JhGKYo15i9cpNgdXH58Wwfw5d+5K+pd20LgBM8HKeok=;
	h=Subject:From:To:Message-Id:Date; b=cEDSjpxcWPX9hsqsdf6HnjLc2E/j92fcqRsMukOjPaKu+c28RE29V6fCgzQHw3m2sR2G/v2PJ/nL6cb0NzRfSs2xWvXJNHk3rD/artURadnvtM42XssiagK6MiYoPCPAOtIRxf85T7DoORh5lEZN5hP9KvOAjY6wEyqmrozoIhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kDavXXgk; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kDavXXgk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=1mhqC93en2GnBJlEwMTuheJKsGRvFTyjLsvZL1sdb4s=; b=kDavXXgky/o1i2OZAoCrrroQiH
	LFMKp63Q6QXjBXnW8KuiNowdIgN9r13ExB8B4Xf1sBJLVXsnMbD2WL5rSsFsYx9xYKxD5jGumA4D2
	CbPhS4C9VaaWiawZtbvfpH6JtMRpsm2ZCx3WuaG+CviAoZNdYl8ioVdlaeXMGz6D7vCmCboDdGYV3
	zBSmvxgW9qtOnMlp5C48l7pYtsfL5K1UJJGDLHN6hO607cwqbKEPH4bnqgVgA4G38Uz8BdwYbRlhN
	nAU5D2LiA6NbY2WedC0qlzRmNztQxRNzRZV57ykChhoBjAOjyC3HA59LY2hOXoRHcGr1e/IgBMEBx
	D/OOMjhg==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzDIy-00000007bWd-2Okt
	for fio@vger.kernel.org;
	Thu, 18 Sep 2025 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id DB6761BC0130; Thu, 18 Sep 2025 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250918120001.DB6761BC0130@kernel.dk>
Date: Thu, 18 Sep 2025 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 2c573a35f3d6b67723114af9e6dffad1e94474bc:

  stat: used shared sem for stats lock (2025-09-16 10:08:57 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 80d72cb05a6c54ea1b256dcd69e3e4fdc9294f4f:

  t/io_uring: Vectored fixed buffer test support for nvme passthrough path (2025-09-17 07:19:51 -0600)

----------------------------------------------------------------
Xiaobing Li (1):
      t/io_uring: Vectored fixed buffer test support for nvme passthrough path

 t/io_uring.c | 41 +++++++++++++----------------------------
 1 file changed, 13 insertions(+), 28 deletions(-)

---

Diff of recent changes:

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
