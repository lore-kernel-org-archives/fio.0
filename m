Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:56222 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751383AbdFHMAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 8 Jun 2017 08:00:07 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dIw6g-0003pi-SK
        for fio@vger.kernel.org; Thu, 08 Jun 2017 12:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170608120002.35E4A2C14E3@kernel.dk>
Date: Thu,  8 Jun 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c12d597ac36632a6f08c749df302135bbd339cb2:

  stat: correct json 'io_bytes' output (2017-06-05 14:05:43 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a35ef7cb514d02671bdcb029a64785bbc288fe96:

  HOWTO: mention some details of ignore_error= option (2017-06-07 14:23:26 -0600)

----------------------------------------------------------------
Jens Axboe (4):
      fileset: fix double addition of file offset
      Fix up some style
      diskutil: ensure we have enough room to not write past end
      blktrace: ensure that dev loop doesn't truncate name

Tomohiro Kusumi (5):
      fix wrong malloc size for ignore_error buffer
      don't leave ignore_error_nr[etype] with 4 on blank input or error
      use enum error_type_bit for ignore_error index
      use ARRAY_SIZE() for ignore_error_nr[etype]
      HOWTO: mention some details of ignore_error= option

 HOWTO                    |  6 ++++--
 diskutil.c               |  2 +-
 filesetup.c              | 27 +++++++++++++++++----------
 options.c                | 18 ++++++++++++------
 oslib/linux-dev-lookup.c |  2 +-
 td_error.c               |  3 +--
 td_error.h               |  3 ++-
 7 files changed, 38 insertions(+), 23 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index ea9466a..289c518 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2836,7 +2836,8 @@ Error handling
 .. option:: ignore_error=str
 
 	Sometimes you want to ignore some errors during test in that case you can
-	specify error list for each error type.
+	specify error list for each error type, instead of only being able to
+	ignore the default 'non-fatal error' using :option:`continue_on_error`.
 	``ignore_error=READ_ERR_LIST,WRITE_ERR_LIST,VERIFY_ERR_LIST`` errors for
 	given error type is separated with ':'. Error may be symbol ('ENOSPC',
 	'ENOMEM') or integer.  Example::
@@ -2844,7 +2845,8 @@ Error handling
 		ignore_error=EAGAIN,ENOSPC:122
 
 	This option will ignore EAGAIN from READ, and ENOSPC and 122(EDQUOT) from
-	WRITE.
+	WRITE. This option works by overriding :option:`continue_on_error` with
+	the list of errors for each error type if any.
 
 .. option:: error_dump=bool
 
diff --git a/diskutil.c b/diskutil.c
index dca3748..9767ea2 100644
--- a/diskutil.c
+++ b/diskutil.c
@@ -363,7 +363,7 @@ static int find_block_dir(int majdev, int mindev, char *path, int link_ok)
 		return 0;
 
 	while ((dir = readdir(D)) != NULL) {
-		char full_path[256];
+		char full_path[257];
 
 		if (!strcmp(dir->d_name, ".") || !strcmp(dir->d_name, ".."))
 			continue;
diff --git a/filesetup.c b/filesetup.c
index e548d21..13079e4 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -833,19 +833,22 @@ static unsigned long long get_fs_free_counts(struct thread_data *td)
 uint64_t get_start_offset(struct thread_data *td, struct fio_file *f)
 {
 	struct thread_options *o = &td->o;
-	unsigned long long align_bs;  /* align the offset to this block size */
-	unsigned long long offset;  /* align_bs-aligned offset */
+	unsigned long long align_bs;
+	unsigned long long offset;
 
 	if (o->file_append && f->filetype == FIO_TYPE_FILE)
 		return f->real_file_size;
 
 	if (o->start_offset_percent > 0) {
-
-		/* if blockalign is provided, find the min across read, write, and trim */
+		/*
+		 * if blockalign is provided, find the min across read, write,
+		 * and trim
+		 */
 		if (fio_option_is_set(o, ba)) {
 			align_bs = (unsigned long long) min(o->ba[DDIR_READ], o->ba[DDIR_WRITE]);
 			align_bs = min((unsigned long long) o->ba[DDIR_TRIM], align_bs);
-		} else {  /* else take the minimum block size */
+		} else {
+			/* else take the minimum block size */
 			align_bs = td_min_bs(td);
 		}
 
@@ -853,14 +856,18 @@ uint64_t get_start_offset(struct thread_data *td, struct fio_file *f)
 		offset = (f->real_file_size * o->start_offset_percent / 100) +
 			(td->subjob_number * o->offset_increment);
 
-		/* block align the offset at the next available boundary at
-		   ceiling(offset / align_bs) * align_bs */
+		/*
+		 * block align the offset at the next available boundary at
+		 * ceiling(offset / align_bs) * align_bs
+		 */
 		offset = (offset / align_bs + (offset % align_bs != 0)) * align_bs;
 
-	} else {  /* start_offset_percent not set */
-		offset = o->start_offset + o->start_offset +
-			td->subjob_number * o->offset_increment;
+	} else {
+		/* start_offset_percent not set */
+		offset = o->start_offset +
+				td->subjob_number * o->offset_increment;
 	}
+
 	return offset;
 }
 
diff --git a/options.c b/options.c
index dcee7e5..6d799bf 100644
--- a/options.c
+++ b/options.c
@@ -270,7 +270,8 @@ static int str2error(char *str)
 	return 0;
 }
 
-static int ignore_error_type(struct thread_data *td, int etype, char *str)
+static int ignore_error_type(struct thread_data *td, enum error_type_bit etype,
+				char *str)
 {
 	unsigned int i;
 	int *error;
@@ -282,7 +283,7 @@ static int ignore_error_type(struct thread_data *td, int etype, char *str)
 	}
 
 	td->o.ignore_error_nr[etype] = 4;
-	error = malloc(4 * sizeof(struct bssplit));
+	error = calloc(4, sizeof(int));
 
 	i = 0;
 	while ((fname = strsep(&str, ":")) != NULL) {
@@ -306,8 +307,9 @@ static int ignore_error_type(struct thread_data *td, int etype, char *str)
 				error[i] = -error[i];
 		}
 		if (!error[i]) {
-			log_err("Unknown error %s, please use number value \n",
+			log_err("Unknown error %s, please use number value\n",
 				  fname);
+			td->o.ignore_error_nr[etype] = 0;
 			free(error);
 			return 1;
 		}
@@ -317,8 +319,10 @@ static int ignore_error_type(struct thread_data *td, int etype, char *str)
 		td->o.continue_on_error |= 1 << etype;
 		td->o.ignore_error_nr[etype] = i;
 		td->o.ignore_error[etype] = error;
-	} else
+	} else {
+		td->o.ignore_error_nr[etype] = 0;
 		free(error);
+	}
 
 	return 0;
 
@@ -328,7 +332,8 @@ static int str_ignore_error_cb(void *data, const char *input)
 {
 	struct thread_data *td = cb_data_to_td(data);
 	char *str, *p, *n;
-	int type = 0, ret = 1;
+	int ret = 1;
+	enum error_type_bit type = 0;
 
 	if (parse_dryrun())
 		return 0;
@@ -1389,7 +1394,8 @@ static int str_offset_cb(void *data, unsigned long long *__val)
 	if (parse_is_percent(v)) {
 		td->o.start_offset = 0;
 		td->o.start_offset_percent = -1ULL - v;
-		dprint(FD_PARSE, "SET start_offset_percent %d\n", td->o.start_offset_percent);
+		dprint(FD_PARSE, "SET start_offset_percent %d\n",
+					td->o.start_offset_percent);
 	} else
 		td->o.start_offset = v;
 
diff --git a/oslib/linux-dev-lookup.c b/oslib/linux-dev-lookup.c
index 5fbccd3..54017ff 100644
--- a/oslib/linux-dev-lookup.c
+++ b/oslib/linux-dev-lookup.c
@@ -20,7 +20,7 @@ int blktrace_lookup_device(const char *redirect, char *path, unsigned int maj,
 		return 0;
 
 	while ((dir = readdir(D)) != NULL) {
-		char full_path[256];
+		char full_path[257];
 
 		if (!strcmp(dir->d_name, ".") || !strcmp(dir->d_name, ".."))
 			continue;
diff --git a/td_error.c b/td_error.c
index 903f9ea..9d58a31 100644
--- a/td_error.c
+++ b/td_error.c
@@ -20,8 +20,7 @@ int td_non_fatal_error(struct thread_data *td, enum error_type_bit etype,
 
 	if (!td->o.ignore_error[etype]) {
 		td->o.ignore_error[etype] = __NON_FATAL_ERR;
-		td->o.ignore_error_nr[etype] = sizeof(__NON_FATAL_ERR)
-			/ sizeof(int);
+		td->o.ignore_error_nr[etype] = ARRAY_SIZE(__NON_FATAL_ERR);
 	}
 
 	if (!(td->o.continue_on_error & (1 << etype)))
diff --git a/td_error.h b/td_error.h
index 1133989..1b38a53 100644
--- a/td_error.h
+++ b/td_error.h
@@ -2,7 +2,8 @@
 #define FIO_TD_ERROR_H
 
 /*
- * What type of errors to continue on when continue_on_error is used
+ * What type of errors to continue on when continue_on_error is used,
+ * and what type of errors to ignore when ignore_error is used.
  */
 enum error_type_bit {
 	ERROR_TYPE_READ_BIT = 0,
