Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:58233 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631AbaCRMAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 18 Mar 2014 08:00:06 -0400
Received: from kernel.dk ([54.225.238.116] helo=strynoevaenget.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WPsge-0007iU-AD
	for fio@vger.kernel.org; Tue, 18 Mar 2014 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140318120003.39B33400C6@strynoevaenget.dk>
Date: Tue, 18 Mar 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 7750aac43ee4e0c001860426e6fdaf22d9ddfc76:

  Update documentation on zero_buffers / scramble_buffers (2014-03-14 19:41:07 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 0aae4ce7dbc93fe5770b25c76f5b6242ce398b7a:

  Update file_append documentation (2014-03-17 12:55:08 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      Add support for file appends
      Update file_append documentation

 HOWTO            |    6 ++++++
 cconv.c          |    2 ++
 file.h           |    2 +-
 filesetup.c      |    9 +++++++--
 fio.1            |    6 ++++++
 fio.h            |    1 +
 init.c           |   13 +------------
 io_u.c           |    7 ++++---
 options.c        |   21 ++++++++++++++++++++-
 thread_options.h |    2 ++
 10 files changed, 50 insertions(+), 19 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 0f9c0fc..47eff96 100644
--- a/HOWTO
+++ b/HOWTO
@@ -435,6 +435,12 @@ filesize=int	Individual file sizes. May be a range, in which case fio
 		and limited to 'size' in total (if that is given). If not
 		given, each created file is the same size.
 
+file_append=bool	Perform IO after the end of the file. Normally fio will
+		operate within the size of a file. If this option is set, then
+		fio will append to the file instead. This has identical
+		behavior to setting offset to the size of a file. This option
+		is ignored on non-regular files.
+
 fill_device=bool
 fill_fs=bool	Sets size to something really large and waits for ENOSPC (no
 		space left on device) as the terminating condition. Only makes
diff --git a/cconv.c b/cconv.c
index 357a784..2843a71 100644
--- a/cconv.c
+++ b/cconv.c
@@ -79,6 +79,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->size = le64_to_cpu(top->size);
 	o->size_percent = le32_to_cpu(top->size_percent);
 	o->fill_device = le32_to_cpu(top->fill_device);
+	o->file_append = le32_to_cpu(top->file_append);
 	o->file_size_low = le64_to_cpu(top->file_size_low);
 	o->file_size_high = le64_to_cpu(top->file_size_high);
 	o->start_offset = le64_to_cpu(top->start_offset);
@@ -280,6 +281,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->iodepth_batch_complete = cpu_to_le32(o->iodepth_batch_complete);
 	top->size_percent = cpu_to_le32(o->size_percent);
 	top->fill_device = cpu_to_le32(o->fill_device);
+	top->file_append = cpu_to_le32(o->file_append);
 	top->ratecycle = cpu_to_le32(o->ratecycle);
 	top->nr_files = cpu_to_le32(o->nr_files);
 	top->open_files = cpu_to_le32(o->open_files);
diff --git a/file.h b/file.h
index c929d1d..add7773 100644
--- a/file.h
+++ b/file.h
@@ -159,7 +159,7 @@ FILE_FLAG_FNS(partial_mmap);
 struct thread_data;
 extern void close_files(struct thread_data *);
 extern void close_and_free_files(struct thread_data *);
-extern uint64_t get_start_offset(struct thread_data *);
+extern uint64_t get_start_offset(struct thread_data *, struct fio_file *);
 extern int __must_check setup_files(struct thread_data *);
 extern int __must_check file_invalidate_cache(struct thread_data *, struct fio_file *);
 extern int __must_check generic_open_file(struct thread_data *, struct fio_file *);
diff --git a/filesetup.c b/filesetup.c
index 4bfa470..c3c0fc4 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -722,8 +722,13 @@ static unsigned long long get_fs_free_counts(struct thread_data *td)
 	return ret;
 }
 
-uint64_t get_start_offset(struct thread_data *td)
+uint64_t get_start_offset(struct thread_data *td, struct fio_file *f)
 {
+	struct thread_options *o = &td->o;
+
+	if (o->file_append && f->filetype == FIO_TYPE_FILE)
+		return f->real_file_size;
+
 	return td->o.start_offset +
 		(td->thread_number - 1) * td->o.offset_increment;
 }
@@ -810,7 +815,7 @@ int setup_files(struct thread_data *td)
 	extend_size = total_size = 0;
 	need_extend = 0;
 	for_each_file(td, f, i) {
-		f->file_offset = get_start_offset(td);
+		f->file_offset = get_start_offset(td, f);
 
 		if (!o->file_size_low) {
 			/*
diff --git a/fio.1 b/fio.1
index 20f0c09..91f96e0 100644
--- a/fio.1
+++ b/fio.1
@@ -386,6 +386,12 @@ for files at random within the given range, limited to \fBsize\fR in total (if
 that is given). If \fBfilesize\fR is not specified, each created file is the
 same size.
 .TP
+.BI file_append \fR=\fPbool
+Perform IO after the end of the file. Normally fio will operate within the
+size of a file. If this option is set, then fio will append to the file
+instead. This has identical behavior to setting \fRoffset\fP to the size
+of a file. This option is ignored on non-regular files.
+.TP
 .BI blocksize \fR=\fPint[,int] "\fR,\fB bs" \fR=\fPint[,int]
 Block size for I/O units.  Default: 4k.  Values for reads, writes, and trims
 can be specified separately in the format \fIread\fR,\fIwrite\fR,\fItrim\fR
diff --git a/fio.h b/fio.h
index 52f1def..befdce3 100644
--- a/fio.h
+++ b/fio.h
@@ -71,6 +71,7 @@ enum {
 	TD_F_SCRAMBLE_BUFFERS	= 16,
 	TD_F_VER_NONE		= 32,
 	TD_F_PROFILE_OPS	= 64,
+	TD_F_COMPRESS		= 128,
 };
 
 enum {
diff --git a/init.c b/init.c
index 0a872c0..73ec9eb 100644
--- a/init.c
+++ b/init.c
@@ -856,11 +856,6 @@ int ioengine_load(struct thread_data *td)
 	return 0;
 }
 
-static int compression_enabled(struct thread_options *o)
-{
-	return o->compress_percentage || o->compress_chunk;
-}
-
 static void init_flags(struct thread_data *td)
 {
 	struct thread_options *o = &td->o;
@@ -873,14 +868,8 @@ static void init_flags(struct thread_data *td)
 		td->flags |= TD_F_READ_IOLOG;
 	if (o->refill_buffers)
 		td->flags |= TD_F_REFILL_BUFFERS;
-
-	/*
-	 * Don't scramble buffers if we set any of the compression
-	 * settings
-	 */
-	if (o->scramble_buffers && !compression_enabled(o))
+	if (o->scramble_buffers)
 		td->flags |= TD_F_SCRAMBLE_BUFFERS;
-
 	if (o->verify != VERIFY_NONE)
 		td->flags |= TD_F_VER_NONE;
 }
diff --git a/io_u.c b/io_u.c
index 0b86d9f..2f6aecf 100644
--- a/io_u.c
+++ b/io_u.c
@@ -273,7 +273,7 @@ static int get_next_seq_offset(struct thread_data *td, struct fio_file *f,
 {
 	assert(ddir_rw(ddir));
 
-	if (f->last_pos >= f->io_size + get_start_offset(td) && td->o.time_based)
+	if (f->last_pos >= f->io_size + get_start_offset(td, f) && td->o.time_based)
 		f->last_pos = f->last_pos - f->io_size;
 
 	if (f->last_pos < f->real_file_size) {
@@ -415,7 +415,7 @@ static inline int io_u_fits(struct thread_data *td, struct io_u *io_u,
 {
 	struct fio_file *f = io_u->file;
 
-	return io_u->offset + buflen <= f->io_size + get_start_offset(td);
+	return io_u->offset + buflen <= f->io_size + get_start_offset(td, f);
 }
 
 static unsigned int __get_next_buflen(struct thread_data *td, struct io_u *io_u,
@@ -1490,7 +1490,8 @@ struct io_u *get_io_u(struct thread_data *td)
 			if (td->flags & TD_F_REFILL_BUFFERS) {
 				io_u_fill_buffer(td, io_u,
 					io_u->xfer_buflen, io_u->xfer_buflen);
-			} else if (td->flags & TD_F_SCRAMBLE_BUFFERS)
+			} else if ((td->flags & TD_F_SCRAMBLE_BUFFERS) &&
+				   !(td->flags & TD_F_COMPRESS))
 				do_scramble = 1;
 			if (td->flags & TD_F_VER_NONE) {
 				populate_verify_io_u(td, io_u);
diff --git a/options.c b/options.c
index 4ff4c9b..4a54c98 100644
--- a/options.c
+++ b/options.c
@@ -1002,6 +1002,15 @@ static int str_buffer_pattern_cb(void *data, const char *input)
 	return ret;
 }
 
+static int str_buffer_compress_cb(void *data, unsigned long long *il)
+{
+	struct thread_data *td = data;
+
+	td->flags |= TD_F_COMPRESS;
+	td->o.compress_percentage = *il;
+	return 0;
+}
+
 static int str_verify_pattern_cb(void *data, const char *input)
 {
 	struct thread_data *td = data;
@@ -1606,6 +1615,16 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_INVALID,
 	},
 	{
+		.name	= "file_append",
+		.lname	= "File append",
+		.type	= FIO_OPT_BOOL,
+		.off1	= td_var_offset(file_append),
+		.help	= "IO will start at the end of the file(s)",
+		.def	= "0",
+		.category = FIO_OPT_C_FILE,
+		.group	= FIO_OPT_G_INVALID,
+	},
+	{
 		.name	= "offset",
 		.lname	= "IO offset",
 		.alias	= "fileoffset",
@@ -3118,7 +3137,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "buffer_compress_percentage",
 		.lname	= "Buffer compression percentage",
 		.type	= FIO_OPT_INT,
-		.off1	= td_var_offset(compress_percentage),
+		.cb	= str_buffer_compress_cb,
 		.maxval	= 100,
 		.minval	= 0,
 		.help	= "How compressible the buffer is (approximately)",
diff --git a/thread_options.h b/thread_options.h
index bacd86b..4642120 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -54,6 +54,7 @@ struct thread_options {
 	unsigned long long size;
 	unsigned int size_percent;
 	unsigned int fill_device;
+	unsigned int file_append;
 	unsigned long long file_size_low;
 	unsigned long long file_size_high;
 	unsigned long long start_offset;
@@ -281,6 +282,7 @@ struct thread_options_pack {
 	uint64_t size;
 	uint32_t size_percent;
 	uint32_t fill_device;
+	uint32_t file_append;
 	uint64_t file_size_low;
 	uint64_t file_size_high;
 	uint64_t start_offset;
