Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:36812 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaBLNAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 12 Feb 2014 08:00:06 -0500
Received: from kernel.dk ([54.225.238.116] helo=strynoevaenget.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WDZQ5-0001zi-2Y
	for fio@vger.kernel.org; Wed, 12 Feb 2014 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140212130004.07AD645939@strynoevaenget.dk>
Date: Wed, 12 Feb 2014 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit ea66e04fe1a803f6a9ddf31cb999641d4396d67c:

  Fix issue with td->mutex being used-after-free (2014-02-10 13:57:09 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f0fdbcafc3a62b84250e5ccdcaec47e3ffa93a00:

  parse: cleanup difference between profile and normal options (2014-02-11 15:44:50 -0700)

----------------------------------------------------------------
Jens Axboe (6):
      Fix issue with openfiles= and file sizing
      Enfore that lockfile= must precede filename=
      Plug a free basic memory leaks
      parse: get rid of raw option offsets
      Fio 2.1.5
      parse: cleanup difference between profile and normal options

 FIO-VERSION-GEN        |    2 +-
 backend.c              |   20 ++++++-
 cconv.c                |   25 +++++++++
 err.h                  |   44 +++++++++++++++
 file.h                 |    1 +
 filesetup.c            |   45 +++++++++++++--
 goptions.c             |   68 +++++++++++-----------
 init.c                 |    1 +
 io_u.c                 |   25 +++++++--
 options.c              |   21 ++++++-
 os/windows/install.wxs |    2 +-
 parse.c                |  146 +++++++++++++++---------------------------------
 parse.h                |   14 ++++-
 profile.c              |    1 +
 profile.h              |    1 +
 profiles/act.c         |   28 +++++++---
 profiles/tiobench.c    |   23 ++++++--
 17 files changed, 305 insertions(+), 162 deletions(-)
 create mode 100644 err.h

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 39e34b5..63ed948 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-2.1.4
+DEF_VER=fio-2.1.5
 
 LF='
 '
diff --git a/backend.c b/backend.c
index a607134..32bc265 100644
--- a/backend.c
+++ b/backend.c
@@ -52,6 +52,7 @@
 #include "server.h"
 #include "lib/getrusage.h"
 #include "idletime.h"
+#include "err.h"
 
 static pthread_t disk_util_thread;
 static struct fio_mutex *disk_thread_mutex;
@@ -478,6 +479,12 @@ static void do_verify(struct thread_data *td, uint64_t verify_bytes)
 				break;
 
 			while ((io_u = get_io_u(td)) != NULL) {
+				if (IS_ERR(io_u)) {
+					io_u = NULL;
+					ret = FIO_Q_BUSY;
+					goto reap;
+				}
+
 				/*
 				 * We are only interested in the places where
 				 * we wrote or trimmed IOs. Turn those into
@@ -574,6 +581,7 @@ sync_done:
 		 * completed io_u's first. Note that we can get BUSY even
 		 * without IO queued, if the system is resource starved.
 		 */
+reap:
 		full = queue_full(td) || (ret == FIO_Q_BUSY && td->cur_depth);
 		if (full || !td->o.iodepth_batch_complete) {
 			min_events = min(td->o.iodepth_batch_complete,
@@ -692,7 +700,14 @@ static uint64_t do_io(struct thread_data *td)
 			break;
 
 		io_u = get_io_u(td);
-		if (!io_u) {
+		if (IS_ERR_OR_NULL(io_u)) {
+			int err = PTR_ERR(io_u);
+
+			io_u = NULL;
+			if (err == -EBUSY) {
+				ret = FIO_Q_BUSY;
+				goto reap;
+			}
 			if (td->o.latency_target)
 				goto reap;
 			break;
@@ -1124,6 +1139,9 @@ static int keep_running(struct thread_data *td)
 		if (diff < td_max_bs(td))
 			return 0;
 
+		if (fio_files_done(td))
+			return 0;
+
 		return 1;
 	}
 
diff --git a/cconv.c b/cconv.c
index 0d30f07..b7d469e 100644
--- a/cconv.c
+++ b/cconv.c
@@ -18,6 +18,29 @@ static void string_to_net(uint8_t *dst, const char *src)
 		dst[0] = '\0';
 }
 
+void free_thread_options_to_cpu(struct thread_options *o)
+{
+	free(o->description);
+	free(o->name);
+	free(o->directory);
+	free(o->filename);
+	free(o->filename_format);
+	free(o->opendir);
+	free(o->ioengine);
+	free(o->mmapfile);
+	free(o->read_iolog_file);
+	free(o->write_iolog_file);
+	free(o->bw_log_file);
+	free(o->lat_log_file);
+	free(o->iops_log_file);
+	free(o->replay_redirect);
+	free(o->exec_prerun);
+	free(o->exec_postrun);
+	free(o->ioscheduler);
+	free(o->profile);
+	free(o->cgroup);
+}
+
 void convert_thread_options_to_cpu(struct thread_options *o,
 				   struct thread_options_pack *top)
 {
@@ -438,5 +461,7 @@ int fio_test_cconv(struct thread_options *__o)
 	convert_thread_options_to_cpu(&o, &top1);
 	convert_thread_options_to_net(&top2, &o);
 
+	free_thread_options_to_cpu(&o);
+
 	return memcmp(&top1, &top2, sizeof(top1));
 }
diff --git a/err.h b/err.h
new file mode 100644
index 0000000..5c024ee
--- /dev/null
+++ b/err.h
@@ -0,0 +1,44 @@
+#ifndef FIO_ERR_H
+#define FIO_ERR_H
+
+/*
+ * Kernel pointers have redundant information, so we can use a
+ * scheme where we can return either an error code or a dentry
+ * pointer with the same return value.
+ *
+ * This should be a per-architecture thing, to allow different
+ * error and pointer decisions.
+ */
+#define MAX_ERRNO	4095
+
+#define IS_ERR_VALUE(x) ((x) >= (unsigned long)-MAX_ERRNO)
+
+static inline void *ERR_PTR(long error)
+{
+	return (void *) error;
+}
+
+static inline long PTR_ERR(const void *ptr)
+{
+	return (long) ptr;
+}
+
+static inline long IS_ERR(const void *ptr)
+{
+	return IS_ERR_VALUE((unsigned long)ptr);
+}
+
+static inline long IS_ERR_OR_NULL(const void *ptr)
+{
+	return !ptr || IS_ERR_VALUE((unsigned long)ptr);
+}
+
+static inline int PTR_ERR_OR_ZERO(const void *ptr)
+{
+	if (IS_ERR(ptr))
+		return PTR_ERR(ptr);
+	else
+		return 0;
+}
+
+#endif
diff --git a/file.h b/file.h
index d7e05f4..19413fc 100644
--- a/file.h
+++ b/file.h
@@ -176,5 +176,6 @@ extern void dup_files(struct thread_data *, struct thread_data *);
 extern int get_fileno(struct thread_data *, const char *);
 extern void free_release_files(struct thread_data *);
 void fio_file_reset(struct thread_data *, struct fio_file *);
+int fio_files_done(struct thread_data *);
 
 #endif
diff --git a/filesetup.c b/filesetup.c
index d1702e2..544ecb1 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -734,9 +734,11 @@ int setup_files(struct thread_data *td)
 	unsigned long long total_size, extend_size;
 	struct thread_options *o = &td->o;
 	struct fio_file *f;
-	unsigned int i;
+	unsigned int i, nr_fs_extra = 0;
 	int err = 0, need_extend;
 	int old_state;
+	const unsigned int bs = td_min_bs(td);
+	uint64_t fs = 0;
 
 	dprint(FD_FILE, "setup files\n");
 
@@ -786,6 +788,20 @@ int setup_files(struct thread_data *td)
 	}
 
 	/*
+	 * Calculate per-file size and potential extra size for the
+	 * first files, if needed.
+	 */
+	if (!o->file_size_low) {
+		uint64_t all_fs;
+
+		fs = o->size / o->nr_files;
+		all_fs = fs * o->nr_files;
+
+		if (all_fs < o->size)
+			nr_fs_extra = (o->size - all_fs) / bs;
+	}
+
+	/*
 	 * now file sizes are known, so we can set ->io_size. if size= is
 	 * not given, ->io_size is just equal to ->real_file_size. if size
 	 * is given, ->io_size is size / nr_files.
@@ -798,10 +814,17 @@ int setup_files(struct thread_data *td)
 		if (!o->file_size_low) {
 			/*
 			 * no file size range given, file size is equal to
-			 * total size divided by number of files. if that is
-			 * zero, set it to the real file size.
+			 * total size divided by number of files. If that is
+			 * zero, set it to the real file size. If the size
+			 * doesn't divide nicely with the min blocksize,
+			 * make the first files bigger.
 			 */
-			f->io_size = o->size / o->nr_files;
+			f->io_size = fs;
+			if (nr_fs_extra) {
+				nr_fs_extra--;
+				f->io_size += bs;
+			}
+
 			if (!f->io_size)
 				f->io_size = f->real_file_size - f->file_offset;
 		} else if (f->real_file_size < o->file_size_low ||
@@ -1243,7 +1266,7 @@ void unlock_file(struct thread_data *td, struct fio_file *f)
 
 void unlock_file_all(struct thread_data *td, struct fio_file *f)
 {
-	if (td->o.file_lock_mode == FILE_LOCK_NONE)
+	if (td->o.file_lock_mode == FILE_LOCK_NONE || !td->file_locks)
 		return;
 	if (td->file_locks[f->fileno] != FILE_LOCK_NONE)
 		unlock_file(td, f);
@@ -1386,3 +1409,15 @@ void fio_file_reset(struct thread_data *td, struct fio_file *f)
 	if (td->o.random_generator == FIO_RAND_GEN_LFSR)
 		lfsr_reset(&f->lfsr, td->rand_seeds[FIO_RAND_BLOCK_OFF]);
 }
+
+int fio_files_done(struct thread_data *td)
+{
+	struct fio_file *f;
+	unsigned int i;
+
+	for_each_file(td, f, i)
+		if (!fio_file_done(f))
+			return 0;
+
+	return 1;
+}
diff --git a/goptions.c b/goptions.c
index 08b17ac..21d6427 100644
--- a/goptions.c
+++ b/goptions.c
@@ -874,7 +874,7 @@ static void gopt_set_option(struct gopt_job_view *gjv, struct fio_option *o,
 		struct gopt_str_val *g;
 
 		if (o->off1)
-			ullp = td_var(to, o->off1);
+			ullp = td_var(to, o, o->off1);
 
 		g = container_of(gopt, struct gopt_str_val, gopt);
 		if (ullp)
@@ -886,7 +886,7 @@ static void gopt_set_option(struct gopt_job_view *gjv, struct fio_option *o,
 		struct gopt_int *i;
 
 		if (o->off1)
-			ullp = td_var(to, o->off1);
+			ullp = td_var(to, o, o->off1);
 
 		i = container_of(gopt, struct gopt_int, gopt);
 		if (ullp)
@@ -899,7 +899,7 @@ static void gopt_set_option(struct gopt_job_view *gjv, struct fio_option *o,
 			struct gopt_combo *c;
 
 			if (o->off1)
-				ip = td_var(to, o->off1);
+				ip = td_var(to, o, o->off1);
 
 			c = container_of(gopt, struct gopt_combo, gopt);
 			if (ip)
@@ -909,7 +909,7 @@ static void gopt_set_option(struct gopt_job_view *gjv, struct fio_option *o,
 			struct gopt_int *i;
 
 			if (o->off1)
-				ip = td_var(to, o->off1);
+				ip = td_var(to, o, o->off1);
 
 			i = container_of(gopt, struct gopt_int, gopt);
 			if (ip)
@@ -922,7 +922,7 @@ static void gopt_set_option(struct gopt_job_view *gjv, struct fio_option *o,
 		struct gopt_bool *b;
 
 		if (o->off1)
-			ip = td_var(to, o->off1);
+			ip = td_var(to, o, o->off1);
 
 		b = container_of(gopt, struct gopt_bool, gopt);
 		if (ip)
@@ -935,7 +935,7 @@ static void gopt_set_option(struct gopt_job_view *gjv, struct fio_option *o,
 			struct gopt_combo *c;
 
 			if (o->off1)
-				ip = td_var(to, o->off1);
+				ip = td_var(to, o, o->off1);
 
 			c = container_of(gopt, struct gopt_combo, gopt);
 			if (ip)
@@ -945,7 +945,7 @@ static void gopt_set_option(struct gopt_job_view *gjv, struct fio_option *o,
 			char *text = NULL;
 
 			if (o->off1) {
-				char **p = td_var(to, o->off1);
+				char **p = td_var(to, o, o->off1);
 
 				text = *p;
 			}
@@ -961,7 +961,7 @@ static void gopt_set_option(struct gopt_job_view *gjv, struct fio_option *o,
 		char *text = NULL;
 
 		if (o->off1) {
-			char **p = td_var(to, o->off1);
+			char **p = td_var(to, o, o->off1);
 			text = *p;
 		}
 
@@ -983,10 +983,10 @@ static void gopt_set_option(struct gopt_job_view *gjv, struct fio_option *o,
 		break;
 	case FIO_OPT_RANGE: {
 		struct gopt_range *r;
-		unsigned int *ip[4] = { td_var(to, o->off1),
-					td_var(to, o->off2),
-					td_var(to, o->off3),
-					td_var(to, o->off4) };
+		unsigned int *ip[4] = { td_var(to, o, o->off1),
+					td_var(to, o, o->off2),
+					td_var(to, o, o->off3),
+					td_var(to, o, o->off4) };
 
 		r = container_of(gopt, struct gopt_range, gopt);
 		gopt_int_range_set_val(r, *ip);
@@ -1014,7 +1014,7 @@ static void gopt_add_option(struct gopt_job_view *gjv, GtkWidget *hbox,
 		unsigned long long *ullp = NULL;
 
 		if (o->off1)
-			ullp = td_var(to, o->off1);
+			ullp = td_var(to, o, o->off1);
 
 		go = gopt_new_str_val(gjv, o, ullp, opt_index);
 		break;
@@ -1023,7 +1023,7 @@ static void gopt_add_option(struct gopt_job_view *gjv, GtkWidget *hbox,
 		unsigned long long *ullp = NULL;
 
 		if (o->off1)
-			ullp = td_var(to, o->off1);
+			ullp = td_var(to, o, o->off1);
 
 		go = gopt_new_ullong(gjv, o, ullp, opt_index);
 		break;
@@ -1033,14 +1033,14 @@ static void gopt_add_option(struct gopt_job_view *gjv, GtkWidget *hbox,
 			unsigned int *ip = NULL;
 
 			if (o->off1)
-				ip = td_var(to, o->off1);
+				ip = td_var(to, o, o->off1);
 
 			go = gopt_new_combo_int(gjv, o, ip, opt_index);
 		} else {
 			unsigned int *ip = NULL;
 
 			if (o->off1)
-				ip = td_var(to, o->off1);
+				ip = td_var(to, o, o->off1);
 
 			go = gopt_new_int(gjv, o, ip, opt_index);
 		}
@@ -1050,7 +1050,7 @@ static void gopt_add_option(struct gopt_job_view *gjv, GtkWidget *hbox,
 		unsigned int *ip = NULL;
 
 		if (o->off1)
-			ip = td_var(to, o->off1);
+			ip = td_var(to, o, o->off1);
 
 		go = gopt_new_bool(gjv, o, ip, opt_index);
 		break;
@@ -1060,7 +1060,7 @@ static void gopt_add_option(struct gopt_job_view *gjv, GtkWidget *hbox,
 			unsigned int *ip = NULL;
 
 			if (o->off1)
-				ip = td_var(to, o->off1);
+				ip = td_var(to, o, o->off1);
 
 			go = gopt_new_combo_int(gjv, o, ip, opt_index);
 		} else {
@@ -1074,7 +1074,7 @@ static void gopt_add_option(struct gopt_job_view *gjv, GtkWidget *hbox,
 		char *text = NULL;
 
 		if (o->off1) {
-			char **p = td_var(to, o->off1);
+			char **p = td_var(to, o, o->off1);
 			text = *p;
 		}
 
@@ -1090,10 +1090,10 @@ static void gopt_add_option(struct gopt_job_view *gjv, GtkWidget *hbox,
 		go = gopt_new_str_multi(gjv, o, opt_index);
 		break;
 	case FIO_OPT_RANGE: {
-		unsigned int *ip[4] = { td_var(to, o->off1),
-					td_var(to, o->off2),
-					td_var(to, o->off3),
-					td_var(to, o->off4) };
+		unsigned int *ip[4] = { td_var(to, o, o->off1),
+					td_var(to, o, o->off2),
+					td_var(to, o, o->off3),
+					td_var(to, o, o->off4) };
 
 		go = gopt_new_int_range(gjv, o, ip, opt_index);
 		break;
@@ -1203,7 +1203,7 @@ static void gopt_handle_str_multi_changed(struct gopt_job_view *gjv,
 					  struct gopt_str_multi *m,
 					  struct fio_option *o)
 {
-	unsigned int *ip = td_var(gjv->o, o->off1);
+	unsigned int *ip = td_var(gjv->o, o, o->off1);
 	struct value_pair *vp;
 	gboolean set;
 	guint val = 0;
@@ -1233,10 +1233,10 @@ static void gopt_handle_range_changed(struct gopt_job_view *gjv,
 				      struct gopt_range *r,
 				      struct fio_option *o)
 {
-	unsigned int *ip[4] = { td_var(gjv->o, o->off1),
-				td_var(gjv->o, o->off2),
-				td_var(gjv->o, o->off3),
-				td_var(gjv->o, o->off4) };
+	unsigned int *ip[4] = { td_var(gjv->o, o, o->off1),
+				td_var(gjv->o, o, o->off2),
+				td_var(gjv->o, o, o->off3),
+				td_var(gjv->o, o, o->off4) };
 	gint val;
 	int i;
 
@@ -1250,7 +1250,7 @@ static void gopt_handle_str_val_changed(struct gopt_job_view *gjv,
 					struct gopt_str_val *s,
 					struct fio_option *o)
 {
-	unsigned long long *ullp = td_var(gjv->o, o->off1);
+	unsigned long long *ullp = td_var(gjv->o, o, o->off1);
 	GtkAdjustment *adj;
 	gint index;
 
@@ -1274,7 +1274,7 @@ static void gopt_handle_str_val_changed(struct gopt_job_view *gjv,
 static void gopt_handle_str_changed(struct gopt_job_view *gjv,
 				    struct gopt_str *s, struct fio_option *o)
 {
-	char **p = td_var(gjv->o, o->off1);
+	char **p = td_var(gjv->o, o, o->off1);
 
 	if (*p)
 		free(*p);
@@ -1285,7 +1285,7 @@ static void gopt_handle_str_changed(struct gopt_job_view *gjv,
 static void gopt_handle_bool_changed(struct gopt_job_view *gjv,
 				     struct gopt_bool *b, struct fio_option *o)
 {
-	unsigned int *ip = td_var(gjv->o, o->off1);
+	unsigned int *ip = td_var(gjv->o, o, o->off1);
 	gboolean set;
 
 	set = gtk_toggle_button_get_active(GTK_TOGGLE_BUTTON(b->check));
@@ -1295,7 +1295,7 @@ static void gopt_handle_bool_changed(struct gopt_job_view *gjv,
 static void gopt_handle_int_changed(struct gopt_job_view *gjv,
 				    struct gopt_int *i, struct fio_option *o)
 {
-	unsigned int *ip = td_var(gjv->o, o->off1);
+	unsigned int *ip = td_var(gjv->o, o, o->off1);
 	GtkAdjustment *adj;
 	guint val;
 
@@ -1308,7 +1308,7 @@ static void gopt_handle_combo_str_changed(struct gopt_job_view *gjv,
 					  struct gopt_combo *c,
 					  struct fio_option *o)
 {
-	char **p = td_var(gjv->o, o->off1);
+	char **p = td_var(gjv->o, o, o->off1);
 
 	if (*p)
 		free(*p);
@@ -1320,7 +1320,7 @@ static void gopt_handle_combo_int_changed(struct gopt_job_view *gjv,
 					  struct gopt_combo *c,
 					  struct fio_option *o)
 {
-	unsigned int *ip = td_var(gjv->o, o->off1);
+	unsigned int *ip = td_var(gjv->o, o, o->off1);
 	gint index;
 
 	index = gtk_combo_box_get_active(GTK_COMBO_BOX(c->combo));
diff --git a/init.c b/init.c
index b26dc9f..fa1df8e 100644
--- a/init.c
+++ b/init.c
@@ -250,6 +250,7 @@ void free_shm(void)
 		free_threads_shm();
 	}
 
+	options_free(fio_options, &def_thread);
 	scleanup();
 }
 
diff --git a/io_u.c b/io_u.c
index 64ff73c..acc1a7b 100644
--- a/io_u.c
+++ b/io_u.c
@@ -11,6 +11,7 @@
 #include "trim.h"
 #include "lib/rand.h"
 #include "lib/axmap.h"
+#include "err.h"
 
 struct io_completion_data {
 	int nr;				/* input */
@@ -985,6 +986,9 @@ static struct fio_file *get_next_file_rand(struct thread_data *td,
 		if (!fio_file_open(f)) {
 			int err;
 
+			if (td->nr_open_files >= td->o.open_files)
+				return ERR_PTR(-EBUSY);
+
 			err = td_io_open_file(td, f);
 			if (err)
 				continue;
@@ -1027,6 +1031,9 @@ static struct fio_file *get_next_file_rr(struct thread_data *td, int goodf,
 		if (!fio_file_open(f)) {
 			int err;
 
+			if (td->nr_open_files >= td->o.open_files)
+				return ERR_PTR(-EBUSY);
+
 			err = td_io_open_file(td, f);
 			if (err) {
 				dprint(FD_FILE, "error %d on open of %s\n",
@@ -1080,6 +1087,9 @@ static struct fio_file *__get_next_file(struct thread_data *td)
 	else
 		f = get_next_file_rand(td, FIO_FILE_open, FIO_FILE_closing);
 
+	if (IS_ERR(f))
+		return f;
+
 	td->file_service_file = f;
 	td->file_service_left = td->file_service_nr - 1;
 out:
@@ -1099,14 +1109,14 @@ static struct fio_file *get_next_file(struct thread_data *td)
 	return __get_next_file(td);
 }
 
-static int set_io_u_file(struct thread_data *td, struct io_u *io_u)
+static long set_io_u_file(struct thread_data *td, struct io_u *io_u)
 {
 	struct fio_file *f;
 
 	do {
 		f = get_next_file(td);
-		if (!f)
-			return 1;
+		if (IS_ERR_OR_NULL(f))
+			return PTR_ERR(f);
 
 		io_u->file = f;
 		get_file(f);
@@ -1400,6 +1410,7 @@ struct io_u *get_io_u(struct thread_data *td)
 	struct fio_file *f;
 	struct io_u *io_u;
 	int do_scramble = 0;
+	long ret = 0;
 
 	io_u = __get_io_u(td);
 	if (!io_u) {
@@ -1425,11 +1436,17 @@ struct io_u *get_io_u(struct thread_data *td)
 		if (read_iolog_get(td, io_u))
 			goto err_put;
 	} else if (set_io_u_file(td, io_u)) {
+		ret = -EBUSY;
 		dprint(FD_IO, "io_u %p, setting file failed\n", io_u);
 		goto err_put;
 	}
 
 	f = io_u->file;
+	if (!f) {
+		dprint(FD_IO, "io_u %p, setting file failed\n", io_u);
+		goto err_put;
+	}
+
 	assert(fio_file_open(f));
 
 	if (ddir_rw(io_u->ddir)) {
@@ -1478,7 +1495,7 @@ out:
 err_put:
 	dprint(FD_IO, "get_io_u failed\n");
 	put_io_u(td, io_u);
-	return NULL;
+	return ERR_PTR(ret);
 }
 
 void io_u_log_error(struct thread_data *td, struct io_u *io_u)
diff --git a/options.c b/options.c
index 57e9af5..9f6bc8d 100644
--- a/options.c
+++ b/options.c
@@ -821,6 +821,18 @@ static int str_directory_cb(void *data, const char fio_unused *str)
 	return 0;
 }
 
+static int str_lockfile_cb(void *data, const char fio_unused *str)
+{
+	struct thread_data *td = data;
+
+	if (td->files_index) {
+		log_err("fio: lockfile= option must precede filename=\n");
+		return 1;
+	}
+
+	return 0;
+}
+
 static int str_opendir_cb(void *data, const char fio_unused *str)
 {
 	struct thread_data *td = data;
@@ -1231,6 +1243,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.parent	= "filename",
 		.hide	= 0,
 		.def	= "none",
+		.cb	= str_lockfile_cb,
 		.category = FIO_OPT_C_FILE,
 		.group	= FIO_OPT_G_FILENAME,
 		.posval = {
@@ -3727,7 +3740,7 @@ void options_mem_dupe(void *data, struct fio_option *options)
 		if (o->type != FIO_OPT_STR_STORE)
 			continue;
 
-		ptr = td_var(data, o->off1);
+		ptr = td_var(data, o, o->off1);
 		if (*ptr)
 			*ptr = strdup(*ptr);
 	}
@@ -3773,7 +3786,13 @@ int add_option(struct fio_option *o)
 		__o++;
 	}
 
+	if (opt_index + 1 == FIO_MAX_OPTS) {
+		log_err("fio: FIO_MAX_OPTS is too small\n");
+		return 1;
+	}
+
 	memcpy(&fio_options[opt_index], o, sizeof(*o));
+	fio_options[opt_index + 1].name = NULL;
 	return 0;
 }
 
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index 599fe39..fd38041 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -10,7 +10,7 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.1.4">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.1.5">
 		<Package
 		  Description="Flexible IO Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
diff --git a/parse.c b/parse.c
index 6141c91..6121dfc 100644
--- a/parse.c
+++ b/parse.c
@@ -368,9 +368,9 @@ static int str_match_len(const struct value_pair *vp, const char *str)
 	return max(strlen(vp->ival), opt_len(str));
 }
 
-#define val_store(ptr, val, off, or, data)		\
+#define val_store(ptr, val, off, or, data, o)		\
 	do {						\
-		ptr = td_var((data), (off));		\
+		ptr = td_var((data), (o), (off));	\
 		if ((or))				\
 			*ptr |= (val);			\
 		else					\
@@ -414,16 +414,8 @@ static int __handle_option(struct fio_option *o, const char *ptr, void *data,
 			all_skipped = 0;
 			if (!strncmp(vp->ival, ptr, str_match_len(vp, ptr))) {
 				ret = 0;
-				if (o->roff1) {
-					if (vp->or)
-						*(unsigned int *) o->roff1 |= vp->oval;
-					else
-						*(unsigned int *) o->roff1 = vp->oval;
-				} else {
-					if (!o->off1)
-						continue;
-					val_store(ilp, vp->oval, o->off1, vp->or, data);
-				}
+				if (o->off1)
+					val_store(ilp, vp->oval, o->off1, vp->or, data, o);
 				continue;
 			}
 		}
@@ -490,50 +482,32 @@ static int __handle_option(struct fio_option *o, const char *ptr, void *data,
 			ret = fn(data, &ull);
 		else {
 			if (o->type == FIO_OPT_INT) {
-				if (first) {
-					if (o->roff1)
-						*(unsigned int *) o->roff1 = ull;
-					else
-						val_store(ilp, ull, o->off1, 0, data);
-				}
+				if (first)
+					val_store(ilp, ull, o->off1, 0, data, o);
 				if (curr == 1) {
-					if (o->roff2)
-						*(unsigned int *) o->roff2 = ull;
-					else if (o->off2)
-						val_store(ilp, ull, o->off2, 0, data);
+					if (o->off2)
+						val_store(ilp, ull, o->off2, 0, data, o);
 				}
 				if (curr == 2) {
-					if (o->roff3)
-						*(unsigned int *) o->roff3 = ull;
-					else if (o->off3)
-						val_store(ilp, ull, o->off3, 0, data);
+					if (o->off3)
+						val_store(ilp, ull, o->off3, 0, data, o);
 				}
 				if (!more) {
 					if (curr < 1) {
-						if (o->roff2)
-							*(unsigned int *) o->roff2 = ull;
-						else if (o->off2)
-							val_store(ilp, ull, o->off2, 0, data);
+						if (o->off2)
+							val_store(ilp, ull, o->off2, 0, data, o);
 					}
 					if (curr < 2) {
-						if (o->roff3)
-							*(unsigned int *) o->roff3 = ull;
-						else if (o->off3)
-							val_store(ilp, ull, o->off3, 0, data);
+						if (o->off3)
+							val_store(ilp, ull, o->off3, 0, data, o);
 					}
 				}
 			} else {
-				if (first) {
-					if (o->roff1)
-						*(unsigned long long *) o->roff1 = ull;
-					else
-						val_store(ullp, ull, o->off1, 0, data);
-				}
+				if (first)
+					val_store(ullp, ull, o->off1, 0, data, o);
 				if (!more) {
-					if (o->roff2)
-						*(unsigned long long *) o->roff2 =  ull;
-					else if (o->off2)
-						val_store(ullp, ull, o->off2, 0, data);
+					if (o->off2)
+						val_store(ullp, ull, o->off2, 0, data, o);
 				}
 			}
 		}
@@ -549,11 +523,11 @@ static int __handle_option(struct fio_option *o, const char *ptr, void *data,
 			*/
 			if (o->off2) {
 				ul2 = 0;
-				ilp = td_var(data, o->off2);
+				ilp = td_var(data, o, o->off2);
 				*ilp = ul2;
 			}
 
-			flp = td_var(data, o->off1);
+			flp = td_var(data, o, o->off1);
 			for(i = 0; i < o->maxlen; i++)
 				flp[i].u.f = 0.0;
 		}
@@ -577,7 +551,7 @@ static int __handle_option(struct fio_option *o, const char *ptr, void *data,
 			return 1;
 		}
 
-		flp = td_var(data, o->off1);
+		flp = td_var(data, o, o->off1);
 		flp[curr].u.f = uf;
 
 		dprint(FD_PARSE, "  out=%f\n", uf);
@@ -595,7 +569,7 @@ static int __handle_option(struct fio_option *o, const char *ptr, void *data,
 				len++;
 
 			if (o->off2) {
-				ilp = td_var(data, o->off2);
+				ilp = td_var(data, o, o->off2);
 				if (len > *ilp)
 					*ilp = len;
 			}
@@ -606,12 +580,8 @@ static int __handle_option(struct fio_option *o, const char *ptr, void *data,
 	case FIO_OPT_STR_STORE: {
 		fio_opt_str_fn *fn = o->cb;
 
-		if (o->roff1 || o->off1) {
-			if (o->roff1)
-				cp = (char **) o->roff1;
-			else if (o->off1)
-				cp = td_var(data, o->off1);
-
+		if (o->off1) {
+			cp = td_var(data, o, o->off1);
 			*cp = strdup(ptr);
 		}
 
@@ -691,50 +661,32 @@ static int __handle_option(struct fio_option *o, const char *ptr, void *data,
 			}
 
 			if (first) {
-				if (o->roff1)
-					*(unsigned int *) o->roff1 = ul1;
-				else
-					val_store(ilp, ul1, o->off1, 0, data);
-				if (o->roff2)
-					*(unsigned int *) o->roff2 = ul2;
-				else
-					val_store(ilp, ul2, o->off2, 0, data);
+				val_store(ilp, ul1, o->off1, 0, data, o);
+				val_store(ilp, ul2, o->off2, 0, data, o);
 			}
 			if (curr == 1) {
-				if (o->roff3 && o->roff4) {
-					*(unsigned int *) o->roff3 = ul1;
-					*(unsigned int *) o->roff4 = ul2;
-				} else if (o->off3 && o->off4) {
-					val_store(ilp, ul1, o->off3, 0, data);
-					val_store(ilp, ul2, o->off4, 0, data);
+				if (o->off3 && o->off4) {
+					val_store(ilp, ul1, o->off3, 0, data, o);
+					val_store(ilp, ul2, o->off4, 0, data, o);
 				}
 			}
 			if (curr == 2) {
-				if (o->roff5 && o->roff6) {
-					*(unsigned int *) o->roff5 = ul1;
-					*(unsigned int *) o->roff6 = ul2;
-				} else if (o->off5 && o->off6) {
-					val_store(ilp, ul1, o->off5, 0, data);
-					val_store(ilp, ul2, o->off6, 0, data);
+				if (o->off5 && o->off6) {
+					val_store(ilp, ul1, o->off5, 0, data, o);
+					val_store(ilp, ul2, o->off6, 0, data, o);
 				}
 			}
 			if (!more) {
 				if (curr < 1) {
-					if (o->roff3 && o->roff4) {
-						*(unsigned int *) o->roff3 = ul1;
-						*(unsigned int *) o->roff4 = ul2;
-					} else if (o->off3 && o->off4) {
-						val_store(ilp, ul1, o->off3, 0, data);
-						val_store(ilp, ul2, o->off4, 0, data);
+					if (o->off3 && o->off4) {
+						val_store(ilp, ul1, o->off3, 0, data, o);
+						val_store(ilp, ul2, o->off4, 0, data, o);
 					}
 				}
 				if (curr < 2) {
-					if (o->roff5 && o->roff6) {
-						*(unsigned int *) o->roff5 = ul1;
-						*(unsigned int *) o->roff6 = ul2;
-					} else if (o->off5 && o->off6) {
-						val_store(ilp, ul1, o->off5, 0, data);
-						val_store(ilp, ul2, o->off6, 0, data);
+					if (o->off5 && o->off6) {
+						val_store(ilp, ul1, o->off5, 0, data, o);
+						val_store(ilp, ul2, o->off6, 0, data, o);
 					}
 				}
 			}
@@ -775,17 +727,11 @@ static int __handle_option(struct fio_option *o, const char *ptr, void *data,
 		if (fn)
 			ret = fn(data, &il);
 		else {
-			if (first) {
-				if (o->roff1)
-					*(unsigned int *)o->roff1 = il;
-				else
-					val_store(ilp, il, o->off1, 0, data);
-			}
+			if (first)
+				val_store(ilp, il, o->off1, 0, data, o);
 			if (!more) {
-				if (o->roff2)
-					*(unsigned int *) o->roff2 = il;
-				else if (o->off2)
-					val_store(ilp, il, o->off2, 0, data);
+				if (o->off2)
+					val_store(ilp, il, o->off2, 0, data, o);
 			}
 		}
 		break;
@@ -1194,7 +1140,7 @@ void option_init(struct fio_option *o)
 		log_err("Option %s: string set option with"
 				" default will always be true\n", o->name);
 	}
-	if (!o->cb && (!o->off1 && !o->roff1))
+	if (!o->cb && !o->off1)
 		log_err("Option %s: neither cb nor offset given\n", o->name);
 	if (!o->category) {
 		log_info("Option %s: no category defined. Setting to misc\n", o->name);
@@ -1204,10 +1150,8 @@ void option_init(struct fio_option *o)
 	if (o->type == FIO_OPT_STR || o->type == FIO_OPT_STR_STORE ||
 	    o->type == FIO_OPT_STR_MULTI)
 		return;
-	if (o->cb && ((o->off1 || o->off2 || o->off3 || o->off4) ||
-		      (o->roff1 || o->roff2 || o->roff3 || o->roff4))) {
+	if (o->cb && (o->off1 || o->off2 || o->off3 || o->off4))
 		log_err("Option %s: both cb and offset given\n", o->name);
-	}
 }
 
 /*
@@ -1238,7 +1182,7 @@ void options_free(struct fio_option *options, void *data)
 		if (o->type != FIO_OPT_STR_STORE || !o->off1)
 			continue;
 
-		ptr = td_var(data, o->off1);
+		ptr = td_var(data, o, o->off1);
 		if (*ptr) {
 			free(*ptr);
 			*ptr = NULL;
diff --git a/parse.h b/parse.h
index 34d99d4..8eefff9 100644
--- a/parse.h
+++ b/parse.h
@@ -49,7 +49,6 @@ struct fio_option {
 	unsigned int off4;
 	unsigned int off5;
 	unsigned int off6;
-	void *roff1, *roff2, *roff3, *roff4, *roff5, *roff6;
 	unsigned int maxval;		/* max and min value */
 	int minval;
 	double maxfp;			/* max and min floating value */
@@ -69,6 +68,7 @@ struct fio_option {
 	struct fio_option *inv_opt;	/* cached lookup */
 	int (*verify)(struct fio_option *, void *);
 	const char *prof_name;		/* only valid for specific profile */
+	void *prof_opts;
 	unsigned int category;		/* what type of option */
 	unsigned int group;		/* who to group with */
 	void *gui_data;
@@ -100,7 +100,17 @@ typedef int (fio_opt_str_val_fn)(void *, long long *);
 typedef int (fio_opt_int_fn)(void *, int *);
 typedef int (fio_opt_str_set_fn)(void *);
 
-#define td_var(start, offset)	((void *) start + (offset))
+#define __td_var(start, offset)	((void *) start + (offset))
+
+struct thread_options;
+static inline void *td_var(struct thread_options *to, struct fio_option *o,
+			   unsigned int offset)
+{
+	if (o->prof_opts)
+		return __td_var(o->prof_opts, offset);
+
+	return __td_var(to, offset);
+}
 
 static inline int parse_is_percent(unsigned long long val)
 {
diff --git a/profile.c b/profile.c
index 5d0b866..90c9ea8 100644
--- a/profile.c
+++ b/profile.c
@@ -52,6 +52,7 @@ static int add_profile_options(struct profile_ops *ops)
 	o = ops->options;
 	while (o->name) {
 		o->prof_name = ops->name;
+		o->prof_opts = ops->opt_data;
 		if (add_option(o))
 			return 1;
 		o++;
diff --git a/profile.h b/profile.h
index de35e9b..8d1f757 100644
--- a/profile.h
+++ b/profile.h
@@ -27,6 +27,7 @@ struct profile_ops {
 	 * Profile specific options
 	 */
 	struct fio_option *options;
+	void *opt_data;
 
 	/*
 	 * Called after parsing options, to prepare 'cmdline'
diff --git a/profiles/act.c b/profiles/act.c
index 7e2f8af..4d2ec5c 100644
--- a/profiles/act.c
+++ b/profiles/act.c
@@ -74,12 +74,25 @@ static unsigned int org_idx;
 
 static int act_add_opt(const char *format, ...) __attribute__ ((__format__ (__printf__, 1, 2)));
 
+struct act_options {
+	unsigned int pad;
+	char *device_names;
+	unsigned int load;
+	unsigned int prep;
+	unsigned int threads_per_queue;
+	unsigned int num_read_blocks;
+	unsigned int write_size;
+	unsigned long long test_duration;
+};
+
+static struct act_options act_options;
+
 static struct fio_option options[] = {
 	{
 		.name	= "device-names",
 		.lname	= "device-names",
 		.type	= FIO_OPT_STR_STORE,
-		.roff1	= &device_names,
+		.off1	= offsetof(struct act_options, device_names),
 		.help	= "Devices to use",
 		.category = FIO_OPT_C_PROFILE,
 		.group	= FIO_OPT_G_ACT,
@@ -88,7 +101,7 @@ static struct fio_option options[] = {
 		.name	= "load",
 		.lname	= "Load multiplier",
 		.type	= FIO_OPT_INT,
-		.roff1	= &load,
+		.off1	= offsetof(struct act_options, load),
 		.help	= "ACT load multipler (default 1x)",
 		.def	= "1",
 		.category = FIO_OPT_C_PROFILE,
@@ -98,7 +111,7 @@ static struct fio_option options[] = {
 		.name	= "test-duration",
 		.lname	= "Test duration",
 		.type	= FIO_OPT_STR_VAL_TIME,
-		.roff1	= &test_duration,
+		.off1	= offsetof(struct act_options, test_duration),
 		.help	= "How long the entire test takes to run",
 		.def	= "24h",
 		.category = FIO_OPT_C_PROFILE,
@@ -108,7 +121,7 @@ static struct fio_option options[] = {
 		.name	= "threads-per-queue",
 		.lname	= "Number of read IO threads per device",
 		.type	= FIO_OPT_INT,
-		.roff1	= &threads_per_queue,
+		.off1	= offsetof(struct act_options, threads_per_queue),
 		.help	= "Number of read IO threads per device",
 		.def	= "8",
 		.category = FIO_OPT_C_PROFILE,
@@ -118,7 +131,7 @@ static struct fio_option options[] = {
 		.name	= "read-req-num-512-blocks",
 		.lname	= "Number of 512b blocks to read",
 		.type	= FIO_OPT_INT,
-		.roff1	= &num_read_blocks,
+		.off1	= offsetof(struct act_options, num_read_blocks),
 		.help	= "Number of 512b blocks to read at the time",
 		.def	= "3",
 		.category = FIO_OPT_C_PROFILE,
@@ -128,7 +141,7 @@ static struct fio_option options[] = {
 		.name	= "large-block-op-kbytes",
 		.lname	= "Size of large block ops (writes)",
 		.type	= FIO_OPT_INT,
-		.roff1	= &write_size,
+		.off1	= offsetof(struct act_options, write_size),
 		.help	= "Size of large block ops (writes)",
 		.def	= "128k",
 		.category = FIO_OPT_C_PROFILE,
@@ -138,7 +151,7 @@ static struct fio_option options[] = {
 		.name	= "prep",
 		.lname	= "Run ACT prep phase",
 		.type	= FIO_OPT_STR_SET,
-		.roff1	= &prep,
+		.off1	= offsetof(struct act_options, prep),
 		.help	= "Set to run ACT prep phase",
 		.category = FIO_OPT_C_PROFILE,
 		.group	= FIO_OPT_G_ACT,
@@ -445,6 +458,7 @@ static struct profile_ops act_profile = {
 	.name		= "act",
 	.desc		= "ACT Aerospike like benchmark",
 	.options	= options,
+	.opt_data	= &act_options,
 	.prep_cmd	= act_prep_cmdline,
 	.cmdline	= act_opts,
 	.io_ops		= &act_io_ops,
diff --git a/profiles/tiobench.c b/profiles/tiobench.c
index bdb5985..99c88c4 100644
--- a/profiles/tiobench.c
+++ b/profiles/tiobench.c
@@ -21,12 +21,23 @@ static const char *tb_opts[] = {
 	"name=randread", "stonewall", "rw=randread", NULL,
 };
 
+struct tiobench_options {
+	unsigned int pad;
+	unsigned long long size;
+	unsigned int loops;
+	unsigned int bs;
+	unsigned int nthreads;
+	char *dir;
+};
+
+static struct tiobench_options tiobench_options;
+
 static struct fio_option options[] = {
 	{
 		.name	= "size",
 		.lname	= "Tiobench size",
 		.type	= FIO_OPT_STR_VAL,
-		.roff1	= &size,
+		.off1	= offsetof(struct tiobench_options, size),
 		.help	= "Size in MB",
 		.category = FIO_OPT_C_PROFILE,
 		.group	= FIO_OPT_G_TIOBENCH,
@@ -35,7 +46,7 @@ static struct fio_option options[] = {
 		.name	= "block",
 		.lname	= "Tiobench block",
 		.type	= FIO_OPT_INT,
-		.roff1	= &bs,
+		.off1	= offsetof(struct tiobench_options, bs),
 		.help	= "Block size in bytes",
 		.def	= "4k",
 		.category = FIO_OPT_C_PROFILE,
@@ -45,7 +56,7 @@ static struct fio_option options[] = {
 		.name	= "numruns",
 		.lname	= "Tiobench numruns",
 		.type	= FIO_OPT_INT,
-		.roff1	= &loops,
+		.off1	= offsetof(struct tiobench_options, loops),
 		.help	= "Number of runs",
 		.category = FIO_OPT_C_PROFILE,
 		.group	= FIO_OPT_G_TIOBENCH,
@@ -54,7 +65,7 @@ static struct fio_option options[] = {
 		.name	= "dir",
 		.lname	= "Tiobench directory",
 		.type	= FIO_OPT_STR_STORE,
-		.roff1	= &dir,
+		.off1	= offsetof(struct tiobench_options, dir),
 		.help	= "Test directory",
 		.category = FIO_OPT_C_PROFILE,
 		.group	= FIO_OPT_G_TIOBENCH,
@@ -63,7 +74,7 @@ static struct fio_option options[] = {
 		.name	= "threads",
 		.lname	= "Tiobench threads",
 		.type	= FIO_OPT_INT,
-		.roff1	= &nthreads,
+		.off1	= offsetof(struct tiobench_options, nthreads),
 		.help	= "Number of Threads",
 		.category = FIO_OPT_C_PROFILE,
 		.group	= FIO_OPT_G_TIOBENCH,
@@ -105,6 +116,8 @@ static struct profile_ops tiobench_profile = {
 	.options	= options,
 	.prep_cmd	= tb_prep_cmdline,
 	.cmdline	= tb_opts,
+	.options	= options,
+	.opt_data	= &tiobench_options,
 };
 
 static void fio_init tiobench_register(void)
