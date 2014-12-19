Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54968 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbaLSNAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 19 Dec 2014 08:00:06 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Y1xA5-0001pb-EA
	for fio@vger.kernel.org; Fri, 19 Dec 2014 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141219130003.44C0240190@lyth.info>
Date: Fri, 19 Dec 2014 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 1d31d1bcffe0b282aaadca12dc83d2dd671b84f2:

  parse: remove the arithmetic parser checking (2014-12-17 13:27:32 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2243dfc796a8a6e137893a57a77949df7657dd71:

  options: add debug code for failure to lookup option names (2014-12-18 21:51:21 -0700)

----------------------------------------------------------------
Jens Axboe (4):
      t/btrace2fio: add ability to add specific options through -a
      Merge branch 'master' of ssh://git.kernel.dk/data/git/fio
      mutex: add __fio_mutex_remove()
      options: add debug code for failure to lookup option names

 filelock.c     |    5 +++--
 mutex.c        |    7 ++++++-
 mutex.h        |    1 +
 options.c      |    2 +-
 options.h      |   11 +++++++++--
 server.c       |    1 +
 t/btrace2fio.c |   15 ++++++++++++++-
 7 files changed, 35 insertions(+), 7 deletions(-)

---

Diff of recent changes:

diff --git a/filelock.c b/filelock.c
index b252a97..18e8875 100644
--- a/filelock.c
+++ b/filelock.c
@@ -144,10 +144,11 @@ void fio_unlock_file(const char *fname)
 
 	ff = fio_hash_find(hash);
 	if (ff) {
-		ff->references--;
+		int refs = --ff->references;
 		fio_mutex_up(&ff->lock);
-		if (!ff->references) {
+		if (!refs) {
 			flist_del(&ff->list);
+			__fio_mutex_remove(&ff->lock);
 			sfree(ff);
 		}
 	} else
diff --git a/mutex.c b/mutex.c
index 9ee3bd8..53f9651 100644
--- a/mutex.c
+++ b/mutex.c
@@ -18,10 +18,15 @@
 #include "fio_time.h"
 #include "gettime.h"
 
-void fio_mutex_remove(struct fio_mutex *mutex)
+void __fio_mutex_remove(struct fio_mutex *mutex)
 {
 	assert(mutex->magic == FIO_MUTEX_MAGIC);
 	pthread_cond_destroy(&mutex->cond);
+}
+
+void fio_mutex_remove(struct fio_mutex *mutex)
+{
+	__fio_mutex_remove(mutex);
 	munmap((void *) mutex, sizeof(*mutex));
 }
 
diff --git a/mutex.h b/mutex.h
index 246afee..17380de 100644
--- a/mutex.h
+++ b/mutex.h
@@ -26,6 +26,7 @@ enum {
 
 extern int __fio_mutex_init(struct fio_mutex *, int);
 extern struct fio_mutex *fio_mutex_init(int);
+extern void __fio_mutex_remove(struct fio_mutex *);
 extern void fio_mutex_remove(struct fio_mutex *);
 extern void fio_mutex_up(struct fio_mutex *);
 extern void fio_mutex_down(struct fio_mutex *);
diff --git a/options.c b/options.c
index 80a7047..6ceefbc 100644
--- a/options.c
+++ b/options.c
@@ -4206,7 +4206,7 @@ int __fio_option_is_set(struct thread_options *o, unsigned int off1)
 
 	if (!opt) {
 		log_err("fio: no option found at offset %u\n", off1);
-		return 0;
+		return -1;
 	}
 
 	opt_off = opt - &fio_options[0];
diff --git a/options.h b/options.h
index fa015c3..e830884 100644
--- a/options.h
+++ b/options.h
@@ -24,8 +24,15 @@ extern struct fio_option fio_options[FIO_MAX_OPTS];
 
 extern int __fio_option_is_set(struct thread_options *, unsigned int off);
 
-#define fio_option_is_set(__td, name)	\
-	__fio_option_is_set((__td), td_var_offset(name))
+#define fio_option_is_set(__td, name)					\
+({									\
+	int __r = __fio_option_is_set((__td), td_var_offset(name));	\
+	if (__r == -1) {						\
+		log_err("fio: wanted %s\n", __fio_stringify(name));	\
+		__r = 0;						\
+	}								\
+	__r;								\
+})
 
 extern void fio_option_mark_set(struct thread_options *, struct fio_option *);
 
diff --git a/server.c b/server.c
index ede291f..3171979 100644
--- a/server.c
+++ b/server.c
@@ -1431,6 +1431,7 @@ fail:
 	*datap = data;
 
 	sfree(rep->data);
+	__fio_mutex_remove(&rep->lock);
 	sfree(rep);
 	return 0;
 }
diff --git a/t/btrace2fio.c b/t/btrace2fio.c
index fc1e4c7..d0b7e09 100644
--- a/t/btrace2fio.c
+++ b/t/btrace2fio.c
@@ -24,6 +24,9 @@ static unsigned int max_depth = 256;
 static int output_ascii = 1;
 static char *filename;
 
+static char **add_opts;
+static int n_add_opts;
+
 /*
  * Collapse defaults
  */
@@ -752,6 +755,10 @@ static int __output_p_fio(struct btrace_pid *p, unsigned long *ios)
 		printf("\n");
 	}
 
+	if (n_add_opts)
+		for (i = 0; i < n_add_opts; i++)
+			printf("%s\n", add_opts[i]);
+
 	printf("\n");
 	return 0;
 }
@@ -1020,6 +1027,7 @@ static int usage(char *argv[])
 	log_err("\t-c\tCollapse \"identical\" jobs (def=%u)\n", collapse_entries);
 	log_err("\t-u\tDepth difference for collapse (def=%u)\n", depth_diff);
 	log_err("\t-x\tRandom difference for collapse (def=%u)\n", random_diff);
+	log_err("\t-a\tAdditional fio option to add to job file\n");
 	return 1;
 }
 
@@ -1075,7 +1083,7 @@ int main(int argc, char *argv[])
 	if (argc < 2)
 		return usage(argv);
 
-	while ((c = getopt(argc, argv, "t:n:fd:r:RD:c:u:x:")) != -1) {
+	while ((c = getopt(argc, argv, "t:n:fd:r:RD:c:u:x:a:")) != -1) {
 		switch (c) {
 		case 'R':
 			set_rate = 1;
@@ -1107,6 +1115,11 @@ int main(int argc, char *argv[])
 		case 'x':
 			random_diff = atoi(optarg);
 			break;
+		case 'a':
+			add_opts = realloc(add_opts, (n_add_opts + 1) * sizeof(char *));
+			add_opts[n_add_opts] = strdup(optarg);
+			n_add_opts++;
+			break;
 		case '?':
 		default:
 			return usage(argv);
