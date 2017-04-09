Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:55186 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751961AbdDIMAO (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 9 Apr 2017 08:00:14 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cxBVt-0003op-GY
        for fio@vger.kernel.org; Sun, 09 Apr 2017 12:00:13 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170409120001.EB88E2C0083@kernel.dk>
Date: Sun,  9 Apr 2017 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 6c8611c79713fe73fddf7458ab3ab36feaeae67b:

  Split poisson rate control into read/write/trim (2017-04-07 16:04:31 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e5a415c889251928dd256738a8022f1eab91c73b:

  Fix num2str() output when maxlen <= strlen(tmp) (2017-04-08 11:04:21 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      backend: include data direction in debug poisson rate print

Tomohiro Kusumi (6):
      Don't silently terminate td when no I/O performed due to error
      dump_td_info() doesn't really need to be a function
      Make lib/prio_tree.c a stand-alone library
      Make lib/memalign.c a stand-alone library
      Make lib/num2str.c a stand-alone library by adding lib/num2str.h
      Fix num2str() output when maxlen <= strlen(tmp)

 backend.c       | 36 +++++++++++++++++++++++-------------
 fio.h           |  9 +--------
 io_u.c          |  5 +++--
 lib/memalign.c  |  4 +++-
 lib/num2str.c   |  9 ++++++---
 lib/num2str.h   | 15 +++++++++++++++
 lib/prio_tree.c |  5 ++++-
 7 files changed, 55 insertions(+), 28 deletions(-)
 create mode 100644 lib/num2str.h

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 86e689f..9a684ed 100644
--- a/backend.c
+++ b/backend.c
@@ -813,8 +813,9 @@ static long long usec_for_io(struct thread_data *td, enum fio_ddir ddir)
 		val = (int64_t) (1000000 / iops) *
 				-logf(__rand_0_1(&td->poisson_state[ddir]));
 		if (val) {
-			dprint(FD_RATE, "poisson rate iops=%llu\n",
-					(unsigned long long) 1000000 / val);
+			dprint(FD_RATE, "poisson rate iops=%llu, ddir=%d\n",
+					(unsigned long long) 1000000 / val,
+					ddir);
 		}
 		td->last_usec[ddir] += val;
 		return td->last_usec[ddir];
@@ -1456,6 +1457,7 @@ static void *thread_main(void *data)
 	struct thread_data *td = fd->td;
 	struct thread_options *o = &td->o;
 	struct sk_out *sk_out = fd->sk_out;
+	uint64_t bytes_done[DDIR_RWDIR_CNT];
 	int deadlock_loop_cnt;
 	int clear_state;
 	int ret;
@@ -1677,7 +1679,9 @@ static void *thread_main(void *data)
 					sizeof(td->bw_sample_time));
 	}
 
+	memset(bytes_done, 0, sizeof(bytes_done));
 	clear_state = 0;
+
 	while (keep_running(td)) {
 		uint64_t verify_bytes;
 
@@ -1696,8 +1700,6 @@ static void *thread_main(void *data)
 		if (td->o.verify_only && td_write(td))
 			verify_bytes = do_dry_run(td);
 		else {
-			uint64_t bytes_done[DDIR_RWDIR_CNT];
-
 			do_io(td, bytes_done);
 
 			if (!ddir_rw_sum(bytes_done)) {
@@ -1776,6 +1778,18 @@ static void *thread_main(void *data)
 			break;
 	}
 
+	/*
+	 * If td ended up with no I/O when it should have had,
+	 * then something went wrong unless FIO_NOIO or FIO_DISKLESSIO.
+	 * (Are we not missing other flags that can be ignored ?)
+	 */
+	if ((td->o.size || td->o.io_size) && !ddir_rw_sum(bytes_done) &&
+	    !(td_ioengine_flagged(td, FIO_NOIO) ||
+	      td_ioengine_flagged(td, FIO_DISKLESSIO)))
+		log_err("%s: No I/O performed by %s, "
+			 "perhaps try --debug=io option for details?\n",
+			 td->o.name, td->io_ops->name);
+
 	td_set_runstate(td, TD_FINISHING);
 
 	update_rusage_stat(td);
@@ -1848,14 +1862,6 @@ err:
 	return (void *) (uintptr_t) td->error;
 }
 
-static void dump_td_info(struct thread_data *td)
-{
-	log_err("fio: job '%s' (state=%d) hasn't exited in %lu seconds, it "
-		"appears to be stuck. Doing forceful exit of this job.\n",
-			td->o.name, td->runstate,
-			(unsigned long) time_since_now(&td->terminate_time));
-}
-
 /*
  * Run over the job map and reap the threads that have exited, if any.
  */
@@ -1940,7 +1946,11 @@ static void reap_threads(unsigned int *nr_running, uint64_t *t_rate,
 		if (td->terminate &&
 		    td->runstate < TD_FSYNCING &&
 		    time_since_now(&td->terminate_time) >= FIO_REAP_TIMEOUT) {
-			dump_td_info(td);
+			log_err("fio: job '%s' (state=%d) hasn't exited in "
+				"%lu seconds, it appears to be stuck. Doing "
+				"forceful exit of this job.\n",
+				td->o.name, td->runstate,
+				(unsigned long) time_since_now(&td->terminate_time));
 			td_set_runstate(td, TD_REAPED);
 			goto reaped;
 		}
diff --git a/fio.h b/fio.h
index 8171b9a..b67613e 100644
--- a/fio.h
+++ b/fio.h
@@ -35,6 +35,7 @@
 #include "oslib/getopt.h"
 #include "lib/rand.h"
 #include "lib/rbtree.h"
+#include "lib/num2str.h"
 #include "client.h"
 #include "server.h"
 #include "stat.h"
@@ -522,7 +523,6 @@ extern void fio_options_mem_dupe(struct thread_data *);
 extern void td_fill_rand_seeds(struct thread_data *);
 extern void td_fill_verify_state_seed(struct thread_data *);
 extern void add_job_opts(const char **, int);
-extern char *num2str(uint64_t, int, int, int, int);
 extern int ioengine_load(struct thread_data *);
 extern bool parse_dryrun(void);
 extern int fio_running_or_pending_io_threads(void);
@@ -535,13 +535,6 @@ extern uintptr_t page_size;
 extern int initialize_fio(char *envp[]);
 extern void deinitialize_fio(void);
 
-#define N2S_NONE	0
-#define N2S_BITPERSEC 	1	/* match unit_base for bit rates */
-#define N2S_PERSEC	2
-#define N2S_BIT		3
-#define N2S_BYTE	4
-#define N2S_BYTEPERSEC 	8	/* match unit_base for byte rates */
-
 #define FIO_GETOPT_JOB		0x89000000
 #define FIO_GETOPT_IOENGINE	0x98000000
 #define FIO_NR_OPTIONS		(FIO_MAX_OPTS + 128)
diff --git a/io_u.c b/io_u.c
index 363bfe1..88f35c9 100644
--- a/io_u.c
+++ b/io_u.c
@@ -899,8 +899,9 @@ static int fill_io_u(struct thread_data *td, struct io_u *io_u)
 	}
 
 	if (io_u->offset + io_u->buflen > io_u->file->real_file_size) {
-		dprint(FD_IO, "io_u %p, offset too large\n", io_u);
-		dprint(FD_IO, "  off=%llu/%lu > %llu\n",
+		dprint(FD_IO, "io_u %p, offset + buflen exceeds file size\n",
+			io_u);
+		dprint(FD_IO, "  offset=%llu/buflen=%lu > %llu\n",
 			(unsigned long long) io_u->offset, io_u->buflen,
 			(unsigned long long) io_u->file->real_file_size);
 		return 1;
diff --git a/lib/memalign.c b/lib/memalign.c
index 1d1ba9b..137cc8e 100644
--- a/lib/memalign.c
+++ b/lib/memalign.c
@@ -3,7 +3,9 @@
 #include <inttypes.h>
 
 #include "memalign.h"
-#include "../fio.h"
+
+#define PTR_ALIGN(ptr, mask)   \
+	(char *)((uintptr_t)((ptr) + (mask)) & ~(mask))
 
 struct align_footer {
 	unsigned int offset;
diff --git a/lib/num2str.c b/lib/num2str.c
index ed3545d..448d3ff 100644
--- a/lib/num2str.c
+++ b/lib/num2str.c
@@ -2,7 +2,10 @@
 #include <stdio.h>
 #include <string.h>
 
-#include "../fio.h"
+#include "../compiler/compiler.h"
+#include "num2str.h"
+
+#define ARRAY_SIZE(x)    (sizeof((x)) / (sizeof((x)[0])))
 
 /**
  * num2str() - Cheesy number->string conversion, complete with carry rounding error.
@@ -10,7 +13,7 @@
  * @maxlen: max number of digits in the output string (not counting prefix and units)
  * @base: multiplier for num (e.g., if num represents Ki, use 1024)
  * @pow2: select unit prefix - 0=power-of-10 decimal SI, nonzero=power-of-2 binary IEC
- * @units: select units - N2S_* macros defined in fio.h
+ * @units: select units - N2S_* macros defined in num2str.h
  * @returns a malloc'd buffer containing "number[<unit prefix>][<units>]"
  */
 char *num2str(uint64_t num, int maxlen, int base, int pow2, int units)
@@ -83,7 +86,7 @@ done:
 
 	sprintf(tmp, "%llu", (unsigned long long) num);
 	decimals = maxlen - strlen(tmp);
-	if (decimals <= 1) {
+	if ((int)decimals <= 1) {
 		if (carry)
 			num++;
 		goto done;
diff --git a/lib/num2str.h b/lib/num2str.h
new file mode 100644
index 0000000..81358a1
--- /dev/null
+++ b/lib/num2str.h
@@ -0,0 +1,15 @@
+#ifndef FIO_NUM2STR_H
+#define FIO_NUM2STR_H
+
+#include <inttypes.h>
+
+#define N2S_NONE	0
+#define N2S_BITPERSEC	1	/* match unit_base for bit rates */
+#define N2S_PERSEC	2
+#define N2S_BIT		3
+#define N2S_BYTE	4
+#define N2S_BYTEPERSEC	8	/* match unit_base for byte rates */
+
+extern char *num2str(uint64_t, int, int, int, int);
+
+#endif
diff --git a/lib/prio_tree.c b/lib/prio_tree.c
index e18ae32..de3fe1c 100644
--- a/lib/prio_tree.c
+++ b/lib/prio_tree.c
@@ -13,9 +13,12 @@
 
 #include <stdlib.h>
 #include <limits.h>
-#include "../fio.h"
+
+#include "../compiler/compiler.h"
 #include "prio_tree.h"
 
+#define ARRAY_SIZE(x)    (sizeof((x)) / (sizeof((x)[0])))
+
 /*
  * A clever mix of heap and radix trees forms a radix priority search tree (PST)
  * which is useful for storing intervals, e.g, we can consider a vma as a closed
