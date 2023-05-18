Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB393C7EE22
	for <fio@archiver.kernel.org>; Thu, 18 May 2023 12:00:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbjERMAJ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 18 May 2023 08:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbjERMAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 18 May 2023 08:00:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 427CEAC
        for <fio@vger.kernel.org>; Thu, 18 May 2023 05:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=JfiT7entJdtSDFQ2DUF9CsKF1yfUQVlvMFlV5oVSOuU=; b=N52p9+Dhiv9fPdpGPTejkY+RBh
        SsYWN6DCzCls0CA4Hh4hVl2Ljp81r/uV5/PIfPsUXEzZnm79Z1HArZh5Jxml1emMt/VkQrV64H9cA
        nfxcYSpj1HQg7SZPDjnnQodh4H/5akR73eAComJiI2cU/yxNzdRWWgigPASbU6LLvZqPowTnde+TS
        COKpl7C+U8lp75oSW0cd4IKHVZIf90pQQa4756R/Xckk/e7huDh6d4aD6Akl7SCsYCgGZDAWsu2RA
        54fjpVmf37zD3AItbXvRXsQTYCsl3BFPTZsFR6aYpxRapfXmK8bFvQEmG+9EbXamWgZz17or4mZvv
        WVsVSF1g==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pzcIe-005kvp-Fw
        for fio@vger.kernel.org; Thu, 18 May 2023 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id F15291BC017B; Thu, 18 May 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230518120001.F15291BC017B@kernel.dk>
Date:   Thu, 18 May 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit be42eadd18fad2569dfc6517940db8bbe2469f6d:

  engines/io_uring: fix coverity issue (2023-05-16 09:01:57 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a64fd9c7994b51039b2fde851579c2453ddb35c0:

  docs: document no_completion_thread (2023-05-17 14:44:49 +0000)

----------------------------------------------------------------
Vincent Fu (3):
      docs: move rate_cycle description
      docs: move experimental_verify description
      docs: document no_completion_thread

 HOWTO.rst | 28 ++++++++++++++++------------
 fio.1     | 21 ++++++++++++---------
 2 files changed, 28 insertions(+), 21 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 80c08f7e..32fff5ec 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -3011,6 +3011,10 @@ with the caveat that when used on the command line, they must come after the
 	performance. The default is to enable it only if
 	:option:`libblkio_wait_mode=eventfd <libblkio_wait_mode>`.
 
+.. option:: no_completion_thread : [windowsaio]
+
+	Avoid using a separate thread for completion polling.
+
 I/O depth
 ~~~~~~~~~
 
@@ -3203,6 +3207,11 @@ I/O rate
 	fio will ignore the thinktime and continue doing IO at the specified
 	rate, instead of entering a catch-up mode after thinktime is done.
 
+.. option:: rate_cycle=int
+
+	Average bandwidth for :option:`rate` and :option:`rate_min` over this number
+	of milliseconds. Defaults to 1000.
+
 
 I/O latency
 ~~~~~~~~~~~
@@ -3241,11 +3250,6 @@ I/O latency
 	microseconds. Comma-separated values may be specified for reads, writes,
 	and trims as described in :option:`blocksize`.
 
-.. option:: rate_cycle=int
-
-	Average bandwidth for :option:`rate` and :option:`rate_min` over this number
-	of milliseconds. Defaults to 1000.
-
 
 I/O replay
 ~~~~~~~~~~
@@ -3761,6 +3765,13 @@ Verification
 	verification pass, according to the settings in the job file used.  Default
 	false.
 
+.. option:: experimental_verify=bool
+
+        Enable experimental verification. Standard verify records I/O metadata
+        for later use during the verification phase. Experimental verify
+        instead resets the file after the write phase and then replays I/Os for
+        the verification phase.
+
 .. option:: trim_percentage=int
 
 	Number of verify blocks to discard/trim.
@@ -3777,13 +3788,6 @@ Verification
 
 	Trim this number of I/O blocks.
 
-.. option:: experimental_verify=bool
-
-        Enable experimental verification. Standard verify records I/O metadata
-        for later use during the verification phase. Experimental verify
-        instead resets the file after the write phase and then replays I/Os for
-        the verification phase.
-
 Steady state
 ~~~~~~~~~~~~
 
diff --git a/fio.1 b/fio.1
index e577e2e0..80bf3371 100644
--- a/fio.1
+++ b/fio.1
@@ -2765,6 +2765,9 @@ Use a busy loop with a non-blocking call to \fBblkioq_do_io()\fR.
 Enable the queue's completion eventfd even when unused. This may impact
 performance. The default is to enable it only if
 \fBlibblkio_wait_mode=eventfd\fR.
+.TP
+.BI (windowsaio)no_completion_thread
+Avoid using a separate thread for completion polling.
 .SS "I/O depth"
 .TP
 .BI iodepth \fR=\fPint
@@ -2946,6 +2949,10 @@ By default, fio will attempt to catch up to the specified rate setting, if any
 kind of thinktime setting was used. If this option is set, then fio will
 ignore the thinktime and continue doing IO at the specified rate, instead of
 entering a catch-up mode after thinktime is done.
+.TP
+.BI rate_cycle \fR=\fPint
+Average bandwidth for \fBrate\fR and \fBrate_min\fR over this number
+of milliseconds. Defaults to 1000.
 .SS "I/O latency"
 .TP
 .BI latency_target \fR=\fPtime
@@ -2975,10 +2982,6 @@ If set, fio will exit the job with an ETIMEDOUT error if it exceeds this
 maximum latency. When the unit is omitted, the value is interpreted in
 microseconds. Comma-separated values may be specified for reads, writes,
 and trims as described in \fBblocksize\fR.
-.TP
-.BI rate_cycle \fR=\fPint
-Average bandwidth for \fBrate\fR and \fBrate_min\fR over this number
-of milliseconds. Defaults to 1000.
 .SS "I/O replay"
 .TP
 .BI write_iolog \fR=\fPstr
@@ -3475,6 +3478,11 @@ far it should verify. Without this information, fio will run a full
 verification pass, according to the settings in the job file used. Default
 false.
 .TP
+.BI experimental_verify \fR=\fPbool
+Enable experimental verification. Standard verify records I/O metadata for
+later use during the verification phase. Experimental verify instead resets the
+file after the write phase and then replays I/Os for the verification phase.
+.TP
 .BI trim_percentage \fR=\fPint
 Number of verify blocks to discard/trim.
 .TP
@@ -3486,11 +3494,6 @@ Verify that trim/discarded blocks are returned as zeros.
 .TP
 .BI trim_backlog_batch \fR=\fPint
 Trim this number of I/O blocks.
-.TP
-.BI experimental_verify \fR=\fPbool
-Enable experimental verification. Standard verify records I/O metadata for
-later use during the verification phase. Experimental verify instead resets the
-file after the write phase and then replays I/Os for the verification phase.
 .SS "Steady state"
 .TP
 .BI steadystate \fR=\fPstr:float "\fR,\fP ss" \fR=\fPstr:float
