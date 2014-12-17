Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:54446 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaLQNAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 17 Dec 2014 08:00:07 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Y1ECz-0008FJ-DG
	for fio@vger.kernel.org; Wed, 17 Dec 2014 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141217130004.09A1C40161@lyth.info>
Date: Wed, 17 Dec 2014 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit f893b76d5745811033f056ae4d4efe4f571452bd:

  backend: use monotonic clock for ETA, if we have it (2014-12-15 19:54:57 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d5e16441bd7727f3e1b90708f957d42a7e47121d:

  gettime: cleanup for FIO_DEBUG_TIME (2014-12-16 23:03:54 -0700)

----------------------------------------------------------------
Jens Axboe (9):
      engines/mmap: fix segfault on large devices and 32-bit archs
      engines/mmap: clear partial mmap flag on close
      gettime: don't attempt to fixup what looks like a backwards clock
      gettime: limit warning on CPU clock
      gettime: improve gettimeofday() offload support
      gettime-thread: fix missing startup mutex
      gettime-thread: set and allow multiple CPUs
      gettime: fix overflow in cycle to usec conversion
      gettime: cleanup for FIO_DEBUG_TIME

 cconv.c          |    2 --
 engines/mmap.c   |    6 +++++
 gettime-thread.c |   29 ++++++++++++++++++++-----
 gettime.c        |   64 ++++++++++++++++++++----------------------------------
 gettime.h        |   20 +++++++++++++++++
 init.c           |   12 +++++-----
 options.c        |   12 +---------
 server.h         |    2 +-
 thread_options.h |    5 ++---
 9 files changed, 84 insertions(+), 68 deletions(-)

---

Diff of recent changes:

diff --git a/cconv.c b/cconv.c
index 0de2f5c..0fca764 100644
--- a/cconv.c
+++ b/cconv.c
@@ -219,7 +219,6 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->unified_rw_rep = le32_to_cpu(top->unified_rw_rep);
 	o->gtod_reduce = le32_to_cpu(top->gtod_reduce);
 	o->gtod_cpu = le32_to_cpu(top->gtod_cpu);
-	o->gtod_offload = le32_to_cpu(top->gtod_offload);
 	o->clocksource = le32_to_cpu(top->clocksource);
 	o->no_stall = le32_to_cpu(top->no_stall);
 	o->trim_percentage = le32_to_cpu(top->trim_percentage);
@@ -381,7 +380,6 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->unified_rw_rep = cpu_to_le32(o->unified_rw_rep);
 	top->gtod_reduce = cpu_to_le32(o->gtod_reduce);
 	top->gtod_cpu = cpu_to_le32(o->gtod_cpu);
-	top->gtod_offload = cpu_to_le32(o->gtod_offload);
 	top->clocksource = cpu_to_le32(o->clocksource);
 	top->no_stall = cpu_to_le32(o->no_stall);
 	top->trim_percentage = cpu_to_le32(o->trim_percentage);
diff --git a/engines/mmap.c b/engines/mmap.c
index 6464cba..8bcd42c 100644
--- a/engines/mmap.c
+++ b/engines/mmap.c
@@ -103,6 +103,11 @@ static int fio_mmapio_prep_full(struct thread_data *td, struct io_u *io_u)
 
 	if (fio_file_partial_mmap(f))
 		return EINVAL;
+	if (io_u->offset != (size_t) io_u->offset ||
+	    f->io_size != (size_t) f->io_size) {
+		fio_file_set_partial_mmap(f);
+		return EINVAL;
+	}
 
 	fmd->mmap_sz = f->io_size;
 	fmd->mmap_off = 0;
@@ -242,6 +247,7 @@ static int fio_mmapio_close_file(struct thread_data *td, struct fio_file *f)
 
 	FILE_SET_ENG_DATA(f, NULL);
 	free(fmd);
+	fio_file_clear_partial_mmap(f);
 
 	return generic_close_file(td, f);
 }
diff --git a/gettime-thread.c b/gettime-thread.c
index 3d49034..73632d0 100644
--- a/gettime-thread.c
+++ b/gettime-thread.c
@@ -8,11 +8,14 @@
 
 struct timeval *fio_tv = NULL;
 int fio_gtod_offload = 0;
-int fio_gtod_cpu = -1;
+static os_cpu_mask_t fio_gtod_cpumask;
 static pthread_t gtod_thread;
 
 void fio_gtod_init(void)
 {
+	if (fio_tv)
+		return;
+
 	fio_tv = smalloc(sizeof(struct timeval));
 	if (!fio_tv)
 		log_err("fio: smalloc pool exhausted\n");
@@ -20,14 +23,27 @@ void fio_gtod_init(void)
 
 static void fio_gtod_update(void)
 {
-	if (fio_tv)
-		gettimeofday(fio_tv, NULL);
+	if (fio_tv) {
+		struct timeval __tv;
+
+		gettimeofday(&__tv, NULL);
+		fio_tv->tv_sec = __tv.tv_sec;
+		write_barrier();
+		fio_tv->tv_usec = __tv.tv_usec;
+		write_barrier();
+	}
 }
 
+struct gtod_cpu_data {
+	struct fio_mutex *mutex;
+	unsigned int cpu;
+};
+
 static void *gtod_thread_main(void *data)
 {
 	struct fio_mutex *mutex = data;
 
+	fio_setaffinity(gettid(), fio_gtod_cpumask);
 	fio_mutex_up(mutex);
 
 	/*
@@ -56,7 +72,7 @@ int fio_start_gtod_thread(void)
 
 	pthread_attr_init(&attr);
 	pthread_attr_setstacksize(&attr, PTHREAD_STACK_MIN);
-	ret = pthread_create(&gtod_thread, &attr, gtod_thread_main, NULL);
+	ret = pthread_create(&gtod_thread, &attr, gtod_thread_main, mutex);
 	pthread_attr_destroy(&attr);
 	if (ret) {
 		log_err("Can't create gtod thread: %s\n", strerror(ret));
@@ -77,4 +93,7 @@ err:
 	return ret;
 }
 
-
+void fio_gtod_set_cpu(unsigned int cpu)
+{
+	fio_cpu_set(&fio_gtod_cpumask, cpu);
+}
diff --git a/gettime.c b/gettime.c
index 6a7e35f..7e3e2e5 100644
--- a/gettime.c
+++ b/gettime.c
@@ -16,13 +16,14 @@
 #if defined(ARCH_HAVE_CPU_CLOCK) && !defined(ARCH_CPU_CLOCK_CYCLES_PER_USEC)
 static unsigned long cycles_per_usec;
 static unsigned long inv_cycles_per_usec;
+static uint64_t max_cycles_for_mult;
 #endif
 int tsc_reliable = 0;
 
 struct tv_valid {
-	struct timeval last_tv;
 	uint64_t last_cycles;
 	int last_tv_valid;
+	int warned;
 };
 #ifdef CONFIG_TLS_THREAD
 static __thread struct tv_valid static_tv_valid;
@@ -64,7 +65,7 @@ static struct gtod_log *find_hash(void *caller)
 	return NULL;
 }
 
-static struct gtod_log *find_log(void *caller)
+static void inc_caller(void *caller)
 {
 	struct gtod_log *log = find_hash(caller);
 
@@ -80,16 +81,13 @@ static struct gtod_log *find_log(void *caller)
 		flist_add_tail(&log->list, &hash[h]);
 	}
 
-	return log;
+	log->calls++;
 }
 
 static void gtod_log_caller(void *caller)
 {
-	if (gtod_inited) {
-		struct gtod_log *log = find_log(caller);
-
-		log->calls++;
-	}
+	if (gtod_inited)
+		inc_caller(caller);
 }
 
 static void fio_exit fio_dump_gtod(void)
@@ -136,7 +134,7 @@ static int fill_clock_gettime(struct timespec *ts)
 }
 #endif
 
-static void *__fio_gettime(struct timeval *tp)
+static void __fio_gettime(struct timeval *tp)
 {
 	struct tv_valid *tv;
 
@@ -171,16 +169,21 @@ static void *__fio_gettime(struct timeval *tp)
 		uint64_t usecs, t;
 
 		t = get_cpu_clock();
-		if (tv && t < tv->last_cycles) {
-			dprint(FD_TIME, "CPU clock going back in time\n");
-			t = tv->last_cycles;
-		} else if (tv)
-			tv->last_cycles = t;
+		if (t < tv->last_cycles && tv->last_tv_valid &&
+		    !tv->warned) {
+			log_err("fio: CPU clock going back in time\n");
+			tv->warned = 1;
+		}
 
+		tv->last_cycles = t;
+		tv->last_tv_valid = 1;
 #ifdef ARCH_CPU_CLOCK_CYCLES_PER_USEC
 		usecs = t / ARCH_CPU_CLOCK_CYCLES_PER_USEC;
 #else
-		usecs = (t * inv_cycles_per_usec) / 16777216UL;
+		if (t < max_cycles_for_mult)
+			usecs = (t * inv_cycles_per_usec) / 16777216UL;
+		else
+			usecs = t / cycles_per_usec;
 #endif
 		tp->tv_sec = usecs / 1000000;
 		tp->tv_usec = usecs % 1000000;
@@ -191,8 +194,6 @@ static void *__fio_gettime(struct timeval *tp)
 		log_err("fio: invalid clock source %d\n", fio_clock_source);
 		break;
 	}
-
-	return tv;
 }
 
 #ifdef FIO_DEBUG_TIME
@@ -201,36 +202,16 @@ void fio_gettime(struct timeval *tp, void *caller)
 void fio_gettime(struct timeval *tp, void fio_unused *caller)
 #endif
 {
-	struct tv_valid *tv;
-
 #ifdef FIO_DEBUG_TIME
 	if (!caller)
 		caller = __builtin_return_address(0);
 
 	gtod_log_caller(caller);
 #endif
-	if (fio_unlikely(fio_tv)) {
-		memcpy(tp, fio_tv, sizeof(*tp));
+	if (fio_unlikely(fio_gettime_offload(tp)))
 		return;
-	}
 
-	tv = __fio_gettime(tp);
-
-	/*
-	 * If Linux is using the tsc clock on non-synced processors,
-	 * sometimes time can appear to drift backwards. Fix that up.
-	 */
-	if (tv) {
-		if (tv->last_tv_valid) {
-			if (tp->tv_sec < tv->last_tv.tv_sec)
-				tp->tv_sec = tv->last_tv.tv_sec;
-			else if (tv->last_tv.tv_sec == tp->tv_sec &&
-				 tp->tv_usec < tv->last_tv.tv_usec)
-				tp->tv_usec = tv->last_tv.tv_usec;
-		}
-		tv->last_tv_valid = 1;
-		memcpy(&tv->last_tv, tp, sizeof(*tp));
-	}
+	__fio_gettime(tp);
 }
 
 #if defined(ARCH_HAVE_CPU_CLOCK) && !defined(ARCH_CPU_CLOCK_CYCLES_PER_USEC)
@@ -316,6 +297,7 @@ static int calibrate_cpu_clock(void)
 
 	cycles_per_usec = avg;
 	inv_cycles_per_usec = 16777216UL / cycles_per_usec;
+	max_cycles_for_mult = ~0ULL / inv_cycles_per_usec;
 	dprint(FD_TIME, "inv_cycles_per_usec=%lu\n", inv_cycles_per_usec);
 	return 0;
 }
@@ -336,8 +318,10 @@ void fio_local_clock_init(int is_thread)
 	struct tv_valid *t;
 
 	t = calloc(1, sizeof(*t));
-	if (pthread_setspecific(tv_tls_key, t))
+	if (pthread_setspecific(tv_tls_key, t)) {
 		log_err("fio: can't set TLS key\n");
+		assert(0);
+	}
 }
 
 static void kill_tv_tls_key(void *data)
diff --git a/gettime.h b/gettime.h
index f0ad20c..b775ef3 100644
--- a/gettime.h
+++ b/gettime.h
@@ -1,6 +1,8 @@
 #ifndef FIO_GETTIME_H
 #define FIO_GETTIME_H
 
+#include "arch/arch.h"
+
 /*
  * Clock sources
  */
@@ -20,4 +22,22 @@ extern void fio_local_clock_init(int);
 
 extern struct timeval *fio_tv;
 
+static inline int fio_gettime_offload(struct timeval *tv)
+{
+	size_t last_sec;
+
+	if (!fio_tv)
+		return 0;
+
+	do {
+		read_barrier();
+		last_sec = tv->tv_sec = fio_tv->tv_sec;
+		tv->tv_usec = fio_tv->tv_usec;
+	} while (fio_tv->tv_sec != last_sec);
+
+	return 1;
+}
+
+extern void fio_gtod_set_cpu(unsigned int cpu);
+
 #endif
diff --git a/init.c b/init.c
index f606087..427768c 100644
--- a/init.c
+++ b/init.c
@@ -758,6 +758,12 @@ static int fixup_options(struct thread_data *td)
 		ret = 1;
 	}
 
+	if (fio_option_is_set(o, gtod_cpu)) {
+		fio_gtod_init();
+		fio_gtod_set_cpu(o->gtod_cpu);
+		fio_gtod_offload = 1;
+	}
+
 	return ret;
 }
 
@@ -2385,12 +2391,6 @@ int parse_options(int argc, char *argv[])
 		return 0;
 	}
 
-	if (def_thread.o.gtod_offload) {
-		fio_gtod_init();
-		fio_gtod_offload = 1;
-		fio_gtod_cpu = def_thread.o.gtod_cpu;
-	}
-
 	if (output_format == FIO_OUTPUT_NORMAL)
 		log_info("%s\n", fio_version_string);
 
diff --git a/options.c b/options.c
index a01b2d9..80a7047 100644
--- a/options.c
+++ b/options.c
@@ -1079,16 +1079,6 @@ static int str_gtod_reduce_cb(void *data, int *il)
 	return 0;
 }
 
-static int str_gtod_cpu_cb(void *data, long long *il)
-{
-	struct thread_data *td = data;
-	int val = *il;
-
-	td->o.gtod_cpu = val;
-	td->o.gtod_offload = 1;
-	return 0;
-}
-
 static int str_size_cb(void *data, unsigned long long *__val)
 {
 	struct thread_data *td = data;
@@ -3404,7 +3394,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "gtod_cpu",
 		.lname	= "Dedicated gettimeofday() CPU",
 		.type	= FIO_OPT_INT,
-		.cb	= str_gtod_cpu_cb,
+		.off1	= td_var_offset(gtod_cpu),
 		.help	= "Set up dedicated gettimeofday() thread on this CPU",
 		.verify	= gtod_cpu_verify,
 		.category = FIO_OPT_C_GENERAL,
diff --git a/server.h b/server.h
index cd3f999..dc5a69e 100644
--- a/server.h
+++ b/server.h
@@ -38,7 +38,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 41,
+	FIO_SERVER_VER			= 42,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index 530dd9a..611f8e7 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -195,7 +195,6 @@ struct thread_options {
 	unsigned int unified_rw_rep;
 	unsigned int gtod_reduce;
 	unsigned int gtod_cpu;
-	unsigned int gtod_offload;
 	enum fio_cs clocksource;
 	unsigned int no_stall;
 	unsigned int trim_percentage;
@@ -419,7 +418,6 @@ struct thread_options_pack {
 	uint32_t unified_rw_rep;
 	uint32_t gtod_reduce;
 	uint32_t gtod_cpu;
-	uint32_t gtod_offload;
 	uint32_t clocksource;
 	uint32_t no_stall;
 	uint32_t trim_percentage;
@@ -428,6 +426,7 @@ struct thread_options_pack {
 	uint64_t trim_backlog;
 	uint32_t clat_percentiles;
 	uint32_t percentile_precision;
+	uint32_t pad2;
 	fio_fp64_t percentile_list[FIO_IO_U_LIST_MAX_LEN];
 
 	uint8_t read_iolog_file[FIO_TOP_STR_MAX];
@@ -480,10 +479,10 @@ struct thread_options_pack {
 	uint64_t number_ios;
 
 	uint32_t sync_file_range;
-	uint32_t pad2;
 
 	uint64_t latency_target;
 	uint64_t latency_window;
+	uint32_t pad3;
 	fio_fp64_t latency_percentile;
 } __attribute__((packed));
 
