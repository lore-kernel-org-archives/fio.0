Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:41127 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934094AbdCVMAx (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 22 Mar 2017 08:00:53 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cqevu-0000U9-95
        for fio@vger.kernel.org; Wed, 22 Mar 2017 12:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170322120002.417872C0232@kernel.dk>
Date: Wed, 22 Mar 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit cee3ddfee4d39ec9ba31b7329a343053af057914:

  Merge branch 'wip-fix-bs-title' of https://github.com/liupan1111/fio (2017-03-19 19:49:04 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f678f8d2aa7f6972b18e368fe42f7bc48134e66c:

  configure: add a --disable-rdma flag to control rdma deps (2017-03-21 07:20:32 -0600)

----------------------------------------------------------------
Mike Frysinger (1):
      configure: add a --disable-rdma flag to control rdma deps

Tomohiro Kusumi (7):
      Replace redundant TD_F_NOIO flag with td->io_ops_init
      Define struct sk_out in server.h (not server.c)
      HOWTO: Mention cpuload= is mandatory for cpuio
      HOWTO: Mention fsync=/fsyncdata= are set to 0 by default
      Fix a comment after f227e2b6
      Test uint,int before division uint/int for the next i/o
      Test fsync/fdatasync/sync_file_range for the next i/o only if should_fsync(td)

 HOWTO       |  8 ++++++--
 configure   |  7 +++++--
 filesetup.c |  9 +++++----
 fio.h       |  4 ++--
 init.c      |  1 +
 io_u.c      | 36 +++++++++++++++---------------------
 ioengines.c | 14 +++++++-------
 libfio.c    |  2 +-
 server.c    | 11 -----------
 server.h    | 11 +++++++++++
 10 files changed, 53 insertions(+), 50 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 5d378f3..cae95b7 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1100,13 +1100,15 @@ I/O type
 	blocks given. For example, if you give 32 as a parameter, fio will sync the
 	file for every 32 writes issued. If fio is using non-buffered I/O, we may
 	not sync the file. The exception is the sg I/O engine, which synchronizes
-	the disk cache anyway.
+	the disk cache anyway. Defaults to 0, which means no sync every certain
+	number of writes.
 
 .. option:: fdatasync=int
 
 	Like :option:`fsync` but uses :manpage:`fdatasync(2)` to only sync data and
 	not metadata blocks.  In Windows, FreeBSD, and DragonFlyBSD there is no
 	:manpage:`fdatasync(2)`, this falls back to using :manpage:`fsync(2)`.
+	Defaults to 0, which means no sync data every certain number of writes.
 
 .. option:: write_barrier=int
 
@@ -1571,6 +1573,7 @@ I/O engine
 		**sync**
 			Basic :manpage:`read(2)` or :manpage:`write(2)`
 			I/O. :manpage:`lseek(2)` is used to position the I/O location.
+			See :option:`fsync` and :option:`fdatasync` for syncing write I/Os.
 
 		**psync**
 			Basic :manpage:`pread(2)` or :manpage:`pwrite(2)` I/O.  Default on
@@ -1748,7 +1751,8 @@ caveat that when used on the command line, they must come after the
 
 .. option:: cpuload=int : [cpuio]
 
-	Attempt to use the specified percentage of CPU cycles.
+	Attempt to use the specified percentage of CPU cycles. This is a mandatory
+	option when using cpuio I/O engine.
 
 .. option:: cpuchunks=int : [cpuio]
 
diff --git a/configure b/configure
index 9335124..f42489b 100755
--- a/configure
+++ b/configure
@@ -166,6 +166,8 @@ for opt do
   ;;
   --disable-numa) disable_numa="yes"
   ;;
+  --disable-rdma) disable_rdma="yes"
+  ;;
   --disable-rbd) disable_rbd="yes"
   ;;
   --disable-rbd-blkin) disable_rbd_blkin="yes"
@@ -204,6 +206,7 @@ if test "$show_help" = "yes" ; then
   echo "--esx                   Configure build options for esx"
   echo "--enable-gfio           Enable building of gtk gfio"
   echo "--disable-numa          Disable libnuma even if found"
+  echo "--disable-rdma         Disable RDMA support even if found"
   echo "--disable-gfapi         Disable gfapi"
   echo "--enable-libhdfs        Enable hdfs support"
   echo "--disable-lex           Disable use of lex/yacc for math"
@@ -692,7 +695,7 @@ int main(int argc, char **argv)
   return 0;
 }
 EOF
-if compile_prog "" "-libverbs" "libverbs" ; then
+if test "$disable_rdma" != "yes" && compile_prog "" "-libverbs" "libverbs" ; then
     libverbs="yes"
     LIBS="-libverbs $LIBS"
 fi
@@ -712,7 +715,7 @@ int main(int argc, char **argv)
   return 0;
 }
 EOF
-if compile_prog "" "-lrdmacm" "rdma"; then
+if test "$disable_rdma" != "yes" && compile_prog "" "-lrdmacm" "rdma"; then
     rdmacm="yes"
     LIBS="-lrdmacm $LIBS"
 fi
diff --git a/filesetup.c b/filesetup.c
index c9f2b5f..bcf95bd 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -932,10 +932,11 @@ int setup_files(struct thread_data *td)
 			}
 
 			/*
-			 * We normally don't come here, but if the result is 0,
-			 * set it to the real file size. This could be size of
-			 * the existing one if it already exists, but otherwise
-			 * will be set to 0. A new file won't be created because
+			 * We normally don't come here for regular files, but
+			 * if the result is 0 for a regular file, set it to the
+			 * real file size. This could be size of the existing
+			 * one if it already exists, but otherwise will be set
+			 * to 0. A new file won't be created because
 			 * ->io_size + ->file_offset equals ->real_file_size.
 			 */
 			if (!f->io_size) {
diff --git a/fio.h b/fio.h
index b573ac5..52a9b75 100644
--- a/fio.h
+++ b/fio.h
@@ -74,7 +74,7 @@ enum {
 	TD_F_VER_NONE		= 1U << 5,
 	TD_F_PROFILE_OPS	= 1U << 6,
 	TD_F_COMPRESS		= 1U << 7,
-	TD_F_NOIO		= 1U << 8,
+	TD_F_RESERVED		= 1U << 8, /* not used */
 	TD_F_COMPRESS_LOG	= 1U << 9,
 	TD_F_VSTATE_SAVED	= 1U << 10,
 	TD_F_NEED_LOCK		= 1U << 11,
@@ -121,7 +121,6 @@ enum {
  * Per-thread/process specific data. Only used for the network client
  * for now.
  */
-struct sk_out;
 void sk_out_assign(struct sk_out *);
 void sk_out_drop(void);
 
@@ -231,6 +230,7 @@ struct thread_data {
 	 * to any of the available IO engines.
 	 */
 	struct ioengine_ops *io_ops;
+	int io_ops_init;
 
 	/*
 	 * IO engine private data and dlhandle.
diff --git a/init.c b/init.c
index b4b0974..4a72255 100644
--- a/init.c
+++ b/init.c
@@ -459,6 +459,7 @@ static struct thread_data *get_new_job(bool global, struct thread_data *parent,
 		copy_opt_list(td, parent);
 
 	td->io_ops = NULL;
+	td->io_ops_init = 0;
 	if (!preserve_eo)
 		td->eo = NULL;
 
diff --git a/io_u.c b/io_u.c
index 5f01c1b..c6d814b 100644
--- a/io_u.c
+++ b/io_u.c
@@ -717,28 +717,22 @@ static enum fio_ddir get_rw_ddir(struct thread_data *td)
 	enum fio_ddir ddir;
 
 	/*
-	 * see if it's time to fsync
+	 * See if it's time to fsync/fdatasync/sync_file_range first,
+	 * and if not then move on to check regular I/Os.
 	 */
-	if (td->o.fsync_blocks &&
-	   !(td->io_issues[DDIR_WRITE] % td->o.fsync_blocks) &&
-	     td->io_issues[DDIR_WRITE] && should_fsync(td))
-		return DDIR_SYNC;
-
-	/*
-	 * see if it's time to fdatasync
-	 */
-	if (td->o.fdatasync_blocks &&
-	   !(td->io_issues[DDIR_WRITE] % td->o.fdatasync_blocks) &&
-	     td->io_issues[DDIR_WRITE] && should_fsync(td))
-		return DDIR_DATASYNC;
-
-	/*
-	 * see if it's time to sync_file_range
-	 */
-	if (td->sync_file_range_nr &&
-	   !(td->io_issues[DDIR_WRITE] % td->sync_file_range_nr) &&
-	     td->io_issues[DDIR_WRITE] && should_fsync(td))
-		return DDIR_SYNC_FILE_RANGE;
+	if (should_fsync(td)) {
+		if (td->o.fsync_blocks && td->io_issues[DDIR_WRITE] &&
+		    !(td->io_issues[DDIR_WRITE] % td->o.fsync_blocks))
+			return DDIR_SYNC;
+
+		if (td->o.fdatasync_blocks && td->io_issues[DDIR_WRITE] &&
+		    !(td->io_issues[DDIR_WRITE] % td->o.fdatasync_blocks))
+			return DDIR_DATASYNC;
+
+		if (td->sync_file_range_nr && td->io_issues[DDIR_WRITE] &&
+		    !(td->io_issues[DDIR_WRITE] % td->sync_file_range_nr))
+			return DDIR_SYNC_FILE_RANGE;
+	}
 
 	if (td_rw(td)) {
 		/*
diff --git a/ioengines.c b/ioengines.c
index 95013d1..c773f2e 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -368,17 +368,17 @@ int td_io_init(struct thread_data *td)
 
 	if (td->io_ops->init) {
 		ret = td->io_ops->init(td);
-		if (ret && td->o.iodepth > 1) {
-			log_err("fio: io engine init failed. Perhaps try"
-				" reducing io depth?\n");
-		}
+		if (ret)
+			log_err("fio: io engine %s init failed.%s\n",
+				td->io_ops->name,
+				td->o.iodepth > 1 ?
+				" Perhaps try reducing io depth?" : "");
+		else
+			td->io_ops_init = 1;
 		if (!td->error)
 			td->error = ret;
 	}
 
-	if (!ret && td_ioengine_flagged(td, FIO_NOIO))
-		td->flags |= TD_F_NOIO;
-
 	return ret;
 }
 
diff --git a/libfio.c b/libfio.c
index 4b53c92..8310708 100644
--- a/libfio.c
+++ b/libfio.c
@@ -276,7 +276,7 @@ int fio_running_or_pending_io_threads(void)
 	int nr_io_threads = 0;
 
 	for_each_td(td, i) {
-		if (td->flags & TD_F_NOIO)
+		if (td->io_ops_init && td_ioengine_flagged(td, FIO_NOIO))
 			continue;
 		nr_io_threads++;
 		if (td->runstate < TD_EXITED)
diff --git a/server.c b/server.c
index 6d5d4ea..1b3bc30 100644
--- a/server.c
+++ b/server.c
@@ -50,17 +50,6 @@ struct sk_entry {
 	struct flist_head next;	/* Other sk_entry's, if linked command */
 };
 
-struct sk_out {
-	unsigned int refs;	/* frees sk_out when it drops to zero.
-				 * protected by below ->lock */
-
-	int sk;			/* socket fd to talk to client */
-	struct fio_mutex lock;	/* protects ref and below list */
-	struct flist_head list;	/* list of pending transmit work */
-	struct fio_mutex wait;	/* wake backend when items added to list */
-	struct fio_mutex xmit;	/* held while sending data */
-};
-
 static char *fio_server_arg;
 static char *bind_sock;
 static struct sockaddr_in saddr_in;
diff --git a/server.h b/server.h
index 3a1d0b0..798d5a8 100644
--- a/server.h
+++ b/server.h
@@ -12,6 +12,17 @@
 
 #define FIO_NET_PORT 8765
 
+struct sk_out {
+	unsigned int refs;	/* frees sk_out when it drops to zero.
+				 * protected by below ->lock */
+
+	int sk;			/* socket fd to talk to client */
+	struct fio_mutex lock;	/* protects ref and below list */
+	struct flist_head list;	/* list of pending transmit work */
+	struct fio_mutex wait;	/* wake backend when items added to list */
+	struct fio_mutex xmit;	/* held while sending data */
+};
+
 /*
  * On-wire encoding is little endian
  */
