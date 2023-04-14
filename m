Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32BE9C77B72
	for <fio@archiver.kernel.org>; Fri, 14 Apr 2023 12:00:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjDNMAg (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 14 Apr 2023 08:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbjDNMAa (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 14 Apr 2023 08:00:30 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3887A27C
        for <fio@vger.kernel.org>; Fri, 14 Apr 2023 05:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=IPxvGB6+d/wTblWBlfpWhh+BurIgsVJoIJYCRfiI9fQ=; b=PsW54JHqQM+Q3LzUi8+NZpL6lL
        eY76RcZXQdWdHabh8Guo7VTbOR5YyHx9U5TFuFSUuZK3N089WAPo0wbhmk61d1NVwIc4/zKqx3ASx
        S/mjjGMKemkn/73gIwvByW2f99fKmeFYfG0vZS6Lfbf1fgz0Hb/8ZJPzTsm6M3wDb6M1jMHeQn+QS
        OgrL8ZGaRByLFTxSMRIoyZVVN2X8EhwcHBy5IrCRPbAGAQbWLPq3TY9cs1Cs+1kKL+0CAOLcnFiaR
        G7BeJBqu+SJp4QnWg+DykGzFEILxkK7JJk0fPO6LxVX7K3TPYyMGUBF9x8iEqpqsewechqN5mGIP6
        VB42NOhg==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pnI60-008j2v-SH
        for fio@vger.kernel.org; Fri, 14 Apr 2023 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 2C4831BC0172; Fri, 14 Apr 2023 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230414120002.2C4831BC0172@kernel.dk>
Date:   Fri, 14 Apr 2023 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 07ed2b57741afa53afa7b2b9fa742c652f1ed8c1:

  Merge branch 'libaio-hang' of https://github.com/lrumancik/fio (2023-04-10 15:40:45 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 7624d58953d38612c11496551a855a1aeee7ad24:

  docs: update documentation for randrepeat and allrandrepeat (2023-04-13 13:38:52 -0400)

----------------------------------------------------------------
Vincent Fu (7):
      rand: print out random seeds for debugging
      init: refactor random seed setting
      init: get rid of td_fill_rand_seeds_internal
      init: clean up random seed options
      t/random_seed: python script to test random seed options
      test: improve evaluation of t0020.fio and t0021.fio
      docs: update documentation for randrepeat and allrandrepeat

Xiaoguang Wang (1):
      t/io_uring: fix max_blocks calculation in nvme passthrough mode

 HOWTO.rst              |   7 +-
 cconv.c                |   2 -
 ci/actions-install.sh  |   3 +-
 ci/appveyor-install.sh |   2 +-
 fio.1                  |   7 +-
 fio.h                  |   1 -
 init.c                 |  91 ++++--------
 options.c              |  11 +-
 server.h               |   2 +-
 t/io_uring.c           |   2 +-
 t/random_seed.py       | 394 +++++++++++++++++++++++++++++++++++++++++++++++++
 t/run-fio-tests.py     |  26 ++--
 thread_options.h       |   3 -
 13 files changed, 454 insertions(+), 97 deletions(-)
 create mode 100755 t/random_seed.py

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index cb0f9834..0a6e60c7 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1232,13 +1232,12 @@ I/O type
 
 .. option:: randrepeat=bool
 
-	Seed the random number generator used for random I/O patterns in a
-	predictable way so the pattern is repeatable across runs. Default: true.
+        Seed all random number generators in a predictable way so the pattern
+        is repeatable across runs. Default: true.
 
 .. option:: allrandrepeat=bool
 
-	Seed all random number generators in a predictable way so results are
-	repeatable across runs.  Default: false.
+	Alias for :option:`randrepeat`. Default: true.
 
 .. option:: randseed=int
 
diff --git a/cconv.c b/cconv.c
index 1ae38b1b..9095d519 100644
--- a/cconv.c
+++ b/cconv.c
@@ -206,7 +206,6 @@ int convert_thread_options_to_cpu(struct thread_options *o,
 	o->do_disk_util = le32_to_cpu(top->do_disk_util);
 	o->override_sync = le32_to_cpu(top->override_sync);
 	o->rand_repeatable = le32_to_cpu(top->rand_repeatable);
-	o->allrand_repeatable = le32_to_cpu(top->allrand_repeatable);
 	o->rand_seed = le64_to_cpu(top->rand_seed);
 	o->log_entries = le32_to_cpu(top->log_entries);
 	o->log_avg_msec = le32_to_cpu(top->log_avg_msec);
@@ -446,7 +445,6 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->do_disk_util = cpu_to_le32(o->do_disk_util);
 	top->override_sync = cpu_to_le32(o->override_sync);
 	top->rand_repeatable = cpu_to_le32(o->rand_repeatable);
-	top->allrand_repeatable = cpu_to_le32(o->allrand_repeatable);
 	top->rand_seed = __cpu_to_le64(o->rand_seed);
 	top->log_entries = cpu_to_le32(o->log_entries);
 	top->log_avg_msec = cpu_to_le32(o->log_avg_msec);
diff --git a/ci/actions-install.sh b/ci/actions-install.sh
index 5057fca3..fb3bd141 100755
--- a/ci/actions-install.sh
+++ b/ci/actions-install.sh
@@ -62,6 +62,7 @@ DPKGCFG
     pkgs+=(
         python3-scipy
 	python3-sphinx
+	python3-statsmodels
     )
 
     echo "Updating APT..."
@@ -85,7 +86,7 @@ install_macos() {
     echo "Installing packages..."
     HOMEBREW_NO_AUTO_UPDATE=1 brew install cunit libnfs sphinx-doc
     brew link sphinx-doc --force
-    pip3 install scipy six 
+    pip3 install scipy six statsmodels
 }
 
 main() {
diff --git a/ci/appveyor-install.sh b/ci/appveyor-install.sh
index 3137f39e..1e28c454 100755
--- a/ci/appveyor-install.sh
+++ b/ci/appveyor-install.sh
@@ -37,7 +37,7 @@ case "${DISTRO}" in
         ;;
 esac
 
-python.exe -m pip install scipy six
+python.exe -m pip install scipy six statsmodels
 
 echo "Python3 path: $(type -p python3 2>&1)"
 echo "Python3 version: $(python3 -V 2>&1)"
diff --git a/fio.1 b/fio.1
index 311b16d8..4207814b 100644
--- a/fio.1
+++ b/fio.1
@@ -1022,12 +1022,11 @@ Alias for \fBboth\fR.
 .RE
 .TP
 .BI randrepeat \fR=\fPbool
-Seed the random number generator used for random I/O patterns in a
-predictable way so the pattern is repeatable across runs. Default: true.
+Seed all random number generators in a predictable way so the pattern is
+repeatable across runs. Default: true.
 .TP
 .BI allrandrepeat \fR=\fPbool
-Seed all random number generators in a predictable way so results are
-repeatable across runs. Default: false.
+Alias for \fBrandrepeat\fR. Default: true.
 .TP
 .BI randseed \fR=\fPint
 Seed the random number generators based on this seed value, to be able to
diff --git a/fio.h b/fio.h
index 6b841e9c..6fc7fb9c 100644
--- a/fio.h
+++ b/fio.h
@@ -638,7 +638,6 @@ extern void fio_options_dup_and_init(struct option *);
 extern char *fio_option_dup_subs(const char *);
 extern void fio_options_mem_dupe(struct thread_data *);
 extern void td_fill_rand_seeds(struct thread_data *);
-extern void td_fill_verify_state_seed(struct thread_data *);
 extern void add_job_opts(const char **, int);
 extern int ioengine_load(struct thread_data *);
 extern bool parse_dryrun(void);
diff --git a/init.c b/init.c
index a70f749a..48121f14 100644
--- a/init.c
+++ b/init.c
@@ -1020,8 +1020,12 @@ static void init_rand_file_service(struct thread_data *td)
 	}
 }
 
-void td_fill_verify_state_seed(struct thread_data *td)
+void td_fill_rand_seeds(struct thread_data *td)
 {
+	uint64_t read_seed = td->rand_seeds[FIO_RAND_BS_OFF];
+	uint64_t write_seed = td->rand_seeds[FIO_RAND_BS1_OFF];
+	uint64_t trim_seed = td->rand_seeds[FIO_RAND_BS2_OFF];
+	int i;
 	bool use64;
 
 	if (td->o.random_generator == FIO_RAND_GEN_TAUSWORTHE64)
@@ -1029,17 +1033,6 @@ void td_fill_verify_state_seed(struct thread_data *td)
 	else
 		use64 = false;
 
-	init_rand_seed(&td->verify_state, td->rand_seeds[FIO_RAND_VER_OFF],
-		use64);
-}
-
-static void td_fill_rand_seeds_internal(struct thread_data *td, bool use64)
-{
-	uint64_t read_seed = td->rand_seeds[FIO_RAND_BS_OFF];
-	uint64_t write_seed = td->rand_seeds[FIO_RAND_BS1_OFF];
-	uint64_t trim_seed = td->rand_seeds[FIO_RAND_BS2_OFF];
-	int i;
-
 	/*
 	 * trimwrite is special in that we need to generate the same
 	 * offsets to get the "write after trim" effect. If we are
@@ -1056,7 +1049,8 @@ static void td_fill_rand_seeds_internal(struct thread_data *td, bool use64)
 	init_rand_seed(&td->bsrange_state[DDIR_WRITE], write_seed, use64);
 	init_rand_seed(&td->bsrange_state[DDIR_TRIM], trim_seed, use64);
 
-	td_fill_verify_state_seed(td);
+	init_rand_seed(&td->verify_state, td->rand_seeds[FIO_RAND_VER_OFF],
+		use64);
 	init_rand_seed(&td->rwmix_state, td->rand_seeds[FIO_RAND_MIX_OFF], false);
 
 	if (td->o.file_service_type == FIO_FSERVICE_RANDOM)
@@ -1075,12 +1069,6 @@ static void td_fill_rand_seeds_internal(struct thread_data *td, bool use64)
 	init_rand_seed(&td->prio_state, td->rand_seeds[FIO_RAND_PRIO_CMDS], false);
 	init_rand_seed(&td->dedupe_working_set_index_state, td->rand_seeds[FIO_RAND_DEDUPE_WORKING_SET_IX], use64);
 
-	if (!td_random(td))
-		return;
-
-	if (td->o.rand_repeatable)
-		td->rand_seeds[FIO_RAND_BLOCK_OFF] = FIO_RANDSEED * td->thread_number;
-
 	init_rand_seed(&td->random_state, td->rand_seeds[FIO_RAND_BLOCK_OFF], use64);
 
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
@@ -1088,29 +1076,39 @@ static void td_fill_rand_seeds_internal(struct thread_data *td, bool use64)
 
 		init_rand_seed(s, td->rand_seeds[FIO_RAND_SEQ_RAND_READ_OFF], false);
 	}
+
+	init_rand_seed(&td->buf_state, td->rand_seeds[FIO_RAND_BUF_OFF], use64);
+	frand_copy(&td->buf_state_prev, &td->buf_state);
 }
 
-void td_fill_rand_seeds(struct thread_data *td)
+static int setup_random_seeds(struct thread_data *td)
 {
-	bool use64;
-
-	if (td->o.allrand_repeatable) {
-		unsigned int i;
+	uint64_t seed;
+	unsigned int i;
 
-		for (i = 0; i < FIO_RAND_NR_OFFS; i++)
-			td->rand_seeds[i] = FIO_RANDSEED * td->thread_number
-			       	+ i;
+	if (!td->o.rand_repeatable && !fio_option_is_set(&td->o, rand_seed)) {
+		int ret = init_random_seeds(td->rand_seeds, sizeof(td->rand_seeds));
+		dprint(FD_RANDOM, "using system RNG for random seeds\n");
+		if (ret)
+			return ret;
+	} else {
+		seed = td->o.rand_seed;
+		for (i = 0; i < 4; i++)
+			seed *= 0x9e370001UL;
+
+		for (i = 0; i < FIO_RAND_NR_OFFS; i++) {
+			td->rand_seeds[i] = seed * td->thread_number + i;
+			seed *= 0x9e370001UL;
+		}
 	}
 
-	if (td->o.random_generator == FIO_RAND_GEN_TAUSWORTHE64)
-		use64 = true;
-	else
-		use64 = false;
+	td_fill_rand_seeds(td);
 
-	td_fill_rand_seeds_internal(td, use64);
+	dprint(FD_RANDOM, "FIO_RAND_NR_OFFS=%d\n", FIO_RAND_NR_OFFS);
+	for (int i = 0; i < FIO_RAND_NR_OFFS; i++)
+		dprint(FD_RANDOM, "rand_seeds[%d]=%" PRIu64 "\n", i, td->rand_seeds[i]);
 
-	init_rand_seed(&td->buf_state, td->rand_seeds[FIO_RAND_BUF_OFF], use64);
-	frand_copy(&td->buf_state_prev, &td->buf_state);
+	return 0;
 }
 
 /*
@@ -1246,31 +1244,6 @@ static void init_flags(struct thread_data *td)
 	}
 }
 
-static int setup_random_seeds(struct thread_data *td)
-{
-	uint64_t seed;
-	unsigned int i;
-
-	if (!td->o.rand_repeatable && !fio_option_is_set(&td->o, rand_seed)) {
-		int ret = init_random_seeds(td->rand_seeds, sizeof(td->rand_seeds));
-		if (!ret)
-			td_fill_rand_seeds(td);
-		return ret;
-	}
-
-	seed = td->o.rand_seed;
-	for (i = 0; i < 4; i++)
-		seed *= 0x9e370001UL;
-
-	for (i = 0; i < FIO_RAND_NR_OFFS; i++) {
-		td->rand_seeds[i] = seed * td->thread_number + i;
-		seed *= 0x9e370001UL;
-	}
-
-	td_fill_rand_seeds(td);
-	return 0;
-}
-
 enum {
 	FPRE_NONE = 0,
 	FPRE_JOBNAME,
diff --git a/options.c b/options.c
index 440bff37..8193fb29 100644
--- a/options.c
+++ b/options.c
@@ -2465,6 +2465,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	},
 	{
 		.name	= "randrepeat",
+		.alias	= "allrandrepeat",
 		.lname	= "Random repeatable",
 		.type	= FIO_OPT_BOOL,
 		.off1	= offsetof(struct thread_options, rand_repeatable),
@@ -2594,16 +2595,6 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_RANDOM,
 	},
-	{
-		.name	= "allrandrepeat",
-		.lname	= "All Random Repeat",
-		.type	= FIO_OPT_BOOL,
-		.off1	= offsetof(struct thread_options, allrand_repeatable),
-		.help	= "Use repeatable random numbers for everything",
-		.def	= "0",
-		.category = FIO_OPT_C_IO,
-		.group	= FIO_OPT_G_RANDOM,
-	},
 	{
 		.name	= "nrfiles",
 		.lname	= "Number of files",
diff --git a/server.h b/server.h
index 898a893d..601d3340 100644
--- a/server.h
+++ b/server.h
@@ -51,7 +51,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 99,
+	FIO_SERVER_VER			= 100,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/t/io_uring.c b/t/io_uring.c
index 504f8ce9..f9f4b840 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -704,7 +704,7 @@ static int get_file_size(struct file *f)
 					bs, lbs);
 			return -1;
 		}
-		f->max_blocks = nlba / bs;
+		f->max_blocks = nlba;
 		f->max_size = nlba;
 		f->lba_shift = ilog2(lbs);
 		return 0;
diff --git a/t/random_seed.py b/t/random_seed.py
new file mode 100755
index 00000000..86f2eb21
--- /dev/null
+++ b/t/random_seed.py
@@ -0,0 +1,394 @@
+#!/usr/bin/env python3
+"""
+# random_seed.py
+#
+# Test fio's random seed options.
+#
+# - make sure that randseed overrides randrepeat and allrandrepeat
+# - make sure that seeds differ across invocations when [all]randrepeat=0 and randseed is not set
+# - make sure that seeds are always the same when [all]randrepeat=1 and randseed is not set
+#
+# USAGE
+# see python3 random_seed.py --help
+#
+# EXAMPLES
+# python3 t/random_seed.py
+# python3 t/random_seed.py -f ./fio
+#
+# REQUIREMENTS
+# Python 3.6
+#
+"""
+import os
+import sys
+import time
+import locale
+import argparse
+import subprocess
+from pathlib import Path
+
+class FioRandTest():
+    """fio random seed test."""
+
+    def __init__(self, artifact_root, test_options, debug):
+        """
+        artifact_root   root directory for artifacts (subdirectory will be created under here)
+        test            test specification
+        """
+        self.artifact_root = artifact_root
+        self.test_options = test_options
+        self.debug = debug
+        self.filename_stub = None
+        self.filenames = {}
+
+        self.test_dir = os.path.abspath(os.path.join(self.artifact_root,
+                                     f"{self.test_options['test_id']:03d}"))
+        if not os.path.exists(self.test_dir):
+            os.mkdir(self.test_dir)
+
+        self.filename_stub = f"random{self.test_options['test_id']:03d}"
+        self.filenames['command'] = os.path.join(self.test_dir, f"{self.filename_stub}.command")
+        self.filenames['stdout'] = os.path.join(self.test_dir, f"{self.filename_stub}.stdout")
+        self.filenames['stderr'] = os.path.join(self.test_dir, f"{self.filename_stub}.stderr")
+        self.filenames['exitcode'] = os.path.join(self.test_dir, f"{self.filename_stub}.exitcode")
+        self.filenames['output'] = os.path.join(self.test_dir, f"{self.filename_stub}.output")
+
+    def run_fio(self, fio_path):
+        """Run a test."""
+
+        fio_args = [
+            "--debug=random",
+            "--name=random_seed",
+            "--ioengine=null",
+            "--filesize=32k",
+            "--rw=randread",
+            f"--output={self.filenames['output']}",
+        ]
+        for opt in ['randseed', 'randrepeat', 'allrandrepeat']:
+            if opt in self.test_options:
+                option = f"--{opt}={self.test_options[opt]}"
+                fio_args.append(option)
+
+        command = [fio_path] + fio_args
+        with open(self.filenames['command'], "w+", encoding=locale.getpreferredencoding()) as command_file:
+            command_file.write(" ".join(command))
+
+        passed = True
+
+        try:
+            with open(self.filenames['stdout'], "w+", encoding=locale.getpreferredencoding()) as stdout_file, \
+                open(self.filenames['stderr'], "w+", encoding=locale.getpreferredencoding()) as stderr_file, \
+                open(self.filenames['exitcode'], "w+", encoding=locale.getpreferredencoding()) as exitcode_file:
+                proc = None
+                # Avoid using subprocess.run() here because when a timeout occurs,
+                # fio will be stopped with SIGKILL. This does not give fio a
+                # chance to clean up and means that child processes may continue
+                # running and submitting IO.
+                proc = subprocess.Popen(command,
+                                        stdout=stdout_file,
+                                        stderr=stderr_file,
+                                        cwd=self.test_dir,
+                                        universal_newlines=True)
+                proc.communicate(timeout=300)
+                exitcode_file.write(f'{proc.returncode}\n')
+                passed &= (proc.returncode == 0)
+        except subprocess.TimeoutExpired:
+            proc.terminate()
+            proc.communicate()
+            assert proc.poll()
+            print("Timeout expired")
+            passed = False
+        except Exception:
+            if proc:
+                if not proc.poll():
+                    proc.terminate()
+                    proc.communicate()
+            print(f"Exception: {sys.exc_info()}")
+            passed = False
+
+        return passed
+
+    def get_rand_seeds(self):
+        """Collect random seeds from --debug=random output."""
+        with open(self.filenames['output'], "r", encoding=locale.getpreferredencoding()) as out_file:
+            file_data = out_file.read()
+
+            offsets = 0
+            for line in file_data.split('\n'):
+                if 'random' in line and 'FIO_RAND_NR_OFFS=' in line:
+                    tokens = line.split('=')
+                    offsets = int(tokens[len(tokens)-1])
+                    break
+
+            if offsets == 0:
+                pass
+                # find an exception to throw
+
+            seed_list = []
+            for line in file_data.split('\n'):
+                if 'random' not in line:
+                    continue
+                if 'rand_seeds[' in line:
+                    tokens = line.split('=')
+                    seed = int(tokens[-1])
+                    seed_list.append(seed)
+                    # assume that seeds are in order
+
+            return seed_list
+
+    def check(self):
+        """Check test output."""
+
+        raise NotImplementedError()
+
+
+class TestRR(FioRandTest):
+    """
+    Test object for [all]randrepeat. If run for the first time just collect the
+    seeds. For later runs make sure the seeds match or do not match those
+    previously collected.
+    """
+    # one set of seeds is for randrepeat=0 and the other is for randrepeat=1
+    seeds = { 0: None, 1: None }
+
+    def check(self):
+        """Check output for allrandrepeat=1."""
+
+        retval = True
+        opt = 'randrepeat' if 'randrepeat' in self.test_options else 'allrandrepeat'
+        rr = self.test_options[opt]
+        rand_seeds = self.get_rand_seeds()
+
+        if not TestRR.seeds[rr]:
+            TestRR.seeds[rr] = rand_seeds
+            if self.debug:
+                print(f"TestRR: saving rand_seeds for [a]rr={rr}")
+        else:
+            if rr:
+                if TestRR.seeds[1] != rand_seeds:
+                    retval = False
+                    print(f"TestRR: unexpected seed mismatch for [a]rr={rr}")
+                else:
+                    if self.debug:
+                        print(f"TestRR: seeds correctly match for [a]rr={rr}")
+                if TestRR.seeds[0] == rand_seeds:
+                    retval = False
+                    print("TestRR: seeds unexpectedly match those from system RNG")
+            else:
+                if TestRR.seeds[0] == rand_seeds:
+                    retval = False
+                    print(f"TestRR: unexpected seed match for [a]rr={rr}")
+                else:
+                    if self.debug:
+                        print(f"TestRR: seeds correctly don't match for [a]rr={rr}")
+                if TestRR.seeds[1] == rand_seeds:
+                    retval = False
+                    print(f"TestRR: random seeds unexpectedly match those from [a]rr=1")
+
+        return retval
+
+
+class TestRS(FioRandTest):
+    """
+    Test object when randseed=something controls the generated seeds. If run
+    for the first time for a given randseed just collect the seeds. For later
+    runs with the same seed make sure the seeds are the same as those
+    previously collected.
+    """
+    seeds = {}
+
+    def check(self):
+        """Check output for randseed=something."""
+
+        retval = True
+        rand_seeds = self.get_rand_seeds()
+        randseed = self.test_options['randseed']
+
+        if self.debug:
+            print("randseed = ", randseed)
+
+        if randseed not in TestRS.seeds:
+            TestRS.seeds[randseed] = rand_seeds
+            if self.debug:
+                print("TestRS: saving rand_seeds")
+        else:
+            if TestRS.seeds[randseed] != rand_seeds:
+                retval = False
+                print("TestRS: seeds don't match when they should")
+            else:
+                if self.debug:
+                    print("TestRS: seeds correctly match")
+
+        # Now try to find seeds generated using a different randseed and make
+        # sure they *don't* match
+        for key in TestRS.seeds:
+            if key != randseed:
+                if TestRS.seeds[key] == rand_seeds:
+                    retval = False
+                    print("TestRS: randseeds differ but generated seeds match.")
+                else:
+                    if self.debug:
+                        print("TestRS: randseeds differ and generated seeds also differ.")
+
+        return retval
+
+
+def parse_args():
+    """Parse command-line arguments."""
+
+    parser = argparse.ArgumentParser()
+    parser.add_argument('-f', '--fio', help='path to file executable (e.g., ./fio)')
+    parser.add_argument('-a', '--artifact-root', help='artifact root directory')
+    parser.add_argument('-d', '--debug', help='enable debug output', action='store_true')
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
+    """Run tests of fio random seed options"""
+
+    args = parse_args()
+
+    artifact_root = args.artifact_root if args.artifact_root else \
+        f"random-seed-test-{time.strftime('%Y%m%d-%H%M%S')}"
+    os.mkdir(artifact_root)
+    print(f"Artifact directory is {artifact_root}")
+
+    if args.fio:
+        fio = str(Path(args.fio).absolute())
+    else:
+        fio = 'fio'
+    print(f"fio path is {fio}")
+
+    test_list = [
+        {
+            "test_id": 1,
+            "randrepeat": 0,
+            "test_obj": TestRR,
+        },
+        {
+            "test_id": 2,
+            "randrepeat": 0,
+            "test_obj": TestRR,
+        },
+        {
+            "test_id": 3,
+            "randrepeat": 1,
+            "test_obj": TestRR,
+        },
+        {
+            "test_id": 4,
+            "randrepeat": 1,
+            "test_obj": TestRR,
+        },
+        {
+            "test_id": 5,
+            "allrandrepeat": 0,
+            "test_obj": TestRR,
+        },
+        {
+            "test_id": 6,
+            "allrandrepeat": 0,
+            "test_obj": TestRR,
+        },
+        {
+            "test_id": 7,
+            "allrandrepeat": 1,
+            "test_obj": TestRR,
+        },
+        {
+            "test_id": 8,
+            "allrandrepeat": 1,
+            "test_obj": TestRR,
+        },
+        {
+            "test_id": 9,
+            "randrepeat": 0,
+            "randseed": "12345",
+            "test_obj": TestRS,
+        },
+        {
+            "test_id": 10,
+            "randrepeat": 0,
+            "randseed": "12345",
+            "test_obj": TestRS,
+        },
+        {
+            "test_id": 11,
+            "randrepeat": 1,
+            "randseed": "12345",
+            "test_obj": TestRS,
+        },
+        {
+            "test_id": 12,
+            "allrandrepeat": 0,
+            "randseed": "12345",
+            "test_obj": TestRS,
+        },
+        {
+            "test_id": 13,
+            "allrandrepeat": 1,
+            "randseed": "12345",
+            "test_obj": TestRS,
+        },
+        {
+            "test_id": 14,
+            "randrepeat": 0,
+            "randseed": "67890",
+            "test_obj": TestRS,
+        },
+        {
+            "test_id": 15,
+            "randrepeat": 1,
+            "randseed": "67890",
+            "test_obj": TestRS,
+        },
+        {
+            "test_id": 16,
+            "allrandrepeat": 0,
+            "randseed": "67890",
+            "test_obj": TestRS,
+        },
+        {
+            "test_id": 17,
+            "allrandrepeat": 1,
+            "randseed": "67890",
+            "test_obj": TestRS,
+        },
+    ]
+
+    passed = 0
+    failed = 0
+    skipped = 0
+
+    for test in test_list:
+        if (args.skip and test['test_id'] in args.skip) or \
+           (args.run_only and test['test_id'] not in args.run_only):
+            skipped = skipped + 1
+            outcome = 'SKIPPED (User request)'
+        else:
+            test_obj = test['test_obj'](artifact_root, test, args.debug)
+            status = test_obj.run_fio(fio)
+            if status:
+                status = test_obj.check()
+            if status:
+                passed = passed + 1
+                outcome = 'PASSED'
+            else:
+                failed = failed + 1
+                outcome = 'FAILED'
+
+        print(f"**********Test {test['test_id']} {outcome}**********")
+
+    print(f"{passed} tests passed, {failed} failed, {skipped} skipped")
+
+    sys.exit(failed)
+
+
+if __name__ == '__main__':
+    main()
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index c3091b68..4fe6fe46 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -53,6 +53,7 @@ import traceback
 import subprocess
 import multiprocessing
 from pathlib import Path
+from statsmodels.sandbox.stats.runs import runstest_1samp
 
 
 class FioTest():
@@ -598,24 +599,16 @@ class FioJobTest_t0020(FioJobTest):
 
         log_lines = file_data.split('\n')
 
-        seq_count = 0
-        offsets = set()
+        offsets = []
 
         prev = int(log_lines[0].split(',')[4])
         for line in log_lines[1:]:
-            offsets.add(prev/4096)
+            offsets.append(prev/4096)
             if len(line.strip()) == 0:
                 continue
             cur = int(line.split(',')[4])
-            if cur - prev == 4096:
-                seq_count += 1
             prev = cur
 
-        # 10 is an arbitrary threshold
-        if seq_count > 10:
-            self.passed = False
-            self.failure_reason = "too many ({0}) consecutive offsets".format(seq_count)
-
         if len(offsets) != 256:
             self.passed = False
             self.failure_reason += " number of offsets is {0} instead of 256".format(len(offsets))
@@ -625,6 +618,11 @@ class FioJobTest_t0020(FioJobTest):
                 self.passed = False
                 self.failure_reason += " missing offset {0}".format(i*4096)
 
+        (z, p) = runstest_1samp(list(offsets))
+        if p < 0.05:
+            self.passed = False
+            self.failure_reason += f" runs test failed with p = {p}"
+
 
 class FioJobTest_t0022(FioJobTest):
     """Test consists of fio test job t0022"""
@@ -1361,6 +1359,14 @@ TEST_LIST = [
         'success':          SUCCESS_DEFAULT,
         'requirements':     [],
     },
+    {
+        'test_id':          1013,
+        'test_class':       FioExeTest,
+        'exe':              't/random_seed.py',
+        'parameters':       ['-f', '{fio_path}'],
+        'success':          SUCCESS_DEFAULT,
+        'requirements':     [],
+    },
 ]
 
 
diff --git a/thread_options.h b/thread_options.h
index 6670cbbf..a24ebee6 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -162,7 +162,6 @@ struct thread_options {
 	unsigned int do_disk_util;
 	unsigned int override_sync;
 	unsigned int rand_repeatable;
-	unsigned int allrand_repeatable;
 	unsigned long long rand_seed;
 	unsigned int log_avg_msec;
 	unsigned int log_hist_msec;
@@ -485,8 +484,6 @@ struct thread_options_pack {
 	uint32_t do_disk_util;
 	uint32_t override_sync;
 	uint32_t rand_repeatable;
-	uint32_t allrand_repeatable;
-	uint32_t pad2;
 	uint64_t rand_seed;
 	uint32_t log_avg_msec;
 	uint32_t log_hist_msec;
