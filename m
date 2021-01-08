Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbhAHNAs (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 8 Jan 2021 08:00:48 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97950C0612F6
        for <fio@vger.kernel.org>; Fri,  8 Jan 2021 05:00:07 -0800 (PST)
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kxrN7-0004LD-4H
        for fio@vger.kernel.org; Fri, 08 Jan 2021 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210108130001.AD56B1BC014F@kernel.dk>
Date: Fri,  8 Jan 2021 06:00:01 -0700 (MST)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 59f94d26f98e9c0bc18d4e013f3361c51a2c6b25:

  Change ARRAY_SIZE to FIO_ARRAY_SIZE (2021-01-06 11:32:59 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 8f14dc61422df3b1eaee1293a7d10ba791c8084c:

  Merge branch 'cpu-engine' of https://github.com/bvanassche/fio (2021-01-07 20:53:00 -0700)

----------------------------------------------------------------
Bart Van Assche (1):
      engines/cpu: Fix td_vmsg() call

Erwan Velu (1):
      engines/cpu: Adding qsort capabilities

Jens Axboe (3):
      Merge branch 'evelu-qsort' of https://github.com/ErwanAliasr1/fio
      engines/cpu: style cleanups
      Merge branch 'cpu-engine' of https://github.com/bvanassche/fio

 HOWTO              |   6 +-
 engines/cpu.c      | 233 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 examples/cpuio.fio |  14 +++-
 fio.1              |  21 +++--
 4 files changed, 254 insertions(+), 20 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index d663166d..0547c721 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1912,12 +1912,14 @@ I/O engine
 
 		**cpuio**
 			Doesn't transfer any data, but burns CPU cycles according to the
-			:option:`cpuload` and :option:`cpuchunks` options. Setting
-			:option:`cpuload`\=85 will cause that job to do nothing but burn 85%
+			:option:`cpuload`, :option:`cpuchunks` and :option:`cpumode` options.
+			Setting :option:`cpuload`\=85 will cause that job to do nothing but burn 85%
 			of the CPU. In case of SMP machines, use :option:`numjobs`\=<nr_of_cpu>
 			to get desired CPU usage, as the cpuload only loads a
 			single CPU at the desired rate. A job never finishes unless there is
 			at least one non-cpuio job.
+			Setting :option:`cpumode`\=qsort replace the default noop instructions loop
+			by a qsort algorithm to consume more energy.
 
 		**rdma**
 			The RDMA I/O engine supports both RDMA memory semantics
diff --git a/engines/cpu.c b/engines/cpu.c
index 4d572b44..ccbfe003 100644
--- a/engines/cpu.c
+++ b/engines/cpu.c
@@ -8,11 +8,26 @@
 #include "../fio.h"
 #include "../optgroup.h"
 
+// number of 32 bit integers to sort
+size_t qsort_size = (256 * (1ULL << 10)); // 256KB
+
+struct mwc {
+	uint32_t w;
+	uint32_t z;
+};
+
+enum stress_mode {
+	FIO_CPU_NOOP = 0,
+	FIO_CPU_QSORT = 1,
+};
+
 struct cpu_options {
 	void *pad;
 	unsigned int cpuload;
 	unsigned int cpucycle;
+	enum stress_mode cpumode;
 	unsigned int exit_io_done;
+	int32_t *qsort_data;
 };
 
 static struct fio_option options[] = {
@@ -25,6 +40,26 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_INVALID,
 	},
+	{
+		.name     = "cpumode",
+		.lname    = "cpumode",
+		.type     = FIO_OPT_STR,
+		.help     = "Stress mode",
+		.off1     = offsetof(struct cpu_options, cpumode),
+		.def      = "noop",
+		.posval = {
+			  { .ival = "noop",
+			    .oval = FIO_CPU_NOOP,
+			    .help = "NOOP instructions",
+			  },
+			  { .ival = "qsort",
+			    .oval = FIO_CPU_QSORT,
+			    .help = "QSORT computation",
+			  },
+		},
+		.category = FIO_OPT_C_ENGINE,
+		.group    = FIO_OPT_G_INVALID,
+	},
 	{
 		.name	= "cpuchunks",
 		.lname	= "CPU chunk",
@@ -52,6 +87,91 @@ static struct fio_option options[] = {
 	},
 };
 
+/*
+ *  mwc32()
+ *      Multiply-with-carry random numbers
+ *      fast pseudo random number generator, see
+ *      http://www.cse.yorku.ca/~oz/marsaglia-rng.html
+ */
+uint32_t mwc32(struct mwc *mwc)
+{
+        mwc->z = 36969 * (mwc->z & 65535) + (mwc->z >> 16);
+        mwc->w = 18000 * (mwc->w & 65535) + (mwc->w >> 16);
+        return (mwc->z << 16) + mwc->w;
+}
+
+/*
+ *  stress_qsort_cmp_1()
+ *	qsort comparison - sort on int32 values
+ */
+static int stress_qsort_cmp_1(const void *p1, const void *p2)
+{
+	const int32_t *i1 = (const int32_t *)p1;
+	const int32_t *i2 = (const int32_t *)p2;
+
+	if (*i1 > *i2)
+		return 1;
+	else if (*i1 < *i2)
+		return -1;
+	else
+		return 0;
+}
+
+/*
+ *  stress_qsort_cmp_2()
+ *	qsort comparison - reverse sort on int32 values
+ */
+static int stress_qsort_cmp_2(const void *p1, const void *p2)
+{
+	return stress_qsort_cmp_1(p2, p1);
+}
+
+/*
+ *  stress_qsort_cmp_3()
+ *	qsort comparison - sort on int8 values
+ */
+static int stress_qsort_cmp_3(const void *p1, const void *p2)
+{
+	const int8_t *i1 = (const int8_t *)p1;
+	const int8_t *i2 = (const int8_t *)p2;
+
+	/* Force re-ordering on 8 bit value */
+	return *i1 - *i2;
+}
+
+static int do_qsort(struct thread_data *td)
+{
+	struct thread_options *o = &td->o;
+	struct cpu_options *co = td->eo;
+	struct timespec start, now;
+
+	fio_get_mono_time(&start);
+
+	/* Sort "random" data */
+	qsort(co->qsort_data, qsort_size, sizeof(*(co->qsort_data)), stress_qsort_cmp_1);
+
+	/* Reverse sort */
+	qsort(co->qsort_data, qsort_size, sizeof(*(co->qsort_data)), stress_qsort_cmp_2);
+
+	/* And re-order by byte compare */
+	qsort((uint8_t *)co->qsort_data, qsort_size * 4, sizeof(uint8_t), stress_qsort_cmp_3);
+
+	/* Reverse sort this again */
+	qsort(co->qsort_data, qsort_size, sizeof(*(co->qsort_data)), stress_qsort_cmp_2);
+	fio_get_mono_time(&now);
+
+	/* Adjusting cpucycle automatically to be as close as possible to the
+	 * expected cpuload The time to execute do_qsort() may change over time
+	 * as per : - the job concurrency - the cpu clock adjusted by the power
+	 * management After every do_qsort() call, the next thinktime is
+	 * adjusted regarding the last run performance
+	 */
+	co->cpucycle = utime_since(&start, &now);
+	o->thinktime = ((unsigned long long) co->cpucycle *
+				(100 - co->cpuload)) / co->cpuload;
+
+	return 0;
+}
 
 static enum fio_q_status fio_cpuio_queue(struct thread_data *td,
 					 struct io_u fio_unused *io_u)
@@ -63,14 +183,69 @@ static enum fio_q_status fio_cpuio_queue(struct thread_data *td,
 		return FIO_Q_BUSY;
 	}
 
-	usec_spin(co->cpucycle);
+	switch (co->cpumode) {
+	case FIO_CPU_NOOP:
+		usec_spin(co->cpucycle);
+		break;
+	case FIO_CPU_QSORT:
+		do_qsort(td);
+		break;
+	}
+
 	return FIO_Q_COMPLETED;
 }
 
+static int noop_init(struct thread_data *td)
+{
+	struct cpu_options *co = td->eo;
+
+	log_info("%s (noop): ioengine=%s, cpuload=%u, cpucycle=%u\n",
+		td->o.name, td->io_ops->name, co->cpuload, co->cpucycle);
+	return 0;
+}
+
+static int qsort_cleanup(struct thread_data *td)
+{
+	struct cpu_options *co = td->eo;
+
+	if (co->qsort_data) {
+		free(co->qsort_data);
+		co->qsort_data = NULL;
+	}
+
+	return 0;
+}
+
+static int qsort_init(struct thread_data *td)
+{
+	/* Setting up a default entropy */
+	struct mwc mwc = { 521288629UL, 362436069UL };
+	struct cpu_options *co = td->eo;
+	int32_t *ptr;
+	int i;
+
+	co->qsort_data = calloc(qsort_size, sizeof(*co->qsort_data));
+	if (co->qsort_data == NULL) {
+		td_verror(td, ENOMEM, "qsort_init");
+		return 1;
+	}
+
+	/* This is expensive, init the memory once */
+	for (ptr = co->qsort_data, i = 0; i < qsort_size; i++)
+		*ptr++ = mwc32(&mwc);
+
+	log_info("%s (qsort): ioengine=%s, cpuload=%u, cpucycle=%u\n",
+		td->o.name, td->io_ops->name, co->cpuload, co->cpucycle);
+
+	return 0;
+}
+
 static int fio_cpuio_init(struct thread_data *td)
 {
 	struct thread_options *o = &td->o;
 	struct cpu_options *co = td->eo;
+	int td_previous_state;
+	char *msg;
 
 	if (!co->cpuload) {
 		td_vmsg(td, EINVAL, "cpu thread needs rate (cpuload=)","cpuio");
@@ -80,21 +255,58 @@ static int fio_cpuio_init(struct thread_data *td)
 	if (co->cpuload > 100)
 		co->cpuload = 100;
 
+	/* Saving the current thread state */
+	td_previous_state = td->runstate;
+
+	/* Reporting that we are preparing the engine
+	 * This is useful as the qsort() calibration takes time
+	 * This prevents the job from starting before init is completed
+	 */
+	td_set_runstate(td, TD_SETTING_UP);
+
 	/*
 	 * set thinktime_sleep and thinktime_spin appropriately
 	 */
 	o->thinktime_blocks = 1;
 	o->thinktime_spin = 0;
-	o->thinktime = ((unsigned long long) co->cpucycle * (100 - co->cpuload)) / co->cpuload;
+	o->thinktime = ((unsigned long long) co->cpucycle *
+				(100 - co->cpuload)) / co->cpuload;
 
 	o->nr_files = o->open_files = 1;
 
-	log_info("%s: ioengine=%s, cpuload=%u, cpucycle=%u\n",
-		td->o.name, td->io_ops->name, co->cpuload, co->cpucycle);
+	switch (co->cpumode) {
+	case FIO_CPU_NOOP:
+		noop_init(td);
+		break;
+	case FIO_CPU_QSORT:
+		qsort_init(td);
+		break;
+	default:
+		if (asprintf(&msg, "bad cpu engine mode: %d", co->cpumode) < 0)
+			msg = NULL;
+		td_vmsg(td, EINVAL, msg ? : "(?)", __func__);
+		free(msg);
+		return 1;
+	}
 
+	/* Let's restore the previous state. */
+	td_set_runstate(td, td_previous_state);
 	return 0;
 }
 
+static void fio_cpuio_cleanup(struct thread_data *td)
+{
+	struct cpu_options *co = td->eo;
+
+	switch (co->cpumode) {
+	case FIO_CPU_NOOP:
+		break;
+	case FIO_CPU_QSORT:
+		qsort_cleanup(td);
+		break;
+	}
+}
+
 static int fio_cpuio_open(struct thread_data fio_unused *td,
 			  struct fio_file fio_unused *f)
 {
@@ -102,12 +314,13 @@ static int fio_cpuio_open(struct thread_data fio_unused *td,
 }
 
 static struct ioengine_ops ioengine = {
-	.name		= "cpuio",
-	.version	= FIO_IOOPS_VERSION,
-	.queue		= fio_cpuio_queue,
-	.init		= fio_cpuio_init,
-	.open_file	= fio_cpuio_open,
-	.flags		= FIO_SYNCIO | FIO_DISKLESSIO | FIO_NOIO,
+	.name			= "cpuio",
+	.version		= FIO_IOOPS_VERSION,
+	.queue			= fio_cpuio_queue,
+	.init			= fio_cpuio_init,
+	.cleanup		= fio_cpuio_cleanup,
+	.open_file		= fio_cpuio_open,
+	.flags			= FIO_SYNCIO | FIO_DISKLESSIO | FIO_NOIO,
 	.options		= options,
 	.option_struct_size	= sizeof(struct cpu_options),
 };
diff --git a/examples/cpuio.fio b/examples/cpuio.fio
index 577e0729..471cf4b2 100644
--- a/examples/cpuio.fio
+++ b/examples/cpuio.fio
@@ -1,8 +1,18 @@
 [global]
 ioengine=cpuio
 time_based
-runtime=10
+runtime=15
 
-[burn50percent]
+# The following example load 2 cores at 50% with the noop (default) mode
+[burn_2x50_noop]
 cpuload=50
+numjobs=2
+cpumode=noop
 
+# Once burn_2x50_noop is over,
+# fio load 2 cores at 50% with the qsort mode which drains much more power
+[burn_2x50%_qsort]
+stonewall
+cpuload=50
+numjobs=2
+cpumode=qsort
diff --git a/fio.1 b/fio.1
index b29ac437..e361b05f 100644
--- a/fio.1
+++ b/fio.1
@@ -1690,12 +1690,21 @@ This engine defines engine specific options.
 .TP
 .B cpuio
 Doesn't transfer any data, but burns CPU cycles according to the
-\fBcpuload\fR and \fBcpuchunks\fR options. Setting
-\fBcpuload\fR\=85 will cause that job to do nothing but burn 85%
-of the CPU. In case of SMP machines, use `numjobs=<nr_of_cpu>'
-to get desired CPU usage, as the cpuload only loads a
-single CPU at the desired rate. A job never finishes unless there is
-at least one non-cpuio job.
+\fBcpuload\fR, \fBcpuchunks\fR and \fBcpumode\fR options.
+A job never finishes unless there is at least one non-cpuio job.
+.RS
+.P
+.PD 0
+\fBcpuload\fR\=85 will cause that job to do nothing but burn 85% of the CPU.
+In case of SMP machines, use \fBnumjobs=<nr_of_cpu>\fR\ to get desired CPU usage,
+as the cpuload only loads a single CPU at the desired rate.
+
+.P
+\fBcpumode\fR\=qsort replace the default noop instructions loop
+by a qsort algorithm to consume more energy.
+
+.P
+.RE
 .TP
 .B rdma
 The RDMA I/O engine supports both RDMA memory semantics

