Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:40866 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726910AbeHUPUE (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 21 Aug 2018 11:20:04 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fs5KV-00012t-Bi
        for fio@vger.kernel.org; Tue, 21 Aug 2018 12:00:11 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180821120002.4DA4C2C2FEB@kernel.dk>
Date: Tue, 21 Aug 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c44d2c6e97245bf68a57f9860a1c92c7bc065f82:

  Move steady state unit test to t/ (2018-08-17 19:39:07 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 78439a18225255f7f1b4f9efab950afcd638b606:

  Update HOWTO for read_iolog change (2018-08-20 08:34:13 -0600)

----------------------------------------------------------------
Adam Kupczyk (1):
      iolog: Now --read_iolog can contain multiple replay files, separated by ':'.

Jens Axboe (2):
      Merge branch 'multiple-read_iolog' of https://github.com/aclamk/fio
      Update HOWTO for read_iolog change

 HOWTO     |  4 ++++
 fio.1     |  4 ++++
 iolog.c   | 12 ++++++++----
 options.c | 17 +++++++++++++++++
 options.h |  1 +
 5 files changed, 34 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index ff7aa09..3839461 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2409,6 +2409,10 @@ I/O replay
 	:manpage:`blktrace(8)` for how to capture such logging data. For blktrace
 	replay, the file needs to be turned into a blkparse binary data file first
 	(``blkparse <device> -o /dev/null -d file_for_fio.bin``).
+	You can specify a number of files by separating the names with a ':'
+	character. See the :option:`filename` option for information on how to
+	escape ':' and '\' characters within the file names. These files will
+	be sequentially assigned to job clones created by :option:`numjobs`.
 
 .. option:: read_iolog_chunked=bool
 
diff --git a/fio.1 b/fio.1
index cb4351f..4071947 100644
--- a/fio.1
+++ b/fio.1
@@ -2127,6 +2127,10 @@ to replay a workload captured by blktrace. See
 \fBblktrace\fR\|(8) for how to capture such logging data. For blktrace
 replay, the file needs to be turned into a blkparse binary data file first
 (`blkparse <device> \-o /dev/null \-d file_for_fio.bin').
+You can specify a number of files by separating the names with a ':' character.
+See the \fBfilename\fR option for information on how to escape ':' and '\'
+characters within the file names. These files will be sequentially assigned to
+job clones created by \fBnumjobs\fR.
 .TP
 .BI read_iolog_chunked \fR=\fPbool
 Determines how iolog is read. If false (default) entire \fBread_iolog\fR will
diff --git a/iolog.c b/iolog.c
index 0f95c60..f3eedb5 100644
--- a/iolog.c
+++ b/iolog.c
@@ -447,7 +447,7 @@ static bool read_iolog2(struct thread_data *td)
 					dprint(FD_FILE, "iolog: ignoring"
 						" re-add of file %s\n", fname);
 				} else {
-					fileno = add_file(td, fname, 0, 1);
+					fileno = add_file(td, fname, td->subjob_number, 1);
 					file_action = FIO_LOG_ADD_FILE;
 				}
 				continue;
@@ -596,13 +596,17 @@ static bool init_iolog_read(struct thread_data *td)
 	char buffer[256], *p;
 	FILE *f = NULL;
 	bool ret;
-	if (is_socket(td->o.read_iolog_file)) {
-		int fd = open_socket(td->o.read_iolog_file);
+	char* fname = get_name_by_idx(td->o.read_iolog_file, td->subjob_number);
+	dprint(FD_IO, "iolog: name=%s\n", fname);
+
+	if (is_socket(fname)) {
+		int fd = open_socket(fname);
 		if (fd >= 0) {
 			f = fdopen(fd, "r");
 		}
 	} else
-		f = fopen(td->o.read_iolog_file, "r");
+		f = fopen(fname, "r");
+	free(fname);
 	if (!f) {
 		perror("fopen read iolog");
 		return false;
diff --git a/options.c b/options.c
index 1c35acc..86ab5d6 100644
--- a/options.c
+++ b/options.c
@@ -1240,6 +1240,23 @@ int set_name_idx(char *target, size_t tlen, char *input, int index,
 	return len;
 }
 
+char* get_name_by_idx(char *input, int index)
+{
+	unsigned int cur_idx;
+	char *fname, *str, *p;
+
+	p = str = strdup(input);
+
+	index %= get_max_name_idx(input);
+	for (cur_idx = 0; cur_idx <= index; cur_idx++)
+		fname = get_next_name(&str);
+
+	fname = strdup(fname);
+	free(p);
+
+	return fname;
+}
+
 static int str_filename_cb(void *data, const char *input)
 {
 	struct thread_data *td = cb_data_to_td(data);
diff --git a/options.h b/options.h
index e53eb1b..8fdd136 100644
--- a/options.h
+++ b/options.h
@@ -16,6 +16,7 @@ void add_opt_posval(const char *, const char *, const char *);
 void del_opt_posval(const char *, const char *);
 struct thread_data;
 void fio_options_free(struct thread_data *);
+char* get_name_by_idx(char *input, int index);
 int set_name_idx(char *, size_t, char *, int, bool);
 
 extern char client_sockaddr_str[];  /* used with --client option */

