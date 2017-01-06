Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:50606 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936767AbdAFNAE (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 6 Jan 2017 08:00:04 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cPU7n-0000ju-4D
        for fio@vger.kernel.org; Fri, 06 Jan 2017 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170106130002.341662C00B7@kernel.dk>
Date: Fri,  6 Jan 2017 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 847d544cce05157ec36f50b8214b26aff83aef01:

  Style cleanups for arm crc32c hw support (2017-01-04 19:44:35 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 8c4e634a44ca35a21387b79ae6e701f951e2cb0c:

  init: cleaner gcd() (2017-01-05 10:38:41 -0700)

----------------------------------------------------------------
Jens Axboe (5):
      verify: use log_verify_failure() for pattern verifies
      Remove '--runtime' command line option
      verify: ensure that verify_interval is always a factor of min/max bs
      verify: fill in vc->name for pattern verify
      init: cleaner gcd()

Tomohiro Kusumi (2):
      Fix invalid ioengine initialization for cpp_null
      Don't malloc ioengine_ops for cpp_null

 README         |  1 -
 engines/null.c | 28 +++++++++++++---------------
 init.c         | 47 +++++++++++++++++++++--------------------------
 io_u.c         |  4 ----
 verify.c       |  3 ++-
 5 files changed, 36 insertions(+), 47 deletions(-)

---

Diff of recent changes:

diff --git a/README b/README
index fdd5bec..875d2be 100644
--- a/README
+++ b/README
@@ -152,7 +152,6 @@ $ fio
 	--debug			Enable some debugging options (see below)
 	--parse-only		Parse options only, don't start any IO
 	--output		Write output to file
-	--runtime		Runtime in seconds
 	--bandwidth-log		Generate aggregate bandwidth logs
 	--minimal		Minimal (terse) output
 	--output-format=type	Output format (terse,json,json+,normal)
diff --git a/engines/null.c b/engines/null.c
index f7ba370..812cadf 100644
--- a/engines/null.c
+++ b/engines/null.c
@@ -135,23 +135,21 @@ static void fio_exit fio_null_unregister(void)
 
 #ifdef FIO_EXTERNAL_ENGINE
 extern "C" {
+static struct ioengine_ops ioengine;
 void get_ioengine(struct ioengine_ops **ioengine_ptr)
 {
-	struct ioengine_ops *ioengine;
-
-	*ioengine_ptr = (struct ioengine_ops *) malloc(sizeof(struct ioengine_ops));
-	ioengine = *ioengine_ptr;
-
-	strcpy(ioengine->name, "cpp_null");
-	ioengine->version        = FIO_IOOPS_VERSION;
-	ioengine->queue          = fio_null_queue;
-	ioengine->commit         = fio_null_commit;
-	ioengine->getevents      = fio_null_getevents;
-	ioengine->event          = fio_null_event;
-	ioengine->init           = fio_null_init;
-	ioengine->cleanup        = fio_null_cleanup;
-	ioengine->open_file      = fio_null_open;
-	ioengine->flags	         = FIO_DISKLESSIO | FIO_FAKEIO;
+	*ioengine_ptr = &ioengine;
+
+	ioengine.name           = "cpp_null";
+	ioengine.version        = FIO_IOOPS_VERSION;
+	ioengine.queue          = fio_null_queue;
+	ioengine.commit         = fio_null_commit;
+	ioengine.getevents      = fio_null_getevents;
+	ioengine.event          = fio_null_event;
+	ioengine.init           = fio_null_init;
+	ioengine.cleanup        = fio_null_cleanup;
+	ioengine.open_file      = fio_null_open;
+	ioengine.flags          = FIO_DISKLESSIO | FIO_FAKEIO;
 }
 }
 #endif /* FIO_EXTERNAL_ENGINE */
diff --git a/init.c b/init.c
index 9889949..ae20d61 100644
--- a/init.c
+++ b/init.c
@@ -40,7 +40,6 @@ const char fio_version_string[] = FIO_VERSION;
 static char **ini_file;
 static int max_jobs = FIO_MAX_JOBS;
 static int dump_cmdline;
-static long long def_timeout;
 static int parse_only;
 
 static struct thread_data def_thread;
@@ -94,11 +93,6 @@ static struct option l_opts[FIO_NR_OPTIONS] = {
 		.val		= 'o' | FIO_CLIENT_FLAG,
 	},
 	{
-		.name		= (char *) "runtime",
-		.has_arg	= required_argument,
-		.val		= 't' | FIO_CLIENT_FLAG,
-	},
-	{
 		.name		= (char *) "latency-log",
 		.has_arg	= required_argument,
 		.val		= 'l' | FIO_CLIENT_FLAG,
@@ -373,14 +367,6 @@ static int setup_thread_area(void)
 	return 0;
 }
 
-static void set_cmd_options(struct thread_data *td)
-{
-	struct thread_options *o = &td->o;
-
-	if (!o->timeout)
-		o->timeout = def_timeout;
-}
-
 static void dump_print_option(struct print_option *p)
 {
 	const char *delim;
@@ -451,10 +437,8 @@ static struct thread_data *get_new_job(int global, struct thread_data *parent,
 {
 	struct thread_data *td;
 
-	if (global) {
-		set_cmd_options(&def_thread);
+	if (global)
 		return &def_thread;
-	}
 	if (setup_thread_area()) {
 		log_err("error: failed to setup shm segment\n");
 		return NULL;
@@ -492,7 +476,6 @@ static struct thread_data *get_new_job(int global, struct thread_data *parent,
 	if (!parent->o.group_reporting || parent == &def_thread)
 		stat_number++;
 
-	set_cmd_options(td);
 	return td;
 }
 
@@ -582,6 +565,17 @@ static unsigned long long get_rand_start_delay(struct thread_data *td)
 }
 
 /*
+ * <3 Johannes
+ */
+static unsigned int gcd(unsigned int m, unsigned int n)
+{
+	if (!n)
+		return m;
+
+	return gcd(n, m % n);
+}
+
+/*
  * Lazy way of fixing up options that depend on each other. We could also
  * define option callback handlers, but this is easier.
  */
@@ -756,6 +750,15 @@ static int fixup_options(struct thread_data *td)
 			o->verify_interval = o->min_bs[DDIR_WRITE];
 		else if (td_read(td) && o->verify_interval > o->min_bs[DDIR_READ])
 			o->verify_interval = o->min_bs[DDIR_READ];
+
+		/*
+		 * Verify interval must be a factor or both min and max
+		 * write size
+		 */
+		if (o->verify_interval % o->min_bs[DDIR_WRITE] ||
+		    o->verify_interval % o->max_bs[DDIR_WRITE])
+			o->verify_interval = gcd(o->min_bs[DDIR_WRITE],
+							o->max_bs[DDIR_WRITE]);
 	}
 
 	if (o->pre_read) {
@@ -1997,7 +2000,6 @@ static void usage(const char *name)
 	show_debug_categories();
 	printf("  --parse-only\t\tParse options only, don't start any IO\n");
 	printf("  --output\t\tWrite output to file\n");
-	printf("  --runtime\t\tRuntime in seconds\n");
 	printf("  --bandwidth-log\tGenerate aggregate bandwidth logs\n");
 	printf("  --minimal\t\tMinimal (terse) output\n");
 	printf("  --output-format=type\tOutput format (terse,json,json+,normal)\n");
@@ -2313,13 +2315,6 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 			smalloc_pool_size <<= 10;
 			sinit();
 			break;
-		case 't':
-			if (check_str_time(optarg, &def_timeout, 1)) {
-				log_err("fio: failed parsing time %s\n", optarg);
-				do_exit++;
-				exit_val = 1;
-			}
-			break;
 		case 'l':
 			log_err("fio: --latency-log is deprecated. Use per-job latency log options.\n");
 			do_exit++;
diff --git a/io_u.c b/io_u.c
index 7420629..1daaf7b 100644
--- a/io_u.c
+++ b/io_u.c
@@ -576,10 +576,6 @@ static unsigned int __get_next_buflen(struct thread_data *td, struct io_u *io_u,
 			}
 		}
 
-		if (td->o.verify != VERIFY_NONE)
-			buflen = (buflen + td->o.verify_interval - 1) &
-				~(td->o.verify_interval - 1);
-
 		if (!td->o.bs_unaligned && is_power_of_2(minbs))
 			buflen &= ~(minbs - 1);
 
diff --git a/verify.c b/verify.c
index 8733feb..02cd3a4 100644
--- a/verify.c
+++ b/verify.c
@@ -393,7 +393,8 @@ static int verify_io_u_pattern(struct verify_header *hdr, struct vcont *vc)
 				(unsigned char)pattern[mod],
 				bits);
 			log_err("fio: bad pattern block offset %u\n", i);
-			dump_verify_buffers(hdr, vc);
+			vc->name = "pattern";
+			log_verify_failure(hdr, vc);
 			return EILSEQ;
 		}
 		mod++;
