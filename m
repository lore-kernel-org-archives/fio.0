Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:59066 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728979AbeJAShh (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 1 Oct 2018 14:37:37 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g6wrx-0004Dc-5E
        for fio@vger.kernel.org; Mon, 01 Oct 2018 12:00:09 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20181001120002.7EFAF2C031B@kernel.dk>
Date: Mon,  1 Oct 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 91d2513127442c4946dc99978870c4dc4f58427d:

  zbd: Avoid duplicating the code for calculating the number of sectors with data (2018-09-29 15:16:26 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2bce52c621f0e1d7a360e8aedfe23300f8e56bb9:

  engines/cpu: fix potential overflow in thinktime calculation (2018-09-30 08:41:40 -0600)

----------------------------------------------------------------
Jeff Moyer (1):
      fix hung fio process with large I/O sizes and verify= option

Jens Axboe (1):
      engines/cpu: fix potential overflow in thinktime calculation

 engines/cpu.c | 2 +-
 lib/rand.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/engines/cpu.c b/engines/cpu.c
index 0987250..4d572b4 100644
--- a/engines/cpu.c
+++ b/engines/cpu.c
@@ -85,7 +85,7 @@ static int fio_cpuio_init(struct thread_data *td)
 	 */
 	o->thinktime_blocks = 1;
 	o->thinktime_spin = 0;
-	o->thinktime = (co->cpucycle * (100 - co->cpuload)) / co->cpuload;
+	o->thinktime = ((unsigned long long) co->cpucycle * (100 - co->cpuload)) / co->cpuload;
 
 	o->nr_files = o->open_files = 1;
 
diff --git a/lib/rand.c b/lib/rand.c
index 46ffe4f..99846a8 100644
--- a/lib/rand.c
+++ b/lib/rand.c
@@ -156,7 +156,7 @@ void __fill_random_buf_percentage(unsigned long seed, void *buf,
 		/*
 		 * Fill random chunk
 		 */
-		this_len = (segment * (100 - percentage)) / 100;
+		this_len = ((unsigned long long)segment * (100 - percentage)) / 100;
 		if (this_len > len)
 			this_len = len;
 

