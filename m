Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:56843 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202AbaDPMAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 16 Apr 2014 08:00:05 -0400
Received: from kernel.dk ([54.225.238.116] helo=rt116.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WaOVY-0004Sh-7u
	for fio@vger.kernel.org; Wed, 16 Apr 2014 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140416120003.5F734400C0@rt116.dk>
Date: Wed, 16 Apr 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit fb73340c52bcab712dfb175dafbcb5156abdda12:

  Windows: set sizeof(sun_path) to 260 (MAX_PATH). (2014-04-14 20:19:54 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 3a35845f7756a8a86b420650bff41267192dce22:

  sg/binject: only restore file flags if they have been set (2014-04-15 09:07:44 -0600)

----------------------------------------------------------------
Jens Axboe (7):
      strcpy: kill last of the suspect ones
      Merge branch 'master' of ssh://git.kernel.dk/data/git/fio
      idletime: fix another missing unlock on error
      backend: fix potential division-by-zero
      binject: check for error in fcntl() restore of flags
      sg: check for error in fcntl() restore of flags
      sg/binject: only restore file flags if they have been set

 backend.c         |    6 +++++-
 cconv.c           |   11 +++++++----
 engines/binject.c |   11 +++++++++--
 engines/sg.c      |   13 ++++++++++---
 filesetup.c       |    4 ++--
 fio.h             |    2 +-
 idletime.c        |    4 +++-
 init.c            |   10 ++++++----
 libfio.c          |   11 +++++++----
 stat.c            |    6 ++++--
 10 files changed, 54 insertions(+), 24 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 62bca29..12e562b 100644
--- a/backend.c
+++ b/backend.c
@@ -204,7 +204,11 @@ static int __check_min_rate(struct thread_data *td, struct timeval *now,
 						td->o.name, rate_iops);
 				return 1;
 			} else {
-				rate = ((iops - td->rate_blocks[ddir]) * 1000) / spent;
+				if (spent)
+					rate = ((iops - td->rate_blocks[ddir]) * 1000) / spent;
+				else
+					rate = 0;
+
 				if (rate < rate_iops_min ||
 				    iops < td->rate_blocks[ddir]) {
 					log_err("%s: min iops rate %u not met,"
diff --git a/cconv.c b/cconv.c
index 5b9c3be..ee3b0ca 100644
--- a/cconv.c
+++ b/cconv.c
@@ -10,14 +10,17 @@ static void string_to_cpu(char **dst, const uint8_t *src)
 		*dst = strdup(__src);
 }
 
-static void string_to_net(uint8_t *dst, const char *src)
+static void __string_to_net(uint8_t *dst, const char *src, size_t dst_size)
 {
-	if (src)
-		strcpy((char *) dst, src);
-	else
+	if (src) {
+		dst[dst_size - 1] = '\0';
+		strncpy((char *) dst, src, dst_size - 1);
+	} else
 		dst[0] = '\0';
 }
 
+#define string_to_net(dst, src)	__string_to_net((dst), (src), sizeof(dst))
+
 static void free_thread_options_to_cpu(struct thread_options *o)
 {
 	free(o->description);
diff --git a/engines/binject.c b/engines/binject.c
index 0264d0a..43e3169 100644
--- a/engines/binject.c
+++ b/engines/binject.c
@@ -110,7 +110,9 @@ static int fio_binject_getevents(struct thread_data *td, unsigned int min,
 		 * don't block for min events == 0
 		 */
 		if (!min)
-			fio_set_fd_nonblocking(bf->fd, "binject");
+			bd->fd_flags[i] = fio_set_fd_nonblocking(bf->fd, "binject");
+		else
+			bd->fd_flags[i] = -1;
 
 		bd->pfds[i].fd = bf->fd;
 		bd->pfds[i].events = POLLIN;
@@ -153,7 +155,12 @@ static int fio_binject_getevents(struct thread_data *td, unsigned int min,
 	if (!min) {
 		for_each_file(td, f, i) {
 			bf = (struct binject_file *) (uintptr_t) f->engine_data;
-			fcntl(bf->fd, F_SETFL, bd->fd_flags[i]);
+
+			if (bd->fd_flags[i] == -1)
+				continue;
+
+			if (fcntl(bf->fd, F_SETFL, bd->fd_flags[i]) < 0)
+				log_err("fio: binject failed to restore fcntl flags: %s\n", strerror(errno));
 		}
 	}
 
diff --git a/engines/sg.c b/engines/sg.c
index fcd9c41..1a027da 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -78,7 +78,9 @@ static int fio_sgio_getevents(struct thread_data *td, unsigned int min,
 		 * don't block for min events == 0
 		 */
 		if (!min)
-			fio_set_fd_nonblocking(f->fd, "sg");
+			sd->fd_flags[i] = fio_set_fd_nonblocking(f->fd, "sg");
+		else
+			sd->fd_flags[i] = -1;
 
 		sd->pfds[i].fd = f->fd;
 		sd->pfds[i].events = POLLIN;
@@ -142,8 +144,13 @@ re_read:
 	}
 
 	if (!min) {
-		for_each_file(td, f, i)
-			fcntl(f->fd, F_SETFL, sd->fd_flags[i]);
+		for_each_file(td, f, i) {
+			if (sd->fd_flags[i] == -1)
+				continue;
+
+			if (fcntl(f->fd, F_SETFL, sd->fd_flags[i]) < 0)
+				log_err("fio: sg failed to restore fcntl flags: %s\n", strerror(errno));
+		}
 	}
 
 	return r;
diff --git a/filesetup.c b/filesetup.c
index 490f0fc..60e7947 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -711,8 +711,8 @@ static unsigned long long get_fs_free_counts(struct thread_data *td)
 		if (fm)
 			continue;
 
-		fm = malloc(sizeof(*fm));
-		strcpy(fm->__base, buf);
+		fm = calloc(1, sizeof(*fm));
+		strncpy(fm->__base, buf, sizeof(fm->__base) - 1);
 		fm->base = basename(fm->__base);
 		fm->key = sb.st_dev;
 		flist_add(&fm->list, &list);
diff --git a/fio.h b/fio.h
index 544916f..9eecba3 100644
--- a/fio.h
+++ b/fio.h
@@ -441,7 +441,7 @@ extern char *num2str(unsigned long, int, int, int, int);
 extern int ioengine_load(struct thread_data *);
 extern int parse_dryrun(void);
 extern int fio_running_or_pending_io_threads(void);
-extern void fio_set_fd_nonblocking(int, const char *);
+extern int fio_set_fd_nonblocking(int, const char *);
 
 extern uintptr_t page_mask;
 extern uintptr_t page_size;
diff --git a/idletime.c b/idletime.c
index 8d23154..a366d2b 100644
--- a/idletime.c
+++ b/idletime.c
@@ -73,8 +73,10 @@ static void *idle_prof_thread_fn(void *data)
 	pthread_mutex_lock(&ipt->init_lock);
 
 	/* exit if any other thread failed to start */
-	if (ipc.status == IDLE_PROF_STATUS_ABORT)
+	if (ipc.status == IDLE_PROF_STATUS_ABORT) {
+		pthread_mutex_unlock(&ipt->init_lock);
 		return NULL;
+	}
 
 	retval = set_cpu_affinity(ipt);
 	if (retval == -1) {
diff --git a/init.c b/init.c
index 7630978..8448586 100644
--- a/init.c
+++ b/init.c
@@ -937,7 +937,7 @@ static struct fpre_keyword {
 	{ .keyword = NULL, },
 	};
 
-static char *make_filename(char *buf, struct thread_options *o,
+static char *make_filename(char *buf, size_t buf_size,struct thread_options *o,
 			   const char *jobname, int jobnum, int filenum)
 {
 	struct fpre_keyword *f;
@@ -952,7 +952,9 @@ static char *make_filename(char *buf, struct thread_options *o,
 	for (f = &fpre_keywords[0]; f->keyword; f++)
 		f->strlen = strlen(f->keyword);
 
-	strcpy(buf, o->filename_format);
+	buf[buf_size - 1] = '\0';
+	strncpy(buf, o->filename_format, buf_size - 1);
+
 	memset(copy, 0, sizeof(copy));
 	for (f = &fpre_keywords[0]; f->keyword; f++) {
 		do {
@@ -1012,7 +1014,7 @@ static char *make_filename(char *buf, struct thread_options *o,
 			if (post_start)
 				strncpy(dst, buf + post_start, dst_left);
 
-			strcpy(buf, copy);
+			strncpy(buf, copy, buf_size - 1);
 		} while (1);
 	}
 
@@ -1072,7 +1074,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 			add_file(td, jobname, job_add_num, 0);
 		else {
 			for (i = 0; i < o->nr_files; i++)
-				add_file(td, make_filename(fname, o, jobname, job_add_num, i), job_add_num, 0);
+				add_file(td, make_filename(fname, sizeof(fname), o, jobname, job_add_num, i), job_add_num, 0);
 		}
 	}
 
diff --git a/libfio.c b/libfio.c
index 5ed8c60..8af1129 100644
--- a/libfio.c
+++ b/libfio.c
@@ -234,7 +234,7 @@ int fio_running_or_pending_io_threads(void)
 	return 0;
 }
 
-void fio_set_fd_nonblocking(int fd, const char *who)
+int fio_set_fd_nonblocking(int fd, const char *who)
 {
 	int flags;
 
@@ -242,11 +242,14 @@ void fio_set_fd_nonblocking(int fd, const char *who)
 	if (flags < 0)
 		log_err("fio: %s failed to get file flags: %s\n", who, strerror(errno));
 	else {
-		flags |= O_NONBLOCK;
-		flags = fcntl(fd, F_SETFL, flags);
-		if (flags < 0)
+		int new_flags = flags | O_NONBLOCK;
+
+		new_flags = fcntl(fd, F_SETFL, new_flags);
+		if (new_flags < 0)
 			log_err("fio: %s failed to get file flags: %s\n", who, strerror(errno));
 	}
+
+	return flags;
 }
 
 static int endian_check(void)
diff --git a/stat.c b/stat.c
index fbf0118..3adb46e 100644
--- a/stat.c
+++ b/stat.c
@@ -1272,10 +1272,12 @@ static void __show_run_stats(void)
 			if (!td->error && td->o.continue_on_error &&
 			    td->first_error) {
 				ts->error = td->first_error;
-				strcpy(ts->verror, td->verror);
+				ts->verror[sizeof(ts->verror) - 1] = '\0';
+				strncpy(ts->verror, td->verror, sizeof(ts->verror) - 1);
 			} else  if (td->error) {
 				ts->error = td->error;
-				strcpy(ts->verror, td->verror);
+				ts->verror[sizeof(ts->verror) - 1] = '\0';
+				strncpy(ts->verror, td->verror, sizeof(ts->verror) - 1);
 			}
 		}
 
