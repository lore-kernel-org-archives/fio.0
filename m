Return-Path: <Alan.Brunelle@hp.com>
Subject: Re: io scheduler merges control
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
In-Reply-To: <20100111135455.GN4489@kernel.dk>
References: <31699.35262.qm@web55002.mail.re4.yahoo.com>
	 <1262709179.10727.36.camel@cail>  <20100111135455.GN4489@kernel.dk>
Content-Type: multipart/mixed; boundary="=-gCesmg8WL8JToLlLrdqz"
Date: Wed, 20 Jan 2010 11:18:55 -0500
Message-ID: <1264004335.2767.7.camel@cail>
Mime-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
Cc: john smith <whalajam@yahoo.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>


--=-gCesmg8WL8JToLlLrdqz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Mon, 2010-01-11 at 14:54 +0100, Jens Axboe wrote:
> On Tue, Jan 05 2010, Alan D. Brunelle wrote:
> > On Mon, 2010-01-04 at 17:53 -0800, john smith wrote:
> > > Alan,
> > > 
> > > I've tried 'echo "1"> /sys/block/<dsf>/queue/nomerges' but
> > > fio/sequential-reads merges still occur and apparently they are only
> > > the simple ones that can't be disabled.
> > > 
> > > 1) What can I change in the kernel to disable ALL the merges
> > > (including the simple ones)?
> > > (I tried setting iosched_cfq.ops.elevator_merge_fn,
> > > elevator_merged_fn, elevator_merge_req_fn, elevator_allow_merge_fn = 0
> > > but still fio reported merges)
> > 
> > Unfortunately, the "simple" ones were left in precisely because they
> > were (a) easy to do, and (b) were expected to happen often enough to
> > keep them in. Jens may be able to comment further.
> 
> Right, they are both cheap and easy so they were kept. The goal with the
> nomerges switch was to save CPU, so it'll still do cheap merges. I don't
> think there's a use for disabling merges completely outside of device
> testing and benchmarking, it's not a real world problem. That said, I do
> occasionally hack that up as well for testing purposes. Perhaps we could
> tweak nomerges to accept a '2' value as well, indicating that we don't
> want any merges at all.
> 

John (& Jens) - 

Please find attached a patch that does this - new documentation
for /sys/block/*/queue/nomerges:

+This enables the user to disable the lookup logic involved with IO
+merging requests in the block layer. By default (0) all merges are
+enabled. When set to 1 only simple one-hit merges will be tried. When
+set to 2 no merge algorithms will be tried (including one-hit or more
+complex tree/hash lookups).

John: let me know if this does what you'd think - then I'll go post to
LKML.

Regards,
Alan

--=-gCesmg8WL8JToLlLrdqz
Content-Disposition: attachment; filename*0=001-Added-in-stricter-no-merge-semantics-for-block-I-O.patch.; filename*1=txt
Content-Type: text/plain; name="001-Added-in-stricter-no-merge-semantics-for-block-I-O.patch.txt"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

From 992fc11fd2818e17a70832943fd49dc3130544db Mon Sep 17 00:00:00 2001
From: Alan D. Brunelle <alan.brunelle@hp.com>
Date: Wed, 20 Jan 2010 11:08:05 -0500
Subject: [PATCH] Added in stricter no merge semantics for block I/O

Updated 'nomerges' tunable to accept a value of '2' - indicating that _no_
merges at all are to be attempted (not even the simple one-hit cache).

Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
---
 Documentation/block/queue-sysfs.txt |   10 +++++-----
 block/blk-sysfs.c                   |   11 +++++++----
 block/elevator.c                    |   11 ++++++++++-
 include/linux/blkdev.h              |    3 +++
 4 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/Documentation/block/queue-sysfs.txt b/Documentation/block/queue-sysfs.txt
index e164403..f652740 100644
--- a/Documentation/block/queue-sysfs.txt
+++ b/Documentation/block/queue-sysfs.txt
@@ -25,11 +25,11 @@ size allowed by the hardware.
 
 nomerges (RW)
 -------------
-This enables the user to disable the lookup logic involved with IO merging
-requests in the block layer. Merging may still occur through a direct
-1-hit cache, since that comes for (almost) free. The IO scheduler will not
-waste cycles doing tree/hash lookups for merges if nomerges is 1. Defaults
-to 0, enabling all merges.
+This enables the user to disable the lookup logic involved with IO
+merging requests in the block layer. By default (0) all merges are
+enabled. When set to 1 only simple one-hit merges will be tried. When
+set to 2 no merge algorithms will be tried (including one-hit or more
+complex tree/hash lookups).
 
 nr_requests (RW)
 ----------------
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 8606c95..e854424 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -189,7 +189,8 @@ static ssize_t queue_nonrot_store(struct request_queue *q, const char *page,
 
 static ssize_t queue_nomerges_show(struct request_queue *q, char *page)
 {
-	return queue_var_show(blk_queue_nomerges(q), page);
+	return queue_var_show((blk_queue_nomerges(q) << 1) |
+			       blk_queue_noxmerges(q), page);
 }
 
 static ssize_t queue_nomerges_store(struct request_queue *q, const char *page,
@@ -199,10 +200,12 @@ static ssize_t queue_nomerges_store(struct request_queue *q, const char *page,
 	ssize_t ret = queue_var_store(&nm, page, count);
 
 	spin_lock_irq(q->queue_lock);
-	if (nm)
+	queue_flag_clear(QUEUE_FLAG_NOMERGES, q);
+	queue_flag_clear(QUEUE_FLAG_NOXMERGES, q);
+	if (nm == 2)
 		queue_flag_set(QUEUE_FLAG_NOMERGES, q);
-	else
-		queue_flag_clear(QUEUE_FLAG_NOMERGES, q);
+	else if (nm)
+		queue_flag_set(QUEUE_FLAG_NOXMERGES, q);
 	spin_unlock_irq(q->queue_lock);
 
 	return ret;
diff --git a/block/elevator.c b/block/elevator.c
index 9ad5ccc..ee3a883 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -474,6 +474,15 @@ int elv_merge(struct request_queue *q, struct request **req, struct bio *bio)
 	int ret;
 
 	/*
+	 * Levels of merges:
+	 * 	nomerges:  No merges at all attempted
+	 * 	noxmerges: Only simple one-hit cache try
+	 * 	merges:	   All merge tries attempted
+	 */
+	if (blk_queue_nomerges(q))
+		return ELEVATOR_NO_MERGE;
+
+	/*
 	 * First try one-hit cache.
 	 */
 	if (q->last_merge) {
@@ -484,7 +493,7 @@ int elv_merge(struct request_queue *q, struct request **req, struct bio *bio)
 		}
 	}
 
-	if (blk_queue_nomerges(q))
+	if (blk_queue_noxmerges(q))
 		return ELEVATOR_NO_MERGE;
 
 	/*
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ffb13ad..f71f5c5 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -463,6 +463,7 @@ struct request_queue
 #define QUEUE_FLAG_IO_STAT     15	/* do IO stats */
 #define QUEUE_FLAG_CQ	       16	/* hardware does queuing */
 #define QUEUE_FLAG_DISCARD     17	/* supports DISCARD */
+#define QUEUE_FLAG_NOXMERGES   18	/* No extended merges */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_CLUSTER) |		\
@@ -589,6 +590,8 @@ enum {
 #define blk_queue_queuing(q)	test_bit(QUEUE_FLAG_CQ, &(q)->queue_flags)
 #define blk_queue_stopped(q)	test_bit(QUEUE_FLAG_STOPPED, &(q)->queue_flags)
 #define blk_queue_nomerges(q)	test_bit(QUEUE_FLAG_NOMERGES, &(q)->queue_flags)
+#define blk_queue_noxmerges(q)	\
+	test_bit(QUEUE_FLAG_NOXMERGES, &(q)->queue_flags)
 #define blk_queue_nonrot(q)	test_bit(QUEUE_FLAG_NONROT, &(q)->queue_flags)
 #define blk_queue_io_stat(q)	test_bit(QUEUE_FLAG_IO_STAT, &(q)->queue_flags)
 #define blk_queue_flushing(q)	((q)->ordseq)
-- 
1.6.5


--=-gCesmg8WL8JToLlLrdqz--


