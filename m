Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:54651 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaDOMAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 15 Apr 2014 08:00:07 -0400
Received: from kernel.dk ([54.225.238.116] helo=rt116.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Wa222-0000Ub-29
	for fio@vger.kernel.org; Tue, 15 Apr 2014 12:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140415120003.A5A1440080@rt116.dk>
Date: Tue, 15 Apr 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit a3b4cf7dcae447729f0f4a4ea122f605b909ed70:

  diskutil: separate out stats from name (2014-04-11 12:17:53 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to fb73340c52bcab712dfb175dafbcb5156abdda12:

  Windows: set sizeof(sun_path) to 260 (MAX_PATH). (2014-04-14 20:19:54 -0600)

----------------------------------------------------------------
Bruce Cran (1):
      Windows: set sizeof(sun_path) to 260 (MAX_PATH).

Jens Axboe (43):
      init: fix more cases of leaking pid_file
      stat: check that TEMP environment variable is half-way sane
      server: ensure that dus->name is always NULL terminated
      init: fix potential buffer overrun in make_filename()
      verify: fix potential buffer overrun in dump_buf()
      file: fix potential buffer overrun in get_fs_free_counts()
      net engine: fix potential buffer overrun in socket path
      client: fix potential buffer overrun in socket path
      server: fix potential buffer overrun in bind string
      server: fix potential buffer overrun in socket setup path
      stat: fix wrong check for whether we have a description or not
      Fix missing sign conversion in ignore_error_type()
      Make td_verror() use an unsigned type
      gettime: use unsigned loop counter
      server: fix missing comma in fio_server_ops[] strings
      eta: fix potential divide by zero
      idletime: fix potential divide-by-zero
      stat: fix potential divide-by-zero
      backend: fix potential divide-by-zero
      init: remove dead code
      Error check fcntl() calls
      make_filename: another off-by-one buffer issue
      num2str: ensure we never access postfix[] out-of-bounds
      backend: better NULL termination fix for IO scheduler switching
      server: sanity check incoming command size (and payload)
      server: ensure that incoming iolog name is NULL terminated
      net engine: get rid of unused struct sockaddr_in6
      td_verror() needs errno style error
      e4defrag: pass 'error' into td_verror()
      filesetup: silence bogus warning on close(-1)
      init: silence bogus td == NULL warning
      gettime: handle pthread_create() failure
      stat: warn on failure to detach DU thread
      gettime: init 'failed' before use
      Avoid overwriting allocated pid_file
      idletime: unlock ->start_lock in error cases
      Fix is_power_of_2() for longs
      parse: make it clear that 'cp' can't be NULL for o->off1
      diskutil: make it clear that parent != NULL for json output
      Fix potential NULL dereference in alloc_mem_mmap()
      disk util: fix bug in strncpy() conversion
      init: fix leak bug fix from commit 60c5ec73
      init: improve command line check for when to print usage/help

 backend.c                         |   11 ++++--
 client.c                          |    2 +-
 diskutil.c                        |   12 ++++--
 engines/binject.c                 |    7 ++--
 engines/e4defrag.c                |    4 +-
 engines/net.c                     |    9 ++---
 engines/sg.c                      |    7 ++--
 eta.c                             |   24 ++++++++---
 filesetup.c                       |   16 ++++++--
 fio.h                             |    5 ++-
 gettime.c                         |   12 ++++--
 idletime.c                        |   13 ++++--
 init.c                            |   79 +++++++++++++++++++++++++++++--------
 io_u.c                            |    2 +-
 lib/num2str.c                     |    5 +++
 libfio.c                          |   16 ++++++++
 memory.c                          |    5 ++-
 options.c                         |    2 +-
 os/windows/posix/include/sys/un.h |    2 +-
 parse.c                           |    2 +-
 server.c                          |   40 +++++++++++++------
 server.h                          |    1 +
 stat.c                            |   26 +++++++++---
 verify.c                          |   22 +++++++++--
 24 files changed, 239 insertions(+), 85 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index b05e543..62bca29 100644
--- a/backend.c
+++ b/backend.c
@@ -182,7 +182,11 @@ static int __check_min_rate(struct thread_data *td, struct timeval *now,
 								ratemin);
 				return 1;
 			} else {
-				rate = ((bytes - td->rate_bytes[ddir]) * 1000) / spent;
+				if (spent)
+					rate = ((bytes - td->rate_bytes[ddir]) * 1000) / spent;
+				else
+					rate = 0;
+
 				if (rate < ratemin ||
 				    bytes < td->rate_bytes[ddir]) {
 					log_err("%s: min rate %u not met, got"
@@ -1110,13 +1114,14 @@ static int switch_ioscheduler(struct thread_data *td)
 	/*
 	 * Read back and check that the selected scheduler is now the default.
 	 */
-	memset(tmp, 0, sizeof(tmp));
-	ret = fread(tmp, 1, sizeof(tmp) - 1, f);
+	ret = fread(tmp, sizeof(tmp), 1, f);
 	if (ferror(f) || ret < 0) {
 		td_verror(td, errno, "fread");
 		fclose(f);
 		return 1;
 	}
+	tmp[sizeof(tmp) - 1] = '\0';
+
 
 	sprintf(tmp2, "[%s]", td->o.ioscheduler);
 	if (!strstr(tmp, tmp2)) {
diff --git a/client.c b/client.c
index 05439e1..af6621d 100644
--- a/client.c
+++ b/client.c
@@ -388,7 +388,7 @@ static int fio_client_connect_sock(struct fio_client *client)
 
 	memset(addr, 0, sizeof(*addr));
 	addr->sun_family = AF_UNIX;
-	strcpy(addr->sun_path, client->hostname);
+	strncpy(addr->sun_path, client->hostname, sizeof(addr->sun_path) - 1);
 
 	fd = socket(AF_UNIX, SOCK_STREAM, 0);
 	if (fd < 0) {
diff --git a/diskutil.c b/diskutil.c
index d97c5ca..cb285cf 100644
--- a/diskutil.c
+++ b/diskutil.c
@@ -6,6 +6,7 @@
 #include <dirent.h>
 #include <libgen.h>
 #include <math.h>
+#include <assert.h>
 
 #include "fio.h"
 #include "smalloc.h"
@@ -299,7 +300,7 @@ static struct disk_util *disk_util_add(struct thread_data *td, int majdev,
 		sfree(du);
 		return NULL;
 	}
-	strncpy((char *) du->dus.name, basename(path) - 1, FIO_DU_NAME_SZ);
+	strncpy((char *) du->dus.name, basename(path), FIO_DU_NAME_SZ - 1);
 	du->sysfs_root = path;
 	du->major = majdev;
 	du->minor = mindev;
@@ -686,12 +687,15 @@ void show_disk_util(int terse, struct json_object *parent)
 		return;
 	}
 
-	if (!terse && !parent)
+	if (output_format == FIO_OUTPUT_JSON)
+		assert(parent);
+
+	if (!terse && output_format != FIO_OUTPUT_JSON)
 		log_info("\nDisk stats (read/write):\n");
 
-	if (output_format == FIO_OUTPUT_JSON) {
+	if (output_format == FIO_OUTPUT_JSON)
 		json_object_add_disk_utils(parent, &disk_list);
-	} else
+	else
 		flist_for_each(entry, &disk_list) {
 			du = flist_entry(entry, struct disk_util, list);
 
diff --git a/engines/binject.c b/engines/binject.c
index fb19062..0264d0a 100644
--- a/engines/binject.c
+++ b/engines/binject.c
@@ -109,10 +109,9 @@ static int fio_binject_getevents(struct thread_data *td, unsigned int min,
 		/*
 		 * don't block for min events == 0
 		 */
-		if (!min) {
-			bd->fd_flags[i] = fcntl(bf->fd, F_GETFL);
-			fcntl(bf->fd, F_SETFL, bd->fd_flags[i] | O_NONBLOCK);
-		}
+		if (!min)
+			fio_set_fd_nonblocking(bf->fd, "binject");
+
 		bd->pfds[i].fd = bf->fd;
 		bd->pfds[i].events = POLLIN;
 	}
diff --git a/engines/e4defrag.c b/engines/e4defrag.c
index 4d87f67..3599ab8 100644
--- a/engines/e4defrag.c
+++ b/engines/e4defrag.c
@@ -80,7 +80,7 @@ static int fio_e4defrag_init(struct thread_data *td)
 
 	ed = malloc(sizeof(*ed));
 	if (!ed) {
-		td_verror(td, -ENOMEM, "io_queue_init");
+		td_verror(td, ENOMEM, "io_queue_init");
 		return 1;
 	}
 	memset(ed, 0 ,sizeof(*ed));
@@ -91,7 +91,7 @@ static int fio_e4defrag_init(struct thread_data *td)
 
 	ed->donor_fd = open(donor_name, O_CREAT|O_WRONLY, 0644);
 	if (ed->donor_fd < 0) {
-		td_verror(td, ed->donor_fd, "io_queue_init");
+		td_verror(td, errno, "io_queue_init");
 		log_err("Can't open donor file %s err:%d", donor_name, ed->donor_fd);
 		free(ed);
 		return 1;
diff --git a/engines/net.c b/engines/net.c
index d036a58..8087207 100644
--- a/engines/net.c
+++ b/engines/net.c
@@ -945,7 +945,8 @@ static int fio_netio_setup_connect_unix(struct thread_data *td,
 	struct sockaddr_un *soun = &nd->addr_un;
 
 	soun->sun_family = AF_UNIX;
-	strcpy(soun->sun_path, path);
+	memset(soun->sun_path, 0, sizeof(soun->sun_path));
+	strncpy(soun->sun_path, path, sizeof(soun->sun_path) - 1);
 	return 0;
 }
 
@@ -976,7 +977,7 @@ static int fio_netio_setup_listen_unix(struct thread_data *td, const char *path)
 
 	memset(addr, 0, sizeof(*addr));
 	addr->sun_family = AF_UNIX;
-	strcpy(addr->sun_path, path);
+	strncpy(addr->sun_path, path, sizeof(addr->sun_path) - 1);
 	unlink(path);
 
 	len = sizeof(addr->sun_family) + strlen(path) + 1;
@@ -998,13 +999,11 @@ static int fio_netio_setup_listen_inet(struct thread_data *td, short port)
 	struct netio_options *o = td->eo;
 	struct ip_mreq mr;
 	struct sockaddr_in sin;
-	struct sockaddr_in6 sin6;
 	struct sockaddr *saddr;
 	int fd, opt, type, domain;
 	socklen_t len;
 
 	memset(&sin, 0, sizeof(sin));
-	memset(&sin6, 0, sizeof(sin6));
 
 	if (o->proto == FIO_TYPE_TCP) {
 		type = SOCK_STREAM;
@@ -1087,7 +1086,7 @@ static int fio_netio_setup_listen_inet(struct thread_data *td, short port)
 		len = sizeof(nd->addr6);
 
 		nd->addr6.sin6_family = AF_INET6;
-		nd->addr6.sin6_addr = sin6.sin6_addr.s6_addr ? sin6.sin6_addr : in6addr_any;
+		nd->addr6.sin6_addr = in6addr_any;
 		nd->addr6.sin6_port = htons(port);
 	}
 
diff --git a/engines/sg.c b/engines/sg.c
index 88d9125..fcd9c41 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -77,10 +77,9 @@ static int fio_sgio_getevents(struct thread_data *td, unsigned int min,
 		/*
 		 * don't block for min events == 0
 		 */
-		if (!min) {
-			sd->fd_flags[i] = fcntl(f->fd, F_GETFL);
-			fcntl(f->fd, F_SETFL, sd->fd_flags[i] | O_NONBLOCK);
-		}
+		if (!min)
+			fio_set_fd_nonblocking(f->fd, "sg");
+
 		sd->pfds[i].fd = f->fd;
 		sd->pfds[i].events = POLLIN;
 	}
diff --git a/eta.c b/eta.c
index 42066e0..7500082 100644
--- a/eta.c
+++ b/eta.c
@@ -174,14 +174,26 @@ static int thread_eta(struct thread_data *td)
 		double perc, perc_t;
 
 		bytes_done = ddir_rw_sum(td->io_bytes);
-		perc = (double) bytes_done / (double) bytes_total;
-		if (perc > 1.0)
-			perc = 1.0;
+
+		if (bytes_total) {
+			perc = (double) bytes_done / (double) bytes_total;
+			if (perc > 1.0)
+				perc = 1.0;
+		} else
+			perc = 0.0;
 
 		if (td->o.time_based) {
-			perc_t = (double) elapsed / (double) timeout;
-			if (perc_t < perc)
-				perc = perc_t;
+			if (timeout) {
+				perc_t = (double) elapsed / (double) timeout;
+				if (perc_t < perc)
+					perc = perc_t;
+			} else {
+				/*
+				 * Will never hit, we can't have time_based
+				 * without a timeout set.
+				 */
+				perc = 0.0;
+			}
 		}
 
 		eta_sec = (unsigned long) (elapsed * (1.0 / perc)) - elapsed;
diff --git a/filesetup.c b/filesetup.c
index bf56112..490f0fc 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -688,7 +688,8 @@ static unsigned long long get_fs_free_counts(struct thread_data *td)
 		} else if (f->filetype != FIO_TYPE_FILE)
 			continue;
 
-		strcpy(buf, f->file_name);
+		buf[255] = '\0';
+		strncpy(buf, f->file_name, 255);
 
 		if (stat(buf, &sb) < 0) {
 			if (errno != ENOENT)
@@ -914,7 +915,13 @@ int setup_files(struct thread_data *td)
 
 			err = __file_invalidate_cache(td, f, old_len,
 								extend_len);
-			close(f->fd);
+
+			/*
+			 * Shut up static checker
+			 */
+			if (f->fd != -1)
+				close(f->fd);
+
 			f->fd = -1;
 			if (err)
 				break;
@@ -1325,8 +1332,11 @@ int put_file(struct thread_data *td, struct fio_file *f)
 	if (--f->references)
 		return 0;
 
-	if (should_fsync(td) && td->o.fsync_on_close)
+	if (should_fsync(td) && td->o.fsync_on_close) {
 		f_ret = fsync(f->fd);
+		if (f_ret < 0)
+			f_ret = errno;
+	}
 
 	if (td->io_ops->close_file)
 		ret = td->io_ops->close_file(td, f);
diff --git a/fio.h b/fio.h
index 3df5bd9..544916f 100644
--- a/fio.h
+++ b/fio.h
@@ -351,7 +351,7 @@ enum {
 
 #define __td_verror(td, err, msg, func)					\
 	do {								\
-		int ____e = (err);						\
+		unsigned int ____e = (err);				\
 		if ((td)->error)					\
 			break;						\
 		(td)->error = ____e;					\
@@ -441,6 +441,7 @@ extern char *num2str(unsigned long, int, int, int, int);
 extern int ioengine_load(struct thread_data *);
 extern int parse_dryrun(void);
 extern int fio_running_or_pending_io_threads(void);
+extern void fio_set_fd_nonblocking(int, const char *);
 
 extern uintptr_t page_mask;
 extern uintptr_t page_size;
@@ -587,7 +588,7 @@ static inline unsigned int td_min_bs(struct thread_data *td)
 	return min(td->o.min_bs[DDIR_TRIM], min_bs);
 }
 
-static inline int is_power_of_2(unsigned int val)
+static inline int is_power_of_2(unsigned long val)
 {
 	return (val != 0 && ((val & (val - 1)) == 0));
 }
diff --git a/gettime.c b/gettime.c
index c6d45f8..fa750ec 100644
--- a/gettime.c
+++ b/gettime.c
@@ -534,10 +534,10 @@ int fio_monotonic_clocktest(void)
 	struct clock_thread *threads;
 	unsigned int nr_cpus = cpus_online();
 	struct clock_entry *entries;
-	unsigned long tentries, failed;
+	unsigned long tentries, failed = 0;
 	struct clock_entry *prev, *this;
 	uint32_t seq = 0;
-	int i;
+	unsigned int i;
 
 	log_info("cs: reliable_tsc: %s\n", tsc_reliable ? "yes" : "no");
 
@@ -560,7 +560,11 @@ int fio_monotonic_clocktest(void)
 		pthread_mutex_init(&t->lock, NULL);
 		pthread_mutex_init(&t->started, NULL);
 		pthread_mutex_lock(&t->lock);
-		pthread_create(&t->thread, NULL, clock_thread_fn, t);
+		if (pthread_create(&t->thread, NULL, clock_thread_fn, t)) {
+			failed++;
+			nr_cpus = i;
+			break;
+		}
 	}
 
 	for (i = 0; i < nr_cpus; i++) {
@@ -575,7 +579,7 @@ int fio_monotonic_clocktest(void)
 		pthread_mutex_unlock(&t->lock);
 	}
 
-	for (failed = i = 0; i < nr_cpus; i++) {
+	for (i = 0; i < nr_cpus; i++) {
 		struct clock_thread *t = &threads[i];
 		void *ret;
 
diff --git a/idletime.c b/idletime.c
index c0bc0bf..8d23154 100644
--- a/idletime.c
+++ b/idletime.c
@@ -109,12 +109,16 @@ static void *idle_prof_thread_fn(void *data)
 	pthread_mutex_lock(&ipt->start_lock);
 
 	/* exit if other threads failed to initialize */
-	if (ipc.status == IDLE_PROF_STATUS_ABORT)
+	if (ipc.status == IDLE_PROF_STATUS_ABORT) {
+		pthread_mutex_unlock(&ipt->start_lock);
 		return NULL;
+	}
 
 	/* exit if we are doing calibration only */
-	if (ipc.status == IDLE_PROF_STATUS_CALI_STOP)
+	if (ipc.status == IDLE_PROF_STATUS_CALI_STOP) {
+		pthread_mutex_unlock(&ipt->start_lock);
 		return NULL;
+	}
 
 	fio_gettime(&ipt->tps, NULL);
 	ipt->state = TD_RUNNING;
@@ -336,7 +340,10 @@ void fio_idle_prof_stop(void)
 		/* calculate idleness */
 		if (ipc.cali_mean != 0.0) {
 			runt = utime_since(&ipt->tps, &ipt->tpe);
-			ipt->idleness = ipt->loops * ipc.cali_mean / runt;
+			if (runt)
+				ipt->idleness = ipt->loops * ipc.cali_mean / runt;
+			else
+				ipt->idleness = 0.0;
 		} else
 			ipt->idleness = 0.0;
 	}
diff --git a/init.c b/init.c
index 215b60d..7630978 100644
--- a/init.c
+++ b/init.c
@@ -942,6 +942,7 @@ static char *make_filename(char *buf, struct thread_options *o,
 {
 	struct fpre_keyword *f;
 	char copy[PATH_MAX];
+	size_t dst_left = PATH_MAX - 1;
 
 	if (!o->filename_format || !strlen(o->filename_format)) {
 		sprintf(buf, "%s.%d.%d", jobname, jobnum, filenum);
@@ -969,25 +970,47 @@ static char *make_filename(char *buf, struct thread_options *o,
 			if (pre_len) {
 				strncpy(dst, buf, pre_len);
 				dst += pre_len;
+				dst_left -= pre_len;
 			}
 
 			switch (f->key) {
-			case FPRE_JOBNAME:
-				dst += sprintf(dst, "%s", jobname);
+			case FPRE_JOBNAME: {
+				int ret;
+
+				ret = snprintf(dst, dst_left, "%s", jobname);
+				if (ret < 0)
+					break;
+				dst += ret;
+				dst_left -= ret;
 				break;
-			case FPRE_JOBNUM:
-				dst += sprintf(dst, "%d", jobnum);
+				}
+			case FPRE_JOBNUM: {
+				int ret;
+
+				ret = snprintf(dst, dst_left, "%d", jobnum);
+				if (ret < 0)
+					break;
+				dst += ret;
+				dst_left -= ret;
 				break;
-			case FPRE_FILENUM:
-				dst += sprintf(dst, "%d", filenum);
+				}
+			case FPRE_FILENUM: {
+				int ret;
+
+				ret = snprintf(dst, dst_left, "%d", filenum);
+				if (ret < 0)
+					break;
+				dst += ret;
+				dst_left -= ret;
 				break;
+				}
 			default:
 				assert(0);
 				break;
 			}
 
 			if (post_start)
-				strcpy(dst, buf + post_start);
+				strncpy(dst, buf + post_start, dst_left);
 
 			strcpy(buf, copy);
 		} while (1);
@@ -1435,9 +1458,6 @@ int parse_jobs_ini(char *file, int is_buf, int stonewall_flag, int type)
 		i++;
 	}
 
-	for (i = 0; i < num_opts; i++)
-		free(opts[i]);
-
 	free(string);
 	free(name);
 	free(opts);
@@ -1694,8 +1714,6 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 	optind = 1;
 
 	while ((c = getopt_long_only(argc, argv, ostr, l_opts, &lidx)) != -1) {
-		did_arg = 1;
-
 		if ((c & FIO_CLIENT_FLAG) || client_flag_set(c)) {
 			parse_cmd_client(cur_client, argv[optind - 1]);
 			c &= ~FIO_CLIENT_FLAG;
@@ -1752,30 +1770,35 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 			append_terse_output = 1;
 			break;
 		case 'h':
+			did_arg = 1;
 			if (!cur_client) {
 				usage(argv[0]);
 				do_exit++;
 			}
 			break;
 		case 'c':
+			did_arg = 1;
 			if (!cur_client) {
 				fio_show_option_help(optarg);
 				do_exit++;
 			}
 			break;
 		case 'i':
+			did_arg = 1;
 			if (!cur_client) {
 				fio_show_ioengine_help(optarg);
 				do_exit++;
 			}
 			break;
 		case 's':
+			did_arg = 1;
 			dump_cmdline = 1;
 			break;
 		case 'r':
 			read_only = 1;
 			break;
 		case 'v':
+			did_arg = 1;
 			if (!cur_client) {
 				log_info("%s\n", fio_version_string);
 				do_exit++;
@@ -1812,6 +1835,7 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 				do_exit++;
 			break;
 		case 'P':
+			did_arg = 1;
 			parse_only = 1;
 			break;
 		case 'x': {
@@ -1831,6 +1855,7 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 			break;
 			}
 		case 'p':
+			did_arg = 1;
 			if (exec_profile)
 				free(exec_profile);
 			exec_profile = strdup(optarg);
@@ -1842,8 +1867,9 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 			if (!strncmp(opt, "name", 4) && td) {
 				ret = add_job(td, td->o.name ?: "fio", 0, 0, client_type);
 				if (ret)
-					return 0;
+					goto out_free;
 				td = NULL;
+				did_arg = 1;
 			}
 			if (!td) {
 				int is_section = !strncmp(opt, "name", 4);
@@ -1857,7 +1883,7 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 
 				td = get_new_job(global, &def_thread, 1);
 				if (!td || ioengine_load(td))
-					return 0;
+					goto out_free;
 				fio_options_set_ioengine_opts(l_opts, td);
 			}
 
@@ -1879,7 +1905,7 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 			if (!ret && !strcmp(opt, "ioengine")) {
 				free_ioengine(td);
 				if (ioengine_load(td))
-					return 0;
+					goto out_free;
 				fio_options_set_ioengine_opts(l_opts, td);
 			}
 			break;
@@ -1887,7 +1913,12 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 		case FIO_GETOPT_IOENGINE: {
 			const char *opt = l_opts[lidx].name;
 			char *val = optarg;
+
+			if (!td)
+				break;
+
 			ret = fio_cmd_ioengine_option_parse(td, opt, val);
+			did_arg = 1;
 			break;
 		}
 		case 'w':
@@ -1902,6 +1933,7 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 			}
 			break;
 		case 'S':
+			did_arg = 1;
 			if (nr_clients) {
 				log_err("fio: can't be both client and server\n");
 				do_exit++;
@@ -1914,17 +1946,21 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 			backend = 1;
 			break;
 		case 'D':
+			if (pid_file)
+				free(pid_file);
 			pid_file = strdup(optarg);
 			break;
 		case 'I':
 			if ((ret = fio_idle_prof_parse_opt(optarg))) {
 				/* exit on error and calibration only */
+				did_arg = 1;
 				do_exit++;
-				if (ret == -1) 
+				if (ret == -1)
 					exit_val = 1;
 			}
 			break;
 		case 'C':
+			did_arg = 1;
 			if (is_backend) {
 				log_err("fio: can't be both client and server\n");
 				do_exit++;
@@ -1951,10 +1987,12 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 			}
 			break;
 		case 'T':
+			did_arg = 1;
 			do_exit++;
 			exit_val = fio_monotonic_clocktest();
 			break;
 		case 'G':
+			did_arg = 1;
 			do_exit++;
 			exit_val = fio_crctest(optarg);
 			break;
@@ -1994,8 +2032,11 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 		free(pid_file);
 
 	if (td) {
-		if (!ret)
+		if (!ret) {
 			ret = add_job(td, td->o.name ?: "fio", 0, 0, client_type);
+			if (ret)
+				did_arg = 1;
+		}
 	}
 
 	while (!ret && optind < argc) {
@@ -2005,6 +2046,10 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 		optind++;
 	}
 
+out_free:
+	if (pid_file)
+		free(pid_file);
+
 	return ini_idx;
 }
 
diff --git a/io_u.c b/io_u.c
index 411da32..4b0b5a7 100644
--- a/io_u.c
+++ b/io_u.c
@@ -678,7 +678,7 @@ static void set_rw_ddir(struct thread_data *td, struct io_u *io_u)
 
 void put_file_log(struct thread_data *td, struct fio_file *f)
 {
-	int ret = put_file(td, f);
+	unsigned int ret = put_file(td, f);
 
 	if (ret)
 		td_verror(td, ret, "file close");
diff --git a/lib/num2str.c b/lib/num2str.c
index 12d6f39..8961868 100644
--- a/lib/num2str.c
+++ b/lib/num2str.c
@@ -4,6 +4,8 @@
 
 #include "../fio.h"
 
+#define ARRAY_LENGTH(arr)	sizeof(arr) / sizeof((arr)[0])
+
 /*
  * Cheesy number->string conversion, complete with carry rounding error.
  */
@@ -46,6 +48,9 @@ char *num2str(unsigned long num, int maxlen, int base, int pow2, int unit_base)
 
 	if (modulo == -1U) {
 done:
+		if (post_index >= ARRAY_LENGTH(postfix))
+			post_index = 0;
+
 		sprintf(buf, "%lu%s%s", num, postfix[post_index],
 			byte_postfix[byte_post_index]);
 		return buf;
diff --git a/libfio.c b/libfio.c
index 3fde492..5ed8c60 100644
--- a/libfio.c
+++ b/libfio.c
@@ -27,6 +27,7 @@
 #include <signal.h>
 #include <stdint.h>
 #include <locale.h>
+#include <fcntl.h>
 
 #include "fio.h"
 #include "smalloc.h"
@@ -233,6 +234,21 @@ int fio_running_or_pending_io_threads(void)
 	return 0;
 }
 
+void fio_set_fd_nonblocking(int fd, const char *who)
+{
+	int flags;
+
+	flags = fcntl(fd, F_GETFL);
+	if (flags < 0)
+		log_err("fio: %s failed to get file flags: %s\n", who, strerror(errno));
+	else {
+		flags |= O_NONBLOCK;
+		flags = fcntl(fd, F_SETFL, flags);
+		if (flags < 0)
+			log_err("fio: %s failed to get file flags: %s\n", who, strerror(errno));
+	}
+}
+
 static int endian_check(void)
 {
 	union {
diff --git a/memory.c b/memory.c
index b208320..8c06d94 100644
--- a/memory.c
+++ b/memory.c
@@ -158,9 +158,10 @@ static int alloc_mem_mmap(struct thread_data *td, size_t total_mem)
 	if (td->orig_buffer == MAP_FAILED) {
 		td_verror(td, errno, "mmap");
 		td->orig_buffer = NULL;
-		if (td->mmapfd) {
+		if (td->mmapfd != 1) {
 			close(td->mmapfd);
-			unlink(td->o.mmapfile);
+			if (td->o.mmapfile)
+				unlink(td->o.mmapfile);
 		}
 
 		return 1;
diff --git a/options.c b/options.c
index 9096a32..50af7b4 100644
--- a/options.c
+++ b/options.c
@@ -269,7 +269,7 @@ static int ignore_error_type(struct thread_data *td, int etype, char *str)
 		} else {
 			error[i] = atoi(fname);
 			if (error[i] < 0)
-				error[i] = error[i];
+				error[i] = -error[i];
 		}
 		if (!error[i]) {
 			log_err("Unknown error %s, please use number value \n",
diff --git a/os/windows/posix/include/sys/un.h b/os/windows/posix/include/sys/un.h
index b9ea630..e418c6d 100644
--- a/os/windows/posix/include/sys/un.h
+++ b/os/windows/posix/include/sys/un.h
@@ -7,7 +7,7 @@ typedef int in_port_t;
  struct sockaddr_un
  {
 	sa_family_t	sun_family; /* Address family */
-	char		sun_path[]; /* Socket pathname */
+	char		sun_path[260]; /* Socket pathname */
 };
 
 #endif /* SYS_UN_H */
diff --git a/parse.c b/parse.c
index 83c59f7..188f728 100644
--- a/parse.c
+++ b/parse.c
@@ -624,7 +624,7 @@ static int __handle_option(struct fio_option *o, const char *ptr, void *data,
 			ret = 1;
 			for (i = 0; i < PARSE_MAX_VP; i++) {
 				vp = &posval[i];
-				if (!vp->ival || vp->ival[0] == '\0')
+				if (!vp->ival || vp->ival[0] == '\0' || !cp)
 					continue;
 				all_skipped = 0;
 				if (!strncmp(vp->ival, ptr, str_match_len(vp, ptr))) {
diff --git a/server.c b/server.c
index 3346445..077dce5 100644
--- a/server.c
+++ b/server.c
@@ -4,7 +4,6 @@
 #include <unistd.h>
 #include <limits.h>
 #include <errno.h>
-#include <fcntl.h>
 #include <sys/poll.h>
 #include <sys/types.h>
 #include <sys/wait.h>
@@ -68,7 +67,7 @@ static const char *fio_server_ops[FIO_NET_CMD_NR] = {
 	"DISK_UTIL",
 	"SERVER_START",
 	"ADD_JOB",
-	"CMD_RUN"
+	"CMD_RUN",
 	"CMD_IOLOG",
 };
 
@@ -209,7 +208,7 @@ static int verify_convert_cmd(struct fio_net_cmd *cmd)
  */
 struct fio_net_cmd *fio_net_recv_cmd(int sk)
 {
-	struct fio_net_cmd cmd, *cmdret = NULL;
+	struct fio_net_cmd cmd, *tmp, *cmdret = NULL;
 	size_t cmd_size = 0, pdu_offset = 0;
 	uint16_t crc;
 	int ret, first = 1;
@@ -232,7 +231,19 @@ struct fio_net_cmd *fio_net_recv_cmd(int sk)
 		} else
 			cmd_size += cmd.pdu_len;
 
-		cmdret = realloc(cmdret, cmd_size);
+		if (cmd_size / 1024 > FIO_SERVER_MAX_CMD_MB * 1024) {
+			log_err("fio: cmd+pdu too large (%llu)\n", (unsigned long long) cmd_size);
+			ret = 1;
+			break;
+		}
+
+		tmp = realloc(cmdret, cmd_size);
+		if (!tmp) {
+			log_err("fio: server failed allocating cmd\n");
+			ret = 1;
+			break;
+		}
+		cmdret = tmp;
 
 		if (first)
 			memcpy(cmdret, &cmd, sizeof(cmd));
@@ -843,14 +854,12 @@ static int accept_loop(int listen_sk)
 	struct sockaddr_in6 addr6;
 	socklen_t len = use_ipv6 ? sizeof(addr6) : sizeof(addr);
 	struct pollfd pfd;
-	int ret = 0, sk, flags, exitval = 0;
+	int ret = 0, sk, exitval = 0;
 	FLIST_HEAD(conn_list);
 
 	dprint(FD_NET, "server enter accept loop\n");
 
-	flags = fcntl(listen_sk, F_GETFL);
-	flags |= O_NONBLOCK;
-	fcntl(listen_sk, F_SETFL, flags);
+	fio_set_fd_nonblocking(listen_sk, "server");
 
 	while (!exit_backend) {
 		const char *from;
@@ -1095,7 +1104,8 @@ static void convert_dus(struct disk_util_stat *dst, struct disk_util_stat *src)
 {
 	int i;
 
-	strcpy((char *) dst->name, (char *) src->name);
+	dst->name[FIO_DU_NAME_SZ - 1] = '\0';
+	strncpy((char *) dst->name, (char *) src->name, FIO_DU_NAME_SZ - 1);
 
 	for (i = 0; i < 2; i++) {
 		dst->s.ios[i]		= cpu_to_le32(src->s.ios[i]);
@@ -1215,7 +1225,9 @@ int fio_send_iolog(struct thread_data *td, struct io_log *log, const char *name)
 	pdu.nr_samples = __cpu_to_le32(log->nr_samples);
 	pdu.log_type = cpu_to_le32(log->log_type);
 	pdu.compressed = cpu_to_le32(use_zlib);
-	strcpy((char *) pdu.name, name);
+
+	strncpy((char *) pdu.name, name, FIO_NET_NAME_MAX);
+	pdu.name[FIO_NET_NAME_MAX - 1] = '\0';
 
 	for (i = 0; i < log->nr_samples; i++) {
 		struct io_sample *s = &log->log[i];
@@ -1338,7 +1350,7 @@ static int fio_init_server_sock(void)
 
 	memset(&addr, 0, sizeof(addr));
 	addr.sun_family = AF_UNIX;
-	strcpy(addr.sun_path, bind_sock);
+	strncpy(addr.sun_path, bind_sock, sizeof(addr.sun_path) - 1);
 
 	len = sizeof(addr.sun_family) + strlen(bind_sock) + 1;
 
@@ -1367,6 +1379,8 @@ static int fio_init_server_connection(void)
 	if (sk < 0)
 		return sk;
 
+	memset(bind_str, 0, sizeof(bind_str));
+
 	if (!bind_sock) {
 		char *p, port[16];
 		const void *src;
@@ -1386,9 +1400,9 @@ static int fio_init_server_connection(void)
 		if (p)
 			strcat(p, port);
 		else
-			strcpy(bind_str, port);
+			strncpy(bind_str, port, sizeof(bind_str) - 1);
 	} else
-		strcpy(bind_str, bind_sock);
+		strncpy(bind_str, bind_sock, sizeof(bind_str) - 1);
 
 	log_info("fio: server listening on %s\n", bind_str);
 
diff --git a/server.h b/server.h
index 3a279f0..2958e73 100644
--- a/server.h
+++ b/server.h
@@ -41,6 +41,7 @@ enum {
 	FIO_SERVER_VER			= 33,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
+	FIO_SERVER_MAX_CMD_MB		= 2048,
 
 	FIO_NET_CMD_QUIT		= 1,
 	FIO_NET_CMD_EXIT		= 2,
diff --git a/stat.c b/stat.c
index 509c6f0..fbf0118 100644
--- a/stat.c
+++ b/stat.c
@@ -831,7 +831,7 @@ static void show_thread_status_terse_v2(struct thread_stat *ts,
 	log_info("\n");
 
 	/* Additional output if description is set */
-	if (ts->description)
+	if (strlen(ts->description))
 		log_info(";%s", ts->description);
 
 	log_info("\n");
@@ -1471,7 +1471,12 @@ void show_running_run_stats(void)
 	fio_mutex_down(stat_mutex);
 
 	if (!pthread_create(&thread, NULL, __show_running_run_stats, NULL)) {
-		pthread_detach(thread);
+		int err;
+
+		err = pthread_detach(thread);
+		if (err)
+			log_err("fio: DU thread detach failed: %s\n", strerror(err));
+
 		return;
 	}
 
@@ -1494,8 +1499,11 @@ static int check_status_file(void)
 		return 0;
 
 	temp_dir = getenv("TMPDIR");
-	if (temp_dir == NULL)
+	if (temp_dir == NULL) {
 		temp_dir = getenv("TEMP");
+		if (temp_dir && strlen(temp_dir) >= PATH_MAX)
+			temp_dir = NULL;
+	}
 	if (temp_dir == NULL)
 		temp_dir = "/tmp";
 
@@ -1800,7 +1808,11 @@ void add_bw_sample(struct thread_data *td, enum fio_ddir ddir, unsigned int bs,
 		if (!delta)
 			continue; /* No entries for interval */
 
-		rate = delta * 1000 / spent / 1024;
+		if (spent)
+			rate = delta * 1000 / spent / 1024;
+		else
+			rate = 0;
+
 		add_stat_sample(&ts->bw_stat[ddir], rate);
 
 		if (td->bw_log)
@@ -1835,7 +1847,11 @@ void add_iops_sample(struct thread_data *td, enum fio_ddir ddir, unsigned int bs
 		if (!delta)
 			continue; /* No entries for interval */
 
-		iops = (delta * 1000) / spent;
+		if (spent)
+			iops = (delta * 1000) / spent;
+		else
+			iops = 0;
+
 		add_stat_sample(&ts->iops_stat[ddir], iops);
 
 		if (td->iops_log)
diff --git a/verify.c b/verify.c
index 9eb532a..282a8cf 100644
--- a/verify.c
+++ b/verify.c
@@ -226,16 +226,32 @@ struct vcont {
 	unsigned int crc_len;
 };
 
+#define DUMP_BUF_SZ	255
+static int dump_buf_warned;
+
 static void dump_buf(char *buf, unsigned int len, unsigned long long offset,
 		     const char *type, struct fio_file *f)
 {
-	char *ptr, fname[256];
+	char *ptr, fname[DUMP_BUF_SZ];
+	size_t buf_left = DUMP_BUF_SZ;
 	int ret, fd;
 
 	ptr = strdup(f->file_name);
-	strcpy(fname, basename(ptr));
 
-	sprintf(fname + strlen(fname), ".%llu.%s", offset, type);
+	fname[DUMP_BUF_SZ - 1] = '\0';
+	strncpy(fname, basename(ptr), DUMP_BUF_SZ - 1);
+
+	buf_left -= strlen(fname);
+	if (buf_left <= 0) {
+		if (!dump_buf_warned) {
+			log_err("fio: verify failure dump buffer too small\n");
+			dump_buf_warned = 1;
+		}
+		free(ptr);
+		return;
+	}
+
+	snprintf(fname + strlen(fname), buf_left, ".%llu.%s", offset, type);
 
 	fd = open(fname, O_CREAT | O_TRUNC | O_WRONLY, 0644);
 	if (fd < 0) {
