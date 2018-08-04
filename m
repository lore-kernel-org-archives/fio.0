Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56832 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbeHDOAz (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 4 Aug 2018 10:00:55 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1flvEQ-00043x-4z
        for fio@vger.kernel.org; Sat, 04 Aug 2018 12:00:26 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180804120002.2969B2C0311@kernel.dk>
Date: Sat,  4 Aug 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 17924179519397e49a7a82fd99d860f9ef077645:

  Merge branch 'szaydel/solaris-Wincompatible-pointer-types' of https://github.com/szaydel/fio (2018-08-02 16:20:24 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 1d73ff2a4a8f02905cf338b2f0286d76d64e7c2a:

  iolog: move the chunked items-to-fetch logic into separate function (2018-08-03 14:40:17 -0600)

----------------------------------------------------------------
Adam Kupczyk (4):
      iolog: Added option read_iolog_chunked. Used to avoid reading large iologs at once.     	Allows iologs to be infinite, generated.
      iolog: Added new option description to HOWTO
      platforms/windows: Add S_ISSOCK macro.
      iolog: allow to read_iolog from unix socket

Jens Axboe (5):
      Merge branch 'windows-s_issock' of https://github.com/aclamk/fio
      Merge branch 'read_iolog-from-unix-socket' of https://github.com/aclamk/fio
      Merge branch 'chunked-iolog-reading' of https://github.com/aclamk/fio
      iolog: fix potential div-by-zero
      iolog: move the chunked items-to-fetch logic into separate function

 HOWTO            |   6 +++
 backend.c        |   4 ++
 fio.1            |   5 +++
 fio.h            |   5 +++
 iolog.c          | 122 ++++++++++++++++++++++++++++++++++++++++++++++++++-----
 options.c        |  11 +++++
 os/os-windows.h  |   4 ++
 thread_options.h |   1 +
 8 files changed, 147 insertions(+), 11 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 804d93e..16c5ae3 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2327,6 +2327,12 @@ I/O replay
 	replay, the file needs to be turned into a blkparse binary data file first
 	(``blkparse <device> -o /dev/null -d file_for_fio.bin``).
 
+.. option:: read_iolog_chunked=bool
+
+	Determines how iolog is read. If false(default) entire :option:`read_iolog`
+	will be read at once. If selected true, input from iolog will be read
+	gradually. Useful when iolog is very large, or it is generated.
+
 .. option:: replay_no_stall=bool
 
 	When replaying I/O with :option:`read_iolog` the default behavior is to
diff --git a/backend.c b/backend.c
index 3c45e78..4b4ecde 100644
--- a/backend.c
+++ b/backend.c
@@ -966,8 +966,10 @@ static void do_io(struct thread_data *td, uint64_t *bytes_done)
 		 * Break if we exceeded the bytes. The exception is time
 		 * based runs, but we still need to break out of the loop
 		 * for those to run verification, if enabled.
+		 * Jobs read from iolog do not use this stop condition.
 		 */
 		if (bytes_issued >= total_bytes &&
+		    !td->o.read_iolog_file &&
 		    (!td->o.time_based ||
 		     (td->o.time_based && td->o.verify != VERIFY_NONE)))
 			break;
@@ -1909,6 +1911,8 @@ err:
 	 */
 	if (o->write_iolog_file)
 		write_iolog_close(td);
+	if (td->io_log_rfile)
+		fclose(td->io_log_rfile);
 
 	td_set_runstate(td, TD_EXITED);
 
diff --git a/fio.1 b/fio.1
index a446aba..4386f85 100644
--- a/fio.1
+++ b/fio.1
@@ -2057,6 +2057,11 @@ to replay a workload captured by blktrace. See
 replay, the file needs to be turned into a blkparse binary data file first
 (`blkparse <device> \-o /dev/null \-d file_for_fio.bin').
 .TP
+.BI read_iolog_chunked \fR=\fPbool
+Determines how iolog is read. If false (default) entire \fBread_iolog\fR will
+be read at once. If selected true, input from iolog will be read gradually.
+Useful when iolog is very large, or it is generated.
+.TP
 .BI replay_no_stall \fR=\fPbool
 When replaying I/O with \fBread_iolog\fR the default behavior is to
 attempt to respect the timestamps within the log and replay them with the
diff --git a/fio.h b/fio.h
index 685aab1..b58057f 100644
--- a/fio.h
+++ b/fio.h
@@ -399,6 +399,11 @@ struct thread_data {
 	 * For IO replaying
 	 */
 	struct flist_head io_log_list;
+	FILE *io_log_rfile;
+	unsigned int io_log_current;
+	unsigned int io_log_checkmark;
+	unsigned int io_log_highmark;
+	struct timespec io_log_highmark_time;
 
 	/*
 	 * For tracking/handling discards
diff --git a/iolog.c b/iolog.c
index d51e49c..bd2a214 100644
--- a/iolog.c
+++ b/iolog.c
@@ -20,6 +20,13 @@
 #include "blktrace.h"
 #include "pshared.h"
 
+#include <netinet/in.h>
+#include <netinet/tcp.h>
+#include <arpa/inet.h>
+#include <sys/stat.h>
+#include <sys/socket.h>
+#include <sys/un.h>
+
 static int iolog_flush(struct io_log *log);
 
 static const char iolog_ver2[] = "fio version 2 iolog";
@@ -134,6 +141,8 @@ static int ipo_special(struct thread_data *td, struct io_piece *ipo)
 	return 1;
 }
 
+static bool read_iolog2(struct thread_data *td);
+
 int read_iolog_get(struct thread_data *td, struct io_u *io_u)
 {
 	struct io_piece *ipo;
@@ -141,7 +150,13 @@ int read_iolog_get(struct thread_data *td, struct io_u *io_u)
 
 	while (!flist_empty(&td->io_log_list)) {
 		int ret;
-
+		if (td->o.read_iolog_chunked) {
+			if (td->io_log_checkmark == td->io_log_current) {
+				if (!read_iolog2(td))
+					return 1;
+			}
+			td->io_log_current--;
+		}
 		ipo = flist_first_entry(&td->io_log_list, struct io_piece, list);
 		flist_del(&ipo->list);
 		remove_trim_entry(td, ipo);
@@ -334,11 +349,39 @@ void write_iolog_close(struct thread_data *td)
 	td->iolog_buf = NULL;
 }
 
+static int64_t iolog_items_to_fetch(struct thread_data *td)
+{
+	struct timespec now;
+	uint64_t elapsed;
+	uint64_t for_1s;
+	int64_t items_to_fetch;
+
+	if (!td->io_log_highmark)
+		return 10;
+
+
+	fio_gettime(&now, NULL);
+	elapsed = ntime_since(&td->io_log_highmark_time, &now);
+	if (elapsed) {
+		for_1s = (td->io_log_highmark - td->io_log_current) * 1000000000 / elapsed;
+		items_to_fetch = for_1s - td->io_log_current;
+		if (items_to_fetch < 0)
+			items_to_fetch = 0;
+	} else
+		items_to_fetch = 0;
+
+	td->io_log_highmark = td->io_log_current + items_to_fetch;
+	td->io_log_checkmark = (td->io_log_highmark + 1) / 2;
+	fio_gettime(&td->io_log_highmark_time, NULL);
+
+	return items_to_fetch;
+}
+
 /*
  * Read version 2 iolog data. It is enhanced to include per-file logging,
  * syncs, etc.
  */
-static bool read_iolog2(struct thread_data *td, FILE *f)
+static bool read_iolog2(struct thread_data *td)
 {
 	unsigned long long offset;
 	unsigned int bytes;
@@ -346,8 +389,13 @@ static bool read_iolog2(struct thread_data *td, FILE *f)
 	char *rfname, *fname, *act;
 	char *str, *p;
 	enum fio_ddir rw;
+	int64_t items_to_fetch = 0;
 
-	free_release_files(td);
+	if (td->o.read_iolog_chunked) {
+		items_to_fetch = iolog_items_to_fetch(td);
+		if (!items_to_fetch)
+			return true;
+	}
 
 	/*
 	 * Read in the read iolog and store it, reuse the infrastructure
@@ -358,7 +406,7 @@ static bool read_iolog2(struct thread_data *td, FILE *f)
 	act = malloc(256+16);
 
 	reads = writes = waits = 0;
-	while ((p = fgets(str, 4096, f)) != NULL) {
+	while ((p = fgets(str, 4096, td->io_log_rfile)) != NULL) {
 		struct io_piece *ipo;
 		int r;
 
@@ -461,18 +509,39 @@ static bool read_iolog2(struct thread_data *td, FILE *f)
 		}
 
 		queue_io_piece(td, ipo);
+
+		if (td->o.read_iolog_chunked) {
+			td->io_log_current++;
+			items_to_fetch--;
+			if (items_to_fetch == 0)
+				break;
+		}
 	}
 
 	free(str);
 	free(act);
 	free(rfname);
 
+	if (td->o.read_iolog_chunked) {
+		td->io_log_highmark = td->io_log_current;
+		td->io_log_checkmark = (td->io_log_highmark + 1) / 2;
+		fio_gettime(&td->io_log_highmark_time, NULL);
+	}
+
 	if (writes && read_only) {
 		log_err("fio: <%s> skips replay of %d writes due to"
 			" read-only\n", td->o.name, writes);
 		writes = 0;
 	}
 
+	if (td->o.read_iolog_chunked) {
+		if (td->io_log_current == 0) {
+			return false;
+		}
+		td->o.td_ddir = TD_DDIR_RW;
+		return true;
+	}
+
 	if (!reads && !writes && !waits)
 		return false;
 	else if (reads && !writes)
@@ -485,16 +554,46 @@ static bool read_iolog2(struct thread_data *td, FILE *f)
 	return true;
 }
 
+static bool is_socket(const char *path)
+{
+	struct stat buf;
+	int r = stat(path, &buf);
+	if (r == -1)
+		return false;
+
+	return S_ISSOCK(buf.st_mode);
+}
+
+static int open_socket(const char *path)
+{
+	int fd = socket(AF_UNIX, SOCK_STREAM, 0);
+	struct sockaddr_un addr;
+	if (fd < 0)
+		return fd;
+	addr.sun_family = AF_UNIX;
+	strncpy(addr.sun_path, path, sizeof(addr.sun_path));
+	if (connect(fd, (const struct sockaddr *)&addr, strlen(path) + sizeof(addr.sun_family)) == 0)
+		return fd;
+	else
+		close(fd);
+	return -1;
+}
+
 /*
  * open iolog, check version, and call appropriate parser
  */
 static bool init_iolog_read(struct thread_data *td)
 {
 	char buffer[256], *p;
-	FILE *f;
+	FILE *f = NULL;
 	bool ret;
-
-	f = fopen(td->o.read_iolog_file, "r");
+	if (is_socket(td->o.read_iolog_file)) {
+		int fd = open_socket(td->o.read_iolog_file);
+		if (fd >= 0) {
+			f = fdopen(fd, "r");
+		}
+	} else
+		f = fopen(td->o.read_iolog_file, "r");
 	if (!f) {
 		perror("fopen read iolog");
 		return false;
@@ -507,19 +606,20 @@ static bool init_iolog_read(struct thread_data *td)
 		fclose(f);
 		return false;
 	}
-
+	td->io_log_rfile = f;
 	/*
 	 * version 2 of the iolog stores a specific string as the
 	 * first line, check for that
 	 */
-	if (!strncmp(iolog_ver2, buffer, strlen(iolog_ver2)))
-		ret = read_iolog2(td, f);
+	if (!strncmp(iolog_ver2, buffer, strlen(iolog_ver2))) {
+		free_release_files(td);
+		ret = read_iolog2(td);
+	}
 	else {
 		log_err("fio: iolog version 1 is no longer supported\n");
 		ret = false;
 	}
 
-	fclose(f);
 	return ret;
 }
 
diff --git a/options.c b/options.c
index 4b46402..f592027 100644
--- a/options.c
+++ b/options.c
@@ -3135,6 +3135,17 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_IOLOG,
 	},
 	{
+		.name	= "read_iolog_chunked",
+		.lname	= "Read I/O log in parts",
+		.type	= FIO_OPT_BOOL,
+		.off1	= offsetof(struct thread_options, read_iolog_chunked),
+		.def	= "0",
+		.parent	= "read_iolog",
+		.help	= "Parse IO pattern in chunks",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_IOLOG,
+	},
+	{
 		.name	= "replay_no_stall",
 		.lname	= "Don't stall on replay",
 		.type	= FIO_OPT_BOOL,
diff --git a/os/os-windows.h b/os/os-windows.h
index 01f555e..aad446e 100644
--- a/os/os-windows.h
+++ b/os/os-windows.h
@@ -74,6 +74,10 @@ int rand_r(unsigned *);
 /* Winsock doesn't support MSG_WAIT */
 #define OS_MSG_DONTWAIT	0
 
+#ifndef S_ISSOCK
+#define S_ISSOCK(x) 0
+#endif
+
 #define SIGCONT	0
 #define SIGUSR1	1
 #define SIGUSR2 2
diff --git a/thread_options.h b/thread_options.h
index 8adba48..8bbf54b 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -247,6 +247,7 @@ struct thread_options {
 	fio_fp64_t percentile_list[FIO_IO_U_LIST_MAX_LEN];
 
 	char *read_iolog_file;
+	bool read_iolog_chunked;
 	char *write_iolog_file;
 
 	unsigned int write_bw_log;
