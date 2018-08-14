Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:46752 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729492AbeHNOrP (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 14 Aug 2018 10:47:15 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fpXzq-0001UH-SO
        for fio@vger.kernel.org; Tue, 14 Aug 2018 12:00:23 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180814120001.83CA52C0311@kernel.dk>
Date: Tue, 14 Aug 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit fee14ab846ef542d9bb9ebf68f11f0ecb8636f5e:

  Merge branch 'minor_fixes' of https://github.com/sitsofe/fio (2018-08-12 15:51:34 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to dcf6ad384149ee0b3f91c5a8127160cc291f7157:

  Merge branch 'fio-man-page' of https://github.com/bvanassche/fio (2018-08-13 21:05:33 -0600)

----------------------------------------------------------------
Bart Van Assche (1):
      Improve zone support documentation

Jens Axboe (5):
      gclient: bump output time buf size
      asprintf: fix indentation
      Fix double free of zone cache data
      Remove old zone gen from options
      Merge branch 'fio-man-page' of https://github.com/bvanassche/fio

 HOWTO            | 18 +++++++++-----
 Makefile         |  2 +-
 backend.c        | 13 +++-------
 fio.1            | 17 +++++++++----
 gclient.c        |  2 +-
 options.c        | 46 +----------------------------------
 oslib/asprintf.c | 38 ++++++++++++++---------------
 zone-dist.c      | 74 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 zone-dist.h      |  7 ++++++
 9 files changed, 131 insertions(+), 86 deletions(-)
 create mode 100644 zone-dist.c
 create mode 100644 zone-dist.h

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 4c117c2..1bec806 100644
--- a/HOWTO
+++ b/HOWTO
@@ -952,18 +952,24 @@ Target file/device
 
 	Unlink job files after each iteration or loop.  Default: false.
 
-.. option:: zonesize=int
+.. option:: zonerange=int
 
-	Divide a file into zones of the specified size. See :option:`zoneskip`.
+	Size of a single zone in which I/O occurs. See also :option:`zonesize`
+	and :option:`zoneskip`.
 
-.. option:: zonerange=int
+.. option:: zonesize=int
 
-	Give size of an I/O zone.  See :option:`zoneskip`.
+	Number of bytes to transfer before skipping :option:`zoneskip`
+	bytes. If this parameter is smaller than :option:`zonerange` then only
+	a fraction of each zone with :option:`zonerange` bytes will be
+	accessed.  If this parameter is larger than :option:`zonerange` then
+	each zone will be accessed multiple times before skipping
 
 .. option:: zoneskip=int
 
-	Skip the specified number of bytes when :option:`zonesize` data has been
-	read. The two zone options can be used to only do I/O on zones of a file.
+	Skip the specified number of bytes when :option:`zonesize` data have
+	been transferred. The three zone options can be used to do strided I/O
+	on a file.
 
 
 I/O type
diff --git a/Makefile b/Makefile
index 20d3ec1..f9bd787 100644
--- a/Makefile
+++ b/Makefile
@@ -50,7 +50,7 @@ SOURCE :=	$(sort $(patsubst $(SRCDIR)/%,%,$(wildcard $(SRCDIR)/crc/*.c)) \
 		gettime-thread.c helpers.c json.c idletime.c td_error.c \
 		profiles/tiobench.c profiles/act.c io_u_queue.c filelock.c \
 		workqueue.c rate-submit.c optgroup.c helper_thread.c \
-		steadystate.c
+		steadystate.c zone-dist.c
 
 ifdef CONFIG_LIBHDFS
   HDFSFLAGS= -I $(JAVA_HOME)/include -I $(JAVA_HOME)/include/linux -I $(FIO_LIBHDFS_INCLUDE)
diff --git a/backend.c b/backend.c
index f6cfbdd..36bde6a 100644
--- a/backend.c
+++ b/backend.c
@@ -47,6 +47,7 @@
 #include "rate-submit.h"
 #include "helper_thread.h"
 #include "pshared.h"
+#include "zone-dist.h"
 
 static struct fio_sem *startup_sem;
 static struct flist_head *cgroup_list;
@@ -1592,6 +1593,8 @@ static void *thread_main(void *data)
 		goto err;
 	}
 
+	td_zone_gen_index(td);
+
 	/*
 	 * Do this early, we don't want the compress threads to be limited
 	 * to the same CPUs as the IO workers. So do this before we set
@@ -1907,15 +1910,7 @@ err:
 	close_ioengine(td);
 	cgroup_shutdown(td, cgroup_mnt);
 	verify_free_state(td);
-
-	if (td->zone_state_index) {
-		int i;
-
-		for (i = 0; i < DDIR_RWDIR_CNT; i++)
-			free(td->zone_state_index[i]);
-		free(td->zone_state_index);
-		td->zone_state_index = NULL;
-	}
+	td_zone_free_index(td);
 
 	if (fio_option_is_set(o, cpumask)) {
 		ret = fio_cpuset_exit(&o->cpumask);
diff --git a/fio.1 b/fio.1
index 0c604a6..18bf6a2 100644
--- a/fio.1
+++ b/fio.1
@@ -724,15 +724,22 @@ false.
 .BI unlink_each_loop \fR=\fPbool
 Unlink job files after each iteration or loop. Default: false.
 .TP
-.BI zonesize \fR=\fPint
-Divide a file into zones of the specified size. See \fBzoneskip\fR.
+Fio supports strided data access. After having read \fBzonesize\fR bytes from an area that is \fBzonerange\fR bytes big, \fBzoneskip\fR bytes are skipped.
 .TP
 .BI zonerange \fR=\fPint
-Give size of an I/O zone. See \fBzoneskip\fR.
+Size of a single zone in which I/O occurs.
+.TP
+.BI zonesize \fR=\fPint
+Number of bytes to transfer before skipping \fBzoneskip\fR bytes. If this
+parameter is smaller than \fBzonerange\fR then only a fraction of each zone
+with \fBzonerange\fR bytes will be accessed.  If this parameter is larger than
+\fBzonerange\fR then each zone will be accessed multiple times before skipping
+to the next zone.
 .TP
 .BI zoneskip \fR=\fPint
-Skip the specified number of bytes when \fBzonesize\fR data has been
-read. The two zone options can be used to only do I/O on zones of a file.
+Skip the specified number of bytes after \fBzonesize\fR bytes of data have been
+transferred.
+
 .SS "I/O type"
 .TP
 .BI direct \fR=\fPbool
diff --git a/gclient.c b/gclient.c
index 7e5071d..04275a1 100644
--- a/gclient.c
+++ b/gclient.c
@@ -121,7 +121,7 @@ static void gfio_text_op(struct fio_client *client, struct fio_net_cmd *cmd)
 	GtkTreeIter iter;
 	struct tm *tm;
 	time_t sec;
-	char tmp[64], timebuf[80];
+	char tmp[64], timebuf[96];
 
 	sec = p->log_sec;
 	tm = localtime(&sec);
diff --git a/options.c b/options.c
index f592027..e53b717 100644
--- a/options.c
+++ b/options.c
@@ -959,48 +959,6 @@ static int zone_split_ddir(struct thread_options *o, enum fio_ddir ddir,
 	return 0;
 }
 
-static void __td_zone_gen_index(struct thread_data *td, enum fio_ddir ddir)
-{
-	unsigned int i, j, sprev, aprev;
-	uint64_t sprev_sz;
-
-	td->zone_state_index[ddir] = malloc(sizeof(struct zone_split_index) * 100);
-
-	sprev_sz = sprev = aprev = 0;
-	for (i = 0; i < td->o.zone_split_nr[ddir]; i++) {
-		struct zone_split *zsp = &td->o.zone_split[ddir][i];
-
-		for (j = aprev; j < aprev + zsp->access_perc; j++) {
-			struct zone_split_index *zsi = &td->zone_state_index[ddir][j];
-
-			zsi->size_perc = sprev + zsp->size_perc;
-			zsi->size_perc_prev = sprev;
-
-			zsi->size = sprev_sz + zsp->size;
-			zsi->size_prev = sprev_sz;
-		}
-
-		aprev += zsp->access_perc;
-		sprev += zsp->size_perc;
-		sprev_sz += zsp->size;
-	}
-}
-
-/*
- * Generate state table for indexes, so we don't have to do it inline from
- * the hot IO path
- */
-static void td_zone_gen_index(struct thread_data *td)
-{
-	int i;
-
-	td->zone_state_index = malloc(DDIR_RWDIR_CNT *
-					sizeof(struct zone_split_index *));
-
-	for (i = 0; i < DDIR_RWDIR_CNT; i++)
-		__td_zone_gen_index(td, i);
-}
-
 static int parse_zoned_distribution(struct thread_data *td, const char *input,
 				    bool absolute)
 {
@@ -1055,9 +1013,7 @@ static int parse_zoned_distribution(struct thread_data *td, const char *input,
 		return ret;
 	}
 
-	if (!ret)
-		td_zone_gen_index(td);
-	else {
+	if (ret) {
 		for (i = 0; i < DDIR_RWDIR_CNT; i++)
 			td->o.zone_split_nr[i] = 0;
 	}
diff --git a/oslib/asprintf.c b/oslib/asprintf.c
index 969479f..ff503c5 100644
--- a/oslib/asprintf.c
+++ b/oslib/asprintf.c
@@ -6,38 +6,38 @@
 #ifndef CONFIG_HAVE_VASPRINTF
 int vasprintf(char **strp, const char *fmt, va_list ap)
 {
-    va_list ap_copy;
-    char *str;
-    int len;
+	va_list ap_copy;
+	char *str;
+	int len;
 
 #ifdef va_copy
-    va_copy(ap_copy, ap);
+	va_copy(ap_copy, ap);
 #else
-    __va_copy(ap_copy, ap);
+	__va_copy(ap_copy, ap);
 #endif
-    len = vsnprintf(NULL, 0, fmt, ap_copy);
-    va_end(ap_copy);
+	len = vsnprintf(NULL, 0, fmt, ap_copy);
+	va_end(ap_copy);
 
-    if (len < 0)
-        return len;
+	if (len < 0)
+		return len;
 
-    len++;
-    str = malloc(len);
-    *strp = str;
-    return str ? vsnprintf(str, len, fmt, ap) : -1;
+	len++;
+	str = malloc(len);
+	*strp = str;
+	return str ? vsnprintf(str, len, fmt, ap) : -1;
 }
 #endif
 
 #ifndef CONFIG_HAVE_ASPRINTF
 int asprintf(char **strp, const char *fmt, ...)
 {
-    va_list arg;
-    int done;
+	va_list arg;
+	int done;
 
-    va_start(arg, fmt);
-    done = vasprintf(strp, fmt, arg);
-    va_end(arg);
+	va_start(arg, fmt);
+	done = vasprintf(strp, fmt, arg);
+	va_end(arg);
 
-    return done;
+	return done;
 }
 #endif
diff --git a/zone-dist.c b/zone-dist.c
new file mode 100644
index 0000000..819d531
--- /dev/null
+++ b/zone-dist.c
@@ -0,0 +1,74 @@
+#include <stdlib.h>
+#include "fio.h"
+#include "zone-dist.h"
+
+static void __td_zone_gen_index(struct thread_data *td, enum fio_ddir ddir)
+{
+	unsigned int i, j, sprev, aprev;
+	uint64_t sprev_sz;
+
+	td->zone_state_index[ddir] = malloc(sizeof(struct zone_split_index) * 100);
+
+	sprev_sz = sprev = aprev = 0;
+	for (i = 0; i < td->o.zone_split_nr[ddir]; i++) {
+		struct zone_split *zsp = &td->o.zone_split[ddir][i];
+
+		for (j = aprev; j < aprev + zsp->access_perc; j++) {
+			struct zone_split_index *zsi = &td->zone_state_index[ddir][j];
+
+			zsi->size_perc = sprev + zsp->size_perc;
+			zsi->size_perc_prev = sprev;
+
+			zsi->size = sprev_sz + zsp->size;
+			zsi->size_prev = sprev_sz;
+		}
+
+		aprev += zsp->access_perc;
+		sprev += zsp->size_perc;
+		sprev_sz += zsp->size;
+	}
+}
+
+static bool has_zones(struct thread_data *td)
+{
+	int i, zones = 0;
+
+	for (i = 0; i < DDIR_RWDIR_CNT; i++)
+		zones += td->o.zone_split_nr[i];
+
+	return zones != 0;
+}
+
+/*
+ * Generate state table for indexes, so we don't have to do it inline from
+ * the hot IO path
+ */
+void td_zone_gen_index(struct thread_data *td)
+{
+	int i;
+
+	if (!has_zones(td))
+		return;
+
+	td->zone_state_index = malloc(DDIR_RWDIR_CNT *
+					sizeof(struct zone_split_index *));
+
+	for (i = 0; i < DDIR_RWDIR_CNT; i++)
+		__td_zone_gen_index(td, i);
+}
+
+void td_zone_free_index(struct thread_data *td)
+{
+	int i;
+
+	if (!td->zone_state_index)
+		return;
+
+	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
+		free(td->zone_state_index[i]);
+		td->zone_state_index[i] = NULL;
+	}
+
+	free(td->zone_state_index);
+	td->zone_state_index = NULL;
+}
diff --git a/zone-dist.h b/zone-dist.h
new file mode 100644
index 0000000..c0b2884
--- /dev/null
+++ b/zone-dist.h
@@ -0,0 +1,7 @@
+#ifndef FIO_ZONE_DIST_H
+#define FIO_ZONE_DIST_H
+
+void td_zone_gen_index(struct thread_data *td);
+void td_zone_free_index(struct thread_data *td);
+
+#endif

