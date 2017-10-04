Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:46760 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752303AbdJDMAS (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 4 Oct 2017 08:00:18 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dziLZ-0007uD-Be
        for fio@vger.kernel.org; Wed, 04 Oct 2017 12:00:17 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20171004120001.B92A52C0111@kernel.dk>
Date: Wed,  4 Oct 2017 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c16035aadd600a3a4c4b241339e3d3099f56c4b2:

  backend: fix a case where we complain about no IO being done (2017-09-28 06:58:23 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e6fe02651641fc64d2fa4fcfe9b1013b2947d11b:

  Merge branch 'master' of https://github.com/dyniusz/fio (2017-10-03 11:19:26 -0600)

----------------------------------------------------------------
Erwan Velu (7):
      io_u: Converting usec from long to uint64_t
      backend: Removing double definition of the same variable
      backend: Removing memory leak in run_threads()
      oslib/libmtd: Removing useless err assigment
      t/gen-rand: Avoid memleak of buckets()
      client:  Avoid memory leak in fio_client_handle_iolog()
      client: Fixing invalid use after free()

Jens Axboe (3):
      Merge branch 'evelu/cleanup' of https://github.com/ErwanAliasr1/fio
      client: fix pointer vs uint8_t comparison
      Merge branch 'master' of https://github.com/dyniusz/fio

dyniusz (2):
      Adjustments to support C++ engines
      null context segfault fix

 backend.c             |   2 +-
 client.c              |  37 +++++++++---
 engines/null.c        | 164 +++++++++++++++++++++++++++++++++++++++++++-------
 examples/cpp_null.fio |  10 +++
 file.h                |   6 ++
 io_u.c                |   2 +-
 ioengines.c           |   5 +-
 lib/types.h           |   2 +-
 oslib/libmtd.c        |   1 -
 t/gen-rand.c          |   2 +-
 10 files changed, 192 insertions(+), 39 deletions(-)
 create mode 100644 examples/cpp_null.fio

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index e4eff37..b1995ef 100644
--- a/backend.c
+++ b/backend.c
@@ -499,7 +499,6 @@ int io_queue_event(struct thread_data *td, struct io_u *io_u, int *ret,
 			if (ddir_rw(io_u->ddir))
 				td->ts.short_io_u[io_u->ddir]++;
 
-			f = io_u->file;
 			if (io_u->offset == f->real_file_size)
 				goto sync_done;
 
@@ -2347,6 +2346,7 @@ reap:
 				fio_terminate_threads(TERMINATE_ALL);
 				fio_abort = 1;
 				nr_started--;
+				free(fd);
 				break;
 			}
 			dprint(FD_MUTEX, "done waiting on startup_mutex\n");
diff --git a/client.c b/client.c
index 09e810a..779fb9d 100644
--- a/client.c
+++ b/client.c
@@ -1312,14 +1312,16 @@ static void client_flush_hist_samples(FILE *f, int hist_coarseness, void *sample
 static int fio_client_handle_iolog(struct fio_client *client,
 				   struct fio_net_cmd *cmd)
 {
-	struct cmd_iolog_pdu *pdu;
+	struct cmd_iolog_pdu *pdu = NULL;
 	bool store_direct;
-	char *log_pathname;
+	char *log_pathname = NULL;
+	int ret = 0;
 
 	pdu = convert_iolog(cmd, &store_direct);
 	if (!pdu) {
 		log_err("fio: failed converting IO log\n");
-		return 1;
+		ret = 1;
+		goto out;
 	}
 
         /* allocate buffer big enough for next sprintf() call */
@@ -1327,7 +1329,8 @@ static int fio_client_handle_iolog(struct fio_client *client,
 			strlen(client->hostname));
 	if (!log_pathname) {
 		log_err("fio: memory allocation of unique pathname failed\n");
-		return -1;
+		ret = -1;
+		goto out;
 	}
 	/* generate a unique pathname for the log file using hostname */
 	sprintf(log_pathname, "%s.%s", pdu->name, client->hostname);
@@ -1342,7 +1345,8 @@ static int fio_client_handle_iolog(struct fio_client *client,
 		if (fd < 0) {
 			log_err("fio: open log %s: %s\n",
 				log_pathname, strerror(errno));
-			return 1;
+			ret = 1;
+			goto out;
 		}
 
 		sz = cmd->pdu_len - sizeof(*pdu);
@@ -1351,17 +1355,19 @@ static int fio_client_handle_iolog(struct fio_client *client,
 
 		if (ret != sz) {
 			log_err("fio: short write on compressed log\n");
-			return 1;
+			ret = 1;
+			goto out;
 		}
 
-		return 0;
+		ret = 0;
 	} else {
 		FILE *f;
 		f = fopen((const char *) log_pathname, "w");
 		if (!f) {
 			log_err("fio: fopen log %s : %s\n",
 				log_pathname, strerror(errno));
-			return 1;
+			ret = 1;
+			goto out;
 		}
 
 		if (pdu->log_type == IO_LOG_TYPE_HIST) {
@@ -1372,8 +1378,17 @@ static int fio_client_handle_iolog(struct fio_client *client,
 					pdu->nr_samples * sizeof(struct io_sample));
 		}
 		fclose(f);
-		return 0;
+		ret = 0;
 	}
+
+out:
+	if (pdu && pdu != (void *) cmd->payload)
+		free(pdu);
+
+	if (log_pathname)
+		free(log_pathname);
+
+	return ret;
 }
 
 static void handle_probe(struct fio_client *client, struct fio_net_cmd *cmd)
@@ -1849,10 +1864,12 @@ static void request_client_etas(struct client_ops *ops)
 static int handle_cmd_timeout(struct fio_client *client,
 			      struct fio_net_cmd_reply *reply)
 {
+	uint16_t reply_opcode = reply->opcode;
+
 	flist_del(&reply->list);
 	free(reply);
 
-	if (reply->opcode != FIO_NET_CMD_SEND_ETA)
+	if (reply_opcode != FIO_NET_CMD_SEND_ETA)
 		return 1;
 
 	log_info("client <%s>: timeout on SEND_ETA\n", client->hostname);
diff --git a/engines/null.c b/engines/null.c
index 812cadf..8a4d106 100644
--- a/engines/null.c
+++ b/engines/null.c
@@ -6,7 +6,11 @@
  *
  * It also can act as external C++ engine - compiled with:
  *
- * g++ -O2 -g -shared -rdynamic -fPIC -o null.so null.c -DFIO_EXTERNAL_ENGINE
+ * g++ -O2 -g -shared -rdynamic -fPIC -o cpp_null null.c -DFIO_EXTERNAL_ENGINE
+ *
+ * to test it execute:
+ *
+ * LD_LIBRARY_PATH=./engines ./fio examples/cpp_null.fio
  *
  */
 #include <stdio.h>
@@ -23,20 +27,17 @@ struct null_data {
 	int events;
 };
 
-static struct io_u *fio_null_event(struct thread_data *td, int event)
+static struct io_u *null_event(struct null_data *nd, int event)
 {
-	struct null_data *nd = (struct null_data *) td->io_ops_data;
-
 	return nd->io_us[event];
 }
 
-static int fio_null_getevents(struct thread_data *td, unsigned int min_events,
-			      unsigned int fio_unused max,
-			      const struct timespec fio_unused *t)
+static int null_getevents(struct null_data *nd, unsigned int min_events,
+			  unsigned int fio_unused max,
+			  const struct timespec fio_unused *t)
 {
-	struct null_data *nd = (struct null_data *) td->io_ops_data;
 	int ret = 0;
-	
+
 	if (min_events) {
 		ret = nd->events;
 		nd->events = 0;
@@ -45,10 +46,8 @@ static int fio_null_getevents(struct thread_data *td, unsigned int min_events,
 	return ret;
 }
 
-static int fio_null_commit(struct thread_data *td)
+static int null_commit(struct thread_data *td, struct null_data *nd)
 {
-	struct null_data *nd = (struct null_data *) td->io_ops_data;
-
 	if (!nd->events) {
 #ifndef FIO_EXTERNAL_ENGINE
 		io_u_mark_submit(td, nd->queued);
@@ -60,10 +59,9 @@ static int fio_null_commit(struct thread_data *td)
 	return 0;
 }
 
-static int fio_null_queue(struct thread_data *td, struct io_u *io_u)
+static int null_queue(struct thread_data *td, struct null_data *nd,
+		      struct io_u *io_u)
 {
-	struct null_data *nd = (struct null_data *) td->io_ops_data;
-
 	fio_ro_check(td, io_u);
 
 	if (td->io_ops->flags & FIO_SYNCIO)
@@ -75,25 +73,23 @@ static int fio_null_queue(struct thread_data *td, struct io_u *io_u)
 	return FIO_Q_QUEUED;
 }
 
-static int fio_null_open(struct thread_data fio_unused *td,
-			 struct fio_file fio_unused *f)
+static int null_open(struct null_data fio_unused *nd,
+		     struct fio_file fio_unused *f)
 {
 	return 0;
 }
 
-static void fio_null_cleanup(struct thread_data *td)
+static void null_cleanup(struct null_data *nd)
 {
-	struct null_data *nd = (struct null_data *) td->io_ops_data;
-
 	if (nd) {
 		free(nd->io_us);
 		free(nd);
 	}
 }
 
-static int fio_null_init(struct thread_data *td)
+static int null_init(struct thread_data *td, struct null_data **nd_ptr)
 {
-	struct null_data *nd = (struct null_data *) malloc(sizeof(*nd));
+	struct null_data *nd = (struct null_data *) malloc(sizeof(**nd_ptr));
 
 	memset(nd, 0, sizeof(*nd));
 
@@ -103,11 +99,49 @@ static int fio_null_init(struct thread_data *td)
 	} else
 		td->io_ops->flags |= FIO_SYNCIO;
 
-	td->io_ops_data = nd;
+	*nd_ptr = nd;
 	return 0;
 }
 
 #ifndef __cplusplus
+
+static struct io_u *fio_null_event(struct thread_data *td, int event)
+{
+	return null_event((struct null_data *)td->io_ops_data, event);
+}
+
+static int fio_null_getevents(struct thread_data *td, unsigned int min_events,
+			      unsigned int max, const struct timespec *t)
+{
+	struct null_data *nd = (struct null_data *)td->io_ops_data;
+	return null_getevents(nd, min_events, max, t);
+}
+
+static int fio_null_commit(struct thread_data *td)
+{
+	return null_commit(td, (struct null_data *)td->io_ops_data);
+}
+
+static int fio_null_queue(struct thread_data *td, struct io_u *io_u)
+{
+	return null_queue(td, (struct null_data *)td->io_ops_data, io_u);
+}
+
+static int fio_null_open(struct thread_data *td, struct fio_file *f)
+{
+	return null_open((struct null_data *)td->io_ops_data, f);
+}
+
+static void fio_null_cleanup(struct thread_data *td)
+{
+	null_cleanup((struct null_data *)td->io_ops_data);
+}
+
+static int fio_null_init(struct thread_data *td)
+{
+	return null_init(td, (struct null_data **)&td->io_ops_data);
+}
+
 static struct ioengine_ops ioengine = {
 	.name		= "null",
 	.version	= FIO_IOOPS_VERSION,
@@ -134,7 +168,91 @@ static void fio_exit fio_null_unregister(void)
 #else
 
 #ifdef FIO_EXTERNAL_ENGINE
+
+struct NullData {
+	NullData(struct thread_data *td)
+	{
+		null_init(td, &impl_);
+	}
+
+	~NullData()
+	{
+		null_cleanup(impl_);
+	}
+
+	static NullData *get(struct thread_data *td)
+	{
+		return reinterpret_cast<NullData *>(td->io_ops_data);
+	}
+
+	io_u *fio_null_event(struct thread_data *, int event)
+	{
+		return null_event(impl_, event);
+	}
+
+	int fio_null_getevents(struct thread_data *, unsigned int min_events,
+			       unsigned int max, const struct timespec *t)
+	{
+		return null_getevents(impl_, min_events, max, t);
+	}
+
+	int fio_null_commit(struct thread_data *td)
+	{
+		return null_commit(td, impl_);
+	}
+
+	int fio_null_queue(struct thread_data *td, struct io_u *io_u)
+	{
+		return null_queue(td, impl_, io_u);
+	}
+
+	int fio_null_open(struct thread_data *, struct fio_file *f)
+	{
+		return null_open(impl_, f);
+	}
+
+	struct null_data *impl_;
+};
+
 extern "C" {
+
+static struct io_u *fio_null_event(struct thread_data *td, int event)
+{
+	return NullData::get(td)->fio_null_event(td, event);
+}
+
+static int fio_null_getevents(struct thread_data *td, unsigned int min_events,
+			      unsigned int max, const struct timespec *t)
+{
+	return NullData::get(td)->fio_null_getevents(td, min_events, max, t);
+}
+
+static int fio_null_commit(struct thread_data *td)
+{
+	return NullData::get(td)->fio_null_commit(td);
+}
+
+static int fio_null_queue(struct thread_data *td, struct io_u *io_u)
+{
+	return NullData::get(td)->fio_null_queue(td, io_u);
+}
+
+static int fio_null_open(struct thread_data *td, struct fio_file *f)
+{
+	return NullData::get(td)->fio_null_open(td, f);
+}
+
+static int fio_null_init(struct thread_data *td)
+{
+	td->io_ops_data = new NullData(td);
+	return 0;
+}
+
+static void fio_null_cleanup(struct thread_data *td)
+{
+	delete NullData::get(td);
+}
+
 static struct ioengine_ops ioengine;
 void get_ioengine(struct ioengine_ops **ioengine_ptr)
 {
diff --git a/examples/cpp_null.fio b/examples/cpp_null.fio
new file mode 100644
index 0000000..436ed90
--- /dev/null
+++ b/examples/cpp_null.fio
@@ -0,0 +1,10 @@
+[global]
+bs=4k
+gtod_reduce=1
+
+[null]
+ioengine=cpp_null
+size=100g
+rw=randread
+norandommap
+time_based=0
diff --git a/file.h b/file.h
index ad8802d..e3864ee 100644
--- a/file.h
+++ b/file.h
@@ -188,9 +188,15 @@ extern void close_and_free_files(struct thread_data *);
 extern uint64_t get_start_offset(struct thread_data *, struct fio_file *);
 extern int __must_check setup_files(struct thread_data *);
 extern int __must_check file_invalidate_cache(struct thread_data *, struct fio_file *);
+#ifdef __cplusplus
+extern "C" {
+#endif
 extern int __must_check generic_open_file(struct thread_data *, struct fio_file *);
 extern int __must_check generic_close_file(struct thread_data *, struct fio_file *);
 extern int __must_check generic_get_file_size(struct thread_data *, struct fio_file *);
+#ifdef __cplusplus
+}
+#endif
 extern int __must_check file_lookup_open(struct fio_file *f, int flags);
 extern int __must_check pre_read_files(struct thread_data *);
 extern unsigned long long get_rand_file_size(struct thread_data *td);
diff --git a/io_u.c b/io_u.c
index e98cd31..58c2320 100644
--- a/io_u.c
+++ b/io_u.c
@@ -662,7 +662,7 @@ int io_u_quiesce(struct thread_data *td)
 static enum fio_ddir rate_ddir(struct thread_data *td, enum fio_ddir ddir)
 {
 	enum fio_ddir odir = ddir ^ 1;
-	long usec;
+	uint64_t usec;
 	uint64_t now;
 
 	assert(ddir_rw(ddir));
diff --git a/ioengines.c b/ioengines.c
index 9638d80..1bfc06f 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -133,8 +133,10 @@ static struct ioengine_ops *__load_ioengine(const char *name)
 	/*
 	 * linux libaio has alias names, so convert to what we want
 	 */
-	if (!strncmp(engine, "linuxaio", 8) || !strncmp(engine, "aio", 3))
+	if (!strncmp(engine, "linuxaio", 8) || !strncmp(engine, "aio", 3)) {
+		dprint(FD_IO, "converting ioengine name: %s -> libaio\n", name);
 		strcpy(engine, "libaio");
+	}
 
 	dprint(FD_IO, "load ioengine %s\n", engine);
 	return find_ioengine(engine);
@@ -436,6 +438,7 @@ int td_io_open_file(struct thread_data *td, struct fio_file *f)
 {
 	assert(!fio_file_open(f));
 	assert(f->fd == -1);
+	assert(td->io_ops->open_file);
 
 	if (td->io_ops->open_file(td, f)) {
 		if (td->error == EINVAL && td->o.odirect)
diff --git a/lib/types.h b/lib/types.h
index 287a3b4..bb24506 100644
--- a/lib/types.h
+++ b/lib/types.h
@@ -1,7 +1,7 @@
 #ifndef FIO_TYPES_H
 #define FIO_TYPES_H
 
-#ifndef CONFIG_HAVE_BOOL
+#if !defined(CONFIG_HAVE_BOOL) && !defined(__cplusplus)
 typedef int bool;
 #ifndef false
 #define false	0
diff --git a/oslib/libmtd.c b/oslib/libmtd.c
index 24e9db9..5d18871 100644
--- a/oslib/libmtd.c
+++ b/oslib/libmtd.c
@@ -1002,7 +1002,6 @@ int mtd_torture(libmtd_t desc, const struct mtd_dev_info *mtd, int fd, int eb)
 		}
 	}
 
-	err = 0;
 	normsg("PEB %d passed torture test, do not mark it a bad", eb);
 
 out:
diff --git a/t/gen-rand.c b/t/gen-rand.c
index 6c31f92..4e9d39c 100644
--- a/t/gen-rand.c
+++ b/t/gen-rand.c
@@ -63,6 +63,6 @@ int main(int argc, char *argv[])
 	}
 
 	printf("Passes=%lu, Fail=%lu\n", pass, fail);
-
+	free(buckets);
 	return 0;
 }
