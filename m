Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:32975 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934AbaCOMAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 15 Mar 2014 08:00:05 -0400
Received: from kernel.dk ([54.225.238.116] helo=strynoevaenget.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WOnG0-00040U-Ln
	for fio@vger.kernel.org; Sat, 15 Mar 2014 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140315120003.C222E400D9@strynoevaenget.dk>
Date: Sat, 15 Mar 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit dac45f23c3c7d146f7df82047ae7f25abf231ed3:

  stat: fixup fio-dump-status file location (2014-03-12 13:40:09 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 7750aac43ee4e0c001860426e6fdaf22d9ddfc76:

  Update documentation on zero_buffers / scramble_buffers (2014-03-14 19:41:07 -0600)

----------------------------------------------------------------
Jens Axboe (4):
      Disable status file updates on error
      Bump length of description field to 256 chars
      Don't scramble buffers if compression is enabled
      Update documentation on zero_buffers / scramble_buffers

 HOWTO    |    2 ++
 fio.1    |    2 ++
 init.c   |   13 ++++++++++++-
 server.c |    6 +++---
 server.h |    2 +-
 stat.c   |   18 ++++++++++++++----
 stat.h   |    3 ++-
 7 files changed, 36 insertions(+), 10 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 725214f..0f9c0fc 100644
--- a/HOWTO
+++ b/HOWTO
@@ -519,6 +519,8 @@ bs_is_seq_rand	If this option is set, fio will use the normal read,write
 
 zero_buffers	If this option is given, fio will init the IO buffers to
 		all zeroes. The default is to fill them with random data.
+		The resulting IO buffers will not be completely zeroed,
+		unless scramble_buffers is also turned off.
 
 refill_buffers	If this option is given, fio will refill the IO buffers
 		on every submit. The default is to only fill it at init
diff --git a/fio.1 b/fio.1
index 2dee56b..20f0c09 100644
--- a/fio.1
+++ b/fio.1
@@ -430,6 +430,8 @@ blocksize setting.
 .TP
 .B zero_buffers
 Initialise buffers with all zeros. Default: fill buffers with random data.
+The resulting IO buffers will not be completely zeroed, unless
+\fPscramble_buffers\fR is also turned off.
 .TP
 .B refill_buffers
 If this option is given, fio will refill the IO buffers on every submit. The
diff --git a/init.c b/init.c
index 73ec9eb..0a872c0 100644
--- a/init.c
+++ b/init.c
@@ -856,6 +856,11 @@ int ioengine_load(struct thread_data *td)
 	return 0;
 }
 
+static int compression_enabled(struct thread_options *o)
+{
+	return o->compress_percentage || o->compress_chunk;
+}
+
 static void init_flags(struct thread_data *td)
 {
 	struct thread_options *o = &td->o;
@@ -868,8 +873,14 @@ static void init_flags(struct thread_data *td)
 		td->flags |= TD_F_READ_IOLOG;
 	if (o->refill_buffers)
 		td->flags |= TD_F_REFILL_BUFFERS;
-	if (o->scramble_buffers)
+
+	/*
+	 * Don't scramble buffers if we set any of the compression
+	 * settings
+	 */
+	if (o->scramble_buffers && !compression_enabled(o))
 		td->flags |= TD_F_SCRAMBLE_BUFFERS;
+
 	if (o->verify != VERIFY_NONE)
 		td->flags |= TD_F_VER_NONE;
 }
diff --git a/server.c b/server.c
index dc70616..2f12162 100644
--- a/server.c
+++ b/server.c
@@ -987,9 +987,9 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
 
 	memset(&p, 0, sizeof(p));
 
-	strcpy(p.ts.name, ts->name);
-	strcpy(p.ts.verror, ts->verror);
-	strcpy(p.ts.description, ts->description);
+	strncpy(p.ts.name, ts->name, FIO_JOBNAME_SIZE - 1);
+	strncpy(p.ts.verror, ts->verror, FIO_VERROR_SIZE - 1);
+	strncpy(p.ts.description, ts->description, FIO_JOBDESC_SIZE - 1);
 
 	p.ts.error		= cpu_to_le32(ts->error);
 	p.ts.thread_number	= cpu_to_le32(ts->thread_number);
diff --git a/server.h b/server.h
index 8f79c14..3a279f0 100644
--- a/server.h
+++ b/server.h
@@ -38,7 +38,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 32,
+	FIO_SERVER_VER			= 33,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 
diff --git a/stat.c b/stat.c
index f018f33..f84ce53 100644
--- a/stat.c
+++ b/stat.c
@@ -1232,12 +1232,12 @@ static void __show_run_stats(void)
 			/*
 			 * These are per-group shared already
 			 */
-			strncpy(ts->name, td->o.name, FIO_JOBNAME_SIZE);
+			strncpy(ts->name, td->o.name, FIO_JOBNAME_SIZE - 1);
 			if (td->o.description)
 				strncpy(ts->description, td->o.description,
-						FIO_JOBNAME_SIZE);
+						FIO_JOBDESC_SIZE - 1);
 			else
-				memset(ts->description, 0, FIO_JOBNAME_SIZE);
+				memset(ts->description, 0, FIO_JOBDESC_SIZE);
 
 			/*
 			 * If multiple entries in this group, this is
@@ -1479,6 +1479,7 @@ void show_running_run_stats(void)
 
 static int status_interval_init;
 static struct timeval status_time;
+static int status_file_disabled;
 
 #define FIO_STATUS_FILE		"fio-dump-status"
 
@@ -1488,6 +1489,9 @@ static int check_status_file(void)
 	const char *temp_dir;
 	char fio_status_file_path[PATH_MAX];
 
+	if (status_file_disabled)
+		return 0;
+
 	temp_dir = getenv("TMPDIR");
 	if (temp_dir == NULL)
 		temp_dir = getenv("TEMP");
@@ -1499,7 +1503,13 @@ static int check_status_file(void)
 	if (stat(fio_status_file_path, &sb))
 		return 0;
 
-	unlink(fio_status_file_path);
+	if (unlink(fio_status_file_path) < 0) {
+		log_err("fio: failed to unlink %s: %s\n", fio_status_file_path,
+							strerror(errno));
+		log_err("fio: disabling status file updates\n");
+		status_file_disabled = 1;
+	}
+
 	return 1;
 }
 
diff --git a/stat.h b/stat.h
index bc4f6da..3f68305 100644
--- a/stat.h
+++ b/stat.h
@@ -114,6 +114,7 @@ struct group_run_stats {
 
 #define MAX_PATTERN_SIZE	512
 #define FIO_JOBNAME_SIZE	128
+#define FIO_JOBDESC_SIZE	256
 #define FIO_VERROR_SIZE		128
 
 struct thread_stat {
@@ -123,7 +124,7 @@ struct thread_stat {
 	uint32_t thread_number;
 	uint32_t groupid;
 	uint32_t pid;
-	char description[FIO_JOBNAME_SIZE];
+	char description[FIO_JOBDESC_SIZE];
 	uint32_t members;
 	uint32_t unified_rw_rep;
 
