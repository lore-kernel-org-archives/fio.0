Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:46778 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751106AbdGMMAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 13 Jul 2017 08:00:07 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dVcms-0006GA-KG
        for fio@vger.kernel.org; Thu, 13 Jul 2017 12:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170713120002.399002C009B@kernel.dk>
Date: Thu, 13 Jul 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit ef2f4a50c25b3315d8825eb5e6fdfd6d57a47b74:

  return correct error code for unhandled addr. (2017-07-11 00:28:45 +0800)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 43f466e667a8bcfc58c1c69b0897fe0345c34841:

  parse: enable options to be marked dont-free (2017-07-12 16:44:07 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      profiles/act: use the right options
      parse: enable options to be marked dont-free

 parse.c             |  2 +-
 parse.h             |  1 +
 profiles/act.c      | 35 +++++++++++++++--------------------
 profiles/tiobench.c |  1 +
 4 files changed, 18 insertions(+), 21 deletions(-)

---

Diff of recent changes:

diff --git a/parse.c b/parse.c
index 4d4fddd..ecce8b8 100644
--- a/parse.c
+++ b/parse.c
@@ -1345,7 +1345,7 @@ void options_free(struct fio_option *options, void *data)
 	dprint(FD_PARSE, "free options\n");
 
 	for (o = &options[0]; o->name; o++) {
-		if (o->type != FIO_OPT_STR_STORE || !o->off1)
+		if (o->type != FIO_OPT_STR_STORE || !o->off1 || o->no_free)
 			continue;
 
 		ptr = td_var(data, o, o->off1);
diff --git a/parse.h b/parse.h
index fb6abd1..dfe7f16 100644
--- a/parse.h
+++ b/parse.h
@@ -78,6 +78,7 @@ struct fio_option {
 	int is_time;			/* time based value */
 	int no_warn_def;
 	int pow2;			/* must be a power-of-2 */
+	int no_free;
 };
 
 extern int parse_option(char *, const char *, struct fio_option *, struct fio_option **, void *, struct flist_head *);
diff --git a/profiles/act.c b/profiles/act.c
index 59e5005..4669535 100644
--- a/profiles/act.c
+++ b/profiles/act.c
@@ -53,14 +53,6 @@ struct act_prof_data {
 	unsigned int nr_slices;
 };
 
-static char *device_names;
-static unsigned int load;
-static unsigned int prep;
-static unsigned int threads_per_queue;
-static unsigned int num_read_blocks;
-static unsigned int write_size;
-static unsigned long long test_duration;
-
 #define ACT_MAX_OPTS	128
 static const char *act_opts[ACT_MAX_OPTS] = {
 	"direct=1",
@@ -97,6 +89,7 @@ static struct fio_option options[] = {
 		.help	= "Devices to use",
 		.category = FIO_OPT_C_PROFILE,
 		.group	= FIO_OPT_G_ACT,
+		.no_free = true,
 	},
 	{
 		.name	= "load",
@@ -185,6 +178,8 @@ static int act_add_opt(const char *str, ...)
 
 static int act_add_rw(const char *dev, int reads)
 {
+	struct act_options *ao = &act_options;
+
 	if (act_add_opt("name=act-%s-%s", reads ? "read" : "write", dev))
 		return 1;
 	if (act_add_opt("filename=%s", dev))
@@ -192,21 +187,21 @@ static int act_add_rw(const char *dev, int reads)
 	if (act_add_opt("rw=%s", reads ? "randread" : "randwrite"))
 		return 1;
 	if (reads) {
-		int rload = load * R_LOAD / threads_per_queue;
+		int rload = ao->load * R_LOAD / ao->threads_per_queue;
 
-		if (act_add_opt("numjobs=%u", threads_per_queue))
+		if (act_add_opt("numjobs=%u", ao->threads_per_queue))
 			return 1;
 		if (act_add_opt("rate_iops=%u", rload))
 			return 1;
-		if (act_add_opt("bs=%u", num_read_blocks * 512))
+		if (act_add_opt("bs=%u", ao->num_read_blocks * 512))
 			return 1;
 	} else {
-		const int rsize = write_size / (num_read_blocks * 512);
-		int wload = (load * W_LOAD + rsize - 1) / rsize;
+		const int rsize = ao->write_size / (ao->num_read_blocks * 512);
+		int wload = (ao->load * W_LOAD + rsize - 1) / rsize;
 
 		if (act_add_opt("rate_iops=%u", wload))
 			return 1;
-		if (act_add_opt("bs=%u", write_size))
+		if (act_add_opt("bs=%u", ao->write_size))
 			return 1;
 	}
 
@@ -248,10 +243,10 @@ static int act_add_dev_prep(const char *dev)
 
 static int act_add_dev(const char *dev)
 {
-	if (prep)
+	if (act_options.prep)
 		return act_add_dev_prep(dev);
 
-	if (act_add_opt("runtime=%llus", test_duration))
+	if (act_add_opt("runtime=%llus", act_options.test_duration))
 		return 1;
 	if (act_add_opt("time_based=1"))
 		return 1;
@@ -269,7 +264,7 @@ static int act_add_dev(const char *dev)
  */
 static int act_prep_cmdline(void)
 {
-	if (!device_names) {
+	if (!act_options.device_names) {
 		log_err("act: you need to set IO target(s) with the "
 			"device-names option.\n");
 		return 1;
@@ -280,7 +275,7 @@ static int act_prep_cmdline(void)
 	do {
 		char *dev;
 
-		dev = strsep(&device_names, ",");
+		dev = strsep(&act_options.device_names, ",");
 		if (!dev)
 			break;
 
@@ -300,7 +295,7 @@ static int act_io_u_lat(struct thread_data *td, uint64_t usec)
 	int i, ret = 0;
 	double perm;
 
-	if (prep)
+	if (act_options.prep)
 		return 0;
 
 	/*
@@ -431,7 +426,7 @@ static int act_td_init(struct thread_data *td)
 	get_act_ref();
 
 	apd = calloc(1, sizeof(*apd));
-	nr_slices = (test_duration + SAMPLE_SEC - 1) / SAMPLE_SEC;
+	nr_slices = (act_options.test_duration + SAMPLE_SEC - 1) / SAMPLE_SEC;
 	apd->slices = calloc(nr_slices, sizeof(struct act_slice));
 	apd->nr_slices = nr_slices;
 	fio_gettime(&apd->sample_tv, NULL);
diff --git a/profiles/tiobench.c b/profiles/tiobench.c
index 9d9885a..f19a085 100644
--- a/profiles/tiobench.c
+++ b/profiles/tiobench.c
@@ -70,6 +70,7 @@ static struct fio_option options[] = {
 		.help	= "Test directory",
 		.category = FIO_OPT_C_PROFILE,
 		.group	= FIO_OPT_G_TIOBENCH,
+		.no_free = true,
 	},
 	{
 		.name	= "threads",
