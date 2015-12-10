Return-Path: <axboe@kernel.dk>
Date: Thu, 10 Dec 2015 11:15:04 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Exit all jobs on error
Message-ID: <20151210181504.GA21415@kernel.dk>
References: <CALjAwxhfyQ3ppw-MXoRwAkhk4+-LSJSTkZQa32ymKizKU0Ox-A@mail.gmail.com>
 <5669B23C.1020001@kernel.dk>
 <CALjAwxjLXTCRe0Ky08DB6in2aq_czkx5Oz8Osi7Mo=+7eFH9PQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALjAwxjLXTCRe0Ky08DB6in2aq_czkx5Oz8Osi7Mo=+7eFH9PQ@mail.gmail.com>
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Thu, Dec 10 2015, Sitsofe Wheeler wrote:
> On 10 December 2015 at 17:11, Jens Axboe <axboe@kernel.dk> wrote:
> > On 12/10/2015 12:01 AM, Sitsofe Wheeler wrote:
> >>
> >> Hi,
> >>
> >> Is there an option to exit all jobs but only on error? If I have a job
> >> like this
> >>
> >> [global]
> >> stonewall=1
> >> verify=crc32
> >> rw=write
> >> [pass1]
> >> bs=4k
> >> [pass2]
> >> bs=8k
> >>
> >> I want fio to stop if pass1 fails verification and for pass2 not to be
> >> performed at all. I'm aware of "exitall" but using that will make fio
> >> quit even if pass1 is successful.
> >
> >
> > That doesn't exist, but we could add a exitall_on_error to have that
> > behavior. Should be pretty easy to add.
> 
> That would work for me - that way it could be put in the global
> section or per (stonewall) group.

Something like the below should work. Apart from the 'adding the option'
sugar, it's a few lines of changes. If you could test, that'd be great.


diff --git a/HOWTO b/HOWTO
index eb9c8245d4e3..b21d27e3b15f 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1227,6 +1227,9 @@ exitall		When one job finishes, terminate the rest. The default is
 		to wait for each job to finish, sometimes that is not the
 		desired action.
 
+exitall_on_error	When one job finishes in error, terminate the rest. The
+		default is to wait for each job to finish.
+
 bwavgtime=int	Average the calculated bandwidth over the given time. Value
 		is specified in milliseconds.
 
diff --git a/backend.c b/backend.c
index 425b0ee94c37..e37fffb7b183 100644
--- a/backend.c
+++ b/backend.c
@@ -974,7 +974,7 @@ reap:
 
 		if (!in_ramp_time(td) && should_check_rate(td)) {
 			if (check_min_rate(td, &comp_time)) {
-				if (exitall_on_terminate)
+				if (exitall_on_terminate || td->o.exitall_error)
 					fio_terminate_threads(td->groupid);
 				td_verror(td, EIO, "check_min_rate");
 				break;
@@ -1662,7 +1662,7 @@ static void *thread_main(void *data)
 	if (o->exec_postrun)
 		exec_string(o, o->exec_postrun, (const char *)"postrun");
 
-	if (exitall_on_terminate)
+	if (exitall_on_terminate || (o->exitall_error && td->error))
 		fio_terminate_threads(td->groupid);
 
 err:
diff --git a/cconv.c b/cconv.c
index c0168c47d7dd..a476aad6376a 100644
--- a/cconv.c
+++ b/cconv.c
@@ -167,6 +167,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->fsync_on_close = le32_to_cpu(top->fsync_on_close);
 	o->bs_is_seq_rand = le32_to_cpu(top->bs_is_seq_rand);
 	o->random_distribution = le32_to_cpu(top->random_distribution);
+	o->exitall_error = le32_to_cpu(top->exitall_error);
 	o->zipf_theta.u.f = fio_uint64_to_double(le64_to_cpu(top->zipf_theta.u.i));
 	o->pareto_h.u.f = fio_uint64_to_double(le64_to_cpu(top->pareto_h.u.i));
 	o->gauss_dev.u.f = fio_uint64_to_double(le64_to_cpu(top->gauss_dev.u.i));
@@ -353,6 +354,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->fsync_on_close = cpu_to_le32(o->fsync_on_close);
 	top->bs_is_seq_rand = cpu_to_le32(o->bs_is_seq_rand);
 	top->random_distribution = cpu_to_le32(o->random_distribution);
+	top->exitall_error = cpu_to_le32(o->exitall_error);
 	top->zipf_theta.u.i = __cpu_to_le64(fio_double_to_uint64(o->zipf_theta.u.f));
 	top->pareto_h.u.i = __cpu_to_le64(fio_double_to_uint64(o->pareto_h.u.f));
 	top->gauss_dev.u.i = __cpu_to_le64(fio_double_to_uint64(o->gauss_dev.u.f));
diff --git a/fio.1 b/fio.1
index eab20d779e35..4fe1be27c31c 100644
--- a/fio.1
+++ b/fio.1
@@ -1126,6 +1126,10 @@ Should be a multiple of 1MB. Default: 4MB.
 .B exitall
 Terminate all jobs when one finishes.  Default: wait for each job to finish.
 .TP
+.B exitall_on_error \fR=\fPbool
+Terminate all jobs if one job finishes in error.  Default: wait for each job
+to finish.
+.TP
 .BI bwavgtime \fR=\fPint
 Average bandwidth calculations over the given time in milliseconds.  Default:
 500ms.
diff --git a/init.c b/init.c
index 0100da213a24..63ba32481b9b 100644
--- a/init.c
+++ b/init.c
@@ -47,6 +47,7 @@ static char **job_sections;
 static int nr_job_sections;
 
 int exitall_on_terminate = 0;
+int exitall_on_terminate_error = 0;
 int output_format = FIO_OUTPUT_NORMAL;
 int eta_print = FIO_ETA_AUTO;
 int eta_new_line = 0;
diff --git a/options.c b/options.c
index 627029cd732c..46d5fb92ea98 100644
--- a/options.c
+++ b/options.c
@@ -3141,6 +3141,15 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_PROCESS,
 	},
 	{
+		.name	= "exitall_on_error",
+		.lname	= "Exit-all on terminate in error",
+		.type	= FIO_OPT_BOOL,
+		.off1	= td_var_offset(unlink),
+		.help	= "Terminate all jobs when one exits in error",
+		.category = FIO_OPT_C_GENERAL,
+		.group	= FIO_OPT_G_PROCESS,
+	},
+	{
 		.name	= "stonewall",
 		.lname	= "Wait for previous",
 		.alias	= "wait_for_previous",
diff --git a/thread_options.h b/thread_options.h
index 02c867f31936..6ae0335698c1 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -131,6 +131,7 @@ struct thread_options {
 	unsigned int verify_only;
 
 	unsigned int random_distribution;
+	unsigned int exitall_error;
 
 	fio_fp64_t zipf_theta;
 	fio_fp64_t pareto_h;
@@ -376,7 +377,7 @@ struct thread_options_pack {
 	uint32_t bs_is_seq_rand;
 
 	uint32_t random_distribution;
-	uint32_t pad;
+	uint32_t exitall_error;
 
 	fio_fp64_t zipf_theta;
 	fio_fp64_t pareto_h;

-- 
Jens Axboe


