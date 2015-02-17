Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:60166 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730AbbBQNAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 17 Feb 2015 08:00:07 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YNhl0-0005IP-9A
	for fio@vger.kernel.org; Tue, 17 Feb 2015 13:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150217130003.A292E4018E@lyth.info>
Date: Tue, 17 Feb 2015 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 10adc4a71b10e504d904bfc1db2d705342aa3851:

  verify: Fix latency log for verify commands. (2015-02-09 08:18:03 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 495288a1e627c3d1b29897786b786eb6008841a3:

  examples/ssd-test.fio: bump size to 10G (2015-02-16 15:04:11 -0700)

----------------------------------------------------------------
Castor Fu (1):
      gettime.h: use time_t instead of size_t for copy of tv_sec

Jens Axboe (1):
      examples/ssd-test.fio: bump size to 10G

Justin Eno (1):
      Allow random overwrite workloads to write io_limit

 backend.c             |    8 +++++++-
 examples/ssd-test.fio |    2 +-
 gettime.h             |    2 +-
 3 files changed, 9 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 0f6e425..3430e66 100644
--- a/backend.c
+++ b/backend.c
@@ -726,12 +726,18 @@ static uint64_t do_io(struct thread_data *td)
 
 	lat_target_init(td);
 
+	total_bytes = td->o.size;
+	/*
+	* Allow random overwrite workloads to write up to io_limit
+	* before starting verification phase as 'size' doesn't apply.
+	*/
+	if (td_write(td) && td_random(td) && td->o.norandommap)
+		total_bytes = max(total_bytes, (uint64_t) td->o.io_limit);
 	/*
 	 * If verify_backlog is enabled, we'll run the verify in this
 	 * handler as well. For that case, we may need up to twice the
 	 * amount of bytes.
 	 */
-	total_bytes = td->o.size;
 	if (td->o.verify != VERIFY_NONE &&
 	   (td_write(td) && td->o.verify_backlog))
 		total_bytes += td->o.size;
diff --git a/examples/ssd-test.fio b/examples/ssd-test.fio
index c84cf50..2b6a590 100644
--- a/examples/ssd-test.fio
+++ b/examples/ssd-test.fio
@@ -14,7 +14,7 @@
 bs=4k
 ioengine=libaio
 iodepth=4
-size=1g
+size=10g
 direct=1
 runtime=60
 directory=/mount-point-of-ssd
diff --git a/gettime.h b/gettime.h
index eb3537b..86d55bd 100644
--- a/gettime.h
+++ b/gettime.h
@@ -24,7 +24,7 @@ extern struct timeval *fio_tv;
 
 static inline int fio_gettime_offload(struct timeval *tv)
 {
-	size_t last_sec;
+	time_t last_sec;
 
 	if (!fio_tv)
 		return 0;
