Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46081 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115AbcAONAE (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 15 Jan 2016 08:00:04 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1aK3z1-0006Wh-NI
	for fio@vger.kernel.org; Fri, 15 Jan 2016 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160115130002.3236D2C00E7@kernel.dk>
Date: Fri, 15 Jan 2016 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 65f41ccb386850671c0651f976cd33fdfbe0644d:

  t/verify-state: one more printf type fix (2016-01-13 13:17:39 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 543e2e9d2ebdd26449a3f07934b87c8e1ff35033:

  Fix issue with termination before io_size has been reached (2016-01-14 14:44:23 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      io_u: ensure that we align new start offset properly for time_based
      Fix issue with termination before io_size has been reached

 backend.c |  2 +-
 io_u.c    | 11 +++++++++--
 2 files changed, 10 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index bd94078..2078409 100644
--- a/backend.c
+++ b/backend.c
@@ -1293,7 +1293,7 @@ static bool keep_running(struct thread_data *td)
 		if (diff < td_max_bs(td))
 			return false;
 
-		if (fio_files_done(td))
+		if (fio_files_done(td) && !td->o.io_limit)
 			return false;
 
 		return true;
diff --git a/io_u.c b/io_u.c
index 9628d5e..8d34912 100644
--- a/io_u.c
+++ b/io_u.c
@@ -285,8 +285,15 @@ static int get_next_seq_offset(struct thread_data *td, struct fio_file *f,
 	assert(ddir_rw(ddir));
 
 	if (f->last_pos[ddir] >= f->io_size + get_start_offset(td, f) &&
-	    o->time_based)
-		f->last_pos[ddir] = f->last_pos[ddir] - f->io_size;
+	    o->time_based) {
+		struct thread_options *o = &td->o;
+		uint64_t io_size = f->io_size + (f->io_size % o->min_bs[ddir]);
+
+		if (io_size > f->last_pos[ddir])
+			f->last_pos[ddir] = 0;
+		else
+			f->last_pos[ddir] = f->last_pos[ddir] - io_size;
+	}
 
 	if (f->last_pos[ddir] < f->real_file_size) {
 		uint64_t pos;
