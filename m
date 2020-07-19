Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgGSMAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 19 Jul 2020 08:00:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F88C0619D2
        for <fio@vger.kernel.org>; Sun, 19 Jul 2020 05:00:09 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx7zC-0005Bk-Us
        for fio@vger.kernel.org; Sun, 19 Jul 2020 12:00:07 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200719120001.84AA01BC018E@kernel.dk>
Date: Sun, 19 Jul 2020 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e04241512bb69f1fe8ff6eed9402343af436ba75:

  t/zbd: Enable regular block devices for test case #47 (2020-07-17 07:32:12 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to fa443634fbfa38fd5d6418a96a45022c78b90df4:

  Merge branch 'patch-1' of https://github.com/avlasov-mos-de/fio (2020-07-18 08:39:04 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'patch-1' of https://github.com/avlasov-mos-de/fio

avlasov-mos-de (1):
      Fix scale on gnuplot graphs

 tools/fio_generate_plots | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/tools/fio_generate_plots b/tools/fio_generate_plots
index 8872206e..e4558788 100755
--- a/tools/fio_generate_plots
+++ b/tools/fio_generate_plots
@@ -123,10 +123,10 @@ plot () {
 # plot <sub title> <file name tag> <y axis label> <y axis scale>
 #
 
-plot "I/O Latency" lat "Time (msec)" 1000
+plot "I/O Latency" lat "Time (msec)" 1000000
 plot "I/O Operations Per Second" iops "IOPS" 1
-plot "I/O Submission Latency" slat "Time (��sec)" 1
-plot "I/O Completion Latency" clat "Time (msec)" 1000
+plot "I/O Submission Latency" slat "Time (��sec)" 1000
+plot "I/O Completion Latency" clat "Time (msec)" 1000000
 plot "I/O Bandwidth" bw "Throughput (KB/s)" 1
 
 

