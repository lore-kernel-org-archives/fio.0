Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725833AbgILMAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 12 Sep 2020 08:00:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B491C061573
        for <fio@vger.kernel.org>; Sat, 12 Sep 2020 05:00:07 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kH4CL-0007O0-8i
        for fio@vger.kernel.org; Sat, 12 Sep 2020 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200912120001.BFD7C1BC0130@kernel.dk>
Date: Sat, 12 Sep 2020 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e55138eed3296b642229271b0dcec492ec776702:

  Merge branch 'evelu-enghelp' of https://github.com/ErwanAliasr1/fio into master (2020-09-09 10:48:27 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 695611a9d4cd554d44d8b2ec5da2811061950a2e:

  Allow offload with FAKEIO engines (2020-09-11 09:58:15 -0600)

----------------------------------------------------------------
Jens Axboe (3):
      engines/io_uring: mark as not compatible with io_submit_mode=offload
      Disable io_submit_mode=offload with async engines
      Allow offload with FAKEIO engines

 HOWTO              |  3 ++-
 engines/io_uring.c |  6 ++++++
 fio.1              |  2 +-
 ioengines.c        | 14 ++++++++++++--
 4 files changed, 21 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index d8586723..2d8c7a02 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2474,7 +2474,8 @@ I/O depth
 	can increase latencies. The benefit is that fio can manage submission rates
 	independently of the device completion rates. This avoids skewed latency
 	reporting if I/O gets backed up on the device side (the coordinated omission
-	problem).
+	problem). Note that this option cannot reliably be used with async IO
+	engines.
 
 
 I/O rate
diff --git a/engines/io_uring.c b/engines/io_uring.c
index e2b5e6ee..69f48859 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -724,6 +724,12 @@ static int fio_ioring_init(struct thread_data *td)
 	struct ioring_data *ld;
 	struct thread_options *to = &td->o;
 
+	if (to->io_submit_mode == IO_MODE_OFFLOAD) {
+		log_err("fio: io_submit_mode=offload is not compatible (or "
+			"useful) with io_uring\n");
+		return 1;
+	}
+
 	/* sqthread submission requires registered files */
 	if (o->sqpoll_thread)
 		o->registerfiles = 1;
diff --git a/fio.1 b/fio.1
index 74509bbd..a881277c 100644
--- a/fio.1
+++ b/fio.1
@@ -2215,7 +2215,7 @@ has a bit of extra overhead, especially for lower queue depth I/O where it
 can increase latencies. The benefit is that fio can manage submission rates
 independently of the device completion rates. This avoids skewed latency
 reporting if I/O gets backed up on the device side (the coordinated omission
-problem).
+problem). Note that this option cannot reliably be used with async IO engines.
 .SS "I/O rate"
 .TP
 .BI thinktime \fR=\fPtime
diff --git a/ioengines.c b/ioengines.c
index 476df58d..d3be8026 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -22,7 +22,7 @@
 
 static FLIST_HEAD(engine_list);
 
-static bool check_engine_ops(struct ioengine_ops *ops)
+static bool check_engine_ops(struct thread_data *td, struct ioengine_ops *ops)
 {
 	if (ops->version != FIO_IOOPS_VERSION) {
 		log_err("bad ioops version %d (want %d)\n", ops->version,
@@ -41,6 +41,16 @@ static bool check_engine_ops(struct ioengine_ops *ops)
 	if (ops->flags & FIO_SYNCIO)
 		return false;
 
+	/*
+	 * async engines aren't reliable with offload
+	 */
+	if ((td->o.io_submit_mode == IO_MODE_OFFLOAD) &&
+	    !(ops->flags & FIO_FAKEIO)) {
+		log_err("%s: can't be used with offloaded submit. Use a sync "
+			"engine\n", ops->name);
+		return true;
+	}
+
 	if (!ops->event || !ops->getevents) {
 		log_err("%s: no event/getevents handler\n", ops->name);
 		return true;
@@ -193,7 +203,7 @@ struct ioengine_ops *load_ioengine(struct thread_data *td)
 	/*
 	 * Check that the required methods are there.
 	 */
-	if (check_engine_ops(ops))
+	if (check_engine_ops(td, ops))
 		return NULL;
 
 	return ops;

