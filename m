Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:46429 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756762Ab3GYSmp (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 25 Jul 2013 14:42:45 -0400
Date: Thu, 25 Jul 2013 12:42:44 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Helping to model this workload
Message-ID: <20130725184244.GI29296@kernel.dk>
References: <20130725182734.GH29296@kernel.dk>
 <CE16E6E8.12D27%Antonio.Jose.Rodrigues.Neto@netapp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CE16E6E8.12D27%Antonio.Jose.Rodrigues.Neto@netapp.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Thu, Jul 25 2013, Neto, Antonio Jose Rodrigues wrote:
> >BTW, if you use filename= twice like you do above, only the last one
> >will be effective.
> 
> And if I do this? file_service_type=random

Doesn't matter. You have to give all files in one filename= statement,
there are not additive.

The below should add bs_is_seq_rand support. If you set that to 1, then:

bs=4k,64k

will not be reads 4k and writes 64k, it will be sequential 4k and random
64k instead. Totally untested...


diff --git a/cconv.c b/cconv.c
index 9de4e25..8e7c69e 100644
--- a/cconv.c
+++ b/cconv.c
@@ -123,6 +123,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->softrandommap = le32_to_cpu(top->softrandommap);
 	o->bs_unaligned = le32_to_cpu(top->bs_unaligned);
 	o->fsync_on_close = le32_to_cpu(top->fsync_on_close);
+	o->bs_is_seq_rand = le32_to_cpu(top->bs_is_seq_rand);
 	o->random_distribution = le32_to_cpu(top->random_distribution);
 	o->zipf_theta.u.f = fio_uint64_to_double(le64_to_cpu(top->zipf_theta.u.i));
 	o->pareto_h.u.f = fio_uint64_to_double(le64_to_cpu(top->pareto_h.u.i));
@@ -281,6 +282,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->softrandommap = cpu_to_le32(o->softrandommap);
 	top->bs_unaligned = cpu_to_le32(o->bs_unaligned);
 	top->fsync_on_close = cpu_to_le32(o->fsync_on_close);
+	top->bs_is_seq_rand = cpu_to_le32(o->bs_is_seq_rand);
 	top->random_distribution = cpu_to_le32(o->random_distribution);
 	top->zipf_theta.u.i = __cpu_to_le64(fio_double_to_uint64(o->zipf_theta.u.f));
 	top->pareto_h.u.i = __cpu_to_le64(fio_double_to_uint64(o->pareto_h.u.f));
diff --git a/io_u.c b/io_u.c
index 8401719..6537c90 100644
--- a/io_u.c
+++ b/io_u.c
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
-			if (should_do_random(td, ddir))
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
index 3da376e..1816d0b 100644
--- a/options.c
+++ b/options.c
@@ -1558,6 +1558,17 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
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
diff --git a/thread_options.h b/thread_options.h
index 32677e2..eaafaee 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -105,6 +105,7 @@ struct thread_options {
 	unsigned int softrandommap;
 	unsigned int bs_unaligned;
 	unsigned int fsync_on_close;
+	unsigned int bs_is_seq_rand;
 
 	unsigned int random_distribution;
 
@@ -317,6 +318,7 @@ struct thread_options_pack {
 	uint32_t softrandommap;
 	uint32_t bs_unaligned;
 	uint32_t fsync_on_close;
+	uint32_t bs_is_seq_rand;
 
 	uint32_t random_distribution;
 	fio_fp64_t zipf_theta;

-- 
Jens Axboe

