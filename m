Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5BF269801
	for <fio@vger.kernel.org>; Tue,  8 Apr 2025 12:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113616; cv=none; b=dHaFaKoaEOzZHzMOAXxP85AsiYEfv6EirRTYFvP/ZE1RLtJWDqZH+T+/PFkuhR8JD74aCX3OVaUcqfgkMOt3a3TpUQyFiwVRYDeZ3jg2TYsuwWOlQBSqUD0DOkgRxIl+NcOv2q/b/MaFwD5tusBup1Rq9dt9p2IeBnNWq77kUko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113616; c=relaxed/simple;
	bh=4nhREGC2HV6C5PnGcww9Up4+aHZfLHaquIhSQ0fAAdA=;
	h=Subject:From:To:Message-Id:Date; b=NQO5GfS0cIrZDezMyhD9fDN1mPPb5MM5qDVn1qydf3CvSQtjrCIT2l6yuS3XvM6BQFF+J9sxphKNB+xaXEjS6wgABGNjClPLRwTgxZ+QSAHd+IZkkcBtT7JiSgl2nybf084nma/YXXe5armwbYLKNfFVCR+sNrn/s/uCqNp2+P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PgHOCrmu; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PgHOCrmu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=O7X2nzU6kjAr7a5PJxf9xgOI9td63mI/DAZb1fhBdiQ=; b=PgHOCrmun7BQ3xThO6eNIx/8/m
	WCyKrkC3CMScXkWUBG1v6WQadZOH1MlpeAQM+Y9nGpkdF4IxX0ayX9niO17tCeOWtj8oDJk629sG6
	vL5wOQIusUSXxcZRYCwHAUwTd7z7B3ATgdnPj3bFm3d3tWKgRu8R2BCG5MAGGXWJijxLElXn2ZCVs
	n3+J/BkXksv3gHPCMsmOFYmgacS7z2QRCmqtFQGJErq2muDnCsIVp1p3nathne6veWdgZfx3lwDVy
	B3ctVBwakCidqHrPPapNBZ5cEiJimEkkEdKyIbWxOBlbHT/TSEiUJEUgJ7KWV39B39qiWcMqsPK52
	o7u/RnDA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98.1 #2 (Red Hat Linux))
	id 1u27cf-00000008HWq-0Bjw
	for fio@vger.kernel.org;
	Tue, 08 Apr 2025 12:00:09 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id E26C11BC0164; Tue,  8 Apr 2025 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250408120001.E26C11BC0164@kernel.dk>
Date: Tue,  8 Apr 2025 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit c283fe11bda9efde7f063e6fe693802724ddc8c0:

  ci: set kvm permissions for GHA QEMU jobs (2025-04-04 11:27:27 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f18c2fd5f3e8114b5bfbe04e5511421c24b25fe1:

  ci: add verify-trim.py test script (2025-04-07 10:54:38 -0400)

----------------------------------------------------------------
Vincent Fu (7):
      fio: allow trim operations for verify/trim workloads
      trim_verify: include a trim panel in the output
      init: error out when readonly is set for a trim/verify workload
      verify/trim: stop issuing trims if we run out
      verify/trim: make trim_backlog_batch work
      t/verify-trim.py: superficial test script for verify/trim
      ci: add verify-trim.py test script

 .github/workflows/qemu.yml |   4 +
 backend.c                  |   3 +-
 ci/actions-full-test.sh    |   2 +
 fio.h                      |  10 +-
 init.c                     |   9 +-
 io_u.c                     |  18 ++-
 t/run-fio-tests.py         |   8 ++
 t/verify-trim.py           | 309 +++++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 354 insertions(+), 9 deletions(-)
 create mode 100755 t/verify-trim.py

---

Diff of recent changes:

diff --git a/.github/workflows/qemu.yml b/.github/workflows/qemu.yml
index db71fbe8..16787018 100644
--- a/.github/workflows/qemu.yml
+++ b/.github/workflows/qemu.yml
@@ -49,6 +49,10 @@ jobs:
               -device nvme-ns,id=nvm-1,drive=nvm-1,bus=nvme0,nsid=1,logical_block_size=4096,physical_block_size=4096,fdp.ruhs=0-63
             test_cmd: "nvme fdp status /dev/ng0n1 && python3 t/nvmept_fdp.py --fio ./fio --dut /dev/ng0n1"
             extra_pkgs: "nvme-cli"
+          - config: verify-trim
+            device:
+            test_cmd: "python3 t/verify-trim.py"
+            extra_pkgs: sg3-utils
           - config: ZBD
             device:
             test_cmd: "./t/zbd/run-tests-against-nullb"
diff --git a/backend.c b/backend.c
index b75eea80..f2a4ad35 100644
--- a/backend.c
+++ b/backend.c
@@ -1994,7 +1994,8 @@ static void *thread_main(void *data)
 			update_runtime(td, elapsed_us, DDIR_READ);
 		if (td_write(td) && td->io_bytes[DDIR_WRITE])
 			update_runtime(td, elapsed_us, DDIR_WRITE);
-		if (td_trim(td) && td->io_bytes[DDIR_TRIM])
+		if (td->io_bytes[DDIR_TRIM] && (td_trim(td) ||
+			((td->flags & TD_F_TRIM_BACKLOG) && td_write(td))))
 			update_runtime(td, elapsed_us, DDIR_TRIM);
 		fio_gettime(&td->start, NULL);
 		fio_sem_up(stat_sem);
diff --git a/ci/actions-full-test.sh b/ci/actions-full-test.sh
index 854788c1..4222a21a 100755
--- a/ci/actions-full-test.sh
+++ b/ci/actions-full-test.sh
@@ -10,10 +10,12 @@ main() {
 
     echo "Running long running tests..."
     export PYTHONUNBUFFERED="TRUE"
+    # We can't load modules so skip 1018 which requires null_blk
     skip=(
         6
 	1007
 	1008
+	1018
     )
     args=(
         --debug
diff --git a/fio.h b/fio.h
index d6423258..00f0f09b 100644
--- a/fio.h
+++ b/fio.h
@@ -292,6 +292,7 @@ struct thread_data {
 
 	unsigned int verify_batch;
 	unsigned int trim_batch;
+	bool trim_verify;
 
 	struct thread_io_list *vstate;
 
@@ -618,7 +619,14 @@ extern bool eta_time_within_slack(unsigned int time);
 static inline void fio_ro_check(const struct thread_data *td, struct io_u *io_u)
 {
 	assert(!(io_u->ddir == DDIR_WRITE && !td_write(td)) &&
-	       !(io_u->ddir == DDIR_TRIM && !td_trim(td)));
+	       !(io_u->ddir == DDIR_TRIM && !(td_trim(td) || td->trim_verify)));
+
+	/*
+	 * The last line above allows trim operations during trim/verify
+	 * workloads. For these workloads we cannot simply set the trim bit for
+	 * the thread's ddir because then fio would assume that
+	 * ddir={trimewrite, randtrimwrite}.
+	 */
 }
 
 static inline bool multi_range_trim(struct thread_data *td, struct io_u *io_u)
diff --git a/init.c b/init.c
index 95f2179d..20f5462d 100644
--- a/init.c
+++ b/init.c
@@ -612,7 +612,14 @@ static int fixup_options(struct thread_data *td)
 	struct thread_options *o = &td->o;
 	int ret = 0;
 
-	if (read_only && (td_write(td) || td_trim(td))) {
+	/*
+	 * Denote whether we are verifying trims. Now we only have to check a
+	 * single variable instead of having to check all three options.
+	 */
+	td->trim_verify = o->verify && o->trim_backlog && o->trim_percentage;
+	dprint(FD_VERIFY, "td->trim_verify=%d\n", td->trim_verify);
+
+	if (read_only && (td_write(td) || td_trim(td) || td->trim_verify)) {
 		log_err("fio: trim and write operations are not allowed"
 			 " with the --readonly parameter.\n");
 		ret |= 1;
diff --git a/io_u.c b/io_u.c
index f7824717..17f5e853 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1749,20 +1749,26 @@ static bool check_get_trim(struct thread_data *td, struct io_u *io_u)
 {
 	if (!(td->flags & TD_F_TRIM_BACKLOG))
 		return false;
-	if (!td->trim_entries)
+	if (!td->trim_entries) {
+		td->trim_batch = 0;
 		return false;
+	}
 
 	if (td->trim_batch) {
 		td->trim_batch--;
 		if (get_next_trim(td, io_u))
 			return true;
+		else
+			td->trim_batch = 0;
 	} else if (!(td->io_hist_len % td->o.trim_backlog) &&
-		     td->last_ddir_completed != DDIR_READ) {
-		td->trim_batch = td->o.trim_batch;
-		if (!td->trim_batch)
-			td->trim_batch = td->o.trim_backlog;
-		if (get_next_trim(td, io_u))
+		     td->last_ddir_completed != DDIR_TRIM) {
+		if (get_next_trim(td, io_u)) {
+			td->trim_batch = td->o.trim_batch;
+			if (!td->trim_batch)
+				td->trim_batch = td->o.trim_backlog;
+			td->trim_batch--;
 			return true;
+		}
 	}
 
 	return false;
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index 7ceda067..b4863297 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -1115,6 +1115,14 @@ TEST_LIST = [
         'success':          SUCCESS_LONG,
         'requirements':     [],
     },
+    {
+        'test_id':          1018,
+        'test_class':       FioExeTest,
+        'exe':              't/verify-trim.py',
+        'parameters':       ['-f', '{fio_path}'],
+        'success':          SUCCESS_DEFAULT,
+        'requirements':     [Requirements.linux],
+    },
 ]
 
 
diff --git a/t/verify-trim.py b/t/verify-trim.py
new file mode 100755
index 00000000..cd98722a
--- /dev/null
+++ b/t/verify-trim.py
@@ -0,0 +1,309 @@
+#!/usr/bin/env python3
+"""
+# verify-trim.c.py
+#
+# Test fio's verify trim feature.
+#
+# USAGE
+# see python3 verify-trim.c.py --help
+#
+# EXAMPLES
+# python3 t/verify-trim.c.py
+# python3 t/verify-trim.c.py --fio ./fio
+#
+# REQUIREMENTS
+# Python 3.6
+# Linux
+#
+"""
+import os
+import sys
+import time
+import logging
+import argparse
+import subprocess
+from pathlib import Path
+from fiotestlib import FioJobCmdTest, run_fio_tests
+from fiotestcommon import SUCCESS_NONZERO, Requirements
+
+
+VERIFY_OPT_LIST = [
+    'direct',
+    'iodepth',
+    'filesize',
+    'bs',
+    'time_based',
+    'runtime',
+    'io_size',
+    'offset',
+    'number_ios',
+    'output-format',
+    'directory',
+    'norandommap',
+    'numjobs',
+    'nrfiles',
+    'openfiles',
+    'ioengine',
+    'trim_backlog_batch',
+    'trim_verify_zero',
+    'number_ios',
+]
+
+class VerifyTrimTest(FioJobCmdTest):
+    """
+    VerifyTrim test class.
+    """
+
+    def setup(self, parameters):
+        """Setup a test."""
+
+        fio_args = [
+            "--name=verifytrim",
+            "--verify=md5",
+            f"--filename={self.fio_opts['filename']}",
+            f"--rw={self.fio_opts['rw']}",
+            f"--trim_percentage={self.fio_opts['trim_percentage']}",
+            f"--trim_backlog={self.fio_opts['trim_backlog']}",
+            f"--output={self.filenames['output']}",
+        ]
+        for opt in VERIFY_OPT_LIST:
+            if opt in self.fio_opts:
+                option = f"--{opt}={self.fio_opts[opt]}"
+                fio_args.append(option)
+
+        super().setup(fio_args)
+
+    def check_result(self):
+        super().check_result()
+
+        if self.fio_opts.get('output-format') == 'json':
+            actual = self.json_data['jobs'][0]['trim']['total_ios']
+            expected = self.json_data['jobs'][0]['write']['total_ios'] * self.fio_opts['trim_percentage'] / 100
+            if abs(expected - actual) > 0.1*expected:
+                self.passed = False
+                self.failure_reason += f" large discrepancy between expected {expected} and {actual} actual trims,"
+            else:
+                logging.debug("expected %d trims ~match actual %d trims", expected, actual)
+
+        if not self.passed:
+            with open(self.filenames['stderr'], "r") as se:
+                contents = se.read()
+                logging.info("stderr: %s", contents)
+
+            with open(self.filenames['stdout'], "r") as so:
+                contents = so.read()
+                logging.info("stdout: %s", contents)
+
+            with open(self.filenames['output'], "r") as out:
+                contents = out.read()
+                logging.info("output: %s", contents)
+
+
+TEST_LIST = [
+    # These tests are superficial.
+    #
+    # TODO: add a test case for trim_verify_zero by inducing a failure; the way
+    # to do this would be to write non-zero data to a block after it was
+    # trimmed but before it was read back (how to do this?)
+    {
+        # make sure readonly option triggers error message when
+        # trim_{percentage,backlog} options make trim operations a possibility
+        "test_id": 1,
+        "fio_opts": {
+            "rw": "read",
+            "trim_percentage": 100,
+            "trim_backlog": 1,
+            "readonly": 1,
+            },
+        "test_class": VerifyTrimTest,
+        "success": SUCCESS_NONZERO,
+    },
+    {
+        # basic test seq write
+        # trim_backlog=1
+        # trim_percentage=100
+        "test_id": 100,
+        "fio_opts": {
+            "rw": "write",
+            "trim_percentage": 100,
+            "trim_backlog": 1,
+            "trim_verify_zero": 1,
+            "number_ios": 64,
+            "output-format": "json",
+            },
+        "test_class": VerifyTrimTest,
+    },
+    {
+        # basic test rand write
+        # trim_backlog=1
+        # trim_percentage=100
+        "test_id": 101,
+        "fio_opts": {
+            "rw": "randwrite",
+            "trim_percentage": 100,
+            "trim_backlog": 1,
+            "trim_verify_zero": 1,
+            "number_ios": 64,
+            "output-format": "json",
+            },
+        "test_class": VerifyTrimTest,
+    },
+    {
+        # basic test seq write
+        # trim_backlog=1
+        # trim_percentage=50
+        "test_id": 102,
+        "fio_opts": {
+            "rw": "write",
+            "trim_percentage": 50,
+            "trim_backlog": 1,
+            "trim_verify_zero": 1,
+            "number_ios": 64,
+            "output-format": "json",
+            },
+        "test_class": VerifyTrimTest,
+    },
+    {
+        # basic test rand write
+        # trim_backlog=1
+        # trim_percentage=50
+        "test_id": 103,
+        "fio_opts": {
+            "rw": "randwrite",
+            "trim_percentage": 50,
+            "trim_backlog": 1,
+            "trim_verify_zero": 1,
+            "number_ios": 64,
+            "output-format": "json",
+            },
+        "test_class": VerifyTrimTest,
+    },
+    {
+        # basic test seq write
+        # trim_backlog=16
+        # trim_percentage=50
+        "test_id": 104,
+        "fio_opts": {
+            "rw": "write",
+            "trim_percentage": 50,
+            "trim_backlog": 16,
+            "trim_verify_zero": 1,
+            "number_ios": 64,
+            "output-format": "json",
+            },
+        "test_class": VerifyTrimTest,
+    },
+    {
+        # basic test rand write
+        # trim_backlog=16
+        # trim_percentage=50
+        "test_id": 105,
+        "fio_opts": {
+            "rw": "randwrite",
+            "trim_percentage": 50,
+            "trim_backlog": 16,
+            "trim_verify_zero": 1,
+            "number_ios": 64,
+            "output-format": "json",
+            },
+        "test_class": VerifyTrimTest,
+    },
+
+]
+
+
+def parse_args():
+    """Parse command-line arguments."""
+
+    parser = argparse.ArgumentParser()
+    parser.add_argument('-r', '--fio-root', help='fio root path')
+    parser.add_argument('-d', '--debug', help='Enable debug messages', action='store_true')
+    parser.add_argument('-f', '--fio', help='path to file executable (e.g., ./fio)')
+    parser.add_argument('-a', '--artifact-root', help='artifact root directory')
+    parser.add_argument('-s', '--skip', nargs='+', type=int,
+                        help='list of test(s) to skip')
+    parser.add_argument('-o', '--run-only', nargs='+', type=int,
+                        help='list of test(s) to run, skipping all others')
+    parser.add_argument('-k', '--skip-req', action='store_true',
+                        help='skip requirements checking')
+    parser.add_argument('--dut',
+                        help='Block device to test against (use null_blk if not provided')
+    args = parser.parse_args()
+
+    return args
+
+
+def main():
+    """
+    Run tests for fio's verify trim feature.
+    """
+
+    args = parse_args()
+
+    if args.debug:
+        logging.basicConfig(level=logging.DEBUG)
+    else:
+        logging.basicConfig(level=logging.INFO)
+
+    artifact_root = args.artifact_root if args.artifact_root else \
+        f"verify-trim-test-{time.strftime('%Y%m%d-%H%M%S')}"
+    os.mkdir(artifact_root)
+    print(f"Artifact directory is {artifact_root}")
+
+    if args.fio:
+        fio_path = str(Path(args.fio).absolute())
+    else:
+        fio_path = os.path.join(os.path.dirname(__file__), '../fio')
+    print(f"fio path is {fio_path}")
+
+    if args.fio_root:
+        fio_root = args.fio_root
+    else:
+        fio_root = str(Path(__file__).absolute().parent.parent)
+    print(f"fio root is {fio_root}")
+
+    if not args.skip_req:
+        Requirements(fio_root, args)
+
+    cleanup_nullb = False
+    if not args.dut:
+        subprocess.run(["sudo", "modprobe", "-r", "null_blk"],
+                       stdout=subprocess.PIPE,
+                       stderr=subprocess.PIPE)
+        subprocess.run(["sudo", "modprobe", "null_blk", "memory_backed=1", "discard=1"],
+                       stdout=subprocess.PIPE,
+                       stderr=subprocess.PIPE)
+        if os.path.exists('/dev/nullb0'):
+            args.dut = '/dev/nullb0'
+            cleanup_nullb = True
+        else:
+            print("No block device provided and could not create null_blk device for testing")
+            sys.exit(1)
+
+    for test in TEST_LIST:
+        test['fio_opts']['filename'] = args.dut
+
+    test_env = {
+              'fio_path': fio_path,
+              'fio_root': str(Path(__file__).absolute().parent.parent),
+              'artifact_root': artifact_root,
+              'basename': 'verifytrim',
+              }
+
+    total = { 'passed':  0, 'failed': 0, 'skipped': 0 }
+
+    try:
+        total['passed'], total['failed'], total['skipped'] = run_fio_tests(TEST_LIST, test_env, args)
+    except KeyboardInterrupt:
+        pass
+
+    if cleanup_nullb:
+        subprocess.run(["sudo", "modprobe", "-r", "null_blk"],
+                       stdout=subprocess.PIPE,
+                       stderr=subprocess.PIPE)
+
+    sys.exit(total['failed'])
+
+
+if __name__ == '__main__':
+    main()
