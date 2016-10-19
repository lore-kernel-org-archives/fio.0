Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60418 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941664AbcJSOUx (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 19 Oct 2016 10:20:53 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1bwpXO-00071q-J8
        for fio@vger.kernel.org; Wed, 19 Oct 2016 12:00:02 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20161019120001.7774C2C0400@kernel.dk>
Date: Wed, 19 Oct 2016 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit dac34079f7d8cfb0a64e4d3f086728edd7eded6d:

  iolog: enable replay_redirect on iolog replay (2016-10-17 14:51:54 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 0228cfe7bb04b3c8329f8e77ee47e30e1a5a03cd:

  HOWTO: update to include iolog replay (2016-10-18 09:12:45 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      iolog: add support for 'replay_no_stall'
      HOWTO: update to include iolog replay

 HOWTO   | 19 ++++++++++---------
 iolog.c |  2 ++
 2 files changed, 12 insertions(+), 9 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index cf1024c..3f8acee 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1558,10 +1558,10 @@ read_iolog=str	Open an iolog with the specified file name and replay the
 
 replay_no_stall=int When replaying I/O with read_iolog the default behavior
 		is to attempt to respect the time stamps within the log and
-		replay them with the appropriate delay between IOPS.  By
+		replay them with the appropriate delay between IOPS. By
 		setting this variable fio will not respect the timestamps and
 		attempt to replay them as fast as possible while still
-		respecting ordering.  The result is the same I/O pattern to a
+		respecting ordering. The result is the same I/O pattern to a
 		given device, but different timings.
 
 replay_redirect=str While replaying I/O patterns using read_iolog the
@@ -1573,13 +1573,14 @@ replay_redirect=str While replaying I/O patterns using read_iolog the
 		mapping.  Replay_redirect causes all IOPS to be replayed onto
 		the single specified device regardless of the device it was
 		recorded from. i.e. replay_redirect=/dev/sdc would cause all
-		IO in the blktrace to be replayed onto /dev/sdc.  This means
-		multiple devices will be replayed onto a single, if the trace
-		contains multiple devices.  If you want multiple devices to be
-		replayed concurrently to multiple redirected devices you must
-		blkparse your trace into separate traces and replay them with
-		independent fio invocations.  Unfortuantely this also breaks
-		the strict time ordering between multiple device accesses.
+		IO in the blktrace or iolog to be replayed onto /dev/sdc.
+		This means multiple devices will be replayed onto a single
+		device, if the trace contains multiple devices. If you want
+		multiple devices to be replayed concurrently to multiple
+		redirected devices you must blkparse your trace into separate
+		traces and replay them with independent fio invocations.
+		Unfortuantely this also breaks the strict time ordering
+		between multiple device accesses.
 
 replay_align=int	Force alignment of IO offsets and lengths in a trace
 		to this power of 2 value.
diff --git a/iolog.c b/iolog.c
index 686c713..f0ce3b2 100644
--- a/iolog.c
+++ b/iolog.c
@@ -425,6 +425,8 @@ static int read_iolog2(struct thread_data *td, FILE *f)
 				continue;
 			writes++;
 		} else if (rw == DDIR_WAIT) {
+			if (td->o.no_stall)
+				continue;
 			waits++;
 		} else if (rw == DDIR_INVAL) {
 		} else if (!ddir_sync(rw)) {
