Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7C335838B
	for <fio@vger.kernel.org>; Sat, 18 Apr 2026 12:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776513613; cv=none; b=g6iLQ7JohMDF1kVKvS8ujM/AB4u0HrMnz6mNpHunHlHefIsxpDgBGFktvrKWDR3FinOJ6biDWGLesSTkop192treY701AMDr4JZsYhLki0nDxNuHxe21whUJN2ULcDXQDtzsVl7JpEt7Rpvnnxs17YnkPCBmjBe1TrimlViXS3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776513613; c=relaxed/simple;
	bh=MuAB5vwSxEPvNd+tlkzt44B6aMQ6+tp7sbPxB3ERpHo=;
	h=Subject:From:To:Date:Message-Id; b=u8ie4MoIv6grAFS9TjoEa6PbidFCBqYxSJ8OLB/14Sr6peBm75E2ts72usNmyZmJR75u2o4uDVbx9s/boQsD8K8P2upbdsuvlRjdE7e2uAFWgdI709cRXK/d9SLEIA/EuPewmfH/QO+DVrMN2SGaVVqtGGwEGyzAKwcO/QDuPaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=S3Qm7hQZ; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="S3Qm7hQZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=j3r/A7IofToAUVOmnP4ufIvqPsSghEDORwhmihlu+9A=; b=S3Qm7hQZDmwFe5lRrl7iw8Cbsg
	Z11+0mpRDStSOO4NuzTX11DmRFbc2ZEquEi1dO5LZu2B24G3gkvcy/TK9GIrQ+6ZrfucEg+xEqNtn
	qxYn/6P2TSse+noITn/jcV7OPEgDXj1uDwogGAjqoVtu5pB/QEbyUEGyPfv4EjMNfc1lfFPnNQDQg
	csf35HYJxsRca2ypbQAvSGcNSo9eAIDGUoKwZ/DHuHKz9E2NxFjQ62LjvKYuevE27rAZB9lQ7upqO
	QhR0h5r98FWhoC268w9Ebovom8wxRO0mVVt82STeguvaruMhqkoeY4ruEU0ZcGBB+7WXwWsA78jGW
	Cu7Y9O2A==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wE4LG-00000006JOR-1ba9
	for fio@vger.kernel.org;
	Sat, 18 Apr 2026 12:00:07 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 1B7371BC017C; Sat, 18 Apr 2026 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Sat, 18 Apr 2026 06:00:02 -0600
Message-Id: <20260418120002.1B7371BC017C@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 219f1c3503c1961f41173456d399f41b72d08ef3:

  Merge branch 'arm-select-eintr' of https://github.com/alex310110/fio (2026-04-16 10:56:35 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d91ab4439af20b13dbbe55021f6c29de5b6eddeb:

  Merge branch 'check-numberio-read-only' of https://github.com/minwooim/fio (2026-04-16 22:31:44 -0400)

----------------------------------------------------------------
Minwoo Im (6):
      fio.h: treat io_size > size as offset overlap risk
      Revert "backend: fix verify issue during readwrite"
      backend: update `total_bytes` for TD_DDIR_WRITE
      io_u: check wrap around `f->last_pos` for overlapped case
      libfio: reset nr_done_files when io_size > size
      t/numberio_overlap: add overlap write verification tests

Vincent Fu (1):
      Merge branch 'check-numberio-read-only' of https://github.com/minwooim/fio

 backend.c               |   7 +-
 ci/actions-full-test.sh |   5 +
 fio.h                   |   3 +-
 io_u.c                  |   5 +-
 libfio.c                |   3 +-
 t/numberio_overlap.py   | 842 ++++++++++++++++++++++++++++++++++++++++++++++++
 t/run-fio-tests.py      |   8 +
 7 files changed, 865 insertions(+), 8 deletions(-)
 create mode 100755 t/numberio_overlap.py

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 230d7fd0..cad43ace 100644
--- a/backend.c
+++ b/backend.c
@@ -1104,11 +1104,8 @@ static void do_io(struct thread_data *td, uint64_t *bytes_done)
 	if (td_write(td) && td_random(td) && td->o.norandommap)
 		total_bytes = max(total_bytes, (uint64_t) td->o.io_size);
 
-	/*
-	 * Don't break too early if io_size > size. The exception is when
-	 * verify is enabled.
-	 */
-	if (td_rw(td) && !td_random(td) && td->o.verify == VERIFY_NONE)
+	/* Don't break too early if io_size > size */
+	if (td_write(td) && !td_random(td))
 		total_bytes = max(total_bytes, (uint64_t)td->o.io_size);
 
 	/*
diff --git a/ci/actions-full-test.sh b/ci/actions-full-test.sh
index 5d6d1ca3..14c2fcf7 100755
--- a/ci/actions-full-test.sh
+++ b/ci/actions-full-test.sh
@@ -32,6 +32,11 @@ main() {
 	    -p
             "1010:--skip 15 16 17 18 19 20 21 22"
         )
+	# io_uring is unavailable in containers; use psync and libaio instead
+	args+=(
+	    -p
+	    "1021:--ioengines psync,libaio"
+	)
 
     fi
 
diff --git a/fio.h b/fio.h
index 8708f048..7793d35c 100644
--- a/fio.h
+++ b/fio.h
@@ -827,7 +827,8 @@ extern void clear_inflight(struct thread_data *);
 static inline bool fio_offset_overlap_risk(struct thread_data *td)
 {
 	if (td->o.norandommap || td->o.softrandommap ||
-	    td->o.ddir_seq_add || (td->o.ddir_seq_nr > 1))
+	    td->o.ddir_seq_add || (td->o.ddir_seq_nr > 1) ||
+	    td->o.io_size > td->o.size)
 		return true;
 
 	return false;
diff --git a/io_u.c b/io_u.c
index 756aa090..24d8b7de 100644
--- a/io_u.c
+++ b/io_u.c
@@ -382,8 +382,11 @@ static int get_next_seq_offset(struct thread_data *td, struct fio_file *f,
 	/*
 	 * If we reach the end for a rw-io-size based run, reset us back to 0
 	 * and invalidate the cache, if we need to.
+	 *
+	 * If it has possibility of overlapped offsets (io_size > size), we
+	 * should get back to 0 offset to verify overlapped offsets.
 	 */
-	if (td_rw(td) && o->io_size > o->size) {
+	if (td_write(td) && o->io_size > o->size) {
 		if (f->last_pos[ddir] >= f->io_size + get_start_offset(td, f)) {
 			f->last_pos[ddir] = f->file_offset;
 			loop_cache_invalidate(td, f);
diff --git a/libfio.c b/libfio.c
index 52afeafb..a57ede4f 100644
--- a/libfio.c
+++ b/libfio.c
@@ -106,7 +106,8 @@ static void reset_io_counters(struct thread_data *td, int all)
 	/*
 	 * reset file done count if we are to start over
 	 */
-	if (td->o.time_based || td->loops > 1 || td->o.do_verify)
+	if (td->o.time_based || td->loops > 1 || td->o.do_verify ||
+			(td->o.io_size > td->o.size))
 		td->nr_done_files = 0;
 }
 
diff --git a/t/numberio_overlap.py b/t/numberio_overlap.py
new file mode 100755
index 00000000..e8f1419c
--- /dev/null
+++ b/t/numberio_overlap.py
@@ -0,0 +1,842 @@
+#!/usr/bin/env python3
+"""
+# numberio_overlap.py
+#
+# Verification tests for sequential and random write overlap with numberio.
+#
+# When io_size > size, writes wrap around and revisit every offset a second
+# time.  fio_offset_overlap_risk() must return true so that io_hist uses an
+# rb-tree and retains only the latest io_piece per offset.
+#
+# Each TC is run twice: once with the async engine and once with the sync
+# engine selected based on the platform (Linux: io_uring/psync,
+# Windows: windowsaio/sync, other: posixaio/psync).
+#
+# rw=write     offline  TC  1: basic 2× overlap
+#              online   TC  2: do_verify=1
+#
+# rw=randwrite offline  TC  3: norandommap
+#              online   TC  4: norandommap
+#
+# rw=rw        offline  TC  5
+#              online   TC  6
+#
+# rw=randrw    offline  TC  7: norandommap
+#              online   TC  8: norandommap
+#
+# filesize<size offline  TC  9: rb-tree triggered before first I/O
+#
+# nrfiles=2    offline  TC 10: write, 2× overlap across 2 files
+#              online   TC 11: write, do_verify=1 across 2 files
+#              offline  TC 12: randwrite, norandommap
+#              offline  TC 13: write, filesize < size/nrfiles
+#
+# USAGE
+# see python3 t/numberio_overlap.py --help
+#
+# EXAMPLES
+# python3 t/numberio_overlap.py --file /tmp/fio-overlap-test.dat
+# python3 t/numberio_overlap.py --file /tmp/fio-overlap-test.dat -f ./fio
+#
+# REQUIREMENTS
+# Python 3.6
+#
+"""
+import copy
+import os
+import platform
+import sys
+import json
+import time
+import locale
+import logging
+import argparse
+import subprocess
+from pathlib import Path
+from fiotestlib import FioJobCmdTest, run_fio_tests
+from fiotestcommon import SUCCESS_DEFAULT, Requirements
+
+
+class OfflineOverlapVerifyTest(FioJobCmdTest):
+    """
+    Two-phase offline overlap verification test.
+
+    Phase 1 — write:
+        rw=write, io_size = N * size  (N >= 2).
+        Every offset is written N times; the N-th pass has the highest numberio.
+        fio_offset_overlap_risk() must return true so that the rb-tree backend
+        is used and only the latest io_piece per offset is kept.
+
+    Phase 2 — verify:
+        verify_only=1, verify_state_load=1.
+        A dry-run write pass detects overlaps ("iolog: overlap") and advances
+        f->last_pos to wrap back to 0.  The subsequent READ phase issues exactly
+        (size / bs) reads — one per block — checking the latest numberio only.
+
+    Key assertions
+        - Write phase exits 0 and produces io_size bytes written.
+        - Verify phase exits 0 and reports 0 verify_errors.
+        - Verify phase reads exactly size bytes — not io_size bytes — confirming
+          that only the latest numberio is verified once per block.
+    """
+
+    def __init__(self, fio_path, success, testnum, artifact_root, fio_opts,
+                 basename=None):
+        super().__init__(fio_path, success, testnum, artifact_root, fio_opts,
+                         basename)
+        stub = os.path.join(self.paths['test_dir'],
+                            f"{self.basename}{self.testnum:03d}")
+        # write-phase output file (verify phase reuses self.filenames['output'])
+        self.filenames['output_write'] = os.path.abspath(f"{stub}.write.output")
+
+    def setup(self, parameters):
+        """Create test directory; args are built dynamically in run()."""
+        if not os.path.exists(self.paths['test_dir']):
+            os.mkdir(self.paths['test_dir'])
+        self.parameters = []    # satisfy FioExeTest.run() if it ever gets called
+
+    def _filename_str(self):
+        """Return the fio --filename value: colon-joined list for nrfiles > 1."""
+        base = self.fio_opts['filename']
+        nrfiles = self.fio_opts.get('nrfiles', 1)
+        if nrfiles > 1:
+            return ':'.join(f"{base}.{i}" for i in range(nrfiles))
+        return base
+
+    def _fio_args(self, phase):
+        """Return fio CLI args for *phase* ('write' or 'verify')."""
+
+        ioengine = self.fio_opts.get('ioengine', 'io_uring')
+
+        fallocate = "--fallocate=truncate"
+
+        common = [
+            "--name=overlap-verify",
+            f"--ioengine={ioengine}",
+            fallocate,
+        ]
+
+        rw = self.fio_opts.get('rw', 'write')
+
+        common += [
+            f"--filename={self._filename_str()}",
+            f"--bs={self.fio_opts['bs']}",
+            f"--size={self.fio_opts['size']}",
+            f"--io_size={self.fio_opts['io_size']}",
+            f"--verify={self.fio_opts['verify']}",
+            "--output-format=json",
+        ]
+
+        if self.fio_opts.get('norandommap'):
+            common.append("--norandommap=1")
+
+        if phase == 'write':
+            return common + [
+                f"--rw={rw}",
+                "--do_verify=0",
+                f"--output={self.filenames['output_write']}",
+            ]
+        else:
+            # Verify phase replays the same rw mode as the write phase so that
+            # do_dry_run produces an identical offset→numberio mapping.
+            # - randwrite/randrw with norandommap=1: no axmap limit so
+            #   do_dry_run runs to io_size.  Both phases use the same RNG
+            #   sequence because randrepeat=1 is fio's default (options.c
+            #   ".def = 1"), giving identical offset→numberio in io_hist.
+            # - rw/randrw (sequential/random mixed): IOs advance position the
+            #   same way in write and verify phases; only writes go to io_hist.
+            verify_io_size = self.fio_opts.get('verify_io_size',
+                                               self.fio_opts['io_size'])
+            verify_args = [
+                "--name=overlap-verify",
+                f"--ioengine={ioengine}",
+                fallocate,
+                f"--filename={self._filename_str()}",
+                f"--rw={rw}",
+                f"--bs={self.fio_opts['bs']}",
+                f"--size={self.fio_opts['size']}",
+                f"--io_size={verify_io_size}",
+                f"--verify={self.fio_opts['verify']}",
+                "--output-format=json",
+                "--do_verify=1",
+                "--verify_only=1",
+                "--verify_write_sequence=1",
+                f"--output={self.filenames['output']}",
+            ]
+            if self.fio_opts.get('norandommap'):
+                verify_args.append("--norandommap=1")
+            return verify_args
+
+    def _run_one(self, args, stdout_f, stderr_f, ec_f):
+        """Spawn fio with *args* in test_dir; return the Popen object."""
+        command = [self.paths['exe']] + args
+        with open(self.filenames['cmd'], "a",
+                  encoding=locale.getpreferredencoding()) as cmd_f:
+            cmd_f.write(" \\\n ".join(command) + "\n\n")
+        proc = subprocess.Popen(command,
+                                stdout=stdout_f,
+                                stderr=stderr_f,
+                                cwd=self.paths['test_dir'],
+                                universal_newlines=True)
+        proc.communicate(timeout=self.success['timeout'])
+        ec_f.write(f"{proc.returncode}\n")
+        logging.debug("Test %d phase %s: exit %d",
+                      self.testnum, args[-1], proc.returncode)
+        return proc
+
+    def run(self):
+        """Run write phase then verify phase sequentially."""
+
+        # If filesize is specified, pre-create each file at that size so that
+        # real_file_size < size/nrfiles, which is the scenario under test.
+        if 'filesize' in self.fio_opts:
+            base = self.fio_opts['filename']
+            nrfiles = self.fio_opts.get('nrfiles', 1)
+            fnames = [f"{base}.{i}" for i in range(nrfiles)] if nrfiles > 1 \
+                else [base]
+            for fname in fnames:
+                with open(fname, 'wb'):
+                    pass
+                os.truncate(fname, self.fio_opts['filesize'])
+
+        try:
+            with open(self.filenames['stdout'], "w",
+                      encoding=locale.getpreferredencoding()) as stdout_f, \
+                 open(self.filenames['stderr'], "w",
+                      encoding=locale.getpreferredencoding()) as stderr_f, \
+                 open(self.filenames['exitcode'], "w",
+                      encoding=locale.getpreferredencoding()) as ec_f:
+
+                proc_w = self._run_one(self._fio_args('write'),
+                                       stdout_f, stderr_f, ec_f)
+                if proc_w.returncode != 0:
+                    self.output['proc'] = proc_w
+                    self.output['failure'] = \
+                        f"write phase exited with {proc_w.returncode}"
+                    return
+
+                proc_v = self._run_one(self._fio_args('verify'),
+                                       stdout_f, stderr_f, ec_f)
+                self.output['proc'] = proc_v
+
+        except subprocess.TimeoutExpired:
+            self.output['failure'] = 'timeout'
+        except Exception:
+            self.output['failure'] = 'exception'
+            self.output['exc_info'] = sys.exc_info()
+
+    @staticmethod
+    def _load_json(path):
+        """Return parsed JSON from a fio output file, or None on error."""
+        try:
+            with open(path, "r", encoding=locale.getpreferredencoding()) as f:
+                raw = f.read()
+            lines = raw.splitlines()
+            last = len(lines) - lines[::-1].index("}")
+            return json.loads("\n".join(lines[lines.index("{"):last]))
+        except Exception as exc:
+            logging.debug("JSON parse error in %s: %s", path, exc)
+            return None
+
+    def check_result(self):
+        """Check both phases produced the expected byte counts."""
+
+        # basic exit-code / stderr checks via FioExeTest
+        if 'proc' not in self.output:
+            self.failure_reason = self.output.get('failure', 'did not run')
+            self.passed = False
+            return
+
+        if 'failure' in self.output:
+            self.failure_reason = self.output['failure']
+            self.passed = False
+            # still fall through to check JSON if proc is set
+
+        if self.output['proc'].returncode != 0:
+            self.failure_reason += (
+                f" verify phase exited with {self.output['proc'].returncode}")
+            self.passed = False
+
+        # --- write phase: must have issued io_size bytes total ---
+        # For write-only modes (write, randwrite): all bytes are writes.
+        # For mixed modes (rw, randrw): writes + reads together equal io_size.
+        jw = self._load_json(self.filenames['output_write'])
+        if not jw:
+            self.failure_reason += " cannot parse write-phase JSON"
+            self.passed = False
+        else:
+            job_w = jw['jobs'][0]
+            written = job_w['write']['io_bytes']
+            rw = self.fio_opts.get('rw', 'write')
+            if rw in ('rw', 'readwrite', 'randrw'):
+                total_issued = written + job_w['read']['io_bytes']
+                if total_issued != self.fio_opts['io_size']:
+                    self.failure_reason += (
+                        f" write phase: issued {total_issued} bytes "
+                        f"(write={written} read={job_w['read']['io_bytes']}), "
+                        f"expected {self.fio_opts['io_size']} total")
+                    self.passed = False
+                    logging.debug("write job: %s",
+                                  json.dumps(job_w, indent=2))
+            else:
+                if written != self.fio_opts['io_size']:
+                    self.failure_reason += (
+                        f" write phase: wrote {written} bytes, "
+                        f"expected {self.fio_opts['io_size']}")
+                    self.passed = False
+                    logging.debug("write job: %s",
+                                  json.dumps(job_w, indent=2))
+
+        # --- verify phase: no errors, reads exactly size bytes ---
+        jv = self._load_json(self.filenames['output'])
+        if not jv:
+            self.failure_reason += " cannot parse verify-phase JSON"
+            self.passed = False
+        else:
+            job = jv['jobs'][0]
+            read_data = job.get('read', {})
+
+            verify_errors = read_data.get('verify_errors', 0)
+            if verify_errors != 0:
+                self.failure_reason += (
+                    f" verify phase: {verify_errors} verify error(s)")
+                self.passed = False
+
+            # For sequential write-only modes (write) every block is written
+            # exactly once per pass, so verify reads exactly size bytes.
+            # Skip the assertion for:
+            #   - mixed modes (rw, randrw): only written blocks are in io_hist
+            #   - norandommap: random sampling may leave some blocks unvisited
+            rw_mode = self.fio_opts.get('rw', 'write')
+            if rw_mode not in ('rw', 'readwrite', 'randrw') \
+                    and not self.fio_opts.get('norandommap'):
+                expected_read = self.fio_opts['size']
+                read_bytes = read_data.get('io_bytes', 0)
+                if read_bytes != expected_read:
+                    self.failure_reason += (
+                        f" verify phase: read {read_bytes} bytes, "
+                        f"expected {expected_read} "
+                        f"(one pass — latest numberio only)")
+                    self.passed = False
+                    logging.debug("verify job: %s", json.dumps(job, indent=2))
+
+
+class OnlineOverlapVerifyTest(FioJobCmdTest):
+    """
+    Single-phase online overlap verification test (--do_verify=1).
+
+    fio writes and verifies in the same job.  With io_size > size the write
+    phase makes multiple passes over the file (or revisits offsets with
+    norandommap); the verify (read) phase runs after all writes, checking
+    only the latest numberio per block.
+
+    This exercises:
+      - fio_offset_overlap_risk() enabling the rb-tree io_hist when
+        io_size > size, for all rw modes (write, randwrite, rw, randrw).
+      - backend.c: total_bytes for sequential write-only jobs is now bounded
+        by io_size (not size), so the second write pass actually happens.
+      - io_u.c: last_pos wrap-around is now triggered by do_verify=1 (not
+        only verify_only=1), so the verify READ phase starts from offset 0.
+
+    Key assertions
+        rw=write / rw=randwrite (TC 9-10, 17-18):
+            write == io_size  (all overlap passes completed)
+            read  == size     (one verify pass — latest numberio only)
+            verify_errors == 0
+        rw=rw / rw=randrw (TC 19-22):
+            verify_errors == 0 only — write and read byte counts are skipped
+            because mixed I/O means write.io_bytes < io_size (50 % writes)
+            and read.io_bytes includes both the rw= read IOs and the verify
+            reads, making an exact assertion impractical.
+    """
+
+    def setup(self, parameters):
+        """Create test directory; args are built dynamically in run()."""
+        if not os.path.exists(self.paths['test_dir']):
+            os.mkdir(self.paths['test_dir'])
+        self.parameters = []
+
+    def _filename_str(self):
+        """Return the fio --filename value: colon-joined list for nrfiles > 1."""
+        base = self.fio_opts['filename']
+        nrfiles = self.fio_opts.get('nrfiles', 1)
+        if nrfiles > 1:
+            return ':'.join(f"{base}.{i}" for i in range(nrfiles))
+        return base
+
+    def _fio_args(self):
+        ioengine = self.fio_opts.get('ioengine', 'io_uring')
+        rw = self.fio_opts.get('rw', 'write')
+        args = [
+            "--name=online-overlap-verify",
+            f"--ioengine={ioengine}",
+            "--fallocate=truncate",
+            f"--filename={self._filename_str()}",
+            f"--rw={rw}",
+            f"--bs={self.fio_opts['bs']}",
+            f"--size={self.fio_opts['size']}",
+            f"--io_size={self.fio_opts['io_size']}",
+            f"--verify={self.fio_opts['verify']}",
+            "--do_verify=1",
+            "--verify_write_sequence=1",
+            "--output-format=json",
+            f"--output={self.filenames['output']}",
+        ]
+        if self.fio_opts.get('norandommap'):
+            args.append("--norandommap=1")
+        return args
+
+    def _run_one(self, args, stdout_f, stderr_f, ec_f):
+        command = [self.paths['exe']] + args
+        with open(self.filenames['cmd'], "w",
+                  encoding=locale.getpreferredencoding()) as cmd_f:
+            cmd_f.write(" \\\n ".join(command) + "\n")
+        proc = subprocess.Popen(command,
+                                stdout=stdout_f,
+                                stderr=stderr_f,
+                                cwd=self.paths['test_dir'],
+                                universal_newlines=True)
+        proc.communicate(timeout=self.success['timeout'])
+        ec_f.write(f"{proc.returncode}\n")
+        logging.debug("Test %d online: exit %d", self.testnum, proc.returncode)
+        return proc
+
+    def run(self):
+        try:
+            with open(self.filenames['stdout'], "w",
+                      encoding=locale.getpreferredencoding()) as stdout_f, \
+                 open(self.filenames['stderr'], "w",
+                      encoding=locale.getpreferredencoding()) as stderr_f, \
+                 open(self.filenames['exitcode'], "w",
+                      encoding=locale.getpreferredencoding()) as ec_f:
+                proc = self._run_one(self._fio_args(), stdout_f, stderr_f, ec_f)
+                self.output['proc'] = proc
+        except subprocess.TimeoutExpired:
+            self.output['failure'] = 'timeout'
+        except Exception:
+            self.output['failure'] = 'exception'
+            self.output['exc_info'] = sys.exc_info()
+
+    @staticmethod
+    def _load_json(path):
+        try:
+            with open(path, "r", encoding=locale.getpreferredencoding()) as f:
+                raw = f.read()
+            lines = raw.splitlines()
+            last = len(lines) - lines[::-1].index("}")
+            return json.loads("\n".join(lines[lines.index("{"):last]))
+        except Exception as exc:
+            logging.debug("JSON parse error in %s: %s", path, exc)
+            return None
+
+    def check_result(self):
+        if 'proc' not in self.output:
+            self.failure_reason = self.output.get('failure', 'did not run')
+            self.passed = False
+            return
+
+        if 'failure' in self.output:
+            self.failure_reason = self.output['failure']
+            self.passed = False
+
+        if self.output['proc'].returncode != 0:
+            self.failure_reason += (
+                f" job exited with {self.output['proc'].returncode}")
+            self.passed = False
+
+        jv = self._load_json(self.filenames['output'])
+        if not jv:
+            self.failure_reason += " cannot parse JSON"
+            self.passed = False
+            return
+
+        job = jv['jobs'][0]
+
+        verify_errors = job.get('read', {}).get('verify_errors', 0)
+        if verify_errors != 0:
+            self.failure_reason += f" {verify_errors} verify error(s)"
+            self.passed = False
+
+        rw_mode = self.fio_opts.get('rw', 'write')
+        is_mixed = rw_mode in ('rw', 'readwrite', 'randrw')
+        has_norandommap = self.fio_opts.get('norandommap', False)
+
+        # For mixed modes (rw, randrw): write.io_bytes < io_size (50 % writes)
+        # and read.io_bytes merges write-phase reads with verify reads.
+        # For write-only modes: assert written == io_size.
+        if not is_mixed:
+            written = job.get('write', {}).get('io_bytes', 0)
+            if written != self.fio_opts['io_size']:
+                self.failure_reason += (
+                    f" wrote {written} bytes, expected {self.fio_opts['io_size']}"
+                    f" (both overlap passes must complete)")
+                self.passed = False
+                logging.debug("job: %s", json.dumps(job, indent=2))
+
+        # For norandommap: random sampling may not cover all blocks, so
+        # read_bytes may be less than size.  Skip the assertion in that case.
+        if not is_mixed and not has_norandommap:
+            read_bytes = job.get('read', {}).get('io_bytes', 0)
+            if read_bytes != self.fio_opts['size']:
+                self.failure_reason += (
+                    f" verify read {read_bytes} bytes, expected {self.fio_opts['size']}"
+                    f" (one pass — latest numberio only)")
+                self.passed = False
+                logging.debug("job: %s", json.dumps(job, indent=2))
+
+
+TEST_LIST = [
+    # ══════════════════════════════════════════════════════════════════
+    # rw=write  (TC 1-2)
+    # ══════════════════════════════════════════════════════════════════
+
+    # write, offline (TC 1): basic 2× overlap (io_size = 2 × size)
+    # 8 blocks written twice; verify reads each once.
+    {
+        "test_id": 1,
+        "fio_opts": {
+            "filename": None,            # filled in from --file at runtime
+            "bs": "128k",
+            "size":    1 * 1024 * 1024,  # 1 MiB
+            "io_size": 2 * 1024 * 1024,  # 2 MiB  →  2× overlap
+            "verify": "crc32c",
+        },
+        "test_class": OfflineOverlapVerifyTest,
+        "success": SUCCESS_DEFAULT,
+    },
+
+    # write, online (TC 2): do_verify=1, 2× overlap.
+    # Exercises the backend.c fix (total_bytes bounded by io_size for
+    # sequential write-only jobs) and the io_u.c fix (last_pos wrap
+    # triggered by do_verify=1, not only verify_only=1).
+    {
+        "test_id": 2,
+        "fio_opts": {
+            "filename": None,
+            "bs": "128k",
+            "size":    1 * 1024 * 1024,
+            "io_size": 2 * 1024 * 1024,
+            "verify": "crc32c",
+        },
+        "test_class": OnlineOverlapVerifyTest,
+        "success": SUCCESS_DEFAULT,
+    },
+
+    # ══════════════════════════════════════════════════════════════════
+    # rw=randwrite  (TC 3-4)
+    # norandommap=1 allows the RNG to revisit the same offsets (genuine
+    # write overlap) and avoids the axmap-full problem in do_dry_run.
+    # Both offline and online phases use fio's default randrepeat=1, so
+    # write and verify dry-run see the same random offset sequence.
+    # ══════════════════════════════════════════════════════════════════
+
+    # randwrite, offline (TC 3): norandommap, offline verify.
+    {
+        "test_id": 3,
+        "fio_opts": {
+            "filename": None,
+            "rw": "randwrite",
+            "bs": "128k",
+            "size":       1 * 1024 * 1024,
+            "io_size":    2 * 1024 * 1024,
+            "norandommap": True,
+            "verify": "crc32c",
+        },
+        "test_class": OfflineOverlapVerifyTest,
+        "success": SUCCESS_DEFAULT,
+    },
+
+    # randwrite, online (TC 4): norandommap, online verify.
+    # total_bytes=io_size so the full 2M is written in one do_io() call;
+    # random offsets may be revisited (genuine overlap).
+    # verify_errors==0 and written==io_size are asserted; read_bytes is
+    # skipped because random sampling may not cover every block.
+    {
+        "test_id": 4,
+        "fio_opts": {
+            "filename": None,
+            "rw": "randwrite",
+            "bs": "128k",
+            "size":       1 * 1024 * 1024,
+            "io_size":    2 * 1024 * 1024,
+            "norandommap": True,
+            "verify": "crc32c",
+        },
+        "test_class": OnlineOverlapVerifyTest,
+        "success": SUCCESS_DEFAULT,
+    },
+
+    # ══════════════════════════════════════════════════════════════════
+    # rw=rw (sequential mixed read/write)  (TC 5-6)
+    # io_size=4×size; with 50/50 rwmix the write fraction gives overlap.
+    # total_bytes=size per outer iteration → 4 iters → write overlap.
+    # Only verify_errors==0 is asserted; byte-count assertions skipped
+    # because write.io_bytes < io_size and read.io_bytes merges phases.
+    # ══════════════════════════════════════════════════════════════════
+
+    # rw=rw, offline (TC 5): both phases use rw=rw so the dry-run produces
+    # the same offset→numberio mapping (writes at even-numbered offsets only).
+    {
+        "test_id": 5,
+        "fio_opts": {
+            "filename": None,
+            "rw": "rw",
+            "bs": "128k",
+            "size":    1 * 1024 * 1024,
+            "io_size": 4 * 1024 * 1024,
+            "verify": "crc32c",
+        },
+        "test_class": OfflineOverlapVerifyTest,
+        "success": SUCCESS_DEFAULT,
+    },
+
+    # rw=rw, online (TC 6).
+    {
+        "test_id": 6,
+        "fio_opts": {
+            "filename": None,
+            "rw": "rw",
+            "bs": "128k",
+            "size":    1 * 1024 * 1024,
+            "io_size": 4 * 1024 * 1024,
+            "verify": "crc32c",
+        },
+        "test_class": OnlineOverlapVerifyTest,
+        "success": SUCCESS_DEFAULT,
+    },
+
+    # ══════════════════════════════════════════════════════════════════
+    # rw=randrw (random mixed read/write)  (TC 7-8)
+    # norandommap=1 allows offsets to be revisited (genuine overlap) and
+    # avoids the axmap-full problem in do_dry_run (offline) / do_io (online).
+    # fio's default randrepeat=1 ensures both phases replay the same mixed
+    # I/O sequence so the dry-run io_hist matches the write phase.
+    # ══════════════════════════════════════════════════════════════════
+
+    # randrw, offline (TC 7): norandommap, offline verify.
+    {
+        "test_id": 7,
+        "fio_opts": {
+            "filename": None,
+            "rw": "randrw",
+            "bs": "128k",
+            "size":       1 * 1024 * 1024,
+            "io_size":    4 * 1024 * 1024,
+            "norandommap": True,
+            "verify": "crc32c",
+        },
+        "test_class": OfflineOverlapVerifyTest,
+        "success": SUCCESS_DEFAULT,
+    },
+
+    # randrw, online (TC 8): norandommap, online verify.
+    # Only verify_errors==0 is asserted.
+    {
+        "test_id": 8,
+        "fio_opts": {
+            "filename": None,
+            "rw": "randrw",
+            "bs": "128k",
+            "size":       1 * 1024 * 1024,
+            "io_size":    4 * 1024 * 1024,
+            "norandommap": True,
+            "verify": "crc32c",
+        },
+        "test_class": OnlineOverlapVerifyTest,
+        "success": SUCCESS_DEFAULT,
+    },
+
+    # ══════════════════════════════════════════════════════════════════
+    # filesize < size  (TC 9)
+    # Real file size smaller than size=: fio_offset_overlap_risk() returns
+    # true (io_size > real_file_size) so the rb-tree is used even before
+    # the first write.  Covers the case where the rb-tree is initialised
+    # at setup time rather than at the first overlap.
+    # ══════════════════════════════════════════════════════════════════
+
+    # write, offline, filesize < size (TC 9):
+    # filesize=512k < size=1M, io_size=2M → 2× overlap over 1M.
+    {
+        "test_id": 9,
+        "fio_opts": {
+            "filename": None,
+            "bs": "128k",
+            "filesize": 512 * 1024,      # initial file size (< size)
+            "size":    1 * 1024 * 1024,  # 1 MiB  >  filesize
+            "io_size": 2 * 1024 * 1024,  # 2 MiB  →  io_size > size → rb-tree
+            "verify": "crc32c",
+        },
+        "test_class": OfflineOverlapVerifyTest,
+        "success": SUCCESS_DEFAULT,
+    },
+
+    # ══════════════════════════════════════════════════════════════════
+    # Multiple files (nrfiles=2)  (TC 10-13)
+    #
+    # With nrfiles=2 fio distributes I/O across two files.  Each file
+    # receives size/2 bytes of address space and io_size/2 of I/O,
+    # giving 2× overlap per file.  fio_offset_overlap_risk() fires at
+    # the job level (io_size > size), so the rb-tree is used for the
+    # shared io_hist.  nr_done_files is reset when io_size > size so
+    # that fio continues I/O after visiting every file once.
+    #
+    # Assertions are identical to the single-file cases:
+    #   write.io_bytes == io_size   (total across both files)
+    #   read.io_bytes  == size      (one verify pass per file, total)
+    # ══════════════════════════════════════════════════════════════════
+
+    # nrfiles=2, write, offline (TC 10): basic 2× overlap across 2 files.
+    {
+        "test_id": 10,
+        "fio_opts": {
+            "filename": None,
+            "nrfiles": 2,
+            "bs": "128k",
+            "size":    1 * 1024 * 1024,  # 1 MiB total (512k per file)
+            "io_size": 2 * 1024 * 1024,  # 2 MiB total → 2× overlap per file
+            "verify": "crc32c",
+        },
+        "test_class": OfflineOverlapVerifyTest,
+        "success": SUCCESS_DEFAULT,
+    },
+
+    # nrfiles=2, write, online (TC 11): do_verify=1 across 2 files.
+    {
+        "test_id": 11,
+        "fio_opts": {
+            "filename": None,
+            "nrfiles": 2,
+            "bs": "128k",
+            "size":    1 * 1024 * 1024,
+            "io_size": 2 * 1024 * 1024,
+            "verify": "crc32c",
+        },
+        "test_class": OnlineOverlapVerifyTest,
+        "success": SUCCESS_DEFAULT,
+    },
+
+    # nrfiles=2, randwrite, norandommap, offline (TC 12).
+    # Random writes distribute across both files via file_service_type;
+    # norandommap=1 allows offsets within each file to be revisited.
+    # read.io_bytes assertion is skipped (norandommap may not cover all blocks).
+    {
+        "test_id": 12,
+        "fio_opts": {
+            "filename": None,
+            "nrfiles": 2,
+            "rw": "randwrite",
+            "bs": "128k",
+            "size":       1 * 1024 * 1024,
+            "io_size":    2 * 1024 * 1024,
+            "norandommap": True,
+            "verify": "crc32c",
+        },
+        "test_class": OfflineOverlapVerifyTest,
+        "success": SUCCESS_DEFAULT,
+    },
+
+    # nrfiles=2, write, offline, filesize < size/nrfiles (TC 13).
+    # Each file is pre-created at 256k (< size/2 = 512k), so
+    # real_file_size < size/nrfiles at setup → rb-tree initialised before
+    # the first I/O (exercises the early-init path alongside TC 9).
+    {
+        "test_id": 13,
+        "fio_opts": {
+            "filename": None,
+            "nrfiles": 2,
+            "bs": "128k",
+            "filesize": 256 * 1024,      # pre-created size per file (< size/2)
+            "size":    1 * 1024 * 1024,  # 1 MiB total → 512k per file > filesize
+            "io_size": 2 * 1024 * 1024,  # 2 MiB total → 2× overlap per file
+            "verify": "crc32c",
+        },
+        "test_class": OfflineOverlapVerifyTest,
+        "success": SUCCESS_DEFAULT,
+    },
+]
+
+
+def parse_args():
+    parser = argparse.ArgumentParser(
+        description="Offline overlap verify test for fio numberio")
+    parser.add_argument('-f', '--fio',
+                        help='path to fio executable (default: ./fio)')
+    parser.add_argument('-a', '--artifact-root',
+                        help='root directory for test artifacts')
+    parser.add_argument('-d', '--debug', action='store_true',
+                        help='enable debug messages')
+    parser.add_argument('-s', '--skip', nargs='+', type=int,
+                        help='test IDs to skip')
+    parser.add_argument('-o', '--run-only', nargs='+', type=int,
+                        help='run only these test IDs')
+    parser.add_argument('-k', '--skip-req', action='store_true',
+                        help='skip requirements checking')
+    parser.add_argument('--file',
+                        default='fio-numberio-overlap-test.dat',
+                        help='file path for all TCs '
+                             '(default: fio-numberio-overlap-test.dat in cwd). '
+                             'WARNING: data will be overwritten',
+                        dest='file')
+    parser.add_argument('--ioengines',
+                        default=None,
+                        help='comma-separated list of ioengines to test '
+                             '(default: platform-specific async,sync pair, '
+                             'e.g. --ioengines psync,libaio)')
+    return parser.parse_args()
+
+
+def main():
+    args = parse_args()
+    logging.basicConfig(level=logging.DEBUG if args.debug else logging.INFO)
+
+    artifact_root = args.artifact_root or \
+        f"numberio-overlap-test-{time.strftime('%Y%m%d-%H%M%S')}"
+    os.mkdir(artifact_root)
+    print(f"Artifact directory: {artifact_root}")
+
+    fio_path = str(Path(args.fio).absolute()) if args.fio else \
+        os.path.join(os.path.dirname(__file__), '../fio')
+    print(f"fio path: {fio_path}")
+
+    fio_root = str(Path(__file__).absolute().parent.parent)
+
+    if not args.skip_req:
+        Requirements(fio_root, args)
+
+    for test in TEST_LIST:
+        test['fio_opts']['filename'] = args.file
+
+    if args.ioengines:
+        engines = [e.strip() for e in args.ioengines.split(',')]
+    elif platform.system() == 'Linux':
+        engines = ['io_uring', 'psync']
+    elif platform.system() == 'Windows':
+        engines = ['windowsaio', 'sync']
+    else:
+        engines = ['posixaio', 'psync']
+
+    total_failed = 0
+    for engine in engines:
+        engine_tests = copy.deepcopy(TEST_LIST)
+        for test in engine_tests:
+            test['fio_opts']['ioengine'] = engine
+
+        engine_artifact = os.path.join(artifact_root, engine)
+        os.mkdir(engine_artifact)
+
+        test_env = {
+            'fio_path':      fio_path,
+            'fio_root':      fio_root,
+            'artifact_root': engine_artifact,
+            'basename':      'numberio-overlap',
+        }
+
+        print(f"\nRunning with ioengine={engine}")
+        _, failed, _ = run_fio_tests(engine_tests, test_env, args)
+        total_failed += failed
+
+    sys.exit(total_failed)
+
+
+if __name__ == '__main__':
+    main()
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index b3321312..c3545dd6 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -1139,6 +1139,14 @@ TEST_LIST = [
         'success':          SUCCESS_DEFAULT,
         'requirements':     [Requirements.not_windows],
     },
+    {
+        'test_id':          1021,
+        'test_class':       FioExeTest,
+        'exe':              't/numberio_overlap.py',
+        'parameters':       ['-f', '{fio_path}'],
+        'success':          SUCCESS_DEFAULT,
+        'requirements':     [],
+    },
 ]
 
 
