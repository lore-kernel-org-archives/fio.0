Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9001FC0F0
	for <fio@vger.kernel.org>; Sat, 17 May 2025 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747483212; cv=none; b=JsoNeaJssvkiz4JozJ1CXMuAiBkSXMsqcLcFqLfTPiUg8KYwM8AWdY4/+0tA9hnwdZSNoIfU2PO4WEOIc6lZ5Z9m19PD8MLv9RSRUUMMdYvR5f8RM49DMlxJr//yCeTt2wFTEOBbxsKqefmU1fAbQbNe/00sT5XITZ05Biymgpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747483212; c=relaxed/simple;
	bh=j/Btk0ufrneF2MObi3BCsLQImNdQjmW5DxKdFU27HNY=;
	h=Subject:From:To:Message-Id:Date; b=FzzE59wBZK7FWF1ASmuwvsofQZi1GYA3XI9dwXfFvT15ju7DrbDvVwFSa8OdCw37hgHWtQd5m6dtZx13f0EpH4fKF0aY1pSgGLXVX8XumBpYv/cpNagIhXXNkBaGOiIq0PRjNepk8YsmMUhGcGrBYS/pEPV3GcX8cwIfN7khkBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sw4QeBKr; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sw4QeBKr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=256/Y+OHL1bupHQ9VBuj36dn7MHZ6qNUU2sTUp885Zg=; b=sw4QeBKr8aR12KPrOXcwTIBIpK
	efIqmRzMC0RTmXtfgCDrbiMy3YsaR4IZq/gFLpo8H0VU0YJS18ZfP33PW1TjPhKCqD+iGAQkFQrF6
	dLtsrYdwyScAo/a47cZ1DXBki5pOida1aonNwkw2O56fVWVNxSr9w6UHcu1o6u+ApfBbLcpEa6Ytr
	y8JVeAeCRmYeJRLti58mvKd0d5BFBX0dcoVf+vRRTm3tVsGYp67zOdsa9y6GW1XEHSJdFXc8hHJeL
	HbJ5STrCZcV+GTTRfislyR7mtTmXgRmiBeQM61UQP6JKZcTDpSl0i0t6niyepIf87XC+fbEPs54Ed
	c9fH7trw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uGGCy-0000000GlOq-0w1S
	for fio@vger.kernel.org;
	Sat, 17 May 2025 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 8902B1BC0152; Sat, 17 May 2025 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250517120001.8902B1BC0152@kernel.dk>
Date: Sat, 17 May 2025 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 171e18146a3ea26491b087a29c6ee7b0ad21e719:

  configure: Fix libnfs cflags and libs (2025-05-14 06:56:13 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to fb253b221687439c92a0ee147427d70a4e36e28f:

  t/verify: add tests to exercise verify_pattern_interval (2025-05-16 12:09:30 -0400)

----------------------------------------------------------------
Vincent Fu (11):
      verify: add verify mode for a pattern with header
      verify: fix verify_offset when used with pattern_hdr
      verify: make verify_pattern=%o thread safe
      verify: omit verify type mismatch error message for pattern verify
      t/fiotestcommon: lengthen timeout for longer tests
      ci: for nightly verify tests use all checksum methods
      ci: don't skip verify tests when triggered manually
      verify: add verify_pattern_interval option
      t/verify: test cases for running pattern and pattern_hdr
      t/verify: Windows --output work-around
      t/verify: add tests to exercise verify_pattern_interval

 HOWTO.rst               |  11 ++++
 cconv.c                 |   2 +
 ci/actions-full-test.sh |   9 ++-
 fio.1                   |  10 +++
 options.c               |  16 +++++
 server.h                |   2 +-
 t/fiotestcommon.py      |   2 +-
 t/verify.py             | 123 +++++++++++++++++++++++++++++++++++--
 thread_options.h        |   3 +
 verify.c                | 158 ++++++++++++++++++++++++++++++++++++++----------
 10 files changed, 295 insertions(+), 41 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index a5033d82..f082158a 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -3921,6 +3921,9 @@ Verification
 			basic information and checksumming, but if this option is set, only
 			the specific pattern set with :option:`verify_pattern` is verified.
 
+		**pattern_hdr**
+			Verify a pattern in conjunction with a header.
+
 		**null**
 			Only pretend to verify. Useful for testing internals with
 			:option:`ioengine`\=null, not for much else.
@@ -3974,6 +3977,14 @@ Verification
 
 		verify_pattern=0xff%o"abcd"-12
 
+.. option:: verify_pattern_interval=bool
+
+        Recreate an instance of the :option:`verify_pattern` every
+        :option:`verify_pattern_interval` bytes. This is only useful when
+        :option:`verify_pattern` contains the %o format specifier and can be
+        used to speed up the process of writing each block on a device with its
+        offset. Default: 0 (disabled).
+
 .. option:: verify_fatal=bool
 
 	Normally fio will keep checking the entire contents before quitting on a
diff --git a/cconv.c b/cconv.c
index cc1a52c7..d2faf83e 100644
--- a/cconv.c
+++ b/cconv.c
@@ -186,6 +186,7 @@ int convert_thread_options_to_cpu(struct thread_options *o,
 	o->verify_header_seed = le32_to_cpu(top->verify_header_seed);
 
 	o->verify_pattern_bytes = le32_to_cpu(top->verify_pattern_bytes);
+	o->verify_pattern_interval = le32_to_cpu(top->verify_pattern_interval);
 	o->buffer_pattern_bytes = le32_to_cpu(top->buffer_pattern_bytes);
 	if (o->verify_pattern_bytes >= MAX_PATTERN_SIZE ||
 	    o->buffer_pattern_bytes >= MAX_PATTERN_SIZE ||
@@ -448,6 +449,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->verify_write_sequence = cpu_to_le32(o->verify_write_sequence);
 	top->verify_header_seed = cpu_to_le32(o->verify_header_seed);
 	top->verify_pattern_bytes = cpu_to_le32(o->verify_pattern_bytes);
+	top->verify_pattern_interval = cpu_to_le32(o->verify_pattern_interval);
 	top->verify_fatal = cpu_to_le32(o->verify_fatal);
 	top->verify_dump = cpu_to_le32(o->verify_dump);
 	top->verify_async = cpu_to_le32(o->verify_async);
diff --git a/ci/actions-full-test.sh b/ci/actions-full-test.sh
index 4222a21a..6fa9f4ad 100755
--- a/ci/actions-full-test.sh
+++ b/ci/actions-full-test.sh
@@ -35,14 +35,17 @@ main() {
 
     fi
 
-    # If we are running a nightly test just run the verify tests.
-    # Otherwise skip the verify test script because it takes so long.
+    # If we are running a nightly test just run the verify tests.  Skip the
+    # verify test script with pull requests and pushes because it takes so
+    # long. When this workflow is run manually everything will be run.
     if [ "${GITHUB_EVENT_NAME}" == "schedule" ]; then
 	args+=(
 	    --run-only
 	    1017
+	    -p
+	    "1017:--complete"
 	)
-    else
+    elif [ "${GITHUB_EVENT_NAME}" == "pull_request" ] || [ "${GITHUB_EVENT_NAME}" == "push" ]; then
 	skip+=(
 	    1017
 	)
diff --git a/fio.1 b/fio.1
index 69dd892f..0071c364 100644
--- a/fio.1
+++ b/fio.1
@@ -3642,6 +3642,9 @@ Verify a strict pattern. Normally fio includes a header with some
 basic information and checksumming, but if this option is set, only
 the specific pattern set with \fBverify_pattern\fR is verified.
 .TP
+.B pattern_hdr
+Verify a pattern in conjunction with a header.
+.TP
 .B null
 Only pretend to verify. Useful for testing internals with
 `ioengine=null', not for much else.
@@ -3699,6 +3702,13 @@ verify_pattern=0xff%o"abcd"\-12
 .RE
 .RE
 .TP
+.BI verify_pattern_interval \fR=\fPbool
+Recreate an instance of the \fBverify_pattern\fR every
+\fBverify_pattern_interval\fR bytes. This is only useful when
+\fBverify_pattern\fR contains the %o format specifier and can be used to speed
+up the process of writing each block on a device with its offset. Default:
+0 (disabled).
+.TP
 .BI verify_fatal \fR=\fPbool
 Normally fio will keep checking the entire contents before quitting on a
 block verification failure. If this option is set, fio will exit the job on
diff --git a/options.c b/options.c
index 71c97e9e..cfece3fe 100644
--- a/options.c
+++ b/options.c
@@ -3217,6 +3217,10 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .oval = VERIFY_PATTERN_NO_HDR,
 			    .help = "Verify strict pattern",
 			  },
+			  { .ival = "pattern_hdr",
+			    .oval = VERIFY_PATTERN,
+			    .help = "Verify pattern with header",
+			  },
 			  {
 			    .ival = "null",
 			    .oval = VERIFY_NULL,
@@ -3287,6 +3291,18 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_VERIFY,
 	},
+	{
+		.name	= "verify_pattern_interval",
+		.lname	= "Running verify pattern",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct thread_options, verify_pattern_interval),
+		.def	= "0",
+		.help	= "Re-create verify pattern every N bytes",
+		.parent = "verify",
+		.hide	= 1,
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_VERIFY,
+	},
 	{
 		.name	= "verify_fatal",
 		.lname	= "Verify fatal",
diff --git a/server.h b/server.h
index 0b93cd02..713fd8e4 100644
--- a/server.h
+++ b/server.h
@@ -51,7 +51,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 110,
+	FIO_SERVER_VER			= 111,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/t/fiotestcommon.py b/t/fiotestcommon.py
index 9003b4c1..04dfb91f 100644
--- a/t/fiotestcommon.py
+++ b/t/fiotestcommon.py
@@ -22,7 +22,7 @@ SUCCESS_DEFAULT = {
 SUCCESS_LONG = {
     'zero_return': True,
     'stderr_empty': True,
-    'timeout': 1800,
+    'timeout': 3600,
     }
 SUCCESS_NONZERO = {
     'zero_return': False,
diff --git a/t/verify.py b/t/verify.py
index e48bad28..58bf327d 100755
--- a/t/verify.py
+++ b/t/verify.py
@@ -55,7 +55,9 @@ VERIFY_OPT_LIST = [
     'verify_async',
     'verify_async_cpus',
     'verify_pattern',
+    'verify_pattern_interval',
     'verify_only',
+    'verify_fatal',
 ]
 
 class VerifyTest(FioJobCmdTest):
@@ -72,7 +74,7 @@ class VerifyTest(FioJobCmdTest):
             f"--ioengine={self.fio_opts['ioengine']}",
             f"--rw={self.fio_opts['rw']}",
             f"--verify={self.fio_opts['verify']}",
-            f"--output={self.filenames['output']}",
+            f"--output={os.path.basename(self.filenames['output'])}",
         ]
         for opt in VERIFY_OPT_LIST:
             if opt in self.fio_opts:
@@ -207,6 +209,41 @@ class VerifyCSUMTest(FioJobCmdTest):
             logging.debug("stderr: %s", contents)
 
 
+#
+# These tests exercise fio's verify_pattern_interval option.
+#
+TEST_LIST_VPI = [
+    {
+        # Basic test verify=pattern
+        "test_id": 3000,
+        "fio_opts": {
+            "ioengine": "psync",
+            "rw": "write",
+            "verify": "pattern",
+            "filesize": "1M",
+            "bs": 4096,
+            "output-format": "json",
+            },
+        "test_class": VerifyTest,
+        "success": SUCCESS_DEFAULT,
+    },
+    {
+        # Basic test verify=pattern_hdr
+        "test_id": 3001,
+        "fio_opts": {
+            "ioengine": "psync",
+            "rw": "write",
+            "verify": "pattern_hdr",
+            "filesize": "1M",
+            "bs": 4096,
+            "output-format": "json",
+            },
+        "test_class": VerifyTest,
+        "success": SUCCESS_DEFAULT,
+    },
+]
+
+
 #
 # These tests exercise fio's decisions about verifying the sequence number and
 # random seed in the verify header.
@@ -281,6 +318,7 @@ TEST_LIST_CSUM = [
             "bs": 4096,
             "rw": "write",
             "output-format": "json",
+            "verify_fatal": 1,
             },
         "test_class": VerifyCSUMTest,
         "success": SUCCESS_NONZERO,
@@ -294,6 +332,7 @@ TEST_LIST_CSUM = [
             "bs": 4096,
             "rw": "randwrite",
             "output-format": "json",
+            "verify_fatal": 1,
             },
         "test_class": VerifyCSUMTest,
         "success": SUCCESS_NONZERO,
@@ -309,6 +348,7 @@ TEST_LIST_CSUM = [
             "bs": 4096,
             "rw": "write",
             "output-format": "json",
+            "verify_fatal": 1,
             },
         "test_class": VerifyCSUMTest,
         "success": SUCCESS_NONZERO,
@@ -324,6 +364,7 @@ TEST_LIST_CSUM = [
             "bs": 4096,
             "rw": "randwrite",
             "output-format": "json",
+            "verify_fatal": 1,
             },
         "test_class": VerifyCSUMTest,
         "success": SUCCESS_NONZERO,
@@ -508,10 +549,20 @@ def verify_test_header(test_env, args, csum, mode, sequence):
             test['force_skip'] = False
 
         test['fio_opts']['verify'] = csum
-        if csum == 'pattern':
+        if csum in ('pattern', 'pattern_hdr'):
             test['fio_opts']['verify_pattern'] = '"abcd"-120xdeadface'
+            test['fio_opts'].pop('verify_pattern_interval', None)
+        elif csum == 'pattern_interval':
+            test['fio_opts']['verify'] = "pattern_hdr"
+            test['fio_opts']['verify_pattern'] = '%o'
+            test['fio_opts']['verify_pattern_interval'] = 512
+        elif csum == 'pattern_interval_nohdr':
+            test['fio_opts']['verify'] = "pattern"
+            test['fio_opts']['verify_pattern'] = '%o'
+            test['fio_opts']['verify_pattern_interval'] = 512
         else:
             test['fio_opts'].pop('verify_pattern', None)
+            test['fio_opts'].pop('verify_pattern_interval', None)
 
         if 'norandommap' in sequence:
             test['fio_opts']['norandommap'] = 1
@@ -579,10 +630,20 @@ def verify_test_csum(test_env, args, mbs, csum):
         test['force_skip'] = False
         test['fio_opts']['verify'] = csum
 
-        if csum == 'pattern':
+        if csum in ('pattern', 'pattern_hdr'):
             test['fio_opts']['verify_pattern'] = '"abcd"-120xdeadface'
+            test['fio_opts'].pop('verify_pattern_interval', None)
+        elif csum == 'pattern_interval':
+            test['fio_opts']['verify'] = "pattern_hdr"
+            test['fio_opts']['verify_pattern'] = '%o'
+            test['fio_opts']['verify_pattern_interval'] = 512
+        elif csum == 'pattern_interval_nohdr':
+            test['fio_opts']['verify'] = "pattern"
+            test['fio_opts']['verify_pattern'] = '%o'
+            test['fio_opts']['verify_pattern_interval'] = 512
         else:
             test['fio_opts'].pop('verify_pattern', None)
+            test['fio_opts'].pop('verify_pattern_interval', None)
 
         if mbs == MANGLE_JOB_BS:
             test['fio_opts']['mangle_bs'] = test['fio_opts']['bs']
@@ -599,6 +660,25 @@ def verify_test_csum(test_env, args, mbs, csum):
     return run_fio_tests(TEST_LIST_CSUM, test_env, args)
 
 
+def verify_test_vpi(test_env, args, pattern, vpi, vi):
+    """
+    Adjust test arguments based on values of ddir and csum.  Then run
+    the tests.
+    """
+    for test in TEST_LIST_VPI:
+        test['force_skip'] = False
+
+        test['fio_opts']['verify_pattern'] = pattern
+        test['fio_opts']['verify_interval'] = vi
+        test['fio_opts']['verify_pattern_interval'] = vpi
+
+        for key in ['verify_interval', 'verify_pattern_interval']:
+            if not test['fio_opts'][key]:
+                test['fio_opts'].pop(key, None)
+
+    return run_fio_tests(TEST_LIST_VPI, test_env, args)
+
+
 def verify_test(test_env, args, ddir, csum):
     """
     Adjust test arguments based on values of ddir and csum.  Then run
@@ -610,10 +690,20 @@ def verify_test(test_env, args, ddir, csum):
         test['fio_opts']['rw'] = ddir
         test['fio_opts']['verify'] = csum
 
-        if csum == 'pattern':
+        if csum in ('pattern', 'pattern_hdr'):
             test['fio_opts']['verify_pattern'] = '"abcd"-120xdeadface'
+            test['fio_opts'].pop('verify_pattern_interval', None)
+        elif csum == 'pattern_interval':
+            test['fio_opts']['verify'] = "pattern_hdr"
+            test['fio_opts']['verify_pattern'] = '%o'
+            test['fio_opts']['verify_pattern_interval'] = 512
+        elif csum == 'pattern_interval_nohdr':
+            test['fio_opts']['verify'] = "pattern"
+            test['fio_opts']['verify_pattern'] = '%o'
+            test['fio_opts']['verify_pattern_interval'] = 512
         else:
             test['fio_opts'].pop('verify_pattern', None)
+            test['fio_opts'].pop('verify_pattern_interval', None)
 
         # For 100% read data directions we need the write file that was written with
         # verify enabled. Use a previous test case for this by telling fio to
@@ -664,6 +754,9 @@ CSUM_LIST2 = [
         'sha3-384',
         'sha3-512',
         'pattern',
+        'pattern_hdr',
+        'pattern_interval',
+        'pattern_interval_nohdr',
         'null',
              ]
 
@@ -730,6 +823,11 @@ def main():
             test['fio_opts']['ioengine'] = aio
         if 'sync' in test['fio_opts']['ioengine']:
             test['fio_opts']['ioengine'] = sync
+    for test in TEST_LIST_VPI:
+        if 'aio' in test['fio_opts']['ioengine']:
+            test['fio_opts']['ioengine'] = aio
+        if 'sync' in test['fio_opts']['ioengine']:
+            test['fio_opts']['ioengine'] = sync
 
     total = { 'passed':  0, 'failed': 0, 'skipped': 0 }
 
@@ -791,6 +889,23 @@ def main():
             total['failed'] += failed
             total['skipped'] += skipped
 
+        # The loop below is for verify_pattern_interval tests
+        pattern_list = ['%o', '"abcde"', '1%o',]
+        vpi_list = [10, 129, 512, 4089, None]
+        verify_interval_list = [512, 1024, 2222, 3791, None]
+        for pattern, vpi, vi in itertools.product(pattern_list, vpi_list, verify_interval_list):
+            print(f"\npattern: {pattern}, verify_pattern_interval: {vpi}, verify_interval: {vi}")
+
+            test_env['artifact_root'] = os.path.join(artifact_root,
+                f"pattern_{pattern}_vpi_{vpi}_vi_{vi}").replace('"', '').replace("%", 'pct')
+            os.mkdir(test_env['artifact_root'])
+
+            passed, failed, skipped = verify_test_vpi(test_env, args, pattern, vpi, vi)
+
+            total['passed'] += passed
+            total['failed'] += failed
+            total['skipped'] += skipped
+
     except KeyboardInterrupt:
         pass
 
diff --git a/thread_options.h b/thread_options.h
index b0094651..6c9dd80a 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -146,6 +146,7 @@ struct thread_options {
 	unsigned int verify_offset;
 	char *verify_pattern;
 	unsigned int verify_pattern_bytes;
+	unsigned int verify_pattern_interval;
 	struct pattern_fmt verify_fmt[8];
 	unsigned int verify_fmt_sz;
 	unsigned int verify_fatal;
@@ -478,6 +479,7 @@ struct thread_options_pack {
 	uint32_t verify_interval;
 	uint32_t verify_offset;
 	uint32_t verify_pattern_bytes;
+	uint32_t verify_pattern_interval;
 	uint32_t verify_fatal;
 	uint32_t verify_dump;
 	uint32_t verify_async;
@@ -517,6 +519,7 @@ struct thread_options_pack {
 
 	struct zone_split zone_split[DDIR_RWDIR_CNT][ZONESPLIT_MAX];
 	uint32_t zone_split_nr[DDIR_RWDIR_CNT];
+	uint32_t pad2;
 
 	fio_fp64_t zipf_theta;
 	fio_fp64_t pareto_h;
diff --git a/verify.c b/verify.c
index 928bdd54..04718f30 100644
--- a/verify.c
+++ b/verify.c
@@ -51,6 +51,8 @@ void fill_verify_pattern(struct thread_data *td, void *p, unsigned int len,
 			 struct io_u *io_u, uint64_t seed, int use_seed)
 {
 	struct thread_options *o = &td->o;
+	unsigned int interval = o->verify_pattern_interval;
+	unsigned long long offset = io_u->offset;
 
 	if (!o->verify_pattern_bytes) {
 		dprint(FD_VERIFY, "fill random bytes len=%u\n", len);
@@ -65,18 +67,33 @@ void fill_verify_pattern(struct thread_data *td, void *p, unsigned int len,
 		return;
 	}
 
-	/* Skip if we were here and we do not need to patch pattern
-	 * with format */
-	if (!td->o.verify_fmt_sz && io_u->buf_filled_len >= len) {
+	/* Skip if we were here and we do not need to patch pattern with
+	 * format. However, we cannot skip if verify_offset is set because we
+	 * have swapped the header with pattern bytes */
+	if (!td->o.verify_fmt_sz && io_u->buf_filled_len >= len && !td->o.verify_offset) {
 		dprint(FD_VERIFY, "using already filled verify pattern b=%d len=%u\n",
 			o->verify_pattern_bytes, len);
 		return;
 	}
 
-	(void)paste_format(td->o.verify_pattern, td->o.verify_pattern_bytes,
-			   td->o.verify_fmt, td->o.verify_fmt_sz,
-			   p, len, io_u);
+	if (!interval)
+		interval = len;
+
+	io_u->offset += (p - io_u->buf) - (p - io_u->buf) % interval;
+	for (unsigned int bytes_done = 0, bytes_todo = 0; bytes_done < len;
+			bytes_done += bytes_todo, p += bytes_todo, io_u->offset += interval) {
+		bytes_todo = (p - io_u->buf) % interval;
+		if (!bytes_todo)
+			bytes_todo = interval;
+		bytes_todo = min(bytes_todo, len - bytes_done);
+
+		(void)paste_format(td->o.verify_pattern, td->o.verify_pattern_bytes,
+				   td->o.verify_fmt, td->o.verify_fmt_sz,
+				   p, bytes_todo, io_u);
+	}
+
 	io_u->buf_filled_len = len;
+	io_u->offset = offset;
 }
 
 static unsigned int get_hdr_inc(struct thread_data *td, struct io_u *io_u)
@@ -372,29 +389,15 @@ static inline void *io_u_verify_off(struct verify_header *hdr, struct vcont *vc)
 	return vc->io_u->buf + vc->hdr_num * hdr->len + hdr_size(vc->td, hdr);
 }
 
-static int verify_io_u_pattern(struct verify_header *hdr, struct vcont *vc)
+static int check_pattern(char *buf, unsigned int len, unsigned int mod,
+		unsigned int pattern_size, char *pattern, unsigned int header_size)
 {
-	struct thread_data *td = vc->td;
-	struct io_u *io_u = vc->io_u;
-	char *buf, *pattern;
-	unsigned int header_size = __hdr_size(td->o.verify);
-	unsigned int len, mod, i, pattern_size;
+	unsigned int i;
 	int rc;
 
-	pattern = td->o.verify_pattern;
-	pattern_size = td->o.verify_pattern_bytes;
-	assert(pattern_size != 0);
-
-	(void)paste_format_inplace(pattern, pattern_size,
-				   td->o.verify_fmt, td->o.verify_fmt_sz, io_u);
-
-	buf = (char *) hdr + header_size;
-	len = get_hdr_inc(td, io_u) - header_size;
-	mod = (get_hdr_inc(td, io_u) * vc->hdr_num + header_size) % pattern_size;
-
 	rc = cmp_pattern(pattern, pattern_size, mod, buf, len);
 	if (!rc)
-		return 0;
+		goto done;
 
 	/* Slow path, compare each byte */
 	for (i = 0; i < len; i++) {
@@ -408,18 +411,109 @@ static int verify_io_u_pattern(struct verify_header *hdr, struct vcont *vc)
 				bits);
 			log_err("fio: bad pattern block offset %u\n",
 				i + header_size);
-			vc->name = "pattern";
-			log_verify_failure(hdr, vc);
-			return EILSEQ;
+			rc = EILSEQ;
+			goto done;
 		}
 		mod++;
-		if (mod == td->o.verify_pattern_bytes)
+		if (mod == pattern_size)
 			mod = 0;
 	}
 
-	/* Unreachable line */
-	assert(0);
-	return EILSEQ;
+done:
+	return rc;
+}
+
+/*
+ *  The current thread will need its own buffer if there are multiple threads
+ *  and the pattern contains the offset. Fio currently only has one pattern
+ *  format specifier so we only need to check that one, but this may need to be
+ *  changed if fio ever gains more pattern format specifiers.
+ */
+static inline bool pattern_need_buffer(struct thread_data *td)
+{
+	return td->o.verify_async &&
+		td->o.verify_fmt_sz &&
+		td->o.verify_fmt[0].desc->paste == paste_blockoff;
+}
+
+static int verify_io_u_pattern(struct verify_header *hdr, struct vcont *vc)
+{
+	struct thread_data *td = vc->td;
+	struct io_u *io_u = vc->io_u;
+	char *buf, *pattern;
+	unsigned int header_size = __hdr_size(td->o.verify);
+	unsigned int len, mod, pattern_size, pattern_interval_mod, bytes_done = 0, bytes_todo;
+	int rc;
+	unsigned long long offset = io_u->offset;
+
+	pattern = td->o.verify_pattern;
+	pattern_size = td->o.verify_pattern_bytes;
+	assert(pattern_size != 0);
+
+	/*
+	 * Make this thread safe when verify_async is set and the verify
+	 * pattern includes the offset.
+	 */
+	if (pattern_need_buffer(td)) {
+		pattern = malloc(pattern_size);
+		assert(pattern);
+		memcpy(pattern, td->o.verify_pattern, pattern_size);
+	}
+
+	if (!td->o.verify_pattern_interval) {
+		(void)paste_format_inplace(pattern, pattern_size,
+					   td->o.verify_fmt, td->o.verify_fmt_sz, io_u);
+	}
+
+	/*
+	 * We have 3 cases here:
+	 * 1. Compare the entire buffer if (1) verify_interval is not set and
+	 * (2) verify_pattern_interval is not set
+	 * 2. Compare the entire *verify_interval* if (1) verify_interval *is*
+	 * set and (2) verify_pattern_interval is not set
+	 * 3. Compare *verify_pattern_interval* segments or subsets thereof if
+	 * (2) verify_pattern_interval is set
+	 */
+
+	buf = (char *) hdr + header_size;
+	len = get_hdr_inc(td, io_u) - header_size;
+	if (td->o.verify_pattern_interval) {
+		unsigned int extent = get_hdr_inc(td, io_u) * vc->hdr_num + header_size;
+		pattern_interval_mod = extent % td->o.verify_pattern_interval;
+		mod = pattern_interval_mod % pattern_size;
+		bytes_todo = min(len, td->o.verify_pattern_interval - pattern_interval_mod);
+		io_u->offset += extent / td->o.verify_pattern_interval * td->o.verify_pattern_interval;
+	} else {
+		mod = (get_hdr_inc(td, io_u) * vc->hdr_num + header_size) % pattern_size;
+		bytes_todo = len;
+		pattern_interval_mod = 0;
+	}
+
+	while (bytes_done < len) {
+		if (td->o.verify_pattern_interval) {
+			(void)paste_format_inplace(pattern, pattern_size,
+					td->o.verify_fmt, td->o.verify_fmt_sz,
+					io_u);
+		}
+
+		rc = check_pattern(buf, bytes_todo, mod, pattern_size, pattern, header_size);
+		if (rc) {
+			vc->name = "pattern";
+			log_verify_failure(hdr, vc);
+			break;
+		}
+
+		mod = 0;
+		bytes_done += bytes_todo;
+		buf += bytes_todo;
+		io_u->offset += td->o.verify_pattern_interval;
+		bytes_todo = min(len - bytes_done, td->o.verify_pattern_interval);
+	}
+
+	io_u->offset = offset;
+	if (pattern_need_buffer(td))
+		free(pattern);
+	return rc;
 }
 
 static int verify_io_u_xxhash(struct verify_header *hdr, struct vcont *vc)
@@ -1004,7 +1098,7 @@ int verify_io_u(struct thread_data *td, struct io_u **io_u_ptr)
 			ret = EINVAL;
 		}
 
-		if (ret && verify_type != hdr->verify_type)
+		if (ret && verify_type != hdr->verify_type && verify_type != VERIFY_PATTERN_NO_HDR)
 			log_err("fio: verify type mismatch (%u media, %u given)\n",
 					hdr->verify_type, verify_type);
 	}
