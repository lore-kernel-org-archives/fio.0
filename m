Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:55000 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759131AbbDYMAP (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 25 Apr 2015 08:00:15 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Ylykn-0003jD-Od
	for fio@vger.kernel.org; Sat, 25 Apr 2015 12:00:13 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150425120001.946372C01AE@kernel.dk>
Date: Sat, 25 Apr 2015 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 36870c47801ca85d1a98c7ec47950b0aa360f865:

  Merge branch 'io-threads' (2015-04-23 11:13:27 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 7c306bb1d27de928cba1b58d7888981d44416fd1:

  io_u: fix bug in rounding of generated buffer length (2015-04-24 10:41:58 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      blktrace: fix bugs in accounting
      io_u: fix bug in rounding of generated buffer length

 blktrace.c | 79 +++++++++++++++++++++++++++++++++++++++++++++++++++-----------
 io_u.c     |  2 +-
 2 files changed, 67 insertions(+), 14 deletions(-)

---

Diff of recent changes:

diff --git a/blktrace.c b/blktrace.c
index e63c708..8ffa9b0 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -327,6 +327,47 @@ static int t_is_write(struct blk_io_trace *t)
 	return (t->action & BLK_TC_ACT(BLK_TC_WRITE | BLK_TC_DISCARD)) != 0;
 }
 
+static enum fio_ddir t_get_ddir(struct blk_io_trace *t)
+{
+	if (t->action & BLK_TC_ACT(BLK_TC_READ))
+		return DDIR_READ;
+	else if (t->action & BLK_TC_ACT(BLK_TC_WRITE))
+		return DDIR_WRITE;
+	else if (t->action & BLK_TC_ACT(BLK_TC_DISCARD))
+		return DDIR_TRIM;
+
+	return DDIR_INVAL;
+}
+
+static void depth_inc(struct blk_io_trace *t, int *depth)
+{
+	enum fio_ddir ddir;
+
+	ddir = t_get_ddir(t);
+	if (ddir != DDIR_INVAL)
+		depth[ddir]++;
+}
+
+static void depth_dec(struct blk_io_trace *t, int *depth)
+{
+	enum fio_ddir ddir;
+
+	ddir = t_get_ddir(t);
+	if (ddir != DDIR_INVAL)
+		depth[ddir]--;
+}
+
+static void depth_end(struct blk_io_trace *t, int *this_depth, int *depth)
+{
+	enum fio_ddir ddir = DDIR_INVAL;
+
+	ddir = t_get_ddir(t);
+	if (ddir != DDIR_INVAL) {
+		depth[ddir] = max(depth[ddir], this_depth[ddir]);
+		this_depth[ddir] = 0;
+	}
+}
+
 /*
  * Load a blktrace file by reading all the blk_io_trace entries, and storing
  * them as io_pieces like the fio text version would do.
@@ -339,7 +380,7 @@ int load_blktrace(struct thread_data *td, const char *filename, int need_swap)
 	struct fifo *fifo;
 	int fd, i, old_state;
 	struct fio_file *f;
-	int this_depth, depth;
+	int this_depth[DDIR_RWDIR_CNT], depth[DDIR_RWDIR_CNT], max_depth;
 
 	fd = open(filename, O_RDONLY);
 	if (fd < 0) {
@@ -353,10 +394,14 @@ int load_blktrace(struct thread_data *td, const char *filename, int need_swap)
 
 	td->o.size = 0;
 
-	ios[0] = ios[1] = 0;
-	rw_bs[0] = rw_bs[1] = 0;
+	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
+		ios[i] = 0;
+		rw_bs[i] = 0;
+		this_depth[i] = 0;
+		depth[i] = 0;
+	}
+
 	skipped_writes = 0;
-	this_depth = depth = 0;
 	do {
 		int ret = trace_fifo_get(td, fifo, fd, &t, sizeof(t));
 
@@ -392,11 +437,12 @@ int load_blktrace(struct thread_data *td, const char *filename, int need_swap)
 		}
 		if ((t.action & BLK_TC_ACT(BLK_TC_NOTIFY)) == 0) {
 			if ((t.action & 0xffff) == __BLK_TA_QUEUE)
-				this_depth++;
-			else if ((t.action & 0xffff) == __BLK_TA_COMPLETE) {
-				depth = max(depth, this_depth);
-				this_depth = 0;
-			}
+				depth_inc(&t, this_depth);
+			else if (((t.action & 0xffff) == __BLK_TA_BACKMERGE) ||
+				((t.action & 0xffff) == __BLK_TA_FRONTMERGE))
+				depth_dec(&t, this_depth);
+			else if ((t.action & 0xffff) == __BLK_TA_COMPLETE)
+				depth_end(&t, this_depth, depth);
 
 			if (t_is_write(&t) && read_only) {
 				skipped_writes++;
@@ -426,8 +472,14 @@ int load_blktrace(struct thread_data *td, const char *filename, int need_swap)
 	 * For stacked devices, we don't always get a COMPLETE event so
 	 * the depth grows to insane values. Limit it to something sane(r).
 	 */
-	if (!depth || depth > 1024)
-		depth = 1024;
+	max_depth = 0;
+	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
+		if (depth[i] > 1024)
+			depth[i] = 1024;
+		else if (!depth[i] && ios[i])
+			depth[i] = 1;
+		max_depth = max(depth[i], max_depth);
+	}
 
 	if (skipped_writes)
 		log_err("fio: %s skips replay of %lu writes due to read-only\n",
@@ -453,13 +505,14 @@ int load_blktrace(struct thread_data *td, const char *filename, int need_swap)
 	 * We need to do direct/raw ios to the device, to avoid getting
 	 * read-ahead in our way.
 	 */
-	td->o.odirect = 1;
+	if (!fio_option_is_set(&td->o, odirect))
+		td->o.odirect = 1;
 
 	/*
 	 * If depth wasn't manually set, use probed depth
 	 */
 	if (!fio_option_is_set(&td->o, iodepth))
-		td->o.iodepth = td->o.iodepth_low = depth;
+		td->o.iodepth = td->o.iodepth_low = max_depth;
 
 	return 0;
 err:
diff --git a/io_u.c b/io_u.c
index ba3f7ca..5064485 100644
--- a/io_u.c
+++ b/io_u.c
@@ -485,7 +485,7 @@ static unsigned int __get_next_buflen(struct thread_data *td, struct io_u *io_u,
 				~(td->o.verify_interval - 1);
 
 		if (!td->o.bs_unaligned && is_power_of_2(minbs))
-			buflen = (buflen + minbs - 1) & ~(minbs - 1);
+			buflen &= ~(minbs - 1);
 
 	} while (!io_u_fits(td, io_u, buflen));
 
