Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:40522 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751669AbdBTNAu (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 20 Feb 2017 08:00:50 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cfnZX-0002AY-7A
        for fio@vger.kernel.org; Mon, 20 Feb 2017 13:00:07 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170220130001.E50312C076E@kernel.dk>
Date: Mon, 20 Feb 2017 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit a0cb220bbb28c68fab0b175d01dcfce38a6f835c:

  Revert "Always set ->real_file_size to -1 when failed to get file size" (2017-02-17 13:30:43 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to dbd39049ca473de7dc031cd9bf3efe992834323f:

  Revert "configure: Drop default CONFIG_LITTLE_ENDIAN for Cygwin" (2017-02-19 17:57:43 -0700)

----------------------------------------------------------------
Tomohiro Kusumi (6):
      Rename thread_options' ->io_limit to io_size
      Avoid irrelevant "offset extend ends" error message
      Add details of file number/size related options to HOWTO
      Remove irrelevant Cygwin config flag CONFIG_FADVISE
      Silence Cygwin warning "'vsprintf_s' redeclared without dllimport..."
      Revert "configure: Drop default CONFIG_LITTLE_ENDIAN for Cygwin"

 HOWTO              | 43 +++++++++++++++++++++++++++++--------------
 backend.c          | 14 +++++++-------
 cconv.c            |  4 ++--
 configure          |  3 +--
 file.h             |  1 +
 filesetup.c        | 54 +++++++++++++++++++++++++++++++++++++++++++++++-------
 fio.h              |  3 +++
 io_u.c             |  1 +
 options.c          |  5 ++++-
 os/windows/posix.c |  6 ------
 thread_options.h   |  4 ++--
 11 files changed, 97 insertions(+), 41 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index f44c626..a72d868 100644
--- a/HOWTO
+++ b/HOWTO
@@ -631,7 +631,8 @@ Job description
 
 .. option:: numjobs=int
 
-	Create the specified number of clones of this job. May be used to setup a
+	Create the specified number of clones of this job. Each clone of job
+	is spawned as an independent thread or process. May be used to setup a
 	larger number of threads/processes doing the same thing. Each thread is
 	reported separately; to see statistics for all clones as a whole, use
 	:option:`group_reporting` in conjunction with :option:`new_group`.
@@ -732,11 +733,15 @@ Target file/device
 
 	Fio normally makes up a `filename` based on the job name, thread number, and
 	file number. If you want to share files between threads in a job or several
-	jobs, specify a `filename` for each of them to override the default.  If the
-	ioengine is file based, you can specify a number of files by separating the
-	names with a ':' colon. So if you wanted a job to open :file:`/dev/sda` and
-	:file:`/dev/sdb` as the two working files, you would use
-	``filename=/dev/sda:/dev/sdb``.
+	jobs with fixed file paths, specify a `filename` for each of them to override
+	the default. If the ioengine is file based, you can specify a number of files
+	by separating the names with a ':' colon. So if you wanted a job to open
+	:file:`/dev/sda` and :file:`/dev/sdb` as the two working files, you would use
+	``filename=/dev/sda:/dev/sdb``. This also means that whenever this option is
+	specified, :option:`nrfiles` is ignored. The size of regular files specified
+	by this option will be :option:`size` divided by number of files unless
+	explicit size is specified by :option:`filesize`.
+
 	On Windows, disk devices are accessed as :file:`\\\\.\\PhysicalDrive0` for
 	the first device, :file:`\\\\.\\PhysicalDrive1` for the second etc.
 	Note: Windows and FreeBSD prevent write access to areas
@@ -798,7 +803,12 @@ Target file/device
 
 .. option:: nrfiles=int
 
-	Number of files to use for this job. Defaults to 1.
+	Number of files to use for this job. Defaults to 1. The size of files
+	will be :option:`size` divided by this unless explicit size is specified by
+	:option:`filesize`. Files are created for each thread separately, and each
+	file will have a file number within its name by default, as explained in
+	:option:`filename` section.
+
 
 .. option:: openfiles=int
 
@@ -1497,12 +1507,14 @@ I/O size
 
 .. option:: size=int
 
-	The total size of file I/O for this job. Fio will run until this many bytes
-	has been transferred, unless runtime is limited by other options (such as
-	:option:`runtime`, for instance, or increased/decreased by
-	:option:`io_size`). Unless specific :option:`nrfiles` and :option:`filesize`
-	options are given, fio will divide this size between the available files
-	specified by the job. If not set, fio will use the full size of the given
+	The total size of file I/O for each thread of this job. Fio will run until
+	this many bytes has been transferred, unless runtime is limited by other options
+	(such as :option:`runtime`, for instance, or increased/decreased by :option:`io_size`).
+	Fio will divide this size between the available files determined by options
+	such as :option:`nrfiles`, :option:`filename`, unless :option:`filesize` is
+	specified by the job. If the result of division happens to be 0, the size is
+	set to the physical size of the given files or devices.
+	If this option is not specified, fio will use the full size of the given
 	files or devices.  If the files do not exist, size must be given. It is also
 	possible to give size as a percentage between 1 and 100. If ``size=20%`` is
 	given, fio will use 20% of the full size of the given files or devices.
@@ -1526,6 +1538,8 @@ I/O size
 	Individual file sizes. May be a range, in which case fio will select sizes
 	for files at random within the given range and limited to :option:`size` in
 	total (if that is given). If not given, each created file is the same size.
+	This option overrides :option:`size` in terms of file size, which means
+	this value is used as a fixed size or possible range of each file.
 
 .. option:: file_append=bool
 
@@ -2108,7 +2122,8 @@ Threads, processes and job synchronization
 .. option:: thread
 
 	Fio defaults to forking jobs, however if this option is given, fio will use
-	:manpage:`pthread_create(3)` to create threads instead.
+	POSIX Threads function :manpage:`pthread_create(3)` to create threads instead
+	of forking processes.
 
 .. option:: wait_for=str
 
diff --git a/backend.c b/backend.c
index 1c1f2f9..4bc00e6 100644
--- a/backend.c
+++ b/backend.c
@@ -776,8 +776,8 @@ static bool io_bytes_exceeded(struct thread_data *td, uint64_t *this_bytes)
 	else
 		bytes = this_bytes[DDIR_TRIM];
 
-	if (td->o.io_limit)
-		limit = td->o.io_limit;
+	if (td->o.io_size)
+		limit = td->o.io_size;
 	else
 		limit = td->o.size;
 
@@ -851,11 +851,11 @@ static void do_io(struct thread_data *td, uint64_t *bytes_done)
 
 	total_bytes = td->o.size;
 	/*
-	* Allow random overwrite workloads to write up to io_limit
+	* Allow random overwrite workloads to write up to io_size
 	* before starting verification phase as 'size' doesn't apply.
 	*/
 	if (td_write(td) && td_random(td) && td->o.norandommap)
-		total_bytes = max(total_bytes, (uint64_t) td->o.io_limit);
+		total_bytes = max(total_bytes, (uint64_t) td->o.io_size);
 	/*
 	 * If verify_backlog is enabled, we'll run the verify in this
 	 * handler as well. For that case, we may need up to twice the
@@ -1355,8 +1355,8 @@ static bool keep_running(struct thread_data *td)
 	if (exceeds_number_ios(td))
 		return false;
 
-	if (td->o.io_limit)
-		limit = td->o.io_limit;
+	if (td->o.io_size)
+		limit = td->o.io_size;
 	else
 		limit = td->o.size;
 
@@ -1371,7 +1371,7 @@ static bool keep_running(struct thread_data *td)
 		if (diff < td_max_bs(td))
 			return false;
 
-		if (fio_files_done(td) && !td->o.io_limit)
+		if (fio_files_done(td) && !td->o.io_size)
 			return false;
 
 		return true;
diff --git a/cconv.c b/cconv.c
index 0c11629..b329bf4 100644
--- a/cconv.c
+++ b/cconv.c
@@ -97,7 +97,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->iodepth_batch_complete_min = le32_to_cpu(top->iodepth_batch_complete_min);
 	o->iodepth_batch_complete_max = le32_to_cpu(top->iodepth_batch_complete_max);
 	o->size = le64_to_cpu(top->size);
-	o->io_limit = le64_to_cpu(top->io_limit);
+	o->io_size = le64_to_cpu(top->io_size);
 	o->size_percent = le32_to_cpu(top->size_percent);
 	o->fill_device = le32_to_cpu(top->fill_device);
 	o->file_append = le32_to_cpu(top->file_append);
@@ -521,7 +521,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	memcpy(top->buffer_pattern, o->buffer_pattern, MAX_PATTERN_SIZE);
 
 	top->size = __cpu_to_le64(o->size);
-	top->io_limit = __cpu_to_le64(o->io_limit);
+	top->io_size = __cpu_to_le64(o->io_size);
 	top->verify_backlog = __cpu_to_le64(o->verify_backlog);
 	top->start_delay = __cpu_to_le64(o->start_delay);
 	top->start_delay_high = __cpu_to_le64(o->start_delay_high);
diff --git a/configure b/configure
index be29db9..44d215f 100755
--- a/configure
+++ b/configure
@@ -306,14 +306,13 @@ CYGWIN*)
       fi
     fi
   fi
+  output_sym "CONFIG_LITTLE_ENDIAN"
   if test ! -z "$build_32bit_win" && test "$build_32bit_win" = "yes"; then
     output_sym "CONFIG_32BIT"
   else
     output_sym "CONFIG_64BIT_LLP64"
   fi
-  output_sym "CONFIG_FADVISE"
   output_sym "CONFIG_SOCKLEN_T"
-  output_sym "CONFIG_FADVISE"
   output_sym "CONFIG_SFAA"
   output_sym "CONFIG_RUSAGE_THREAD"
   output_sym "CONFIG_WINDOWSAIO"
diff --git a/file.h b/file.h
index ac00ff8..611470c 100644
--- a/file.h
+++ b/file.h
@@ -90,6 +90,7 @@ struct fio_file {
 
 	/*
 	 * size of the file, offset into file, and io size from that offset
+	 * (be aware io_size is different from thread_options::io_size)
 	 */
 	uint64_t real_file_size;
 	uint64_t file_offset;
diff --git a/filesetup.c b/filesetup.c
index e2585ee..793b08d 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -130,6 +130,9 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 	}
 #endif /* CONFIG_POSIX_FALLOCATE */
 
+	/*
+	 * If our jobs don't require regular files initially, we're done.
+	 */
 	if (!new_layout)
 		goto done;
 
@@ -374,12 +377,26 @@ static int get_file_size(struct thread_data *td, struct fio_file *f)
 		ret = bdev_size(td, f);
 	else if (f->filetype == FIO_TYPE_CHAR)
 		ret = char_size(td, f);
-	else
+	else {
 		f->real_file_size = -1;
+		log_info("%s: failed to get file size of %s\n", td->o.name,
+					f->file_name);
+		return 1; /* avoid offset extends end error message */
+	}
 
+	/*
+	 * Leave ->real_file_size with 0 since it could be expectation
+	 * of initial setup for regular files.
+	 */
 	if (ret)
 		return ret;
 
+	/*
+	 * ->file_offset normally hasn't been initialized yet, so this
+	 * is basically always false unless ->real_file_size is -1, but
+	 * if ->real_file_size is -1 this message doesn't make sense.
+	 * As a result, this message is basically useless.
+	 */
 	if (f->file_offset > f->real_file_size) {
 		log_err("%s: offset extends end (%llu > %llu)\n", td->o.name,
 					(unsigned long long) f->file_offset,
@@ -649,6 +666,10 @@ open_again:
 	return 0;
 }
 
+/*
+ * This function i.e. get_file_size() is the default .get_file_size
+ * implementation of majority of I/O engines.
+ */
 int generic_get_file_size(struct thread_data *td, struct fio_file *f)
 {
 	return get_file_size(td, f);
@@ -676,6 +697,13 @@ static int get_file_sizes(struct thread_data *td)
 			clear_error(td);
 		}
 
+		/*
+		 * There are corner cases where we end up with -1 for
+		 * ->real_file_size due to unsupported file type, etc.
+		 * We then just set to size option value divided by number
+		 * of files, similar to the way file ->io_size is set.
+		 * stat(2) failure doesn't set ->real_file_size to -1.
+		 */
 		if (f->real_file_size == -1ULL && td->o.size)
 			f->real_file_size = td->o.size / td->o.nr_files;
 	}
@@ -792,7 +820,9 @@ int setup_files(struct thread_data *td)
 		goto done;
 
 	/*
-	 * if ioengine defines a setup() method, it's responsible for
+	 * Find out physical size of files or devices for this thread,
+	 * before we determine I/O size and range of our targets.
+	 * If ioengine defines a setup() method, it's responsible for
 	 * opening the files and setting f->real_file_size to indicate
 	 * the valid range for that file.
 	 */
@@ -833,7 +863,7 @@ int setup_files(struct thread_data *td)
 
 	/*
 	 * Calculate per-file size and potential extra size for the
-	 * first files, if needed.
+	 * first files, if needed (i.e. if we don't have a fixed size).
 	 */
 	if (!o->file_size_low && o->nr_files) {
 		uint64_t all_fs;
@@ -855,9 +885,17 @@ int setup_files(struct thread_data *td)
 	for_each_file(td, f, i) {
 		f->file_offset = get_start_offset(td, f);
 
+		/*
+		 * Update ->io_size depending on options specified.
+		 * ->file_size_low being 0 means filesize option isn't set.
+		 * Non zero ->file_size_low equals ->file_size_high means
+		 * filesize option is set in a fixed size format.
+		 * Non zero ->file_size_low not equals ->file_size_high means
+		 * filesize option is set in a range format.
+		 */
 		if (!o->file_size_low) {
 			/*
-			 * no file size range given, file size is equal to
+			 * no file size or range given, file size is equal to
 			 * total size divided by number of files. If that is
 			 * zero, set it to the real file size. If the size
 			 * doesn't divide nicely with the min blocksize,
@@ -940,7 +978,9 @@ int setup_files(struct thread_data *td)
 	}
 
 	/*
-	 * See if we need to extend some files
+	 * See if we need to extend some files, typically needed when our
+	 * target regular files don't exist yet, but our jobs require them
+	 * initially due to read I/Os.
 	 */
 	if (need_extend) {
 		temp_stall_ts = 1;
@@ -993,8 +1033,8 @@ int setup_files(struct thread_data *td)
 	 * stored entries.
 	 */
 	if (!o->read_iolog_file) {
-		if (o->io_limit)
-			td->total_io_size = o->io_limit * o->loops;
+		if (o->io_size)
+			td->total_io_size = o->io_size * o->loops;
 		else
 			td->total_io_size = o->size * o->loops;
 	}
diff --git a/fio.h b/fio.h
index 19ac0af..b2f0e2f 100644
--- a/fio.h
+++ b/fio.h
@@ -646,6 +646,9 @@ extern void lat_target_check(struct thread_data *);
 extern void lat_target_init(struct thread_data *);
 extern void lat_target_reset(struct thread_data *);
 
+/*
+ * Iterates all threads/processes within all the defined jobs
+ */
 #define for_each_td(td, i)	\
 	for ((i) = 0, (td) = &threads[0]; (i) < (int) thread_number; (i)++, (td)++)
 #define for_each_file(td, f, i)	\
diff --git a/io_u.c b/io_u.c
index 69bec4b..46d9731 100644
--- a/io_u.c
+++ b/io_u.c
@@ -62,6 +62,7 @@ static uint64_t last_block(struct thread_data *td, struct fio_file *f,
 
 	/*
 	 * Hmm, should we make sure that ->io_size <= ->real_file_size?
+	 * -> not for now since there is code assuming it could go either.
 	 */
 	max_size = f->io_size;
 	if (max_size > f->real_file_size)
diff --git a/options.c b/options.c
index 1fa99b6..a543e5a 100644
--- a/options.c
+++ b/options.c
@@ -1233,6 +1233,9 @@ static int str_filename_cb(void *data, const char *input)
 	strip_blank_front(&str);
 	strip_blank_end(str);
 
+	/*
+	 * Ignore what we may already have from nrfiles option.
+	 */
 	if (!td->files_index)
 		td->o.nr_files = 0;
 
@@ -1882,7 +1885,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.alias	= "io_limit",
 		.lname	= "IO Size",
 		.type	= FIO_OPT_STR_VAL,
-		.off1	= offsetof(struct thread_options, io_limit),
+		.off1	= offsetof(struct thread_options, io_size),
 		.help	= "Total size of I/O to be performed",
 		.interval = 1024 * 1024,
 		.category = FIO_OPT_C_IO,
diff --git a/os/windows/posix.c b/os/windows/posix.c
index f468cbf..eae8c86 100755
--- a/os/windows/posix.c
+++ b/os/windows/posix.c
@@ -40,12 +40,6 @@ HRESULT WINAPI StringCchPrintfA(
   const char *pszFormat,
   ...);
 
-int vsprintf_s(
-  char *buffer,
-  size_t numberOfElements,
-  const char *format,
-  va_list argptr);
-
 int win_to_posix_error(DWORD winerr)
 {
 	switch (winerr)
diff --git a/thread_options.h b/thread_options.h
index dd5b9ef..5e72867 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -68,7 +68,7 @@ struct thread_options {
 	unsigned int unique_filename;
 
 	unsigned long long size;
-	unsigned long long io_limit;
+	unsigned long long io_size;
 	unsigned int size_percent;
 	unsigned int fill_device;
 	unsigned int file_append;
@@ -338,7 +338,7 @@ struct thread_options_pack {
 	uint32_t __proper_alignment_for_64b;
 
 	uint64_t size;
-	uint64_t io_limit;
+	uint64_t io_size;
 	uint32_t size_percent;
 	uint32_t fill_device;
 	uint32_t file_append;
