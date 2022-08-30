Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7510ECAAA1
	for <fio@archiver.kernel.org>; Tue, 30 Aug 2022 12:00:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiH3MAL (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 30 Aug 2022 08:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbiH3MAK (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 30 Aug 2022 08:00:10 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C8D1C13D
        for <fio@vger.kernel.org>; Tue, 30 Aug 2022 05:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=J/yXsqNGtzb8RSgrIrT02DQam3pO9P0Wz0P3va+3Dt0=; b=GdlkhLZkloK7gO5k1z+bp53dcc
        CEeL/gHTygbcl8kB1peOvhe2G7j7O6COyGQQHMdmaBMNScucQXZRwC2Jj7sS5I9tmIZVcjB0cB5V8
        d/+ves0/kosyuCnbSwn6s2m2j6GieaqWwk1j52+g3jM+CleYY4ajpcyZtdtaYkbaagX3rNja0fhcA
        2e5j+ovv/CgsT+ZoDQoT+CWRcBYlMm8/lOCzJnI8bcxSmgnYL1DAcZSWBst0dkHelhtxxngQDBUxT
        Hx9EVeR2S5Mz+yNi92z/I6yF8ZJ5vD+bml2pnevTBqfWLDCV5GfF2ANaVlY2eds/yOXaokjcPxwkV
        c3eArFsA==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oSzuX-007pYR-IQ
        for fio@vger.kernel.org; Tue, 30 Aug 2022 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id BF7981BC0162; Tue, 30 Aug 2022 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220830120001.BF7981BC0162@kernel.dk>
Date:   Tue, 30 Aug 2022 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit a5a2429ece9b2a7e35e2b8a0248e7b1de6d075c3:

  t/io_uring: remove duplicate definition of gettid() (2022-08-26 14:17:40 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b68ba328173f5a4714d888f6ce80fd24a4e4c504:

  test: get 32-bit Ubuntu 22.04 build working (2022-08-29 16:42:18 -0400)

----------------------------------------------------------------
Vincent Fu (3):
      test: add some tests for seq and rand offsets
      test: use Ubuntu 22.04 for 64-bit tests
      test: get 32-bit Ubuntu 22.04 build working

 .github/workflows/ci.yml |  8 ++---
 ci/actions-install.sh    | 13 ++++----
 t/jobs/t0019.fio         | 10 ++++++
 t/jobs/t0020.fio         | 11 +++++++
 t/run-fio-tests.py       | 84 ++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 115 insertions(+), 11 deletions(-)
 create mode 100644 t/jobs/t0019.fio
 create mode 100644 t/jobs/t0020.fio

---

Diff of recent changes:

diff --git a/.github/workflows/ci.yml b/.github/workflows/ci.yml
index 650366b2..bdc4db85 100644
--- a/.github/workflows/ci.yml
+++ b/.github/workflows/ci.yml
@@ -18,18 +18,18 @@ jobs:
         - android
         include:
         - build: linux-gcc
-          os: ubuntu-20.04
+          os: ubuntu-22.04
           cc: gcc
         - build: linux-clang
-          os: ubuntu-20.04
+          os: ubuntu-22.04
           cc: clang
         - build: macos
           os: macos-11
         - build: linux-i686-gcc
-          os: ubuntu-20.04
+          os: ubuntu-22.04
           arch: i686
         - build: android
-          os: ubuntu-20.04
+          os: ubuntu-22.04
           arch: aarch64-linux-android32
 
     env:
diff --git a/ci/actions-install.sh b/ci/actions-install.sh
index b5c4198f..c209a089 100755
--- a/ci/actions-install.sh
+++ b/ci/actions-install.sh
@@ -23,26 +23,21 @@ DPKGCFG
         libcunit1-dev
         libcurl4-openssl-dev
         libfl-dev
-        libibverbs-dev
         libnuma-dev
-        librdmacm-dev
 	libnfs-dev
         valgrind
     )
     case "${CI_TARGET_ARCH}" in
         "i686")
             sudo dpkg --add-architecture i386
-            opts="--allow-downgrades"
             pkgs=("${pkgs[@]/%/:i386}")
             pkgs+=(
                 gcc-multilib
                 pkg-config:i386
                 zlib1g-dev:i386
-		libpcre2-8-0=10.34-7
             )
             ;;
         "x86_64")
-            opts=""
             pkgs+=(
                 libglusterfs-dev
                 libgoogle-perftools-dev
@@ -53,7 +48,11 @@ DPKGCFG
                 librbd-dev
                 libtcmalloc-minimal4
                 nvidia-cuda-dev
+                libibverbs-dev
+                librdmacm-dev
             )
+	    echo "Removing libunwind-14-dev because of conflicts with libunwind-dev"
+	    sudo apt remove -y libunwind-14-dev
             ;;
     esac
 
@@ -66,8 +65,8 @@ DPKGCFG
 
     echo "Updating APT..."
     sudo apt-get -qq update
-    echo "Installing packages..."
-    sudo apt-get install "$opts" -o APT::Immediate-Configure=false --no-install-recommends -qq -y "${pkgs[@]}"
+    echo "Installing packages... ${pkgs[@]}"
+    sudo apt-get install -o APT::Immediate-Configure=false --no-install-recommends -qq -y "${pkgs[@]}"
 }
 
 install_linux() {
diff --git a/t/jobs/t0019.fio b/t/jobs/t0019.fio
new file mode 100644
index 00000000..b60d27d2
--- /dev/null
+++ b/t/jobs/t0019.fio
@@ -0,0 +1,10 @@
+# Expected result: offsets are accessed sequentially and all offsets are read
+# Buggy result: offsets are not accessed sequentially and one or more offsets are missed
+# run with --debug=io or logging to see which offsets are accessed
+
+[test]
+ioengine=null
+filesize=1M
+write_bw_log=test
+per_job_logs=0
+log_offset=1
diff --git a/t/jobs/t0020.fio b/t/jobs/t0020.fio
new file mode 100644
index 00000000..1c1c5166
--- /dev/null
+++ b/t/jobs/t0020.fio
@@ -0,0 +1,11 @@
+# Expected result: offsets are not accessed sequentially and all offsets are touched
+# Buggy result: offsets are accessed sequentially and one or more offsets are missed
+# run with --debug=io or logging to see which offsets are read
+
+[test]
+ioengine=null
+filesize=1M
+rw=randread
+write_bw_log=test
+per_job_logs=0
+log_offset=1
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index 1e5e9f24..78f43521 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -548,6 +548,72 @@ class FioJobTest_t0015(FioJobTest):
             self.passed = False
 
 
+class FioJobTest_t0019(FioJobTest):
+    """Test consists of fio test job t0019
+    Confirm that all offsets were touched sequentially"""
+
+    def check_result(self):
+        super(FioJobTest_t0019, self).check_result()
+
+        bw_log_filename = os.path.join(self.test_dir, "test_bw.log")
+        file_data, success = self.get_file(bw_log_filename)
+        log_lines = file_data.split('\n')
+
+        prev = -4096
+        for line in log_lines:
+            if len(line.strip()) == 0:
+                continue
+            cur = int(line.split(',')[4])
+            if cur - prev != 4096:
+                self.passed = False
+                self.failure_reason = "offsets {0}, {1} not sequential".format(prev, cur)
+                return
+            prev = cur
+
+        if cur/4096 != 255:
+            self.passed = False
+            self.failure_reason = "unexpected last offset {0}".format(cur)
+
+
+class FioJobTest_t0020(FioJobTest):
+    """Test consists of fio test job t0020
+    Confirm that almost all offsets were touched non-sequentially"""
+
+    def check_result(self):
+        super(FioJobTest_t0020, self).check_result()
+
+        bw_log_filename = os.path.join(self.test_dir, "test_bw.log")
+        file_data, success = self.get_file(bw_log_filename)
+        log_lines = file_data.split('\n')
+
+        seq_count = 0
+        offsets = set()
+
+        prev = int(log_lines[0].split(',')[4])
+        for line in log_lines[1:]:
+            offsets.add(prev/4096)
+            if len(line.strip()) == 0:
+                continue
+            cur = int(line.split(',')[4])
+            if cur - prev == 4096:
+                seq_count += 1
+            prev = cur
+
+        # 10 is an arbitrary threshold
+        if seq_count > 10:
+            self.passed = False
+            self.failure_reason = "too many ({0}) consecutive offsets".format(seq_count)
+
+        if len(offsets) != 256:
+            self.passed = False
+            self.failure_reason += " number of offsets is {0} instead of 256".format(len(offsets))
+
+        for i in range(256):
+            if not i in offsets:
+                self.passed = False
+                self.failure_reason += " missing offset {0}".format(i*4096)
+
+
 class FioJobTest_iops_rate(FioJobTest):
     """Test consists of fio test job t0009
     Confirm that job0 iops == 1000
@@ -889,6 +955,24 @@ TEST_LIST = [
         'pre_success':      None,
         'requirements':     [Requirements.linux, Requirements.io_uring],
     },
+    {
+        'test_id':          19,
+        'test_class':       FioJobTest_t0019,
+        'job':              't0019.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          None,
+        'pre_success':      None,
+        'requirements':     [],
+    },
+    {
+        'test_id':          20,
+        'test_class':       FioJobTest_t0020,
+        'job':              't0020.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          None,
+        'pre_success':      None,
+        'requirements':     [],
+    },
     {
         'test_id':          1000,
         'test_class':       FioExeTest,
