Return-Path: <axboe@kernel.dk>
Date: Thu, 3 Mar 2016 13:04:46 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Specify range and distribution of accesses
Message-ID: <20160303200446.GA2234@kernel.dk>
References: <BN3PR0401MB145783CB3B39ADEEAED39523F7A70@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <CANvN+e=rTzEnCybj3jFkxt0WCGbSP4R1YbTBKpF+QBv3H2swkA@mail.gmail.com>
 <20160303161828.GC22164@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160303161828.GC22164@kernel.dk>
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: Jeff Furlong <jeff.furlong@hgst.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Thu, Mar 03 2016, Jens Axboe wrote:
> On Sat, Feb 27 2016, Andrey Kuzmin wrote:
> > On Fri, Feb 26, 2016 at 11:53 PM, Jeff Furlong <jeff.furlong@hgst.com> wrote:
> > > Hi All,
> > > I'm looking for a method to distribute access to certain ranges of a block device.  For example, the JESD219 workload (http://www.jedec.org/sites/default/files/docs/JESD219.pdf) specifies
> > >
> > > The workload shall be distributed across the SSD such that the following is achieved:
> > > 1) 50% of accesses to first 5% of user LBA space (LBA group a)
> > > 2) 30% of accesses to next 15% of user LBA space (LBA group b)
> > > 3) 20% of accesses to remainder of user LBA space (LBA group c)
> > >
> > > I do not currently see any fio options to allow such usage.  Perhaps if --size or --iosize is updated to allow ranges/distributions, it may be possible?
> > >
> > > The JESD219 workload also specifies a distribution of block sizes, which can already be accomplished in fio with --bssplit, such as --bssplit=4k/10:64k/50:32k/40.  Perhaps extending that usage to --size or --iosize may solve the issue?
> > >
> > > The above link for the JESD219 workload includes a vdbench script to produce the desired workload, but I'm hesitant to think that vdbench does something that fio cannot.  Has anyone been able to specify ranges and distributions of accesses in any other way?  Thanks.
> > >
> > 
> > To model skewed workloads, fio provides Zipf and Pareto offset
> > distributions, although neither solves exactly your problem. At the
> > same time, a specific feature you're looking for should be pretty
> > straightforward to add. You might want to add a new sub-option under
> > random_distribution to specify frequency/capacity percentage list,
> > similar to the 'bssplit' block size frequency option, and code it
> > following the example of the bssplit, with uniform distribution within
> > the range chosen based on the frequency table yielding the actual
> > offset.
> 
> Those are some good pointers, and that would be a good way to go about
> it.
> 
> For temporary use through zipf/pareto, it's worth noting that fio hashes
> the output so that even with a distribution theta that follows the above
> access frequency, it would not honor the LBA part. That's trivially
> fixable with just providing an option to disable block offset hashing.

Here's a patch that attempts to provide that. Basically it's a new
setting for random_distribution, zoned. With zoned, you can give
percentages like your original example. So to do the zone layout that
you provided:

1) 50% of accesses to first 5% of user LBA space (LBA group a)
2) 30% of accesses to next 15% of user LBA space (LBA group b)
3) 20% of accesses to remainder of user LBA space (LBA group c)

you would do:

random_distribution=zoned:50/5:30/15:20/

and it should work. I hope, it's not really tested... And there's no
documentation yet. But see below patch, would be great if you could give
it a spin.

Note that this does work like bssplit, so you can do different zones for
reads, writes, trims. If you just do one setting, it'll apply across
read/write/trim alike. In this test patch, fio will dump the
distribution when you start it:

xboe@xps13:/home/axboe/git/fio $ ./fio zone-split.fio  
zone ddir 0: 
        0: 50/5
        1: 30/15
        2: 20/80
zone ddir 1: 
        0: 50/5
        1: 30/15
        2: 20/80
zone ddir 2: 
        0: 50/5
        1: 30/15
        2: 20/80
zones: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=sync,
iodepth=1
fio-2.6-20-g2caf
Starting 1 process
[...]

so you can verify that fio gets it right.


diff --git a/fio.h b/fio.h
index b71a48648eaf..18e759c068b0 100644
--- a/fio.h
+++ b/fio.h
@@ -96,6 +96,7 @@ enum {
 	FIO_RAND_START_DELAY,
 	FIO_DEDUPE_OFF,
 	FIO_RAND_POISSON_OFF,
+	FIO_RAND_ZONE_OFF,
 	FIO_RAND_NR_OFFS,
 };
 
@@ -200,6 +201,7 @@ struct thread_data {
 	struct frand_state buf_state;
 	struct frand_state buf_state_prev;
 	struct frand_state dedupe_state;
+	struct frand_state zone_state;
 
 	unsigned int verify_batch;
 	unsigned int trim_batch;
@@ -712,6 +714,7 @@ enum {
 	FIO_RAND_DIST_ZIPF,
 	FIO_RAND_DIST_PARETO,
 	FIO_RAND_DIST_GAUSS,
+	FIO_RAND_DIST_ZONED,
 };
 
 #define FIO_DEF_ZIPF		1.1
diff --git a/init.c b/init.c
index c7ce2cc0df2c..149029a52574 100644
--- a/init.c
+++ b/init.c
@@ -968,6 +968,7 @@ void td_fill_rand_seeds(struct thread_data *td)
 	frand_copy(&td->buf_state_prev, &td->buf_state);
 
 	init_rand_seed(&td->dedupe_state, td->rand_seeds[FIO_DEDUPE_OFF], use64);
+	init_rand_seed(&td->zone_state, td->rand_seeds[FIO_RAND_ZONE_OFF], use64);
 }
 
 /*
diff --git a/io_u.c b/io_u.c
index 8d3491281dde..3dc86873ed07 100644
--- a/io_u.c
+++ b/io_u.c
@@ -86,17 +86,14 @@ struct rand_off {
 };
 
 static int __get_next_rand_offset(struct thread_data *td, struct fio_file *f,
-				  enum fio_ddir ddir, uint64_t *b)
+				  enum fio_ddir ddir, uint64_t *b,
+				  uint64_t lastb)
 {
 	uint64_t r;
 
 	if (td->o.random_generator == FIO_RAND_GEN_TAUSWORTHE ||
 	    td->o.random_generator == FIO_RAND_GEN_TAUSWORTHE64) {
-		uint64_t frand_max, lastb;
-
-		lastb = last_block(td, f, ddir);
-		if (!lastb)
-			return 1;
+		uint64_t frand_max;
 
 		frand_max = rand_max(&td->random_state);
 		r = __rand(&td->random_state);
@@ -161,6 +158,55 @@ static int __get_next_rand_offset_gauss(struct thread_data *td,
 	return 0;
 }
 
+static int __get_next_rand_offset_zoned(struct thread_data *td,
+					struct fio_file *f, enum fio_ddir ddir,
+					uint64_t *b)
+{
+	unsigned int i, v, send, atotal, stotal;
+	uint64_t offset, frand_max, lastb;
+	unsigned long r;
+
+	lastb = last_block(td, f, ddir);
+	if (!lastb)
+		return 1;
+
+	if (!td->o.zone_split_nr[ddir]) {
+bail:
+		return __get_next_rand_offset(td, f, ddir, b, lastb);
+	}
+
+	frand_max = rand_max(&td->zone_state);
+	r = __rand(&td->zone_state);
+	v = 1 + (int) (100.0 * (r / (frand_max + 1.0)));
+
+	send = -1U;
+	atotal = stotal = 0;
+	for (i = 0; i < td->o.zone_split_nr[ddir]; i++) {
+		struct zone_split *zsp = &td->o.zone_split[ddir][i];
+
+		if (v <= atotal + zsp->access_perc) {
+			send = stotal + zsp->size_perc;
+			break;
+		}
+
+		atotal += zsp->access_perc;
+		stotal += zsp->size_perc;
+	}
+
+	if (send == -1U) {
+		log_err("fio: bug in zoned generation\n");
+		goto bail;
+	}
+
+	offset = stotal * lastb / 100ULL;
+	lastb = lastb * (send - stotal) / 100ULL;
+
+	if (__get_next_rand_offset(td, f, ddir, b, lastb) == 1)
+		return 1;
+
+	*b += offset;
+	return 0;
+}
 
 static int flist_cmp(void *data, struct flist_head *a, struct flist_head *b)
 {
@@ -173,14 +219,22 @@ static int flist_cmp(void *data, struct flist_head *a, struct flist_head *b)
 static int get_off_from_method(struct thread_data *td, struct fio_file *f,
 			       enum fio_ddir ddir, uint64_t *b)
 {
-	if (td->o.random_distribution == FIO_RAND_DIST_RANDOM)
-		return __get_next_rand_offset(td, f, ddir, b);
-	else if (td->o.random_distribution == FIO_RAND_DIST_ZIPF)
+	if (td->o.random_distribution == FIO_RAND_DIST_RANDOM) {
+		uint64_t lastb;
+
+		lastb = last_block(td, f, ddir);
+		if (!lastb)
+			return 1;
+
+		return __get_next_rand_offset(td, f, ddir, b, lastb);
+	} else if (td->o.random_distribution == FIO_RAND_DIST_ZIPF)
 		return __get_next_rand_offset_zipf(td, f, ddir, b);
 	else if (td->o.random_distribution == FIO_RAND_DIST_PARETO)
 		return __get_next_rand_offset_pareto(td, f, ddir, b);
 	else if (td->o.random_distribution == FIO_RAND_DIST_GAUSS)
 		return __get_next_rand_offset_gauss(td, f, ddir, b);
+	else if (td->o.random_distribution == FIO_RAND_DIST_ZONED)
+		return __get_next_rand_offset_zoned(td, f, ddir, b);
 
 	log_err("fio: unknown random distribution: %d\n", td->o.random_distribution);
 	return 1;
diff --git a/options.c b/options.c
index ac2da71f514e..88f794ce8705 100644
--- a/options.c
+++ b/options.c
@@ -706,6 +706,193 @@ static int str_sfr_cb(void *data, const char *str)
 }
 #endif
 
+static int zone_cmp(const void *p1, const void *p2)
+{
+	const struct zone_split *zsp1 = p1;
+	const struct zone_split *zsp2 = p2;
+
+	return (int) zsp2->access_perc - (int) zsp1->access_perc;
+}
+
+static int zone_split_ddir(struct thread_options *o, int ddir, char *str)
+{
+	struct zone_split *zsplit;
+	unsigned int i, perc, perc_missing, sperc, sperc_missing;
+	long long val;
+	char *fname;
+
+	o->zone_split_nr[ddir] = 4;
+	zsplit = malloc(4 * sizeof(struct zone_split));
+
+	i = 0;
+	while ((fname = strsep(&str, ":")) != NULL) {
+		char *perc_str;
+
+		if (!strlen(fname))
+			break;
+
+		/*
+		 * grow struct buffer, if needed
+		 */
+		if (i == o->zone_split_nr[ddir]) {
+			o->zone_split_nr[ddir] <<= 1;
+			zsplit = realloc(zsplit, o->zone_split_nr[ddir]
+						  * sizeof(struct zone_split));
+		}
+
+		perc_str = strstr(fname, "/");
+		if (perc_str) {
+			*perc_str = '\0';
+			perc_str++;
+			perc = atoi(perc_str);
+			if (perc > 100)
+				perc = 100;
+			else if (!perc)
+				perc = -1U;
+		} else
+			perc = -1U;
+
+		if (str_to_decimal(fname, &val, 1, o, 0, 0)) {
+			log_err("fio: zone_split conversion failed\n");
+			free(zsplit);
+			return 1;
+		}
+
+		zsplit[i].access_perc = val;
+		zsplit[i].size_perc = perc;
+		i++;
+	}
+
+	o->zone_split_nr[ddir] = i;
+
+	/*
+	 * Now check if the percentages add up, and how much is missing
+	 */
+	perc = perc_missing = 0;
+	sperc = sperc_missing = 0;
+	for (i = 0; i < o->zone_split_nr[ddir]; i++) {
+		struct zone_split *zsp = &zsplit[i];
+
+		if (zsp->access_perc == (uint8_t) -1U)
+			perc_missing++;
+		else
+			perc += zsp->access_perc;
+
+		if (zsp->size_perc == (uint8_t) -1U)
+			sperc_missing++;
+		else
+			sperc += zsp->size_perc;
+
+	}
+
+	if (perc > 100 || sperc > 100) {
+		log_err("fio: zone_split percentages add to more than 100%%\n");
+		free(zsplit);
+		return 1;
+	}
+
+	/*
+	 * If values didn't have a percentage set, divide the remains between
+	 * them.
+	 */
+	if (perc_missing) {
+		if (perc_missing == 1 && o->zone_split_nr[ddir] == 1)
+			perc = 100;
+		for (i = 0; i < o->zone_split_nr[ddir]; i++) {
+			struct zone_split *zsp = &zsplit[i];
+
+			if (zsp->access_perc == (uint8_t) -1U)
+				zsp->access_perc = (100 - perc) / perc_missing;
+		}
+	}
+	if (sperc_missing) {
+		if (sperc_missing == 1 && o->zone_split_nr[ddir] == 1)
+			sperc = 100;
+		for (i = 0; i < o->zone_split_nr[ddir]; i++) {
+			struct zone_split *zsp = &zsplit[i];
+
+			if (zsp->size_perc == (uint8_t) -1U)
+				zsp->size_perc = (100 - sperc) / sperc_missing;
+		}
+	}
+
+	/*
+	 * now sort based on percentages, for ease of lookup
+	 */
+	qsort(zsplit, o->zone_split_nr[ddir], sizeof(struct zone_split), zone_cmp);
+	o->zone_split[ddir] = zsplit;
+	return 0;
+}
+
+static int parse_zoned_distribution(struct thread_data *td, const char *input)
+{
+	char *str, *p, *odir, *ddir;
+	int i, ret = 0;
+
+	p = str = strdup(input);
+
+	strip_blank_front(&str);
+	strip_blank_end(str);
+
+	/* We expect it to start like that, bail if not */
+	if (strncmp(str, "zoned:", 6)) {
+		log_err("fio: mismatch in zoned input <%s>\n", str);
+		free(p);
+		return 1;
+	}
+	str += strlen("zoned:");
+
+	odir = strchr(str, ',');
+	if (odir) {
+		ddir = strchr(odir + 1, ',');
+		if (ddir) {
+			ret = zone_split_ddir(&td->o, DDIR_TRIM, ddir + 1);
+			if (!ret)
+				*ddir = '\0';
+		} else {
+			char *op;
+
+			op = strdup(odir + 1);
+			ret = zone_split_ddir(&td->o, DDIR_TRIM, op);
+
+			free(op);
+		}
+		if (!ret)
+			ret = zone_split_ddir(&td->o, DDIR_WRITE, odir + 1);
+		if (!ret) {
+			*odir = '\0';
+			ret = zone_split_ddir(&td->o, DDIR_READ, str);
+		}
+	} else {
+		char *op;
+
+		op = strdup(str);
+		ret = zone_split_ddir(&td->o, DDIR_WRITE, op);
+		free(op);
+
+		if (!ret) {
+			op = strdup(str);
+			ret = zone_split_ddir(&td->o, DDIR_TRIM, op);
+			free(op);
+		}
+		if (!ret)
+			ret = zone_split_ddir(&td->o, DDIR_READ, str);
+	}
+
+	free(p);
+
+	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
+		int j;
+
+		printf("zone ddir %d: \n", i);
+		for (j = 0; j < td->o.zone_split_nr[i]; j++) {
+			struct zone_split *zsp = &td->o.zone_split[i][j];
+			printf("\t%d: %u/%u\n", j, zsp->access_perc, zsp->size_perc);
+		}
+	}
+	return ret;
+}
+
 static int str_random_distribution_cb(void *data, const char *str)
 {
 	struct thread_data *td = data;
@@ -721,6 +908,8 @@ static int str_random_distribution_cb(void *data, const char *str)
 		val = FIO_DEF_PARETO;
 	else if (td->o.random_distribution == FIO_RAND_DIST_GAUSS)
 		val = 0.0;
+	else if (td->o.random_distribution == FIO_RAND_DIST_ZONED)
+		return parse_zoned_distribution(td, str);
 	else
 		return 0;
 
@@ -1709,6 +1898,11 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .oval = FIO_RAND_DIST_GAUSS,
 			    .help = "Normal (gaussian) distribution",
 			  },
+			  { .ival = "zoned",
+			    .oval = FIO_RAND_DIST_ZONED,
+			    .help = "Zoned random distribution",
+			  },
+
 		},
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_RANDOM,
diff --git a/thread_options.h b/thread_options.h
index 384534add737..10d7ba61334a 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -25,12 +25,18 @@ enum fio_memtype {
 #define ERROR_STR_MAX	128
 
 #define BSSPLIT_MAX	64
+#define ZONESPLIT_MAX	64
 
 struct bssplit {
 	uint32_t bs;
 	uint32_t perc;
 };
 
+struct zone_split {
+	uint8_t access_perc;
+	uint8_t size_perc;
+};
+
 #define NR_OPTS_SZ	(FIO_MAX_OPTS / (8 * sizeof(uint64_t)))
 
 #define OPT_MAGIC	0x4f50544e
@@ -135,6 +141,9 @@ struct thread_options {
 	unsigned int random_distribution;
 	unsigned int exitall_error;
 
+	struct zone_split *zone_split[DDIR_RWDIR_CNT];
+	unsigned int zone_split_nr[DDIR_RWDIR_CNT];
+
 	fio_fp64_t zipf_theta;
 	fio_fp64_t pareto_h;
 	fio_fp64_t gauss_dev;
@@ -382,7 +391,9 @@ struct thread_options_pack {
 
 	uint32_t random_distribution;
 	uint32_t exitall_error;
-	uint32_t pad0;
+
+	struct zone_split zone_split[DDIR_RWDIR_CNT][ZONESPLIT_MAX];
+	uint32_t zone_split_nr[DDIR_RWDIR_CNT];
 
 	fio_fp64_t zipf_theta;
 	fio_fp64_t pareto_h;

-- 
Jens Axboe


