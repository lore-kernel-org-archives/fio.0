Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbgLRNAr (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 18 Dec 2020 08:00:47 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56069C0617A7
        for <fio@vger.kernel.org>; Fri, 18 Dec 2020 05:00:07 -0800 (PST)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kqFMb-00010p-Lc
        for fio@vger.kernel.org; Fri, 18 Dec 2020 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20201218130002.6B1E11BC014F@kernel.dk>
Date: Fri, 18 Dec 2020 06:00:02 -0700 (MST)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit dee9b29bef5bc344815d7a53dda6bb21426f2bfa:

  Merge branch 'wip-rbd-engine-tweaks' of https://github.com/dillaman/fio (2020-12-15 09:18:28 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ced224611b039df68ceebde4733269f4f6606912:

  Merge branch 'github_issue' of https://github.com/sitsofe/fio (2020-12-17 16:09:54 -0700)

----------------------------------------------------------------
Erwan Velu (4):
      examples/fsx: Removing deprecated rwmixcycle options
      examples: Clarify time_based usage
      examples: Clarify thread usage
      examples: Clarify group_reporting usage

Jens Axboe (2):
      Merge branch 'evelu-examples' of https://github.com/ErwanAliasr1/fio
      Merge branch 'github_issue' of https://github.com/sitsofe/fio

Sitsofe Wheeler (1):
      docs: add new section to REPORTING-BUGS and github issue templates

 .github/ISSUE_TEMPLATE.md             |  5 +++++
 .github/ISSUE_TEMPLATE/bug-report.md  | 20 +++++++++++++++++++
 .github/ISSUE_TEMPLATE/config.yml     |  6 ++++++
 .github/ISSUE_TEMPLATE/enhancement.md | 11 +++++++++++
 .github/SUPPORT.md                    | 36 +++++++++++++++++++++++++++++++++++
 REPORTING-BUGS                        | 31 +++++++++++++++++++++++++-----
 examples/cpp_null.fio                 |  2 +-
 examples/cross-stripe-verify.fio      |  2 +-
 examples/dev-dax.fio                  |  4 ++--
 examples/e4defrag.fio                 |  2 +-
 examples/e4defrag2.fio                |  5 ++---
 examples/exitwhat.fio                 |  2 +-
 examples/falloc.fio                   |  4 ++--
 examples/fio-rand-RW.fio              |  2 +-
 examples/fio-rand-read.fio            |  2 +-
 examples/fio-rand-write.fio           |  2 +-
 examples/fio-seq-RW.fio               |  2 +-
 examples/fio-seq-read.fio             |  2 +-
 examples/fio-seq-write.fio            |  2 +-
 examples/fsx.fio                      |  1 -
 examples/jesd219.fio                  |  2 +-
 examples/libpmem.fio                  |  4 ++--
 examples/libzbc-rand-write.fio        |  2 +-
 examples/null.fio                     |  1 -
 examples/pmemblk.fio                  |  4 ++--
 examples/steadystate.fio              |  2 +-
 examples/surface-scan.fio             |  2 +-
 examples/waitfor.fio                  |  2 +-
 examples/zbd-rand-write.fio           |  2 +-
 29 files changed, 130 insertions(+), 34 deletions(-)
 create mode 100644 .github/ISSUE_TEMPLATE.md
 create mode 100644 .github/ISSUE_TEMPLATE/bug-report.md
 create mode 100644 .github/ISSUE_TEMPLATE/config.yml
 create mode 100644 .github/ISSUE_TEMPLATE/enhancement.md
 create mode 100644 .github/SUPPORT.md

---

Diff of recent changes:

diff --git a/.github/ISSUE_TEMPLATE.md b/.github/ISSUE_TEMPLATE.md
new file mode 100644
index 00000000..272968f8
--- /dev/null
+++ b/.github/ISSUE_TEMPLATE.md
@@ -0,0 +1,5 @@
+**Please acknowledge you have done the following before creating a ticket**
+
+- [ ] I have read the GitHub issues section of [REPORTING-BUGS](../blob/master/REPORTING-BUGS).
+
+<!-- replace me with bug report / enhancement request -->
diff --git a/.github/ISSUE_TEMPLATE/bug-report.md b/.github/ISSUE_TEMPLATE/bug-report.md
new file mode 100644
index 00000000..10738165
--- /dev/null
+++ b/.github/ISSUE_TEMPLATE/bug-report.md
@@ -0,0 +1,20 @@
+---
+name: Report a bug
+about: For bugs that are reproducible with the latest fio releases
+
+---
+
+**Please acknowledge the following before creating a ticket**
+
+- [ ] I have read the GitHub issues section of [REPORTING-BUGS](../blob/master/REPORTING-BUGS).
+
+**Description of the bug:**
+<!--replaceme-->
+
+**Environment**: <!-- Name and version of operating system -->
+
+**fio version**: <!--replaceme-->
+
+**Reproduction steps**
+<!-- Please minimise the job file/command line options down to only those
+necessary to reproduce the issue (https://stackoverflow.com/help/mcve ) -->
diff --git a/.github/ISSUE_TEMPLATE/config.yml b/.github/ISSUE_TEMPLATE/config.yml
new file mode 100644
index 00000000..c7e3b372
--- /dev/null
+++ b/.github/ISSUE_TEMPLATE/config.yml
@@ -0,0 +1,6 @@
+blank_issues_enabled: true
+
+contact_links:
+- name: General questions (e.g. "How do I...", "Why is...") that are related to fio
+  url: http://vger.kernel.org/vger-lists.html#fio
+  about: Please send questions to the fio mailing list (plain-text emails ONLY)
diff --git a/.github/ISSUE_TEMPLATE/enhancement.md b/.github/ISSUE_TEMPLATE/enhancement.md
new file mode 100644
index 00000000..1d4ba77d
--- /dev/null
+++ b/.github/ISSUE_TEMPLATE/enhancement.md
@@ -0,0 +1,11 @@
+---
+name: Feature enhancement request
+about: Suggest a new fio feature
+labels: enhancement
+
+---
+
+**Description of the new feature**
+<!-- Please be aware regular fio developers are busy with non-fio work. Because
+of this, most requests are only completed if someone from outside the project
+contributes the code. -->
diff --git a/.github/SUPPORT.md b/.github/SUPPORT.md
new file mode 100644
index 00000000..8d9df863
--- /dev/null
+++ b/.github/SUPPORT.md
@@ -0,0 +1,36 @@
+# Getting support for fio
+
+## General questions
+
+Please use the fio mailing list for asking general fio questions (e.g. "How do
+I do X?", "Why does Y happen?"). See the Mailing list section of the
+[README][readme] for details).
+
+## Reporting bugs
+
+As mentioned in [REPORTING-BUGS][reportingbugs], fio bugs and enhancements can
+be reported to the fio mailing list or fio's GitHub issues tracker.
+
+When reporting bugs please include ALL of the following:
+- Description of the issue
+- fio version number tested. If your fio isn't among the recent releases (see
+  the [fio releases page][releases]) please build a new one from source (see
+  the Source and Building sections of the [README][readme] for how to do this)
+  and reproduce the issue with the fresh build before filing an issue.
+- Reproduction steps and minimal job file/command line parameters.
+
+When requesting an enhancement only the description is needed.
+
+### GitHub issues specific information
+
+[Formatting terminal output with markdown][quotingcode] will help people who
+are reading your report. However, if the output is large (e.g. over 15 lines
+long) please consider including it as a text attachment. Avoid attaching
+pictures of screenshots as these are not searchable/selectable.
+
+<!-- Definitions -->
+
+[readme]: ../README
+[reportingbugs]: ../REPORTING-BUGS
+[releases]: ../../../releases
+[quotingcode]: https://docs.github.com/en/free-pro-team@latest/github/writing-on-github/basic-writing-and-formatting-syntax#quoting-code
diff --git a/REPORTING-BUGS b/REPORTING-BUGS
index 327b6caa..c0204d7e 100644
--- a/REPORTING-BUGS
+++ b/REPORTING-BUGS
@@ -1,16 +1,20 @@
 Reporting a bug
 ---------------
 
-If you notice anything that seems like a fio bug, please do send email
-to the list (fio@vger.kernel.org, see README) about it. If you are not
-running the newest release of fio, upgrading first is recommended.
+...via the mailing list
+=======================
+
+If you notice anything that seems like a fio bug or want to ask fio related
+questions, please send a plain-text only email to the list
+(fio@vger.kernel.org, see README) about it. If you are not running the newest
+release of fio please upgrade first.
 
 When reporting a bug, you'll need to include:
 
 1) A description of what you think the bug is
-2) Environment (Linux distro version, kernel version). This is mostly
+2) Environment (e.g. Linux distro version, kernel version). This is mostly
    needed if it's a build bug.
-3) The output from fio --version.
+3) The output from fio --version .
 4) How to reproduce. Please include a full list of the parameters
    passed to fio and the job file used (if any).
 
@@ -19,3 +23,20 @@ is left out and has to be asked for will add to the turn-around time
 of getting to the bottom of the issue, and an eventual fix.
 
 That's it!
+
+...via GitHub issues
+====================
+
+Please create an issue in the GitHub issue tracker
+(https://github.com/axboe/fio/issues ) but observe the following:
+
+a) If you are asking a question on how to do something ("How do I/Why is?")
+   please send it to the mailing list and not GitHub issues. The fio project
+   uses GitHub issues for reproducible bugs/enhancement requests.
+b) Please reproduce your bug using the latest fio listed on
+   https://github.com/axboe/fio/releases (see the Source and Building sections
+   of the README for how to build fio from source).
+c) Include all of the information requested in the mailing list section above
+   (description, environment, version, reproduction steps and all job parameters).
+
+Thanks!
diff --git a/examples/cpp_null.fio b/examples/cpp_null.fio
index 436ed90a..7c62beaf 100644
--- a/examples/cpp_null.fio
+++ b/examples/cpp_null.fio
@@ -7,4 +7,4 @@ ioengine=cpp_null
 size=100g
 rw=randread
 norandommap
-time_based=0
+time_based
diff --git a/examples/cross-stripe-verify.fio b/examples/cross-stripe-verify.fio
index 68664ed0..47c0889c 100644
--- a/examples/cross-stripe-verify.fio
+++ b/examples/cross-stripe-verify.fio
@@ -17,7 +17,7 @@ verify_backlog=1
 offset_increment=124g
 io_size=120g
 offset=120k
-group_reporting=1
+group_reporting
 verify_dump=1
 loops=2
 
diff --git a/examples/dev-dax.fio b/examples/dev-dax.fio
index d9f430eb..88bce31b 100644
--- a/examples/dev-dax.fio
+++ b/examples/dev-dax.fio
@@ -2,7 +2,7 @@
 bs=2m
 ioengine=dev-dax
 norandommap
-time_based=1
+time_based
 runtime=30
 group_reporting
 disable_lat=1
@@ -18,7 +18,7 @@ cpus_allowed_policy=split
 #
 iodepth=1
 direct=0
-thread=1
+thread
 numjobs=16
 #
 # The dev-dax engine does IO to DAX device that are special character
diff --git a/examples/e4defrag.fio b/examples/e4defrag.fio
index cb94e85a..d6495f7a 100644
--- a/examples/e4defrag.fio
+++ b/examples/e4defrag.fio
@@ -18,7 +18,7 @@ rw=write
 # Run e4defrag and aio-dio workers in parallel
 [e4defrag]
 stonewall
-time_based=30
+time_based
 runtime=30
 ioengine=e4defrag
 buffered=0
diff --git a/examples/e4defrag2.fio b/examples/e4defrag2.fio
index c6485997..2d4e1a87 100644
--- a/examples/e4defrag2.fio
+++ b/examples/e4defrag2.fio
@@ -55,7 +55,7 @@ inplace=1
 bs=4k
 donorname=file3.def
 filename=file3
-time_based=30
+time_based
 rw=randwrite
 
 [buffered-aio-32k]
@@ -68,7 +68,7 @@ bs=32k
 filename=file3
 rw=randrw
 runtime=30
-time_based=30
+time_based
 numjobs=4
 
 [direct-aio-32k]
@@ -82,7 +82,6 @@ bs=32k
 filename=file3
 rw=randrw
 runtime=30
-time_based=30
 numjobs=4
 
 
diff --git a/examples/exitwhat.fio b/examples/exitwhat.fio
index c91d7375..864508c6 100644
--- a/examples/exitwhat.fio
+++ b/examples/exitwhat.fio
@@ -11,7 +11,7 @@
 filename=/tmp/test
 filesize=1G
 blocksize=4096
-group_reporting=1
+group_reporting
 exitall=1
 
 [slow1]
diff --git a/examples/falloc.fio b/examples/falloc.fio
index fa307314..fadf1321 100644
--- a/examples/falloc.fio
+++ b/examples/falloc.fio
@@ -15,7 +15,7 @@ group_reporting
 [falloc-fuzzer]
 stonewall
 runtime=10
-time_based=10
+time_based
 bssplit=4k/10:64k/50:32k/40
 rw=randwrite
 numjobs=1
@@ -24,7 +24,7 @@ filename=fragmented_file
 [punch hole-fuzzer]
 bs=4k
 runtime=10
-time_based=10
+time_based
 rw=randtrim
 numjobs=2
 filename=fragmented_file
diff --git a/examples/fio-rand-RW.fio b/examples/fio-rand-RW.fio
index 0df0bc17..a1074a1a 100644
--- a/examples/fio-rand-RW.fio
+++ b/examples/fio-rand-RW.fio
@@ -9,7 +9,7 @@ rwmixwrite=40
 bs=4K
 direct=0
 numjobs=4
-time_based=1
+time_based
 runtime=900
 
 [file1]
diff --git a/examples/fio-rand-read.fio b/examples/fio-rand-read.fio
index bc154668..319a9209 100644
--- a/examples/fio-rand-read.fio
+++ b/examples/fio-rand-read.fio
@@ -7,7 +7,7 @@ rw=randread
 bs=4K
 direct=0
 numjobs=1
-time_based=1
+time_based
 runtime=900
 
 [file1]
diff --git a/examples/fio-rand-write.fio b/examples/fio-rand-write.fio
index bd1b73a9..55ededbd 100644
--- a/examples/fio-rand-write.fio
+++ b/examples/fio-rand-write.fio
@@ -7,7 +7,7 @@ rw=randwrite
 bs=4K
 direct=0
 numjobs=4
-time_based=1
+time_based
 runtime=900
 
 [file1]
diff --git a/examples/fio-seq-RW.fio b/examples/fio-seq-RW.fio
index 8f7090f3..89e5c679 100644
--- a/examples/fio-seq-RW.fio
+++ b/examples/fio-seq-RW.fio
@@ -9,7 +9,7 @@ rwmixwrite=40
 bs=256K
 direct=0
 numjobs=4
-time_based=1
+time_based
 runtime=900
 
 [file1]
diff --git a/examples/fio-seq-read.fio b/examples/fio-seq-read.fio
index 28de93c8..2b272480 100644
--- a/examples/fio-seq-read.fio
+++ b/examples/fio-seq-read.fio
@@ -5,7 +5,7 @@ rw=read
 bs=256K
 direct=1
 numjobs=1
-time_based=1
+time_based
 runtime=900
 
 [file1]
diff --git a/examples/fio-seq-write.fio b/examples/fio-seq-write.fio
index b291a15a..ac6c9eef 100644
--- a/examples/fio-seq-write.fio
+++ b/examples/fio-seq-write.fio
@@ -7,7 +7,7 @@ rw=write
 bs=256K
 direct=0
 numjobs=1
-time_based=1
+time_based
 runtime=900
 
 [file1]
diff --git a/examples/fsx.fio b/examples/fsx.fio
index 6b48c6fd..22152dc0 100644
--- a/examples/fsx.fio
+++ b/examples/fsx.fio
@@ -9,4 +9,3 @@ bs=4k
 norandommap
 direct=1
 loops=500000
-rwmixcycle=40
diff --git a/examples/jesd219.fio b/examples/jesd219.fio
index 24f16f77..deddd9a7 100644
--- a/examples/jesd219.fio
+++ b/examples/jesd219.fio
@@ -17,4 +17,4 @@ bssplit=512/4:1024/1:1536/1:2048/1:2560/1:3072/1:3584/1:4k/67:8k/10:16k/7:32k/3:
 blockalign=4k
 random_distribution=zoned:50/5:30/15:20/80
 filename=/dev/nvme0n1
-group_reporting=1
+group_reporting
diff --git a/examples/libpmem.fio b/examples/libpmem.fio
index 65b1d687..0ff681f0 100644
--- a/examples/libpmem.fio
+++ b/examples/libpmem.fio
@@ -3,7 +3,7 @@ bs=4k
 size=8g
 ioengine=libpmem
 norandommap
-time_based=1
+time_based
 group_reporting
 invalidate=1
 disable_lat=1
@@ -13,7 +13,7 @@ clat_percentiles=0
 
 iodepth=1
 iodepth_batch=1
-thread=1
+thread
 numjobs=1
 runtime=300
 
diff --git a/examples/libzbc-rand-write.fio b/examples/libzbc-rand-write.fio
index ce5870e4..41496219 100644
--- a/examples/libzbc-rand-write.fio
+++ b/examples/libzbc-rand-write.fio
@@ -12,7 +12,7 @@ max_open_zones=32
 bs=512K
 direct=1
 numjobs=16
-time_based=1
+time_based
 runtime=300
 
 [dev1]
diff --git a/examples/null.fio b/examples/null.fio
index 9d2f3e00..4534cbdd 100644
--- a/examples/null.fio
+++ b/examples/null.fio
@@ -7,4 +7,3 @@ ioengine=null
 size=100g
 rw=randread
 norandommap
-time_based=0
diff --git a/examples/pmemblk.fio b/examples/pmemblk.fio
index 2d5ecfce..f8131741 100644
--- a/examples/pmemblk.fio
+++ b/examples/pmemblk.fio
@@ -2,7 +2,7 @@
 bs=1m
 ioengine=pmemblk
 norandommap
-time_based=1
+time_based
 runtime=30
 group_reporting
 disable_lat=1
@@ -19,7 +19,7 @@ cpus_allowed_policy=split
 #
 iodepth=1
 direct=1
-thread=1
+thread
 numjobs=16
 #
 # Unlink can be used to remove the files when done, but if you are
diff --git a/examples/steadystate.fio b/examples/steadystate.fio
index 26fb8083..a38a3438 100644
--- a/examples/steadystate.fio
+++ b/examples/steadystate.fio
@@ -7,7 +7,7 @@
 
 [global]
 threads=1
-group_reporting=1
+group_reporting
 time_based
 size=128m
 
diff --git a/examples/surface-scan.fio b/examples/surface-scan.fio
index dc3373a2..98faf69a 100644
--- a/examples/surface-scan.fio
+++ b/examples/surface-scan.fio
@@ -1,7 +1,7 @@
 ; writes 512 byte verification blocks until the disk is full,
 ; then verifies written data
 [global]
-thread=1
+thread
 bs=64k
 direct=1
 ioengine=sync
diff --git a/examples/waitfor.fio b/examples/waitfor.fio
index 95fad005..096c3153 100644
--- a/examples/waitfor.fio
+++ b/examples/waitfor.fio
@@ -1,6 +1,6 @@
 [global]
 threads=1
-group_reporting=1
+group_reporting
 filename=/tmp/data
 filesize=128m
 
diff --git a/examples/zbd-rand-write.fio b/examples/zbd-rand-write.fio
index 1b3f2088..46cddd06 100644
--- a/examples/zbd-rand-write.fio
+++ b/examples/zbd-rand-write.fio
@@ -12,7 +12,7 @@ max_open_zones=32
 bs=512K
 direct=1
 numjobs=16
-time_based=1
+time_based
 runtime=180
 
 [dev1]

