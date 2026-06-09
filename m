Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD324407CEC
	for <fio@vger.kernel.org>; Tue,  9 Jun 2026 12:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781006418; cv=none; b=hqtHjWmMV80pt0AkWt9n4tcAe86caI4urKryAHf9Q62OTY106sZupaK3cK0HBdO3lqZSn8Yk4iiY/mKhcOwzlGMJ+suppmBdgCwpGTE6uHVTw5VswkwZp35+7NfwPRwVYlJ+YzkLqyMKytX1PAVchtz9iGEbOe8cHTbt3UyEABI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781006418; c=relaxed/simple;
	bh=B3NPOLPOMP/How1/7cfyzlQdqvQ3nzLL/Ntnze4/rZU=;
	h=Subject:From:To:Date:Message-Id; b=Jpnksy+x0p6gExEhLM/CoGCcENI/wsxSLC6QHd8z65E0UscCjwRobpzHCRKe4SErW3n7qrrZMh4dqLLjd4GilQwLofBo8AGhQ0buLJQOqtBZWLZ8quePmRKesDyhIEBaV175eET2i/J1u5YEXXS/Jls2jPudk99CLFLobyxnRgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SElB/4Hr; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SElB/4Hr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=iEckkd49fEmeVRmOjm0w/z4k2WPaQVUCFlLC01U4FiE=; b=SElB/4Hr8p4cUrPm8UBWfTQB0R
	szMNG+3X9AIGcHgail6ras4rE4ey9hAAePY379OdOct9FQwOxrVmTQz32bRKLmaMaPIEf3UXNMsnw
	5xMJMS7Tueyhum3N1i6hnwev6bAUy4Vx+wbtlFZIBD0DJRrKOc9ffj9jdSZf/y1rhTyNANgzPZFB7
	WLLCg5rKzpMSClgk9jLUGawxdWZ+KnepVocpnJwRyTiANkakldnI8Gk2H2+Yp+ChwQd9kpwhKcuTh
	bMh+OhV1OEvoJ7pp8IJS6/GpCbBoFwT1rqOY7fj8OXRV/RtdBoA/JacxEz0zz8p7KlGkP53WeZv9a
	hk194wGQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wWv7m-00000002RAF-0yZU
	for fio@vger.kernel.org;
	Tue, 09 Jun 2026 12:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id C8DFD1BC00E8; Tue,  9 Jun 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Tue,  9 Jun 2026 06:00:01 -0600
Message-Id: <20260609120001.C8DFD1BC00E8@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 5e65f4f03c67016e09111c5cd7b2f5137c126106:

  Merge branch 'fix/metadata-io_uring-doc' of https://github.com/calebsander/fio (2026-06-05 15:34:26 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to cf144e06b4f98492f6ca8a17157bcf284b3f64a4:

  t/run-fio-tests: add verify_state_save.py (2026-06-08 14:05:55 -0400)

----------------------------------------------------------------
Minwoo Im (3):
      verify: introduce crash-aware data verification
      backend: mark @td to terminate when no more next verify
      backend: stop outer loop when `verify_only=1`

Vincent Fu (3):
      Merge branch 'verify-policy' of https://github.com/minwooim/fio
      t/verify_state_save: test verify state save feature
      t/run-fio-tests: add verify_state_save.py

 HOWTO.rst              |  20 +++
 backend.c              |  72 +++++++++-
 cconv.c                |   2 +
 engines/io_uring.c     |  30 +++++
 fio.1                  |  23 ++++
 fio.h                  |   3 +
 io_u.c                 |   1 +
 options.c              |  24 ++++
 server.h               |   2 +-
 t/run-fio-tests.py     |   8 ++
 t/verify_state_save.py | 352 +++++++++++++++++++++++++++++++++++++++++++++++++
 thread_options.h       |   3 +
 verify-state.h         |   4 +-
 verify.c               |  36 ++++-
 verify.h               |   6 +
 15 files changed, 579 insertions(+), 7 deletions(-)
 create mode 100755 t/verify_state_save.py

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 6bf7b29d..63964eb9 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -4156,6 +4156,26 @@ Verification
         used to speed up the process of writing each block on a device with its
         offset. Default: 0 (disabled).
 
+.. option:: verify_policy=str
+
+        Controls which writes are included during offline verification.  Only
+        takes effect when :option:`verify_state_save` is used to save state
+        during the write phase and a separate job later verifies with
+        :option:`verify_state_load`.
+
+        **completed**
+                Verify all completed writes (default).
+
+        **fsynced**
+                Only verify writes that were completed before the last fsync
+                submission which goes to successfully complete.  Writes issued
+                after the most recent fsync submission are excluded, because
+                they may not be persistent after a crash or power loss.
+                The safe threshold is captured at fsync submission time (not
+                completion time) to avoid counting writes submitted after the
+                fsync submission in async engines.  At state-save time the
+                threshold and the in-flight write list are recorded.
+
 .. option:: verify_fatal=bool
 
 	Normally fio will keep checking the entire contents before quitting on a
diff --git a/backend.c b/backend.c
index e2b33b14..af5a22b7 100644
--- a/backend.c
+++ b/backend.c
@@ -1102,6 +1102,46 @@ void clear_inflight(struct thread_data *td)
 	td->inflight_issued = td->io_issues[DDIR_WRITE];
 }
 
+/*
+ * Called just before an fsync is submitted with verify_policy=fsynced.  Captures
+ * the current inflight_issued as the safe threshold for this fsync.
+ *
+ * The threshold must be captured here, at submission time, not at completion
+ * time: in async engines (e.g. io_uring_cmd) new writes may be submitted
+ * after the fsync SQE, so reading inflight_issued at completion would
+ * include those post-fsync writes in the safe set.  The captured value is
+ * stored in io_u->numberio and transferred to safe_inflight_issued only
+ * when the fsync successfully completes.
+ */
+void on_fsync_submitted(struct thread_data *td, struct io_u *io_u)
+{
+	if (!(td->o.verify_policy & VERIFY_POLICY_FSYNCED) || !td->inflight_numberio)
+		return;
+
+	io_u->numberio = atomic_load_acquire(&td->inflight_issued);
+
+	dprint(FD_VERIFY, "on_fsync_submitted: threshold=%"PRIu64"\n",
+		io_u->numberio);
+}
+
+/*
+ * Called when an fsync successfully completes with verify_policy=fsynced.
+ * Transfers the threshold captured at submission time to safe_inflight_issued.
+ * Store threshold+1 so that 0 remains the "no completed fsync" sentinel.
+ * Take the max so that out-of-order completions never lower the threshold.
+ */
+void on_fsync_completed(struct thread_data *td, struct io_u *io_u)
+{
+	if (!(td->o.verify_policy & VERIFY_POLICY_FSYNCED) || !td->inflight_numberio)
+		return;
+
+	if (io_u->numberio + 1 > td->safe_inflight_issued)
+		td->safe_inflight_issued = io_u->numberio + 1;
+
+	dprint(FD_VERIFY, "on_fsync_completed: threshold=%"PRIu64", safe_issued=%"PRIu64"\n",
+		io_u->numberio, td->safe_inflight_issued);
+}
+
 /*
  * Main IO worker function. It retrieves io_u's to process and queues
  * and reaps them, checking for rate and errors along the way.
@@ -1212,6 +1252,8 @@ static void do_io(struct thread_data *td, uint64_t *bytes_done)
 				populate_verify_io_u(td, io_u);
 				log_inflight(td, io_u);
 			}
+		} else if (ddir_sync(io_u->ddir)) {
+			on_fsync_submitted(td, io_u);
 		}
 
 		ddir = io_u->ddir;
@@ -1420,6 +1462,7 @@ static int init_inflight_logging(struct thread_data *td)
 	for (i = 0; i < td->o.iodepth; i++)
 		td->inflight_numberio[i] = INVALID_NUMBERIO;
 
+	td->safe_inflight_issued = 0;
 	return 0;
 }
 
@@ -1747,6 +1790,15 @@ static bool keep_running(struct thread_data *td)
 		td->o.loops--;
 		return true;
 	}
+
+	/*
+	 * The verify state file may describe fewer I/Os than the job's
+	 * configured size or number_ios, so stop here rather than looping
+	 * again and re-verifying from the beginning.
+	 */
+	if (td->o.verify_only && td->vstate)
+		return false;
+
 	if (exceeds_number_ios(td))
 		return false;
 
@@ -1813,6 +1865,20 @@ static uint64_t do_dry_run(struct thread_data *td)
 		if (IS_ERR_OR_NULL(io_u))
 			break;
 
+		/*
+		 * Check stop condition before updating any accounting, so
+		 * put_io_u() can be called cleanly on early exit.
+		 */
+		if (td_write(td) && io_u->ddir == DDIR_WRITE &&
+		    td->o.do_verify &&
+		    td->o.verify != VERIFY_NONE &&
+		    !td->o.experimental_verify) {
+			if (verify_state_should_stop(td, td->io_issues[acct_ddir(io_u)])) {
+				put_io_u(td, io_u);
+				break;
+			}
+		}
+
 		io_u_set(td, io_u, IO_U_F_FLIGHT);
 		io_u->error = 0;
 		io_u->resid = 0;
@@ -2117,9 +2183,11 @@ static void *thread_main(void *data)
 
 		prune_io_piece_log(td);
 
-		if (td->o.verify_only && td_write(td))
+		if (td->o.verify_only && td_write(td)) {
 			verify_bytes = do_dry_run(td);
-		else {
+			if (!verify_bytes)
+				fio_mark_td_terminate(td);
+		} else {
 			if (!td->o.rand_repeatable)
 				/* save verify rand state to replay hdr seeds later at verify */
 				frand_copy(&td->verify_state_last_do_io, &td->verify_state);
diff --git a/cconv.c b/cconv.c
index 1c1b7273..753c55ab 100644
--- a/cconv.c
+++ b/cconv.c
@@ -181,6 +181,7 @@ int convert_thread_options_to_cpu(struct thread_options *o,
 	o->sync_io = le32_to_cpu(top->sync_io);
 	o->write_hint = le32_to_cpu(top->write_hint);
 	o->verify = le32_to_cpu(top->verify);
+	o->verify_policy = le32_to_cpu(top->verify_policy);
 	o->do_verify = le32_to_cpu(top->do_verify);
 	o->experimental_verify = le32_to_cpu(top->experimental_verify);
 	o->verify_state = le32_to_cpu(top->verify_state);
@@ -454,6 +455,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->sync_io = cpu_to_le32(o->sync_io);
 	top->write_hint = cpu_to_le32(o->write_hint);
 	top->verify = cpu_to_le32(o->verify);
+	top->verify_policy = cpu_to_le32(o->verify_policy);
 	top->do_verify = cpu_to_le32(o->do_verify);
 	top->experimental_verify = cpu_to_le32(o->experimental_verify);
 	top->verify_state = cpu_to_le32(o->verify_state);
diff --git a/engines/io_uring.c b/engines/io_uring.c
index d4dff3b8..6aedb062 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -890,6 +890,28 @@ static enum fio_q_status fio_ioring_queue(struct thread_data *td,
 	if (ld->queued == td->o.iodepth)
 		return FIO_Q_BUSY;
 
+	/*
+	 * For io_uring_cmd with verify_policy=fsynced, the flush must not be
+	 * submitted while writes are still in flight. The NVMe device does
+	 * not guarantee ordering between a flush and concurrent writes in its
+	 * internal queue, so all prior writes must have completed at the
+	 * device level before the flush is issued. Return BUSY to let fio
+	 * drain in-flight ops; fio will retry the flush once the queue is
+	 * empty.
+	 *
+	 * Use td->cur_depth > 1 (not io_issues vs io_blocks) because io_blocks
+	 * only counts successful completions; errored I/Os never increment it,
+	 * causing a permanent mismatch. cur_depth is decremented for both
+	 * success and error completions. The flush io_u itself already holds
+	 * one count when fio_ioring_queue() is called, so check > 1 to
+	 * distinguish "only the flush is in-flight" from "writes still pending".
+	 */
+	if (ddir_sync(io_u->ddir) && ld->is_uring_cmd_eng &&
+	    (td->o.verify_policy & VERIFY_POLICY_FSYNCED)) {
+		if (td->cur_depth > 1)
+			return FIO_Q_BUSY;
+	}
+
 	/*
 	 * If this is a syncfs request, or if async trim has been tried and
 	 * failed, punt to sync.
@@ -1484,6 +1506,14 @@ static int fio_ioring_init(struct thread_data *td)
 		return 1;
 	}
 
+	if (o->writefua && (td->o.verify_policy & VERIFY_POLICY_FSYNCED)) {
+		log_err("fio: writefua=1 is incompatible with verify_policy=fsynced. "
+			"FUA writes are individually committed to storage media "
+			"and do not require fsync coverage tracking. "
+			"Use verify_policy=completed(default) instead.\n");
+		return 1;
+	}
+
 	ld = calloc(1, sizeof(*ld));
 
 	ld->is_uring_cmd_eng = (td->io_ops->prep == fio_ioring_cmd_prep);
diff --git a/fio.1 b/fio.1
index 1c572c3c..71a7309a 100644
--- a/fio.1
+++ b/fio.1
@@ -3861,6 +3861,29 @@ Recreate an instance of the \fBverify_pattern\fR every
 up the process of writing each block on a device with its offset. Default:
 0 (disabled).
 .TP
+.BI verify_policy \fR=\fPstr
+Controls which writes are included during offline verification. Only
+takes effect when \fBverify_state_save\fR is used to save state
+during the write phase and a separate job later verifies with
+\fBverify_state_load\fR.
+.RS
+.RS
+.TP
+.B completed
+Verify all completed writes (default).
+.TP
+.B fsynced
+Only verify writes that were completed before the last fsync
+submission which goes to successfully complete. Writes issued
+after the most recent fsync submission are excluded, because
+they may not be persistent after a crash or power loss.
+The safe threshold is captured at fsync submission time (not
+completion time) to avoid counting writes submitted after the
+fsync submission in async engines. At state-save time the
+threshold and the in-flight write list are recorded.
+.RE
+.RE
+.TP
 .BI verify_fatal \fR=\fPbool
 Normally fio will keep checking the entire contents before quitting on a
 block verification failure. If this option is set, fio will exit the job on
diff --git a/fio.h b/fio.h
index 3b6ff6c6..8ef3523e 100644
--- a/fio.h
+++ b/fio.h
@@ -385,6 +385,7 @@ struct thread_data {
 	uint64_t *inflight_numberio;
 	unsigned int next_inflight_numberio_idx;
 	uint64_t inflight_issued;
+	uint64_t safe_inflight_issued;		/* threshold+1 from last completed fsync (0 = no fsync yet), for verify_policy=fsynced */
 
 	/*
 	 * Track failed write I/Os for offline verification (to exclude from verify state)
@@ -804,6 +805,8 @@ extern void lat_target_reset(struct thread_data *);
 extern void log_inflight(struct thread_data *, struct io_u *);
 extern void invalidate_inflight(struct thread_data *, struct io_u *);
 extern void clear_inflight(struct thread_data *);
+extern void on_fsync_submitted(struct thread_data *, struct io_u *);
+extern void on_fsync_completed(struct thread_data *, struct io_u *);
 
 /*
  * Iterates all threads/processes within all the defined jobs
diff --git a/io_u.c b/io_u.c
index 1725a9ce..8b90dd1b 100644
--- a/io_u.c
+++ b/io_u.c
@@ -2178,6 +2178,7 @@ static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
 	if (ddir_sync(ddir)) {
 		if (io_u->error)
 			goto error;
+		on_fsync_completed(td, io_u);
 		if (f) {
 			f->first_write = -1ULL;
 			f->last_write = -1ULL;
diff --git a/options.c b/options.c
index f418179b..0df0f87f 100644
--- a/options.c
+++ b/options.c
@@ -3389,6 +3389,30 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_VERIFY,
 	},
+	{
+		.name	= "verify_policy",
+		.lname	= "Verify policy",
+		.type	= FIO_OPT_STR_MULTI,
+		.off1	= offsetof(struct thread_options, verify_policy),
+		.help	= "Filter writes to verify based on crash semantics",
+		.def	= "completed",
+		.parent = "verify",
+		.hide	= 1,
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_VERIFY,
+		.posval = {
+			  { .ival = "completed",
+			    .oval = VERIFY_POLICY_COMPLETED,
+			    .orval = 1,
+			    .help = "Verify all completed writes",
+			  },
+			  { .ival = "fsynced",
+			    .oval = VERIFY_POLICY_FSYNCED,
+			    .orval = 1,
+			    .help = "Verify only writes covered by the last fsync",
+			  },
+		},
+	},
 	{
 		.name	= "verifysort",
 		.lname	= "Verify sort",
diff --git a/server.h b/server.h
index 6ac89013..e38900ee 100644
--- a/server.h
+++ b/server.h
@@ -51,7 +51,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 120,
+	FIO_SERVER_VER			= 121,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index afecd67d..35790120 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -1155,6 +1155,14 @@ TEST_LIST = [
         'success':          SUCCESS_DEFAULT,
         'requirements':     [Requirements.linux, Requirements.nvmecdev],
     },
+    {
+        'test_id':          1023,
+        'test_class':       FioExeTest,
+        'exe':              't/verify_state_save.py',
+        'parameters':       ['-f', '{fio_path}'],
+        'success':          SUCCESS_DEFAULT,
+        'requirements':     [],
+    },
 ]
 
 
diff --git a/t/verify_state_save.py b/t/verify_state_save.py
new file mode 100755
index 00000000..8376c8ee
--- /dev/null
+++ b/t/verify_state_save.py
@@ -0,0 +1,352 @@
+#!/usr/bin/env python3
+#
+# Copyright 2026 Samsung Electronics Co., Ltd All Rights Reserved
+#
+# For conditions of distribution and use, see the accompanying COPYING file.
+#
+"""
+# verify_state_save.py
+#
+# Superficial tests of fio's verify state save feature
+#
+# USAGE
+# see python3 verify_state_save.py --help
+#
+# EXAMPLES
+# python3 t/verify_state_save.py
+# python3 t/verify_state_save.py -f ./fio
+#
+# REQUIREMENTS
+# Python 3.6
+#
+"""
+import os
+import sys
+import time
+import logging
+import platform
+import argparse
+from pathlib import Path
+from fiotestlib import FioJobCmdTest, run_fio_tests
+from fiotestcommon import SUCCESS_NONZERO
+
+
+class VerifyStateSaveTest(FioJobCmdTest):
+    """
+    Verify state save test class. Just make sure the test completes successfully.
+    """
+
+    def setup(self, parameters):
+        """Setup a test."""
+
+        fio_args = [
+            f"--output={self.filenames['output']}",
+            f"--output-format={self.fio_opts['output-format']}",
+            "--name=verify-state",
+            f"--ioengine={self.fio_opts['ioengine']}",
+            f"--filesize={self.fio_opts['filesize']}",
+            f"--rw={self.fio_opts['rw']}",
+        ]
+        for opt in ['fixedbufs', 'nonvectored', 'force_async', 'registerfiles',
+                    'sqthread_poll', 'sqthread_poll_cpu', 'hipri', 'nowait',
+                    'time_based', 'runtime', 'verify', 'io_size', 'num_range',
+                    'iodepth', 'iodepth_batch', 'iodepth_batch_complete',
+                    'size', 'rate', 'bs', 'bssplit', 'bsrange', 'randrepeat',
+                    'buffer_pattern', 'verify_pattern', 'offset', 'write_mode',
+                    "fsync", "verify_state_save", "verify_state_load",
+                    'directory', "verify_only", "verify_policy", "aux-path",
+                    "rwmixread", "rwmixwrite", ]:
+            if opt in self.fio_opts:
+                option = f"--{opt}={self.fio_opts[opt]}"
+                fio_args.append(option)
+
+        super().setup(fio_args)
+
+
+    def check_result(self):
+
+        super().check_result()
+
+        if 'rw' not in self.fio_opts or \
+                not self.passed or \
+                'json' not in self.fio_opts['output-format']:
+            return
+
+        job = self.json_data['jobs'][0]
+
+        if self.fio_opts['rw'] in ['read', 'randread']:
+            self.passed = self.check_all_ddirs(['read'], job)
+        elif self.fio_opts['rw'] in ['write', 'randwrite']:
+            if 'verify' not in self.fio_opts:
+                self.passed = self.check_all_ddirs(['write'], job)
+            else:
+                self.passed = self.check_all_ddirs(['read', 'write'], job)
+        elif self.fio_opts['rw'] in ['trim', 'randtrim']:
+            self.passed = self.check_all_ddirs(['trim'], job)
+        elif self.fio_opts['rw'] in ['readwrite', 'randrw']:
+            self.passed = self.check_all_ddirs(['read', 'write'], job)
+        elif self.fio_opts['rw'] in ['trimwrite', 'randtrimwrite']:
+            self.passed = self.check_all_ddirs(['trim', 'write'], job)
+        else:
+            logging.error("Unhandled rw value %s", self.fio_opts['rw'])
+            self.passed = False
+
+TEST_SIZE="4M"
+
+TEST_LIST = [
+    # Simple tests where a verify job runs to completion and we save
+    # verify state
+    {
+        "test_id": 100,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "ioengine": "psync",
+            "filesize": TEST_SIZE,
+            "output-format": "json",
+            "verify": "crc32c",
+            "verify_state_save": 1,
+            },
+        "test_class": VerifyStateSaveTest,
+    },
+    {
+        "test_id": 101,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "ioengine": "psync",
+            "filesize": TEST_SIZE,
+            "output-format": "json",
+            "verify": "crc32c",
+            "verify_state_save": 1,
+            "verify_policy": "completed",
+            },
+        "test_class": VerifyStateSaveTest,
+    },
+    {
+        "test_id": 102,
+        "fio_opts": {
+            "rw": 'randwrite',
+            "ioengine": "psync",
+            "filesize": TEST_SIZE,
+            "output-format": "json",
+            "verify": "crc32c",
+            "verify_state_save": 1,
+            "verify_policy": "fsynced",
+            "fsync": 16,
+            },
+        "test_class": VerifyStateSaveTest,
+    },
+    {
+        "test_id": 103,
+        "fio_opts": {
+            "rw": 'randrw',
+            "ioengine": "psync",
+            "filesize": TEST_SIZE,
+            "output-format": "json",
+            "verify": "crc32c",
+            "verify_state_save": 1,
+            },
+        "test_class": VerifyStateSaveTest,
+    },
+    {
+        "test_id": 104,
+        "fio_opts": {
+            "rw": 'randrw',
+            "ioengine": "psync",
+            "filesize": TEST_SIZE,
+            "output-format": "json",
+            "verify": "crc32c",
+            "verify_state_save": 1,
+            "verify_policy": "completed",
+            },
+        "test_class": VerifyStateSaveTest,
+    },
+    {
+        "test_id": 105,
+        "fio_opts": {
+            "rw": 'randrw',
+            "ioengine": "psync",
+            "filesize": TEST_SIZE,
+            "output-format": "json",
+            "verify": "crc32c",
+            "verify_state_save": 1,
+            "verify_policy": "fsynced",
+            "fsync": 16,
+            },
+        "test_class": VerifyStateSaveTest,
+    },
+    {
+        "test_id": 106,
+        "fio_opts": {
+            "rw": 'randrw',
+            "rwmixread": 70,
+            "ioengine": "psync",
+            "filesize": TEST_SIZE,
+            "output-format": "json",
+            "verify": "crc32c",
+            "verify_state_save": 1,
+            },
+        "test_class": VerifyStateSaveTest,
+    },
+    {
+        "test_id": 107,
+        "fio_opts": {
+            "rw": 'randrw',
+            "rwmixread": 70,
+            "ioengine": "psync",
+            "filesize": TEST_SIZE,
+            "output-format": "json",
+            "verify": "crc32c",
+            "verify_state_save": 1,
+            "verify_policy": "completed",
+            },
+        "test_class": VerifyStateSaveTest,
+    },
+    {
+        "test_id": 108,
+        "fio_opts": {
+            "rw": 'randrw',
+            "rwmixread": 70,
+            "ioengine": "psync",
+            "filesize": TEST_SIZE,
+            "output-format": "json",
+            "verify": "crc32c",
+            "verify_state_save": 1,
+            "verify_policy": "fsynced",
+            "fsync": 16,
+            },
+        "test_class": VerifyStateSaveTest,
+    },
+]
+
+def parse_args():
+    """Parse command-line arguments."""
+
+    parser = argparse.ArgumentParser()
+    parser.add_argument('-d', '--debug', help='Enable debug messages', action='store_true')
+    parser.add_argument('-f', '--fio', help='path to file executable (e.g., ./fio)')
+    parser.add_argument('-a', '--artifact-root', help='artifact root directory')
+    parser.add_argument('-s', '--skip', nargs='+', type=int,
+                        help='list of test(s) to skip')
+    parser.add_argument('-o', '--run-only', nargs='+', type=int,
+                        help='list of test(s) to run, skipping all others')
+    args = parser.parse_args()
+
+    return args
+
+
+def main():
+    """Run tests to exercise fio's verify_state_save feature."""
+
+    args = parse_args()
+
+    if args.debug:
+        logging.basicConfig(level=logging.DEBUG)
+    else:
+        logging.basicConfig(level=logging.INFO)
+
+    artifact_root = args.artifact_root if args.artifact_root else \
+        f"verify-state-save-test-{time.strftime('%Y%m%d-%H%M%S')}"
+    os.mkdir(artifact_root)
+    print(f"Artifact directory is {artifact_root}")
+
+    if args.fio:
+        fio_path = str(Path(args.fio).absolute())
+    else:
+        fio_path = os.path.join(str(Path(__file__).absolute().parent.parent), "fio")
+    print(f"fio path is {fio_path}")
+
+    test_env = {
+              'fio_path': fio_path,
+              'fio_root': str(Path(__file__).absolute().parent.parent),
+              'artifact_root': artifact_root,
+              'basename': 'verify-state-save',
+              }
+
+    if platform.system() == 'Linux':
+        aio = 'libaio'
+        sync = 'psync'
+    elif platform.system() == 'Windows':
+        aio = 'windowsaio'
+        sync = 'sync'
+    else:
+        aio = 'posixaio'
+        sync = 'psync'
+
+    total = { 'passed':  0, 'failed': 0, 'skipped': 0 }
+    for ioengine in [aio, sync]:
+
+        #
+        # set up tests with verify_state_save=1 to generate verify state save files
+        #
+        test_env['artifact_root'] = os.path.join(artifact_root, ioengine, "verify-state-save")
+        os.makedirs(test_env['artifact_root'])
+
+        for test in TEST_LIST:
+            test['fio_opts']['ioengine'] = ioengine
+            test['fio_opts']['verify_state_save'] = 1
+            test['fio_opts']['rw'] = test['fio_opts']['rw'].replace("read", "write")
+            test['fio_opts'].pop('verify_state_load', None)
+            test['fio_opts'].pop('directory', None)
+            test['fio_opts'].pop('aux-path', None)
+            test['force_skip'] = False
+
+        print(f"\nRunning verify_state_save=1 tests with ioengine={ioengine}")
+        passed, failed, skipped = run_fio_tests(TEST_LIST, test_env, args)
+
+        total['passed'] += passed
+        total['failed'] += failed
+        total['skipped'] += skipped
+
+        #
+        # set up same tests with verify_state_load=1 and verify_only=1
+        #
+        test_env['artifact_root'] = os.path.join(artifact_root, ioengine, "verify-only")
+        os.makedirs(test_env['artifact_root'])
+
+        for test in TEST_LIST:
+            test['fio_opts']['verify_state_save'] = 0  # don't overwrite vssave file
+            test['fio_opts']['verify_state_load'] = 1
+            test['fio_opts']['verify_only'] = 1
+            vss_dir = os.path.join(artifact_root, ioengine, "verify-state-save", f"{test['test_id']:04d}")
+            this_dir = os.path.join(test_env['artifact_root'], f"{test['test_id']:04d}")
+            directory = os.path.relpath(vss_dir, this_dir)
+            test['fio_opts']['directory'] = directory
+            test['fio_opts']['aux-path'] = directory
+
+
+        print(f"\nRunning verify_only=1 tests with ioengine={ioengine}")
+        passed, failed, skipped = run_fio_tests(TEST_LIST, test_env, args)
+
+        total['passed'] += passed
+        total['failed'] += failed
+        total['skipped'] += skipped
+
+        #
+        # now run the same verify_state_load=1 tests replacing randwrite with
+        # randread
+        #
+        test_env['artifact_root'] = os.path.join(artifact_root, ioengine, "read")
+        os.makedirs(test_env['artifact_root'])
+
+        for test in TEST_LIST:
+            test['fio_opts'].pop('verify_only', None)
+            test['fio_opts']['rw'] = test['fio_opts']['rw'].replace("write", "read")
+            if test['fio_opts']['rw'] == 'randrw':
+                test['force_skip'] = True
+                # there is no 100% read equivalent of a randrw verify workload,
+                # so just skip these tests when run in read mode
+
+        print(f"\nRunning rw=[rand]read tests with ioengine={ioengine}")
+        passed, failed, skipped = run_fio_tests(TEST_LIST, test_env, args)
+
+        total['passed'] += passed
+        total['failed'] += failed
+        total['skipped'] += skipped
+
+    print(f"\n\n{total['passed']} test(s) passed, {total['failed']} failed, " \
+            f"{total['skipped']} skipped")
+    sys.exit(total['failed'])
+
+
+if __name__ == '__main__':
+    main()
diff --git a/thread_options.h b/thread_options.h
index 1b7f67eb..65114dc9 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -143,6 +143,7 @@ struct thread_options {
 	unsigned int sync_io;
 	unsigned int write_hint;
 	unsigned int verify;
+	unsigned int verify_policy;
 	unsigned int do_verify;
 	unsigned int verify_interval;
 	unsigned int verify_offset;
@@ -485,6 +486,7 @@ struct thread_options_pack {
 	uint32_t sync_io;
 	uint32_t write_hint;
 	uint32_t verify;
+	uint32_t verify_policy;
 	uint32_t do_verify;
 	uint32_t verify_interval;
 	uint32_t verify_offset;
@@ -535,6 +537,7 @@ struct thread_options_pack {
 
 	struct zone_split zone_split[DDIR_RWDIR_CNT][ZONESPLIT_MAX];
 	uint32_t zone_split_nr[DDIR_RWDIR_CNT];
+	uint32_t pad3;
 
 	fio_fp64_t zipf_theta;
 	fio_fp64_t pareto_h;
diff --git a/verify-state.h b/verify-state.h
index 03093ecd..93cb2420 100644
--- a/verify-state.h
+++ b/verify-state.h
@@ -29,7 +29,7 @@ struct inflight_write {
 
 struct thread_io_list {
 	uint32_t depth; /* I/O depth of the job that saves the verify state */
-	uint64_t numberio; /* Number of issued writes */
+	uint64_t numberio; /* fsync threshold (VERIFY_POLICY_FSYNCED) or total writes issued */
 	uint64_t index;
 	struct thread_rand_state rand;
 	uint8_t name[64];
@@ -41,7 +41,7 @@ struct all_io_list {
 	struct thread_io_list state[0];
 };
 
-#define VSTATE_HDR_VERSION	0x06
+#define VSTATE_HDR_VERSION	0x07
 
 struct verify_state_hdr {
 	uint64_t version;
diff --git a/verify.c b/verify.c
index 9dd9da7e..7237dc2c 100644
--- a/verify.c
+++ b/verify.c
@@ -1682,6 +1682,28 @@ struct all_io_list *get_all_io_list(int save_mask, size_t *sz)
 		for (int i = 0; td->inflight_numberio && i < td->o.iodepth; i++)
 			s->inflight[i].numberio = cpu_to_le64(atomic_load_acquire(&td->inflight_numberio[i]));
 
+		/*
+		 * Offline verify jobs stop under two conditions:
+		 *   1. fio tries to queue a write that was still inflight when
+		 *      the state was saved.
+		 *   2. fio tries to queue a write whose numberio exceeds the max
+		 *      numberio recorded in the state file (s->numberio).
+		 */
+		if (td->o.verify_policy & VERIFY_POLICY_FSYNCED) {
+			/*
+			 * For `verify_policy=fsynced`, store safe inflight
+			 * threshold numberio to terminate verification due to
+			 * condition 2.  If no fsync has completed yet, store 0
+			 * so that condition 2 stops all verification
+			 * immediately.
+			 */
+			if (td->safe_inflight_issued)
+				s->numberio = cpu_to_le64(td->safe_inflight_issued - 1);
+			else
+				s->numberio = 0;
+		} else
+			s->numberio = cpu_to_le64((uint64_t) atomic_load_acquire(&td->inflight_issued));
+
 		/* Then, append failed I/Os to exclude them from verification */
 		for (unsigned int i = 0; i < td->failed_numberio_count; i++) {
 			s->inflight[td->o.iodepth + i].numberio = cpu_to_le64(td->failed_numberio[i]);
@@ -1691,7 +1713,6 @@ struct all_io_list *get_all_io_list(int save_mask, size_t *sz)
 
 		total_depth = td->o.iodepth + td->failed_numberio_count;
 		s->depth = cpu_to_le32((uint32_t) total_depth);
-		s->numberio = cpu_to_le64((uint64_t) atomic_load_acquire(&td->inflight_issued));
 		s->index = cpu_to_le64((uint64_t) __td_index);
 		if (td->offset_state.use64) {
 			s->rand.state64.s[0] = cpu_to_le64(td->offset_state.state64.s1);
@@ -1990,8 +2011,19 @@ int verify_state_should_stop(struct thread_data *td, uint64_t numberio)
 	int i;
 
 	dprint(FD_VERIFY, "verify_state_should_stop numberio=%"PRIu64"\n", numberio);
-	if (!s)
+	if (!s) {
+		/*
+		 * If verify state is NULL, it means that the current verify
+		 * session is online verification.  We can simply see the cached
+		 * value in @td only in case of --verify_policy=fsynced and there was
+		 * at least one fsync happened.
+		 */
+		if (td->o.verify_policy & VERIFY_POLICY_FSYNCED) {
+			return !td->safe_inflight_issued ||
+				numberio >= td->safe_inflight_issued - 1;
+		}
 		return 0;
+	}
 
 	/* If the current seq is lower than the max issued seq, check to make sure
 	 * the write was not inflight (but exclude failed writes, they should be skipped not stopped).
diff --git a/verify.h b/verify.h
index e361337c..9628d6c6 100644
--- a/verify.h
+++ b/verify.h
@@ -32,6 +32,12 @@ enum {
 	VERIFY_NULL,			/* pretend to verify */
 };
 
+/* Values for the verify_policy option (bitmask) */
+enum {
+	VERIFY_POLICY_COMPLETED = 0,		/* verify all completed writes */
+	VERIFY_POLICY_FSYNCED   = 1 << 0,	/* only verify writes covered by the last fsync */
+};
+
 /*
  * Set the high bit to distinguish versioned headers from older
  * non-versioned headers.
