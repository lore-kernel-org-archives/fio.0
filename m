Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB0F117D5
	for <fio@vger.kernel.org>; Sat,  4 Nov 2023 12:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mfS7S+Rn"
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E1F7B6
	for <fio@vger.kernel.org>; Sat,  4 Nov 2023 05:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=5gs3PRwjgAPw76M4XCcVqXI9D2RLoeQ5TklQdJ3toZU=; b=mfS7S+RnMsTnSZKA8Kl4ycE4Xh
	bTGbLCaCLecsG9/DED4jJbAe54qNmB3dhznxh2/Oo2A/YyPEDb3Y/38cQXAGzRGYPwsJ8wvwhNXuv
	x/ELvG807IdmLknfDi3N5N8XQoXdfoZ2+qoQrEQdXxSoIRp2OFDW/At7xS3j0SA+WVKxj/UlN3A01
	BC7Xcmt8QI02kyaNsNDM8WW4ucJ26ydt/4cxotjcAdclw6O42T6C6MhxcVwkG7pJQC16T2FoJy5tv
	Dg91HAnubbB96g4YIperAlR0LezAFMYKiXQd6/VBUylQCJCnz2V130JQLiQJhRoOjMx0kaTcz1EpY
	kNxS9lyw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1qzFK2-00BFAN-Bq
	for fio@vger.kernel.org; Sat, 04 Nov 2023 12:00:15 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 854B51BC0143; Sat,  4 Nov 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20231104120001.854B51BC0143@kernel.dk>
Date: Sat,  4 Nov 2023 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 48cf0c63e5b867c8953f25deaa02466bf94a2eed:

  engines/xnvme: fix fdp support for userspace drivers (2023-11-02 06:08:13 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2c0b784a12172da1533dfd40b66a0e4e5609065f:

  Merge branch 'thinkcycles-parameter' of https://github.com/cloehle/fio (2023-11-03 11:21:22 -0400)

----------------------------------------------------------------
Christian Loehle (1):
      fio: Introduce new constant thinkcycles option

Vincent Fu (1):
      Merge branch 'thinkcycles-parameter' of https://github.com/cloehle/fio

 HOWTO.rst        |  8 ++++++++
 backend.c        |  4 ++++
 cconv.c          |  2 ++
 fio.1            |  7 +++++++
 fio_time.h       |  1 +
 options.c        | 12 ++++++++++++
 thread_options.h |  8 ++++++--
 time.c           | 11 +++++++++++
 8 files changed, 51 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 34d6afdf..42b2b119 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -3209,6 +3209,14 @@ I/O depth
 I/O rate
 ~~~~~~~~
 
+.. option:: thinkcycles=int
+
+	Stall the job for the specified number of cycles after an I/O has completed before
+	issuing the next. May be used to simulate processing being done by an application.
+	This is not taken into account for the time to be waited on for  :option:`thinktime`.
+	Might not have any effect on some platforms, this can be checked by trying a setting
+	a high enough amount of thinkcycles.
+
 .. option:: thinktime=time
 
 	Stall the job for the specified period of time after an I/O has completed before issuing the
diff --git a/backend.c b/backend.c
index a5895fec..1fab467a 100644
--- a/backend.c
+++ b/backend.c
@@ -49,6 +49,7 @@
 #include "helper_thread.h"
 #include "pshared.h"
 #include "zone-dist.h"
+#include "fio_time.h"
 
 static struct fio_sem *startup_sem;
 static struct flist_head *cgroup_list;
@@ -1133,6 +1134,9 @@ reap:
 		if (ret < 0)
 			break;
 
+		if (ddir_rw(ddir) && td->o.thinkcycles)
+			cycles_spin(td->o.thinkcycles);
+
 		if (ddir_rw(ddir) && td->o.thinktime)
 			handle_thinktime(td, ddir, &comp_time);
 
diff --git a/cconv.c b/cconv.c
index 341388d4..c9298408 100644
--- a/cconv.c
+++ b/cconv.c
@@ -233,6 +233,7 @@ int convert_thread_options_to_cpu(struct thread_options *o,
 	o->random_generator = le32_to_cpu(top->random_generator);
 	o->hugepage_size = le32_to_cpu(top->hugepage_size);
 	o->rw_min_bs = le64_to_cpu(top->rw_min_bs);
+	o->thinkcycles = le32_to_cpu(top->thinkcycles);
 	o->thinktime = le32_to_cpu(top->thinktime);
 	o->thinktime_spin = le32_to_cpu(top->thinktime_spin);
 	o->thinktime_blocks = le32_to_cpu(top->thinktime_blocks);
@@ -472,6 +473,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->random_generator = cpu_to_le32(o->random_generator);
 	top->hugepage_size = cpu_to_le32(o->hugepage_size);
 	top->rw_min_bs = __cpu_to_le64(o->rw_min_bs);
+	top->thinkcycles = cpu_to_le32(o->thinkcycles);
 	top->thinktime = cpu_to_le32(o->thinktime);
 	top->thinktime_spin = cpu_to_le32(o->thinktime_spin);
 	top->thinktime_blocks = cpu_to_le32(o->thinktime_blocks);
diff --git a/fio.1 b/fio.1
index c4742aa9..d62da688 100644
--- a/fio.1
+++ b/fio.1
@@ -2962,6 +2962,13 @@ reporting if I/O gets backed up on the device side (the coordinated omission
 problem). Note that this option cannot reliably be used with async IO engines.
 .SS "I/O rate"
 .TP
+.BI thinkcycles \fR=\fPint
+Stall the job for the specified number of cycles after an I/O has completed before
+issuing the next. May be used to simulate processing being done by an application.
+This is not taken into account for the time to be waited on for \fBthinktime\fR.
+Might not have any effect on some platforms, this can be checked by trying a setting
+a high enough amount of thinkcycles.
+.TP
 .BI thinktime \fR=\fPtime
 Stall the job for the specified period of time after an I/O has completed before issuing the
 next. May be used to simulate processing being done by an application.
diff --git a/fio_time.h b/fio_time.h
index b20e734c..969ad68d 100644
--- a/fio_time.h
+++ b/fio_time.h
@@ -22,6 +22,7 @@ extern uint64_t time_since_now(const struct timespec *);
 extern uint64_t time_since_genesis(void);
 extern uint64_t mtime_since_genesis(void);
 extern uint64_t utime_since_genesis(void);
+extern void cycles_spin(unsigned int);
 extern uint64_t usec_spin(unsigned int);
 extern uint64_t usec_sleep(struct thread_data *, unsigned long);
 extern void fill_start_time(struct timespec *);
diff --git a/options.c b/options.c
index 6b2cb53f..53df03de 100644
--- a/options.c
+++ b/options.c
@@ -3875,6 +3875,18 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_THINKTIME,
 	},
+	{
+		.name	= "thinkcycles",
+		.lname	= "Think cycles",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct thread_options, thinkcycles),
+		.help	= "Spin for a constant amount of cycles between requests",
+		.def	= "0",
+		.parent	= "thinktime",
+		.hide	= 1,
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_THINKTIME,
+	},
 	{
 		.name	= "thinktime_blocks",
 		.lname	= "Thinktime blocks",
diff --git a/thread_options.h b/thread_options.h
index fdde055e..24f695fe 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -309,6 +309,8 @@ struct thread_options {
 	char *exec_prerun;
 	char *exec_postrun;
 
+	unsigned int thinkcycles;
+
 	unsigned int thinktime;
 	unsigned int thinktime_spin;
 	unsigned int thinktime_blocks;
@@ -355,8 +357,8 @@ struct thread_options {
 
 	unsigned long long latency_target;
 	unsigned long long latency_window;
-	fio_fp64_t latency_percentile;
 	uint32_t latency_run;
+	fio_fp64_t latency_percentile;
 
 	/*
 	 * flow support
@@ -626,6 +628,8 @@ struct thread_options_pack {
 	uint8_t exec_prerun[FIO_TOP_STR_MAX];
 	uint8_t exec_postrun[FIO_TOP_STR_MAX];
 
+	uint32_t thinkcycles;
+
 	uint32_t thinktime;
 	uint32_t thinktime_spin;
 	uint32_t thinktime_blocks;
@@ -671,8 +675,8 @@ struct thread_options_pack {
 	uint64_t latency_target;
 	uint64_t latency_window;
 	uint64_t max_latency[DDIR_RWDIR_CNT];
-	fio_fp64_t latency_percentile;
 	uint32_t latency_run;
+	fio_fp64_t latency_percentile;
 
 	/*
 	 * flow support
diff --git a/time.c b/time.c
index 7cbab6ff..7f85c8de 100644
--- a/time.c
+++ b/time.c
@@ -38,6 +38,17 @@ uint64_t usec_spin(unsigned int usec)
 	return t;
 }
 
+/*
+ * busy loop for a fixed amount of cycles
+ */
+void cycles_spin(unsigned int n)
+{
+	unsigned long i;
+
+	for (i=0; i < n; i++)
+		nop;
+}
+
 uint64_t usec_sleep(struct thread_data *td, unsigned long usec)
 {
 	struct timespec req;
