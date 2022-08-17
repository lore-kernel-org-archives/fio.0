Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3120DC25B08
	for <fio@archiver.kernel.org>; Wed, 17 Aug 2022 12:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbiHQMAJ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 17 Aug 2022 08:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234451AbiHQMAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 17 Aug 2022 08:00:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD83683BFE
        for <fio@vger.kernel.org>; Wed, 17 Aug 2022 05:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=pZel6Ec1mfE+0+D3NFbe1kXU2ewGpCjXMSlqb6I7IYM=; b=N/vv87NcKTDdprTmXk4130iwvK
        74f90w8j5gh6/+iQGPcprWsl9DChkZJIFmWx5imM8Hsut+7msPt7faiCxYCmME9I3J6oR7bW0gHrn
        Ahs08B4PnvmzeknEyM+RRl8EE2/5ZC2gWoVUgDTpqfcGZf7smXoVY97wTsI/jJCMMCFKYJao4ekaU
        7Sx7xx248uDkE0knoBycc7ojbifWar5SAPt6qZljCqpzQlq6ueLZ2/93WBkmjEqLmmS0VkG5QM1ZN
        SdmxVTEzn04bokyZB3MnOkeyBUONoyTN/vTeXGp+45aRTNnZ9wf77ojsNnvP+3Mxiz4LL8k4iMjQV
        ZHcb+2lA==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oOHiP-0088fm-3M
        for fio@vger.kernel.org; Wed, 17 Aug 2022 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 260CA1BC011A; Wed, 17 Aug 2022 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220817120002.260CA1BC011A@kernel.dk>
Date:   Wed, 17 Aug 2022 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit eeb302f9bfa4bbe121cae2a12a679c888164fc93:

  README: link to GitHub releases for Windows (2022-08-15 10:37:57 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d33c7846cc5f175177e194a5489282780e2a04c4:

  Merge branch 'clarify-io-errors' of https://github.com/Hi-Angel/fio (2022-08-16 19:54:17 -0600)

----------------------------------------------------------------
Ankit Kumar (2):
      engines/xnvme: fix segfault issue with xnvme ioengine
      doc: update fio doc for xnvme engine

Jens Axboe (1):
      Merge branch 'clarify-io-errors' of https://github.com/Hi-Angel/fio

Konstantin Kharlamov (2):
      doc: get rid of trailing whitespace
      doc: clarify that I/O errors may go unnoticed without direct=1

Vincent Fu (2):
      test: add latency test using posixaio ioengine
      test: fix hash for t0016

 HOWTO.rst                                        | 48 +++++++++++++++------
 engines/xnvme.c                                  | 17 ++++++--
 fio.1                                            | 54 ++++++++++++++++--------
 t/jobs/{t0016-259ebc00.fio => t0016-d54ae22.fio} |  0
 t/jobs/t0017.fio                                 |  9 ++++
 t/run-fio-tests.py                               | 12 +++++-
 6 files changed, 105 insertions(+), 35 deletions(-)
 rename t/jobs/{t0016-259ebc00.fio => t0016-d54ae22.fio} (100%)
 create mode 100644 t/jobs/t0017.fio

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 05fc117f..08be687c 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1301,7 +1301,7 @@ I/O type
 	effectively caps the file size at `real_size - offset`. Can be combined with
 	:option:`size` to constrain the start and end range of the I/O workload.
 	A percentage can be specified by a number between 1 and 100 followed by '%',
-	for example, ``offset=20%`` to specify 20%. In ZBD mode, value can be set as 
+	for example, ``offset=20%`` to specify 20%. In ZBD mode, value can be set as
         number of zones using 'z'.
 
 .. option:: offset_align=int
@@ -1877,7 +1877,7 @@ I/O size
 	If this option is not specified, fio will use the full size of the given
 	files or devices.  If the files do not exist, size must be given. It is also
 	possible to give size as a percentage between 1 and 100. If ``size=20%`` is
-	given, fio will use 20% of the full size of the given files or devices. 
+	given, fio will use 20% of the full size of the given files or devices.
 	In ZBD mode, value can also be set as number of zones using 'z'.
 	Can be combined with :option:`offset` to constrain the start and end range
 	that I/O will be done within.
@@ -2780,41 +2780,56 @@ with the caveat that when used on the command line, they must come after the
 	Select the xnvme async command interface. This can take these values.
 
 	**emu**
-		This is default and used to emulate asynchronous I/O.
+		This is default and use to emulate asynchronous I/O by using a
+		single thread to create a queue pair on top of a synchronous
+		I/O interface using the NVMe driver IOCTL.
 	**thrpool**
-		Use thread pool for Asynchronous I/O.
+		Emulate an asynchronous I/O interface with a pool of userspace
+		threads on top of a synchronous I/O interface using the NVMe
+		driver IOCTL. By default four threads are used.
 	**io_uring**
-		Use Linux io_uring/liburing for Asynchronous I/O.
+		Linux native asynchronous I/O interface which supports both
+		direct and buffered I/O.
+	**io_uring_cmd**
+		Fast Linux native asynchronous I/O interface for NVMe pass
+		through commands. This only works with NVMe character device
+		(/dev/ngXnY).
 	**libaio**
 		Use Linux aio for Asynchronous I/O.
 	**posix**
-		Use POSIX aio for Asynchronous I/O.
+		Use the posix asynchronous I/O interface to perform one or
+		more I/O operations asynchronously.
 	**nil**
-		Use nil-io; For introspective perf. evaluation
+		Do not transfer any data; just pretend to. This is mainly used
+		for introspective performance evaluation.
 
 .. option:: xnvme_sync=str : [xnvme]
 
 	Select the xnvme synchronous command interface. This can take these values.
 
 	**nvme**
-		This is default and uses Linux NVMe Driver ioctl() for synchronous I/O.
+		This is default and uses Linux NVMe Driver ioctl() for
+		synchronous I/O.
 	**psync**
-		Use pread()/write() for synchronous I/O.
+		This supports regular as well as vectored pread() and pwrite()
+		commands.
+	**block**
+		This is the same as psync except that it also supports zone
+		management commands using Linux block layer IOCTLs.
 
 .. option:: xnvme_admin=str : [xnvme]
 
 	Select the xnvme admin command interface. This can take these values.
 
 	**nvme**
-		This is default and uses linux NVMe Driver ioctl() for admin commands.
+		This is default and uses linux NVMe Driver ioctl() for admin
+		commands.
 	**block**
 		Use Linux Block Layer ioctl() and sysfs for admin commands.
-	**file_as_ns**
-		Use file-stat to construct NVMe idfy responses.
 
 .. option:: xnvme_dev_nsid=int : [xnvme]
 
-	xnvme namespace identifier, for userspace NVMe driver.
+	xnvme namespace identifier for userspace NVMe driver, such as SPDK.
 
 .. option:: xnvme_iovec=int : [xnvme]
 
@@ -3912,6 +3927,13 @@ Error handling
 	appended, the total error count and the first error. The error field given
 	in the stats is the first error that was hit during the run.
 
+	Note: a write error from the device may go unnoticed by fio when using
+	buffered IO, as the write() (or similar) system call merely dirties the
+	kernel pages, unless :option:`sync` or :option:`direct` is used. Device IO
+	errors occur when the dirty data is actually written out to disk. If fully
+	sync writes aren't desirable, :option:`fsync` or :option:`fdatasync` can be
+	used as well. This is specific to writes, as reads are always synchronous.
+
 	The allowed values are:
 
 		**none**
diff --git a/engines/xnvme.c b/engines/xnvme.c
index c11b33a8..d8647481 100644
--- a/engines/xnvme.c
+++ b/engines/xnvme.c
@@ -205,9 +205,14 @@ static void _dev_close(struct thread_data *td, struct xnvme_fioe_fwrap *fwrap)
 
 static void xnvme_fioe_cleanup(struct thread_data *td)
 {
-	struct xnvme_fioe_data *xd = td->io_ops_data;
+	struct xnvme_fioe_data *xd = NULL;
 	int err;
 
+	if (!td->io_ops_data)
+		return;
+
+	xd = td->io_ops_data;
+
 	err = pthread_mutex_lock(&g_serialize);
 	if (err)
 		log_err("ioeng->cleanup(): pthread_mutex_lock(), err(%d)\n", err);
@@ -367,8 +372,14 @@ static int xnvme_fioe_iomem_alloc(struct thread_data *td, size_t total_mem)
 /* NOTE: using the first device for buffer-allocators) */
 static void xnvme_fioe_iomem_free(struct thread_data *td)
 {
-	struct xnvme_fioe_data *xd = td->io_ops_data;
-	struct xnvme_fioe_fwrap *fwrap = &xd->files[0];
+	struct xnvme_fioe_data *xd = NULL;
+	struct xnvme_fioe_fwrap *fwrap = NULL;
+
+	if (!td->io_ops_data)
+		return;
+
+	xd = td->io_ops_data;
+	fwrap = &xd->files[0];
 
 	if (!fwrap->dev) {
 		log_err("ioeng->iomem_free(): failed no dev-handle\n");
diff --git a/fio.1 b/fio.1
index 6630525f..27454b0b 100644
--- a/fio.1
+++ b/fio.1
@@ -292,7 +292,7 @@ For Zone Block Device Mode:
 .RS
 .P
 .PD 0
-z means Zone 
+z means Zone
 .P
 .PD
 .RE
@@ -1083,7 +1083,7 @@ provided. Data before the given offset will not be touched. This
 effectively caps the file size at `real_size \- offset'. Can be combined with
 \fBsize\fR to constrain the start and end range of the I/O workload.
 A percentage can be specified by a number between 1 and 100 followed by '%',
-for example, `offset=20%' to specify 20%. In ZBD mode, value can be set as 
+for example, `offset=20%' to specify 20%. In ZBD mode, value can be set as
 number of zones using 'z'.
 .TP
 .BI offset_align \fR=\fPint
@@ -1099,7 +1099,7 @@ specified). This option is useful if there are several jobs which are
 intended to operate on a file in parallel disjoint segments, with even
 spacing between the starting points. Percentages can be used for this option.
 If a percentage is given, the generated offset will be aligned to the minimum
-\fBblocksize\fR or to the value of \fBoffset_align\fR if provided.In ZBD mode, value 
+\fBblocksize\fR or to the value of \fBoffset_align\fR if provided.In ZBD mode, value
 can be set as number of zones using 'z'.
 .TP
 .BI number_ios \fR=\fPint
@@ -1678,7 +1678,7 @@ If this option is not specified, fio will use the full size of the given
 files or devices. If the files do not exist, size must be given. It is also
 possible to give size as a percentage between 1 and 100. If `size=20%' is
 given, fio will use 20% of the full size of the given files or devices. In ZBD mode,
-size can be given in units of number of zones using 'z'. Can be combined with \fBoffset\fR to 
+size can be given in units of number of zones using 'z'. Can be combined with \fBoffset\fR to
 constrain the start and end range that I/O will be done within.
 .TP
 .BI io_size \fR=\fPint[%|z] "\fR,\fB io_limit" \fR=\fPint[%|z]
@@ -1697,7 +1697,7 @@ also be set as number of zones using 'z'.
 .BI filesize \fR=\fPirange(int)
 Individual file sizes. May be a range, in which case fio will select sizes
 for files at random within the given range. If not given, each created file
-is the same size. This option overrides \fBsize\fR in terms of file size, 
+is the same size. This option overrides \fBsize\fR in terms of file size,
 i.e. \fBsize\fR becomes merely the default for \fBio_size\fR (and
 has no effect it all if \fBio_size\fR is set explicitly).
 .TP
@@ -2530,22 +2530,29 @@ Select the xnvme async command interface. This can take these values.
 .RS
 .TP
 .B emu
-This is default and used to emulate asynchronous I/O
+This is default and use to emulate asynchronous I/O by using a single thread to
+create a queue pair on top of a synchronous I/O interface using the NVMe driver
+IOCTL.
 .TP
 .BI thrpool
-Use thread pool for Asynchronous I/O
+Emulate an asynchronous I/O interface with a pool of userspace threads on top
+of a synchronous I/O interface using the NVMe driver IOCTL. By default four
+threads are used.
 .TP
 .BI io_uring
-Use Linux io_uring/liburing for Asynchronous I/O
+Linux native asynchronous I/O interface which supports both direct and buffered
+I/O.
 .TP
 .BI libaio
 Use Linux aio for Asynchronous I/O
 .TP
 .BI posix
-Use POSIX aio for Asynchronous I/O
+Use the posix asynchronous I/O interface to perform one or more I/O operations
+asynchronously.
 .TP
 .BI nil
-Use nil-io; For introspective perf. evaluation
+Do not transfer any data; just pretend to. This is mainly used for
+introspective performance evaluation.
 .RE
 .RE
 .TP
@@ -2555,10 +2562,14 @@ Select the xnvme synchronous command interface. This can take these values.
 .RS
 .TP
 .B nvme
-This is default and uses Linux NVMe Driver ioctl() for synchronous I/O
+This is default and uses Linux NVMe Driver ioctl() for synchronous I/O.
 .TP
 .BI psync
-Use pread()/write() for synchronous I/O
+This supports regular as well as vectored pread() and pwrite() commands.
+.TP
+.BI block
+This is the same as psync except that it also supports zone management
+commands using Linux block layer IOCTLs.
 .RE
 .RE
 .TP
@@ -2568,18 +2579,15 @@ Select the xnvme admin command interface. This can take these values.
 .RS
 .TP
 .B nvme
-This is default and uses Linux NVMe Driver ioctl() for admin commands
+This is default and uses Linux NVMe Driver ioctl() for admin commands.
 .TP
 .BI block
-Use Linux Block Layer ioctl() and sysfs for admin commands
-.TP
-.BI file_as_ns
-Use file-stat as to construct NVMe idfy responses
+Use Linux Block Layer ioctl() and sysfs for admin commands.
 .RE
 .RE
 .TP
 .BI (xnvme)xnvme_dev_nsid\fR=\fPint
-xnvme namespace identifier, for userspace NVMe driver.
+xnvme namespace identifier for userspace NVMe driver such as SPDK.
 .TP
 .BI (xnvme)xnvme_iovec
 If this option is set, xnvme will use vectored read/write commands.
@@ -3598,6 +3606,16 @@ EILSEQ) until the runtime is exceeded or the I/O size specified is
 completed. If this option is used, there are two more stats that are
 appended, the total error count and the first error. The error field given
 in the stats is the first error that was hit during the run.
+.RS
+.P
+Note: a write error from the device may go unnoticed by fio when using buffered
+IO, as the write() (or similar) system call merely dirties the kernel pages,
+unless `sync' or `direct' is used. Device IO errors occur when the dirty data is
+actually written out to disk. If fully sync writes aren't desirable, `fsync' or
+`fdatasync' can be used as well. This is specific to writes, as reads are always
+synchronous.
+.RS
+.P
 The allowed values are:
 .RS
 .RS
diff --git a/t/jobs/t0016-259ebc00.fio b/t/jobs/t0016-d54ae22.fio
similarity index 100%
rename from t/jobs/t0016-259ebc00.fio
rename to t/jobs/t0016-d54ae22.fio
diff --git a/t/jobs/t0017.fio b/t/jobs/t0017.fio
new file mode 100644
index 00000000..14486d98
--- /dev/null
+++ b/t/jobs/t0017.fio
@@ -0,0 +1,9 @@
+# Expected result: mean(slat) + mean(clat) = mean(lat)
+# Buggy result: equality does not hold
+# This is similar to t0015 and t0016 except that is uses posixaio which is
+# available on more platforms and does not have a commit hook
+
+[test]
+ioengine=posixaio
+size=1M
+iodepth=16
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index d77f20e0..504b7cdb 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -850,13 +850,23 @@ TEST_LIST = [
     {
         'test_id':          16,
         'test_class':       FioJobTest_t0015,
-        'job':              't0016-259ebc00.fio',
+        'job':              't0016-d54ae22.fio',
         'success':          SUCCESS_DEFAULT,
         'pre_job':          None,
         'pre_success':      None,
         'output_format':    'json',
         'requirements':     [],
     },
+    {
+        'test_id':          17,
+        'test_class':       FioJobTest_t0015,
+        'job':              't0017.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          None,
+        'pre_success':      None,
+        'output_format':    'json',
+        'requirements':     [Requirements.not_windows],
+    },
     {
         'test_id':          1000,
         'test_class':       FioExeTest,
