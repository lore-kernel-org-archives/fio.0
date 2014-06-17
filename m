Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49918 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120AbaFQMAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 17 Jun 2014 08:00:06 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Wws3Y-0006LA-KC
	for fio@vger.kernel.org; Tue, 17 Jun 2014 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140617120003.93E1E401DF@lyth.info>
Date: Tue, 17 Jun 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 0ed2192dc4600ebef0715e748969b80fd58fe156:

  Fio 2.1.10 (2014-06-10 13:18:38 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 3e2e48a72851354f7d6d4da9fc83d4a6df20e955:

  Add string condensing for the ETA output (2014-06-16 14:42:05 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Add string condensing for the ETA output

Sumanth K (1):
      fio: Eliminate compilation warning in ppc

 HOWTO           |    9 +++++++++
 arch/arch-ppc.h |    2 ++
 eta.c           |   50 ++++++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 57 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 1c89d75..cad175c 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1607,6 +1607,15 @@ _		Thread reaped, or
 X		Thread reaped, exited with an error.
 K		Thread reaped, exited due to signal.
 
+Fio will condense the thread string as not to take up more space on the
+command line as is needed. For instance, if you have 10 readers and 10
+writers running, the output would look like this:
+
+Jobs: 20 (f=20): [R(10),W(10)] [4.0% done] [2103MB/0KB/0KB /s] [538K/0/0 iops] [eta 57m:36s]
+
+Fio will still maintain the ordering, though. So the above means that jobs
+1..10 are readers, and 11..20 are writers.
+
 The other values are fairly self explanatory - number of threads
 currently running and doing io, rate of io since last check (read speed
 listed first, then write speed), and the estimated completion percentage
diff --git a/arch/arch-ppc.h b/arch/arch-ppc.h
index 0f043bc..d4a080c 100644
--- a/arch/arch-ppc.h
+++ b/arch/arch-ppc.h
@@ -82,6 +82,7 @@ static inline unsigned long long get_cpu_clock(void)
 	return ret;
 }
 
+#if 0
 static void atb_child(void)
 {
 	arch_flags |= ARCH_FLAG_1;
@@ -106,6 +107,7 @@ static void atb_clocktest(void)
 			arch_flags |= ARCH_FLAG_1;
 	}
 }
+#endif
 
 #define ARCH_HAVE_INIT
 extern int tsc_reliable;
diff --git a/eta.c b/eta.c
index 7500082..52c1728 100644
--- a/eta.c
+++ b/eta.c
@@ -7,14 +7,54 @@
 
 #include "fio.h"
 
-static char run_str[REAL_MAX_JOBS + 1];
+static char __run_str[REAL_MAX_JOBS + 1];
+
+/*
+ * Worst level condensing would be 1:4, so allow enough room for that
+ */
+static char run_str[(4 * REAL_MAX_JOBS) + 1];
+
+static void update_condensed_str(char *run_str, char *run_str_condensed)
+{
+	int i, ci, last, nr;
+	size_t len;
+
+	len = strlen(run_str);
+	if (!len)
+		return;
+
+	last = 0;
+	nr = 0;
+	ci = 0;
+	for (i = 0; i < len; i++) {
+		if (!last) {
+new:
+			run_str_condensed[ci] = run_str[i];
+			last = run_str[i];
+			nr = 1;
+			ci++;
+		} else if (last == run_str[i]) {
+			nr++;
+		} else {
+			int elen;
+
+			elen = sprintf(&run_str_condensed[ci], "(%u),", nr);
+			ci += elen;
+			goto new;
+		}
+	}
+
+	if (nr)
+		sprintf(&run_str_condensed[ci], "(%u)", nr);
+}
+
 
 /*
  * Sets the status of the 'td' in the printed status map.
  */
 static void check_str_update(struct thread_data *td)
 {
-	char c = run_str[td->thread_number - 1];
+	char c = __run_str[td->thread_number - 1];
 
 	switch (td->runstate) {
 	case TD_REAPED:
@@ -91,7 +131,8 @@ static void check_str_update(struct thread_data *td)
 		log_err("state %d\n", td->runstate);
 	}
 
-	run_str[td->thread_number - 1] = c;
+	__run_str[td->thread_number - 1] = c;
+	update_condensed_str(__run_str, run_str);
 }
 
 /*
@@ -564,5 +605,6 @@ void print_thread_status(void)
 
 void print_status_init(int thr_number)
 {
-	run_str[thr_number] = 'P';
+	__run_str[thr_number] = 'P';
+	update_condensed_str(__run_str, run_str);
 }
