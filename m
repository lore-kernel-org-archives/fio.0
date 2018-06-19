Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:40998 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937609AbeFSMAU (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 19 Jun 2018 08:00:20 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fVFJ5-0000G7-VD
        for fio@vger.kernel.org; Tue, 19 Jun 2018 12:00:20 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180619120002.27E672C013B@kernel.dk>
Date: Tue, 19 Jun 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit af84cd66149507424814cf9c0b4950f4cf66e3b7:

  client: close dup'ed descriptor if fdopen() fails (2018-06-15 09:18:04 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5de1d4ba1e6ae82bb4ad559463801cb6b7096ac3:

  Merge branch 'readonly-trim' of https://github.com/vincentkfu/fio (2018-06-18 13:58:26 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'readonly-trim' of https://github.com/vincentkfu/fio

Vincent Fu (7):
      fio.h: also check trim operations in fio_ro_check
      filesetup: make trim jobs respect --readonly during file open
      init: ensure that fatal errors in fixup_options are always propogated to caller
      init: abort write and trim jobs when --readonly option is present
      options: check for conflict between trims and readonly option
      doc: improve readonly option description
      testing: add test script for readonly parameter

 HOWTO                 | 12 ++++----
 filesetup.c           |  3 +-
 fio.1                 |  9 +++---
 fio.h                 |  3 +-
 init.c                | 40 +++++++++++++-----------
 options.c             |  6 ++--
 t/jobs/readonly-r.fio |  5 +++
 t/jobs/readonly-t.fio |  5 +++
 t/jobs/readonly-w.fio |  5 +++
 t/readonly.sh         | 84 +++++++++++++++++++++++++++++++++++++++++++++++++++
 10 files changed, 139 insertions(+), 33 deletions(-)
 create mode 100644 t/jobs/readonly-r.fio
 create mode 100644 t/jobs/readonly-t.fio
 create mode 100644 t/jobs/readonly-w.fio
 create mode 100755 t/readonly.sh

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 4398ffa..e1399b4 100644
--- a/HOWTO
+++ b/HOWTO
@@ -163,12 +163,12 @@ Command line options
 
 .. option:: --readonly
 
-	Turn on safety read-only checks, preventing writes.  The ``--readonly``
-	option is an extra safety guard to prevent users from accidentally starting
-	a write workload when that is not desired.  Fio will only write if
-	`rw=write/randwrite/rw/randrw` is given.  This extra safety net can be used
-	as an extra precaution as ``--readonly`` will also enable a write check in
-	the I/O engine core to prevent writes due to unknown user space bug(s).
+	Turn on safety read-only checks, preventing writes and trims.  The
+	``--readonly`` option is an extra safety guard to prevent users from
+	accidentally starting a write or trim workload when that is not desired.
+	Fio will only modify the device under test if
+	`rw=write/randwrite/rw/randrw/trim/randtrim/trimwrite` is given.  This
+	safety net can be used as an extra precaution.
 
 .. option:: --eta=when
 
diff --git a/filesetup.c b/filesetup.c
index 75694bd..a2427a1 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -674,7 +674,8 @@ open_again:
 			from_hash = file_lookup_open(f, flags);
 	} else if (td_trim(td)) {
 		assert(!td_rw(td)); /* should have matched above */
-		flags |= O_RDWR;
+		if (!read_only)
+			flags |= O_RDWR;
 		from_hash = file_lookup_open(f, flags);
 	}
 
diff --git a/fio.1 b/fio.1
index 733c740..c744d1a 100644
--- a/fio.1
+++ b/fio.1
@@ -68,12 +68,11 @@ available ioengines.
 Convert \fIjobfile\fR to a set of command\-line options.
 .TP
 .BI \-\-readonly
-Turn on safety read\-only checks, preventing writes. The \fB\-\-readonly\fR
+Turn on safety read\-only checks, preventing writes and trims. The \fB\-\-readonly\fR
 option is an extra safety guard to prevent users from accidentally starting
-a write workload when that is not desired. Fio will only write if
-`rw=write/randwrite/rw/randrw' is given. This extra safety net can be used
-as an extra precaution as \fB\-\-readonly\fR will also enable a write check in
-the I/O engine core to prevent writes due to unknown user space bug(s).
+a write or trim workload when that is not desired. Fio will only modify the
+device under test if `rw=write/randwrite/rw/randrw/trim/randtrim/trimwrite'
+is given. This safety net can be used as an extra precaution.
 .TP
 .BI \-\-eta \fR=\fPwhen
 Specifies when real\-time ETA estimate should be printed. \fIwhen\fR may
diff --git a/fio.h b/fio.h
index 9727f6c..51b8fdc 100644
--- a/fio.h
+++ b/fio.h
@@ -533,7 +533,8 @@ extern bool eta_time_within_slack(unsigned int time);
 
 static inline void fio_ro_check(const struct thread_data *td, struct io_u *io_u)
 {
-	assert(!(io_u->ddir == DDIR_WRITE && !td_write(td)));
+	assert(!(io_u->ddir == DDIR_WRITE && !td_write(td)) &&
+	       !(io_u->ddir == DDIR_TRIM && !td_trim(td)));
 }
 
 #define REAL_MAX_JOBS		4096
diff --git a/init.c b/init.c
index 353c99b..af4cc6b 100644
--- a/init.c
+++ b/init.c
@@ -594,13 +594,19 @@ static int fixup_options(struct thread_data *td)
 	struct thread_options *o = &td->o;
 	int ret = 0;
 
+	if (read_only && (td_write(td) || td_trim(td))) {
+		log_err("fio: trim and write operations are not allowed"
+			 " with the --readonly parameter.\n");
+		ret |= 1;
+	}
+
 #ifndef CONFIG_PSHARED
 	if (!o->use_thread) {
 		log_info("fio: this platform does not support process shared"
 			 " mutexes, forcing use of threads. Use the 'thread'"
 			 " option to get rid of this warning.\n");
 		o->use_thread = 1;
-		ret = warnings_fatal;
+		ret |= warnings_fatal;
 	}
 #endif
 
@@ -608,7 +614,7 @@ static int fixup_options(struct thread_data *td)
 		log_err("fio: read iolog overrides write_iolog\n");
 		free(o->write_iolog_file);
 		o->write_iolog_file = NULL;
-		ret = warnings_fatal;
+		ret |= warnings_fatal;
 	}
 
 	/*
@@ -662,7 +668,7 @@ static int fixup_options(struct thread_data *td)
 	    !o->norandommap) {
 		log_err("fio: Any use of blockalign= turns off randommap\n");
 		o->norandommap = 1;
-		ret = warnings_fatal;
+		ret |= warnings_fatal;
 	}
 
 	if (!o->file_size_high)
@@ -680,7 +686,7 @@ static int fixup_options(struct thread_data *td)
 	    && !fixed_block_size(o))  {
 		log_err("fio: norandommap given for variable block sizes, "
 			"verify limited\n");
-		ret = warnings_fatal;
+		ret |= warnings_fatal;
 	}
 	if (o->bs_unaligned && (o->odirect || td_ioengine_flagged(td, FIO_RAWIO)))
 		log_err("fio: bs_unaligned may not work with raw io\n");
@@ -724,7 +730,7 @@ static int fixup_options(struct thread_data *td)
 		log_err("fio: checking for in-flight overlaps when the "
 			"io_submit_mode is offload is not supported\n");
 		o->serialize_overlap = 0;
-		ret = warnings_fatal;
+		ret |= warnings_fatal;
 	}
 
 	if (o->nr_files > td->files_index)
@@ -738,7 +744,7 @@ static int fixup_options(struct thread_data *td)
 	    ((o->ratemin[DDIR_READ] + o->ratemin[DDIR_WRITE] + o->ratemin[DDIR_TRIM]) &&
 	    (o->rate_iops_min[DDIR_READ] + o->rate_iops_min[DDIR_WRITE] + o->rate_iops_min[DDIR_TRIM]))) {
 		log_err("fio: rate and rate_iops are mutually exclusive\n");
-		ret = 1;
+		ret |= 1;
 	}
 	if ((o->rate[DDIR_READ] && (o->rate[DDIR_READ] < o->ratemin[DDIR_READ])) ||
 	    (o->rate[DDIR_WRITE] && (o->rate[DDIR_WRITE] < o->ratemin[DDIR_WRITE])) ||
@@ -747,13 +753,13 @@ static int fixup_options(struct thread_data *td)
 	    (o->rate_iops[DDIR_WRITE] && (o->rate_iops[DDIR_WRITE] < o->rate_iops_min[DDIR_WRITE])) ||
 	    (o->rate_iops[DDIR_TRIM] && (o->rate_iops[DDIR_TRIM] < o->rate_iops_min[DDIR_TRIM]))) {
 		log_err("fio: minimum rate exceeds rate\n");
-		ret = 1;
+		ret |= 1;
 	}
 
 	if (!o->timeout && o->time_based) {
 		log_err("fio: time_based requires a runtime/timeout setting\n");
 		o->time_based = 0;
-		ret = warnings_fatal;
+		ret |= warnings_fatal;
 	}
 
 	if (o->fill_device && !o->size)
@@ -769,7 +775,7 @@ static int fixup_options(struct thread_data *td)
 			log_info("fio: multiple writers may overwrite blocks "
 				"that belong to other jobs. This can cause "
 				"verification failures.\n");
-			ret = warnings_fatal;
+			ret |= warnings_fatal;
 		}
 
 		/*
@@ -781,7 +787,7 @@ static int fixup_options(struct thread_data *td)
 			log_info("fio: verification read phase will never "
 				 "start because write phase uses all of "
 				 "runtime\n");
-			ret = warnings_fatal;
+			ret |= warnings_fatal;
 		}
 
 		if (!fio_option_is_set(o, refill_buffers))
@@ -817,7 +823,7 @@ static int fixup_options(struct thread_data *td)
 		if (td_ioengine_flagged(td, FIO_PIPEIO)) {
 			log_info("fio: cannot pre-read files with an IO engine"
 				 " that isn't seekable. Pre-read disabled.\n");
-			ret = warnings_fatal;
+			ret |= warnings_fatal;
 		}
 	}
 
@@ -841,7 +847,7 @@ static int fixup_options(struct thread_data *td)
 			 " this warning\n");
 		o->fsync_blocks = o->fdatasync_blocks;
 		o->fdatasync_blocks = 0;
-		ret = warnings_fatal;
+		ret |= warnings_fatal;
 	}
 #endif
 
@@ -854,7 +860,7 @@ static int fixup_options(struct thread_data *td)
 		log_err("fio: Windows does not support direct or non-buffered io with"
 				" the synchronous ioengines. Use the 'windowsaio' ioengine"
 				" with 'direct=1' and 'iodepth=1' instead.\n");
-		ret = 1;
+		ret |= 1;
 	}
 #endif
 
@@ -887,7 +893,7 @@ static int fixup_options(struct thread_data *td)
 	if (o->size && o->size < td_min_bs(td)) {
 		log_err("fio: size too small, must not be less than minimum block size: %llu < %u\n",
 			(unsigned long long) o->size, td_min_bs(td));
-		ret = 1;
+		ret |= 1;
 	}
 
 	/*
@@ -904,7 +910,7 @@ static int fixup_options(struct thread_data *td)
 
 	if (td_ioengine_flagged(td, FIO_NOEXTEND) && o->file_append) {
 		log_err("fio: can't append/extent with IO engine %s\n", td->io_ops->name);
-		ret = 1;
+		ret |= 1;
 	}
 
 	if (fio_option_is_set(o, gtod_cpu)) {
@@ -921,7 +927,7 @@ static int fixup_options(struct thread_data *td)
 		log_err("fio: block error histogram only available "
 			"with a single file per job, but %d files "
 			"provided\n", o->nr_files);
-		ret = 1;
+		ret |= 1;
 	}
 
 	if (fio_option_is_set(o, clat_percentiles) &&
@@ -935,7 +941,7 @@ static int fixup_options(struct thread_data *td)
 		   o->lat_percentiles && o->clat_percentiles) {
 		log_err("fio: lat_percentiles and clat_percentiles are "
 			"mutually exclusive\n");
-		ret = 1;
+		ret |= 1;
 	}
 
 	if (o->disable_lat)
diff --git a/options.c b/options.c
index 0c4f89c..a174e2c 100644
--- a/options.c
+++ b/options.c
@@ -1555,9 +1555,9 @@ static int rw_verify(const struct fio_option *o, void *data)
 {
 	struct thread_data *td = cb_data_to_td(data);
 
-	if (read_only && td_write(td)) {
-		log_err("fio: job <%s> has write bit set, but fio is in"
-			" read-only mode\n", td->o.name);
+	if (read_only && (td_write(td) || td_trim(td))) {
+		log_err("fio: job <%s> has write or trim bit set, but"
+			" fio is in read-only mode\n", td->o.name);
 		return 1;
 	}
 
diff --git a/t/jobs/readonly-r.fio b/t/jobs/readonly-r.fio
new file mode 100644
index 0000000..34ba9b5
--- /dev/null
+++ b/t/jobs/readonly-r.fio
@@ -0,0 +1,5 @@
+[test]
+filename=${DUT}
+rw=randread
+time_based
+runtime=1s
diff --git a/t/jobs/readonly-t.fio b/t/jobs/readonly-t.fio
new file mode 100644
index 0000000..f3e093c
--- /dev/null
+++ b/t/jobs/readonly-t.fio
@@ -0,0 +1,5 @@
+[test]
+filename=${DUT}
+rw=randtrim
+time_based
+runtime=1s
diff --git a/t/jobs/readonly-w.fio b/t/jobs/readonly-w.fio
new file mode 100644
index 0000000..26029ef
--- /dev/null
+++ b/t/jobs/readonly-w.fio
@@ -0,0 +1,5 @@
+[test]
+filename=${DUT}
+rw=randwrite
+time_based
+runtime=1s
diff --git a/t/readonly.sh b/t/readonly.sh
new file mode 100755
index 0000000..d709414
--- /dev/null
+++ b/t/readonly.sh
@@ -0,0 +1,84 @@
+#!/bin/bash
+#
+# Do some basic test of the --readonly parameter
+#
+# DUT should be a device that accepts read, write, and trim operations
+#
+# Example usage:
+#
+# DUT=/dev/fioa t/readonly.sh
+#
+TESTNUM=1
+
+#
+# The first parameter is the return code
+# The second parameter is 0        if the return code should be 0
+#                         positive if the return code should be positive
+#
+check () {
+	echo "********************"
+
+	if [ $2 -gt 0 ]; then
+		if [ $1 -eq 0 ]; then
+			echo "Test $TESTNUM failed"
+			echo "********************"
+			exit 1
+		else
+			echo "Test $TESTNUM passed"
+		fi
+	else
+		if [ $1 -gt 0 ]; then
+			echo "Test $TESTNUM failed"
+			echo "********************"
+			exit 1
+		else
+			echo "Test $TESTNUM passed"
+		fi
+	fi
+
+	echo "********************"
+	echo
+	TESTNUM=$((TESTNUM+1))
+}
+
+./fio --name=test --filename=$DUT --rw=randread  --readonly --time_based --runtime=1s &> /dev/null
+check $? 0
+./fio --name=test --filename=$DUT --rw=randwrite --readonly --time_based --runtime=1s &> /dev/null
+check $? 1
+./fio --name=test --filename=$DUT --rw=randtrim  --readonly --time_based --runtime=1s &> /dev/null
+check $? 1
+
+./fio --name=test --filename=$DUT --readonly --rw=randread  --time_based --runtime=1s &> /dev/null
+check $? 0
+./fio --name=test --filename=$DUT --readonly --rw=randwrite --time_based --runtime=1s &> /dev/null
+check $? 1
+./fio --name=test --filename=$DUT --readonly --rw=randtrim  --time_based --runtime=1s &> /dev/null
+check $? 1
+
+./fio --name=test --filename=$DUT --rw=randread  --time_based --runtime=1s &> /dev/null
+check $? 0
+./fio --name=test --filename=$DUT --rw=randwrite --time_based --runtime=1s &> /dev/null
+check $? 0
+./fio --name=test --filename=$DUT --rw=randtrim  --time_based --runtime=1s &> /dev/null
+check $? 0
+
+./fio t/jobs/readonly-r.fio --readonly &> /dev/null
+check $? 0
+./fio t/jobs/readonly-w.fio --readonly &> /dev/null
+check $? 1
+./fio t/jobs/readonly-t.fio --readonly &> /dev/null
+check $? 1
+
+./fio --readonly t/jobs/readonly-r.fio &> /dev/null
+check $? 0
+./fio --readonly t/jobs/readonly-w.fio &> /dev/null
+check $? 1
+./fio --readonly t/jobs/readonly-t.fio &> /dev/null
+check $? 1
+
+./fio t/jobs/readonly-r.fio &> /dev/null
+check $? 0
+./fio t/jobs/readonly-w.fio &> /dev/null
+check $? 0
+./fio t/jobs/readonly-t.fio &> /dev/null
+check $? 0
