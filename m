Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:47640 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752027AbeDRMAZ (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 18 Apr 2018 08:00:25 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1f8llB-0007WC-0z
        for fio@vger.kernel.org; Wed, 18 Apr 2018 12:00:25 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180418120002.2657A2C00EE@kernel.dk>
Date: Wed, 18 Apr 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c7d32225c3efe61c79470bc31bb369b33d3e3a88:

  Merge branch 'nvml-to-pmdk' of https://github.com/sscargal/fio (2018-04-16 19:40:46 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f31feaa21642929b6d9d5396b73669372fda9a0a:

  Deprecate verifysort and verifysort_nr (2018-04-17 21:50:55 -0600)

----------------------------------------------------------------
Jens Axboe (3):
      init: ensure that read/write use the same random seed for verify
      parse: add support for soft deprecated options
      Deprecate verifysort and verifysort_nr

 backend.c        |  1 -
 cconv.c          |  4 ---
 fio.h            |  2 --
 init.c           | 23 ++++++++++--------
 io_u.c           | 74 ++------------------------------------------------------
 iolog.c          |  3 +--
 options.c        | 15 ++----------
 parse.c          | 10 +++++---
 parse.h          |  1 +
 rate-submit.c    |  1 -
 thread_options.h |  4 ---
 verify.c         |  5 ++--
 12 files changed, 28 insertions(+), 115 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index b28c3db..a2a0b3d 100644
--- a/backend.c
+++ b/backend.c
@@ -1549,7 +1549,6 @@ static void *thread_main(void *data)
 	INIT_FLIST_HEAD(&td->io_hist_list);
 	INIT_FLIST_HEAD(&td->verify_list);
 	INIT_FLIST_HEAD(&td->trim_list);
-	INIT_FLIST_HEAD(&td->next_rand_list);
 	td->io_hist_tree = RB_ROOT;
 
 	ret = mutex_cond_init_pshared(&td->io_u_lock, &td->free_cond);
diff --git a/cconv.c b/cconv.c
index 585ed86..9e163b3 100644
--- a/cconv.c
+++ b/cconv.c
@@ -162,8 +162,6 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->write_hint = le32_to_cpu(top->write_hint);
 	o->verify = le32_to_cpu(top->verify);
 	o->do_verify = le32_to_cpu(top->do_verify);
-	o->verifysort = le32_to_cpu(top->verifysort);
-	o->verifysort_nr = le32_to_cpu(top->verifysort_nr);
 	o->experimental_verify = le32_to_cpu(top->experimental_verify);
 	o->verify_state = le32_to_cpu(top->verify_state);
 	o->verify_interval = le32_to_cpu(top->verify_interval);
@@ -376,8 +374,6 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->write_hint = cpu_to_le32(o->write_hint);
 	top->verify = cpu_to_le32(o->verify);
 	top->do_verify = cpu_to_le32(o->do_verify);
-	top->verifysort = cpu_to_le32(o->verifysort);
-	top->verifysort_nr = cpu_to_le32(o->verifysort_nr);
 	top->experimental_verify = cpu_to_le32(o->experimental_verify);
 	top->verify_state = cpu_to_le32(o->verify_state);
 	top->verify_interval = cpu_to_le32(o->verify_interval);
diff --git a/fio.h b/fio.h
index 2bfcac4..4ce4991 100644
--- a/fio.h
+++ b/fio.h
@@ -405,8 +405,6 @@ struct thread_data {
 	struct flist_head trim_list;
 	unsigned long trim_entries;
 
-	struct flist_head next_rand_list;
-
 	/*
 	 * for fileservice, how often to switch to a new file
 	 */
diff --git a/init.c b/init.c
index f5ff73d..07d1cdd 100644
--- a/init.c
+++ b/init.c
@@ -997,23 +997,26 @@ void td_fill_verify_state_seed(struct thread_data *td)
 
 static void td_fill_rand_seeds_internal(struct thread_data *td, bool use64)
 {
+	unsigned int read_seed = td->rand_seeds[FIO_RAND_BS_OFF];
+	unsigned int write_seed = td->rand_seeds[FIO_RAND_BS1_OFF];
+	unsigned int trim_seed = td->rand_seeds[FIO_RAND_BS2_OFF];
 	int i;
 
 	/*
 	 * trimwrite is special in that we need to generate the same
 	 * offsets to get the "write after trim" effect. If we are
 	 * using bssplit to set buffer length distributions, ensure that
-	 * we seed the trim and write generators identically.
+	 * we seed the trim and write generators identically. Ditto for
+	 * verify, read and writes must have the same seed, if we are doing
+	 * read verify.
 	 */
-	if (td_trimwrite(td)) {
-		init_rand_seed(&td->bsrange_state[DDIR_READ], td->rand_seeds[FIO_RAND_BS_OFF], use64);
-		init_rand_seed(&td->bsrange_state[DDIR_WRITE], td->rand_seeds[FIO_RAND_BS1_OFF], use64);
-		init_rand_seed(&td->bsrange_state[DDIR_TRIM], td->rand_seeds[FIO_RAND_BS1_OFF], use64);
-	} else {
-		init_rand_seed(&td->bsrange_state[DDIR_READ], td->rand_seeds[FIO_RAND_BS_OFF], use64);
-		init_rand_seed(&td->bsrange_state[DDIR_WRITE], td->rand_seeds[FIO_RAND_BS1_OFF], use64);
-		init_rand_seed(&td->bsrange_state[DDIR_TRIM], td->rand_seeds[FIO_RAND_BS2_OFF], use64);
-	}
+	if (td->o.verify != VERIFY_NONE)
+		write_seed = read_seed;
+	if (td_trimwrite(td))
+		trim_seed = write_seed;
+	init_rand_seed(&td->bsrange_state[DDIR_READ], read_seed, use64);
+	init_rand_seed(&td->bsrange_state[DDIR_WRITE], write_seed, use64);
+	init_rand_seed(&td->bsrange_state[DDIR_TRIM], trim_seed, use64);
 
 	td_fill_verify_state_seed(td);
 	init_rand_seed(&td->rwmix_state, td->rand_seeds[FIO_RAND_MIX_OFF], false);
diff --git a/io_u.c b/io_u.c
index 5fbb238..633f617 100644
--- a/io_u.c
+++ b/io_u.c
@@ -77,11 +77,6 @@ static uint64_t last_block(struct thread_data *td, struct fio_file *f,
 	return max_blocks;
 }
 
-struct rand_off {
-	struct flist_head list;
-	uint64_t off;
-};
-
 static int __get_next_rand_offset(struct thread_data *td, struct fio_file *f,
 				  enum fio_ddir ddir, uint64_t *b,
 				  uint64_t lastb)
@@ -272,16 +267,8 @@ bail:
 	return 0;
 }
 
-static int flist_cmp(void *data, struct flist_head *a, struct flist_head *b)
-{
-	struct rand_off *r1 = flist_entry(a, struct rand_off, list);
-	struct rand_off *r2 = flist_entry(b, struct rand_off, list);
-
-	return r1->off - r2->off;
-}
-
-static int get_off_from_method(struct thread_data *td, struct fio_file *f,
-			       enum fio_ddir ddir, uint64_t *b)
+static int get_next_rand_offset(struct thread_data *td, struct fio_file *f,
+				enum fio_ddir ddir, uint64_t *b)
 {
 	if (td->o.random_distribution == FIO_RAND_DIST_RANDOM) {
 		uint64_t lastb;
@@ -306,25 +293,6 @@ static int get_off_from_method(struct thread_data *td, struct fio_file *f,
 	return 1;
 }
 
-/*
- * Sort the reads for a verify phase in batches of verifysort_nr, if
- * specified.
- */
-static inline bool should_sort_io(struct thread_data *td)
-{
-	if (!td->o.verifysort_nr || !td->o.do_verify)
-		return false;
-	if (!td_random(td))
-		return false;
-	if (td->runstate != TD_VERIFYING)
-		return false;
-	if (td->o.random_generator == FIO_RAND_GEN_TAUSWORTHE ||
-	    td->o.random_generator == FIO_RAND_GEN_TAUSWORTHE64)
-		return false;
-
-	return true;
-}
-
 static bool should_do_random(struct thread_data *td, enum fio_ddir ddir)
 {
 	unsigned int v;
@@ -337,44 +305,6 @@ static bool should_do_random(struct thread_data *td, enum fio_ddir ddir)
 	return v <= td->o.perc_rand[ddir];
 }
 
-static int get_next_rand_offset(struct thread_data *td, struct fio_file *f,
-				enum fio_ddir ddir, uint64_t *b)
-{
-	struct rand_off *r;
-	int i, ret = 1;
-
-	if (!should_sort_io(td))
-		return get_off_from_method(td, f, ddir, b);
-
-	if (!flist_empty(&td->next_rand_list)) {
-fetch:
-		r = flist_first_entry(&td->next_rand_list, struct rand_off, list);
-		flist_del(&r->list);
-		*b = r->off;
-		free(r);
-		return 0;
-	}
-
-	for (i = 0; i < td->o.verifysort_nr; i++) {
-		r = malloc(sizeof(*r));
-
-		ret = get_off_from_method(td, f, ddir, &r->off);
-		if (ret) {
-			free(r);
-			break;
-		}
-
-		flist_add(&r->list, &td->next_rand_list);
-	}
-
-	if (ret && !i)
-		return ret;
-
-	assert(!flist_empty(&td->next_rand_list));
-	flist_sort(NULL, &td->next_rand_list, flist_cmp);
-	goto fetch;
-}
-
 static void loop_cache_invalidate(struct thread_data *td, struct fio_file *f)
 {
 	struct thread_options *o = &td->o;
diff --git a/iolog.c b/iolog.c
index 3f0fc22..598548d 100644
--- a/iolog.c
+++ b/iolog.c
@@ -235,8 +235,7 @@ void log_io_piece(struct thread_data *td, struct io_u *io_u)
 	 * to check for duplicate blocks and drop the old one, which we rely on
 	 * the rb insert/lookup for handling.
 	 */
-	if (((!td->o.verifysort) || !td_random(td)) &&
-	      file_randommap(td, ipo->file)) {
+	if (file_randommap(td, ipo->file)) {
 		INIT_FLIST_HEAD(&ipo->list);
 		flist_add_tail(&ipo->list, &td->io_hist_list);
 		ipo->flags |= IP_F_ONLIST;
diff --git a/options.c b/options.c
index fb28511..1b3ea04 100644
--- a/options.c
+++ b/options.c
@@ -2846,25 +2846,14 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	{
 		.name	= "verifysort",
 		.lname	= "Verify sort",
-		.type	= FIO_OPT_BOOL,
-		.off1	= offsetof(struct thread_options, verifysort),
-		.help	= "Sort written verify blocks for read back",
-		.def	= "1",
-		.parent = "verify",
-		.hide	= 1,
+		.type	= FIO_OPT_SOFT_DEPRECATED,
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_VERIFY,
 	},
 	{
 		.name	= "verifysort_nr",
 		.lname	= "Verify Sort Nr",
-		.type	= FIO_OPT_INT,
-		.off1	= offsetof(struct thread_options, verifysort_nr),
-		.help	= "Pre-load and sort verify blocks for a read workload",
-		.minval	= 0,
-		.maxval	= 131072,
-		.def	= "1024",
-		.parent = "verify",
+		.type	= FIO_OPT_SOFT_DEPRECATED,
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_VERIFY,
 	},
diff --git a/parse.c b/parse.c
index 539c602..9685f1e 100644
--- a/parse.c
+++ b/parse.c
@@ -36,6 +36,7 @@ static const char *opt_type_names[] = {
 	"OPT_FLOAT_LIST",
 	"OPT_STR_SET",
 	"OPT_DEPRECATED",
+	"OPT_SOFT_DEPRECATED",
 	"OPT_UNSUPPORTED",
 };
 
@@ -876,8 +877,9 @@ static int __handle_option(const struct fio_option *o, const char *ptr,
 		break;
 	}
 	case FIO_OPT_DEPRECATED:
-		log_info("Option %s is deprecated\n", o->name);
 		ret = 1;
+	case FIO_OPT_SOFT_DEPRECATED:
+		log_info("Option %s is deprecated\n", o->name);
 		break;
 	default:
 		log_err("Bad option type %u\n", o->type);
@@ -1235,7 +1237,8 @@ int show_cmd_help(const struct fio_option *options, const char *name)
 	for (o = &options[0]; o->name; o++) {
 		int match = 0;
 
-		if (o->type == FIO_OPT_DEPRECATED)
+		if (o->type == FIO_OPT_DEPRECATED ||
+		    o->type == FIO_OPT_SOFT_DEPRECATED)
 			continue;
 		if (!exec_profile && o->prof_name)
 			continue;
@@ -1309,7 +1312,8 @@ void fill_default_options(void *data, const struct fio_option *options)
 
 static void option_init(struct fio_option *o)
 {
-	if (o->type == FIO_OPT_DEPRECATED || o->type == FIO_OPT_UNSUPPORTED)
+	if (o->type == FIO_OPT_DEPRECATED || o->type == FIO_OPT_UNSUPPORTED ||
+	    o->type == FIO_OPT_SOFT_DEPRECATED)
 		return;
 	if (o->name && !o->lname)
 		log_err("Option %s: missing long option name\n", o->name);
diff --git a/parse.h b/parse.h
index 4ad92d9..4de5e77 100644
--- a/parse.h
+++ b/parse.h
@@ -20,6 +20,7 @@ enum fio_opt_type {
 	FIO_OPT_FLOAT_LIST,
 	FIO_OPT_STR_SET,
 	FIO_OPT_DEPRECATED,
+	FIO_OPT_SOFT_DEPRECATED,
 	FIO_OPT_UNSUPPORTED,	/* keep this last */
 };
 
diff --git a/rate-submit.c b/rate-submit.c
index fdbece6..5c77a4e 100644
--- a/rate-submit.c
+++ b/rate-submit.c
@@ -115,7 +115,6 @@ static int io_workqueue_init_worker_fn(struct submit_worker *sw)
 	INIT_FLIST_HEAD(&td->io_hist_list);
 	INIT_FLIST_HEAD(&td->verify_list);
 	INIT_FLIST_HEAD(&td->trim_list);
-	INIT_FLIST_HEAD(&td->next_rand_list);
 	td->io_hist_tree = RB_ROOT;
 
 	td->o.iodepth = 1;
diff --git a/thread_options.h b/thread_options.h
index 944feaf..4ec570d 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -110,8 +110,6 @@ struct thread_options {
 	unsigned int write_hint;
 	unsigned int verify;
 	unsigned int do_verify;
-	unsigned int verifysort;
-	unsigned int verifysort_nr;
 	unsigned int verify_interval;
 	unsigned int verify_offset;
 	char verify_pattern[MAX_PATTERN_SIZE];
@@ -391,8 +389,6 @@ struct thread_options_pack {
 	uint32_t write_hint;
 	uint32_t verify;
 	uint32_t do_verify;
-	uint32_t verifysort;
-	uint32_t verifysort_nr;
 	uint32_t verify_interval;
 	uint32_t verify_offset;
 	uint8_t verify_pattern[MAX_PATTERN_SIZE];
diff --git a/verify.c b/verify.c
index c5fa241..40d484b 100644
--- a/verify.c
+++ b/verify.c
@@ -919,10 +919,9 @@ int verify_io_u(struct thread_data *td, struct io_u **io_u_ptr)
 		hdr = p;
 
 		/*
-		 * Make rand_seed check pass when have verifysort or
-		 * verify_backlog.
+		 * Make rand_seed check pass when have verify_backlog.
 		 */
-		if (td->o.verifysort || (td->flags & TD_F_VER_BACKLOG))
+		if (!td_rw(td) || (td->flags & TD_F_VER_BACKLOG))
 			io_u->rand_seed = hdr->rand_seed;
 
 		if (td->o.verify != VERIFY_PATTERN_NO_HDR) {
