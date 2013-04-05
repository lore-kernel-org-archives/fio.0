Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:41347 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab3DEIjM (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 5 Apr 2013 04:39:12 -0400
Date: Fri, 5 Apr 2013 10:39:02 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: How to re-use default sequential filenames?
Message-ID: <20130405083902.GL9683@kernel.dk>
References: <515DAA33.4000009@warnerbros.com>
 <20130404181946.GD9683@kernel.dk>
 <20130404184104.GE9683@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130404184104.GE9683@kernel.dk>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Alan Hagge <Alan.Hagge@warnerbros.com>
Cc: fio@vger.kernel.org

On Thu, Apr 04 2013, Jens Axboe wrote:
> On Thu, Apr 04 2013, Jens Axboe wrote:
> > On Thu, Apr 04 2013, Alan Hagge wrote:
> > > I'm trying to put together a test of the write and read speed to some new
> > > SAN storage.  Our workflow involves writing large numbers of 12 MiB files
> > > (on the order of 20,000 or so) at a time.  I'd like to set up a config file
> > > section that will write all 20,000 files then read all 20,000 files and
> > > report on the write performance and the read performance (separately).
> > > 
> > > I've tried something like this:
> > > 
> > > [global]
> > > blocksize=4m
> > > filesize=12m
> > > nrfiles=20000
> > > openfiles=1
> > > file_service_type=sequential
> > > create_on_open=1
> > > ioengine=posixaio
> > > 
> > > [write]
> > > rw=write
> > > 
> > > [read]
> > > stonewall
> > > rw=read
> > > 
> > > But the issue is that the files get created with default filenames
> > > (write.1.1, write.1.2, etc.), so that when the read job is run, it can't
> > > find any files (since it expects the files to be named read.1.1, read.1.2,
> > > etc.).  If I try to specify the "filename=" option in either section, fio no
> > > longer appends the ".<thread>.<sequence>" to the filename, but rather tries
> > > to do all I/O to a single file.
> > > 
> > > Is there a syntax for the "filename=" option that will allow me to specify a
> > > different root filename, but still use the ".<thread>.<sequence>" naming
> > > convention?  Failing that, is there any other way to accomplish my goal?
> > 
> > Good question, and no, you can't currently do that. But you should be
> > able to do that. Fio has no current option for specifying the naming. We
> > could have a fileprefix= option that allows you to set that.
> > 
> > So we currently have two options. The first option is that you take on
> > this task. The file name (if not given with filename=) is generated in
> > init.c:add_job(), here:
> > 
> > 	if (!td->o.filename && !td->files_index && !td->o.read_iolog_file) {
> > 		file_alloced = 1;
> > 
> > 		if (td->o.nr_files == 1 && exists_and_not_file(jobname))
> > 			add_file(td, jobname);
> > 		else {
> > 			for (i = 0; i < td->o.nr_files; i++) {
> > 				sprintf(fname, "%s.%d.%d", jobname,
> > 							td->thread_number, i);
> > 				add_file(td, fname);
> > 			}
> > 		}
> > 	}
> > 
> > Options are pretty easy to add, basically just an entry in the
> > fio_option options[] array in options.c with pretty much
> > self-explanatory fields. Add matching string type in fio.h to
> > thread_options{ }.
> > 
> > The other option is that you claim that you are not a programmer, and
> > then you are at the mercy of someone else (most likely me!) doing it for
> > you. Since this is a good feature request, I can be talked into that as
> > well.
> > 
> > Let me know.
> 
> OK, so I give it a quick shot, see below. Basically it allows you to set
> fileprefix= to override the jobname.threadnumber part of the file. So
> not super flexible, we'd need some reserved keywords to make it fully
> flexible. Eg it would be nifty if you could do:
> 
> fileprefix=$jobnum.$threadnum.$filenum

Changed it a bit, the option is now filename_format and it allows the
following keywords, which it replaces with the appropriate name or
number:

$jobname        Name of the job
$jobnum         Number of the job
$filenum        Number of the file in the job

So for your use case, you would do:

filename_format=testfiles.$filenum

and then 'write' and 'read' job would be sharing those files. Let me
know if it works for you.


diff --git a/HOWTO b/HOWTO
index cf6d427..76effee 100644
--- a/HOWTO
+++ b/HOWTO
@@ -285,6 +285,32 @@ filename=str	Fio normally makes up a filename based on the job name,
 		stdin or stdout. Which of the two depends on the read/write
 		direction set.
 
+filename_format=str
+		If sharing multiple files between jobs, it is usually necessary
+		to  have fio generate the exact names that you want. By default,
+		fio will name a file based on the default file format
+		specification of jobname.jobnumber.filenumber. With this
+		option, that can be customized. Fio will recognize and replace
+		the following keywords in this string:
+
+		$jobname
+			The name of the worker thread or process.
+
+		$jobnum
+			The incremental number of the worker thread or
+			process.
+
+		$filenum
+			The incremental number of the file for that worker
+			thread or process.
+
+		To have dependent jobs share a set of files, this option can
+		be set to have fio generate filenames that are shared between
+		the two. For instance, if testfiles.$filenum is specified,
+		file number 4 for any job will be named testfiles.4. The
+		default of $jobname.$jobnum.$filenum will be used if
+		no other format specifier is given.
+
 opendir=str	Tell fio to recursively add any file it can find in this
 		directory and down the file system tree.
 
@@ -405,7 +431,7 @@ filesize=int	Individual file sizes. May be a range, in which case fio
 fill_device=bool
 fill_fs=bool	Sets size to something really large and waits for ENOSPC (no
 		space left on device) as the terminating condition. Only makes
-                sense with sequential write. For a read workload, the mount
+		sense with sequential write. For a read workload, the mount
 		point will be filled first then IO started on the result. This
 		option doesn't make sense if operating on a raw device node,
 		since the size of that is already known by the file system.
diff --git a/filesetup.c b/filesetup.c
index e456186..88d6565 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -719,13 +719,14 @@ uint64_t get_start_offset(struct thread_data *td)
 int setup_files(struct thread_data *td)
 {
 	unsigned long long total_size, extend_size;
+	struct thread_options *o = &td->o;
 	struct fio_file *f;
 	unsigned int i;
 	int err = 0, need_extend;
 
 	dprint(FD_FILE, "setup files\n");
 
-	if (td->o.read_iolog_file)
+	if (o->read_iolog_file)
 		goto done;
 
 	/*
@@ -753,15 +754,16 @@ int setup_files(struct thread_data *td)
 			total_size += f->real_file_size;
 	}
 
-	if (td->o.fill_device)
+	if (o->fill_device)
 		td->fill_device_size = get_fs_free_counts(td);
 
 	/*
 	 * device/file sizes are zero and no size given, punt
 	 */
-	if ((!total_size || total_size == -1ULL) && !td->o.size &&
-	    !(td->io_ops->flags & FIO_NOIO) && !td->o.fill_device) {
-		log_err("%s: you need to specify size=\n", td->o.name);
+	if ((!total_size || total_size == -1ULL) && !o->size &&
+	    !(td->io_ops->flags & FIO_NOIO) && !o->fill_device &&
+	    !(o->nr_files && (o->file_size_low || o->file_size_high))) {
+		log_err("%s: you need to specify size=\n", o->name);
 		td_verror(td, EINVAL, "total_file_size");
 		return 1;
 	}
@@ -776,27 +778,26 @@ int setup_files(struct thread_data *td)
 	for_each_file(td, f, i) {
 		f->file_offset = get_start_offset(td);
 
-		if (!td->o.file_size_low) {
+		if (!o->file_size_low) {
 			/*
 			 * no file size range given, file size is equal to
 			 * total size divided by number of files. if that is
 			 * zero, set it to the real file size.
 			 */
-			f->io_size = td->o.size / td->o.nr_files;
+			f->io_size = o->size / o->nr_files;
 			if (!f->io_size)
 				f->io_size = f->real_file_size - f->file_offset;
-		} else if (f->real_file_size < td->o.file_size_low ||
-			   f->real_file_size > td->o.file_size_high) {
-			if (f->file_offset > td->o.file_size_low)
+		} else if (f->real_file_size < o->file_size_low ||
+			   f->real_file_size > o->file_size_high) {
+			if (f->file_offset > o->file_size_low)
 				goto err_offset;
 			/*
 			 * file size given. if it's fixed, use that. if it's a
 			 * range, generate a random size in-between.
 			 */
-			if (td->o.file_size_low == td->o.file_size_high) {
-				f->io_size = td->o.file_size_low
-						- f->file_offset;
-			} else {
+			if (o->file_size_low == o->file_size_high)
+				f->io_size = o->file_size_low - f->file_offset;
+			else {
 				f->io_size = get_rand_file_size(td)
 						- f->file_offset;
 			}
@@ -806,15 +807,15 @@ int setup_files(struct thread_data *td)
 		if (f->io_size == -1ULL)
 			total_size = -1ULL;
 		else {
-                        if (td->o.size_percent)
-                                f->io_size = (f->io_size * td->o.size_percent) / 100;
+                        if (o->size_percent)
+                                f->io_size = (f->io_size * o->size_percent) / 100;
 			total_size += f->io_size;
 		}
 
 		if (f->filetype == FIO_TYPE_FILE &&
 		    (f->io_size + f->file_offset) > f->real_file_size &&
 		    !(td->io_ops->flags & FIO_DISKLESSIO)) {
-			if (!td->o.create_on_open) {
+			if (!o->create_on_open) {
 				need_extend++;
 				extend_size += (f->io_size + f->file_offset);
 			} else
@@ -823,8 +824,8 @@ int setup_files(struct thread_data *td)
 		}
 	}
 
-	if (!td->o.size || td->o.size > total_size)
-		td->o.size = total_size;
+	if (!o->size || o->size > total_size)
+		o->size = total_size;
 
 	/*
 	 * See if we need to extend some files
@@ -833,7 +834,7 @@ int setup_files(struct thread_data *td)
 		temp_stall_ts = 1;
 		if (output_format == FIO_OUTPUT_NORMAL)
 			log_info("%s: Laying out IO file(s) (%u file(s) /"
-				 " %lluMB)\n", td->o.name, need_extend,
+				 " %lluMB)\n", o->name, need_extend,
 					extend_size >> 20);
 
 		for_each_file(td, f, i) {
@@ -844,7 +845,7 @@ int setup_files(struct thread_data *td)
 
 			assert(f->filetype == FIO_TYPE_FILE);
 			fio_file_clear_extend(f);
-			if (!td->o.fill_device) {
+			if (!o->fill_device) {
 				old_len = f->real_file_size;
 				extend_len = f->io_size + f->file_offset -
 						old_len;
@@ -867,23 +868,23 @@ int setup_files(struct thread_data *td)
 	if (err)
 		return err;
 
-	if (!td->o.zone_size)
-		td->o.zone_size = td->o.size;
+	if (!o->zone_size)
+		o->zone_size = o->size;
 
 	/*
 	 * iolog already set the total io size, if we read back
 	 * stored entries.
 	 */
-	if (!td->o.read_iolog_file)
-		td->total_io_size = td->o.size * td->o.loops;
+	if (!o->read_iolog_file)
+		td->total_io_size = o->size * o->loops;
 
 done:
-	if (td->o.create_only)
+	if (o->create_only)
 		td->done = 1;
 
 	return 0;
 err_offset:
-	log_err("%s: you need to specify valid offset=\n", td->o.name);
+	log_err("%s: you need to specify valid offset=\n", o->name);
 	return 1;
 }
 
diff --git a/fio.1 b/fio.1
index fe8ab76..0c2a243 100644
--- a/fio.1
+++ b/fio.1
@@ -151,6 +151,34 @@ a number of files by separating the names with a `:' character. `\-' is a
 reserved name, meaning stdin or stdout, depending on the read/write direction
 set.
 .TP
+.BI filename_format \fR=\fPstr
+.B If sharing multiple files between jobs, it is usually necessary to have
+fio generate the exact names that you want. By default, fio will name a file
+based on the default file format specification of
+\fBjobname.jobnumber.filenumber\fP. With this option, that can be
+customized. Fio will recognize and replace the following keywords in this
+string:
+.RS
+.RS
+.TP
+.B $jobname
+The name of the worker thread or process.
+.TP
+.B $jobnum
+The incremental number of the worker thread or process.
+.TP
+.B $filenum
+The incremental number of the file for that worker thread or process.
+.RE
+.P
+To have dependent jobs share a set of files, this option can be set to
+have fio generate filenames that are shared between the two. For instance,
+if \fBtestfiles.$filenum\fR is specified, file number 4 for any job will
+be named \fBtestfiles.4\fR. The default of \fB$jobname.$jobnum.$filenum\fR
+will be used if no other format specifier is given.
+.RE
+.P
+.TP
 .BI lockfile \fR=\fPstr
 Fio defaults to not locking any files before it does IO to them. If a file or
 file descriptor is shared, fio can serialize IO to that file to make the end
diff --git a/fio.h b/fio.h
index a1b2a93..db594ab 100644
--- a/fio.h
+++ b/fio.h
@@ -102,6 +102,7 @@ struct thread_options {
 	char *name;
 	char *directory;
 	char *filename;
+	char *filename_format;
 	char *opendir;
 	char *ioengine;
 	enum td_ddir td_ddir;
diff --git a/init.c b/init.c
index 9d15318..0da878d 100644
--- a/init.c
+++ b/init.c
@@ -799,6 +799,82 @@ static int setup_random_seeds(struct thread_data *td)
 	return 0;
 }
 
+enum {
+	FPRE_NONE = 0,
+	FPRE_JOBNAME,
+	FPRE_JOBNUM,
+	FPRE_FILENUM
+};
+
+static struct fpre_keyword {
+	const char *keyword;
+	size_t strlen;
+	int key;
+} fpre_keywords[] = {
+	{ .keyword = "$jobname",	.key = FPRE_JOBNAME, },
+	{ .keyword = "$jobnum",		.key = FPRE_JOBNUM, },
+	{ .keyword = "$filenum",	.key = FPRE_FILENUM, },
+	{ .keyword = NULL, },
+	};
+
+static char *make_filename(char *buf, struct thread_options *o,
+			   const char *jobname, int jobnum, int filenum)
+{
+	struct fpre_keyword *f;
+	char copy[PATH_MAX];
+
+	if (!o->filename_format || !strlen(o->filename_format)) {
+		sprintf(buf, "%s.%d.%d", jobname, jobnum, filenum);
+		return NULL;
+	}
+
+	for (f = &fpre_keywords[0]; f->keyword; f++)
+		f->strlen = strlen(f->keyword);
+
+	strcpy(buf, o->filename_format);
+	memset(copy, 0, sizeof(copy));
+	for (f = &fpre_keywords[0]; f->keyword; f++) {
+		do {
+			size_t pre_len, post_start = 0;
+			char *str, *dst = copy;
+
+			str = strstr(buf, f->keyword);
+			if (!str)
+				break;
+
+			pre_len = str - buf;
+			if (strlen(str) != f->strlen)
+				post_start = pre_len + f->strlen;
+
+			if (pre_len) {
+				strncpy(dst, buf, pre_len);
+				dst += pre_len;
+			}
+
+			switch (f->key) {
+			case FPRE_JOBNAME:
+				dst += sprintf(dst, "%s", jobname);
+				break;
+			case FPRE_JOBNUM:
+				dst += sprintf(dst, "%d", jobnum);
+				break;
+			case FPRE_FILENUM:
+				dst += sprintf(dst, "%d", filenum);
+				break;
+			default:
+				assert(0);
+				break;
+			}
+
+			if (post_start)
+				strcpy(dst, buf + post_start);
+
+			strcpy(buf, copy);
+		} while (1);
+	}
+
+	return buf;
+}
 /*
  * Adds a job to the list of things todo. Sanitizes the various options
  * to make sure we don't have conflicts, and initializes various
@@ -812,6 +888,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num)
 	unsigned int i;
 	char fname[PATH_MAX];
 	int numjobs, file_alloced;
+	struct thread_options *o = &td->o;
 
 	/*
 	 * the def_thread is just for options, it's not a real job
@@ -835,26 +912,23 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num)
 	if (ioengine_load(td))
 		goto err;
 
-	if (td->o.use_thread)
+	if (o->use_thread)
 		nr_thread++;
 	else
 		nr_process++;
 
-	if (td->o.odirect)
+	if (o->odirect)
 		td->io_ops->flags |= FIO_RAWIO;
 
 	file_alloced = 0;
-	if (!td->o.filename && !td->files_index && !td->o.read_iolog_file) {
+	if (!o->filename && !td->files_index && !o->read_iolog_file) {
 		file_alloced = 1;
 
-		if (td->o.nr_files == 1 && exists_and_not_file(jobname))
+		if (o->nr_files == 1 && exists_and_not_file(jobname))
 			add_file(td, jobname);
 		else {
-			for (i = 0; i < td->o.nr_files; i++) {
-				sprintf(fname, "%s.%d.%d", jobname,
-							td->thread_number, i);
-				add_file(td, fname);
-			}
+			for (i = 0; i < o->nr_files; i++)
+				add_file(td, make_filename(fname, o, jobname, td->thread_number, i));
 		}
 	}
 
@@ -879,9 +953,9 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num)
 
 	td->mutex = fio_mutex_init(FIO_MUTEX_LOCKED);
 
-	td->ts.clat_percentiles = td->o.clat_percentiles;
-	td->ts.percentile_precision = td->o.percentile_precision;
-	memcpy(td->ts.percentile_list, td->o.percentile_list, sizeof(td->o.percentile_list));
+	td->ts.clat_percentiles = o->clat_percentiles;
+	td->ts.percentile_precision = o->percentile_precision;
+	memcpy(td->ts.percentile_list, o->percentile_list, sizeof(o->percentile_list));
 
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 		td->ts.clat_stat[i].min_val = ULONG_MAX;
@@ -889,9 +963,9 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num)
 		td->ts.lat_stat[i].min_val = ULONG_MAX;
 		td->ts.bw_stat[i].min_val = ULONG_MAX;
 	}
-	td->ddir_seq_nr = td->o.ddir_seq_nr;
+	td->ddir_seq_nr = o->ddir_seq_nr;
 
-	if ((td->o.stonewall || td->o.new_group) && prev_group_jobs) {
+	if ((o->stonewall || o->new_group) && prev_group_jobs) {
 		prev_group_jobs = 0;
 		groupid++;
 	}
@@ -907,43 +981,41 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num)
 	if (setup_rate(td))
 		goto err;
 
-	if (td->o.write_lat_log) {
-		setup_log(&td->lat_log, td->o.log_avg_msec);
-		setup_log(&td->slat_log, td->o.log_avg_msec);
-		setup_log(&td->clat_log, td->o.log_avg_msec);
+	if (o->write_lat_log) {
+		setup_log(&td->lat_log, o->log_avg_msec);
+		setup_log(&td->slat_log, o->log_avg_msec);
+		setup_log(&td->clat_log, o->log_avg_msec);
 	}
-	if (td->o.write_bw_log)
-		setup_log(&td->bw_log, td->o.log_avg_msec);
-	if (td->o.write_iops_log)
-		setup_log(&td->iops_log, td->o.log_avg_msec);
+	if (o->write_bw_log)
+		setup_log(&td->bw_log, o->log_avg_msec);
+	if (o->write_iops_log)
+		setup_log(&td->iops_log, o->log_avg_msec);
 
-	if (!td->o.name)
-		td->o.name = strdup(jobname);
+	if (!o->name)
+		o->name = strdup(jobname);
 
 	if (output_format == FIO_OUTPUT_NORMAL) {
 		if (!job_add_num) {
 			if (!strcmp(td->io_ops->name, "cpuio")) {
 				log_info("%s: ioengine=cpu, cpuload=%u,"
-					 " cpucycle=%u\n", td->o.name,
-							td->o.cpuload,
-							td->o.cpucycle);
+					 " cpucycle=%u\n", o->name,
+						o->cpuload, o->cpucycle);
 			} else {
 				char *c1, *c2, *c3, *c4, *c5, *c6;
 
-				c1 = to_kmg(td->o.min_bs[DDIR_READ]);
-				c2 = to_kmg(td->o.max_bs[DDIR_READ]);
-				c3 = to_kmg(td->o.min_bs[DDIR_WRITE]);
-				c4 = to_kmg(td->o.max_bs[DDIR_WRITE]);
-				c5 = to_kmg(td->o.min_bs[DDIR_TRIM]);
-				c6 = to_kmg(td->o.max_bs[DDIR_TRIM]);
+				c1 = to_kmg(o->min_bs[DDIR_READ]);
+				c2 = to_kmg(o->max_bs[DDIR_READ]);
+				c3 = to_kmg(o->min_bs[DDIR_WRITE]);
+				c4 = to_kmg(o->max_bs[DDIR_WRITE]);
+				c5 = to_kmg(o->min_bs[DDIR_TRIM]);
+				c6 = to_kmg(o->max_bs[DDIR_TRIM]);
 
 				log_info("%s: (g=%d): rw=%s, bs=%s-%s/%s-%s/%s-%s,"
 					 " ioengine=%s, iodepth=%u\n",
-						td->o.name, td->groupid,
-						ddir_str[td->o.td_ddir],
+						o->name, td->groupid,
+						ddir_str[o->td_ddir],
 						c1, c2, c3, c4, c5, c6,
-						td->io_ops->name,
-						td->o.iodepth);
+						td->io_ops->name, o->iodepth);
 
 				free(c1);
 				free(c2);
@@ -960,7 +1032,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num)
 	 * recurse add identical jobs, clear numjobs and stonewall options
 	 * as they don't apply to sub-jobs
 	 */
-	numjobs = td->o.numjobs;
+	numjobs = o->numjobs;
 	while (--numjobs) {
 		struct thread_data *td_new = get_new_job(0, td, 1);
 
diff --git a/options.c b/options.c
index 3eb5fdc..bca217f 100644
--- a/options.c
+++ b/options.c
@@ -1132,6 +1132,14 @@ static struct fio_option options[FIO_MAX_OPTS] = {
 		.help	= "File(s) to use for the workload",
 	},
 	{
+		.name	= "filename_format",
+		.type	= FIO_OPT_STR_STORE,
+		.off1	= td_var_offset(filename_format),
+		.prio	= -1, /* must come after "directory" */
+		.help	= "Override default $jobname.$jobnum.$filenum naming",
+		.def	= "$jobname.$jobnum.$filenum",
+	},
+	{
 		.name	= "kb_base",
 		.type	= FIO_OPT_INT,
 		.off1	= td_var_offset(kb_base),

-- 
Jens Axboe

