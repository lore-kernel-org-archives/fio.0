Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:37347 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab3KVE5U (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 21 Nov 2013 23:57:20 -0500
Received: from kernel.dk ([54.225.238.116])
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Vjinv-00066a-P1
	for fio@vger.kernel.org; Fri, 22 Nov 2013 04:57:19 +0000
Subject: Recent changes (master)
From: Jens Axboe <jaxboe@fusionio.com>
Message-Id: <20131122050001.B3C28231B1@kernel.dk>
Date: Fri, 22 Nov 2013 06:00:01 +0100 (CET)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 0cf2574b73599004958856c6e5d2e59ef5e531bf:

  Fio 2.1.4 (2013-11-16 11:15:12 -0700)

are available in the git repository at:
  git://git.kernel.dk/fio.git master

Jens Axboe (2):
      blktrace: add support for non-native endian format
      Error out gracefully if we don't find the replay device for log replay

 blktrace.c |   49 +++++++++++++++++++++++++++++++++++++++++++------
 fio.h      |    4 ++--
 iolog.c    |    9 +++++++--
 os/os.h    |    5 +++--
 4 files changed, 55 insertions(+), 12 deletions(-)

---

Diff of recent changes:

diff --git a/blktrace.c b/blktrace.c
index e195f7f..9e4e599 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -71,7 +71,7 @@ static int discard_pdu(struct thread_data *td, struct fifo *fifo, int fd,
  * Check if this is a blktrace binary data file. We read a single trace
  * into memory and check for the magic signature.
  */
-int is_blktrace(const char *filename)
+int is_blktrace(const char *filename, int *need_swap)
 {
 	struct blk_io_trace t;
 	int fd, ret;
@@ -91,8 +91,19 @@ int is_blktrace(const char *filename)
 		return 0;
 	}
 
-	if ((t.magic & 0xffffff00) == BLK_IO_TRACE_MAGIC)
+	if ((t.magic & 0xffffff00) == BLK_IO_TRACE_MAGIC) {
+		*need_swap = 0;
 		return 1;
+	}
+
+	/*
+	 * Maybe it needs to be endian swapped...
+	 */
+	t.magic = fio_swap32(t.magic);
+	if ((t.magic & 0xffffff00) == BLK_IO_TRACE_MAGIC) {
+		*need_swap = 1;
+		return 1;
+	}
 
 	return 0;
 }
@@ -209,6 +220,7 @@ static int trace_add_file(struct thread_data *td, __u32 device)
 		trace_add_open_close_event(td, fileno, FIO_LOG_OPEN_FILE);
 		last_fileno = fileno;
 	}
+
 	return last_fileno;
 }
 
@@ -245,10 +257,12 @@ static void handle_trace_notify(struct blk_io_trace *t)
 {
 	switch (t->action) {
 	case BLK_TN_PROCESS:
-		printf("got process notify: %x, %d\n", t->action, t->pid);
+		log_info("blktrace: got process notify: %x, %d\n",
+				t->action, t->pid);
 		break;
 	case BLK_TN_TIMESTAMP:
-		printf("got timestamp notify: %x, %d\n", t->action, t->pid);
+		log_info("blktrace: got timestamp notify: %x, %d\n",
+				t->action, t->pid);
 		break;
 	case BLK_TN_MESSAGE:
 		break;
@@ -328,11 +342,26 @@ static void handle_trace(struct thread_data *td, struct blk_io_trace *t,
 		handle_trace_fs(td, t, ttime, ios, bs);
 }
 
+static void byteswap_trace(struct blk_io_trace *t)
+{
+	t->magic = fio_swap32(t->magic);
+	t->sequence = fio_swap32(t->sequence);
+	t->time = fio_swap64(t->time);
+	t->sector = fio_swap64(t->sector);
+	t->bytes = fio_swap32(t->bytes);
+	t->action = fio_swap32(t->action);
+	t->pid = fio_swap32(t->pid);
+	t->device = fio_swap32(t->device);
+	t->cpu = fio_swap32(t->cpu);
+	t->error = fio_swap16(t->error);
+	t->pdu_len = fio_swap16(t->pdu_len);
+}
+
 /*
  * Load a blktrace file by reading all the blk_io_trace entries, and storing
  * them as io_pieces like the fio text version would do.
  */
-int load_blktrace(struct thread_data *td, const char *filename)
+int load_blktrace(struct thread_data *td, const char *filename, int need_swap)
 {
 	unsigned long long ttime, delay;
 	struct blk_io_trace t;
@@ -370,6 +399,9 @@ int load_blktrace(struct thread_data *td, const char *filename)
 			break;
 		}
 
+		if (need_swap)
+			byteswap_trace(&t);
+
 		if ((t.magic & 0xffffff00) != BLK_IO_TRACE_MAGIC) {
 			log_err("fio: bad magic in blktrace data: %x\n",
 								t.magic);
@@ -419,13 +451,18 @@ int load_blktrace(struct thread_data *td, const char *filename)
 	} while (1);
 
 	for (i = 0; i < td->files_index; i++) {
-		f= td->files[i];
+		f = td->files[i];
 		trace_add_open_close_event(td, f->fileno, FIO_LOG_CLOSE_FILE);
 	}
 
 	fifo_free(fifo);
 	close(fd);
 
+	if (!td->files_index) {
+		log_err("fio: did not find replay device(s)\n");
+		return 1;
+	}
+
 	if (skipped_writes)
 		log_err("fio: %s skips replay of %lu writes due to read-only\n",
 						td->o.name, skipped_writes);
diff --git a/fio.h b/fio.h
index 0d7fbeb..a6dcb4e 100644
--- a/fio.h
+++ b/fio.h
@@ -479,8 +479,8 @@ extern void reset_all_stats(struct thread_data *);
  * blktrace support
  */
 #ifdef FIO_HAVE_BLKTRACE
-extern int is_blktrace(const char *);
-extern int load_blktrace(struct thread_data *, const char *);
+extern int is_blktrace(const char *, int *);
+extern int load_blktrace(struct thread_data *, const char *, int);
 #endif
 
 #define for_each_td(td, i)	\
diff --git a/iolog.c b/iolog.c
index 9bcf0d8..6593367 100644
--- a/iolog.c
+++ b/iolog.c
@@ -480,17 +480,22 @@ int init_iolog(struct thread_data *td)
 	int ret = 0;
 
 	if (td->o.read_iolog_file) {
+		int need_swap;
+
 		/*
 		 * Check if it's a blktrace file and load that if possible.
 		 * Otherwise assume it's a normal log file and load that.
 		 */
-		if (is_blktrace(td->o.read_iolog_file))
-			ret = load_blktrace(td, td->o.read_iolog_file);
+		if (is_blktrace(td->o.read_iolog_file, &need_swap))
+			ret = load_blktrace(td, td->o.read_iolog_file, need_swap);
 		else
 			ret = init_iolog_read(td);
 	} else if (td->o.write_iolog_file)
 		ret = init_iolog_write(td);
 
+	if (ret)
+		td_verror(td, EINVAL, "failed initializing iolog");
+
 	return ret;
 }
 
diff --git a/os/os.h b/os/os.h
index 715f226..4b59034 100644
--- a/os/os.h
+++ b/os/os.h
@@ -220,12 +220,13 @@ static inline uint64_t fio_swap64(uint64_t val)
 })
 
 #ifndef FIO_HAVE_BLKTRACE
-static inline int is_blktrace(const char *fname)
+static inline int is_blktrace(const char *fname, int *need_swap)
 {
 	return 0;
 }
 struct thread_data;
-static inline int load_blktrace(struct thread_data *td, const char *fname)
+static inline int load_blktrace(struct thread_data *td, const char *fname,
+				int need_swap)
 {
 	return 1;
 }
