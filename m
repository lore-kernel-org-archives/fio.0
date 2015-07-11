Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:45418 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbbGKMAJ (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 11 Jul 2015 08:00:09 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ZDtRw-0006eo-1r
	for fio@vger.kernel.org; Sat, 11 Jul 2015 12:00:08 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150711120001.9EFE02C005F@kernel.dk>
Date: Sat, 11 Jul 2015 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit fd727d9de9f22a7ad3e026bcca80f58a65410ad6:

  verify: fix bad 'from_verify' setting in do_io() (2015-07-09 13:13:43 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 7627557b4795971e0a7565f51415697c71d27c6b:

  buffer: only set refill_buffers, it it wasn't set manually (2015-07-10 09:27:02 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      Make td flags be shifts
      buffer: only set refill_buffers, it it wasn't set manually

 fio.h  | 26 +++++++++++++-------------
 init.c |  4 +++-
 2 files changed, 16 insertions(+), 14 deletions(-)

---

Diff of recent changes:

diff --git a/fio.h b/fio.h
index 4e2532f..819d4fc 100644
--- a/fio.h
+++ b/fio.h
@@ -65,19 +65,19 @@ enum {
 };
 
 enum {
-	TD_F_VER_BACKLOG	= 1,
-	TD_F_TRIM_BACKLOG	= 2,
-	TD_F_READ_IOLOG		= 4,
-	TD_F_REFILL_BUFFERS	= 8,
-	TD_F_SCRAMBLE_BUFFERS	= 16,
-	TD_F_VER_NONE		= 32,
-	TD_F_PROFILE_OPS	= 64,
-	TD_F_COMPRESS		= 128,
-	TD_F_NOIO		= 256,
-	TD_F_COMPRESS_LOG	= 512,
-	TD_F_VSTATE_SAVED	= 1024,
-	TD_F_NEED_LOCK		= 2048,
-	TD_F_CHILD		= 4096,
+	TD_F_VER_BACKLOG	= 1U << 0,
+	TD_F_TRIM_BACKLOG	= 1U << 1,
+	TD_F_READ_IOLOG		= 1U << 2,
+	TD_F_REFILL_BUFFERS	= 1U << 3,
+	TD_F_SCRAMBLE_BUFFERS	= 1U << 4,
+	TD_F_VER_NONE		= 1U << 5,
+	TD_F_PROFILE_OPS	= 1U << 6,
+	TD_F_COMPRESS		= 1U << 7,
+	TD_F_NOIO		= 1U << 8,
+	TD_F_COMPRESS_LOG	= 1U << 9,
+	TD_F_VSTATE_SAVED	= 1U << 10,
+	TD_F_NEED_LOCK		= 1U << 11,
+	TD_F_CHILD		= 1U << 12,
 };
 
 enum {
diff --git a/init.c b/init.c
index 515f314..5edd53e 100644
--- a/init.c
+++ b/init.c
@@ -662,7 +662,9 @@ static int fixup_options(struct thread_data *td)
 			ret = warnings_fatal;
 		}
 
-		o->refill_buffers = 1;
+		if (!fio_option_is_set(o, refill_buffers))
+			o->refill_buffers = 1;
+
 		if (o->max_bs[DDIR_WRITE] != o->min_bs[DDIR_WRITE] &&
 		    !o->verify_interval)
 			o->verify_interval = o->min_bs[DDIR_WRITE];
