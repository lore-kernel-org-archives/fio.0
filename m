Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64850 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab1KQDKV (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 16 Nov 2011 22:10:21 -0500
Received: by wwe5 with SMTP id 5so2011581wwe.1
        for <fio@vger.kernel.org>; Wed, 16 Nov 2011 19:10:20 -0800 (PST)
MIME-Version: 1.0
From: Steven Lang <tirea@google.com>
Date: Wed, 16 Nov 2011 19:09:58 -0800
Message-ID: <CAAUT-yMXe=PK1roL710ciSqZqqnh2GSmGb6BVyUMreY5Yqbwbw@mail.gmail.com>
Subject: [PATCH] Expand continue_on_error to select which type of error to allow
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

This expands the continue_on_error option to take a string specifying
what type of error to continue on, breaking out errors into read,
write, and verify.  (Sync, trim, and anything else not specifically a
read are considered write operations for the sake of error
continuation.)

Backwards compatibility is retained by allowing =0 and =1 values to
specify none and all, respectively.

diff --git a/HOWTO b/HOWTO
index 2403a5c..ac7e729 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1170,7 +1170,7 @@ gtod_cpu=int	Sometimes it's cheaper to dedicate
a single thread of
 		uses. Fio will manually clear it from the CPU mask of other
 		jobs.

-continue_on_error=bool	Normally fio will exit the job on the first observed
+continue_on_error=str	Normally fio will exit the job on the first observed
 		failure. If this option is set, fio will continue the job when
 		there is a 'non-fatal error' (EIO or EILSEQ) until the runtime
 		is exceeded or the I/O size specified is completed. If this
@@ -1179,6 +1179,24 @@ continue_on_error=bool	Normally fio will exit
the job on the first observed
 		given in the stats is the first error that was hit during the
 		run.

+		The allowed values are:
+
+			none	Exit on any IO or verify errors.
+
+			read	Continue on read errors, exit on all others.
+
+			write	Continue on write errors, exit on all others.
+
+			io	Continue on any IO error, exit on all others.
+
+			verify	Continue on verify errors, exit on all others.
+
+			all	Continue on all errors.
+
+			0		Backward-compatible alias for 'none'.
+
+			1		Backward-compatible alias for 'all'.
+
 cgroup=str	Add job to this control group. If it doesn't exist, it will
 		be created. The system must have a mounted cgroup blkio
 		mount point for this to work. If your system doesn't have it
diff --git a/fio.c b/fio.c
index 5b58ab8..8702086 100644
--- a/fio.c
+++ b/fio.c
@@ -452,21 +452,22 @@ static inline void update_tv_cache(struct thread_data *td)
 		__update_tv_cache(td);
 }

-static int break_on_this_error(struct thread_data *td, int *retptr)
+static int break_on_this_error(struct thread_data *td, enum fio_ddir ddir,
+			       int *retptr)
 {
 	int ret = *retptr;

 	if (ret < 0 || td->error) {
 		int err;

-		if (!td->o.continue_on_error)
-			return 1;
-
 		if (ret < 0)
 			err = -ret;
 		else
 			err = td->error;

+		if (!(td->o.continue_on_error & td_error_type(ddir, err)))
+			return 1;
+
 		if (td_non_fatal_error(err)) {
 		        /*
 		         * Continue with the I/Os in case of
@@ -612,7 +613,7 @@ sync_done:
 			break;
 		}

-		if (break_on_this_error(td, &ret))
+		if (break_on_this_error(td, io_u->ddir, &ret))
 			break;

 		/*
@@ -678,6 +679,7 @@ static void do_io(struct thread_data *td)
 		int min_evts = 0;
 		struct io_u *io_u;
 		int ret2, full;
+		enum fio_ddir ddir;

 		if (td->terminate)
 			break;
@@ -696,6 +698,8 @@ static void do_io(struct thread_data *td)
 		if (!io_u)
 			break;

+		ddir = io_u->ddir;
+
 		/*
 		 * Add verification end_io handler, if asked to verify
 		 * a previously written file.
@@ -774,7 +778,7 @@ sync_done:
 			break;
 		}

-		if (break_on_this_error(td, &ret))
+		if (break_on_this_error(td, ddir, &ret))
 			break;

 		/*
diff --git a/fio.h b/fio.h
index cc1f65f..4733990 100644
--- a/fio.h
+++ b/fio.h
@@ -65,6 +65,17 @@ enum {
 	RW_SEQ_IDENT,
 };

+/*
+ * What type of errors to continue on when continue_on_error is used
+ */
+enum error_type {
+        ERROR_TYPE_NONE = 0,
+        ERROR_TYPE_READ = 1 << 0,
+        ERROR_TYPE_WRITE = 1 << 1,
+        ERROR_TYPE_VERIFY = 1 << 2,
+        ERROR_TYPE_ANY = 0xffff,
+};
+
 struct bssplit {
 	unsigned int bs;
 	unsigned char perc;
@@ -227,7 +238,7 @@ struct thread_options {
 	/*
 	 * I/O Error handling
 	 */
-	unsigned int continue_on_error;
+	enum error_type continue_on_error;

 	/*
 	 * Benchmark profile type
@@ -520,6 +531,15 @@ static inline void fio_ro_check(struct
thread_data *td, struct io_u *io_u)

 #define td_non_fatal_error(e)	((e) == EIO || (e) == EILSEQ)

+static inline enum error_type td_error_type(enum fio_ddir ddir, int err)
+{
+	if (err == EILSEQ)
+		return ERROR_TYPE_VERIFY;
+	if (ddir == DDIR_READ)
+		return ERROR_TYPE_READ;
+	return ERROR_TYPE_WRITE;
+}
+
 static inline void update_error_count(struct thread_data *td, int err)
 {
 	td->total_err_count++;
diff --git a/io_u.c b/io_u.c
index 0ff66f9..a5f22f9 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1389,8 +1389,8 @@ static void io_completed(struct thread_data *td,
struct io_u *io_u,
 		icd->error = io_u->error;
 		io_u_log_error(td, io_u);
 	}
-	if (td->o.continue_on_error && icd->error &&
-	    td_non_fatal_error(icd->error)) {
+	if (icd->error && td_non_fatal_error(icd->error) &&
+            (td->o.continue_on_error & td_error_type(io_u->ddir,
icd->error))) {
 		/*
 		 * If there is a non_fatal error, then add to the error count
 		 * and clear all the errors.
diff --git a/options.c b/options.c
index 53c3a82..2e1e709 100644
--- a/options.c
+++ b/options.c
@@ -2057,10 +2057,44 @@ static struct fio_option options[FIO_MAX_OPTS] = {
 	},
 	{
 		.name	= "continue_on_error",
-		.type	= FIO_OPT_BOOL,
+		.type	= FIO_OPT_STR,
 		.off1	= td_var_offset(continue_on_error),
 		.help	= "Continue on non-fatal errors during IO",
-		.def	= "0",
+		.def	= "none",
+		.posval = {
+			  { .ival = "none",
+			    .oval = ERROR_TYPE_NONE,
+			    .help = "Exit when an error is encountered",
+			  },
+			  { .ival = "read",
+			    .oval = ERROR_TYPE_READ,
+			    .help = "Continue on read errors only",
+			  },
+			  { .ival = "write",
+			    .oval = ERROR_TYPE_WRITE,
+			    .help = "Continue on write errors only",
+			  },
+			  { .ival = "io",
+			    .oval = ERROR_TYPE_READ | ERROR_TYPE_WRITE,
+			    .help = "Continue on any IO errors",
+			  },
+			  { .ival = "verify",
+			    .oval = ERROR_TYPE_VERIFY,
+			    .help = "Continue on verify errors only",
+			  },
+			  { .ival = "all",
+			    .oval = ERROR_TYPE_ANY,
+			    .help = "Continue on all io and verify errors",
+			  },
+			  { .ival = "0",
+			    .oval = ERROR_TYPE_NONE,
+			    .help = "Alias for 'none'",
+			  },
+			  { .ival = "1",
+			    .oval = ERROR_TYPE_ANY,
+			    .help = "Alias for 'all'",
+			  },
+		},
 	},
 	{
 		.name	= "profile",
diff --git a/verify.c b/verify.c
index 5a94281..91a9077 100644
--- a/verify.c
+++ b/verify.c
@@ -1033,7 +1033,7 @@ static void *verify_async_thread(void *data)
 			put_io_u(td, io_u);
 			if (!ret)
 				continue;
-			if (td->o.continue_on_error &&
+			if (td->o.continue_on_error & ERROR_TYPE_VERIFY &&
 			    td_non_fatal_error(ret)) {
 				update_error_count(td, ret);
 				td_clear_error(td);
