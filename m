Return-Path: <tkusumi@tuxera.com>
From: Tomohiro Kusumi <tkusumi@tuxera.com>
Subject: [PATCH 3/6] Add details of file number/size related options to HOWTO
Date: Sun, 19 Feb 2017 20:22:20 +0200
Message-ID: <20170219182223.120559-3-tkusumi@tuxera.com>
In-Reply-To: <20170219182223.120559-1-tkusumi@tuxera.com>
References: <20170219182223.120559-1-tkusumi@tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

File number/size related options for each job/thread are difficult
to understand without looking at source.

fio(1) hasn't been updated (yet). There's already quite significant
amount of diff between these two, and people are basically only
updating HOWTO.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 HOWTO       | 43 +++++++++++++++++++++++++++++--------------
 file.h      |  1 +
 filesetup.c | 38 ++++++++++++++++++++++++++++++++++----
 fio.h       |  3 +++
 io_u.c      |  1 +
 options.c   |  3 +++
 6 files changed, 71 insertions(+), 18 deletions(-)

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
index 3217e4f..793b08d 100644
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
 
@@ -381,6 +384,10 @@ static int get_file_size(struct thread_data *td, struct fio_file *f)
 		return 1; /* avoid offset extends end error message */
 	}
 
+	/*
+	 * Leave ->real_file_size with 0 since it could be expectation
+	 * of initial setup for regular files.
+	 */
 	if (ret)
 		return ret;
 
@@ -659,6 +666,10 @@ open_again:
 	return 0;
 }
 
+/*
+ * This function i.e. get_file_size() is the default .get_file_size
+ * implementation of majority of I/O engines.
+ */
 int generic_get_file_size(struct thread_data *td, struct fio_file *f)
 {
 	return get_file_size(td, f);
@@ -686,6 +697,13 @@ static int get_file_sizes(struct thread_data *td)
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
@@ -802,7 +820,9 @@ int setup_files(struct thread_data *td)
 		goto done;
 
 	/*
-	 * if ioengine defines a setup() method, it's responsible for
+	 * Find out physical size of files or devices for this thread,
+	 * before we determine I/O size and range of our targets.
+	 * If ioengine defines a setup() method, it's responsible for
 	 * opening the files and setting f->real_file_size to indicate
 	 * the valid range for that file.
 	 */
@@ -843,7 +863,7 @@ int setup_files(struct thread_data *td)
 
 	/*
 	 * Calculate per-file size and potential extra size for the
-	 * first files, if needed.
+	 * first files, if needed (i.e. if we don't have a fixed size).
 	 */
 	if (!o->file_size_low && o->nr_files) {
 		uint64_t all_fs;
@@ -865,9 +885,17 @@ int setup_files(struct thread_data *td)
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
@@ -950,7 +978,9 @@ int setup_files(struct thread_data *td)
 	}
 
 	/*
-	 * See if we need to extend some files
+	 * See if we need to extend some files, typically needed when our
+	 * target regular files don't exist yet, but our jobs require them
+	 * initially due to read I/Os.
 	 */
 	if (need_extend) {
 		temp_stall_ts = 1;
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
index 10a6e01..a543e5a 100644
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
 
-- 
2.9.3


