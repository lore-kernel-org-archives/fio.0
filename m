Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:54055 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbaCFNAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 6 Mar 2014 08:00:05 -0500
Received: from kernel.dk ([54.225.238.116] helo=strynoevaenget.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WLXu8-0006oY-0A
	for fio@vger.kernel.org; Thu, 06 Mar 2014 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140306130003.3AFD241A72@strynoevaenget.dk>
Date: Thu,  6 Mar 2014 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit d004a209eee0a8db603c2d7ca6dc5fb6c367aa5a:

  Fix typo in fio_cpu_count() (2014-03-04 09:02:10 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6cf71c249abd60f2d2f6878ae436d4bab00aacbd:

  Fix compile on CentOS/RHEL5 (2014-03-05 15:49:54 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Fix compile on CentOS/RHEL5

 configure |   19 +++++++++++++++++++
 os/os.h   |   16 ++++++++++++++++
 2 files changed, 35 insertions(+)

---

Diff of recent changes:

diff --git a/configure b/configure
index 4b00679..4a8d352 100755
--- a/configure
+++ b/configure
@@ -650,6 +650,22 @@ echo "sched_setaffinity(3 arg)      $linux_3arg_affinity"
 echo "sched_setaffinity(2 arg)      $linux_2arg_affinity"
 
 ##########################################
+# CPU_COUNT test
+cpu_count="no"
+cat > $TMPC << EOF
+#include <sched.h>
+int main(int argc, char **argv)
+{
+  cpu_set_t mask;
+  return CPU_COUNT(&mask);
+}
+EOF
+if compile_prog "" "" "cpu_count"; then
+  cpu_count="yes"
+fi
+echo "CPU_COUNT                     $cpu_count"
+
+##########################################
 # clock_gettime probe
 clock_gettime="no"
 cat > $TMPC << EOF
@@ -1270,6 +1286,9 @@ fi
 if test "$rbd" = "yes" ; then
   output_sym "CONFIG_RBD"
 fi
+if test "$cpu_count" = "yes" ; then
+  output_sym "CONFIG_CPU_COUNT"
+fi
 
 echo "LIBS+=$LIBS" >> $config_host_mak
 echo "CFLAGS+=$CFLAGS" >> $config_host_mak
diff --git a/os/os.h b/os/os.h
index a6bc17f..7f92d1b 100644
--- a/os/os.h
+++ b/os/os.h
@@ -327,6 +327,22 @@ static inline unsigned int cpus_online(void)
 }
 #endif
 
+#ifndef CONFIG_CPU_COUNT
+#ifdef FIO_HAVE_CPU_AFFINITY
+static inline int CPU_COUNT(os_cpu_mask_t *mask)
+{
+	int max_cpus = cpus_online();
+	int nr_cpus, i;
+
+	for (i = 0, nr_cpus = 0; i < max_cpus; i++)
+		if (fio_cpu_isset(mask, i))
+			nr_cpus++;
+
+	return nr_cpus;
+}
+#endif
+#endif
+
 #ifndef FIO_HAVE_GETTID
 static inline int gettid(void)
 {
