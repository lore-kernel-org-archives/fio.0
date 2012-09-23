Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:65008 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab2IWLqY (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 23 Sep 2012 07:46:24 -0400
Received: by lbbgj3 with SMTP id gj3so5610128lbb.19
        for <fio@vger.kernel.org>; Sun, 23 Sep 2012 04:46:22 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] backend: Add configurable non fatal error list
Date: Sun, 23 Sep 2012 15:46:09 +0400
Message-Id: <1348400769-12760-1-git-send-email-dmonakhov@openvz.org>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: axboe@kernel.dk, Dmitry Monakhov <dmonakhov@openvz.org>

Sometimes it is reasonable to perform test nearly system limits where
errors are possible and expected, in that case one may provide non
fatal error list which will be ignored during execution.
This patch add two options:
    ignore_error: List of non fatal error
    error_dump:   Whenever ignored list should be dumped to log.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 HOWTO                    |   13 +++++
 backend.c                |   10 ++--
 examples/enospc-pressure |   51 +++++++++++++++++++++
 fio.1                    |   17 +++++++
 fio.h                    |   44 +++++++++++++++---
 init.c                   |    2 +-
 io_u.c                   |   10 +++-
 options.c                |  110 ++++++++++++++++++++++++++++++++++++++++++++++
 verify.c                 |    3 +-
 9 files changed, 241 insertions(+), 19 deletions(-)
 create mode 100644 examples/enospc-pressure

diff --git a/HOWTO b/HOWTO
index 3eb5510..4f4dd55 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1240,6 +1240,19 @@ continue_on_error=str	Normally fio will exit the job on the first observed
 
 			1		Backward-compatible alias for 'all'.
 
+ignore_error=str Sometimes you want to ignore some errors during test
+		 in that case you can specify error list for each error type.
+		 ignore_error=READ_ERR_LIST,WRITE_ERR_LIST,VERIFY_ERR_LIST
+		 errors for given error type is separated with ':'. Error
+		 may be symbol ('ENOSPC', 'ENOMEM') or integer.
+		 Example:
+			ignore_error=EAGAIN,ENOSPC:122
+		 This option will ignore EAGAIN from READ, and ENOSPC and 
+		 122(EDQUOT) from WRITE. 
+
+error_dump=bool If set dump every error even if it is non fatal, true
+		by default. If disabled only fatal error will be dumped
+				 
 cgroup=str	Add job to this control group. If it doesn't exist, it will
 		be created. The system must have a mounted cgroup blkio
 		mount point for this to work. If your system doesn't have it
diff --git a/backend.c b/backend.c
index ce0a009..39d13a3 100644
--- a/backend.c
+++ b/backend.c
@@ -337,17 +337,17 @@ static int break_on_this_error(struct thread_data *td, enum fio_ddir ddir,
 	int ret = *retptr;
 
 	if (ret < 0 || td->error) {
-		int err;
+		int err = td->error;
+		enum error_type_bit eb;
 
 		if (ret < 0)
 			err = -ret;
-		else
-			err = td->error;
 
-		if (!(td->o.continue_on_error & td_error_type(ddir, err)))
+		eb = td_error_type(ddir, err);
+		if (!(td->o.continue_on_error & (1 << eb)))
 			return 1;
 
-		if (td_non_fatal_error(err)) {
+		if (td_non_fatal_error(td, eb, err)) {
 		        /*
 		         * Continue with the I/Os in case of
 			 * a non fatal error.
diff --git a/examples/enospc-pressure b/examples/enospc-pressure
new file mode 100644
index 0000000..e8b3f55
--- /dev/null
+++ b/examples/enospc-pressure
@@ -0,0 +1,51 @@
+#
+# Test for race-condition DIO-write vs punch_hole
+# If race exist dio may rewrite punched block after
+# it was allocated to another file, we will catch that
+# by verifying blocks content
+#
+[global]
+ioengine=libaio 
+directory=/scratch
+# File size is reasonably huge to provoke ENOSPC
+filesize=128G
+size=999G
+iodepth=128
+
+# Expect write failure due to ENOSPC, skip error dump
+continue_on_error=write
+ignore_error=,ENOSPC
+error_dump=0
+fallocate=none
+exitall
+
+# Two threads (dio and punch_hole) operate on single file:'raicer',
+# We do not care about data content here
+[dio-raicer]
+bs=128k 
+direct=1
+buffered=0 
+rw=randwrite
+runtime=100
+filename=raicer
+time_based
+
+[punch_hole-raicer]
+bs=4k
+rw=randtrim
+filename=raicer
+
+# Verifier thread continiously write to newly allcated blocks
+# and veryfy written content
+[aio-dio-verifier]
+create_on_open=1
+verify=crc32c-intel
+verify_fatal=1
+verify_dump=1
+verify_backlog=1024
+verify_async=4
+direct=1
+# block size should be equals to fs block size to prevent short writes
+bs=4k
+rw=randrw
+filename=aio-dio-verifier
diff --git a/fio.1 b/fio.1
index 086cf9d..98f3e62 100644
--- a/fio.1
+++ b/fio.1
@@ -956,6 +956,23 @@ entering the kernel with a gettimeofday() call. The CPU set aside for doing
 these time calls will be excluded from other uses. Fio will manually clear it
 from the CPU mask of other jobs.
 .TP
+.BI ignore_error \fR=\fPstr
+Sometimes you want to ignore some errors during test in that case you can specify
+error list for each error type.
+.br
+ignore_error=READ_ERR_LIST,WRITE_ERR_LIST,VERIFY_ERR_LIST
+.br
+errors for given error type is separated with ':'.
+Error may be symbol ('ENOSPC', 'ENOMEM') or an integer.
+.br
+Example: ignore_error=EAGAIN,ENOSPC:122 .
+.br	
+This option will ignore EAGAIN from READ, and ENOSPC and 122(EDQUOT) from WRITE. 
+.TP
+.BI error_dump \fR=\fPbool
+If set dump every error even if it is non fatal, true by default. If disabled
+only fatal error will be dumped
+.TP
 .BI cgroup \fR=\fPstr
 Add job to this control group. If it doesn't exist, it will be created.
 The system must have a mounted cgroup blkio mount point for this to work. If
diff --git a/fio.h b/fio.h
index b2bbe93..8bb5b03 100644
--- a/fio.h
+++ b/fio.h
@@ -70,11 +70,18 @@ enum {
 /*
  * What type of errors to continue on when continue_on_error is used
  */
+enum error_type_bit {
+	ERROR_TYPE_READ_BIT = 0,
+	ERROR_TYPE_WRITE_BIT = 1,
+	ERROR_TYPE_VERIFY_BIT = 2,
+	ERROR_TYPE_CNT = 3,
+};
+
 enum error_type {
         ERROR_TYPE_NONE = 0,
-        ERROR_TYPE_READ = 1 << 0,
-        ERROR_TYPE_WRITE = 1 << 1,
-        ERROR_TYPE_VERIFY = 1 << 2,
+        ERROR_TYPE_READ = 1 << ERROR_TYPE_READ_BIT,
+        ERROR_TYPE_WRITE = 1 << ERROR_TYPE_WRITE_BIT,
+        ERROR_TYPE_VERIFY = 1 << ERROR_TYPE_VERIFY_BIT,
         ERROR_TYPE_ANY = 0xffff,
 };
 
@@ -115,6 +122,10 @@ struct thread_options {
 	struct bssplit *bssplit[DDIR_RWDIR_CNT];
 	unsigned int bssplit_nr[DDIR_RWDIR_CNT];
 
+	int *ignore_error[ERROR_TYPE_CNT];
+	unsigned int ignore_error_nr[ERROR_TYPE_CNT];
+	unsigned int error_dump;
+
 	unsigned int nr_files;
 	unsigned int open_files;
 	enum file_lock_mode file_lock_mode;
@@ -559,15 +570,32 @@ static inline void fio_ro_check(struct thread_data *td, struct io_u *io_u)
 
 #define REAL_MAX_JOBS		2048
 
-#define td_non_fatal_error(e)	((e) == EIO || (e) == EILSEQ)
-
 static inline enum error_type td_error_type(enum fio_ddir ddir, int err)
 {
 	if (err == EILSEQ)
-		return ERROR_TYPE_VERIFY;
+		return ERROR_TYPE_VERIFY_BIT;
 	if (ddir == DDIR_READ)
-		return ERROR_TYPE_READ;
-	return ERROR_TYPE_WRITE;
+		return ERROR_TYPE_READ_BIT;
+	return ERROR_TYPE_WRITE_BIT;
+}
+
+static int __NON_FATAL_ERR[] = {EIO, EILSEQ};
+static inline int td_non_fatal_error(struct thread_data *td,
+				     enum error_type_bit etype, int err)
+{
+	int i;
+	if (!td->o.ignore_error[etype]) {
+		td->o.ignore_error[etype] = __NON_FATAL_ERR;
+		td->o.ignore_error_nr[etype] = sizeof(__NON_FATAL_ERR)
+			/ sizeof(int);
+	}
+
+	if (!(td->o.continue_on_error & (1 << etype)))
+		return 0;
+	for (i = 0; i < td->o.ignore_error_nr[etype]; i++)
+		if (td->o.ignore_error[etype][i] == err)
+			return 1;
+	return 0;
 }
 
 static inline void update_error_count(struct thread_data *td, int err)
diff --git a/init.c b/init.c
index da1f472..399dbcc 100644
--- a/init.c
+++ b/init.c
@@ -1198,7 +1198,7 @@ static int fill_def_thread(void)
 
 	fio_getaffinity(getpid(), &def_thread.o.cpumask);
 	def_thread.o.timeout = def_timeout;
-
+	def_thread.o.error_dump = 1;
 	/*
 	 * fill default options
 	 */
diff --git a/io_u.c b/io_u.c
index db0a6dc..a2c583d 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1290,10 +1290,12 @@ err_put:
 
 void io_u_log_error(struct thread_data *td, struct io_u *io_u)
 {
+	enum error_type_bit eb = td_error_type(io_u->ddir, io_u->error);
 	const char *msg[] = { "read", "write", "sync", "datasync",
 				"sync_file_range", "wait", "trim" };
 
-
+	if (td_non_fatal_error(td, eb, io_u->error) && !td->o.error_dump)
+		return;
 
 	log_err("fio: io_u error");
 
@@ -1432,8 +1434,10 @@ static void io_completed(struct thread_data *td, struct io_u *io_u,
 		icd->error = io_u->error;
 		io_u_log_error(td, io_u);
 	}
-	if (icd->error && td_non_fatal_error(icd->error) &&
-           (td->o.continue_on_error & td_error_type(io_u->ddir, icd->error))) {
+	if (icd->error) {
+		enum error_type_bit eb = td_error_type(io_u->ddir, icd->error);
+		if (!td_non_fatal_error(td, eb, icd->error))
+			return;
 		/*
 		 * If there is a non_fatal error, then add to the error count
 		 * and clear all the errors.
diff --git a/options.c b/options.c
index 8fa50a8..e207f8c 100644
--- a/options.c
+++ b/options.c
@@ -214,6 +214,101 @@ static int str_bssplit_cb(void *data, const char *input)
 	return ret;
 }
 
+static int str2error(char *str)
+{
+	const char * err[] = {"EPERM", "ENOENT", "ESRCH", "EINTR", "EIO",
+			    "ENXIO", "E2BIG", "ENOEXEC", "EBADF",
+			    "ECHILD", "EAGAIN", "ENOMEM", "EACCES",
+			    "EFAULT", "ENOTBLK", "EBUSY", "EEXIST",
+			    "EXDEV", "ENODEV", "ENOTDIR", "EISDIR",
+			    "EINVAL", "ENFILE", "EMFILE", "ENOTTY",
+			    "ETXTBSY","EFBIG", "ENOSPC", "ESPIPE",
+			    "EROFS","EMLINK", "EPIPE", "EDOM", "ERANGE"};
+	int i = 0, num = sizeof(err) / sizeof(void *);
+
+	while( i < num) {
+		if (!strcmp(err[i], str))
+			return i + 1;
+		i++;
+	}
+	return 0;
+}
+
+static int ignore_error_type(struct thread_data *td, int etype, char *str)
+{
+	unsigned int i;
+	int *error;
+	char *fname;
+
+	if (etype >= ERROR_TYPE_CNT) {
+		log_err("Illegal error type\n");
+		return 1;
+	}
+
+	td->o.ignore_error_nr[etype] = 4;
+	error = malloc(4 * sizeof(struct bssplit));
+
+	i = 0;
+	while ((fname = strsep(&str, ":")) != NULL) {
+
+		if (!strlen(fname))
+			break;
+
+		/*
+		 * grow struct buffer, if needed
+		 */
+		if (i == td->o.ignore_error_nr[etype]) {
+			td->o.ignore_error_nr[etype] <<= 1;
+			error = realloc(error, td->o.ignore_error_nr[etype]
+						  * sizeof(int));
+		}
+		if (fname[0] == 'E') {
+			error[i] = str2error(fname);
+		} else {
+			error[i] = atoi(fname);
+			if (error[i] < 0)
+				error[i] = error[i];
+		}
+		if (!error[i]) {
+			log_err("Unknown error %s, please use number value \n",
+				  fname);
+			return 1;
+		}
+		i++;
+	}
+	if (i) {
+		td->o.continue_on_error |= 1 << etype;
+		td->o.ignore_error_nr[etype] = i;
+		td->o.ignore_error[etype] = error;
+	}
+	return 0;
+
+}
+
+static int str_ignore_error_cb(void *data, const char *input)
+{
+	struct thread_data *td = data;
+	char *str, *p, *n;
+	int type = 0, ret = 1;
+	p = str = strdup(input);
+
+	strip_blank_front(&str);
+	strip_blank_end(str);
+
+	while (p) {
+		n = strchr(p, ',');
+		if (n)
+			*n++ = '\0';
+		ret = ignore_error_type(td, type, p);
+		if (ret)
+			break;
+		p = n;
+		type++;
+	}
+	free(str);
+	return ret;
+}
+
 static int str_rw_cb(void *data, const char *str)
 {
 	struct thread_data *td = data;
@@ -2200,6 +2295,21 @@ static struct fio_option options[FIO_MAX_OPTS] = {
 		},
 	},
 	{
+		.name	= "ignore_error",
+		.type	= FIO_OPT_STR,
+		.cb	= str_ignore_error_cb,
+		.help	= "Set a specific list of errors to ignore",
+		.parent	= "rw",
+	},
+	{
+		.name	= "error_dump",
+		.type	= FIO_OPT_BOOL,
+		.off1	= td_var_offset(error_dump),
+		.def	= "0",
+		.help	= "Dump info on each error",
+	},
+
+	{
 		.name	= "profile",
 		.type	= FIO_OPT_STR_STORE,
 		.off1	= td_var_offset(profile),
diff --git a/verify.c b/verify.c
index f25eab9..f246dc8 100644
--- a/verify.c
+++ b/verify.c
@@ -1049,8 +1049,7 @@ static void *verify_async_thread(void *data)
 			put_io_u(td, io_u);
 			if (!ret)
 				continue;
-			if (td->o.continue_on_error & ERROR_TYPE_VERIFY &&
-			    td_non_fatal_error(ret)) {
+			if (td_non_fatal_error(td, ERROR_TYPE_VERIFY_BIT, ret)) {
 				update_error_count(td, ret);
 				td_clear_error(td);
 				ret = 0;
-- 
1.7.7.6

