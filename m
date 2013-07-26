Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:54716 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab3GZEAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 26 Jul 2013 00:00:06 -0400
Received: from kernel.dk ([54.225.238.116])
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1V2ZCH-0005eU-PR
	for fio@vger.kernel.org; Fri, 26 Jul 2013 04:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <jaxboe@fusionio.com>
Message-Id: <20130726040002.B99E4204EA@kernel.dk>
Date: Fri, 26 Jul 2013 04:00:02 +0000 (UTC)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 954cd73a9a93102c24afa869fbe67ac38af6e416:

  Update for RDMA io engine's compatibility (2013-07-22 20:58:05 -0600)

are available in the git repository at:
  git://git.kernel.dk/fio.git master

Jens Axboe (4):
      Add support for randomness of any IO direction
      init: remove leftover unused variable
      Add support for bs_is_seq_rand
      Make it clear in job output whether we are using bs_is_seq_rand or not

 HOWTO            |   21 ++++++++++------
 cconv.c          |    8 +++++-
 fio.1            |   19 ++++++++++-----
 fio.h            |    8 ++++--
 init.c           |   38 ++++++++++++++++++++++---------
 io_u.c           |   65 ++++++++++++++++++++++++++++++++++-------------------
 options.c        |   42 +++++++++++++---------------------
 parse.c          |    1 +
 profile.h        |    4 +-
 server.h         |    2 +-
 thread_options.h |    6 +++-
 11 files changed, 129 insertions(+), 85 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index a2de470..2335a07 100644
--- a/HOWTO
+++ b/HOWTO
@@ -443,9 +443,11 @@ bs=int		The block size used for the io units. Defaults to 4k. Values
 		can be given for both read and writes. If a single int is
 		given, it will apply to both. If a second int is specified
 		after a comma, it will apply to writes only. In other words,
-		the format is either bs=read_and_write or bs=read,write.
-		bs=4k,8k will thus use 4k blocks for reads, and 8k blocks
-		for writes. If you only wish to set the write size, you
+		the format is either bs=read_and_write or bs=read,write,trim.
+		bs=4k,8k will thus use 4k blocks for reads, 8k blocks for
+		writes, and 8k for trims. You can terminate the list with
+		a trailing comma. bs=4k,8k, would use the default value for
+		trims.. If you only wish to set the write size, you
 		can do so by passing an empty read size - bs=,8k will set
 		8k for writes and leave the read default value.
 
@@ -503,6 +505,11 @@ bs_unaligned	If this option is given, any byte size value within bsrange
 		may be used as a block range. This typically wont work with
 		direct IO, as that normally requires sector alignment.
 
+bs_is_seq_rand	If this option is set, fio will use the normal read,write
+		blocksize settings as sequential,random instead. Any random
+		read or write will use the WRITE blocksize settings, and any
+		sequential read or write will use the READ blocksize setting.
+
 zero_buffers	If this option is given, fio will init the IO buffers to
 		all zeroes. The default is to fill them with random data.
 
@@ -773,12 +780,10 @@ percentage_random=int	For a random workload, set how big a percentage should
 		is fully random. It can be set from anywhere from 0 to 100.
 		Setting it to 0 would make the workload fully sequential. Any
 		setting in between will result in a random mix of sequential
-		and random IO, at the given percentages.
+		and random IO, at the given percentages. It is possible to
+		set different values for reads, writes, and trim. To do so,
+		simply use a comma separated list. See blocksize.
 	
-percentage_sequential=int	See percentage_random. It is guaranteed that
-		they add up to 100. The later setting has priority, each
-		will adjust the other.
-
 norandommap	Normally fio will cover every block of the file when doing
 		random IO. If this option is given, fio will just get a
 		new random offset without looking at past io history. This
diff --git a/cconv.c b/cconv.c
index b06f60f..8e7c69e 100644
--- a/cconv.c
+++ b/cconv.c
@@ -80,6 +80,8 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 		o->ratemin[i] = le32_to_cpu(top->ratemin[i]);
 		o->rate_iops[i] = le32_to_cpu(top->rate_iops[i]);
 		o->rate_iops_min[i] = le32_to_cpu(top->rate_iops_min[i]);
+
+		o->perc_rand[i] = le32_to_cpu(top->perc_rand[i]);
 	}
 
 	o->ratecycle = le32_to_cpu(top->ratecycle);
@@ -121,11 +123,11 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->softrandommap = le32_to_cpu(top->softrandommap);
 	o->bs_unaligned = le32_to_cpu(top->bs_unaligned);
 	o->fsync_on_close = le32_to_cpu(top->fsync_on_close);
+	o->bs_is_seq_rand = le32_to_cpu(top->bs_is_seq_rand);
 	o->random_distribution = le32_to_cpu(top->random_distribution);
 	o->zipf_theta.u.f = fio_uint64_to_double(le64_to_cpu(top->zipf_theta.u.i));
 	o->pareto_h.u.f = fio_uint64_to_double(le64_to_cpu(top->pareto_h.u.i));
 	o->random_generator = le32_to_cpu(top->random_generator);
-	o->perc_rand = le32_to_cpu(top->perc_rand);
 	o->hugepage_size = le32_to_cpu(top->hugepage_size);
 	o->rw_min_bs = le32_to_cpu(top->rw_min_bs);
 	o->thinktime = le32_to_cpu(top->thinktime);
@@ -280,11 +282,11 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->softrandommap = cpu_to_le32(o->softrandommap);
 	top->bs_unaligned = cpu_to_le32(o->bs_unaligned);
 	top->fsync_on_close = cpu_to_le32(o->fsync_on_close);
+	top->bs_is_seq_rand = cpu_to_le32(o->bs_is_seq_rand);
 	top->random_distribution = cpu_to_le32(o->random_distribution);
 	top->zipf_theta.u.i = __cpu_to_le64(fio_double_to_uint64(o->zipf_theta.u.f));
 	top->pareto_h.u.i = __cpu_to_le64(fio_double_to_uint64(o->pareto_h.u.f));
 	top->random_generator = cpu_to_le32(o->random_generator);
-	top->perc_rand = cpu_to_le32(o->perc_rand);
 	top->hugepage_size = cpu_to_le32(o->hugepage_size);
 	top->rw_min_bs = cpu_to_le32(o->rw_min_bs);
 	top->thinktime = cpu_to_le32(o->thinktime);
@@ -371,6 +373,8 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 		top->ratemin[i] = cpu_to_le32(o->ratemin[i]);
 		top->rate_iops[i] = cpu_to_le32(o->rate_iops[i]);
 		top->rate_iops_min[i] = cpu_to_le32(o->rate_iops_min[i]);
+
+		top->perc_rand[i] = cpu_to_le32(o->perc_rand[i]);
 	}
 
 	memcpy(top->verify_pattern, o->verify_pattern, MAX_PATTERN_SIZE);
diff --git a/fio.1 b/fio.1
index 62f7bb6..b54eead 100644
--- a/fio.1
+++ b/fio.1
@@ -344,9 +344,10 @@ that is given). If \fBfilesize\fR is not specified, each created file is the
 same size.
 .TP
 .BI blocksize \fR=\fPint[,int] "\fR,\fB bs" \fR=\fPint[,int]
-Block size for I/O units.  Default: 4k.  Values for reads and writes can be
-specified separately in the format \fIread\fR,\fIwrite\fR, either of
-which may be empty to leave that value at its default.
+Block size for I/O units.  Default: 4k.  Values for reads, writes, and trims
+can be specified separately in the format \fIread\fR,\fIwrite\fR,\fItrim\fR
+either of which may be empty to leave that value at its default. If a trailing
+comma isn't given, the remainder will inherit the last value set.
 .TP
 .BI blocksize_range \fR=\fPirange[,irange] "\fR,\fB bsrange" \fR=\fPirange[,irange]
 Specify a range of I/O block sizes.  The issued I/O unit will always be a
@@ -378,6 +379,12 @@ for using direct IO, though it usually depends on the hardware block size.
 This option is mutually exclusive with using a random map for files, so it
 will turn off that option.
 .TP
+.BI bs_is_seq_rand \fR=\fPbool
+If this option is set, fio will use the normal read,write blocksize settings as
+sequential,random instead. Any random read or write will use the WRITE
+blocksize settings, and any sequential read or write will use the READ
+blocksize setting.
+.TP
 .B zero_buffers
 Initialise buffers with all zeros. Default: fill buffers with random data.
 .TP
@@ -648,10 +655,8 @@ fio will disable use of the random map.
 For a random workload, set how big a percentage should be random. This defaults
 to 100%, in which case the workload is fully random. It can be set from
 anywhere from 0 to 100.  Setting it to 0 would make the workload fully
-sequential.
-.TP
-.BI percentage_sequential \fR=\fPint
-See \fBpercentage_random\fR.
+sequential. It is possible to set different values for reads, writes, and
+trim. To do so, simply use a comma separated list. See \fBblocksize\fR.
 .TP
 .B norandommap
 Normally \fBfio\fR will cover every block of the file when doing random I/O. If
diff --git a/fio.h b/fio.h
index 8c67fcc..e7d5c27 100644
--- a/fio.h
+++ b/fio.h
@@ -82,7 +82,9 @@ enum {
 	FIO_RAND_FILE_SIZE_OFF,
 	FIO_RAND_TRIM_OFF,
 	FIO_RAND_BUF_OFF,
-	FIO_RAND_SEQ_RAND_OFF,
+	FIO_RAND_SEQ_RAND_READ_OFF,
+	FIO_RAND_SEQ_RAND_WRITE_OFF,
+	FIO_RAND_SEQ_RAND_TRIM_OFF,
 	FIO_RAND_NR_OFFS,
 };
 
@@ -261,8 +263,8 @@ struct thread_data {
 	 * rand/seq mixed workload state
 	 */
 	union {
-		os_random_state_t seq_rand_state;
-		struct frand_state __seq_rand_state;
+		os_random_state_t seq_rand_state[DDIR_RWDIR_CNT];
+		struct frand_state __seq_rand_state[DDIR_RWDIR_CNT];
 	};
 
 	/*
diff --git a/init.c b/init.c
index d808eb6..1afc341 100644
--- a/init.c
+++ b/init.c
@@ -701,7 +701,10 @@ static void td_fill_rand_seeds_os(struct thread_data *td)
 		td->rand_seeds[FIO_RAND_BLOCK_OFF] = FIO_RANDSEED * td->thread_number;
 
 	os_random_seed(td->rand_seeds[FIO_RAND_BLOCK_OFF], &td->random_state);
-	os_random_seed(td->rand_seeds[FIO_RAND_SEQ_RAND_OFF], &td->seq_rand_state);
+
+	os_random_seed(td->rand_seeds[FIO_RAND_SEQ_RAND_READ_OFF], &td->seq_rand_state[DDIR_READ]);
+	os_random_seed(td->rand_seeds[FIO_RAND_SEQ_RAND_WRITE_OFF], &td->seq_rand_state[DDIR_WRITE]);
+	os_random_seed(td->rand_seeds[FIO_RAND_SEQ_RAND_TRIM_OFF], &td->seq_rand_state[DDIR_TRIM]);
 }
 
 static void td_fill_rand_seeds_internal(struct thread_data *td)
@@ -723,7 +726,9 @@ static void td_fill_rand_seeds_internal(struct thread_data *td)
 		td->rand_seeds[FIO_RAND_BLOCK_OFF] = FIO_RANDSEED * td->thread_number;
 
 	init_rand_seed(&td->__random_state, td->rand_seeds[FIO_RAND_BLOCK_OFF]);
-	init_rand_seed(&td->__seq_rand_state, td->rand_seeds[FIO_RAND_SEQ_RAND_OFF]);
+	init_rand_seed(&td->__seq_rand_state[DDIR_READ], td->rand_seeds[FIO_RAND_SEQ_RAND_READ_OFF]);
+	init_rand_seed(&td->__seq_rand_state[DDIR_WRITE], td->rand_seeds[FIO_RAND_SEQ_RAND_WRITE_OFF]);
+	init_rand_seed(&td->__seq_rand_state[DDIR_TRIM], td->rand_seeds[FIO_RAND_SEQ_RAND_TRIM_OFF]);
 }
 
 void td_fill_rand_seeds(struct thread_data *td)
@@ -1030,20 +1035,31 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 				fio_server_send_add_job(td);
 
 			if (!(td->io_ops->flags & FIO_NOIO)) {
-				char *c1, *c2, *c3, *c4, *c5, *c6;
+				char *c1, *c2, *c3, *c4;
+				char *c5 = NULL, *c6 = NULL;
 
 				c1 = fio_uint_to_kmg(o->min_bs[DDIR_READ]);
 				c2 = fio_uint_to_kmg(o->max_bs[DDIR_READ]);
 				c3 = fio_uint_to_kmg(o->min_bs[DDIR_WRITE]);
 				c4 = fio_uint_to_kmg(o->max_bs[DDIR_WRITE]);
-				c5 = fio_uint_to_kmg(o->min_bs[DDIR_TRIM]);
-				c6 = fio_uint_to_kmg(o->max_bs[DDIR_TRIM]);
-
-				log_info("%s: (g=%d): rw=%s, bs=%s-%s/%s-%s/%s-%s,"
-					 " ioengine=%s, iodepth=%u\n",
-						td->o.name, td->groupid,
-						ddir_str(o->td_ddir),
-						c1, c2, c3, c4, c5, c6,
+
+				if (!o->bs_is_seq_rand) {
+					c5 = fio_uint_to_kmg(o->min_bs[DDIR_TRIM]);
+					c6 = fio_uint_to_kmg(o->max_bs[DDIR_TRIM]);
+				}
+
+				log_info("%s: (g=%d): rw=%s, ", td->o.name,
+							td->groupid,
+							ddir_str(o->td_ddir));
+
+				if (o->bs_is_seq_rand)
+					log_info("bs(seq/rand)=%s-%s/%s-%s, ",
+							c1, c2, c3, c4);
+				else
+					log_info("bs=%s-%s/%s-%s/%s-%s, ",
+							c1, c2, c3, c4, c5, c6);
+
+				log_info("ioengine=%s, iodepth=%u\n",
 						td->io_ops->name, o->iodepth);
 
 				free(c1);
diff --git a/io_u.c b/io_u.c
index 865c582..6537c90 100644
--- a/io_u.c
+++ b/io_u.c
@@ -191,23 +191,23 @@ static inline int should_sort_io(struct thread_data *td)
 	return 1;
 }
 
-static int should_do_random(struct thread_data *td)
+static int should_do_random(struct thread_data *td, enum fio_ddir ddir)
 {
 	unsigned int v;
 	unsigned long r;
 
-	if (td->o.perc_rand == 100)
+	if (td->o.perc_rand[ddir] == 100)
 		return 1;
 
 	if (td->o.use_os_rand) {
-		r = os_random_long(&td->seq_rand_state);
+		r = os_random_long(&td->seq_rand_state[ddir]);
 		v = 1 + (int) (100.0 * (r / (OS_RAND_MAX + 1.0)));
 	} else {
-		r = __rand(&td->__seq_rand_state);
+		r = __rand(&td->__seq_rand_state[ddir]);
 		v = 1 + (int) (100.0 * (r / (FRAND_MAX + 1.0)));
 	}
 
-	return v <= td->o.perc_rand;
+	return v <= td->o.perc_rand[ddir];
 }
 
 static int get_next_rand_offset(struct thread_data *td, struct fio_file *f,
@@ -293,7 +293,8 @@ static int get_next_seq_offset(struct thread_data *td, struct fio_file *f,
 }
 
 static int get_next_block(struct thread_data *td, struct io_u *io_u,
-			  enum fio_ddir ddir, int rw_seq)
+			  enum fio_ddir ddir, int rw_seq,
+			  unsigned int *is_random)
 {
 	struct fio_file *f = io_u->file;
 	uint64_t b, offset;
@@ -305,23 +306,30 @@ static int get_next_block(struct thread_data *td, struct io_u *io_u,
 
 	if (rw_seq) {
 		if (td_random(td)) {
-			if (should_do_random(td))
+			if (should_do_random(td, ddir)) {
 				ret = get_next_rand_block(td, f, ddir, &b);
-			else {
+				*is_random = 1;
+			} else {
+				*is_random = 0;
 				io_u->flags |= IO_U_F_BUSY_OK;
 				ret = get_next_seq_offset(td, f, ddir, &offset);
 				if (ret)
 					ret = get_next_rand_block(td, f, ddir, &b);
 			}
-		} else
+		} else {
+			*is_random = 0;
 			ret = get_next_seq_offset(td, f, ddir, &offset);
+		}
 	} else {
 		io_u->flags |= IO_U_F_BUSY_OK;
+		*is_random = 0;
 
 		if (td->o.rw_seq == RW_SEQ_SEQ) {
 			ret = get_next_seq_offset(td, f, ddir, &offset);
-			if (ret)
+			if (ret) {
 				ret = get_next_rand_block(td, f, ddir, &b);
+				*is_random = 0;
+			}
 		} else if (td->o.rw_seq == RW_SEQ_IDENT) {
 			if (f->last_start != -1ULL)
 				offset = f->last_start - f->file_offset;
@@ -353,7 +361,8 @@ static int get_next_block(struct thread_data *td, struct io_u *io_u,
  * until we find a free one. For sequential io, just return the end of
  * the last io issued.
  */
-static int __get_next_offset(struct thread_data *td, struct io_u *io_u)
+static int __get_next_offset(struct thread_data *td, struct io_u *io_u,
+			     unsigned int *is_random)
 {
 	struct fio_file *f = io_u->file;
 	enum fio_ddir ddir = io_u->ddir;
@@ -366,7 +375,7 @@ static int __get_next_offset(struct thread_data *td, struct io_u *io_u)
 		td->ddir_seq_nr = td->o.ddir_seq_nr;
 	}
 
-	if (get_next_block(td, io_u, ddir, rw_seq_hit))
+	if (get_next_block(td, io_u, ddir, rw_seq_hit, is_random))
 		return 1;
 
 	if (io_u->offset >= f->io_size) {
@@ -387,16 +396,17 @@ static int __get_next_offset(struct thread_data *td, struct io_u *io_u)
 	return 0;
 }
 
-static int get_next_offset(struct thread_data *td, struct io_u *io_u)
+static int get_next_offset(struct thread_data *td, struct io_u *io_u,
+			   unsigned int *is_random)
 {
 	if (td->flags & TD_F_PROFILE_OPS) {
 		struct prof_io_ops *ops = &td->prof_io_ops;
 
 		if (ops->fill_io_u_off)
-			return ops->fill_io_u_off(td, io_u);
+			return ops->fill_io_u_off(td, io_u, is_random);
 	}
 
-	return __get_next_offset(td, io_u);
+	return __get_next_offset(td, io_u, is_random);
 }
 
 static inline int io_u_fits(struct thread_data *td, struct io_u *io_u,
@@ -407,14 +417,20 @@ static inline int io_u_fits(struct thread_data *td, struct io_u *io_u,
 	return io_u->offset + buflen <= f->io_size + get_start_offset(td);
 }
 
-static unsigned int __get_next_buflen(struct thread_data *td, struct io_u *io_u)
+static unsigned int __get_next_buflen(struct thread_data *td, struct io_u *io_u,
+				      unsigned int is_random)
 {
-	const int ddir = io_u->ddir;
+	int ddir = io_u->ddir;
 	unsigned int buflen = 0;
 	unsigned int minbs, maxbs;
 	unsigned long r, rand_max;
 
-	assert(ddir_rw(ddir));
+	assert(ddir_rw(io_u->ddir));
+
+	if (td->o.bs_is_seq_rand)
+		ddir = is_random ? DDIR_WRITE: DDIR_READ;
+	else
+		ddir = io_u->ddir;
 
 	minbs = td->o.min_bs[ddir];
 	maxbs = td->o.max_bs[ddir];
@@ -471,16 +487,17 @@ static unsigned int __get_next_buflen(struct thread_data *td, struct io_u *io_u)
 	return buflen;
 }
 
-static unsigned int get_next_buflen(struct thread_data *td, struct io_u *io_u)
+static unsigned int get_next_buflen(struct thread_data *td, struct io_u *io_u,
+				    unsigned int is_random)
 {
 	if (td->flags & TD_F_PROFILE_OPS) {
 		struct prof_io_ops *ops = &td->prof_io_ops;
 
 		if (ops->fill_io_u_size)
-			return ops->fill_io_u_size(td, io_u);
+			return ops->fill_io_u_size(td, io_u, is_random);
 	}
 
-	return __get_next_buflen(td, io_u);
+	return __get_next_buflen(td, io_u, is_random);
 }
 
 static void set_rwmix_bytes(struct thread_data *td)
@@ -715,6 +732,8 @@ void requeue_io_u(struct thread_data *td, struct io_u **io_u)
 
 static int fill_io_u(struct thread_data *td, struct io_u *io_u)
 {
+	unsigned int is_random;
+
 	if (td->io_ops->flags & FIO_NOIO)
 		goto out;
 
@@ -740,12 +759,12 @@ static int fill_io_u(struct thread_data *td, struct io_u *io_u)
 	 * No log, let the seq/rand engine retrieve the next buflen and
 	 * position.
 	 */
-	if (get_next_offset(td, io_u)) {
+	if (get_next_offset(td, io_u, &is_random)) {
 		dprint(FD_IO, "io_u %p, failed getting offset\n", io_u);
 		return 1;
 	}
 
-	io_u->buflen = get_next_buflen(td, io_u);
+	io_u->buflen = get_next_buflen(td, io_u, is_random);
 	if (!io_u->buflen) {
 		dprint(FD_IO, "io_u %p, failed getting buflen\n", io_u);
 		return 1;
diff --git a/options.c b/options.c
index 1c44f42..1816d0b 100644
--- a/options.c
+++ b/options.c
@@ -377,23 +377,6 @@ static int str_rwmix_write_cb(void *data, unsigned long long *val)
 	return 0;
 }
 
-static int str_perc_rand_cb(void *data, unsigned long long *val)
-{
-	struct thread_data *td = data;
-
-	td->o.perc_rand = *val;
-	return 0;
-}
-
-static int str_perc_seq_cb(void *data, unsigned long long *val)
-{
-	struct thread_data *td = data;
-
-	td->o.perc_rand = 100 - *val;
-	return 0;
-}
-
-
 static int str_exitall_cb(void)
 {
 	exitall_on_terminate = 1;
@@ -1575,6 +1558,17 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_INVALID,
 	},
 	{
+		.name	= "bs_is_seq_rand",
+		.lname	= "Block size division is seq/random (not read/write)",
+		.type	= FIO_OPT_BOOL,
+		.off1	= td_var_offset(bs_is_seq_rand),
+		.help	= "Consider any blocksize setting to be sequential,ramdom",
+		.def	= "0",
+		.parent = "blocksize",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_INVALID,
+	},
+	{
 		.name	= "randrepeat",
 		.lname	= "Random repeatable",
 		.type	= FIO_OPT_BOOL,
@@ -1669,10 +1663,12 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "percentage_random",
 		.lname	= "Percentage Random",
 		.type	= FIO_OPT_INT,
-		.cb	= str_perc_rand_cb,
+		.off1	= td_var_offset(perc_rand[DDIR_READ]),
+		.off2	= td_var_offset(perc_rand[DDIR_WRITE]),
+		.off3	= td_var_offset(perc_rand[DDIR_TRIM]),
 		.maxval	= 100,
 		.help	= "Percentage of seq/random mix that should be random",
-		.def	= "100",
+		.def	= "100,100,100",
 		.interval = 5,
 		.inverse = "percentage_sequential",
 		.category = FIO_OPT_C_IO,
@@ -1681,13 +1677,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	{
 		.name	= "percentage_sequential",
 		.lname	= "Percentage Sequential",
-		.type	= FIO_OPT_INT,
-		.cb	= str_perc_seq_cb,
-		.maxval	= 100,
-		.help	= "Percentage of seq/random mix that should be sequential",
-		.def	= "0",
-		.interval = 5,
-		.inverse = "percentage_random",
+		.type	= FIO_OPT_DEPRECATED,
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_RANDOM,
 	},
diff --git a/parse.c b/parse.c
index d3eb2c4..5e3573e 100644
--- a/parse.c
+++ b/parse.c
@@ -788,6 +788,7 @@ static int __handle_option(struct fio_option *o, const char *ptr, void *data,
 	}
 	case FIO_OPT_DEPRECATED:
 		log_info("Option %s is deprecated\n", o->name);
+		ret = 1;
 		break;
 	default:
 		log_err("Bad option type %u\n", o->type);
diff --git a/profile.h b/profile.h
index 3c8d61f..de35e9b 100644
--- a/profile.h
+++ b/profile.h
@@ -10,8 +10,8 @@ struct prof_io_ops {
 	int (*td_init)(struct thread_data *);
 	void (*td_exit)(struct thread_data *);
 
-	int (*fill_io_u_off)(struct thread_data *, struct io_u *);
-	int (*fill_io_u_size)(struct thread_data *, struct io_u *);
+	int (*fill_io_u_off)(struct thread_data *, struct io_u *, unsigned int *);
+	int (*fill_io_u_size)(struct thread_data *, struct io_u *, unsigned int);
 	struct fio_file *(*get_next_file)(struct thread_data *);
 
 	int (*io_u_lat)(struct thread_data *, uint64_t);
diff --git a/server.h b/server.h
index 46745aa..2f41be0 100644
--- a/server.h
+++ b/server.h
@@ -38,7 +38,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 23,
+	FIO_SERVER_VER			= 24,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 
diff --git a/thread_options.h b/thread_options.h
index 45e22ae..eaafaee 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -105,6 +105,7 @@ struct thread_options {
 	unsigned int softrandommap;
 	unsigned int bs_unaligned;
 	unsigned int fsync_on_close;
+	unsigned int bs_is_seq_rand;
 
 	unsigned int random_distribution;
 
@@ -113,7 +114,7 @@ struct thread_options {
 
 	unsigned int random_generator;
 
-	unsigned int perc_rand;
+	unsigned int perc_rand[DDIR_RWDIR_CNT];
 
 	unsigned int hugepage_size;
 	unsigned int rw_min_bs;
@@ -317,6 +318,7 @@ struct thread_options_pack {
 	uint32_t softrandommap;
 	uint32_t bs_unaligned;
 	uint32_t fsync_on_close;
+	uint32_t bs_is_seq_rand;
 
 	uint32_t random_distribution;
 	fio_fp64_t zipf_theta;
@@ -324,7 +326,7 @@ struct thread_options_pack {
 
 	uint32_t random_generator;
 
-	uint32_t perc_rand;
+	uint32_t perc_rand[DDIR_RWDIR_CNT];
 
 	uint32_t hugepage_size;
 	uint32_t rw_min_bs;
