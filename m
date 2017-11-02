Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:56192 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752377AbdKBMAS (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 2 Nov 2017 08:00:18 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1eAEAT-0000om-DC
        for fio@vger.kernel.org; Thu, 02 Nov 2017 12:00:17 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20171102120002.1F59A2C23D1@kernel.dk>
Date: Thu,  2 Nov 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 1633aa61a68593b4a4cc5dbb621129303a7c3049:

  engines/windowsaio: style fixups (2017-10-31 14:01:16 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c89daa4a98e6f3749ffc75b727a77cc061a0a454:

  io_u: reset file to initial offset (2017-11-01 14:51:03 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      io_u: wrap to beginning when end-of-file is reached for time_based
      io_u: reset file to initial offset

 io_u.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

---

Diff of recent changes:

diff --git a/io_u.c b/io_u.c
index 4246edf..81ee724 100644
--- a/io_u.c
+++ b/io_u.c
@@ -361,16 +361,13 @@ static int get_next_seq_offset(struct thread_data *td, struct fio_file *f,
 
 	assert(ddir_rw(ddir));
 
+	/*
+	 * If we reach the end for a time based run, reset us back to 0
+	 * and invalidate the cache, if we need to.
+	 */
 	if (f->last_pos[ddir] >= f->io_size + get_start_offset(td, f) &&
 	    o->time_based) {
-		struct thread_options *o = &td->o;
-		uint64_t io_size = f->io_size + (f->io_size % o->min_bs[ddir]);
-
-		if (io_size > f->last_pos[ddir])
-			f->last_pos[ddir] = 0;
-		else
-			f->last_pos[ddir] = f->last_pos[ddir] - io_size;
-
+		f->last_pos[ddir] = f->file_offset;
 		loop_cache_invalidate(td, f);
 	}
 
