Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:36706 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727202AbeJFTDM (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 6 Oct 2018 15:03:12 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g8lFl-0002fH-Cz
        for fio@vger.kernel.org; Sat, 06 Oct 2018 12:00:13 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20181006120001.B16A52C288D@kernel.dk>
Date: Sat,  6 Oct 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit f1867a7f9e588acf67cf8fa96eab8a6e2fdedcf6:

  Bool conversions (2018-10-04 09:07:01 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5857e8e0f53e81bd7096209fe5cabf91ce74b853:

  Merge branch 'patch-1' of https://github.com/joaomlneto/fio (2018-10-05 19:11:19 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      Add cross-stripe intel sample verify job
      Merge branch 'patch-1' of https://github.com/joaomlneto/fio

Jo��o Neto (1):
      Be careful when defining `MPOL_LOCAL`

 examples/cross-stripe-verify.fio | 25 +++++++++++++++++++++++++
 fio.h                            |  4 +++-
 2 files changed, 28 insertions(+), 1 deletion(-)
 create mode 100644 examples/cross-stripe-verify.fio

---

Diff of recent changes:

diff --git a/examples/cross-stripe-verify.fio b/examples/cross-stripe-verify.fio
new file mode 100644
index 0000000..68664ed
--- /dev/null
+++ b/examples/cross-stripe-verify.fio
@@ -0,0 +1,25 @@
+# Example of how to split a drive up into sections, manually, and perform
+# verify from a bunch of jobs. This example is special in that it assumes
+# the drive is at around 30 * 124G in size, so with the below settings, we'll
+# cover most of the drive. It's also special in that it doesn't write
+# everything, it just writes 16k at a specific boundary, for every 128k.
+# This is done to exercise the split path for Intel NVMe devices, most of
+# which have a 128k stripe size and require IOs to be split if the cross
+# the stripe boundary.
+#
+[global]
+bs=16k
+direct=1
+rw=write:112k
+verify=crc32c
+filename=/dev/nvme0n1
+verify_backlog=1
+offset_increment=124g
+io_size=120g
+offset=120k
+group_reporting=1
+verify_dump=1
+loops=2
+
+[write-verify]
+numjobs=30
diff --git a/fio.h b/fio.h
index 7b6611a..53bcda1 100644
--- a/fio.h
+++ b/fio.h
@@ -57,7 +57,9 @@
 /*
  * "local" is pseudo-policy
  */
-#define MPOL_LOCAL MPOL_MAX
+#ifndef MPOL_LOCAL
+#define MPOL_LOCAL 4
+#endif
 #endif
 
 #ifdef CONFIG_CUDA

