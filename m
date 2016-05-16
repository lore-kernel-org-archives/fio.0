Return-Path: <axboe@kernel.dk>
Subject: Re: file_service_type and random_distribution
References: <CAGjEAhstKdQQQORoniayYLuvTdfXqAkOCXdargudF7oyeM0S5Q@mail.gmail.com>
 <5739FC0D.7070106@kernel.dk>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <573A0D4D.8010205@kernel.dk>
Date: Mon, 16 May 2016 12:11:25 -0600
MIME-Version: 1.0
In-Reply-To: <5739FC0D.7070106@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: qingwei wei <tchengwee@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 05/16/2016 10:57 AM, Jens Axboe wrote:
>> I would like to confirm those points is because i intend to run
>> workload test that simulate hot file access. At any one time, the
>> files open will be less than the total files in the system and there
>> will be files that are hot and get access multiple times. Can i do it
>> using fio? Thanks.
>
> That's a good question. Currently fio doesn't, but there's no reason why
> it could not use the same distribution methods for choosing what files
> to service. That would indeed allow you to mimic some files being hotter
> than others, just like we do for offsets in that file.

Something like the below patch would allow you to do that. Basically the
options and values are idential to random_distribution, this one is just
for selecting what file to service. Just like with random_distribution,
you could use fio-genzipf to give you a good idea of what the
distribution of file uses would be.

Let me know how it works for you.


diff --git a/HOWTO b/HOWTO
index 88d10a171da9..9ed2c5f55803 100644
--- a/HOWTO
+++ b/HOWTO
@@ -673,10 +673,23 @@ file_service_type=str  Defines how fio decides 
which file from a job to
  				the next. Multiple files can still be
  				open depending on 'openfiles'.

-		The string can have a number appended, indicating how
-		often to switch to a new file. So if option random:4 is
-		given, fio will switch to a new random file after 4 ios
-		have been issued.
+			zipf	Use a zipfian distribution to decide what file
+				to access.
+
+			pareto	Use a pareto distribution to decide what file
+				to access.
+
+			gauss	Use a gaussian (normal) distribution to decide
+				what file to access.
+
+		For random, roundrobin, and sequential, a postfix can be
+		appended to tell fio how many I/Os to issue before switching
+		to a new file. For example, specifying
+		'file_service_type=random:8' would cause fio to issue 8 I/Os
+		before selecting a new file at random. For the non-uniform
+		distributions, a floating point postfix can be given to
+		influence how the distribution is skewed. See
+		'random_distribution' for a description of how that would work.

  ioengine=str	Defines how the job issues io to the file. The following
  		types are defined:
diff --git a/file.h b/file.h
index e7563b846384..e0a45275d5a5 100644
--- a/file.h
+++ b/file.h
@@ -39,13 +39,18 @@ enum file_lock_mode {
  };

  /*
- * roundrobin available files, or choose one at random, or do each one
- * serially.
+ * How fio chooses what file to service next. Choice of uniformly 
random, or
+ * some skewed random variants, or just sequentially go through them or
+ * roundrobing.
   */
  enum {
-	FIO_FSERVICE_RANDOM	= 1,
-	FIO_FSERVICE_RR		= 2,
-	FIO_FSERVICE_SEQ	= 3,
+	FIO_FSERVICE_RANDOM		= 1,
+	FIO_FSERVICE_RR			= 2,
+	FIO_FSERVICE_SEQ		= 3,
+	__FIO_FSERVICE_NONUNIFORM	= 0x100,
+	FIO_FSERVICE_ZIPF		= __FIO_FSERVICE_NONUNIFORM | 4,
+	FIO_FSERVICE_PARETO		= __FIO_FSERVICE_NONUNIFORM | 5,
+	FIO_FSERVICE_GAUSS		= __FIO_FSERVICE_NONUNIFORM | 6,
  };

  /*
diff --git a/fio.1 b/fio.1
index ebb489905707..5e4cd4ff2663 100644
--- a/fio.1
+++ b/fio.1
@@ -566,10 +566,24 @@ Round robin over opened files (default).
  .TP
  .B sequential
  Do each file in the set sequentially.
+.TP
+.B zipf
+Use a zipfian distribution to decide what file to access.
+.TP
+.B pareto
+Use a pareto distribution to decide what file to access.
+.TP
+.B gauss
+Use a gaussian (normal) distribution to decide what file to access.
  .RE
  .P
-The number of I/Os to issue before switching to a new file can be 
specified by
-appending `:\fIint\fR' to the service type.
+For \fBrandom\fR, \fBroundrobin\fR, and \fBsequential\fR, a postfix can be
+appended to tell fio how many I/Os to issue before switching to a new file.
+For example, specifying \fBfile_service_type=random:8\fR would cause fio to
+issue \fI8\fR I/Os before selecting a new file at random. For the 
non-uniform
+distributions, a floating point postfix can be given to influence how the
+distribution is skewed. See \fBrandom_distribution\fR for a description 
of how
+that would work.
  .RE
  .TP
  .BI ioengine \fR=\fPstr
diff --git a/fio.h b/fio.h
index 6a244c38896e..8b6a27220db7 100644
--- a/fio.h
+++ b/fio.h
@@ -170,6 +170,15 @@ struct thread_data {
  		unsigned int next_file;
  		struct frand_state next_file_state;
  	};
+	union {
+		struct zipf_state next_file_zipf;
+		struct gauss_state next_file_gauss;
+	};
+	union {
+		double zipf_theta;
+		double pareto_h;
+		double gauss_dev;
+	};
  	int error;
  	int sig;
  	int done;
diff --git a/init.c b/init.c
index c579d5c04c82..e9c169aee14a 100644
--- a/init.c
+++ b/init.c
@@ -929,6 +929,12 @@ static void td_fill_rand_seeds_internal(struct 
thread_data *td, bool use64)

  	if (td->o.file_service_type == FIO_FSERVICE_RANDOM)
  		init_rand_seed(&td->next_file_state, 
td->rand_seeds[FIO_RAND_FILE_OFF], use64);
+	else if (td->o.file_service_type == FIO_FSERVICE_ZIPF)
+		zipf_init(&td->next_file_zipf, td->o.nr_files, td->zipf_theta, 
td->rand_seeds[FIO_RAND_FILE_OFF]);
+	else if (td->o.file_service_type == FIO_FSERVICE_PARETO)
+		pareto_init(&td->next_file_zipf, td->o.nr_files, td->pareto_h, 
td->rand_seeds[FIO_RAND_FILE_OFF]);
+	else if (td->o.file_service_type == FIO_FSERVICE_GAUSS)
+		gauss_init(&td->next_file_gauss, td->o.nr_files, td->gauss_dev, 
td->rand_seeds[FIO_RAND_FILE_OFF]);

  	init_rand_seed(&td->file_size_state, 
td->rand_seeds[FIO_RAND_FILE_SIZE_OFF], use64);
  	init_rand_seed(&td->trim_state, td->rand_seeds[FIO_RAND_TRIM_OFF], 
use64);
diff --git a/io_u.c b/io_u.c
index f9870e70bc8d..347b71384aa6 100644
--- a/io_u.c
+++ b/io_u.c
@@ -328,7 +328,8 @@ static int get_next_rand_block(struct thread_data 
*td, struct fio_file *f,
  	if (!get_next_rand_offset(td, f, ddir, b))
  		return 0;

-	if (td->o.time_based) {
+	if (td->o.time_based ||
+	    (td->o.file_service_type & __FIO_FSERVICE_NONUNIFORM)) {
  		fio_file_reset(td, f);
  		if (!get_next_rand_offset(td, f, ddir, b))
  			return 0;
@@ -1070,6 +1071,27 @@ static void io_u_mark_latency(struct thread_data 
*td, unsigned long usec)
  		io_u_mark_lat_msec(td, usec / 1000);
  }

+static unsigned int __get_next_fileno_rand(struct thread_data *td)
+{
+	if (td->o.file_service_type == FIO_FSERVICE_RANDOM) {
+		uint64_t frand_max = rand_max(&td->next_file_state);
+		unsigned long r;
+
+		r = __rand(&td->next_file_state);
+		return (unsigned int) ((double) td->o.nr_files
+				* (r / (frand_max + 1.0)));
+	} else if (td->o.file_service_type == FIO_FSERVICE_ZIPF)
+		return zipf_next(&td->next_file_zipf);
+	else if (td->o.file_service_type == FIO_FSERVICE_PARETO)
+		return pareto_next(&td->next_file_zipf);
+	else if (td->o.file_service_type == FIO_FSERVICE_GAUSS)
+		return gauss_next(&td->next_file_gauss);
+
+	log_err("fio: bad file service type: %d\n", td->o.file_service_type);
+	assert(0);
+	return 0;
+}
+
  /*
   * Get next file to service by choosing one at random
   */
@@ -1077,17 +1099,13 @@ static struct fio_file 
*get_next_file_rand(struct thread_data *td,
  					   enum fio_file_flags goodf,
  					   enum fio_file_flags badf)
  {
-	uint64_t frand_max = rand_max(&td->next_file_state);
  	struct fio_file *f;
  	int fno;

  	do {
  		int opened = 0;
-		unsigned long r;

-		r = __rand(&td->next_file_state);
-		fno = (unsigned int) ((double) td->o.nr_files
-				* (r / (frand_max + 1.0)));
+		fno = __get_next_fileno_rand(td);

  		f = td->files[fno];
  		if (fio_file_done(f))
@@ -1240,10 +1258,14 @@ static long set_io_u_file(struct thread_data 
*td, struct io_u *io_u)
  		put_file_log(td, f);
  		td_io_close_file(td, f);
  		io_u->file = NULL;
-		fio_file_set_done(f);
-		td->nr_done_files++;
-		dprint(FD_FILE, "%s: is done (%d of %d)\n", f->file_name,
+		if (td->o.file_service_type & __FIO_FSERVICE_NONUNIFORM)
+			fio_file_reset(td, f);
+		else {
+			fio_file_set_done(f);
+			td->nr_done_files++;
+			dprint(FD_FILE, "%s: is done (%d of %d)\n", f->file_name,
  					td->nr_done_files, td->o.nr_files);
+		}
  	} while (1);

  	return 0;
diff --git a/options.c b/options.c
index 980b7e5e48d2..6d1ef82bcef6 100644
--- a/options.c
+++ b/options.c
@@ -724,12 +724,77 @@ out:
  static int str_fst_cb(void *data, const char *str)
  {
  	struct thread_data *td = data;
-	char *nr = get_opt_postfix(str);
+	double val;
+	bool done = false;
+	char *nr;

  	td->file_service_nr = 1;
-	if (nr) {
-		td->file_service_nr = atoi(nr);
+
+	switch (td->o.file_service_type) {
+	case FIO_FSERVICE_RANDOM:
+	case FIO_FSERVICE_RR:
+	case FIO_FSERVICE_SEQ:
+		nr = get_opt_postfix(str);
+		if (nr) {
+			td->file_service_nr = atoi(nr);
+			free(nr);
+		}
+		done = true;
+		break;
+	case FIO_FSERVICE_ZIPF:
+		val = FIO_DEF_ZIPF;
+		break;
+	case FIO_FSERVICE_PARETO:
+		val = FIO_DEF_PARETO;
+		break;
+	case FIO_FSERVICE_GAUSS:
+		val = 0.0;
+		break;
+	default:
+		log_err("fio: bad file service type: %d\n", td->o.file_service_type);
+		return 1;
+	}
+
+	if (done)
+		return 0;
+
+	nr = get_opt_postfix(str);
+	if (nr && !str_to_float(nr, &val, 0)) {
+		log_err("fio: file service type random postfix parsing failed\n");
  		free(nr);
+		return 1;
+	}
+
+	free(nr);
+
+	switch (td->o.file_service_type) {
+	case FIO_FSERVICE_ZIPF:
+		if (val == 1.00) {
+			log_err("fio: zipf theta must be different than 1.0\n");
+			return 1;
+		}
+		if (parse_dryrun())
+			return 0;
+		td->zipf_theta = val;
+		break;
+	case FIO_FSERVICE_PARETO:
+		if (val <= 0.00 || val >= 1.00) {
+                          log_err("fio: pareto input out of range (0 < 
input < 1.0)\n");
+                          return 1;
+		}
+		if (parse_dryrun())
+			return 0;
+		td->pareto_h = val;
+		break;
+	case FIO_FSERVICE_GAUSS:
+		if (val <= 0.00 || val >= 100.00) {
+                          log_err("fio: normal deviation out of range 
(0 < input < 100.0  )\n");
+                          return 1;
+		}
+		if (parse_dryrun())
+			return 0;
+		td->gauss_dev = val;
+		break;
  	}

  	return 0;
@@ -2020,7 +2085,19 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
  		.posval	= {
  			  { .ival = "random",
  			    .oval = FIO_FSERVICE_RANDOM,
-			    .help = "Choose a file at random",
+			    .help = "Choose a file at random (uniform)",
+			  },
+			  { .ival = "zipf",
+			    .oval = FIO_FSERVICE_ZIPF,
+			    .help = "Zipf randomized",
+			  },
+			  { .ival = "pareto",
+			    .oval = FIO_FSERVICE_PARETO,
+			    .help = "Pareto randomized",
+			  },
+			  { .ival = "gauss",
+			    .oval = FIO_FSERVICE_GAUSS,
+			    .help = "Normal (guassian) distribution",
  			  },
  			  { .ival = "roundrobin",
  			    .oval = FIO_FSERVICE_RR,

-- 
Jens Axboe


