Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0829AC77B7F
	for <fio@archiver.kernel.org>; Fri, 12 May 2023 12:00:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240363AbjELMAT (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 12 May 2023 08:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240395AbjELMAS (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 12 May 2023 08:00:18 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26BB51700
        for <fio@vger.kernel.org>; Fri, 12 May 2023 05:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=w2piPOGjrh4M6F4iPb31yMeVWa6Z9hP95t5p1yH4Ico=; b=GRGQQLEQ1mI0H4mnTaBTVybblB
        I68jmVrFEryArKEs0iM9D83SdcSumhFV0QjwfxZ6U79uyQYGFZRcp5IUy0yrsseJ7iDBBEGkVMfJQ
        DykIIwH0tpkTN1VrGjmLQ9bqn87pjd19qzFmxvhQRAiJzc7nIqwi56wpHfgUUURY3epPEGg92G6XF
        Pa7pLJ4Q6LPBmyHPeRzJgSec33Ouwa0H8KVtwVVcKr6T3LvvcvW7+N59bm06GF0foQENtPbbXuJYw
        fnoljWmEVr2z4WFzKb065BecO9G8jgPiGMyExKaHZWuguM+fg32meicFO7eq38tFHaqkfx+9CVb5Q
        xukCxacg==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pxRRV-0098dj-0d
        for fio@vger.kernel.org;
        Fri, 12 May 2023 12:00:15 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id E08E71BC0161; Fri, 12 May 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230512120001.E08E71BC0161@kernel.dk>
Date:   Fri, 12 May 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 37946bed31b688fe55e2003b6d59ff0c964165bb:

  engines/rdma: remove dead code (2023-05-10 09:16:55 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f6f80750f75810bdaf56dd9362982055de1d7232:

  docs: expand description for interval-based bw and iops statistics (2023-05-10 20:28:49 -0400)

----------------------------------------------------------------
Vincent Fu (2):
      t/run-fio-test: fix comment
      docs: expand description for interval-based bw and iops statistics

 HOWTO.rst          | 22 +++++++++++++++-------
 fio.1              | 19 ++++++++++++-------
 t/run-fio-tests.py |  2 +-
 3 files changed, 28 insertions(+), 15 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 0a6e60c7..80c08f7e 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -4417,15 +4417,23 @@ writes in the example above).  In the order listed, they denote:
                 It is the sum of submission and completion latency.
 
 **bw**
-		Bandwidth statistics based on samples. Same names as the xlat stats,
-		but also includes the number of samples taken (**samples**) and an
-		approximate percentage of total aggregate bandwidth this thread
-		received in its group (**per**). This last value is only really
-		useful if the threads in this group are on the same disk, since they
-		are then competing for disk access.
+		Bandwidth statistics based on measurements from discrete
+		intervals. Fio continuously monitors bytes transferred and I/O
+		operations completed. By default fio calculates bandwidth in
+		each half-second interval (see :option:`bwavgtime`) and reports
+		descriptive statistics for the measurements here. Same names as
+		the xlat stats, but also includes the number of samples taken
+		(**samples**) and an approximate percentage of total aggregate
+		bandwidth this thread received in its group (**per**). This
+		last value is only really useful if the threads in this group
+		are on the same disk, since they are then competing for disk
+		access.
 
 **iops**
-		IOPS statistics based on samples. Same names as bw.
+		IOPS statistics based on measurements from discrete intervals.
+		For details see the description for bw above. See
+		:option:`iopsavgtime` to control the duration of the intervals.
+		Same values reported here as for bw except for percentage.
 
 **lat (nsec/usec/msec)**
 		The distribution of I/O completion latencies. This is the time from when
diff --git a/fio.1 b/fio.1
index 4207814b..e577e2e0 100644
--- a/fio.1
+++ b/fio.1
@@ -4073,15 +4073,20 @@ Total latency. Same names as slat and clat, this denotes the time from
 when fio created the I/O unit to completion of the I/O operation.
 .TP
 .B bw
-Bandwidth statistics based on samples. Same names as the xlat stats,
-but also includes the number of samples taken (\fIsamples\fR) and an
-approximate percentage of total aggregate bandwidth this thread
-received in its group (\fIper\fR). This last value is only really
-useful if the threads in this group are on the same disk, since they
-are then competing for disk access.
+Bandwidth statistics based on measurements from discrete intervals. Fio
+continuosly monitors bytes transferred and I/O operations completed. By default
+fio calculates bandwidth in each half-second interval (see \fBbwavgtime\fR)
+and reports descriptive statistics for the measurements here. Same names as the
+xlat stats, but also includes the number of samples taken (\fIsamples\fR) and an
+approximate percentage of total aggregate bandwidth this thread received in its
+group (\fIper\fR). This last value is only really useful if the threads in this
+group are on the same disk, since they are then competing for disk access.
 .TP
 .B iops
-IOPS statistics based on samples. Same names as \fBbw\fR.
+IOPS statistics based on measurements from discrete intervals.
+For details see the description for \fBbw\fR above. See
+\fBiopsavgtime\fR to control the duration of the intervals.
+Same values reported here as for \fBbw\fR except for percentage.
 .TP
 .B lat (nsec/usec/msec)
 The distribution of I/O completion latencies. This is the time from when
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index 4fe6fe46..71e3e5a6 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -822,7 +822,7 @@ class FioJobTest_t0027(FioJobTest):
             self.passed = False
 
 class FioJobTest_iops_rate(FioJobTest):
-    """Test consists of fio test job t0009
+    """Test consists of fio test job t0011
     Confirm that job0 iops == 1000
     and that job1_iops / job0_iops ~ 8
     With two runs of fio-3.16 I observed a ratio of 8.3"""
