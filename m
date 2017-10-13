Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:58484 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753320AbdJMMAU (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 13 Oct 2017 08:00:20 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1e2ydX-00089O-Mi
        for fio@vger.kernel.org; Fri, 13 Oct 2017 12:00:19 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20171013120001.E955A2C234E@kernel.dk>
Date: Fri, 13 Oct 2017 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 447b94e10bddab8078f35c423ca1e3c3f0b1be38:

  Fix overflow in percentile calculation for Windows (2017-10-11 16:26:00 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c13a60ce72aaf5b07b93977ab86e7522d167ec28:

  flow: fix bad overflowing math (2017-10-12 10:54:27 -0600)

----------------------------------------------------------------
Andrzej Jakowski (1):
      Fix more overflows in percentile calculation for Windows

Jens Axboe (3):
      Merge branch 'overflow_fix' of https://github.com/sitsofe/fio
      Merge branch 'master' of https://github.com/Venutiwa/fio
      flow: fix bad overflowing math

Sitsofe Wheeler (1):
      gettime: fix cycles_per_msec overflow when using 32 bit longs

Venu (1):
      Adding support for multiple jobs for fio test

 examples/fio-rand-RW.job    | 18 ++++++++++++++++++
 examples/fio-rand-read.job  | 16 ++++++++++++++++
 examples/fio-rand-write.job | 16 ++++++++++++++++
 examples/fio-seq-RW.job     | 18 ++++++++++++++++++
 examples/fio-seq-read.job   | 14 ++++++++++++++
 examples/fio-seq-write.job  | 16 ++++++++++++++++
 flow.c                      | 10 +++++++---
 gclient.c                   |  2 +-
 gettime.c                   |  2 +-
 stat.c                      |  4 ++--
 stat.h                      |  2 +-
 11 files changed, 110 insertions(+), 8 deletions(-)
 create mode 100644 examples/fio-rand-RW.job
 create mode 100644 examples/fio-rand-read.job
 create mode 100644 examples/fio-rand-write.job
 create mode 100644 examples/fio-seq-RW.job
 create mode 100644 examples/fio-seq-read.job
 create mode 100644 examples/fio-seq-write.job

---

Diff of recent changes:

diff --git a/examples/fio-rand-RW.job b/examples/fio-rand-RW.job
new file mode 100644
index 0000000..0df0bc1
--- /dev/null
+++ b/examples/fio-rand-RW.job
@@ -0,0 +1,18 @@
+; fio-rand-RW.job for fiotest
+
+[global]
+name=fio-rand-RW
+filename=fio-rand-RW
+rw=randrw
+rwmixread=60
+rwmixwrite=40
+bs=4K
+direct=0
+numjobs=4
+time_based=1
+runtime=900
+
+[file1]
+size=10G
+ioengine=libaio
+iodepth=16
diff --git a/examples/fio-rand-read.job b/examples/fio-rand-read.job
new file mode 100644
index 0000000..bc15466
--- /dev/null
+++ b/examples/fio-rand-read.job
@@ -0,0 +1,16 @@
+; fio-rand-read.job for fiotest
+
+[global]
+name=fio-rand-read
+filename=fio-rand-read
+rw=randread
+bs=4K
+direct=0
+numjobs=1
+time_based=1
+runtime=900
+
+[file1]
+size=10G
+ioengine=libaio
+iodepth=16
diff --git a/examples/fio-rand-write.job b/examples/fio-rand-write.job
new file mode 100644
index 0000000..bd1b73a
--- /dev/null
+++ b/examples/fio-rand-write.job
@@ -0,0 +1,16 @@
+; fio-rand-write.job for fiotest
+
+[global]
+name=fio-rand-write
+filename=fio-rand-write
+rw=randwrite
+bs=4K
+direct=0
+numjobs=4
+time_based=1
+runtime=900
+
+[file1]
+size=10G
+ioengine=libaio
+iodepth=16
diff --git a/examples/fio-seq-RW.job b/examples/fio-seq-RW.job
new file mode 100644
index 0000000..8f7090f
--- /dev/null
+++ b/examples/fio-seq-RW.job
@@ -0,0 +1,18 @@
+; fio-seq-RW.job for fiotest
+
+[global]
+name=fio-seq-RW
+filename=fio-seq-RW
+rw=rw
+rwmixread=60
+rwmixwrite=40
+bs=256K
+direct=0
+numjobs=4
+time_based=1
+runtime=900
+
+[file1]
+size=10G
+ioengine=libaio
+iodepth=16
diff --git a/examples/fio-seq-read.job b/examples/fio-seq-read.job
new file mode 100644
index 0000000..74b1b30
--- /dev/null
+++ b/examples/fio-seq-read.job
@@ -0,0 +1,14 @@
+[global]
+name=fio-seq-reads
+filename=fio-seq-reads
+rw=read
+bs=256K
+direct=0
+numjobs=1
+time_based=1
+runtime=900
+
+[file1]
+size=10G
+ioengine=libaio
+iodepth=16
diff --git a/examples/fio-seq-write.job b/examples/fio-seq-write.job
new file mode 100644
index 0000000..b291a15
--- /dev/null
+++ b/examples/fio-seq-write.job
@@ -0,0 +1,16 @@
+; fio-seq-write.job for fiotest
+
+[global]
+name=fio-seq-write
+filename=fio-seq-write
+rw=write
+bs=256K
+direct=0
+numjobs=1
+time_based=1
+runtime=900
+
+[file1]
+size=10G
+ioengine=libaio
+iodepth=16
diff --git a/flow.c b/flow.c
index 42b6dd7..384187e 100644
--- a/flow.c
+++ b/flow.c
@@ -16,13 +16,17 @@ static struct fio_mutex *flow_lock;
 int flow_threshold_exceeded(struct thread_data *td)
 {
 	struct fio_flow *flow = td->flow;
-	int sign;
+	long long flow_counter;
 
 	if (!flow)
 		return 0;
 
-	sign = td->o.flow > 0 ? 1 : -1;
-	if (sign * flow->flow_counter > td->o.flow_watermark) {
+	if (td->o.flow > 0)
+		flow_counter = flow->flow_counter;
+	else
+		flow_counter = -flow->flow_counter;
+
+	if (flow_counter > td->o.flow_watermark) {
 		if (td->o.flow_sleep) {
 			io_u_quiesce(td);
 			usleep(td->o.flow_sleep);
diff --git a/gclient.c b/gclient.c
index 43c8a08..daa9153 100644
--- a/gclient.c
+++ b/gclient.c
@@ -1099,7 +1099,7 @@ static void gfio_show_clat_percentiles(struct gfio_client *gc,
 				       int ddir)
 {
 	unsigned int *io_u_plat = ts->io_u_plat[ddir];
-	unsigned long nr = ts->clat_stat[ddir].samples;
+	unsigned long long nr = ts->clat_stat[ddir].samples;
 	fio_fp64_t *plist = ts->percentile_list;
 	unsigned int len, scale_down;
 	unsigned long long *ovals, minv, maxv;
diff --git a/gettime.c b/gettime.c
index 7945528..1cbef84 100644
--- a/gettime.c
+++ b/gettime.c
@@ -15,7 +15,7 @@
 
 #if defined(ARCH_HAVE_CPU_CLOCK)
 #ifndef ARCH_CPU_CLOCK_CYCLES_PER_USEC
-static unsigned long cycles_per_msec;
+static unsigned long long cycles_per_msec;
 static unsigned long long cycles_start;
 static unsigned long long clock_mult;
 static unsigned long long max_cycles_mask;
diff --git a/stat.c b/stat.c
index 5c75868..c8a45db 100644
--- a/stat.c
+++ b/stat.c
@@ -135,7 +135,7 @@ static int double_cmp(const void *a, const void *b)
 	return cmp;
 }
 
-unsigned int calc_clat_percentiles(unsigned int *io_u_plat, unsigned long nr,
+unsigned int calc_clat_percentiles(unsigned int *io_u_plat, unsigned long long nr,
 				   fio_fp64_t *plist, unsigned long long **output,
 				   unsigned long long *maxv, unsigned long long *minv)
 {
@@ -198,7 +198,7 @@ unsigned int calc_clat_percentiles(unsigned int *io_u_plat, unsigned long nr,
 /*
  * Find and display the p-th percentile of clat
  */
-static void show_clat_percentiles(unsigned int *io_u_plat, unsigned long nr,
+static void show_clat_percentiles(unsigned int *io_u_plat, unsigned long long nr,
 				  fio_fp64_t *plist, unsigned int precision,
 				  bool is_clat, struct buf_output *out)
 {
diff --git a/stat.h b/stat.h
index 3fda084..6ddcad2 100644
--- a/stat.h
+++ b/stat.h
@@ -293,7 +293,7 @@ extern void init_thread_stat(struct thread_stat *ts);
 extern void init_group_run_stat(struct group_run_stats *gs);
 extern void eta_to_str(char *str, unsigned long eta_sec);
 extern bool calc_lat(struct io_stat *is, unsigned long long *min, unsigned long long *max, double *mean, double *dev);
-extern unsigned int calc_clat_percentiles(unsigned int *io_u_plat, unsigned long nr, fio_fp64_t *plist, unsigned long long **output, unsigned long long *maxv, unsigned long long *minv);
+extern unsigned int calc_clat_percentiles(unsigned int *io_u_plat, unsigned long long nr, fio_fp64_t *plist, unsigned long long **output, unsigned long long *maxv, unsigned long long *minv);
 extern void stat_calc_lat_n(struct thread_stat *ts, double *io_u_lat);
 extern void stat_calc_lat_m(struct thread_stat *ts, double *io_u_lat);
 extern void stat_calc_lat_u(struct thread_stat *ts, double *io_u_lat);
