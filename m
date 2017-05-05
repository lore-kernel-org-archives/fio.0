Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:36914 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751460AbdEEMAK (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 5 May 2017 08:00:10 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1d6bu5-0004jz-R2
        for fio@vger.kernel.org; Fri, 05 May 2017 12:00:09 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170505120002.104D42C1712@kernel.dk>
Date: Fri,  5 May 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit f52e919826839eaba90903b67fe02042159a0023:

  gettime: make utime_since_now and mtime_since_now consistent in how they record the caller and put this all behind FIO_DEBUG_TIME (2017-05-03 08:49:37 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c55fae03f7d5c0981e55241fc9003d762f7a5fd9:

  options: force refill_buffers with pattern and any reads (2017-05-04 08:43:27 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      options: force refill_buffers with pattern and any reads

 options.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/options.c b/options.c
index 85574d7..b489e90 100644
--- a/options.c
+++ b/options.c
@@ -1306,8 +1306,17 @@ static int str_buffer_pattern_cb(void *data, const char *input)
 
 	assert(ret != 0);
 	td->o.buffer_pattern_bytes = ret;
-	if (!td->o.compress_percentage)
+
+	/*
+	 * If this job is doing any reading or has compression set,
+	 * ensure that we refill buffers for writes or we could be
+	 * invalidating the pattern through reads.
+	 */
+	if (!td->o.compress_percentage && !td_read(td))
 		td->o.refill_buffers = 0;
+	else
+		td->o.refill_buffers = 1;
+
 	td->o.scramble_buffers = 0;
 	td->o.zero_buffers = 0;
 
