Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C5D3FE658
	for <fio@vger.kernel.org>; Wed, 13 May 2026 12:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778673616; cv=none; b=tjAdPOClul9jIegdbRBVQu9Fog9YPm98Vu1EONx1yGO/uGGq9E3Fmyl3unVCn5qrS45aCqhp1/vWhS7tL+mwNn4iCouflrdZTvoJTbIHQh9VaV02Va8bvttCNjOfiKKgVEl7r14AFQARs3rt0dpeu+3kWxdtXV5T1zr66YRuDPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778673616; c=relaxed/simple;
	bh=V+JVTgWyqznfeLqgswBUKiBnO5zM8LxGKE7Z6FkaMwo=;
	h=Subject:From:To:Date:Message-Id; b=dZJdnBC0Ubhl451F6SlsipyyrYbxkfy3HwLDlbEHjezf2hwZ6WMelk1XbJqXRjv4i/+UfUzxq8f51MkE4mU3FOUBgHp7IPxAVMI9zM0z0+IQhs3E2vTOKexgyFMvkS2yEmPuqNR1F16k4a35yDZ3yE33QBOogU5XWgyRNw7OsWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=abEf6BCi; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="abEf6BCi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=kFnps8ioThwCo3nRAiIK41WNAajwERk7haortBNDzNQ=; b=abEf6BCijtROROg++zlgUrgNuE
	+7DnJnwx+2+B3PtOu/RaISaGZxqfAAwxqF3QyOrmIxjIMDgVcWI87hUNHlOghMqPUuzgvkW6eCu7C
	9lnEYlCNkIfweN90EXknKFgXJBjwYLjyunazs/sWZTaWSmx8ePEK3tM+ihZmTLVIZYhom98Ly4jQH
	JLQgDrcCv5NSjmxJd8xOg16WQdFDuACp7Lj1nt8eVhaVG4l3ePE0Ss8Wt0z2sR84Btwds8NCH151T
	ScpjqfTclBu0TU+eAgbkhcD2kza7emzwCdMqg9VZYAd4tFTIohj4KIbn1GcjIs6Cq8dVRzggIzEO9
	H473ZANA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wN8Fw-0000000HMNZ-2xOV
	for fio@vger.kernel.org;
	Wed, 13 May 2026 12:00:09 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id F15F51BC0165; Wed, 13 May 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Wed, 13 May 2026 06:00:01 -0600
Message-Id: <20260513120001.F15F51BC0165@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 72156dca3d41df7d05ea4e5a4e59623c2d393a92:

  Merge branch 'codex/cgroup-path-overflows' of https://github.com/linuxholic/fio (2026-04-30 06:53:46 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 3ea531dfc54aaccb6a5846f37e6cfefedd7ff60e:

  Merge branch 't_io_uring_htlb' of https://github.com/ming1/fio (2026-05-12 10:21:09 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 't_io_uring_htlb' of https://github.com/ming1/fio

Ming Lei (1):
      t/io_uring: add --hugetlb option for hugetlbfs IO buffers

 t/io_uring.c | 70 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 68 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/t/io_uring.c b/t/io_uring.c
index 0a04af4e..64d30d95 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -114,12 +114,20 @@ struct submitter {
 	int per_file_depth;
 	const char *filename;
 
+	void *htlb_buf;		/* pre-assigned hugetlb buffer */
+
 	struct file files[MAX_FDS];
 	unsigned nr_files;
 	unsigned cur_file;
 	struct iovec iovecs[];
 };
 
+struct htlb_alloc {
+	char *path;		/* hugetlbfs file path */
+	void *base;		/* mmap base */
+	size_t size;		/* total mmap size */
+};
+
 static struct submitter *submitter;
 static volatile int finish;
 static int stats_running;
@@ -149,6 +157,7 @@ static int numa_placement = 0;	/* set to node of device */
 static int vectored = 0;	/* use vectored IO */
 static int pt = 0;		/* passthrough I/O or not */
 static int restriction = 0;	/* for testing restriction filter */
+static struct htlb_alloc htlb;
 
 static unsigned long tsc_rate;
 
@@ -1034,6 +1043,11 @@ static void *allocate_mem(struct submitter *s, int size)
 {
 	void *buf;
 
+	if (s->htlb_buf) {
+		buf = s->htlb_buf;
+		s->htlb_buf = (char *)buf + size;
+		return buf;
+	}
 #ifdef CONFIG_LIBNUMA
 	if (s->numa_node != -1)
 		return numa_alloc_onnode(size, s->numa_node);
@@ -1531,6 +1545,51 @@ static void arm_sig_int(void)
 #endif
 }
 
+static int setup_hugetlb(void)
+{
+	size_t needed, per_thread;
+	struct stat st;
+	int fd, j;
+
+	fd = open(htlb.path, O_RDWR);
+	if (fd < 0) {
+		perror("open hugetlb file");
+		return -1;
+	}
+
+	if (fstat(fd, &st) < 0 || st.st_size <= 0) {
+		fprintf(stderr, "hugetlb file %s: invalid size\n", htlb.path);
+		close(fd);
+		return -1;
+	}
+
+	htlb.size = st.st_size;
+	needed = (size_t)nthreads * bs * roundup_pow2(depth);
+	if (htlb.size < needed) {
+		fprintf(stderr, "hugetlb file too small: %zu < %zu "
+			"(%d threads × %d bs × %d depth)\n",
+			htlb.size, needed, nthreads, bs, roundup_pow2(depth));
+		close(fd);
+		return -1;
+	}
+
+	htlb.base = mmap(NULL, htlb.size, PROT_READ | PROT_WRITE,
+			 MAP_SHARED | MAP_POPULATE, fd, 0);
+	close(fd);
+	if (htlb.base == MAP_FAILED) {
+		perror("mmap hugetlb file");
+		htlb.base = NULL;
+		return -1;
+	}
+
+	per_thread = bs * roundup_pow2(depth);
+	for (j = 0; j < nthreads; j++)
+		get_submitter(j)->htlb_buf = (char *)htlb.base + j * per_thread;
+
+	printf("Using hugetlb file %s, size %zu\n", htlb.path, htlb.size);
+	return 0;
+}
+
 static void usage(char *argv, int status)
 {
 	char runtime_str[16];
@@ -1556,7 +1615,8 @@ static void usage(char *argv, int status)
 		" -P <bool> : Automatically place on device home node %d\n"
 		" -V <bool> : Vectored IO, default %d\n"
 		" -e <bool> : Set restriction filter on opcodes %d\n"
-		" -u <bool> : Use nvme-passthrough I/O, default %d\n",
+		" -u <bool> : Use nvme-passthrough I/O, default %d\n"
+		" -H <path> : Use hugetlbfs file for IO buffers\n",
 		argv, DEPTH, BATCH_SUBMIT, BATCH_COMPLETE, BS, polled,
 		fixedbufs, register_files, nthreads, !buffered, do_nop,
 		stats, runtime == 0 ? "unlimited" : runtime_str, random_io, aio,
@@ -1620,7 +1680,7 @@ int main(int argc, char *argv[])
 	if (!do_nop && argc < 2)
 		usage(argv[0], 1);
 
-	while ((opt = getopt(argc, argv, "e:d:s:c:b:p:B:F:n:N:O:t:T:a:r:D:R:X:S:P:V:u:h?")) != -1) {
+	while ((opt = getopt(argc, argv, "e:d:s:c:b:p:B:F:H:n:N:O:t:T:a:r:D:R:X:S:P:V:u:h?")) != -1) {
 		switch (opt) {
 		case 'a':
 			aio = !!atoi(optarg);
@@ -1707,6 +1767,9 @@ int main(int argc, char *argv[])
 		case 'e':
 			restriction = !!atoi(optarg);
 			break;
+		case 'H':
+			htlb.path = strdup(optarg);
+			break;
 		case 'h':
 		case '?':
 		default:
@@ -1802,6 +1865,9 @@ int main(int argc, char *argv[])
 	if (t_io_uring_page_size < 0)
 		t_io_uring_page_size = 4096;
 
+	if (htlb.path && setup_hugetlb())
+		return 1;
+
 	for (j = 0; j < nthreads; j++) {
 		s = get_submitter(j);
 		if (use_sync)
