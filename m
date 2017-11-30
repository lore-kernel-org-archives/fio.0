Return-Path: <axboe@kernel.dk>
Subject: Re: Random distribution: zoned argument
From: Jens Axboe <axboe@kernel.dk>
References: <CAODBMzm2qZu=gcpDKLyQ27zyFgkDD1ieaw2b4=A869_zuQE7HA@mail.gmail.com>
 <261eb52b-e606-2736-d195-7abbcf2dd762@kernel.dk>
 <CAODBMzmD0o-bWNV0gpYNuFcQHo=BMLCVAALZvpPaVo36PFsd+w@mail.gmail.com>
 <2db67a6b-137f-42df-208d-1c4c97190fb2@kernel.dk>
 <ca7a2874-4f42-22c9-7d0b-04e251ab2532@kernel.dk>
 <CAODBMzkEkk8xqPFsEeFGSYL-dtJW5Q010ojuHRAcL=o71YcU7g@mail.gmail.com>
 <ad78196d-0e0b-bbf8-4c9f-02ce877b4051@kernel.dk>
 <b352de81-8175-87fa-be5e-3c5ceda20b23@kernel.dk>
Message-ID: <ec439e5c-5df3-06ff-c21a-22c22b90ebff@kernel.dk>
Date: Wed, 29 Nov 2017 19:16:04 -0700
MIME-Version: 1.0
In-Reply-To: <b352de81-8175-87fa-be5e-3c5ceda20b23@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Phillip Chen <phillip.a.chen@seagate.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 11/29/2017 06:37 PM, Jens Axboe wrote:
> On 11/29/2017 01:58 PM, Jens Axboe wrote:
>> I'll take a look at adding absolute zoning, should be pretty
>> trivial.
> 
> Quick and dirty here, can you see if this works with your magic
> script?
> 
> Basically you just do:
> 
> random_distribution=zoned_abs:60/100m:10/200m:30/700m                           
> 
> like you would for 'zoned' - the first is a percentage, the
> other part is a size. So the above would be:
> 
> - 60% of accesss to the first 100M
> - 10% of access to the next 200M
> - 30% of access to the next 700m
> 
> No checking for whether or not we exceed device/file size or anything
> like that in this version, but everything else should work with the
> existing code pretty nicely. Not tested...

Added documentation, and modified your script do have:

dist_str = "zoned_abs:50/35770m:10/286166m:40/35770m"                           

for a 375G nvme drive I have, this yields:

histogram percents = [25.011592135525543, 25.014596077621864, 0.6177337336535484, 0.6206606515935528, 0.6198133858740779, 0.6175796853409167, 0.6187350476856551, 0.6266685357861933, 0.6370667968888403, 0.6393004974220015, 0.6279009222872477, 0.6302886711330408, 0.6230484004393458, 0.6274387773493523, 0.6131122842745942, 0.6258982942230342, 0.614036574150385, 0.6185809993730234, 19.971208370369116, 20.02474015900867]
histogram edges = [36629084.0, 73258168.0, 109887252.0, 146516336.0, 183145420.0, 219774504.0, 256403588.0, 293032672.0, 329661756.0, 366290840.0, 402919924.0, 439549008.0, 476178092.0, 512807176.0, 549436260.0, 586065344.0, 622694428.0, 659323512.0, 695952596.0, 732581680.0]
zoned_abs:50/35770m:10/286166m:40/35770m

which looks correct to me - 50% in the first two buckets, which is defined as
the first 10% of the drive. 40% in the last two buckets, which is the last 10%
of the drive. And the rest in the middle, which should add up to 10 (quick
eyeballing says it does).

Updated patch below. Only change is the added documentation, and a check
for exceeding device/file size.


diff --git a/HOWTO b/HOWTO
index 164ba2bbdea2..dc99e9989a47 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1254,6 +1254,9 @@ I/O type
 		**zoned**
 				Zoned random distribution
 
+		**zoned_abs**
+				Zone absolute random distribution
+
 	When using a **zipf** or **pareto** distribution, an input value is also
 	needed to define the access pattern. For **zipf**, this is the `Zipf
 	theta`. For **pareto**, it's the `Pareto power`. Fio includes a test
@@ -1278,10 +1281,23 @@ I/O type
 
 		random_distribution=zoned:60/10:30/20:8/30:2/40
 
-	similarly to how :option:`bssplit` works for setting ranges and percentages
-	of block sizes. Like :option:`bssplit`, it's possible to specify separate
-	zones for reads, writes, and trims. If just one set is given, it'll apply to
-	all of them.
+	A **zoned_abs** distribution works exactly like the **zoned**, except
+	that it takes absolute sizes. For example, let's say you wanted to
+	define access according to the following criteria:
+
+		* 60% of accesses should be to the first 20G
+		* 30% of accesses should be to the next 100G
+		* 10% of accesses should be to the next 500G
+
+	we can define an absolute zoning distribution with:
+
+		random_distribution=zoned_abs=60/20G:30/100G:10/500g
+
+	Similarly to how :option:`bssplit` works for setting ranges and
+	percentages of block sizes. Like :option:`bssplit`, it's possible to
+	specify separate zones for reads, writes, and trims. If just one set
+	is given, it'll apply to all of them. This goes for both **zoned**
+	**zoned_abs** distributions.
 
 .. option:: percentage_random=int[,int][,int]
 
diff --git a/fio.1 b/fio.1
index a4b0ea6af750..01b4db6f8c9e 100644
--- a/fio.1
+++ b/fio.1
@@ -1033,6 +1033,8 @@ Normal (Gaussian) distribution
 .TP
 .B zoned
 Zoned random distribution
+.B zoned_abs
+Zoned absolute random distribution
 .RE
 .P
 When using a \fBzipf\fR or \fBpareto\fR distribution, an input value is also
@@ -1068,7 +1070,27 @@ example, the user would do:
 random_distribution=zoned:60/10:30/20:8/30:2/40
 .RE
 .P
-similarly to how \fBbssplit\fR works for setting ranges and percentages
+A \fBzoned_abs\fR distribution works exactly like the\fBzoned\fR, except that
+it takes absolute sizes. For example, let's say you wanted to define access
+according to the following criteria:
+.RS
+.P
+.PD 0
+60% of accesses should be to the first 20G
+.P
+30% of accesses should be to the next 100G
+.P
+10% of accesses should be to the next 500G
+.PD
+.RE
+.P
+we can define an absolute zoning distribution with:
+.RS
+.P
+random_distribution=zoned:60/10:30/20:8/30:2/40
+.RE
+.P
+Similarly to how \fBbssplit\fR works for setting ranges and percentages
 of block sizes. Like \fBbssplit\fR, it's possible to specify separate
 zones for reads, writes, and trims. If just one set is given, it'll apply to
 all of them.
diff --git a/fio.h b/fio.h
index 8ca934d14a4c..a44f1aae4721 100644
--- a/fio.h
+++ b/fio.h
@@ -158,6 +158,8 @@ void sk_out_drop(void);
 struct zone_split_index {
 	uint8_t size_perc;
 	uint8_t size_perc_prev;
+	uint64_t size;
+	uint64_t size_prev;
 };
 
 /*
@@ -813,6 +815,7 @@ enum {
 	FIO_RAND_DIST_PARETO,
 	FIO_RAND_DIST_GAUSS,
 	FIO_RAND_DIST_ZONED,
+	FIO_RAND_DIST_ZONED_ABS,
 };
 
 #define FIO_DEF_ZIPF		1.1
diff --git a/io_u.c b/io_u.c
index 81ee724b7357..6ec04fa30607 100644
--- a/io_u.c
+++ b/io_u.c
@@ -157,6 +157,80 @@ static int __get_next_rand_offset_gauss(struct thread_data *td,
 	return 0;
 }
 
+static int __get_next_rand_offset_zoned_abs(struct thread_data *td,
+					    struct fio_file *f,
+					    enum fio_ddir ddir, uint64_t *b)
+{
+	struct zone_split_index *zsi;
+	uint64_t offset, lastb;
+	uint64_t send, stotal;
+	static int warned;
+	unsigned int v;
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
+	/*
+	 * Generate a value, v, between 1 and 100, both inclusive
+	 */
+	v = rand32_between(&td->zone_state, 1, 100);
+
+	zsi = &td->zone_state_index[ddir][v - 1];
+	stotal = zsi->size_prev / td->o.ba[ddir];
+	send = zsi->size / td->o.ba[ddir];
+
+	/*
+	 * Should never happen
+	 */
+	if (send == -1U) {
+		if (!warned) {
+			log_err("fio: bug in zoned generation\n");
+			warned = 1;
+		}
+		goto bail;
+	} else if (send > lastb) {
+		/*
+		 * This happens if the user specifies ranges that exceed
+		 * the file/device size. We can't handle that gracefully,
+		 * so error and exit.
+		 */
+		log_err("fio: zoned_abs sizes exceed file size\n");
+		return 1;
+	}
+
+	/*
+	 * 'send' is some percentage below or equal to 100 that
+	 * marks the end of the current IO range. 'stotal' marks
+	 * the start, in percent.
+	 */
+	if (stotal)
+		offset = stotal;
+	else
+		offset = 0;
+
+	lastb = send - stotal;
+
+	/*
+	 * Generate index from 0..send-of-lastb
+	 */
+	if (__get_next_rand_offset(td, f, ddir, b, lastb) == 1)
+		return 1;
+
+	/*
+	 * Add our start offset, if any
+	 */
+	if (offset)
+		*b += offset;
+
+	return 0;
+}
+
 static int __get_next_rand_offset_zoned(struct thread_data *td,
 					struct fio_file *f, enum fio_ddir ddir,
 					uint64_t *b)
@@ -249,6 +323,8 @@ static int get_off_from_method(struct thread_data *td, struct fio_file *f,
 		return __get_next_rand_offset_gauss(td, f, ddir, b);
 	else if (td->o.random_distribution == FIO_RAND_DIST_ZONED)
 		return __get_next_rand_offset_zoned(td, f, ddir, b);
+	else if (td->o.random_distribution == FIO_RAND_DIST_ZONED_ABS)
+		return __get_next_rand_offset_zoned_abs(td, f, ddir, b);
 
 	log_err("fio: unknown random distribution: %d\n", td->o.random_distribution);
 	return 1;
diff --git a/options.c b/options.c
index 4bea8f781304..d979f804d76c 100644
--- a/options.c
+++ b/options.c
@@ -54,16 +54,19 @@ static int bs_cmp(const void *p1, const void *p2)
 	return (int) bsp1->perc - (int) bsp2->perc;
 }
 
+#define SPLIT_MAX_ENTRY	100
+
 struct split {
 	unsigned int nr;
-	unsigned int val1[100];
-	unsigned int val2[100];
+	unsigned int val1[SPLIT_MAX_ENTRY];
+	unsigned long long val2[SPLIT_MAX_ENTRY];
 };
 
 static int split_parse_ddir(struct thread_options *o, struct split *split,
-			    enum fio_ddir ddir, char *str)
+			    enum fio_ddir ddir, char *str, bool absolute)
 {
-	unsigned int i, perc;
+	unsigned long long perc;
+	unsigned int i;
 	long long val;
 	char *fname;
 
@@ -80,23 +83,35 @@ static int split_parse_ddir(struct thread_options *o, struct split *split,
 		if (perc_str) {
 			*perc_str = '\0';
 			perc_str++;
-			perc = atoi(perc_str);
-			if (perc > 100)
-				perc = 100;
-			else if (!perc)
+			if (absolute) {
+				if (str_to_decimal(perc_str, &val, 1, o, 0, 0)) {
+					log_err("fio: split conversion failed\n");
+					return 1;
+				}
+				perc = val;
+			} else {
+				perc = atoi(perc_str);
+				if (perc > 100)
+					perc = 100;
+				else if (!perc)
+					perc = -1U;
+			}
+		} else {
+			if (absolute)
+				perc = 0;
+			else
 				perc = -1U;
-		} else
-			perc = -1U;
+		}
 
 		if (str_to_decimal(fname, &val, 1, o, 0, 0)) {
-			log_err("fio: bssplit conversion failed\n");
+			log_err("fio: split conversion failed\n");
 			return 1;
 		}
 
 		split->val1[i] = val;
 		split->val2[i] = perc;
 		i++;
-		if (i == 100)
+		if (i == SPLIT_MAX_ENTRY)
 			break;
 	}
 
@@ -104,7 +119,8 @@ static int split_parse_ddir(struct thread_options *o, struct split *split,
 	return 0;
 }
 
-static int bssplit_ddir(struct thread_options *o, enum fio_ddir ddir, char *str)
+static int bssplit_ddir(struct thread_options *o, enum fio_ddir ddir, char *str,
+			bool data)
 {
 	unsigned int i, perc, perc_missing;
 	unsigned int max_bs, min_bs;
@@ -112,7 +128,7 @@ static int bssplit_ddir(struct thread_options *o, enum fio_ddir ddir, char *str)
 
 	memset(&split, 0, sizeof(split));
 
-	if (split_parse_ddir(o, &split, ddir, str))
+	if (split_parse_ddir(o, &split, ddir, str, data))
 		return 1;
 	if (!split.nr)
 		return 0;
@@ -176,9 +192,10 @@ static int bssplit_ddir(struct thread_options *o, enum fio_ddir ddir, char *str)
 	return 0;
 }
 
-typedef int (split_parse_fn)(struct thread_options *, enum fio_ddir, char *);
+typedef int (split_parse_fn)(struct thread_options *, enum fio_ddir, char *, bool);
 
-static int str_split_parse(struct thread_data *td, char *str, split_parse_fn *fn)
+static int str_split_parse(struct thread_data *td, char *str,
+			   split_parse_fn *fn, bool data)
 {
 	char *odir, *ddir;
 	int ret = 0;
@@ -187,37 +204,37 @@ static int str_split_parse(struct thread_data *td, char *str, split_parse_fn *fn
 	if (odir) {
 		ddir = strchr(odir + 1, ',');
 		if (ddir) {
-			ret = fn(&td->o, DDIR_TRIM, ddir + 1);
+			ret = fn(&td->o, DDIR_TRIM, ddir + 1, data);
 			if (!ret)
 				*ddir = '\0';
 		} else {
 			char *op;
 
 			op = strdup(odir + 1);
-			ret = fn(&td->o, DDIR_TRIM, op);
+			ret = fn(&td->o, DDIR_TRIM, op, data);
 
 			free(op);
 		}
 		if (!ret)
-			ret = fn(&td->o, DDIR_WRITE, odir + 1);
+			ret = fn(&td->o, DDIR_WRITE, odir + 1, data);
 		if (!ret) {
 			*odir = '\0';
-			ret = fn(&td->o, DDIR_READ, str);
+			ret = fn(&td->o, DDIR_READ, str, data);
 		}
 	} else {
 		char *op;
 
 		op = strdup(str);
-		ret = fn(&td->o, DDIR_WRITE, op);
+		ret = fn(&td->o, DDIR_WRITE, op, data);
 		free(op);
 
 		if (!ret) {
 			op = strdup(str);
-			ret = fn(&td->o, DDIR_TRIM, op);
+			ret = fn(&td->o, DDIR_TRIM, op, data);
 			free(op);
 		}
 		if (!ret)
-			ret = fn(&td->o, DDIR_READ, str);
+			ret = fn(&td->o, DDIR_READ, str, data);
 	}
 
 	return ret;
@@ -234,7 +251,7 @@ static int str_bssplit_cb(void *data, const char *input)
 	strip_blank_front(&str);
 	strip_blank_end(str);
 
-	ret = str_split_parse(td, str, bssplit_ddir);
+	ret = str_split_parse(td, str, bssplit_ddir, false);
 
 	if (parse_dryrun()) {
 		int i;
@@ -824,14 +841,14 @@ static int str_sfr_cb(void *data, const char *str)
 #endif
 
 static int zone_split_ddir(struct thread_options *o, enum fio_ddir ddir,
-			   char *str)
+			   char *str, bool absolute)
 {
 	unsigned int i, perc, perc_missing, sperc, sperc_missing;
 	struct split split;
 
 	memset(&split, 0, sizeof(split));
 
-	if (split_parse_ddir(o, &split, ddir, str))
+	if (split_parse_ddir(o, &split, ddir, str, absolute))
 		return 1;
 	if (!split.nr)
 		return 0;
@@ -840,7 +857,10 @@ static int zone_split_ddir(struct thread_options *o, enum fio_ddir ddir,
 	o->zone_split_nr[ddir] = split.nr;
 	for (i = 0; i < split.nr; i++) {
 		o->zone_split[ddir][i].access_perc = split.val1[i];
-		o->zone_split[ddir][i].size_perc = split.val2[i];
+		if (absolute)
+			o->zone_split[ddir][i].size = split.val2[i];
+		else
+			o->zone_split[ddir][i].size_perc = split.val2[i];
 	}
 
 	/*
@@ -856,11 +876,12 @@ static int zone_split_ddir(struct thread_options *o, enum fio_ddir ddir,
 		else
 			perc += zsp->access_perc;
 
-		if (zsp->size_perc == (uint8_t) -1U)
-			sperc_missing++;
-		else
-			sperc += zsp->size_perc;
-
+		if (!absolute) {
+			if (zsp->size_perc == (uint8_t) -1U)
+				sperc_missing++;
+			else
+				sperc += zsp->size_perc;
+		}
 	}
 
 	if (perc > 100 || sperc > 100) {
@@ -908,10 +929,11 @@ static int zone_split_ddir(struct thread_options *o, enum fio_ddir ddir,
 static void __td_zone_gen_index(struct thread_data *td, enum fio_ddir ddir)
 {
 	unsigned int i, j, sprev, aprev;
+	uint64_t sprev_sz;
 
 	td->zone_state_index[ddir] = malloc(sizeof(struct zone_split_index) * 100);
 
-	sprev = aprev = 0;
+	sprev_sz = sprev = aprev = 0;
 	for (i = 0; i < td->o.zone_split_nr[ddir]; i++) {
 		struct zone_split *zsp = &td->o.zone_split[ddir][i];
 
@@ -920,10 +942,14 @@ static void __td_zone_gen_index(struct thread_data *td, enum fio_ddir ddir)
 
 			zsi->size_perc = sprev + zsp->size_perc;
 			zsi->size_perc_prev = sprev;
+
+			zsi->size = sprev_sz + zsp->size;
+			zsi->size_prev = sprev_sz;
 		}
 
 		aprev += zsp->access_perc;
 		sprev += zsp->size_perc;
+		sprev_sz += zsp->size;
 	}
 }
 
@@ -942,8 +968,10 @@ static void td_zone_gen_index(struct thread_data *td)
 		__td_zone_gen_index(td, i);
 }
 
-static int parse_zoned_distribution(struct thread_data *td, const char *input)
+static int parse_zoned_distribution(struct thread_data *td, const char *input,
+				    bool absolute)
 {
+	const char *pre = absolute ? "zoned_abs:" : "zoned:";
 	char *str, *p;
 	int i, ret = 0;
 
@@ -953,14 +981,14 @@ static int parse_zoned_distribution(struct thread_data *td, const char *input)
 	strip_blank_end(str);
 
 	/* We expect it to start like that, bail if not */
-	if (strncmp(str, "zoned:", 6)) {
+	if (strncmp(str, pre, strlen(pre))) {
 		log_err("fio: mismatch in zoned input <%s>\n", str);
 		free(p);
 		return 1;
 	}
-	str += strlen("zoned:");
+	str += strlen(pre);
 
-	ret = str_split_parse(td, str, zone_split_ddir);
+	ret = str_split_parse(td, str, zone_split_ddir, absolute);
 
 	free(p);
 
@@ -972,8 +1000,15 @@ static int parse_zoned_distribution(struct thread_data *td, const char *input)
 		for (j = 0; j < td->o.zone_split_nr[i]; j++) {
 			struct zone_split *zsp = &td->o.zone_split[i][j];
 
-			dprint(FD_PARSE, "\t%d: %u/%u\n", j, zsp->access_perc,
-								zsp->size_perc);
+			if (absolute) {
+				dprint(FD_PARSE, "\t%d: %u/%llu\n", j,
+						zsp->access_perc,
+						(unsigned long long) zsp->size);
+			} else {
+				dprint(FD_PARSE, "\t%d: %u/%u\n", j,
+						zsp->access_perc,
+						zsp->size_perc);
+			}
 		}
 	}
 
@@ -1012,7 +1047,9 @@ static int str_random_distribution_cb(void *data, const char *str)
 	else if (td->o.random_distribution == FIO_RAND_DIST_GAUSS)
 		val = 0.0;
 	else if (td->o.random_distribution == FIO_RAND_DIST_ZONED)
-		return parse_zoned_distribution(td, str);
+		return parse_zoned_distribution(td, str, false);
+	else if (td->o.random_distribution == FIO_RAND_DIST_ZONED_ABS)
+		return parse_zoned_distribution(td, str, true);
 	else
 		return 0;
 
@@ -2241,7 +2278,10 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .oval = FIO_RAND_DIST_ZONED,
 			    .help = "Zoned random distribution",
 			  },
-
+			  { .ival = "zoned_abs",
+			    .oval = FIO_RAND_DIST_ZONED_ABS,
+			    .help = "Zoned absolute random distribution",
+			  },
 		},
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_RANDOM,
diff --git a/server.h b/server.h
index ba3abfeb3228..dbd5c277de6b 100644
--- a/server.h
+++ b/server.h
@@ -49,7 +49,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 66,
+	FIO_SERVER_VER			= 67,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index ca549b542703..050cd3822914 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -36,6 +36,8 @@ struct bssplit {
 struct zone_split {
 	uint8_t access_perc;
 	uint8_t size_perc;
+	uint8_t pad[6];
+	uint64_t size;
 };
 
 #define NR_OPTS_SZ	(FIO_MAX_OPTS / (8 * sizeof(uint64_t)))

-- 
Jens Axboe


