Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41058 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbaLXNAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 24 Dec 2014 08:00:05 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Y3lXo-0000iv-Mz
	for fio@vger.kernel.org; Wed, 24 Dec 2014 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141224130003.525D640128@lyth.info>
Date: Wed, 24 Dec 2014 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 3c6c5a29a74cf5727c0572b82907c330c38cea61:

  Fio 2.2.3 (2014-12-22 20:06:45 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to aad918e47d119eb2043311f1a2a45ce109c047d1:

  gettime: add basic init cpuclock test (2014-12-23 10:41:34 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      gettime: add basic init cpuclock test

 gettime.c |   70 ++++++++++++++++++++++++++++++++++++++++++-------------------
 gettime.h |    2 +-
 init.c    |    2 +-
 3 files changed, 50 insertions(+), 24 deletions(-)

---

Diff of recent changes:

diff --git a/gettime.c b/gettime.c
index 172b478..5ceb809 100644
--- a/gettime.c
+++ b/gettime.c
@@ -361,7 +361,7 @@ void fio_clock_init(void)
 	 * runs at a constant rate and is synced across CPU cores.
 	 */
 	if (tsc_reliable) {
-		if (!fio_clock_source_set)
+		if (!fio_clock_source_set && !fio_monotonic_clocktest(0))
 			fio_clock_source = CS_CPUCLOCK;
 	} else if (fio_clock_source == CS_CPUCLOCK)
 		log_info("fio: clocksource=cpu may not be reliable\n");
@@ -436,7 +436,8 @@ uint64_t time_since_now(const struct timeval *s)
 #if defined(FIO_HAVE_CPU_AFFINITY) && defined(ARCH_HAVE_CPU_CLOCK)  && \
     defined(CONFIG_SFAA)
 
-#define CLOCK_ENTRIES	100000
+#define CLOCK_ENTRIES_DEBUG	100000
+#define CLOCK_ENTRIES_TEST	10000
 
 struct clock_entry {
 	uint32_t seq;
@@ -447,8 +448,10 @@ struct clock_entry {
 struct clock_thread {
 	pthread_t thread;
 	int cpu;
+	int debug;
 	pthread_mutex_t lock;
 	pthread_mutex_t started;
+	unsigned long nr_entries;
 	uint32_t *seq;
 	struct clock_entry *entries;
 };
@@ -479,7 +482,7 @@ static void *clock_thread_fn(void *data)
 
 	last_seq = 0;
 	c = &t->entries[0];
-	for (i = 0; i < CLOCK_ENTRIES; i++, c++) {
+	for (i = 0; i < t->nr_entries; i++, c++) {
 		uint32_t seq;
 		uint64_t tsc;
 
@@ -495,8 +498,12 @@ static void *clock_thread_fn(void *data)
 		c->tsc = tsc;
 	}
 
-	log_info("cs: cpu%3d: %llu clocks seen\n", t->cpu,
-		(unsigned long long) t->entries[i - 1].tsc - t->entries[0].tsc);
+	if (t->debug) {
+		unsigned long long clocks;
+
+		clocks = t->entries[i - 1].tsc - t->entries[0].tsc;
+		log_info("cs: cpu%3d: %llu clocks seen\n", t->cpu, clocks);
+	}
 
 	/*
 	 * The most common platform clock breakage is returning zero
@@ -519,38 +526,49 @@ static int clock_cmp(const void *p1, const void *p2)
 	return c1->seq - c2->seq;
 }
 
-int fio_monotonic_clocktest(void)
+int fio_monotonic_clocktest(int debug)
 {
 	struct clock_thread *cthreads;
 	unsigned int nr_cpus = cpus_online();
 	struct clock_entry *entries;
-	unsigned long tentries, failed = 0;
+	unsigned long nr_entries, tentries, failed = 0;
 	struct clock_entry *prev, *this;
 	uint32_t seq = 0;
 	unsigned int i;
 
-	log_info("cs: reliable_tsc: %s\n", tsc_reliable ? "yes" : "no");
+	if (debug) {
+		log_info("cs: reliable_tsc: %s\n", tsc_reliable ? "yes" : "no");
 
 #ifdef FIO_INC_DEBUG
-	fio_debug |= 1U << FD_TIME;
+		fio_debug |= 1U << FD_TIME;
 #endif
+		nr_entries = CLOCK_ENTRIES_DEBUG;
+	} else
+		nr_entries = CLOCK_ENTRIES_TEST;
+
 	calibrate_cpu_clock();
+
+	if (debug) {
 #ifdef FIO_INC_DEBUG
-	fio_debug &= ~(1U << FD_TIME);
+		fio_debug &= ~(1U << FD_TIME);
 #endif
+	}
 
 	cthreads = malloc(nr_cpus * sizeof(struct clock_thread));
-	tentries = CLOCK_ENTRIES * nr_cpus;
+	tentries = nr_entries * nr_cpus;
 	entries = malloc(tentries * sizeof(struct clock_entry));
 
-	log_info("cs: Testing %u CPUs\n", nr_cpus);
+	if (debug)
+		log_info("cs: Testing %u CPUs\n", nr_cpus);
 
 	for (i = 0; i < nr_cpus; i++) {
 		struct clock_thread *t = &cthreads[i];
 
 		t->cpu = i;
+		t->debug = debug;
 		t->seq = &seq;
-		t->entries = &entries[i * CLOCK_ENTRIES];
+		t->nr_entries = nr_entries;
+		t->entries = &entries[i * nr_entries];
 		pthread_mutex_init(&t->lock, NULL);
 		pthread_mutex_init(&t->started, NULL);
 		pthread_mutex_lock(&t->lock);
@@ -584,7 +602,8 @@ int fio_monotonic_clocktest(void)
 	free(cthreads);
 
 	if (failed) {
-		log_err("Clocksource test: %lu threads failed\n", failed);
+		if (debug)
+			log_err("Clocksource test: %lu threads failed\n", failed);
 		goto err;
 	}
 
@@ -601,6 +620,11 @@ int fio_monotonic_clocktest(void)
 		if (prev->tsc > this->tsc) {
 			uint64_t diff = prev->tsc - this->tsc;
 
+			if (!debug) {
+				failed++;
+				break;
+			}
+
 			log_info("cs: CPU clock mismatch (diff=%llu):\n",
 						(unsigned long long) diff);
 			log_info("\t CPU%3u: TSC=%llu, SEQ=%u\n", prev->cpu, (unsigned long long) prev->tsc, prev->seq);
@@ -611,11 +635,12 @@ int fio_monotonic_clocktest(void)
 		prev = this;
 	}
 
-	if (failed)
-		log_info("cs: Failed: %lu\n", failed);
-	else
-		log_info("cs: Pass!\n");
-
+	if (debug) {
+		if (failed)
+			log_info("cs: Failed: %lu\n", failed);
+		else
+			log_info("cs: Pass!\n");
+	}
 err:
 	free(entries);
 	return !!failed;
@@ -623,10 +648,11 @@ err:
 
 #else /* defined(FIO_HAVE_CPU_AFFINITY) && defined(ARCH_HAVE_CPU_CLOCK) */
 
-int fio_monotonic_clocktest(void)
+int fio_monotonic_clocktest(int debug)
 {
-	log_info("cs: current platform does not support CPU clocks\n");
-	return 0;
+	if (debug)
+		log_info("cs: current platform does not support CPU clocks\n");
+	return 1;
 }
 
 #endif
diff --git a/gettime.h b/gettime.h
index b775ef3..eb3537b 100644
--- a/gettime.h
+++ b/gettime.h
@@ -17,7 +17,7 @@ extern void fio_gettime(struct timeval *, void *);
 extern void fio_gtod_init(void);
 extern void fio_clock_init(void);
 extern int fio_start_gtod_thread(void);
-extern int fio_monotonic_clocktest(void);
+extern int fio_monotonic_clocktest(int debug);
 extern void fio_local_clock_init(int);
 
 extern struct timeval *fio_tv;
diff --git a/init.c b/init.c
index d3dec0a..dc563fd 100644
--- a/init.c
+++ b/init.c
@@ -2238,7 +2238,7 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 		case 'T':
 			did_arg = 1;
 			do_exit++;
-			exit_val = fio_monotonic_clocktest();
+			exit_val = fio_monotonic_clocktest(1);
 			break;
 		case 'G':
 			did_arg = 1;
