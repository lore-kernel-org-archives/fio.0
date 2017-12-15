Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:52695 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755747AbdLONAM (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 15 Dec 2017 08:00:12 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1ePpb1-0004V9-7k
        for fio@vger.kernel.org; Fri, 15 Dec 2017 13:00:11 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20171215130002.2E62E2C009F@kernel.dk>
Date: Fri, 15 Dec 2017 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c20c361255683ee138f0c239e48b315e25725f7e:

  server: initialize first iolog header properly (2017-12-13 08:44:34 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to db37d89074ed204c9c2bd010e72f63dcf4725715:

  Allow configurable ETA intervals (2017-12-14 11:51:41 -0700)

----------------------------------------------------------------
Jeff Furlong (1):
      Fix Windows local time

Jens Axboe (4):
      server: cleanup iolog pdu prep
      server: convert more memset to on-stack initialization
      client: respect --eta=never for networked connections
      Allow configurable ETA intervals

Robert Elliott (1):
      .gitignore: ignore tags files and additional output binaries

 .gitignore         | 12 ++++++++++
 HOWTO              | 11 ++++++++-
 client.c           |  5 +++-
 eta.c              | 13 +++++++----
 fio.1              |  9 +++++++-
 fio.h              |  3 +++
 init.c             | 29 +++++++++++++++++++++++
 os/windows/posix.c |  4 +++-
 server.c           | 68 +++++++++++++++++++++++++-----------------------------
 9 files changed, 110 insertions(+), 44 deletions(-)

---

Diff of recent changes:

diff --git a/.gitignore b/.gitignore
index 463b53a..0c8cb7c 100644
--- a/.gitignore
+++ b/.gitignore
@@ -8,7 +8,19 @@
 /config.log
 /cscope.out
 /fio
+/gfio
+/t/axmap
+/t/fio-btrace2fio
+/t/fio-dedupe
+/t/fio-genzipf
+/t/fio-verify-state
+/t/gen-rand
+/t/ieee754
+/t/lfsr-test
+/t/stest
 y.tab.*
 lex.yy.c
 *.un~
 doc/output
+/tags
+/TAGS
diff --git a/HOWTO b/HOWTO
index 563ca93..78fa6cc 100644
--- a/HOWTO
+++ b/HOWTO
@@ -173,7 +173,16 @@ Command line options
 .. option:: --eta=when
 
 	Specifies when real-time ETA estimate should be printed.  `when` may be
-	`always`, `never` or `auto`.
+	`always`, `never` or `auto`. `auto` is the default, it prints ETA
+	when requested if the output is a TTY. `always` disregards the output
+	type, and prints ETA when requested. `never` never prints ETA.
+
+.. option:: --eta-interval=time
+
+	By default, fio requests client ETA status roughly every second. With
+	this option, the interval is configurable. Fio imposes a minimum
+	allowed time to avoid flooding the console, less than 250 msec is
+	not supported.
 
 .. option:: --eta-newline=time
 
diff --git a/client.c b/client.c
index 2b136a0..18247ef 100644
--- a/client.c
+++ b/client.c
@@ -1834,6 +1834,9 @@ static void request_client_etas(struct client_ops *ops)
 	struct client_eta *eta;
 	int skipped = 0;
 
+	if (eta_print == FIO_ETA_NEVER)
+		return;
+
 	dprint(FD_NET, "client: request eta (%d)\n", nr_clients);
 
 	eta = calloc(1, sizeof(*eta) + __THREAD_RUNSTR_SZ(REAL_MAX_JOBS));
@@ -1997,7 +2000,7 @@ int fio_handle_clients(struct client_ops *ops)
 			int timeout;
 
 			fio_gettime(&ts, NULL);
-			if (mtime_since(&eta_ts, &ts) >= 900) {
+			if (eta_time_within_slack(mtime_since(&eta_ts, &ts))) {
 				request_client_etas(ops);
 				memcpy(&eta_ts, &ts, sizeof(ts));
 
diff --git a/eta.c b/eta.c
index 1b0b000..8b77daf 100644
--- a/eta.c
+++ b/eta.c
@@ -348,6 +348,14 @@ static void calc_iops(int unified_rw_rep, unsigned long mtime,
 }
 
 /*
+ * Allow a little slack - if we're within 95% of the time, allow ETA.
+ */
+bool eta_time_within_slack(unsigned int time)
+{
+	return time > ((eta_interval_msec * 95) / 100);
+}
+
+/*
  * Print status of the jobs we know about. This includes rate estimates,
  * ETA, thread state, etc.
  */
@@ -489,10 +497,7 @@ bool calc_thread_status(struct jobs_eta *je, int force)
 
 	disp_time = mtime_since(&disp_prev_time, &now);
 
-	/*
-	 * Allow a little slack, the target is to print it every 1000 msecs
-	 */
-	if (!force && disp_time < 900)
+	if (!force && !eta_time_within_slack(disp_time))
 		return false;
 
 	calc_rate(unified_rw_rep, disp_time, io_bytes, disp_io_bytes, je->rate);
diff --git a/fio.1 b/fio.1
index 57ab665..70eeeb0 100644
--- a/fio.1
+++ b/fio.1
@@ -77,7 +77,14 @@ the I/O engine core to prevent writes due to unknown user space bug(s).
 .TP
 .BI \-\-eta \fR=\fPwhen
 Specifies when real\-time ETA estimate should be printed. \fIwhen\fR may
-be `always', `never' or `auto'.
+be `always', `never' or `auto'. `auto' is the default, it prints ETA when
+requested if the output is a TTY. `always' disregards the output type, and
+prints ETA when requested. `never' never prints ETA.
+.TP
+.BI \-\-eta\-interval \fR=\fPtime
+By default, fio requests client ETA status roughly every second. With this
+option, the interval is configurable. Fio imposes a minimum allowed time to
+avoid flooding the console, less than 250 msec is not supported.
 .TP
 .BI \-\-eta\-newline \fR=\fPtime
 Force a new line for every \fItime\fR period passed. When the unit is omitted,
diff --git a/fio.h b/fio.h
index 8a65646..b3b95ef 100644
--- a/fio.h
+++ b/fio.h
@@ -505,6 +505,7 @@ extern uintptr_t page_mask, page_size;
 extern int read_only;
 extern int eta_print;
 extern int eta_new_line;
+extern unsigned int eta_interval_msec;
 extern unsigned long done_secs;
 extern int fio_gtod_offload;
 extern int fio_gtod_cpu;
@@ -525,6 +526,8 @@ extern char *aux_path;
 
 extern struct thread_data *threads;
 
+extern bool eta_time_within_slack(unsigned int time);
+
 static inline void fio_ro_check(const struct thread_data *td, struct io_u *io_u)
 {
 	assert(!(io_u->ddir == DDIR_WRITE && !td_write(td)));
diff --git a/init.c b/init.c
index b77b299..b9da713 100644
--- a/init.c
+++ b/init.c
@@ -51,6 +51,7 @@ static int nr_job_sections;
 int exitall_on_terminate = 0;
 int output_format = FIO_OUTPUT_NORMAL;
 int eta_print = FIO_ETA_AUTO;
+unsigned int eta_interval_msec = 1000;
 int eta_new_line = 0;
 FILE *f_out = NULL;
 FILE *f_err = NULL;
@@ -154,6 +155,11 @@ static struct option l_opts[FIO_NR_OPTIONS] = {
 		.val		= 'e' | FIO_CLIENT_FLAG,
 	},
 	{
+		.name		= (char *) "eta-interval",
+		.has_arg	= required_argument,
+		.val		= 'O' | FIO_CLIENT_FLAG,
+	},
+	{
 		.name		= (char *) "eta-newline",
 		.has_arg	= required_argument,
 		.val		= 'E' | FIO_CLIENT_FLAG,
@@ -2504,8 +2510,31 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 				log_err("fio: failed parsing eta time %s\n", optarg);
 				exit_val = 1;
 				do_exit++;
+				break;
 			}
 			eta_new_line = t / 1000;
+			if (!eta_new_line) {
+				log_err("fio: eta new line time too short\n");
+				exit_val = 1;
+				do_exit++;
+			}
+			break;
+			}
+		case 'O': {
+			long long t = 0;
+
+			if (check_str_time(optarg, &t, 1)) {
+				log_err("fio: failed parsing eta interval %s\n", optarg);
+				exit_val = 1;
+				do_exit++;
+				break;
+			}
+			eta_interval_msec = t / 1000;
+			if (eta_interval_msec < DISK_UTIL_MSEC) {
+				log_err("fio: eta interval time too short (%umsec min)\n", DISK_UTIL_MSEC);
+				exit_val = 1;
+				do_exit++;
+			}
 			break;
 			}
 		case 'd':
diff --git a/os/windows/posix.c b/os/windows/posix.c
index 00f0335..17e18a1 100755
--- a/os/windows/posix.c
+++ b/os/windows/posix.c
@@ -228,12 +228,14 @@ void Time_tToSystemTime(time_t dosTime, SYSTEMTIME *systemTime)
 {
     FILETIME utcFT;
     LONGLONG jan1970;
+	SYSTEMTIME tempSystemTime;
 
     jan1970 = Int32x32To64(dosTime, 10000000) + 116444736000000000;
     utcFT.dwLowDateTime = (DWORD)jan1970;
     utcFT.dwHighDateTime = jan1970 >> 32;
 
-    FileTimeToSystemTime((FILETIME*)&utcFT, systemTime);
+    FileTimeToSystemTime((FILETIME*)&utcFT, &tempSystemTime);
+	SystemTimeToTzSpecificLocalTime(NULL, &tempSystemTime, systemTime);
 }
 
 char* ctime_r(const time_t *t, char *buf)
diff --git a/server.c b/server.c
index 6225614..54d703d 100644
--- a/server.c
+++ b/server.c
@@ -844,25 +844,24 @@ static int handle_jobline_cmd(struct fio_net_cmd *cmd)
 static int handle_probe_cmd(struct fio_net_cmd *cmd)
 {
 	struct cmd_client_probe_pdu *pdu = (struct cmd_client_probe_pdu *) cmd->payload;
-	struct cmd_probe_reply_pdu probe;
 	uint64_t tag = cmd->tag;
+	struct cmd_probe_reply_pdu probe = {
+#ifdef CONFIG_BIG_ENDIAN
+		.bigendian	= 1,
+#endif
+		.os		= FIO_OS,
+		.arch		= FIO_ARCH,
+		.bpp		= sizeof(void *),
+		.cpus		= __cpu_to_le32(cpus_online()),
+	};
 
 	dprint(FD_NET, "server: sending probe reply\n");
 
 	strcpy(me, (char *) pdu->server);
 
-	memset(&probe, 0, sizeof(probe));
 	gethostname((char *) probe.hostname, sizeof(probe.hostname));
-#ifdef CONFIG_BIG_ENDIAN
-	probe.bigendian = 1;
-#endif
 	strncpy((char *) probe.fio_version, fio_version_string, sizeof(probe.fio_version) - 1);
 
-	probe.os	= FIO_OS;
-	probe.arch	= FIO_ARCH;
-	probe.bpp	= sizeof(void *);
-	probe.cpus	= __cpu_to_le32(cpus_online());
-
 	/*
 	 * If the client supports compression and we do too, then enable it
 	 */
@@ -1826,13 +1825,12 @@ static int __fio_append_iolog_gz(struct sk_entry *first, struct io_log *log,
 
 static int fio_append_iolog_gz(struct sk_entry *first, struct io_log *log)
 {
+	z_stream stream = {
+		.zalloc	= Z_NULL,
+		.zfree	= Z_NULL,
+		.opaque	= Z_NULL,
+	};
 	int ret = 0;
-	z_stream stream;
-
-	memset(&stream, 0, sizeof(stream));
-	stream.zalloc = Z_NULL;
-	stream.zfree = Z_NULL;
-	stream.opaque = Z_NULL;
 
 	if (deflateInit(&stream, Z_DEFAULT_COMPRESSION) != Z_OK)
 		return 1;
@@ -1928,17 +1926,16 @@ static int fio_append_text_log(struct sk_entry *first, struct io_log *log)
 
 int fio_send_iolog(struct thread_data *td, struct io_log *log, const char *name)
 {
-	struct cmd_iolog_pdu pdu;
+	struct cmd_iolog_pdu pdu = {
+		.nr_samples		= cpu_to_le64(iolog_nr_samples(log)),
+		.thread_number		= cpu_to_le32(td->thread_number),
+		.log_type		= cpu_to_le32(log->log_type),
+		.log_hist_coarseness	= cpu_to_le32(log->hist_coarseness),
+	};
 	struct sk_entry *first;
 	struct flist_head *entry;
 	int ret = 0;
 
-	memset(&pdu, 0, sizeof(pdu));
-	pdu.nr_samples = cpu_to_le64(iolog_nr_samples(log));
-	pdu.thread_number = cpu_to_le32(td->thread_number);
-	pdu.log_type = cpu_to_le32(log->log_type);
-	pdu.log_hist_coarseness = cpu_to_le32(log->hist_coarseness);
-
 	if (!flist_empty(&log->chunk_list))
 		pdu.compressed = __cpu_to_le32(STORE_COMPRESSED);
 	else if (use_zlib)
@@ -1999,11 +1996,11 @@ int fio_send_iolog(struct thread_data *td, struct io_log *log, const char *name)
 
 void fio_server_send_add_job(struct thread_data *td)
 {
-	struct cmd_add_job_pdu pdu;
+	struct cmd_add_job_pdu pdu = {
+		.thread_number = cpu_to_le32(td->thread_number),
+		.groupid = cpu_to_le32(td->groupid),
+	};
 
-	memset(&pdu, 0, sizeof(pdu));
-	pdu.thread_number = cpu_to_le32(td->thread_number);
-	pdu.groupid = cpu_to_le32(td->groupid);
 	convert_thread_options_to_net(&pdu.top, &td->o);
 
 	fio_net_queue_cmd(FIO_NET_CMD_ADD_JOB, &pdu, sizeof(pdu), NULL,
@@ -2241,11 +2238,10 @@ int fio_server_parse_host(const char *host, int ipv6, struct in_addr *inp,
 		ret = inet_pton(AF_INET, host, inp);
 
 	if (ret != 1) {
-		struct addrinfo hints, *res;
-
-		memset(&hints, 0, sizeof(hints));
-		hints.ai_family = ipv6 ? AF_INET6 : AF_INET;
-		hints.ai_socktype = SOCK_STREAM;
+		struct addrinfo *res, hints = {
+			.ai_family = ipv6 ? AF_INET6 : AF_INET,
+			.ai_socktype = SOCK_STREAM,
+		};
 
 		ret = getaddrinfo(host, NULL, &hints, &res);
 		if (ret) {
@@ -2404,11 +2400,11 @@ static void sig_int(int sig)
 
 static void set_sig_handlers(void)
 {
-	struct sigaction act;
+	struct sigaction act = {
+		.sa_handler = sig_int,
+		.sa_flags = SA_RESTART,
+	};
 
-	memset(&act, 0, sizeof(act));
-	act.sa_handler = sig_int;
-	act.sa_flags = SA_RESTART;
 	sigaction(SIGINT, &act, NULL);
 }
 
