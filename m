Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:35525 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbaKGNAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 7 Nov 2014 08:00:07 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Xmj93-0007XH-GR
	for fio@vger.kernel.org; Fri, 07 Nov 2014 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141107130003.317EB400D1@lyth.info>
Date: Fri,  7 Nov 2014 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit d6b72507e72d3f2ed334fa5665880b0ab59dbfdd:

  Get rid of __ prefix for internal frand state (2014-11-05 18:39:23 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 544992f770de2b98481b980e463e0492c2f2763e:

  smalloc: add zeroing scalloc() variant (2014-11-06 15:19:31 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      Make fio -Wshadow clean
      smalloc: add zeroing scalloc() variant

 backend.c          |    9 +++------
 client.c           |    6 ++----
 engines/e4defrag.c |    4 ++--
 eta.c              |   16 ++++++++--------
 gettime.c          |   14 +++++++-------
 io_u.c             |    1 -
 iolog.c            |   10 +++++-----
 lib/lfsr.c         |   18 +++++++++---------
 parse.c            |    4 +++-
 server.c           |   16 +++++++---------
 smalloc.c          |   11 +++++++++++
 smalloc.h          |    1 +
 t/btrace2fio.c     |    7 +++----
 13 files changed, 61 insertions(+), 56 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index cae4e38..c0b446a 100644
--- a/backend.c
+++ b/backend.c
@@ -1345,7 +1345,6 @@ static void *thread_main(void *data)
 	/* numa node setup */
 	if (o->numa_cpumask_set || o->numa_memmask_set) {
 		struct bitmask *mask;
-		int ret;
 
 		if (numa_available() < 0) {
 			td_verror(td, errno, "Does not support NUMA API\n");
@@ -1554,9 +1553,9 @@ err:
 	cgroup_shutdown(td, &cgroup_mnt);
 
 	if (o->cpumask_set) {
-		int ret = fio_cpuset_exit(&o->cpumask);
-
-		td_verror(td, ret, "fio_cpuset_exit");
+		ret = fio_cpuset_exit(&o->cpumask);
+		if (ret)
+			td_verror(td, ret, "fio_cpuset_exit");
 	}
 
 	/*
@@ -2092,8 +2091,6 @@ int fio_backend(void)
 	if (!fio_abort) {
 		__show_run_stats();
 		if (write_bw_log) {
-			int i;
-
 			for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 				struct io_log *log = agg_io_log[i];
 
diff --git a/client.c b/client.c
index edc02a0..e9eab81 100644
--- a/client.c
+++ b/client.c
@@ -654,15 +654,13 @@ static int __fio_client_send_local_ini(struct fio_client *client,
 
 	fd = open(filename, O_RDONLY);
 	if (fd < 0) {
-		int ret = -errno;
-
+		ret = -errno;
 		log_err("fio: job file <%s> open: %s\n", filename, strerror(errno));
 		return ret;
 	}
 
 	if (fstat(fd, &sb) < 0) {
-		int ret = -errno;
-
+		ret = -errno;
 		log_err("fio: job file stat: %s\n", strerror(errno));
 		close(fd);
 		return ret;
diff --git a/engines/e4defrag.c b/engines/e4defrag.c
index 6854070..d6113a9 100644
--- a/engines/e4defrag.c
+++ b/engines/e4defrag.c
@@ -98,8 +98,8 @@ static int fio_e4defrag_init(struct thread_data *td)
 	}
 
 	if (!o->inplace) {
-		long long len = td->o.file_size_high - td->o.start_offset;
-		r = fallocate(ed->donor_fd, 0, td->o.start_offset, len);
+		long long __len = td->o.file_size_high - td->o.start_offset;
+		r = fallocate(ed->donor_fd, 0, td->o.start_offset, __len);
 		if (r)
 			goto err;
 	}
diff --git a/eta.c b/eta.c
index baada7b..db08e2a 100644
--- a/eta.c
+++ b/eta.c
@@ -10,15 +10,15 @@
 static char __run_str[REAL_MAX_JOBS + 1];
 static char run_str[__THREAD_RUNSTR_SZ(REAL_MAX_JOBS)];
 
-static void update_condensed_str(char *run_str, char *run_str_condensed)
+static void update_condensed_str(char *rstr, char *run_str_condensed)
 {
-	if (*run_str) {
-		while (*run_str) {
+	if (*rstr) {
+		while (*rstr) {
 			int nr = 1;
 
-			*run_str_condensed++ = *run_str++;
-			while (*(run_str - 1) == *run_str) {
-				run_str++;
+			*run_str_condensed++ = *rstr++;
+			while (*(rstr - 1) == *rstr) {
+				rstr++;
 				nr++;
 			}
 			run_str_condensed += sprintf(run_str_condensed, "(%u),", nr);
@@ -234,11 +234,11 @@ static int thread_eta(struct thread_data *td)
 		 * if given, otherwise assume it'll run at the specified rate.
 		 */
 		if (td->o.timeout) {
-			uint64_t timeout = td->o.timeout;
+			uint64_t __timeout = td->o.timeout;
 			uint64_t start_delay = td->o.start_delay;
 			uint64_t ramp_time = td->o.ramp_time;
 
-			t_eta = timeout + start_delay + ramp_time;
+			t_eta = __timeout + start_delay + ramp_time;
 			t_eta /= 1000000ULL;
 
 			if (in_ramp_time(td)) {
diff --git a/gettime.c b/gettime.c
index 9f83620..6a7e35f 100644
--- a/gettime.c
+++ b/gettime.c
@@ -531,7 +531,7 @@ static int clock_cmp(const void *p1, const void *p2)
 
 int fio_monotonic_clocktest(void)
 {
-	struct clock_thread *threads;
+	struct clock_thread *cthreads;
 	unsigned int nr_cpus = cpus_online();
 	struct clock_entry *entries;
 	unsigned long tentries, failed = 0;
@@ -549,14 +549,14 @@ int fio_monotonic_clocktest(void)
 	fio_debug &= ~(1U << FD_TIME);
 #endif
 
-	threads = malloc(nr_cpus * sizeof(struct clock_thread));
+	cthreads = malloc(nr_cpus * sizeof(struct clock_thread));
 	tentries = CLOCK_ENTRIES * nr_cpus;
 	entries = malloc(tentries * sizeof(struct clock_entry));
 
 	log_info("cs: Testing %u CPUs\n", nr_cpus);
 
 	for (i = 0; i < nr_cpus; i++) {
-		struct clock_thread *t = &threads[i];
+		struct clock_thread *t = &cthreads[i];
 
 		t->cpu = i;
 		t->seq = &seq;
@@ -572,26 +572,26 @@ int fio_monotonic_clocktest(void)
 	}
 
 	for (i = 0; i < nr_cpus; i++) {
-		struct clock_thread *t = &threads[i];
+		struct clock_thread *t = &cthreads[i];
 
 		pthread_mutex_lock(&t->started);
 	}
 
 	for (i = 0; i < nr_cpus; i++) {
-		struct clock_thread *t = &threads[i];
+		struct clock_thread *t = &cthreads[i];
 
 		pthread_mutex_unlock(&t->lock);
 	}
 
 	for (i = 0; i < nr_cpus; i++) {
-		struct clock_thread *t = &threads[i];
+		struct clock_thread *t = &cthreads[i];
 		void *ret;
 
 		pthread_join(t->thread, &ret);
 		if (ret)
 			failed++;
 	}
-	free(threads);
+	free(cthreads);
 
 	if (failed) {
 		log_err("Clocksource test: %lu threads failed\n", failed);
diff --git a/io_u.c b/io_u.c
index d815ad9..438ad5d 100644
--- a/io_u.c
+++ b/io_u.c
@@ -206,7 +206,6 @@ static int get_next_rand_offset(struct thread_data *td, struct fio_file *f,
 		return get_off_from_method(td, f, ddir, b);
 
 	if (!flist_empty(&td->next_rand_list)) {
-		struct rand_off *r;
 fetch:
 		r = flist_first_entry(&td->next_rand_list, struct rand_off, list);
 		flist_del(&r->list);
diff --git a/iolog.c b/iolog.c
index 4a7d939..1ff64e6 100644
--- a/iolog.c
+++ b/iolog.c
@@ -871,18 +871,18 @@ int iolog_file_inflate(const char *file)
 	 */
 	total = ic.len;
 	do {
-		size_t ret;
+		size_t iret;
 
-		ret = inflate_chunk(&ic,  1, stdout, &stream, &iter);
-		total -= ret;
+		iret = inflate_chunk(&ic,  1, stdout, &stream, &iter);
+		total -= iret;
 		if (!total)
 			break;
 		if (iter.err)
 			break;
 
 		ic.seq++;
-		ic.len -= ret;
-		ic.buf += ret;
+		ic.len -= iret;
+		ic.buf += iret;
 	} while (1);
 
 	if (iter.seq) {
diff --git a/lib/lfsr.c b/lib/lfsr.c
index 329ef85..9fff50d 100644
--- a/lib/lfsr.c
+++ b/lib/lfsr.c
@@ -11,7 +11,7 @@
  * The memory overhead of the following tap table should be relatively small,
  * no more than 400 bytes.
  */
-static uint8_t taps[64][FIO_MAX_TAPS] =
+static uint8_t lfsr_taps[64][FIO_MAX_TAPS] =
 {
 	{0}, {0}, {0},		//LFSRs with less that 3-bits cannot exist
 	{3, 2},			//Tap position for 3-bit LFSR
@@ -158,12 +158,12 @@ static uint8_t *find_lfsr(uint64_t size)
 
 	/*
 	 * For an LFSR, there is always a prohibited state (all ones).
-	 * Thus, if we need to find the proper LFSR for our size, we must take that
-	 * into account.
+	 * Thus, if we need to find the proper LFSR for our size, we must
+	 * take that into account.
 	 */
 	for (i = 3; i < 64; i++)
 		if ((1UL << i) > size)
-			return taps[i];
+			return lfsr_taps[i];
 
 	return NULL;
 }
@@ -234,15 +234,15 @@ int lfsr_reset(struct fio_lfsr *fl, unsigned long seed)
 int lfsr_init(struct fio_lfsr *fl, uint64_t nums, unsigned long seed,
 		unsigned int spin)
 {
-	uint8_t *lfsr_taps;
+	uint8_t *taps;
 
-	lfsr_taps = find_lfsr(nums);
-	if (!lfsr_taps)
+	taps = find_lfsr(nums);
+	if (!taps)
 		return 1;
 
 	fl->max_val = nums - 1;
-	fl->xormask = lfsr_create_xormask(lfsr_taps);
-	fl->cached_bit = 1UL << (lfsr_taps[0] - 1);
+	fl->xormask = lfsr_create_xormask(taps);
+	fl->cached_bit = 1UL << (taps[0] - 1);
 
 	if (prepare_spin(fl, spin))
 		return 1;
diff --git a/parse.c b/parse.c
index 9e31908..282baa4 100644
--- a/parse.c
+++ b/parse.c
@@ -1081,11 +1081,13 @@ static int string_distance(const char *s1, const char *s2)
 		q[0] = p[0] + 1;
 		for (j = 1; j <= s2_len; j++) {
 			unsigned int sub = p[j - 1];
+			unsigned int pmin;
 
 			if (s1[i - 1] != s2[j - 1])
 				sub++;
 
-			q[j] = min(p[j] + 1, min(q[j - 1] + 1, sub));
+			pmin = min(q[j - 1] + 1, sub);
+			q[j] = min(p[j] + 1, pmin);
 		}
 		r = p;
 		p = q;
diff --git a/server.c b/server.c
index b5bf878..14eb199 100644
--- a/server.c
+++ b/server.c
@@ -287,14 +287,14 @@ struct fio_net_cmd *fio_net_recv_cmd(int sk)
 		/* zero-terminate text input */
 		if (cmdret->pdu_len) {
 			if (cmdret->opcode == FIO_NET_CMD_TEXT) {
-				struct cmd_text_pdu *pdu = (struct cmd_text_pdu *) cmdret->payload;
-				char *buf = (char *) pdu->buf;
+				struct cmd_text_pdu *__pdu = (struct cmd_text_pdu *) cmdret->payload;
+				char *buf = (char *) __pdu->buf;
 
-				buf[pdu->buf_len] = '\0';
+				buf[__pdu->buf_len] = '\0';
 			} else if (cmdret->opcode == FIO_NET_CMD_JOB) {
-				struct cmd_job_pdu *pdu = (struct cmd_job_pdu *) cmdret->payload;
-				char *buf = (char *) pdu->buf;
-				int len = le32_to_cpu(pdu->buf_len);
+				struct cmd_job_pdu *__pdu = (struct cmd_job_pdu *) cmdret->payload;
+				char *buf = (char *) __pdu->buf;
+				int len = le32_to_cpu(__pdu->buf_len);
 
 				buf[len] = '\0';
 			}
@@ -1209,7 +1209,6 @@ static int fio_send_iolog_gz(struct cmd_iolog_pdu *pdu, struct io_log *log)
 
 	do {
 		unsigned int this_len, flags = 0;
-		int ret;
 
 		stream.avail_out = FIO_SERVER_MAX_FRAGMENT_PDU;
 		stream.next_out = out_pdu;
@@ -1734,8 +1733,7 @@ int fio_start_server(char *pidfile)
 		free(pidfile);
 		return -1;
 	} else if (pid) {
-		int ret = write_pid(pid, pidfile);
-
+		ret = write_pid(pid, pidfile);
 		free(pidfile);
 		_exit(ret);
 	}
diff --git a/smalloc.c b/smalloc.c
index 5fe0b6f..1ba9353 100644
--- a/smalloc.c
+++ b/smalloc.c
@@ -479,6 +479,17 @@ out:
 	return NULL;
 }
 
+void *scalloc(size_t nmemb, size_t size)
+{
+	void *ret;
+
+	ret = smalloc(nmemb * size);
+	if (ret)
+		memset(ret, 0, nmemb * size);
+
+	return ret;
+}
+
 char *smalloc_strdup(const char *str)
 {
 	char *ptr;
diff --git a/smalloc.h b/smalloc.h
index f9a5e41..4b551e3 100644
--- a/smalloc.h
+++ b/smalloc.h
@@ -2,6 +2,7 @@
 #define FIO_SMALLOC_H
 
 extern void *smalloc(size_t);
+extern void *scalloc(size_t, size_t);
 extern void sfree(void *);
 extern char *smalloc_strdup(const char *);
 extern void sinit(void);
diff --git a/t/btrace2fio.c b/t/btrace2fio.c
index baf29ac..32dda92 100644
--- a/t/btrace2fio.c
+++ b/t/btrace2fio.c
@@ -450,7 +450,7 @@ static struct btrace_pid *pid_hash_get(pid_t pid)
  * Load a blktrace file by reading all the blk_io_trace entries, and storing
  * them as io_pieces like the fio text version would do.
  */
-static int load_blktrace(const char *filename, int need_swap)
+static int load_blktrace(const char *fname, int need_swap)
 {
 	struct btrace_pid *p;
 	unsigned long traces;
@@ -458,7 +458,7 @@ static int load_blktrace(const char *filename, int need_swap)
 	struct fifo *fifo;
 	int fd, ret = 0;
 
-	fd = open(filename, O_RDONLY);
+	fd = open(fname, O_RDONLY);
 	if (fd < 0) {
 		perror("open trace file\n");
 		return 1;
@@ -468,8 +468,7 @@ static int load_blktrace(const char *filename, int need_swap)
 
 	traces = 0;
 	do {
-		int ret = trace_fifo_get(fifo, fd, &t, sizeof(t));
-
+		ret = trace_fifo_get(fifo, fd, &t, sizeof(t));
 		if (ret < 0)
 			goto err;
 		else if (!ret)
