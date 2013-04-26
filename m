Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:39424 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab3DZOrj (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 26 Apr 2013 10:47:39 -0400
Date: Fri, 26 Apr 2013 08:47:36 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Random IO pattern ratios
Message-ID: <20130426144736.GQ9563@kernel.dk>
References: <CAEzQZ4AEx5ioBUMR2HieVe9eoi2iwu-mFdEPdTkuPci55jBqHQ@mail.gmail.com>
 <20130426034452.GN9563@kernel.dk>
 <CAJBj3vcw+AcrR-ka-tp6+CrR=TVaav9OvRSjbm-rwFeaGHDFng@mail.gmail.com>
 <20130426134216.GO9563@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130426134216.GO9563@kernel.dk>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: John Williams <jwilliams4200@gmail.com>
Cc: Brian Carey <brian@careydrive.com>, fio@vger.kernel.org

On Fri, Apr 26 2013, Jens Axboe wrote:
> On Thu, Apr 25 2013, John Williams wrote:
> > Are there any plans to add %random / %sequential capability to fio?
> > 
> > That is the only feature IOMeter has that I miss in fio.
> 
> Sure, that'd be pretty easy to add. Let me take a look this morning.

Done. Did a few test runs to check it.

percentage_random=50
Random: 16313 (50.036808), Seq: 16289 (49.963192)

percentage_random=10
Random: 3239 (9.942292), Seq: 29339 (90.057708)

percentage_random=72
Random: 23467 (71.993496), Seq: 9129 (28.006504)

percentage_random=100
Random: 32596 (99.990797), Seq: 3 (0.009203)

percentage_random=0
Random: 1 (0.003066), Seq: 32613 (99.996934)

Note that the first IO is always counted as random, which is why the =0
test says only 99.996% sequential. In fact it is fully sequential.


diff --git a/cconv.c b/cconv.c
index 57c76e3..c2b2793 100644
--- a/cconv.c
+++ b/cconv.c
@@ -125,6 +125,8 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->zipf_theta.u.f = fio_uint64_to_double(le64_to_cpu(top->zipf_theta.u.i));
 	o->pareto_h.u.f = fio_uint64_to_double(le64_to_cpu(top->pareto_h.u.i));
 	o->random_generator = le32_to_cpu(top->random_generator);
+	o->perc_rand = le32_to_cpu(top->perc_rand);
+	o->perc_seq = le32_to_cpu(top->perc_seq);
 	o->hugepage_size = le32_to_cpu(top->hugepage_size);
 	o->rw_min_bs = le32_to_cpu(top->rw_min_bs);
 	o->thinktime = le32_to_cpu(top->thinktime);
@@ -283,6 +285,8 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->zipf_theta.u.i = __cpu_to_le64(fio_double_to_uint64(o->zipf_theta.u.f));
 	top->pareto_h.u.i = __cpu_to_le64(fio_double_to_uint64(o->pareto_h.u.f));
 	top->random_generator = cpu_to_le32(o->random_generator);
+	top->perc_rand = cpu_to_le32(o->perc_rand);
+	top->perc_seq = cpu_to_le32(o->perc_seq);
 	top->hugepage_size = cpu_to_le32(o->hugepage_size);
 	top->rw_min_bs = cpu_to_le32(o->rw_min_bs);
 	top->thinktime = cpu_to_le32(o->thinktime);
diff --git a/fio.h b/fio.h
index 5438b76..965d7d9 100644
--- a/fio.h
+++ b/fio.h
@@ -81,6 +81,7 @@ enum {
 	FIO_RAND_FILE_SIZE_OFF,
 	FIO_RAND_TRIM_OFF,
 	FIO_RAND_BUF_OFF,
+	FIO_RAND_SEQ_RAND_OFF,
 	FIO_RAND_NR_OFFS,
 };
 
@@ -256,6 +257,14 @@ struct thread_data {
 	unsigned int ddir_seq_nr;
 
 	/*
+	 * rand/seq mixed workload state
+	 */
+	union {
+		os_random_state_t seq_rand_state;
+		struct frand_state __seq_rand_state;
+	};
+
+	/*
 	 * IO history logs for verification. We use a tree for sorting,
 	 * if we are overwriting. Otherwise just use a fifo.
 	 */
diff --git a/init.c b/init.c
index aba7671..7246bd8 100644
--- a/init.c
+++ b/init.c
@@ -701,6 +701,7 @@ static void td_fill_rand_seeds_os(struct thread_data *td)
 		td->rand_seeds[FIO_RAND_BLOCK_OFF] = FIO_RANDSEED * td->thread_number;
 
 	os_random_seed(td->rand_seeds[FIO_RAND_BLOCK_OFF], &td->random_state);
+	os_random_seed(td->rand_seeds[FIO_RAND_SEQ_RAND_OFF], &td->seq_rand_state);
 }
 
 static void td_fill_rand_seeds_internal(struct thread_data *td)
@@ -722,6 +723,7 @@ static void td_fill_rand_seeds_internal(struct thread_data *td)
 		td->rand_seeds[FIO_RAND_BLOCK_OFF] = FIO_RANDSEED * td->thread_number;
 
 	init_rand_seed(&td->__random_state, td->rand_seeds[FIO_RAND_BLOCK_OFF]);
+	init_rand_seed(&td->__seq_rand_state, td->rand_seeds[FIO_RAND_SEQ_RAND_OFF]);
 }
 
 void td_fill_rand_seeds(struct thread_data *td)
diff --git a/io_u.c b/io_u.c
index 19ef7b9..d03049e 100644
--- a/io_u.c
+++ b/io_u.c
@@ -191,6 +191,25 @@ static inline int should_sort_io(struct thread_data *td)
 	return 1;
 }
 
+static int should_do_random(struct thread_data *td)
+{
+	unsigned int v;
+	unsigned long r;
+
+	if (td->o.perc_rand == 100)
+		return 1;
+
+	if (td->o.use_os_rand) {
+		r = os_random_long(&td->seq_rand_state);
+		v = 1 + (int) (100.0 * (r / (OS_RAND_MAX + 1.0)));
+	} else {
+		r = __rand(&td->__seq_rand_state);
+		v = 1 + (int) (100.0 * (r / (FRAND_MAX + 1.0)));
+	}
+
+	return v <= td->o.perc_rand;
+}
+
 static int get_next_rand_offset(struct thread_data *td, struct fio_file *f,
 				enum fio_ddir ddir, uint64_t *b)
 {
@@ -285,9 +304,16 @@ static int get_next_block(struct thread_data *td, struct io_u *io_u,
 	b = offset = -1ULL;
 
 	if (rw_seq) {
-		if (td_random(td))
-			ret = get_next_rand_block(td, f, ddir, &b);
-		else
+		if (td_random(td)) {
+			if (should_do_random(td))
+				ret = get_next_rand_block(td, f, ddir, &b);
+			else {
+				io_u->flags |= IO_U_F_BUSY_OK;
+				ret = get_next_seq_offset(td, f, ddir, &offset);
+				if (ret)
+					ret = get_next_rand_block(td, f, ddir, &b);
+			}
+		} else
 			ret = get_next_seq_offset(td, f, ddir, &offset);
 	} else {
 		io_u->flags |= IO_U_F_BUSY_OK;
diff --git a/options.c b/options.c
index 1219803..97c5b6f 100644
--- a/options.c
+++ b/options.c
@@ -376,6 +376,25 @@ static int str_rwmix_write_cb(void *data, unsigned long long *val)
 	return 0;
 }
 
+static int str_perc_rand_cb(void *data, unsigned long long *val)
+{
+	struct thread_data *td = data;
+
+	td->o.perc_rand = *val;
+	td->o.perc_seq = 100 - *val;
+	return 0;
+}
+
+static int str_perc_seq_cb(void *data, unsigned long long *val)
+{
+	struct thread_data *td = data;
+
+	td->o.perc_seq = *val;
+	td->o.perc_rand = 100 - *val;
+	return 0;
+}
+
+
 static int str_exitall_cb(void)
 {
 	exitall_on_terminate = 1;
@@ -1643,6 +1662,32 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_RANDOM,
 	},
 	{
+		.name	= "percentage_random",
+		.lname	= "Percentage Random",
+		.type	= FIO_OPT_INT,
+		.cb	= str_perc_rand_cb,
+		.maxval	= 100,
+		.help	= "Percentage of seq/random mix that should be random",
+		.def	= "100",
+		.interval = 5,
+		.inverse = "percentage_sequential",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_RANDOM,
+	},
+	{
+		.name	= "percentage_sequential",
+		.lname	= "Percentage Sequential",
+		.type	= FIO_OPT_INT,
+		.cb	= str_perc_seq_cb,
+		.maxval	= 100,
+		.help	= "Percentage of seq/random mix that should be sequential",
+		.def	= "0",
+		.interval = 5,
+		.inverse = "percentage_random",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_RANDOM,
+	},
+	{
 		.name	= "nrfiles",
 		.lname	= "Number of files",
 		.alias	= "nr_files",
diff --git a/thread_options.h b/thread_options.h
index f25988a..138d026 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -113,6 +113,9 @@ struct thread_options {
 
 	unsigned int random_generator;
 
+	unsigned int perc_rand;
+	unsigned int perc_seq;
+
 	unsigned int hugepage_size;
 	unsigned int rw_min_bs;
 	unsigned int thinktime;
@@ -322,6 +325,9 @@ struct thread_options_pack {
 
 	uint32_t random_generator;
 
+	uint32_t perc_rand;
+	uint32_t perc_seq;
+
 	uint32_t hugepage_size;
 	uint32_t rw_min_bs;
 	uint32_t thinktime;

-- 
Jens Axboe

