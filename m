Return-Path: <bart.vanassche@gmail.com>
Return-Path: <bart.vanassche@gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 3/7] Optimize the code that copies strings
Date: Wed, 14 Aug 2019 13:10:08 -0700
Message-Id: <20190814201012.253060-4-bvanassche@acm.org>
In-Reply-To: <20190814201012.253060-1-bvanassche@acm.org>
References: <20190814201012.253060-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>, Damien Le Moal <damien.lemoal@wdc.com>
List-ID: <fio@vger.kernel.org>

Using strncpy() to copy strings is suboptimal because strncpy writes a
bunch of additional unnecessary null bytes. Use snprintf() instead of
strncpy(). An additional advantage of snprintf() is that it guarantees
that the output string is '\0'-terminated.

This patch is an improvement for commit 32e31c8c5f7b ("Fix string copy
compilation warnings").

Cc: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 cconv.c       |  7 +++----
 client.c      |  5 +++--
 diskutil.c    |  9 ++++-----
 engines/net.c |  6 ++----
 engines/sg.c  |  4 ++--
 filesetup.c   |  6 ++----
 gclient.c     |  4 ++--
 init.c        | 19 +++++--------------
 ioengines.c   |  3 +--
 options.c     |  3 +--
 parse.c       |  6 ++----
 server.c      | 26 +++++++++++---------------
 stat.c        | 15 ++++++++-------
 verify.c      |  3 +--
 14 files changed, 47 insertions(+), 69 deletions(-)

diff --git a/cconv.c b/cconv.c
index 50e45c63a636..0e6572462788 100644
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
index 43cfbd43b9d3..e0047af06a3e 100644
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
index 7be4c022431e..f074401501ba 100644
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
index ca6fb344b897..91f25774690a 100644
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
index c46b9abaec87..a1a6de4ce248 100644
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
diff --git a/filesetup.c b/filesetup.c
index 17fa31fb3cd4..57eca1bf5bf0 100644
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
index 04275a1384c2..64324177ef1a 100644
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
index c9f6198ea63a..63f2168eabcb 100644
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
index aa4ccd2755c9..40fa75c382b4 100644
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
index f4c9bedf377f..447f231e7148 100644
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
index a7d4516e4702..c4fd4626df9f 100644
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
index 23e549a590a7..e7846227f2b1 100644
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
index bf87917c2956..33637900df62 100644
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
 
diff --git a/verify.c b/verify.c
index f79ab43aab6b..48ba051da3ad 100644
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
 
-- 
2.22.0.rc1


