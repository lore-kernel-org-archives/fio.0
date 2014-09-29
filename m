Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:37424 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbaI2MAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 29 Sep 2014 08:00:06 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XYZcb-0002tl-3Y
	for fio@vger.kernel.org; Mon, 29 Sep 2014 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140929120003.B42FF401CA@lyth.info>
Date: Mon, 29 Sep 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit bc095aab789a2e7d036c6d499f6c124a0c2d5de0:

  t/dedupe: fixup bloom entry calculation (2014-09-27 21:29:03 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 86d59660ca54dd2e3e2457f3683198afc2b2701c:

  Fix typo in bs_is_seq_ran option help (2014-09-28 16:25:49 -0600)

----------------------------------------------------------------
Jens Axboe (4):
      Fix bug with rw sequence offset and io_limit
      Fix bug with zone and zone skipping and io_limit
      Clarify what number_ios does in the HOWTO/man page/help
      Fix typo in bs_is_seq_ran option help

 HOWTO     |    4 +++-
 fio.1     |    4 +++-
 io_u.c    |   32 ++++++++++++++++++++++++++------
 options.c |    4 ++--
 4 files changed, 34 insertions(+), 10 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index aaa46f8..e770b99 100644
--- a/HOWTO
+++ b/HOWTO
@@ -823,7 +823,9 @@ number_ios=int	Fio will normally perform IOs until it has exhausted the size
 		time (or hits an error condition). With this setting, the
 		range/size can be set independently of the number of IOs to
 		perform. When fio reaches this number, it will exit normally
-		and report status.
+		and report status. Note that this does not extend the amount
+		of IO that will be done, it will only stop fio if this
+		condition is met before other end-of-job criteria.
 
 fsync=int	If writing to a file, issue a sync of the dirty data
 		for every number of blocks given. For example, if you give
diff --git a/fio.1 b/fio.1
index bc6c9fa..d64fbb7 100644
--- a/fio.1
+++ b/fio.1
@@ -687,7 +687,9 @@ Fio will normally perform IOs until it has exhausted the size of the region
 set by \fBsize\fR, or if it exhaust the allocated time (or hits an error
 condition). With this setting, the range/size can be set independently of
 the number of IOs to perform. When fio reaches this number, it will exit
-normally and report status.
+normally and report status. Note that this does not extend the amount
+of IO that will be done, it will only stop fio if this condition is met
+before other end-of-job criteria.
 .TP
 .BI fsync \fR=\fPint
 How many I/Os to perform before issuing an \fBfsync\fR\|(2) of dirty data.  If
diff --git a/io_u.c b/io_u.c
index 8546899..9adc31b 100644
--- a/io_u.c
+++ b/io_u.c
@@ -271,20 +271,32 @@ static int get_next_rand_block(struct thread_data *td, struct fio_file *f,
 static int get_next_seq_offset(struct thread_data *td, struct fio_file *f,
 			       enum fio_ddir ddir, uint64_t *offset)
 {
+	struct thread_options *o = &td->o;
+
 	assert(ddir_rw(ddir));
 
-	if (f->last_pos >= f->io_size + get_start_offset(td, f) && td->o.time_based)
+	if (f->last_pos >= f->io_size + get_start_offset(td, f) &&
+	    o->time_based)
 		f->last_pos = f->last_pos - f->io_size;
 
 	if (f->last_pos < f->real_file_size) {
 		uint64_t pos;
 
-		if (f->last_pos == f->file_offset && td->o.ddir_seq_add < 0)
+		if (f->last_pos == f->file_offset && o->ddir_seq_add < 0)
 			f->last_pos = f->real_file_size;
 
 		pos = f->last_pos - f->file_offset;
-		if (pos)
-			pos += td->o.ddir_seq_add;
+		if (pos && o->ddir_seq_add) {
+			pos += o->ddir_seq_add;
+
+			/*
+			 * If we reach beyond the end of the file
+			 * with holed IO, wrap around to the
+			 * beginning again.
+			 */
+			if (pos >= f->real_file_size)
+				pos = f->file_offset;
+		}
 
 		*offset = pos;
 		return 0;
@@ -748,9 +760,17 @@ static int fill_io_u(struct thread_data *td, struct io_u *io_u)
 	 * See if it's time to switch to a new zone
 	 */
 	if (td->zone_bytes >= td->o.zone_size && td->o.zone_skip) {
+		struct fio_file *f = io_u->file;
+
 		td->zone_bytes = 0;
-		io_u->file->file_offset += td->o.zone_range + td->o.zone_skip;
-		io_u->file->last_pos = io_u->file->file_offset;
+		f->file_offset += td->o.zone_range + td->o.zone_skip;
+
+		/*
+		 * Wrap from the beginning, if we exceed the file size
+		 */
+		if (f->file_offset >= f->real_file_size)
+			f->file_offset = f->real_file_size - f->file_offset;
+		f->last_pos = f->file_offset;
 		td->io_skip_bytes += td->o.zone_skip;
 	}
 
diff --git a/options.c b/options.c
index 56e9108..918de8e 100644
--- a/options.c
+++ b/options.c
@@ -1726,7 +1726,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "Number of IOs to perform",
 		.type	= FIO_OPT_STR_VAL,
 		.off1	= td_var_offset(number_ios),
-		.help	= "Force job completion of this number of IOs",
+		.help	= "Force job completion after this number of IOs",
 		.def	= "0",
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_INVALID,
@@ -1811,7 +1811,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "Block size division is seq/random (not read/write)",
 		.type	= FIO_OPT_BOOL,
 		.off1	= td_var_offset(bs_is_seq_rand),
-		.help	= "Consider any blocksize setting to be sequential,ramdom",
+		.help	= "Consider any blocksize setting to be sequential,random",
 		.def	= "0",
 		.parent = "blocksize",
 		.category = FIO_OPT_C_IO,
