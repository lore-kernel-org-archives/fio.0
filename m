Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A14C5ECAAD2
	for <fio@archiver.kernel.org>; Sat, 27 Aug 2022 12:00:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiH0MAO (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 27 Aug 2022 08:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiH0MAN (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 27 Aug 2022 08:00:13 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F87252B3
        for <fio@vger.kernel.org>; Sat, 27 Aug 2022 05:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=aVSu/tMs6U/yGClgXjb4dLowvu8DEWWzV+3Rzjbxhls=; b=Qco+zbrbXKAYbta4jClgMzUUPF
        nWLTtSZPMB2iZAvVZ0ZpcU1CxAO3RqRI0UvdS8aChYnwHNb0WEOb4IWsdXvEhw/Hi9JAdFzgGVDro
        frXO4Q3/fDucEklv/4OclqqGEx6fZozSOT8C+yO8gsQRe9gPq3mE6Yaxipz2JnCoN3fh/HkyYVWJ7
        mNQlwrh5WehkC0QOIwngpSvu0entlAG1bkxUMe2bBQ4XZrXQnoKdRpm16vVy3tgshqlArmP9SWNwA
        169aBZlmIay7G8sEAkwsQ5NaE3X5akEbPFHIltI5u0JAcgxf2m3GC3my0MIFvg0arxPf5UXdOGYbg
        KnTExsWg==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oRuTt-006gxZ-CL
        for fio@vger.kernel.org; Sat, 27 Aug 2022 12:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id EDF481BC0138; Sat, 27 Aug 2022 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220827120001.EDF481BC0138@kernel.dk>
Date:   Sat, 27 Aug 2022 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit c27ae7ae6c3d9108bba80ff71cf36bf7fc8b34c9:

  engines/io_uring: delete debug code (2022-08-25 11:19:34 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a5a2429ece9b2a7e35e2b8a0248e7b1de6d075c3:

  t/io_uring: remove duplicate definition of gettid() (2022-08-26 14:17:40 -0600)

----------------------------------------------------------------
Anuj Gupta (2):
      t/io_uring: prep for including engines/nvme.h in t/io_uring
      t/io_uring: add support for async-passthru

Jens Axboe (2):
      t/io_uring: fix 64-bit cast on 32-bit archs
      t/io_uring: remove duplicate definition of gettid()

Vincent Fu (1):
      test: add basic test for io_uring ioengine

 t/io_uring.c       | 264 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 t/jobs/t0018.fio   |   9 ++
 t/run-fio-tests.py |  22 +++++
 3 files changed, 271 insertions(+), 24 deletions(-)
 create mode 100644 t/jobs/t0018.fio

---

Diff of recent changes:

diff --git a/t/io_uring.c b/t/io_uring.c
index f34a3554..e8e41796 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -30,11 +30,13 @@
 #include <sched.h>
 
 #include "../arch/arch.h"
+#include "../os/os.h"
 #include "../lib/types.h"
 #include "../lib/roundup.h"
 #include "../lib/rand.h"
 #include "../minmax.h"
 #include "../os/linux/io_uring.h"
+#include "../engines/nvme.h"
 
 struct io_sq_ring {
 	unsigned *head;
@@ -67,6 +69,8 @@ struct file {
 	unsigned long max_size;
 	unsigned long cur_off;
 	unsigned pending_ios;
+	unsigned int nsid;	/* nsid field required for nvme-passthrough */
+	unsigned int lba_shift;	/* lba_shift field required for nvme-passthrough */
 	int real_fd;
 	int fixed_fd;
 	int fileno;
@@ -117,7 +121,7 @@ static struct submitter *submitter;
 static volatile int finish;
 static int stats_running;
 static unsigned long max_iops;
-static long page_size;
+static long t_io_uring_page_size;
 
 static int depth = DEPTH;
 static int batch_submit = BATCH_SUBMIT;
@@ -139,6 +143,7 @@ static int random_io = 1;	/* random or sequential IO */
 static int register_ring = 1;	/* register ring */
 static int use_sync = 0;	/* use preadv2 */
 static int numa_placement = 0;	/* set to node of device */
+static int pt = 0;		/* passthrough I/O or not */
 
 static unsigned long tsc_rate;
 
@@ -161,6 +166,54 @@ struct io_uring_map_buffers {
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
@@ -195,9 +248,9 @@ static unsigned long plat_idx_to_val(unsigned int idx)
 	return cycles_to_nsec(base + ((k + 0.5) * (1 << error_bits)));
 }
 
-unsigned int calc_clat_percentiles(unsigned long *io_u_plat, unsigned long nr,
-				   unsigned long **output,
-				   unsigned long *maxv, unsigned long *minv)
+unsigned int calculate_clat_percentiles(unsigned long *io_u_plat,
+		unsigned long nr, unsigned long **output,
+		unsigned long *maxv, unsigned long *minv)
 {
 	unsigned long sum = 0;
 	unsigned int len = plist_len, i, j = 0;
@@ -251,7 +304,7 @@ static void show_clat_percentiles(unsigned long *io_u_plat, unsigned long nr,
 	bool is_last;
 	char fmt[32];
 
-	len = calc_clat_percentiles(io_u_plat, nr, &ovals, &maxv, &minv);
+	len = calculate_clat_percentiles(io_u_plat, nr, &ovals, &maxv, &minv);
 	if (!len || !ovals)
 		goto out;
 
@@ -443,13 +496,6 @@ static int io_uring_enter(struct submitter *s, unsigned int to_submit,
 #endif
 }
 
-#ifndef CONFIG_HAVE_GETTID
-static int gettid(void)
-{
-	return syscall(__NR_gettid);
-}
-#endif
-
 static unsigned file_depth(struct submitter *s)
 {
 	return (depth + s->nr_files - 1) / s->nr_files;
@@ -520,6 +566,65 @@ static void init_io(struct submitter *s, unsigned index)
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
+		sqe->user_data |= ((__u64) s->clock_index << 32ULL);
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
@@ -532,7 +637,10 @@ static int prep_more_ios_uring(struct submitter *s, int max_ios)
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
@@ -549,7 +657,29 @@ static int get_file_size(struct file *f)
 
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
@@ -620,6 +750,60 @@ static int reap_events_uring(struct submitter *s)
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
@@ -697,6 +881,7 @@ static int setup_ring(struct submitter *s)
 	struct io_uring_params p;
 	int ret, fd;
 	void *ptr;
+	size_t len;
 
 	memset(&p, 0, sizeof(p));
 
@@ -709,6 +894,10 @@ static int setup_ring(struct submitter *s)
 			p.sq_thread_cpu = sq_thread_cpu;
 		}
 	}
+	if (pt) {
+		p.flags |= IORING_SETUP_SQE128;
+		p.flags |= IORING_SETUP_CQE32;
+	}
 
 	fd = io_uring_setup(depth, &p);
 	if (fd < 0) {
@@ -761,11 +950,22 @@ static int setup_ring(struct submitter *s)
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
@@ -786,7 +986,7 @@ static void *allocate_mem(struct submitter *s, int size)
 		return numa_alloc_onnode(size, s->numa_node);
 #endif
 
-	if (posix_memalign(&buf, page_size, bs)) {
+	if (posix_memalign(&buf, t_io_uring_page_size, bs)) {
 		printf("failed alloc\n");
 		return NULL;
 	}
@@ -855,7 +1055,16 @@ static int submitter_init(struct submitter *s)
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
 
@@ -1111,7 +1320,10 @@ submit:
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
@@ -1305,11 +1517,12 @@ static void usage(char *argv, int status)
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
 
@@ -1368,7 +1581,7 @@ int main(int argc, char *argv[])
 	if (!do_nop && argc < 2)
 		usage(argv[0], 1);
 
-	while ((opt = getopt(argc, argv, "d:s:c:b:p:B:F:n:N:O:t:T:a:r:D:R:X:S:P:h?")) != -1) {
+	while ((opt = getopt(argc, argv, "d:s:c:b:p:B:F:n:N:O:t:T:a:r:D:R:X:S:P:u:h?")) != -1) {
 		switch (opt) {
 		case 'a':
 			aio = !!atoi(optarg);
@@ -1449,6 +1662,9 @@ int main(int argc, char *argv[])
 		case 'P':
 			numa_placement = !!atoi(optarg);
 			break;
+		case 'u':
+			pt = !!atoi(optarg);
+			break;
 		case 'h':
 		case '?':
 		default:
@@ -1542,9 +1758,9 @@ int main(int argc, char *argv[])
 
 	arm_sig_int();
 
-	page_size = sysconf(_SC_PAGESIZE);
-	if (page_size < 0)
-		page_size = 4096;
+	t_io_uring_page_size = sysconf(_SC_PAGESIZE);
+	if (t_io_uring_page_size < 0)
+		t_io_uring_page_size = 4096;
 
 	for (j = 0; j < nthreads; j++) {
 		s = get_submitter(j);
diff --git a/t/jobs/t0018.fio b/t/jobs/t0018.fio
new file mode 100644
index 00000000..e2298b1f
--- /dev/null
+++ b/t/jobs/t0018.fio
@@ -0,0 +1,9 @@
+# Expected result: job completes without error
+# Buggy result: job fails
+
+[test]
+ioengine=io_uring
+filesize=256K
+time_based
+runtime=3s
+rw=randrw
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index 504b7cdb..1e5e9f24 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -582,6 +582,7 @@ class Requirements(object):
 
     _linux = False
     _libaio = False
+    _io_uring = False
     _zbd = False
     _root = False
     _zoned_nullb = False
@@ -605,6 +606,12 @@ class Requirements(object):
                 Requirements._zbd = "CONFIG_HAS_BLKZONED" in contents
                 Requirements._libaio = "CONFIG_LIBAIO" in contents
 
+            contents, success = FioJobTest.get_file("/proc/kallsyms")
+            if not success:
+                print("Unable to open '/proc/kallsyms' to probe for io_uring support")
+            else:
+                Requirements._io_uring = "io_uring_setup" in contents
+
             Requirements._root = (os.geteuid() == 0)
             if Requirements._zbd and Requirements._root:
                 try:
@@ -627,6 +634,7 @@ class Requirements(object):
 
         req_list = [Requirements.linux,
                     Requirements.libaio,
+                    Requirements.io_uring,
                     Requirements.zbd,
                     Requirements.root,
                     Requirements.zoned_nullb,
@@ -648,6 +656,11 @@ class Requirements(object):
         """Is libaio available?"""
         return Requirements._libaio, "libaio required"
 
+    @classmethod
+    def io_uring(cls):
+        """Is io_uring available?"""
+        return Requirements._io_uring, "io_uring required"
+
     @classmethod
     def zbd(cls):
         """Is ZBD support available?"""
@@ -867,6 +880,15 @@ TEST_LIST = [
         'output_format':    'json',
         'requirements':     [Requirements.not_windows],
     },
+    {
+        'test_id':          18,
+        'test_class':       FioJobTest,
+        'job':              't0018.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          None,
+        'pre_success':      None,
+        'requirements':     [Requirements.linux, Requirements.io_uring],
+    },
     {
         'test_id':          1000,
         'test_class':       FioExeTest,
