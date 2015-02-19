Return-Path: <fio-owner@vger.kernel.org>
Received: from [198.137.202.9] ([198.137.202.9]:39459 "EHLO
	bombadil.infradead.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753203AbbBSNA2 (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 19 Feb 2015 08:00:28 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YOQi4-0003oy-3K
	for fio@vger.kernel.org; Thu, 19 Feb 2015 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150219130003.0736040191@lyth.info>
Date: Thu, 19 Feb 2015 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 495288a1e627c3d1b29897786b786eb6008841a3:

  examples/ssd-test.fio: bump size to 10G (2015-02-16 15:04:11 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 83da8fbfa3cdcd16bef7276af6aec0eea4a4566b:

  Allow verify w/norandommap and bsrange (2015-02-18 10:38:37 -0800)

----------------------------------------------------------------
Justin Eno (2):
      Allow verification of random overwrites w/ba < bs
      Allow verify w/norandommap and bsrange

 HOWTO   |    8 ++++----
 init.c  |    3 +--
 iolog.c |   14 +++++++++++---
 3 files changed, 16 insertions(+), 9 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 8da5527..0f7909d 100644
--- a/HOWTO
+++ b/HOWTO
@@ -919,10 +919,10 @@ norandommap	Normally fio will cover every block of the file when doing
 		random IO. If this option is given, fio will just get a
 		new random offset without looking at past io history. This
 		means that some blocks may not be read or written, and that
-		some blocks may be read/written more than once. This option
-		is mutually exclusive with verify= if and only if multiple
-		blocksizes (via bsrange=) are used, since fio only tracks
-		complete rewrites of blocks.
+		some blocks may be read/written more than once. If this option
+		is used with verify= and multiple blocksizes (via bsrange=),
+		only intact blocks are verified, i.e., partially-overwritten
+		blocks are ignored.
 
 softrandommap=bool See norandommap. If fio runs with the random block map
 		enabled and it fails to allocate the map, if this option is
diff --git a/init.c b/init.c
index bb53a1e..c210ad2 100644
--- a/init.c
+++ b/init.c
@@ -596,8 +596,7 @@ static int fixup_options(struct thread_data *td)
 	if (o->norandommap && o->verify != VERIFY_NONE
 	    && !fixed_block_size(o))  {
 		log_err("fio: norandommap given for variable block sizes, "
-			"verify disabled\n");
-		o->verify = VERIFY_NONE;
+			"verify limited\n");
 		ret = warnings_fatal;
 	}
 	if (o->bs_unaligned && (o->odirect || td->io_ops->flags & FIO_RAWIO))
diff --git a/iolog.c b/iolog.c
index 99f8bc1..b867583 100644
--- a/iolog.c
+++ b/iolog.c
@@ -250,6 +250,7 @@ restart:
 	p = &td->io_hist_tree.rb_node;
 	parent = NULL;
 	while (*p) {
+		int overlap = 0;
 		parent = *p;
 
 		__ipo = rb_entry(parent, struct io_piece, rb_node);
@@ -257,11 +258,18 @@ restart:
 			p = &(*p)->rb_left;
 		else if (ipo->file > __ipo->file)
 			p = &(*p)->rb_right;
-		else if (ipo->offset < __ipo->offset)
+		else if (ipo->offset < __ipo->offset) {
 			p = &(*p)->rb_left;
-		else if (ipo->offset > __ipo->offset)
+			overlap = ipo->offset + ipo->len > __ipo->offset;
+		}
+		else if (ipo->offset > __ipo->offset) {
 			p = &(*p)->rb_right;
-		else {
+			overlap = __ipo->offset + __ipo->len > ipo->offset;
+		}
+		else
+			overlap = 1;
+
+		if (overlap) {
 			dprint(FD_IO, "iolog: overlap %llu/%lu, %llu/%lu",
 				__ipo->offset, __ipo->len,
 				ipo->offset, ipo->len);
