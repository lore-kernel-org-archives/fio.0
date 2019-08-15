Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:35574 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729818AbfHOMAM (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 15 Aug 2019 08:00:12 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hyEQO-0001sq-8k
        for fio@vger.kernel.org; Thu, 15 Aug 2019 12:00:12 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190815120002.693802C22FD@kernel.dk>
Date: Thu, 15 Aug 2019 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 937ec971236d98089b63217635294c788ea00bce:

  t/zbd: Fix I/O bytes rounding errors (2019-08-08 21:36:32 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to dc54b6ca3209c2da3df30e96d097f6de29d56d24:

  eta: use struct jobs_eta_packed (2019-08-14 15:16:09 -0600)

----------------------------------------------------------------
Bart Van Assche (7):
      zbd: Declare local functions 'static'
      zbd: Improve robustness of unit tests
      Optimize the code that copies strings
      Refine packed annotations in stat.h
      Verify the absence of holes in struct jobs_eta at compile time
      Restore type checking in calc_thread_status()
      Makefile: Add 'fulltest' target

Jens Axboe (1):
      eta: use struct jobs_eta_packed

 Makefile                            | 17 ++++++++++++
 cconv.c                             |  7 +++--
 client.c                            |  5 ++--
 diskutil.c                          |  9 +++----
 engines/net.c                       |  6 ++---
 engines/sg.c                        |  4 +--
 eta.c                               | 13 ++++-----
 filesetup.c                         |  6 ++---
 gclient.c                           |  4 +--
 init.c                              | 19 ++++---------
 ioengines.c                         |  3 +--
 options.c                           |  3 +--
 parse.c                             |  6 ++---
 server.c                            | 26 ++++++++----------
 stat.c                              | 15 ++++++-----
 stat.h                              | 54 ++++++++++++++++++++-----------------
 t/zbd/run-tests-against-zoned-nullb |  2 +-
 t/zbd/test-zbd-support              |  4 +--
 verify.c                            |  3 +--
 zbd.c                               |  6 ++---
 20 files changed, 106 insertions(+), 106 deletions(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index fe02bf1d..7c21ef83 100644
--- a/Makefile
+++ b/Makefile
@@ -531,6 +531,21 @@ doc: tools/plot/fio2gnuplot.1
 test: fio
 	./fio --minimal --thread --exitall_on_error --runtime=1s --name=nulltest --ioengine=null --rw=randrw --iodepth=2 --norandommap --random_generator=tausworthe64 --size=16T --name=verifyfstest --filename=fiotestfile.tmp --unlink=1 --rw=write --verify=crc32c --verify_state_save=0 --size=16K
 
+fulltest:
+	sudo modprobe null_blk &&				 	\
+	if [ ! -e /usr/include/libzbc/zbc.h ]; then			\
+	  git clone https://github.com/hgst/libzbc &&		 	\
+	  (cd libzbc &&						 	\
+	   ./autogen.sh &&					 	\
+	   ./configure --prefix=/usr &&				 	\
+	   make -j &&						 	\
+	   sudo make install)						\
+	fi &&					 			\
+	sudo t/zbd/run-tests-against-regular-nullb &&		 	\
+	if [ -e /sys/module/null_blk/parameters/zoned ]; then		\
+		sudo t/zbd/run-tests-against-zoned-nullb;	 	\
+	fi
+
 install: $(PROGS) $(SCRIPTS) tools/plot/fio2gnuplot.1 FORCE
 	$(INSTALL) -m 755 -d $(DESTDIR)$(bindir)
 	$(INSTALL) $(PROGS) $(SCRIPTS) $(DESTDIR)$(bindir)
@@ -541,3 +556,5 @@ install: $(PROGS) $(SCRIPTS) tools/plot/fio2gnuplot.1 FORCE
 	$(INSTALL) -m 644 $(SRCDIR)/tools/hist/fiologparser_hist.py.1 $(DESTDIR)$(mandir)/man1
 	$(INSTALL) -m 755 -d $(DESTDIR)$(sharedir)
 	$(INSTALL) -m 644 $(SRCDIR)/tools/plot/*gpm $(DESTDIR)$(sharedir)/
+
+.PHONY: test fulltest
diff --git a/cconv.c b/cconv.c
index 50e45c63..0e657246 100644
--- a/cconv.c
+++ b/cconv.c
@@ -13,10 +13,9 @@ static void string_to_cpu(char **dst, const uint8_t *src)
 
 static void __string_to_net(uint8_t *dst, const char *src, size_t dst_size)
 {
-	if (src) {
-		dst[dst_size - 1] = '\0';
-		strncpy((char *) dst, src, dst_size - 1);
-	} else
+	if (src)
+		snprintf((char *) dst, dst_size, "%s", src);
+	else
 		dst[0] = '\0';
 }
 
diff --git a/client.c b/client.c
index 43cfbd43..e0047af0 100644
--- a/client.c
+++ b/client.c
@@ -520,7 +520,7 @@ static void probe_client(struct fio_client *client)
 
 	sname = server_name(client, buf, sizeof(buf));
 	memset(pdu.server, 0, sizeof(pdu.server));
-	strncpy((char *) pdu.server, sname, sizeof(pdu.server) - 1);
+	snprintf((char *) pdu.server, sizeof(pdu.server), "%s", sname);
 
 	fio_net_send_cmd(client->fd, FIO_NET_CMD_PROBE, &pdu, sizeof(pdu), &tag, &client->cmd_list);
 }
@@ -574,7 +574,8 @@ static int fio_client_connect_sock(struct fio_client *client)
 
 	memset(addr, 0, sizeof(*addr));
 	addr->sun_family = AF_UNIX;
-	strncpy(addr->sun_path, client->hostname, sizeof(addr->sun_path) - 1);
+	snprintf(addr->sun_path, sizeof(addr->sun_path), "%s",
+		 client->hostname);
 
 	fd = socket(AF_UNIX, SOCK_STREAM, 0);
 	if (fd < 0) {
diff --git a/diskutil.c b/diskutil.c
index 7be4c022..f0744015 100644
--- a/diskutil.c
+++ b/diskutil.c
@@ -181,8 +181,7 @@ static int get_device_numbers(char *file_name, int *maj, int *min)
 		/*
 		 * must be a file, open "." in that path
 		 */
-		tempname[PATH_MAX - 1] = '\0';
-		strncpy(tempname, file_name, PATH_MAX - 1);
+		snprintf(tempname, ARRAY_SIZE(tempname), "%s", file_name);
 		p = dirname(tempname);
 		if (stat(p, &st)) {
 			perror("disk util stat");
@@ -314,7 +313,8 @@ static struct disk_util *disk_util_add(struct thread_data *td, int majdev,
 		sfree(du);
 		return NULL;
 	}
-	strncpy((char *) du->dus.name, basename(path), FIO_DU_NAME_SZ - 1);
+	snprintf((char *) du->dus.name, ARRAY_SIZE(du->dus.name), "%s",
+		 basename(path));
 	du->sysfs_root = strdup(path);
 	du->major = majdev;
 	du->minor = mindev;
@@ -435,8 +435,7 @@ static struct disk_util *__init_per_file_disk_util(struct thread_data *td,
 			log_err("unknown sysfs layout\n");
 			return NULL;
 		}
-		tmp[PATH_MAX - 1] = '\0';
-		strncpy(tmp, p, PATH_MAX - 1);
+		snprintf(tmp, ARRAY_SIZE(tmp), "%s", p);
 		sprintf(path, "%s", tmp);
 	}
 
diff --git a/engines/net.c b/engines/net.c
index ca6fb344..91f25774 100644
--- a/engines/net.c
+++ b/engines/net.c
@@ -1105,8 +1105,7 @@ static int fio_netio_setup_connect_unix(struct thread_data *td,
 	struct sockaddr_un *soun = &nd->addr_un;
 
 	soun->sun_family = AF_UNIX;
-	memset(soun->sun_path, 0, sizeof(soun->sun_path));
-	strncpy(soun->sun_path, path, sizeof(soun->sun_path) - 1);
+	snprintf(soun->sun_path, sizeof(soun->sun_path), "%s", path);
 	return 0;
 }
 
@@ -1135,9 +1134,8 @@ static int fio_netio_setup_listen_unix(struct thread_data *td, const char *path)
 
 	mode = umask(000);
 
-	memset(addr, 0, sizeof(*addr));
 	addr->sun_family = AF_UNIX;
-	strncpy(addr->sun_path, path, sizeof(addr->sun_path) - 1);
+	snprintf(addr->sun_path, sizeof(addr->sun_path), "%s", path);
 	unlink(path);
 
 	len = sizeof(addr->sun_family) + strlen(path) + 1;
diff --git a/engines/sg.c b/engines/sg.c
index c46b9aba..a1a6de4c 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -1181,8 +1181,8 @@ static char *fio_sgio_errdetails(struct io_u *io_u)
 	}
 
 	if (!(hdr->info & SG_INFO_CHECK) && !strlen(msg))
-		strncpy(msg, "SG Driver did not report a Host, Driver or Device check",
-			MAXERRDETAIL - 1);
+		snprintf(msg, MAXERRDETAIL, "%s",
+			 "SG Driver did not report a Host, Driver or Device check");
 
 	return msg;
 }
diff --git a/eta.c b/eta.c
index 647a1bdd..9950ef30 100644
--- a/eta.c
+++ b/eta.c
@@ -392,9 +392,6 @@ bool calc_thread_status(struct jobs_eta *je, int force)
 	static unsigned long long disp_io_iops[DDIR_RWDIR_CNT];
 	static struct timespec rate_prev_time, disp_prev_time;
 
-	void *je_rate = (void *) je->rate;
-	void *je_iops = (void *) je->iops;
-
 	if (!force) {
 		if (!(output_format & FIO_OUTPUT_NORMAL) &&
 		    f_out == stdout)
@@ -510,7 +507,7 @@ bool calc_thread_status(struct jobs_eta *je, int force)
 
 	if (write_bw_log && rate_time > bw_avg_time && !in_ramp_time(td)) {
 		calc_rate(unified_rw_rep, rate_time, io_bytes, rate_io_bytes,
-				je_rate);
+				je->rate);
 		memcpy(&rate_prev_time, &now, sizeof(now));
 		add_agg_sample(sample_val(je->rate[DDIR_READ]), DDIR_READ, 0);
 		add_agg_sample(sample_val(je->rate[DDIR_WRITE]), DDIR_WRITE, 0);
@@ -522,8 +519,8 @@ bool calc_thread_status(struct jobs_eta *je, int force)
 	if (!force && !eta_time_within_slack(disp_time))
 		return false;
 
-	calc_rate(unified_rw_rep, disp_time, io_bytes, disp_io_bytes, je_rate);
-	calc_iops(unified_rw_rep, disp_time, io_iops, disp_io_iops, je_iops);
+	calc_rate(unified_rw_rep, disp_time, io_bytes, disp_io_bytes, je->rate);
+	calc_iops(unified_rw_rep, disp_time, io_iops, disp_io_iops, je->iops);
 
 	memcpy(&disp_prev_time, &now, sizeof(now));
 
@@ -736,6 +733,10 @@ void print_thread_status(void)
 
 void print_status_init(int thr_number)
 {
+	struct jobs_eta_packed jep;
+
+	compiletime_assert(sizeof(struct jobs_eta) == sizeof(jep), "jobs_eta");
+
 	DRD_IGNORE_VAR(__run_str);
 	__run_str[thr_number] = 'P';
 	update_condensed_str(__run_str, run_str);
diff --git a/filesetup.c b/filesetup.c
index 17fa31fb..57eca1bf 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -805,8 +805,7 @@ static unsigned long long get_fs_free_counts(struct thread_data *td)
 		} else if (f->filetype != FIO_TYPE_FILE)
 			continue;
 
-		buf[255] = '\0';
-		strncpy(buf, f->file_name, 255);
+		snprintf(buf, ARRAY_SIZE(buf), "%s", f->file_name);
 
 		if (stat(buf, &sb) < 0) {
 			if (errno != ENOENT)
@@ -829,8 +828,7 @@ static unsigned long long get_fs_free_counts(struct thread_data *td)
 			continue;
 
 		fm = calloc(1, sizeof(*fm));
-		strncpy(fm->__base, buf, sizeof(fm->__base));
-		fm->__base[255] = '\0'; 
+		snprintf(fm->__base, ARRAY_SIZE(fm->__base), "%s", buf);
 		fm->base = basename(fm->__base);
 		fm->key = sb.st_dev;
 		flist_add(&fm->list, &list);
diff --git a/gclient.c b/gclient.c
index 04275a13..64324177 100644
--- a/gclient.c
+++ b/gclient.c
@@ -318,7 +318,7 @@ static void gfio_update_thread_status(struct gui_entry *ge,
 	static char message[100];
 	const char *m = message;
 
-	strncpy(message, status_message, sizeof(message) - 1);
+	snprintf(message, sizeof(message), "%s", status_message);
 	gtk_progress_bar_set_text(GTK_PROGRESS_BAR(ge->thread_status_pb), m);
 	gtk_progress_bar_set_fraction(GTK_PROGRESS_BAR(ge->thread_status_pb), perc / 100.0);
 	gtk_widget_queue_draw(ge->ui->window);
@@ -330,7 +330,7 @@ static void gfio_update_thread_status_all(struct gui *ui, char *status_message,
 	static char message[100];
 	const char *m = message;
 
-	strncpy(message, status_message, sizeof(message) - 1);
+	strncpy(message, sizeof(message), "%s", status_message);
 	gtk_progress_bar_set_text(GTK_PROGRESS_BAR(ui->thread_status_pb), m);
 	gtk_progress_bar_set_fraction(GTK_PROGRESS_BAR(ui->thread_status_pb), perc / 100.0);
 	gtk_widget_queue_draw(ui->window);
diff --git a/init.c b/init.c
index c9f6198e..63f2168e 100644
--- a/init.c
+++ b/init.c
@@ -1273,8 +1273,7 @@ static char *make_filename(char *buf, size_t buf_size,struct thread_options *o,
 	for (f = &fpre_keywords[0]; f->keyword; f++)
 		f->strlen = strlen(f->keyword);
 
-	buf[buf_size - 1] = '\0';
-	strncpy(buf, o->filename_format, buf_size - 1);
+	snprintf(buf, buf_size, "%s", o->filename_format);
 
 	memset(copy, 0, sizeof(copy));
 	for (f = &fpre_keywords[0]; f->keyword; f++) {
@@ -1353,7 +1352,7 @@ static char *make_filename(char *buf, size_t buf_size,struct thread_options *o,
 			if (post_start)
 				strncpy(dst, buf + post_start, dst_left);
 
-			strncpy(buf, copy, buf_size - 1);
+			snprintf(buf, buf_size, "%s", copy);
 		} while (1);
 	}
 
@@ -2029,20 +2028,12 @@ static int __parse_jobs_ini(struct thread_data *td,
 				 */
 				if (access(filename, F_OK) &&
 				    (ts = strrchr(file, '/'))) {
-					int len = ts - file +
-						strlen(filename) + 2;
-
-					if (!(full_fn = calloc(1, len))) {
+					if (asprintf(&full_fn, "%.*s%s",
+						 (int)(ts - file + 1), file,
+						 filename) < 0) {
 						ret = ENOMEM;
 						break;
 					}
-
-					strncpy(full_fn,
-						file, (ts - file) + 1);
-					strncpy(full_fn + (ts - file) + 1,
-						filename,
-						len - (ts - file) - 1);
-					full_fn[len - 1] = 0;
 					filename = full_fn;
 				}
 
diff --git a/ioengines.c b/ioengines.c
index aa4ccd27..40fa75c3 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -125,8 +125,7 @@ static struct ioengine_ops *__load_ioengine(const char *name)
 {
 	char engine[64];
 
-	engine[sizeof(engine) - 1] = '\0';
-	strncpy(engine, name, sizeof(engine) - 1);
+	snprintf(engine, sizeof(engine), "%s", name);
 
 	/*
 	 * linux libaio has alias names, so convert to what we want
diff --git a/options.c b/options.c
index f4c9bedf..447f231e 100644
--- a/options.c
+++ b/options.c
@@ -4902,8 +4902,7 @@ char *fio_option_dup_subs(const char *opt)
 		return NULL;
 	}
 
-	in[OPT_LEN_MAX] = '\0';
-	strncpy(in, opt, OPT_LEN_MAX);
+	snprintf(in, sizeof(in), "%s", opt);
 
 	while (*inptr && nchr > 0) {
 		if (inptr[0] == '$' && inptr[1] == '{') {
diff --git a/parse.c b/parse.c
index a7d4516e..c4fd4626 100644
--- a/parse.c
+++ b/parse.c
@@ -602,8 +602,7 @@ static int __handle_option(const struct fio_option *o, const char *ptr,
 		if (!is_time && o->is_time)
 			is_time = o->is_time;
 
-		tmp[sizeof(tmp) - 1] = '\0';
-		strncpy(tmp, ptr, sizeof(tmp) - 1);
+		snprintf(tmp, sizeof(tmp), "%s", ptr);
 		p = strchr(tmp, ',');
 		if (p)
 			*p = '\0';
@@ -829,8 +828,7 @@ static int __handle_option(const struct fio_option *o, const char *ptr,
 		char tmp[128];
 		char *p1, *p2;
 
-		tmp[sizeof(tmp) - 1] = '\0';
-		strncpy(tmp, ptr, sizeof(tmp) - 1);
+		snprintf(tmp, sizeof(tmp), "%s", ptr);
 
 		/* Handle bsrange with separate read,write values: */
 		p1 = strchr(tmp, ',');
diff --git a/server.c b/server.c
index 23e549a5..e7846227 100644
--- a/server.c
+++ b/server.c
@@ -865,7 +865,8 @@ static int handle_probe_cmd(struct fio_net_cmd *cmd)
 	strcpy(me, (char *) pdu->server);
 
 	gethostname((char *) probe.hostname, sizeof(probe.hostname));
-	strncpy((char *) probe.fio_version, fio_version_string, sizeof(probe.fio_version) - 1);
+	snprintf((char *) probe.fio_version, sizeof(probe.fio_version), "%s",
+		 fio_version_string);
 
 	/*
 	 * If the client supports compression and we do too, then enable it
@@ -1470,12 +1471,10 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
 
 	memset(&p, 0, sizeof(p));
 
-	strncpy(p.ts.name, ts->name, FIO_JOBNAME_SIZE);
-	p.ts.name[FIO_JOBNAME_SIZE - 1] = '\0';
-	strncpy(p.ts.verror, ts->verror, FIO_VERROR_SIZE);
-	p.ts.verror[FIO_VERROR_SIZE - 1] = '\0';
-	strncpy(p.ts.description, ts->description, FIO_JOBDESC_SIZE);
-	p.ts.description[FIO_JOBDESC_SIZE - 1] = '\0';
+	snprintf(p.ts.name, sizeof(p.ts.name), "%s", ts->name);
+	snprintf(p.ts.verror, sizeof(p.ts.verror), "%s", ts->verror);
+	snprintf(p.ts.description, sizeof(p.ts.description), "%s",
+		 ts->description);
 
 	p.ts.error		= cpu_to_le32(ts->error);
 	p.ts.thread_number	= cpu_to_le32(ts->thread_number);
@@ -1666,8 +1665,7 @@ static void convert_dus(struct disk_util_stat *dst, struct disk_util_stat *src)
 {
 	int i;
 
-	dst->name[FIO_DU_NAME_SZ - 1] = '\0';
-	strncpy((char *) dst->name, (char *) src->name, FIO_DU_NAME_SZ - 1);
+	snprintf((char *) dst->name, sizeof(dst->name), "%s", src->name);
 
 	for (i = 0; i < 2; i++) {
 		dst->s.ios[i]		= cpu_to_le64(src->s.ios[i]);
@@ -1977,8 +1975,7 @@ int fio_send_iolog(struct thread_data *td, struct io_log *log, const char *name)
 	else
 		pdu.compressed = 0;
 
-	strncpy((char *) pdu.name, name, FIO_NET_NAME_MAX);
-	pdu.name[FIO_NET_NAME_MAX - 1] = '\0';
+	snprintf((char *) pdu.name, sizeof(pdu.name), "%s", name);
 
 	/*
 	 * We can't do this for a pre-compressed log, but for that case,
@@ -2195,9 +2192,8 @@ static int fio_init_server_sock(void)
 
 	mode = umask(000);
 
-	memset(&addr, 0, sizeof(addr));
 	addr.sun_family = AF_UNIX;
-	strncpy(addr.sun_path, bind_sock, sizeof(addr.sun_path) - 1);
+	snprintf(addr.sun_path, sizeof(addr.sun_path), "%s", bind_sock);
 
 	len = sizeof(addr.sun_family) + strlen(bind_sock) + 1;
 
@@ -2247,9 +2243,9 @@ static int fio_init_server_connection(void)
 		if (p)
 			strcat(p, port);
 		else
-			strncpy(bind_str, port, sizeof(bind_str) - 1);
+			snprintf(bind_str, sizeof(bind_str), "%s", port);
 	} else
-		strncpy(bind_str, bind_sock, sizeof(bind_str) - 1);
+		snprintf(bind_str, sizeof(bind_str), "%s", bind_sock);
 
 	log_info("fio: server listening on %s\n", bind_str);
 
diff --git a/stat.c b/stat.c
index bf87917c..33637900 100644
--- a/stat.c
+++ b/stat.c
@@ -1828,10 +1828,11 @@ void __show_run_stats(void)
 			/*
 			 * These are per-group shared already
 			 */
-			strncpy(ts->name, td->o.name, FIO_JOBNAME_SIZE - 1);
+			snprintf(ts->name, sizeof(ts->name), "%s", td->o.name);
 			if (td->o.description)
-				strncpy(ts->description, td->o.description,
-						FIO_JOBDESC_SIZE - 1);
+				snprintf(ts->description,
+					 sizeof(ts->description), "%s",
+					 td->o.description);
 			else
 				memset(ts->description, 0, FIO_JOBDESC_SIZE);
 
@@ -1868,12 +1869,12 @@ void __show_run_stats(void)
 			if (!td->error && td->o.continue_on_error &&
 			    td->first_error) {
 				ts->error = td->first_error;
-				ts->verror[sizeof(ts->verror) - 1] = '\0';
-				strncpy(ts->verror, td->verror, sizeof(ts->verror) - 1);
+				snprintf(ts->verror, sizeof(ts->verror), "%s",
+					 td->verror);
 			} else  if (td->error) {
 				ts->error = td->error;
-				ts->verror[sizeof(ts->verror) - 1] = '\0';
-				strncpy(ts->verror, td->verror, sizeof(ts->verror) - 1);
+				snprintf(ts->verror, sizeof(ts->verror), "%s",
+					 td->verror);
 			}
 		}
 
diff --git a/stat.h b/stat.h
index e9551381..c209ab6c 100644
--- a/stat.h
+++ b/stat.h
@@ -251,32 +251,36 @@ struct thread_stat {
 	uint64_t cachemiss;
 } __attribute__((packed));
 
-struct jobs_eta {
-	uint32_t nr_running;
-	uint32_t nr_ramp;
-
-	uint32_t nr_pending;
-	uint32_t nr_setting_up;
-
-	uint64_t m_rate[DDIR_RWDIR_CNT], t_rate[DDIR_RWDIR_CNT];
-	uint64_t rate[DDIR_RWDIR_CNT];
-	uint32_t m_iops[DDIR_RWDIR_CNT], t_iops[DDIR_RWDIR_CNT];
-	uint32_t iops[DDIR_RWDIR_CNT];
-	uint64_t elapsed_sec;
-	uint64_t eta_sec;
-	uint32_t is_pow2;
-	uint32_t unit_base;
-
-	uint32_t sig_figs;
-
-	uint32_t files_open;
+#define JOBS_ETA {							\
+	uint32_t nr_running;						\
+	uint32_t nr_ramp;						\
+									\
+	uint32_t nr_pending;						\
+	uint32_t nr_setting_up;						\
+									\
+	uint64_t m_rate[DDIR_RWDIR_CNT], t_rate[DDIR_RWDIR_CNT];	\
+	uint64_t rate[DDIR_RWDIR_CNT];					\
+	uint32_t m_iops[DDIR_RWDIR_CNT] __attribute__((packed));	\
+	uint32_t t_iops[DDIR_RWDIR_CNT] __attribute__((packed));	\
+	uint32_t iops[DDIR_RWDIR_CNT] __attribute__((packed));		\
+	uint64_t elapsed_sec __attribute__((packed));			\
+	uint64_t eta_sec __attribute__((packed));			\
+	uint32_t is_pow2;						\
+	uint32_t unit_base;						\
+									\
+	uint32_t sig_figs;						\
+									\
+	uint32_t files_open;						\
+									\
+	/*								\
+	 * Network 'copy' of run_str[]					\
+	 */								\
+	uint32_t nr_threads;						\
+	uint8_t run_str[];						\
+}
 
-	/*
-	 * Network 'copy' of run_str[]
-	 */
-	uint32_t nr_threads;
-	uint8_t run_str[];
-} __attribute__((packed));
+struct jobs_eta JOBS_ETA;
+struct jobs_eta_packed JOBS_ETA __attribute__((packed));
 
 struct io_u_plat_entry {
 	struct flist_head list;
diff --git a/t/zbd/run-tests-against-zoned-nullb b/t/zbd/run-tests-against-zoned-nullb
index 9336716d..0952011c 100755
--- a/t/zbd/run-tests-against-zoned-nullb
+++ b/t/zbd/run-tests-against-zoned-nullb
@@ -24,6 +24,6 @@ modprobe null_blk nr_devices=0 &&
     echo 4096 > blocksize &&
     echo 1024 > size &&
     echo 1 > memory_backed &&
-    echo 1 > power
+    echo 1 > power || exit $?
 
 "${scriptdir}"/test-zbd-support "$@" /dev/nullb0
diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 6fb48ef0..ed54a0aa 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -772,8 +772,8 @@ source "$(dirname "$0")/functions" || exit $?
 dev=$1
 realdev=$(readlink -f "$dev")
 basename=$(basename "$realdev")
-major=$((0x$(stat -L -c '%t' "$realdev")))
-minor=$((0x$(stat -L -c '%T' "$realdev")))
+major=$((0x$(stat -L -c '%t' "$realdev"))) || exit $?
+minor=$((0x$(stat -L -c '%T' "$realdev"))) || exit $?
 disk_size=$(($(<"/sys/dev/block/$major:$minor/size")*512))
 # When the target is a partition device, get basename of its holder device to
 # access sysfs path of the holder device
diff --git a/verify.c b/verify.c
index f79ab43a..48ba051d 100644
--- a/verify.c
+++ b/verify.c
@@ -1635,8 +1635,7 @@ struct all_io_list *get_all_io_list(int save_mask, size_t *sz)
 			s->rand.state32.s[3] = 0;
 			s->rand.use64 = 0;
 		}
-		s->name[sizeof(s->name) - 1] = '\0';
-		strncpy((char *) s->name, td->o.name, sizeof(s->name) - 1);
+		snprintf((char *) s->name, sizeof(s->name), "%s", td->o.name);
 		next = io_list_next(s);
 	}
 
diff --git a/zbd.c b/zbd.c
index d7e91e37..2383c57d 100644
--- a/zbd.c
+++ b/zbd.c
@@ -481,7 +481,7 @@ out:
  *
  * Returns 0 upon success and a negative error code upon failure.
  */
-int zbd_create_zone_info(struct thread_data *td, struct fio_file *f)
+static int zbd_create_zone_info(struct thread_data *td, struct fio_file *f)
 {
 	enum blk_zoned_model zbd_model;
 	int ret = 0;
@@ -933,8 +933,8 @@ static void zbd_close_zone(struct thread_data *td, const struct fio_file *f,
  * a multiple of the fio block size. The caller must neither hold z->mutex
  * nor f->zbd_info->mutex. Returns with z->mutex held upon success.
  */
-struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
-					       struct io_u *io_u)
+static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
+						      struct io_u *io_u)
 {
 	const uint32_t min_bs = td->o.min_bs[io_u->ddir];
 	const struct fio_file *f = io_u->file;

