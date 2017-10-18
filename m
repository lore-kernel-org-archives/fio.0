Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:33400 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754572AbdJRMAQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 18 Oct 2017 08:00:16 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1e4n1D-0006IU-Mt
        for fio@vger.kernel.org; Wed, 18 Oct 2017 12:00:15 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20171018120002.8BAA42C234E@kernel.dk>
Date: Wed, 18 Oct 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c13a60ce72aaf5b07b93977ab86e7522d167ec28:

  flow: fix bad overflowing math (2017-10-12 10:54:27 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 7ad86b642b6c3962177064b85b4c055ae9455032:

  Merge branch 'cpuclock-test' (2017-10-17 12:59:40 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      gettime: improve cpu clock test
      Merge branch 'cpuclock-test'

 configure | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 gettime.c | 21 ++++++++++++---------
 2 files changed, 58 insertions(+), 9 deletions(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index 2b46ab8..d34c000 100755
--- a/configure
+++ b/configure
@@ -343,6 +343,8 @@ CYGWIN*)
   # Flags below are still necessary mostly for MinGW.
   socklen_t="yes"
   sfaa="yes"
+  sync_sync="yes"
+  cmp_swap="yes"
   rusage_thread="yes"
   fdatasync="yes"
   clock_gettime="yes" # clock_monotonic probe has dependency on this
@@ -707,6 +709,44 @@ fi
 print_config "__sync_fetch_and_add" "$sfaa"
 
 ##########################################
+# __sync_synchronize() test
+if test "$sync_sync" != "yes" ; then
+  sync_sync="no"
+fi
+cat > $TMPC << EOF
+#include <inttypes.h>
+
+int main(int argc, char **argv)
+{
+  __sync_synchronize();
+  return 0;
+}
+EOF
+if compile_prog "" "" "__sync_synchronize()" ; then
+    sync_sync="yes"
+fi
+print_config "__sync_synchronize" "$sync_sync"
+
+##########################################
+# __sync_val_compare_and_swap() test
+if test "$cmp_swap" != "yes" ; then
+  cmp_swap="no"
+fi
+cat > $TMPC << EOF
+#include <inttypes.h>
+
+int main(int argc, char **argv)
+{
+  int x = 0;
+  return __sync_val_compare_and_swap(&x, 1, 2);
+}
+EOF
+if compile_prog "" "" "__sync_val_compare_and_swap()" ; then
+    cmp_swap="yes"
+fi
+print_config "__sync_val_compare_and_swap" "$cmp_swap"
+
+##########################################
 # libverbs probe
 if test "$libverbs" != "yes" ; then
   libverbs="no"
@@ -2108,6 +2148,12 @@ fi
 if test "$sfaa" = "yes" ; then
   output_sym "CONFIG_SFAA"
 fi
+if test "$sync_sync" = "yes" ; then
+  output_sym "CONFIG_SYNC_SYNC"
+fi
+if test "$cmp_swap" = "yes" ; then
+  output_sym "CONFIG_CMP_SWAP"
+fi
 if test "$libverbs" = "yes" -a "$rdmacm" = "yes" ; then
   output_sym "CONFIG_RDMA"
 fi
diff --git a/gettime.c b/gettime.c
index 1cbef84..c256a96 100644
--- a/gettime.c
+++ b/gettime.c
@@ -548,7 +548,7 @@ uint64_t time_since_now(const struct timespec *s)
 }
 
 #if defined(FIO_HAVE_CPU_AFFINITY) && defined(ARCH_HAVE_CPU_CLOCK)  && \
-    defined(CONFIG_SFAA)
+    defined(CONFIG_SYNC_SYNC) && defined(CONFIG_CMP_SWAP)
 
 #define CLOCK_ENTRIES_DEBUG	100000
 #define CLOCK_ENTRIES_TEST	1000
@@ -570,9 +570,10 @@ struct clock_thread {
 	struct clock_entry *entries;
 };
 
-static inline uint32_t atomic32_inc_return(uint32_t *seq)
+static inline uint32_t atomic32_compare_and_swap(uint32_t *ptr, uint32_t old,
+						 uint32_t new)
 {
-	return 1 + __sync_fetch_and_add(seq, 1);
+	return __sync_val_compare_and_swap(ptr, old, new);
 }
 
 static void *clock_thread_fn(void *data)
@@ -580,7 +581,6 @@ static void *clock_thread_fn(void *data)
 	struct clock_thread *t = data;
 	struct clock_entry *c;
 	os_cpu_mask_t cpu_mask;
-	uint32_t last_seq;
 	unsigned long long first;
 	int i;
 
@@ -604,7 +604,6 @@ static void *clock_thread_fn(void *data)
 	pthread_mutex_unlock(&t->started);
 
 	first = get_cpu_clock();
-	last_seq = 0;
 	c = &t->entries[0];
 	for (i = 0; i < t->nr_entries; i++, c++) {
 		uint32_t seq;
@@ -612,11 +611,15 @@ static void *clock_thread_fn(void *data)
 
 		c->cpu = t->cpu;
 		do {
-			seq = atomic32_inc_return(t->seq);
-			if (seq < last_seq)
+			seq = *t->seq;
+			if (seq == UINT_MAX)
 				break;
+			__sync_synchronize();
 			tsc = get_cpu_clock();
-		} while (seq != *t->seq);
+		} while (seq != atomic32_compare_and_swap(t->seq, seq, seq + 1));
+
+		if (seq == UINT_MAX)
+			break;
 
 		c->seq = seq;
 		c->tsc = tsc;
@@ -634,7 +637,7 @@ static void *clock_thread_fn(void *data)
 	 * The most common platform clock breakage is returning zero
 	 * indefinitely. Check for that and return failure.
 	 */
-	if (!t->entries[i - 1].tsc && !t->entries[0].tsc)
+	if (i > 1 && !t->entries[i - 1].tsc && !t->entries[0].tsc)
 		goto err;
 
 	fio_cpuset_exit(&cpu_mask);
