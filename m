Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33892 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbbA2NAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 29 Jan 2015 08:00:05 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YGohY-0001xZ-Mv
	for fio@vger.kernel.org; Thu, 29 Jan 2015 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150129130003.3BFF240184@lyth.info>
Date: Thu, 29 Jan 2015 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 209e10374bb57565f0a61286d1ed8effd50fa95c:

  parse: ensure strings are pre-terminated when using strncpy() (2015-01-22 14:51:56 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 54ed125bb0deffa937286e64367ed8e4e94413f1:

  idletime: maintain cpuset over lifetime of idle thread (2015-01-28 14:47:48 -0700)

----------------------------------------------------------------
Felipe Franciosi (1):
      Fixing typo

Jens Axboe (3):
      gettime: if setaffinity fails, print the errno error
      gettime: initialize cpusets properly
      idletime: maintain cpuset over lifetime of idle thread

Justin Eno (1):
      Better accommodate random writes larger than blockalign

Vasily Tarasov (1):
      dedupe_percentage should work even if compress_percentage is not set

 README     |    2 +-
 gettime.c  |   20 ++++++++++++++++----
 idletime.c |   26 +++++++++++++++++++-------
 idletime.h |    2 ++
 io_u.c     |    5 ++++-
 5 files changed, 42 insertions(+), 13 deletions(-)

---

Diff of recent changes:

diff --git a/README b/README
index 0917544..18d1c4f 100644
--- a/README
+++ b/README
@@ -311,7 +311,7 @@ to load a local file as well. This is done by using --remote-config:
 
 fio --client=server --remote-config /path/to/file.fio
 
-Then the fio serer will open this local (to the server) job file instead
+Then the fio server will open this local (to the server) job file instead
 of being passed one from the client.
 
 
diff --git a/gettime.c b/gettime.c
index 72968c5..8419fe4 100644
--- a/gettime.c
+++ b/gettime.c
@@ -477,12 +477,20 @@ static void *clock_thread_fn(void *data)
 	uint32_t last_seq;
 	int i;
 
-	memset(&cpu_mask, 0, sizeof(cpu_mask));
+	if (fio_cpuset_init(&cpu_mask)) {
+		int __err;
+
+		log_err("clock cpuset init failed: %s\n", strerror(__err));
+		goto err_out;
+	}
+
 	fio_cpu_set(&cpu_mask, t->cpu);
 
 	if (fio_setaffinity(gettid(), cpu_mask) == -1) {
-		log_err("clock setaffinity failed\n");
-		return (void *) 1;
+		int __err = errno;
+
+		log_err("clock setaffinity failed: %s\n", strerror(__err));
+		goto err;
 	}
 
 	pthread_mutex_lock(&t->lock);
@@ -518,9 +526,13 @@ static void *clock_thread_fn(void *data)
 	 * indefinitely. Check for that and return failure.
 	 */
 	if (!t->entries[i - 1].tsc && !t->entries[0].tsc)
-		return (void *) 1;
+		goto err;
 
 	return NULL;
+err:
+	fio_cpuset_exit(&cpu_mask);
+err_out:
+	return (void *) 1;
 }
 
 static int clock_cmp(const void *p1, const void *p2)
diff --git a/idletime.c b/idletime.c
index a366d2b..db272fe 100644
--- a/idletime.c
+++ b/idletime.c
@@ -43,16 +43,26 @@ static double calibrate_unit(unsigned char *data)
 	return tunit / CALIBRATE_SCALE;
 }
 
+static void free_cpu_affinity(struct idle_prof_thread *ipt)
+{
+#if defined(FIO_HAVE_CPU_AFFINITY)
+	fio_cpuset_exit(&ipt->cpu_mask);
+#endif
+}
+
 static int set_cpu_affinity(struct idle_prof_thread *ipt)
 {
 #if defined(FIO_HAVE_CPU_AFFINITY)
-	os_cpu_mask_t cpu_mask;
+	if (fio_cpuset_init(&ipt->cpu_mask)) {
+		log_err("fio: cpuset init failed\n");
+		return -1;
+	}
 
-	memset(&cpu_mask, 0, sizeof(cpu_mask));
-	fio_cpu_set(&cpu_mask, ipt->cpu);
+	fio_cpu_set(&ipt->cpu_mask, ipt->cpu);
 
-	if (fio_setaffinity(gettid(), cpu_mask)) {
+	if (fio_setaffinity(gettid(), ipt->cpu_mask)) {
 		log_err("fio: fio_setaffinity failed\n");
+		fio_cpuset_exit(&ipt->cpu_mask);
 		return -1;
 	}
 
@@ -98,7 +108,7 @@ static void *idle_prof_thread_fn(void *data)
 	if (retval == -1) {
 		ipt->state = TD_EXITED;
 		pthread_mutex_unlock(&ipt->init_lock);
-		return NULL;
+		goto do_exit;
 	}
 
 	ipt->state = TD_INITIALIZED;
@@ -113,13 +123,13 @@ static void *idle_prof_thread_fn(void *data)
 	/* exit if other threads failed to initialize */
 	if (ipc.status == IDLE_PROF_STATUS_ABORT) {
 		pthread_mutex_unlock(&ipt->start_lock);
-		return NULL;
+		goto do_exit;
 	}
 
 	/* exit if we are doing calibration only */
 	if (ipc.status == IDLE_PROF_STATUS_CALI_STOP) {
 		pthread_mutex_unlock(&ipt->start_lock);
-		return NULL;
+		goto do_exit;
 	}
 
 	fio_gettime(&ipt->tps, NULL);
@@ -143,6 +153,8 @@ idle_prof_done:
 	ipt->state = TD_EXITED;
 	pthread_mutex_unlock(&ipt->start_lock);
 
+do_exit:
+	free_cpu_affinity(ipt);
 	return NULL;
 }
 
diff --git a/idletime.h b/idletime.h
index 819da25..bd6dcef 100644
--- a/idletime.h
+++ b/idletime.h
@@ -34,6 +34,8 @@ struct idle_prof_thread {
 	pthread_cond_t  cond;
 	pthread_mutex_t init_lock;
 	pthread_mutex_t start_lock;
+
+	os_cpu_mask_t cpu_mask;
 };
 
 struct idle_prof_common {
diff --git a/io_u.c b/io_u.c
index 5971d78..f61fee8 100644
--- a/io_u.c
+++ b/io_u.c
@@ -68,6 +68,9 @@ static uint64_t last_block(struct thread_data *td, struct fio_file *f,
 	if (td->o.zone_range)
 		max_size = td->o.zone_range;
 
+	if (td->o.min_bs[ddir] > td->o.ba[ddir])
+		max_size -= td->o.min_bs[ddir] - td->o.ba[ddir];
+
 	max_blocks = max_size / (uint64_t) td->o.ba[ddir];
 	if (!max_blocks)
 		return 0;
@@ -1866,7 +1869,7 @@ void fill_io_buffer(struct thread_data *td, void *buf, unsigned int min_write,
 {
 	struct thread_options *o = &td->o;
 
-	if (o->compress_percentage) {
+	if (o->compress_percentage || o->dedupe_percentage) {
 		unsigned int perc = td->o.compress_percentage;
 		struct frand_state *rs;
 		unsigned int left = max_bs;
