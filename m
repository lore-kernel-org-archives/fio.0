Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54022 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbcCHNAD (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 8 Mar 2016 08:00:03 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1adHF5-0007vj-9e
	for fio@vger.kernel.org; Tue, 08 Mar 2016 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160308130001.D39FA2C005F@kernel.dk>
Date: Tue,  8 Mar 2016 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 7c4d0fb7e9e038000978b43b5674f9ad049d36b9:

  Fix double free of td zone state index (2016-03-04 19:50:41 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to de4096e8682a064ed9125af7ac30a3fe4021167b:

  rand: use bools (2016-03-07 15:38:44 -0700)

----------------------------------------------------------------
Andrey Kuzmin (1):
      io_u: speed up __get_next_buflen()

Jens Axboe (5):
      options: unify the bssplit/zone split code
      options: finish merge of bssplit/rand zone code
      options: improvements to parse dry run
      Add the sample JESD219 job file
      rand: use bools

 examples/jesd219.fio |  19 ++++
 io_u.c               |   2 +-
 lib/rand.c           |   4 +-
 lib/rand.h           |   5 +-
 options.c            | 267 ++++++++++++++++++++++++---------------------------
 5 files changed, 152 insertions(+), 145 deletions(-)
 create mode 100644 examples/jesd219.fio

---

Diff of recent changes:

diff --git a/examples/jesd219.fio b/examples/jesd219.fio
new file mode 100644
index 0000000..ab2c40e
--- /dev/null
+++ b/examples/jesd219.fio
@@ -0,0 +1,19 @@
+# Sample implementation of the JESD219 workload for SSD endurance
+# testing. It uses a specific distribution of block sizes and
+# read/write mix, as well as a specific distribution of where on
+# the device the IO accesses will land. Based on posting from
+# Jeff Furlong <jeff.furlong@hgst.com>
+[JESD219]
+ioengine=libaio
+direct=1
+rw=randrw
+norandommap
+randrepeat=0
+rwmixread=40
+rwmixwrite=60
+iodepth=256
+numjobs=4
+bssplit=512/4:1024/1:1536/1:2048/1:2560/1:3072/1:3584/1:4k/67:8k/10:16k/7:32k/3:64k/3
+random_distribution=zoned:50/5:30/15:20/80
+filename=/dev/nvme0n1
+group_reporting=1
diff --git a/io_u.c b/io_u.c
index 0a39886..3299f29 100644
--- a/io_u.c
+++ b/io_u.c
@@ -553,7 +553,7 @@ static unsigned int __get_next_buflen(struct thread_data *td, struct io_u *io_u,
 
 				buflen = bsp->bs;
 				perc += bsp->perc;
-				if ((r <= ((frand_max / 100L) * perc)) &&
+				if ((r * 100UL <= frand_max * perc) &&
 				    io_u_fits(td, io_u, buflen))
 					break;
 			}
diff --git a/lib/rand.c b/lib/rand.c
index 1b661a8..9c3e0d6 100644
--- a/lib/rand.c
+++ b/lib/rand.c
@@ -76,7 +76,7 @@ static void __init_rand64(struct taus258_state *state, uint64_t seed)
 		__rand64(state);
 }
 
-void init_rand(struct frand_state *state, int use64)
+void init_rand(struct frand_state *state, bool use64)
 {
 	state->use64 = use64;
 
@@ -86,7 +86,7 @@ void init_rand(struct frand_state *state, int use64)
 		__init_rand64(&state->state64, 1);
 }
 
-void init_rand_seed(struct frand_state *state, unsigned int seed, int use64)
+void init_rand_seed(struct frand_state *state, unsigned int seed, bool use64)
 {
 	state->use64 = use64;
 
diff --git a/lib/rand.h b/lib/rand.h
index 49773b0..24fac23 100644
--- a/lib/rand.h
+++ b/lib/rand.h
@@ -2,6 +2,7 @@
 #define FIO_RAND_H
 
 #include <inttypes.h>
+#include "types.h"
 #include "../arch/arch.h"
 
 #define FRAND32_MAX	(-1U)
@@ -128,8 +129,8 @@ static inline int rand_between(struct frand_state *state, int start, int end)
 	return start + (int) ((double)end * (r / (rand_max(state) + 1.0)));
 }
 
-extern void init_rand(struct frand_state *, int);
-extern void init_rand_seed(struct frand_state *, unsigned int seed, int);
+extern void init_rand(struct frand_state *, bool);
+extern void init_rand_seed(struct frand_state *, unsigned int seed, bool);
 extern void __fill_random_buf(void *buf, unsigned int len, unsigned long seed);
 extern unsigned long fill_random_buf(struct frand_state *, void *buf, unsigned int len);
 extern void __fill_random_buf_percentage(unsigned long, void *, unsigned int, unsigned int, unsigned int, char *, unsigned int);
diff --git a/options.c b/options.c
index bc2d0ed..7075d84 100644
--- a/options.c
+++ b/options.c
@@ -44,35 +44,28 @@ static int bs_cmp(const void *p1, const void *p2)
 	return (int) bsp1->perc - (int) bsp2->perc;
 }
 
-static int bssplit_ddir(struct thread_options *o, int ddir, char *str)
+struct split {
+	unsigned int nr;
+	unsigned int val1[100];
+	unsigned int val2[100];
+};
+
+static int split_parse_ddir(struct thread_options *o, struct split *split,
+			    enum fio_ddir ddir, char *str)
 {
-	struct bssplit *bssplit;
-	unsigned int i, perc, perc_missing;
-	unsigned int max_bs, min_bs;
+	unsigned int i, perc;
 	long long val;
 	char *fname;
 
-	o->bssplit_nr[ddir] = 4;
-	bssplit = malloc(4 * sizeof(struct bssplit));
+	split->nr = 0;
 
 	i = 0;
-	max_bs = 0;
-	min_bs = -1;
 	while ((fname = strsep(&str, ":")) != NULL) {
 		char *perc_str;
 
 		if (!strlen(fname))
 			break;
 
-		/*
-		 * grow struct buffer, if needed
-		 */
-		if (i == o->bssplit_nr[ddir]) {
-			o->bssplit_nr[ddir] <<= 1;
-			bssplit = realloc(bssplit, o->bssplit_nr[ddir]
-						  * sizeof(struct bssplit));
-		}
-
 		perc_str = strstr(fname, "/");
 		if (perc_str) {
 			*perc_str = '\0';
@@ -87,28 +80,53 @@ static int bssplit_ddir(struct thread_options *o, int ddir, char *str)
 
 		if (str_to_decimal(fname, &val, 1, o, 0, 0)) {
 			log_err("fio: bssplit conversion failed\n");
-			free(bssplit);
 			return 1;
 		}
 
-		if (val > max_bs)
-			max_bs = val;
-		if (val < min_bs)
-			min_bs = val;
-
-		bssplit[i].bs = val;
-		bssplit[i].perc = perc;
+		split->val1[i] = val;
+		split->val2[i] = perc;
 		i++;
+		if (i == 100)
+			break;
 	}
 
-	o->bssplit_nr[ddir] = i;
+	split->nr = i;
+	return 0;
+}
+
+static int bssplit_ddir(struct thread_options *o, enum fio_ddir ddir, char *str)
+{
+	unsigned int i, perc, perc_missing;
+	unsigned int max_bs, min_bs;
+	struct split split;
+
+	memset(&split, 0, sizeof(split));
+
+	if (split_parse_ddir(o, &split, ddir, str))
+		return 1;
+	if (!split.nr)
+		return 0;
+
+	max_bs = 0;
+	min_bs = -1;
+	o->bssplit[ddir] = malloc(split.nr * sizeof(struct bssplit));
+	o->bssplit_nr[ddir] = split.nr;
+	for (i = 0; i < split.nr; i++) {
+		if (split.val1[i] > max_bs)
+			max_bs = split.val1[i];
+		if (split.val1[i] < min_bs)
+			min_bs = split.val1[i];
+
+		o->bssplit[ddir][i].bs = split.val1[i];
+		o->bssplit[ddir][i].perc =split.val2[i];
+	}
 
 	/*
 	 * Now check if the percentages add up, and how much is missing
 	 */
 	perc = perc_missing = 0;
 	for (i = 0; i < o->bssplit_nr[ddir]; i++) {
-		struct bssplit *bsp = &bssplit[i];
+		struct bssplit *bsp = &o->bssplit[ddir][i];
 
 		if (bsp->perc == -1U)
 			perc_missing++;
@@ -118,7 +136,8 @@ static int bssplit_ddir(struct thread_options *o, int ddir, char *str)
 
 	if (perc > 100 && perc_missing > 1) {
 		log_err("fio: bssplit percentages add to more than 100%%\n");
-		free(bssplit);
+		free(o->bssplit[ddir]);
+		o->bssplit[ddir] = NULL;
 		return 1;
 	}
 
@@ -130,7 +149,7 @@ static int bssplit_ddir(struct thread_options *o, int ddir, char *str)
 		if (perc_missing == 1 && o->bssplit_nr[ddir] == 1)
 			perc = 100;
 		for (i = 0; i < o->bssplit_nr[ddir]; i++) {
-			struct bssplit *bsp = &bssplit[i];
+			struct bssplit *bsp = &o->bssplit[ddir][i];
 
 			if (bsp->perc == -1U)
 				bsp->perc = (100 - perc) / perc_missing;
@@ -143,60 +162,78 @@ static int bssplit_ddir(struct thread_options *o, int ddir, char *str)
 	/*
 	 * now sort based on percentages, for ease of lookup
 	 */
-	qsort(bssplit, o->bssplit_nr[ddir], sizeof(struct bssplit), bs_cmp);
-	o->bssplit[ddir] = bssplit;
+	qsort(o->bssplit[ddir], o->bssplit_nr[ddir], sizeof(struct bssplit), bs_cmp);
 	return 0;
 }
 
-static int str_bssplit_cb(void *data, const char *input)
+typedef int (split_parse_fn)(struct thread_options *, enum fio_ddir, char *);
+
+static int str_split_parse(struct thread_data *td, char *str, split_parse_fn *fn)
 {
-	struct thread_data *td = data;
-	char *str, *p, *odir, *ddir;
+	char *odir, *ddir;
 	int ret = 0;
 
-	if (parse_dryrun())
-		return 0;
-
-	p = str = strdup(input);
-
-	strip_blank_front(&str);
-	strip_blank_end(str);
-
 	odir = strchr(str, ',');
 	if (odir) {
 		ddir = strchr(odir + 1, ',');
 		if (ddir) {
-			ret = bssplit_ddir(&td->o, DDIR_TRIM, ddir + 1);
+			ret = fn(&td->o, DDIR_TRIM, ddir + 1);
 			if (!ret)
 				*ddir = '\0';
 		} else {
 			char *op;
 
 			op = strdup(odir + 1);
-			ret = bssplit_ddir(&td->o, DDIR_TRIM, op);
+			ret = fn(&td->o, DDIR_TRIM, op);
 
 			free(op);
 		}
 		if (!ret)
-			ret = bssplit_ddir(&td->o, DDIR_WRITE, odir + 1);
+			ret = fn(&td->o, DDIR_WRITE, odir + 1);
 		if (!ret) {
 			*odir = '\0';
-			ret = bssplit_ddir(&td->o, DDIR_READ, str);
+			ret = fn(&td->o, DDIR_READ, str);
 		}
 	} else {
 		char *op;
 
 		op = strdup(str);
-		ret = bssplit_ddir(&td->o, DDIR_WRITE, op);
+		ret = fn(&td->o, DDIR_WRITE, op);
 		free(op);
 
 		if (!ret) {
 			op = strdup(str);
-			ret = bssplit_ddir(&td->o, DDIR_TRIM, op);
+			ret = fn(&td->o, DDIR_TRIM, op);
 			free(op);
 		}
 		if (!ret)
-			ret = bssplit_ddir(&td->o, DDIR_READ, str);
+			ret = fn(&td->o, DDIR_READ, str);
+	}
+
+	return ret;
+}
+
+static int str_bssplit_cb(void *data, const char *input)
+{
+	struct thread_data *td = data;
+	char *str, *p;
+	int ret = 0;
+
+	p = str = strdup(input);
+
+	strip_blank_front(&str);
+	strip_blank_end(str);
+
+	ret = str_split_parse(td, str, bssplit_ddir);
+
+	if (parse_dryrun()) {
+		int i;
+
+		for (i = 0; i < DDIR_RWDIR_CNT; i++) {
+			free(td->o.bssplit[i]);
+			td->o.bssplit[i] = NULL;
+			td->o.bssplit_nr[i] = 0;
+		}
 	}
 
 	free(p);
@@ -714,64 +751,33 @@ static int zone_cmp(const void *p1, const void *p2)
 	return (int) zsp2->access_perc - (int) zsp1->access_perc;
 }
 
-static int zone_split_ddir(struct thread_options *o, int ddir, char *str)
+static int zone_split_ddir(struct thread_options *o, enum fio_ddir ddir,
+			   char *str)
 {
-	struct zone_split *zsplit;
 	unsigned int i, perc, perc_missing, sperc, sperc_missing;
-	long long val;
-	char *fname;
+	struct split split;
 
-	o->zone_split_nr[ddir] = 4;
-	zsplit = malloc(4 * sizeof(struct zone_split));
-
-	i = 0;
-	while ((fname = strsep(&str, ":")) != NULL) {
-		char *perc_str;
+	memset(&split, 0, sizeof(split));
 
-		if (!strlen(fname))
-			break;
-
-		/*
-		 * grow struct buffer, if needed
-		 */
-		if (i == o->zone_split_nr[ddir]) {
-			o->zone_split_nr[ddir] <<= 1;
-			zsplit = realloc(zsplit, o->zone_split_nr[ddir]
-						  * sizeof(struct zone_split));
-		}
-
-		perc_str = strstr(fname, "/");
-		if (perc_str) {
-			*perc_str = '\0';
-			perc_str++;
-			perc = atoi(perc_str);
-			if (perc > 100)
-				perc = 100;
-			else if (!perc)
-				perc = -1U;
-		} else
-			perc = -1U;
-
-		if (str_to_decimal(fname, &val, 1, o, 0, 0)) {
-			log_err("fio: zone_split conversion failed\n");
-			free(zsplit);
-			return 1;
-		}
+	if (split_parse_ddir(o, &split, ddir, str))
+		return 1;
+	if (!split.nr)
+		return 0;
 
-		zsplit[i].access_perc = val;
-		zsplit[i].size_perc = perc;
-		i++;
+	o->zone_split[ddir] = malloc(split.nr * sizeof(struct zone_split));
+	o->zone_split_nr[ddir] = split.nr;
+	for (i = 0; i < split.nr; i++) {
+		o->zone_split[ddir][i].access_perc = split.val1[i];
+		o->zone_split[ddir][i].size_perc = split.val2[i];
 	}
 
-	o->zone_split_nr[ddir] = i;
-
 	/*
 	 * Now check if the percentages add up, and how much is missing
 	 */
 	perc = perc_missing = 0;
 	sperc = sperc_missing = 0;
 	for (i = 0; i < o->zone_split_nr[ddir]; i++) {
-		struct zone_split *zsp = &zsplit[i];
+		struct zone_split *zsp = &o->zone_split[ddir][i];
 
 		if (zsp->access_perc == (uint8_t) -1U)
 			perc_missing++;
@@ -787,13 +793,15 @@ static int zone_split_ddir(struct thread_options *o, int ddir, char *str)
 
 	if (perc > 100 || sperc > 100) {
 		log_err("fio: zone_split percentages add to more than 100%%\n");
-		free(zsplit);
+		free(o->zone_split[ddir]);
+		o->zone_split[ddir] = NULL;
 		return 1;
 	}
 	if (perc < 100) {
 		log_err("fio: access percentage don't add up to 100 for zoned "
 			"random distribution (got=%u)\n", perc);
-		free(zsplit);
+		free(o->zone_split[ddir]);
+		o->zone_split[ddir] = NULL;
 		return 1;
 	}
 
@@ -805,7 +813,7 @@ static int zone_split_ddir(struct thread_options *o, int ddir, char *str)
 		if (perc_missing == 1 && o->zone_split_nr[ddir] == 1)
 			perc = 100;
 		for (i = 0; i < o->zone_split_nr[ddir]; i++) {
-			struct zone_split *zsp = &zsplit[i];
+			struct zone_split *zsp = &o->zone_split[ddir][i];
 
 			if (zsp->access_perc == (uint8_t) -1U)
 				zsp->access_perc = (100 - perc) / perc_missing;
@@ -815,7 +823,7 @@ static int zone_split_ddir(struct thread_options *o, int ddir, char *str)
 		if (sperc_missing == 1 && o->zone_split_nr[ddir] == 1)
 			sperc = 100;
 		for (i = 0; i < o->zone_split_nr[ddir]; i++) {
-			struct zone_split *zsp = &zsplit[i];
+			struct zone_split *zsp = &o->zone_split[ddir][i];
 
 			if (zsp->size_perc == (uint8_t) -1U)
 				zsp->size_perc = (100 - sperc) / sperc_missing;
@@ -825,8 +833,7 @@ static int zone_split_ddir(struct thread_options *o, int ddir, char *str)
 	/*
 	 * now sort based on percentages, for ease of lookup
 	 */
-	qsort(zsplit, o->zone_split_nr[ddir], sizeof(struct zone_split), zone_cmp);
-	o->zone_split[ddir] = zsplit;
+	qsort(o->zone_split[ddir], o->zone_split_nr[ddir], sizeof(struct zone_split), zone_cmp);
 	return 0;
 }
 
@@ -869,7 +876,7 @@ static void td_zone_gen_index(struct thread_data *td)
 
 static int parse_zoned_distribution(struct thread_data *td, const char *input)
 {
-	char *str, *p, *odir, *ddir;
+	char *str, *p;
 	int i, ret = 0;
 
 	p = str = strdup(input);
@@ -885,42 +892,7 @@ static int parse_zoned_distribution(struct thread_data *td, const char *input)
 	}
 	str += strlen("zoned:");
 
-	odir = strchr(str, ',');
-	if (odir) {
-		ddir = strchr(odir + 1, ',');
-		if (ddir) {
-			ret = zone_split_ddir(&td->o, DDIR_TRIM, ddir + 1);
-			if (!ret)
-				*ddir = '\0';
-		} else {
-			char *op;
-
-			op = strdup(odir + 1);
-			ret = zone_split_ddir(&td->o, DDIR_TRIM, op);
-
-			free(op);
-		}
-		if (!ret)
-			ret = zone_split_ddir(&td->o, DDIR_WRITE, odir + 1);
-		if (!ret) {
-			*odir = '\0';
-			ret = zone_split_ddir(&td->o, DDIR_READ, str);
-		}
-	} else {
-		char *op;
-
-		op = strdup(str);
-		ret = zone_split_ddir(&td->o, DDIR_WRITE, op);
-		free(op);
-
-		if (!ret) {
-			op = strdup(str);
-			ret = zone_split_ddir(&td->o, DDIR_TRIM, op);
-			free(op);
-		}
-		if (!ret)
-			ret = zone_split_ddir(&td->o, DDIR_READ, str);
-	}
+	ret = str_split_parse(td, str, zone_split_ddir);
 
 	free(p);
 
@@ -937,6 +909,18 @@ static int parse_zoned_distribution(struct thread_data *td, const char *input)
 		}
 	}
 
+	if (parse_dryrun()) {
+		int i;
+
+		for (i = 0; i < DDIR_RWDIR_CNT; i++) {
+			free(td->o.zone_split[i]);
+			td->o.zone_split[i] = NULL;
+			td->o.zone_split_nr[i] = 0;
+		}
+
+		return ret;
+	}
+
 	if (!ret)
 		td_zone_gen_index(td);
 	else {
@@ -953,9 +937,6 @@ static int str_random_distribution_cb(void *data, const char *str)
 	double val;
 	char *nr;
 
-	if (parse_dryrun())
-		return 0;
-
 	if (td->o.random_distribution == FIO_RAND_DIST_ZIPF)
 		val = FIO_DEF_ZIPF;
 	else if (td->o.random_distribution == FIO_RAND_DIST_PARETO)
@@ -981,18 +962,24 @@ static int str_random_distribution_cb(void *data, const char *str)
 			log_err("fio: zipf theta must different than 1.0\n");
 			return 1;
 		}
+		if (parse_dryrun())
+			return 0;
 		td->o.zipf_theta.u.f = val;
 	} else if (td->o.random_distribution == FIO_RAND_DIST_PARETO) {
 		if (val <= 0.00 || val >= 1.00) {
 			log_err("fio: pareto input out of range (0 < input < 1.0)\n");
 			return 1;
 		}
+		if (parse_dryrun())
+			return 0;
 		td->o.pareto_h.u.f = val;
 	} else {
 		if (val <= 0.00 || val >= 100.0) {
 			log_err("fio: normal deviation out of range (0 < input < 100.0)\n");
 			return 1;
 		}
+		if (parse_dryrun())
+			return 0;
 		td->o.gauss_dev.u.f = val;
 	}
 
