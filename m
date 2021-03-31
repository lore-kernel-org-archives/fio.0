Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235014AbhCaMAN (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 31 Mar 2021 08:00:13 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C55FC061574
        for <fio@vger.kernel.org>; Wed, 31 Mar 2021 05:00:12 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lRZW0-004Vnr-Ja
        for fio@vger.kernel.org; Wed, 31 Mar 2021 12:00:08 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210331120001.EA3191BC0155@kernel.dk>
Date: Wed, 31 Mar 2021 06:00:01 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e7e536b665bd6a9d3e936e0847dbbb6957101da4:

  Merge branch 'unified-merge' of https://github.com/jeffreyalien/fio (2021-03-18 10:19:57 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6202c70d8d5cbdd3fb4bc23b96f691cbd25a327e:

  gettime: cleanup ifdef mess (2021-03-30 20:13:16 -0600)

----------------------------------------------------------------
Jens Axboe (4):
      configure: add test case for pthread_getaffinity_np()
      os/os-linux: add pthread CPU affinity helper
      gettime: check affinity for thread, if we have it
      gettime: cleanup ifdef mess

 configure     | 27 +++++++++++++++++++++++++++
 gettime.c     | 22 ++++++++++++++++++++--
 os/os-linux.h |  3 +++
 3 files changed, 50 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index 2f5ac91f..a7d82be0 100755
--- a/configure
+++ b/configure
@@ -418,6 +418,7 @@ CYGWIN*)
   clock_monotonic="yes"
   sched_idle="yes"
   pthread_condattr_setclock="no"
+  pthread_affinity="no"
   ;;
 esac
 
@@ -803,6 +804,29 @@ elif compile_prog "" "$LIBS -lpthread" "pthread_sigmask" ; then
 fi
 print_config "pthread_sigmask()" "$pthread_sigmask"
 
+##########################################
+# pthread_getaffinity_np() probe
+if test "$pthread_getaffinity" != "yes" ; then
+  pthread_getaffinity="no"
+fi
+cat > $TMPC <<EOF
+#include <stddef.h> /* NULL */
+#include <signal.h> /* pthread_sigmask() */
+#include <pthread.h>
+int main(void)
+{
+  cpu_set_t set;
+  return pthread_getaffinity_np(pthread_self(), sizeof(set), &set);
+}
+EOF
+if compile_prog "" "$LIBS" "pthread_getaffinity" ; then
+  pthread_getaffinity="yes"
+elif compile_prog "" "$LIBS -lpthread" "pthread_getaffinity" ; then
+  pthread_getaffinity="yes"
+  LIBS="$LIBS -lpthread"
+fi
+print_config "pthread_getaffinity_np()" "$pthread_getaffinity"
+
 ##########################################
 # solaris aio probe
 if test "$solaris_aio" != "yes" ; then
@@ -2823,6 +2847,9 @@ fi
 if test "$pthread_sigmask" = "yes" ; then
   output_sym "CONFIG_PTHREAD_SIGMASK"
 fi
+if test "$pthread_getaffinity" = "yes" ; then
+  output_sym "CONFIG_PTHREAD_GETAFFINITY"
+fi
 if test "$have_asprintf" = "yes" ; then
     output_sym "CONFIG_HAVE_ASPRINTF"
 fi
diff --git a/gettime.c b/gettime.c
index f85da6e0..e3f483a7 100644
--- a/gettime.c
+++ b/gettime.c
@@ -671,12 +671,21 @@ static int clock_cmp(const void *p1, const void *p2)
 int fio_monotonic_clocktest(int debug)
 {
 	struct clock_thread *cthreads;
-	unsigned int nr_cpus = cpus_online();
+	unsigned int seen_cpus, nr_cpus = cpus_online();
 	struct clock_entry *entries;
 	unsigned long nr_entries, tentries, failed = 0;
 	struct clock_entry *prev, *this;
 	uint32_t seq = 0;
 	unsigned int i;
+	os_cpu_mask_t mask;
+
+#ifdef CONFIG_PTHREAD_GETAFFINITY
+	fio_get_thread_affinity(mask);
+#else
+	memset(&mask, 0, sizeof(mask));
+	for (i = 0; i < nr_cpus; i++)
+		fio_cpu_set(&mask, i);
+#endif
 
 	if (debug) {
 		log_info("cs: reliable_tsc: %s\n", tsc_reliable ? "yes" : "no");
@@ -703,25 +712,31 @@ int fio_monotonic_clocktest(int debug)
 	if (debug)
 		log_info("cs: Testing %u CPUs\n", nr_cpus);
 
+	seen_cpus = 0;
 	for (i = 0; i < nr_cpus; i++) {
 		struct clock_thread *t = &cthreads[i];
 
+		if (!fio_cpu_isset(&mask, i))
+			continue;
 		t->cpu = i;
 		t->debug = debug;
 		t->seq = &seq;
 		t->nr_entries = nr_entries;
-		t->entries = &entries[i * nr_entries];
+		t->entries = &entries[seen_cpus * nr_entries];
 		__fio_sem_init(&t->lock, FIO_SEM_LOCKED);
 		if (pthread_create(&t->thread, NULL, clock_thread_fn, t)) {
 			failed++;
 			nr_cpus = i;
 			break;
 		}
+		seen_cpus++;
 	}
 
 	for (i = 0; i < nr_cpus; i++) {
 		struct clock_thread *t = &cthreads[i];
 
+		if (!fio_cpu_isset(&mask, i))
+			continue;
 		fio_sem_up(&t->lock);
 	}
 
@@ -729,6 +744,8 @@ int fio_monotonic_clocktest(int debug)
 		struct clock_thread *t = &cthreads[i];
 		void *ret;
 
+		if (!fio_cpu_isset(&mask, i))
+			continue;
 		pthread_join(t->thread, &ret);
 		if (ret)
 			failed++;
@@ -742,6 +759,7 @@ int fio_monotonic_clocktest(int debug)
 		goto err;
 	}
 
+	tentries = nr_entries * seen_cpus;
 	qsort(entries, tentries, sizeof(struct clock_entry), clock_cmp);
 
 	/* silence silly gcc */
diff --git a/os/os-linux.h b/os/os-linux.h
index 5562b0da..ea8d7922 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -74,6 +74,9 @@ typedef cpu_set_t os_cpu_mask_t;
 	sched_getaffinity((pid), (ptr))
 #endif
 
+#define fio_get_thread_affinity(mask)	\
+	pthread_getaffinity_np(pthread_self(), sizeof(mask), &(mask))
+
 #define fio_cpu_clear(mask, cpu)	(void) CPU_CLR((cpu), (mask))
 #define fio_cpu_set(mask, cpu)		(void) CPU_SET((cpu), (mask))
 #define fio_cpu_isset(mask, cpu)	(CPU_ISSET((cpu), (mask)) != 0)

