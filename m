Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57098 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbbDIMAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 9 Apr 2015 08:00:05 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YgB7t-0005zP-BG
	for fio@vger.kernel.org; Thu, 09 Apr 2015 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150409120003.4F31A40156@lyth.info>
Date: Thu,  9 Apr 2015 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 16ada7542f32b38c1189390a97b595948079b100:

  sg: don't return success if non bdev/char is used (2015-03-31 13:41:18 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 87f5fce38c1b8fc979cea10c926973c2f2a76217:

  genzip: switch to jenkins hash (2015-04-08 16:25:49 -0600)

----------------------------------------------------------------
Fabrice Bacchella (1):
      fio-genzipf results output are slightly wrong, it doesn't help to understand how to use it:      * The last row was not displayed      * some useless variables were used      * the calculation for the output table missed a few events, so the sum of 'No Hits' column was wrong      * Wrong sample in genzipf.c header, used old style arguments      * the help message for -o options was misleading.      * useless define of DEF_NR.      * default of default row number to a more common value of 20,        instead of 23.

Jens Axboe (8):
      Add support for normal/gaussian random distributions
      Merge branch 'master' of ssh://git.kernel.dk/data/git/fio
      Make normal distribution takes deviations as a percentage
      genzipf: add support for normal distribution
      genzip: add summed hit percentages
      genzip: cleanups
      Unify gauss and zipf/pareto input values
      genzip: switch to jenkins hash

 Makefile         |    4 +-
 cconv.c          |    2 +
 file.h           |    6 +-
 filesetup.c      |    4 +-
 fio.h            |    1 +
 io_u.c           |   11 +++
 lib/gauss.c      |   56 ++++++++++++
 lib/gauss.h      |   17 ++++
 options.c        |   14 ++-
 t/genzipf.c      |  251 ++++++++++++++++++++++++++++++------------------------
 thread_options.h |    3 +
 11 files changed, 252 insertions(+), 117 deletions(-)
 create mode 100644 lib/gauss.c
 create mode 100644 lib/gauss.h

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 52e515b..50f7468 100644
--- a/Makefile
+++ b/Makefile
@@ -36,7 +36,7 @@ SOURCE := gettime.c ioengines.c init.c stat.c log.c time.c filesetup.c \
 		lib/lfsr.c gettime-thread.c helpers.c lib/flist_sort.c \
 		lib/hweight.c lib/getrusage.c idletime.c td_error.c \
 		profiles/tiobench.c profiles/act.c io_u_queue.c filelock.c \
-		lib/tp.c lib/bloom.c
+		lib/tp.c lib/bloom.c lib/gauss.c
 
 ifdef CONFIG_LIBHDFS
   HDFSFLAGS= -I $(JAVA_HOME)/include -I $(JAVA_HOME)/include/linux -I $(FIO_LIBHDFS_INCLUDE)
@@ -182,7 +182,7 @@ T_IEEE_OBJS += lib/ieee754.o
 T_IEEE_PROGS = t/ieee754
 
 T_ZIPF_OBS = t/genzipf.o
-T_ZIPF_OBJS += t/log.o lib/ieee754.o lib/rand.o lib/zipf.o t/genzipf.o
+T_ZIPF_OBJS += t/log.o lib/ieee754.o lib/rand.o lib/zipf.o lib/gauss.o t/genzipf.o
 T_ZIPF_PROGS = t/fio-genzipf
 
 T_AXMAP_OBJS = t/axmap.o
diff --git a/cconv.c b/cconv.c
index 0fca764..68f119f 100644
--- a/cconv.c
+++ b/cconv.c
@@ -165,6 +165,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->random_distribution = le32_to_cpu(top->random_distribution);
 	o->zipf_theta.u.f = fio_uint64_to_double(le64_to_cpu(top->zipf_theta.u.i));
 	o->pareto_h.u.f = fio_uint64_to_double(le64_to_cpu(top->pareto_h.u.i));
+	o->gauss_dev.u.f = fio_uint64_to_double(le64_to_cpu(top->gauss_dev.u.i));
 	o->random_generator = le32_to_cpu(top->random_generator);
 	o->hugepage_size = le32_to_cpu(top->hugepage_size);
 	o->rw_min_bs = le32_to_cpu(top->rw_min_bs);
@@ -339,6 +340,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->random_distribution = cpu_to_le32(o->random_distribution);
 	top->zipf_theta.u.i = __cpu_to_le64(fio_double_to_uint64(o->zipf_theta.u.f));
 	top->pareto_h.u.i = __cpu_to_le64(fio_double_to_uint64(o->pareto_h.u.f));
+	top->gauss_dev.u.i = __cpu_to_le64(fio_double_to_uint64(o->gauss_dev.u.f));
 	top->random_generator = cpu_to_le32(o->random_generator);
 	top->hugepage_size = cpu_to_le32(o->hugepage_size);
 	top->rw_min_bs = cpu_to_le32(o->rw_min_bs);
diff --git a/file.h b/file.h
index fc47310..22ec742 100644
--- a/file.h
+++ b/file.h
@@ -8,6 +8,7 @@
 #include "lib/zipf.h"
 #include "lib/axmap.h"
 #include "lib/lfsr.h"
+#include "lib/gauss.h"
 
 /*
  * The type of object we are working on
@@ -119,7 +120,10 @@ struct fio_file {
 	/*
 	 * Used for zipf random distribution
 	 */
-	struct zipf_state zipf;
+	union {
+		struct zipf_state zipf;
+		struct gauss_state gauss;
+	};
 
 	int references;
 	enum fio_file_flags flags;
diff --git a/filesetup.c b/filesetup.c
index 0fb5589..09e877f 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -998,8 +998,10 @@ static int __init_rand_distribution(struct thread_data *td, struct fio_file *f)
 
 	if (td->o.random_distribution == FIO_RAND_DIST_ZIPF)
 		zipf_init(&f->zipf, nranges, td->o.zipf_theta.u.f, seed);
-	else
+	else if (td->o.random_distribution == FIO_RAND_DIST_PARETO)
 		pareto_init(&f->zipf, nranges, td->o.pareto_h.u.f, seed);
+	else if (td->o.random_distribution == FIO_RAND_DIST_GAUSS)
+		gauss_init(&f->gauss, nranges, td->o.gauss_dev.u.f, seed);
 
 	return 1;
 }
diff --git a/fio.h b/fio.h
index f688084..0fb86ea 100644
--- a/fio.h
+++ b/fio.h
@@ -649,6 +649,7 @@ enum {
 	FIO_RAND_DIST_RANDOM	= 0,
 	FIO_RAND_DIST_ZIPF,
 	FIO_RAND_DIST_PARETO,
+	FIO_RAND_DIST_GAUSS,
 };
 
 #define FIO_DEF_ZIPF		1.1
diff --git a/io_u.c b/io_u.c
index 975d242..1606512 100644
--- a/io_u.c
+++ b/io_u.c
@@ -149,6 +149,15 @@ static int __get_next_rand_offset_pareto(struct thread_data *td,
 	return 0;
 }
 
+static int __get_next_rand_offset_gauss(struct thread_data *td,
+					struct fio_file *f, enum fio_ddir ddir,
+					uint64_t *b)
+{
+	*b = gauss_next(&f->gauss);
+	return 0;
+}
+
+
 static int flist_cmp(void *data, struct flist_head *a, struct flist_head *b)
 {
 	struct rand_off *r1 = flist_entry(a, struct rand_off, list);
@@ -166,6 +175,8 @@ static int get_off_from_method(struct thread_data *td, struct fio_file *f,
 		return __get_next_rand_offset_zipf(td, f, ddir, b);
 	else if (td->o.random_distribution == FIO_RAND_DIST_PARETO)
 		return __get_next_rand_offset_pareto(td, f, ddir, b);
+	else if (td->o.random_distribution == FIO_RAND_DIST_GAUSS)
+		return __get_next_rand_offset_gauss(td, f, ddir, b);
 
 	log_err("fio: unknown random distribution: %d\n", td->o.random_distribution);
 	return 1;
diff --git a/lib/gauss.c b/lib/gauss.c
new file mode 100644
index 0000000..1bb6c41
--- /dev/null
+++ b/lib/gauss.c
@@ -0,0 +1,56 @@
+#include <math.h>
+#include <string.h>
+#include <stdio.h>
+#include "../hash.h"
+#include "gauss.h"
+
+#define GAUSS_ITERS	12
+
+static int gauss_dev(struct gauss_state *gs)
+{
+	unsigned int r;
+	int vr;
+
+	if (!gs->stddev)
+		return 0;
+
+	r = __rand(&gs->r);
+	vr = gs->stddev * (r / (FRAND_MAX + 1.0));
+
+	return vr - gs->stddev / 2;
+}
+
+unsigned long long gauss_next(struct gauss_state *gs)
+{
+	unsigned long long sum = 0;
+	int i;
+
+	for (i = 0; i < GAUSS_ITERS; i++)
+		sum += __rand(&gs->r) % (gs->nranges + 1);
+
+	sum = (sum + GAUSS_ITERS - 1) / GAUSS_ITERS;
+
+	if (gs->stddev) {
+		int dev = gauss_dev(gs);
+
+		while (dev + sum >= gs->nranges)
+			dev /= 2;
+		sum += dev;
+	}
+
+	return __hash_u64(sum) % gs->nranges;
+}
+
+void gauss_init(struct gauss_state *gs, unsigned long nranges, double dev,
+		unsigned int seed)
+{
+	memset(gs, 0, sizeof(*gs));
+	init_rand_seed(&gs->r, seed);
+	gs->nranges = nranges;
+
+	if (dev != 0.0) {
+		gs->stddev = ceil((double) (nranges * 100.0) / dev);
+		if (gs->stddev > nranges / 2)
+			gs->stddev = nranges / 2;
+	}
+}
diff --git a/lib/gauss.h b/lib/gauss.h
new file mode 100644
index 0000000..a76df3f
--- /dev/null
+++ b/lib/gauss.h
@@ -0,0 +1,17 @@
+#ifndef FIO_GAUSS_H
+#define FIO_GAUSS_H
+
+#include <inttypes.h>
+#include "rand.h"
+
+struct gauss_state {
+	struct frand_state r;
+	uint64_t nranges;
+	unsigned int stddev;
+};
+
+void gauss_init(struct gauss_state *gs, unsigned long nranges, double dev,
+		unsigned int seed);
+unsigned long long gauss_next(struct gauss_state *gs);
+
+#endif
diff --git a/options.c b/options.c
index 337fecd..95e0e0c 100644
--- a/options.c
+++ b/options.c
@@ -718,6 +718,8 @@ static int str_random_distribution_cb(void *data, const char *str)
 		val = FIO_DEF_ZIPF;
 	else if (td->o.random_distribution == FIO_RAND_DIST_PARETO)
 		val = FIO_DEF_PARETO;
+	else if (td->o.random_distribution == FIO_RAND_DIST_GAUSS)
+		val = 0.0;
 	else
 		return 0;
 
@@ -736,12 +738,18 @@ static int str_random_distribution_cb(void *data, const char *str)
 			return 1;
 		}
 		td->o.zipf_theta.u.f = val;
-	} else {
+	} else if (td->o.random_distribution == FIO_RAND_DIST_PARETO) {
 		if (val <= 0.00 || val >= 1.00) {
 			log_err("fio: pareto input out of range (0 < input < 1.0)\n");
 			return 1;
 		}
 		td->o.pareto_h.u.f = val;
+	} else {
+		if (val <= 0.00 || val >= 100.0) {
+			log_err("fio: normal deviation out of range (0 < input < 100.0)\n");
+			return 1;
+		}
+		td->o.gauss_dev.u.f = val;
 	}
 
 	return 0;
@@ -1875,6 +1883,10 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .oval = FIO_RAND_DIST_PARETO,
 			    .help = "Pareto distribution",
 			  },
+			  { .ival = "normal",
+			    .oval = FIO_RAND_DIST_GAUSS,
+			    .help = "Normal (gaussian) distribution",
+			  },
 		},
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_RANDOM,
diff --git a/t/genzipf.c b/t/genzipf.c
index c5f098c..ff0729e 100644
--- a/t/genzipf.c
+++ b/t/genzipf.c
@@ -3,10 +3,10 @@
  * what an access pattern would look like.
  *
  * For instance, the following would generate a zipf distribution
- * with theta 1.2, using 100,000 values and split the reporting into
+ * with theta 1.2, using 262144 (1 GB / 4096) values and split the reporting into
  * 20 buckets:
  *
- *	t/genzipf zipf 1.2 100000 20
+ *	./t/fio-genzipf -t zipf -i 1.2 -g 1 -b 4096 -o 20
  *
  * Only the distribution type (zipf or pareto) and spread input need
  * to be given, if not given defaults are used.
@@ -19,11 +19,11 @@
 #include <unistd.h>
 
 #include "../lib/zipf.h"
+#include "../lib/gauss.h"
 #include "../flist.h"
 #include "../hash.h"
 
-#define DEF_NR		1000000
-#define DEF_NR_OUTPUT	23
+#define DEF_NR_OUTPUT	20
 
 struct node {
 	struct flist_head list;
@@ -39,8 +39,14 @@ enum {
 	TYPE_NONE = 0,
 	TYPE_ZIPF,
 	TYPE_PARETO,
+	TYPE_NORMAL,
+};
+static const char *dist_types[] = { "None", "Zipf", "Pareto", "Normal" };
+
+enum {
+	OUTPUT_NORMAL,
+	OUTPUT_CSV,
 };
-static const char *dist_types[] = { "None", "Zipf", "Pareto" };
 
 static int dist_type = TYPE_ZIPF;
 static unsigned long gb_size = 500;
@@ -48,14 +54,19 @@ static unsigned long block_size = 4096;
 static unsigned long output_nranges = DEF_NR_OUTPUT;
 static double percentage;
 static double dist_val;
-static int output_csv = 0;
+static int output_type = OUTPUT_NORMAL;
 
 #define DEF_ZIPF_VAL	1.2
 #define DEF_PARETO_VAL	0.3
 
+static unsigned int hashv(unsigned long long val)
+{
+	return jhash(&val, sizeof(val), 0) & (hash_size - 1);
+}
+
 static struct node *hash_lookup(unsigned long long val)
 {
-	struct flist_head *l = &hash[hash_long(val, hash_bits)];
+	struct flist_head *l = &hash[hashv(val)];
 	struct flist_head *entry;
 	struct node *n;
 
@@ -68,14 +79,13 @@ static struct node *hash_lookup(unsigned long long val)
 	return NULL;
 }
 
-static struct node *hash_insert(struct node *n, unsigned long long val)
+static void hash_insert(struct node *n, unsigned long long val)
 {
-	struct flist_head *l = &hash[hash_long(val, hash_bits)];
+	struct flist_head *l = &hash[hashv(val)];
 
 	n->val = val;
 	n->hits = 1;
 	flist_add_tail(&n->list, l);
-	return n;
 }
 
 static void usage(void)
@@ -83,11 +93,12 @@ static void usage(void)
 	printf("genzipf: test zipf/pareto values for fio input\n");
 	printf("\t-h\tThis help screen\n");
 	printf("\t-p\tGenerate size of data set that are hit by this percentage\n");
-	printf("\t-t\tDistribution type (zipf or pareto)\n");
-	printf("\t-i\tDistribution algorithm input (zipf theta or pareto power)\n");
+	printf("\t-t\tDistribution type (zipf, pareto, or normal)\n");
+	printf("\t-i\tDistribution algorithm input (zipf theta, pareto power,\n"
+		"\t\tor normal %% deviation)\n");
 	printf("\t-b\tBlock size of a given range (in bytes)\n");
 	printf("\t-g\tSize of data set (in gigabytes)\n");
-	printf("\t-o\tNumber of output columns\n");
+	printf("\t-o\tNumber of output rows\n");
 	printf("\t-c\tOutput ranges in CSV format\n");
 }
 
@@ -112,6 +123,8 @@ static int parse_options(int argc, char *argv[])
 				dist_type = TYPE_ZIPF;
 			else if (!strncmp(optarg, "pareto", 6))
 				dist_type = TYPE_PARETO;
+			else if (!strncmp(optarg, "normal", 6))
+				dist_type = TYPE_NORMAL;
 			else {
 				printf("wrong dist type: %s\n", optarg);
 				return 1;
@@ -128,7 +141,7 @@ static int parse_options(int argc, char *argv[])
 			output_nranges = strtoul(optarg, NULL, 10);
 			break;
 		case 'c':
-			output_csv = 1;
+			output_type = OUTPUT_CSV;
 			break;
 		default:
 			printf("bad option %c\n", c);
@@ -168,20 +181,116 @@ static int node_cmp(const void *p1, const void *p2)
 	return n2->hits - n1->hits;
 }
 
+static void output_csv(struct node *nodes, unsigned long nnodes)
+{
+	unsigned long i;
+
+	printf("rank, count\n");
+	for (i = 0; i < nnodes; i++)
+		printf("%lu, %lu\n", i, nodes[i].hits);
+}
+
+static void output_normal(struct node *nodes, unsigned long nnodes,
+			  unsigned long nranges)
+{
+	unsigned long i, j, cur_vals, interval_step, next_interval, total_vals;
+	unsigned long blocks = percentage * nnodes / 100;
+	double hit_percent_sum = 0;
+	unsigned long long hit_sum = 0;
+	double perc, perc_i;
+	struct output_sum *output_sums;
+
+	interval_step = (nnodes - 1) / output_nranges + 1;
+	next_interval = interval_step;
+	output_sums = malloc(output_nranges * sizeof(struct output_sum));
+
+	for (i = 0; i < output_nranges; i++) {
+		output_sums[i].output = 0.0;
+		output_sums[i].nranges = 0;
+	}
+
+	j = total_vals = cur_vals = 0;
+
+	for (i = 0; i < nnodes; i++) {
+		struct output_sum *os = &output_sums[j];
+		struct node *node = &nodes[i];
+		cur_vals += node->hits;
+		total_vals += node->hits;
+		os->nranges += node->hits;
+		if (i == (next_interval) -1 || i == nnodes - 1) {
+			os->output = (double) cur_vals / (double) nranges;
+			os->output *= 100.0;
+			cur_vals = 0;
+			next_interval += interval_step;
+			j++;
+		}
+
+		if (percentage) {
+			if (total_vals >= blocks) {
+				double cs = i * block_size / (1024 * 1024);
+				char p = 'M';
+
+				if (cs > 1024.0) {
+					cs /= 1024.0;
+					p = 'G';
+				}
+				if (cs > 1024.0) {
+					cs /= 1024.0;
+					p = 'T';
+				}
+
+				printf("%.2f%% of hits satisfied in %.3f%cB of cache\n", percentage, cs, p);
+				percentage = 0.0;
+			}
+		}
+	}
+
+	perc_i = 100.0 / (double)output_nranges;
+	perc = 0.0;
+
+	printf("\n   Rows           Hits %%         Sum %%           # Hits          Size\n");
+	printf("-----------------------------------------------------------------------\n");
+	for (i = 0; i < output_nranges; i++) {
+		struct output_sum *os = &output_sums[i];
+		double gb = (double)os->nranges * block_size / 1024.0;
+		char p = 'K';
+
+		if (gb > 1024.0) {
+			p = 'M';
+			gb /= 1024.0;
+		}
+		if (gb > 1024.0) {
+			p = 'G';
+			gb /= 1024.0;
+		}
+
+		perc += perc_i;
+		hit_percent_sum += os->output;
+		hit_sum += os->nranges;
+		printf("%s %6.2f%%\t%6.2f%%\t\t%6.2f%%\t\t%8u\t%6.2f%c\n",
+			i ? "|->" : "Top", perc, os->output, hit_percent_sum,
+			os->nranges, gb, p);
+	}
+
+	printf("-----------------------------------------------------------------------\n");
+	printf("Total\t\t\t\t\t\t%8llu\n", hit_sum);
+	free(output_sums);
+}
+
 int main(int argc, char *argv[])
 {
 	unsigned long offset;
-	unsigned long i, j, k, nr_vals, cur_vals, interval, total_vals, nnodes;
 	unsigned long long nranges;
-	struct output_sum *output_sums;
+	unsigned long nnodes;
 	struct node *nodes;
-	double perc, perc_i;
 	struct zipf_state zs;
+	struct gauss_state gs;
+	int i, j;
 
 	if (parse_options(argc, argv))
 		return 1;
 
-	if( !output_csv )
+	if (output_type != OUTPUT_CSV)
 		printf("Generating %s distribution with %f input and %lu GB size and %lu block_size.\n", dist_types[dist_type], dist_val, gb_size, block_size);
 
 	nranges = gb_size * 1024 * 1024 * 1024ULL;
@@ -189,8 +298,10 @@ int main(int argc, char *argv[])
 
 	if (dist_type == TYPE_ZIPF)
 		zipf_init(&zs, nranges, dist_val, 1);
-	else
+	else if (dist_type == TYPE_PARETO)
 		pareto_init(&zs, nranges, dist_val, 1);
+	else
+		gauss_init(&gs, nranges, dist_val, 1);
 
 	hash_bits = 0;
 	hash_size = nranges;
@@ -199,19 +310,21 @@ int main(int argc, char *argv[])
 
 	hash_size = 1 << hash_bits;
 
-	hash = malloc(hash_size * sizeof(struct flist_head));
+	hash = calloc(hash_size, sizeof(struct flist_head));
 	for (i = 0; i < hash_size; i++)
 		INIT_FLIST_HEAD(&hash[i]);
 
 	nodes = malloc(nranges * sizeof(struct node));
 
-	for (nr_vals = i = j = 0; i < nranges; i++) {
+	for (i = j = 0; i < nranges; i++) {
 		struct node *n;
 
 		if (dist_type == TYPE_ZIPF)
 			offset = zipf_next(&zs);
-		else
+		else if (dist_type == TYPE_PARETO)
 			offset = pareto_next(&zs);
+		else
+			offset = gauss_next(&gs);
 
 		n = hash_lookup(offset);
 		if (n)
@@ -220,101 +333,15 @@ int main(int argc, char *argv[])
 			hash_insert(&nodes[j], offset);
 			j++;
 		}
-
-		nr_vals++;
 	}
 
 	qsort(nodes, j, sizeof(struct node), node_cmp);
 	nnodes = j;
-	nr_vals = nnodes;
-
-	if (output_csv) {
-		printf("rank, count\n");
-		for (k = 0; k < nnodes; k++)
-			printf("%lu, %lu\n", k, nodes[k].hits);
-	} else {
-		interval = (nr_vals + output_nranges - 1) / output_nranges;
-
-		output_sums = malloc(output_nranges * sizeof(struct output_sum));
-		for (i = 0; i < output_nranges; i++) {
-			output_sums[i].output = 0.0;
-			output_sums[i].nranges = 1;
-		}
 
-		total_vals = i = j = cur_vals = 0;
-
-		for (k = 0; k < nnodes; k++) {
-			struct output_sum *os = &output_sums[j];
-			struct node *node = &nodes[k];
-
-			if (i >= interval) {
-				os->output =
-				    (double)(cur_vals + 1) / (double)nranges;
-				os->output *= 100.0;
-				j++;
-				cur_vals = node->hits;
-				interval +=
-				    (nr_vals + output_nranges -
-				     1) / output_nranges;
-			} else {
-				cur_vals += node->hits;
-				os->nranges += node->hits;
-			}
-
-			i++;
-			total_vals += node->hits;
-
-			if (percentage) {
-				unsigned long blocks =
-				    percentage * nranges / 100;
-
-				if (total_vals >= blocks) {
-					double cs =
-					    i * block_size / (1024 * 1024);
-					char p = 'M';
-
-					if (cs > 1024.0) {
-						cs /= 1024.0;
-						p = 'G';
-					}
-					if (cs > 1024.0) {
-						cs /= 1024.0;
-						p = 'T';
-					}
-
-					printf("%.2f%% of hits satisfied in %.3f%cB of cache\n", percentage, cs, p);
-					percentage = 0.0;
-				}
-			}
-		}
-
-		perc_i = 100.0 / (double)output_nranges;
-		perc = 0.0;
-
-		printf("\n   Rows           Hits           No Hits         Size\n");
-		printf("--------------------------------------------------------\n");
-		for (i = 0; i < j; i++) {
-			struct output_sum *os = &output_sums[i];
-			double gb = (double)os->nranges * block_size / 1024.0;
-			char p = 'K';
-
-			if (gb > 1024.0) {
-				p = 'M';
-				gb /= 1024.0;
-			}
-			if (gb > 1024.0) {
-				p = 'G';
-				gb /= 1024.0;
-			}
-
-			perc += perc_i;
-			printf("%s %6.2f%%\t%6.2f%%\t\t%8u\t%6.2f%c\n",
-			       i ? "|->" : "Top", perc, os->output, os->nranges,
-			       gb, p);
-		}
-
-		free(output_sums);
-	}
+	if (output_type == OUTPUT_CSV)
+		output_csv(nodes, nnodes);
+	else
+		output_normal(nodes, nnodes, nranges);
 
 	free(hash);
 	free(nodes);
diff --git a/thread_options.h b/thread_options.h
index 5a2428a..ee1114d 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -129,6 +129,7 @@ struct thread_options {
 
 	fio_fp64_t zipf_theta;
 	fio_fp64_t pareto_h;
+	fio_fp64_t gauss_dev;
 
 	unsigned int random_generator;
 
@@ -355,8 +356,10 @@ struct thread_options_pack {
 
 	uint32_t random_distribution;
 	uint32_t pad;
+
 	fio_fp64_t zipf_theta;
 	fio_fp64_t pareto_h;
+	fio_fp64_t gauss_dev;
 
 	uint32_t random_generator;
 
