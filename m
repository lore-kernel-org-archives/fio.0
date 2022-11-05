Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB279C433FE
	for <fio@archiver.kernel.org>; Sat,  5 Nov 2022 12:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbiKEMAK (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 5 Nov 2022 08:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiKEMAK (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 5 Nov 2022 08:00:10 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B71B76241
        for <fio@vger.kernel.org>; Sat,  5 Nov 2022 05:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=uP5zwb4C8AKFq3m7fiTy4tDh3MVmhRVi/QLlObIpA0Y=; b=ZKeZ4MdVBlbbORdf6cx71pyXPQ
        K0i4ihh9PN9NFtnkpOB+AmKEelJgXgyJLaGfoOwb7cWPlc7KoUVVcIBVrn2QazW86PNWjONokHZdT
        jCKgdd+nQQzP+Q2X9HJbyFSVyZlWek0Huk3ul/IPYSiK4Qw1STdAx3f5VdeTnlyFh7c0Bdg53CPYX
        yflQQJrwvvbaIartGsSFAFAs1PyB3TQZNT6kJL659Zysz2XMX9WdCrvCCQsvQzyBRPaaJsTBLVwGh
        jsJrzoiUhBhViafa4oYeSftMWBzc2AQ5vI+AmY4S3dT5Olz0gLrnFtiDijKCwlSvD2baRjeaKPCF1
        kTNuGing==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1orHqH-009FCJ-9O
        for fio@vger.kernel.org; Sat, 05 Nov 2022 12:00:07 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id E7D5B1BC0162; Sat,  5 Nov 2022 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20221105120001.E7D5B1BC0162@kernel.dk>
Date:   Sat,  5 Nov 2022 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 7fc3a553beadd15cac09b1514547c4d382d292d9:

  HOWTO: clean up exit_what description (2022-11-02 10:26:36 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 02ee8a1ba7ea798f03fb029f589382b6f799be24:

  test: use homebrew to install sphinx instead of pip on macOS (2022-11-04 13:50:31 -0400)

----------------------------------------------------------------
Ankit Kumar (1):
      io_uring: update documentation and small fix for sqthread_poll

Vincent Fu (2):
      test: change GitHub Actions macOS platform to macOS 12
      test: use homebrew to install sphinx instead of pip on macOS

 .github/workflows/ci.yml | 2 +-
 HOWTO.rst                | 6 +++---
 ci/actions-install.sh    | 5 +++--
 engines/io_uring.c       | 2 +-
 fio.1                    | 6 +++---
 5 files changed, 11 insertions(+), 10 deletions(-)

---

Diff of recent changes:

diff --git a/.github/workflows/ci.yml b/.github/workflows/ci.yml
index 1b8c0701..4bc91d3e 100644
--- a/.github/workflows/ci.yml
+++ b/.github/workflows/ci.yml
@@ -24,7 +24,7 @@ jobs:
           os: ubuntu-22.04
           cc: clang
         - build: macos
-          os: macos-11
+          os: macos-12
         - build: linux-i686-gcc
           os: ubuntu-22.04
           arch: i686
diff --git a/HOWTO.rst b/HOWTO.rst
index 0fb5593e..e796f961 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2274,7 +2274,7 @@ with the caveat that when used on the command line, they must come after the
 	map and release for each IO. This is more efficient, and reduces the
 	IO latency as well.
 
-.. option:: nonvectored : [io_uring] [io_uring_cmd]
+.. option:: nonvectored=int : [io_uring] [io_uring_cmd]
 
 	With this option, fio will use non-vectored read/write commands, where
 	address must contain the address directly. Default is -1.
@@ -2301,7 +2301,7 @@ with the caveat that when used on the command line, they must come after the
 	This frees up cycles for fio, at the cost of using more CPU in the
 	system.
 
-.. option:: sqthread_poll_cpu : [io_uring] [io_uring_cmd]
+.. option:: sqthread_poll_cpu=int : [io_uring] [io_uring_cmd]
 
 	When :option:`sqthread_poll` is set, this option provides a way to
 	define which CPU should be used for the polling thread.
@@ -2351,7 +2351,7 @@ with the caveat that when used on the command line, they must come after the
 	When hipri is set this determines the probability of a pvsync2 I/O being high
 	priority. The default is 100%.
 
-.. option:: nowait : [pvsync2] [libaio] [io_uring]
+.. option:: nowait=bool : [pvsync2] [libaio] [io_uring] [io_uring_cmd]
 
 	By default if a request cannot be executed immediately (e.g. resource starvation,
 	waiting on locks) it is queued and the initiating process will be blocked until
diff --git a/ci/actions-install.sh b/ci/actions-install.sh
index 82e14d2a..c16dff16 100755
--- a/ci/actions-install.sh
+++ b/ci/actions-install.sh
@@ -84,8 +84,9 @@ install_macos() {
     #echo "Updating homebrew..."
     #brew update >/dev/null 2>&1
     echo "Installing packages..."
-    HOMEBREW_NO_AUTO_UPDATE=1 brew install cunit libnfs
-    pip3 install scipy six sphinx
+    HOMEBREW_NO_AUTO_UPDATE=1 brew install cunit libnfs sphinx-doc
+    brew link sphinx-doc --force
+    pip3 install scipy six 
 }
 
 main() {
diff --git a/engines/io_uring.c b/engines/io_uring.c
index 6906e0a4..3c656b77 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -226,7 +226,7 @@ static struct fio_option options[] = {
 	{
 		.name	= "sqthread_poll",
 		.lname	= "Kernel SQ thread polling",
-		.type	= FIO_OPT_INT,
+		.type	= FIO_OPT_STR_SET,
 		.off1	= offsetof(struct ioring_options, sqpoll_thread),
 		.help	= "Offload submission/completion to kernel thread",
 		.category = FIO_OPT_C_ENGINE,
diff --git a/fio.1 b/fio.1
index 4324a975..9e33c9e1 100644
--- a/fio.1
+++ b/fio.1
@@ -2063,7 +2063,7 @@ release them when IO is done. If this option is set, the pages are pre-mapped
 before IO is started. This eliminates the need to map and release for each IO.
 This is more efficient, and reduces the IO latency as well.
 .TP
-.BI (io_uring,io_uring_cmd)nonvectored
+.BI (io_uring,io_uring_cmd)nonvectored \fR=\fPint
 With this option, fio will use non-vectored read/write commands, where address
 must contain the address directly. Default is -1.
 .TP
@@ -2092,7 +2092,7 @@ available items in the SQ ring. If this option is set, the act of submitting IO
 will be done by a polling thread in the kernel. This frees up cycles for fio, at
 the cost of using more CPU in the system.
 .TP
-.BI (io_uring,io_uring_cmd)sqthread_poll_cpu
+.BI (io_uring,io_uring_cmd)sqthread_poll_cpu \fR=\fPint
 When `sqthread_poll` is set, this option provides a way to define which CPU
 should be used for the polling thread.
 .TP
@@ -2115,7 +2115,7 @@ than normal.
 When hipri is set this determines the probability of a pvsync2 I/O being high
 priority. The default is 100%.
 .TP
-.BI (pvsync2,libaio,io_uring)nowait
+.BI (pvsync2,libaio,io_uring,io_uring_cmd)nowait \fR=\fPbool
 By default if a request cannot be executed immediately (e.g. resource starvation,
 waiting on locks) it is queued and the initiating process will be blocked until
 the required resource becomes free.
