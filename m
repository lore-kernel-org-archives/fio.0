Return-Path: <axboe@kernel.dk>
Received: from [192.168.3.11] (66.29.187.50.static.utbb.net. [66.29.187.50])
        by mx.google.com with ESMTPSA id b16sm2754440pdj.76.2015.01.07.15.32.49
        for <fio@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Jan 2015 15:32:49 -0800 (PST)
Message-ID: <54ADC21F.10207@kernel.dk>
Date: Wed, 07 Jan 2015 16:32:47 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Non-uniform randomness with drifting
Content-Type: multipart/mixed;
 boundary="------------090602090607080205050408"
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------090602090607080205050408
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

If you boil it down, fio can basically do two types of random 
distributions (random_distribution=):

- Uniform, meaning we scatter evenly across the IO range.
- Or zipf/pareto, meaning that we have some notion of hotness of
   offsets that are hit more often than others.

zipf/pareto are often used to simulate real world access patterns, 
where, eg, 5% of the dataset is hit 95% of the time, and having a long 
tail of rarely accessed data.

Something that's bothered me for a while is that a zipf/pareto 
distribution remains static over the runtime of the job. Real world 
workloads would often see a shift in what appears hot/cold and what 
isn't. So the attached patch is a first crude attempt at implementing 
that, and I'm posting it here to solicit ideas on how best to express 
such a shift in access patterns. The patch attached defines the 
following options:

random_drift	none, meaning the current behavior (static)
		sudden, meaning a sudden shift in the hot data
		gradual, meaning a gradual shift in the hot data

random_drift_start_percentage	0..100%. For example, if set to 50%, the
		hot/cold distribution would remain static until 50% of
		data has been accessed.

random_drift_percentage		0..100% For example, if set to 10%, the
		hot/cold distribution would shift 10% of the total size
		for every 10% of the workload accessed.

I'm thinking that random_drift_percentage should be split in two, so 
that we could say "shift X percent every time Y percent of the data has 
been accessed". But apart from that, any input on this? I'm open to 
suggestions on how to improve this, I think it's a feature that people 
evaluating caching solutions would be interested in in using.

An example job file would contain:

random_distribution=zipf
random_drift=gradual
random_drift_start_percentage=50
random_drift_percentage=10

-- 
Jens Axboe


--------------090602090607080205050408
Content-Type: text/x-patch;
 name="fio-drift.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="fio-drift.patch"

diff --git a/file.h b/file.h
index f7a1eae14408..93f9ee737bcf 100644
--- a/file.h
+++ b/file.h
@@ -95,6 +95,8 @@ struct fio_file {
 	uint64_t first_write;
 	uint64_t last_write;
 
+	uint64_t io_done;
+
 	/*
 	 * For use by the io engine
 	 */
@@ -120,6 +122,8 @@ struct fio_file {
 	 * Used for zipf random distribution
 	 */
 	struct zipf_state zipf;
+	uint64_t drift_offset;
+	unsigned int last_drift_perc;
 
 	int references;
 	enum fio_file_flags flags;
diff --git a/fio.h b/fio.h
index be2f23aa9f76..b017d2e5926b 100644
--- a/fio.h
+++ b/fio.h
@@ -642,6 +642,12 @@ enum {
 	FIO_RAND_DIST_PARETO,
 };
 
+enum {
+	FIO_RAND_DRIFT_NONE	= 0,
+	FIO_RAND_DRIFT_GRADUAL,
+	FIO_RAND_DRIFT_SUDDEN,
+};
+
 #define FIO_DEF_ZIPF		1.1
 #define FIO_DEF_PARETO		0.2
 
diff --git a/io_u.c b/io_u.c
index 23a9e4ada729..49dfa3792eea 100644
--- a/io_u.c
+++ b/io_u.c
@@ -130,11 +130,50 @@ ret:
 	return 0;
 }
 
+static uint64_t drift_offset(struct thread_data *td, struct fio_file *f)
+{
+	struct thread_options *o = &td->o;
+	unsigned int io_perc;
+
+	if (o->random_drift == FIO_RAND_DRIFT_NONE)
+		return 0;
+
+	if (!f->io_done)
+		return 0;
+
+	io_perc = 100 * f->io_done / f->io_size;
+	if (io_perc < o->drift_start_perc)
+		return 0;
+
+	io_perc -= o->drift_start_perc;
+	if (!io_perc)
+		return 0;
+
+	if (o->random_drift == FIO_RAND_DRIFT_GRADUAL) {
+		if (io_perc == f->last_drift_perc)
+			return 0;
+
+		f->drift_offset = f->io_size * io_perc / 100;
+		f->last_drift_perc = io_perc;
+	} else if (o->random_drift == FIO_RAND_DRIFT_SUDDEN) {
+		unsigned int o_io_perc = io_perc;
+
+		io_perc -= f->last_drift_perc;
+		if (io_perc < o->drift_perc)
+			return 0;
+
+		f->drift_offset += f->io_size * o->drift_perc / 100;
+		f->last_drift_perc = o_io_perc;
+	}
+
+	return f->drift_offset;
+}
+
 static int __get_next_rand_offset_zipf(struct thread_data *td,
 				       struct fio_file *f, enum fio_ddir ddir,
 				       uint64_t *b)
 {
-	*b = zipf_next(&f->zipf);
+	*b = zipf_next(&f->zipf, drift_offset(td, f));
 	return 0;
 }
 
@@ -142,7 +181,7 @@ static int __get_next_rand_offset_pareto(struct thread_data *td,
 					 struct fio_file *f, enum fio_ddir ddir,
 					 uint64_t *b)
 {
-	*b = pareto_next(&f->zipf);
+	*b = pareto_next(&f->zipf, drift_offset(td, f));
 	return 0;
 }
 
@@ -1648,6 +1687,8 @@ static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
 
 		if (!(io_u->flags & IO_U_F_VER_LIST))
 			td->this_io_bytes[ddir] += bytes;
+		if (f)
+			f->io_done += bytes;
 
 		if (ddir == DDIR_WRITE) {
 			if (f) {
diff --git a/lib/zipf.c b/lib/zipf.c
index c691bc51a5a5..1bfbcee2a549 100644
--- a/lib/zipf.c
+++ b/lib/zipf.c
@@ -50,11 +50,12 @@ void zipf_init(struct zipf_state *zs, unsigned long nranges, double theta,
 	zipf_update(zs);
 }
 
-unsigned long long zipf_next(struct zipf_state *zs)
+unsigned long long zipf_next(struct zipf_state *zs, uint64_t offset)
 {
 	double alpha, eta, rand_uni, rand_z;
 	unsigned long long n = zs->nranges;
 	unsigned long long val;
+	uint64_t off = zs->rand_off + offset;
 
 	alpha = 1.0 / (1.0 - zs->theta);
 	eta = (1.0 - pow(2.0 / n, 1.0 - zs->theta)) / (1.0 - zs->zeta2 / zs->zetan);
@@ -69,7 +70,7 @@ unsigned long long zipf_next(struct zipf_state *zs)
 	else
 		val = 1 + (unsigned long long)(n * pow(eta*rand_uni - eta + 1.0, alpha));
 
-	return (__hash_u64(val - 1) + zs->rand_off) % zs->nranges;
+	return (__hash_u64(val - 1) + off) % zs->nranges;
 }
 
 void pareto_init(struct zipf_state *zs, unsigned long nranges, double h,
@@ -79,10 +80,11 @@ void pareto_init(struct zipf_state *zs, unsigned long nranges, double h,
 	zs->pareto_pow = log(h) / log(1.0 - h);
 }
 
-unsigned long long pareto_next(struct zipf_state *zs)
+unsigned long long pareto_next(struct zipf_state *zs, uint64_t offset)
 {
 	double rand = (double) __rand(&zs->rand) / (double) FRAND_MAX;
 	unsigned long long n = zs->nranges - 1;
+	uint64_t off = zs->rand_off + offset;
 
-	return (__hash_u64(n * pow(rand, zs->pareto_pow)) + zs->rand_off) % zs->nranges;
+	return (__hash_u64(n * pow(rand, zs->pareto_pow)) + off) % zs->nranges;
 }
diff --git a/lib/zipf.h b/lib/zipf.h
index f98ad8182883..43edcc5e78d2 100644
--- a/lib/zipf.h
+++ b/lib/zipf.h
@@ -15,9 +15,9 @@ struct zipf_state {
 };
 
 void zipf_init(struct zipf_state *zs, unsigned long nranges, double theta, unsigned int seed);
-unsigned long long zipf_next(struct zipf_state *zs);
+unsigned long long zipf_next(struct zipf_state *zs, uint64_t off);
 
 void pareto_init(struct zipf_state *zs, unsigned long nranges, double h, unsigned int seed);
-unsigned long long pareto_next(struct zipf_state *zs);
+unsigned long long pareto_next(struct zipf_state *zs, uint64_t off);
 
 #endif
diff --git a/options.c b/options.c
index ab6e399db520..d4ebef0a7ee1 100644
--- a/options.c
+++ b/options.c
@@ -1880,6 +1880,51 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_RANDOM,
 	},
 	{
+		.name	= "random_drift",
+		.type	= FIO_OPT_STR,
+		.off1	= td_var_offset(random_drift),
+		.help	= "Random offset drift type",
+		.def	= "none",
+		.posval	= {
+			  { .ival = "none",
+			    .oval = FIO_RAND_DRIFT_NONE,
+			    .help = "No drift",
+			  },
+			  { .ival = "gradual",
+			    .oval = FIO_RAND_DRIFT_GRADUAL,
+			    .help = "Gradual drift",
+			  },
+			  { .ival = "sudden",
+			    .oval = FIO_RAND_DRIFT_SUDDEN,
+			    .help = "Sudden drift",
+			  },
+		},
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_RANDOM,
+	},
+	{
+		.name	= "random_drift_start_percentage",
+		.lname	= "Random drift start percentage",
+		.type	= FIO_OPT_INT,
+		.off1	= td_var_offset(drift_start_perc),
+		.help	= "Percentage of workload done before drifting",
+		.minval	= 0,
+		.maxval	= 100,
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_INVALID,
+	},
+	{
+		.name	= "random_drift_percentage",
+		.lname	= "Random drift percentage",
+		.type	= FIO_OPT_INT,
+		.off1	= td_var_offset(drift_perc),
+		.help	= "Percentage of workload that is drifted",
+		.minval	= 0,
+		.maxval	= 100,
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_INVALID,
+	},
+	{
 		.name	= "percentage_random",
 		.lname	= "Percentage Random",
 		.type	= FIO_OPT_INT,
diff --git a/t/genzipf.c b/t/genzipf.c
index c5f098c4c606..273fc62f5fbc 100644
--- a/t/genzipf.c
+++ b/t/genzipf.c
@@ -209,9 +209,9 @@ int main(int argc, char *argv[])
 		struct node *n;
 
 		if (dist_type == TYPE_ZIPF)
-			offset = zipf_next(&zs);
+			offset = zipf_next(&zs, 0);
 		else
-			offset = pareto_next(&zs);
+			offset = pareto_next(&zs, 0);
 
 		n = hash_lookup(offset);
 		if (n)
diff --git a/thread_options.h b/thread_options.h
index 611f8e7376fa..6f5451428051 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -127,6 +127,10 @@ struct thread_options {
 
 	unsigned int random_distribution;
 
+	unsigned int random_drift;
+	unsigned int drift_start_perc;
+	unsigned int drift_perc;
+
 	fio_fp64_t zipf_theta;
 	fio_fp64_t pareto_h;
 
@@ -353,7 +357,11 @@ struct thread_options_pack {
 	uint32_t bs_is_seq_rand;
 
 	uint32_t random_distribution;
-	uint32_t pad;
+
+	uint32_t random_drift;
+	uint32_t drift_start_perc;
+	uint32_t drift_perc;
+
 	fio_fp64_t zipf_theta;
 	fio_fp64_t pareto_h;
 
@@ -426,7 +434,7 @@ struct thread_options_pack {
 	uint64_t trim_backlog;
 	uint32_t clat_percentiles;
 	uint32_t percentile_precision;
-	uint32_t pad2;
+	uint32_t pad;
 	fio_fp64_t percentile_list[FIO_IO_U_LIST_MAX_LEN];
 
 	uint8_t read_iolog_file[FIO_TOP_STR_MAX];
@@ -482,7 +490,7 @@ struct thread_options_pack {
 
 	uint64_t latency_target;
 	uint64_t latency_window;
-	uint32_t pad3;
+	uint32_t pad2;
 	fio_fp64_t latency_percentile;
 } __attribute__((packed));
 

--------------090602090607080205050408--

