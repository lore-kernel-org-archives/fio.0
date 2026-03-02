Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5876C3CCA06
	for <fio@vger.kernel.org>; Mon,  2 Mar 2026 13:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772456412; cv=none; b=QY3v6R9gVND+HZfM9pp0RCtdwCbwHOs78hkJl3u+pJLRDmZC+E4SITjcEMcedmeKDQnTazyvRRyL+sfAONJfY4ptPzSTkM2lg1xOK16jZ0YfbY35h4mjlfAjM6O/gg/5Loew0IIRwx8gaBB5C1Z58Sb/TC2XqQ0l/H6zoOZQ7Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772456412; c=relaxed/simple;
	bh=90raOQLRgNyWUNPL5h31Fd3dUKHELgCYtUsF9u+jwcg=;
	h=Subject:From:To:Date:Message-Id; b=X0KrJg2E4j5+wY/qqnjSOS/Pk/S3oEbH1H0OknsNOIImnVhuOGgWaahak9f+MOY9LzTtO0iAgxhGDkQ4+Jg7+l3tMsg9zQPmkSzNcK1phPyP6Voy7gDvZEoaYZ3fhuhWXHlyh4uKN6rKuLRe9g0sqNftNe6F57JktmOi86PXY9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LgabO1gD; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LgabO1gD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=LP/4YZ17sWr5xH3jF2eG64ezUshzO7hgmTdRClq6QgI=; b=LgabO1gDZYUX27jdKCiGqQoN07
	H1Yg7hyf9MjXnQUpavD3ZsNps94Dcsnx5jqYODUCANgW+P59n/BMRQFpwy5lL0E0NOQiJFUvC88tB
	ePKarKPdQovtT/QUSyASPrnPvz8UWRG/Loa5j9YzNSEcak/PtujtsPW4UYx7j3ycbQbnMTc0BPuUG
	tvuQbjFC9vJHIpAmHsbfmax4re35+utClXMcD4puXJjCnCqlNLTHhLbree5ecB1Rdqg6nihOn8sjD
	ybeHNe+R3URoyIzph0V4a3q+dfleqjF6fXrnVHQPglKMRjDTDrmFk4Z8iek0V4BVKAnRPk8eCDpMU
	1ujurN/Q==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vx2sY-00000009SDO-0c7a
	for fio@vger.kernel.org;
	Mon, 02 Mar 2026 13:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id C11661BC0171; Mon,  2 Mar 2026 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Mon,  2 Mar 2026 06:00:01 -0700
Message-Id: <20260302130001.C11661BC0171@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 411de8ecef63194adf805d4807b5dc3730571655:

  Merge branch 'offload_stability' of https://github.com/tomas-winkler-sndk/fio (2026-02-24 08:03:09 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a7554ee21d3f4a799969da2e54a66e7081c1571c:

  engines: posixaio: add support for DDIR_SYNCFS (2026-03-01 23:22:27 -0700)

----------------------------------------------------------------
Damien Le Moal (8):
      fio: introduce the end_syncfs option
      engines: sync: add support for DDIR_SYNCFS
      engines: libaio: add support for DDIR_SYNCFS
      engines: io_uring: add support for DDIR_SYNCFS
      engines: fallocate: add support for DDIR_SYNCFS
      engines: fileoperations: add support for DDIR_SYNCFS
      engines: ftruncate: add support for DDIR_SYNCFS
      engines: posixaio: add support for DDIR_SYNCFS

 HOWTO.rst                |   9 +++-
 backend.c                |  63 ++++++++++++++++++----
 cconv.c                  |   2 +
 configure                |  26 ++++++++++
 engines/falloc.c         |   4 +-
 engines/fileoperations.c |   8 +--
 engines/ftruncate.c      |   4 +-
 engines/io_uring.c       |  16 ++++--
 engines/libaio.c         |   8 ++-
 engines/posixaio.c       |   8 ++-
 engines/sync.c           |  11 ++--
 file.h                   |  17 ++++++
 filesetup.c              | 132 ++++++++++++++++++++++++++++++++++++++++++++---
 fio.1                    |   8 ++-
 fio.h                    |   1 +
 helpers.c                |   8 +++
 helpers.h                |   3 ++
 init.c                   |   1 +
 io_ddir.h                |   3 +-
 io_u.c                   |   6 ++-
 ioengines.c              |  10 +++-
 ioengines.h              |   4 ++
 options.c                |  19 +++++++
 server.h                 |   2 +-
 stat.c                   |   3 +-
 thread_options.h         |   5 +-
 zbd.c                    |   1 +
 27 files changed, 333 insertions(+), 49 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index d31851e9..20903496 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1450,7 +1450,7 @@ I/O type
 	using non-buffered I/O, we may not sync the file. The exception is the sg
 	I/O engine, which synchronizes the disk cache anyway. Defaults to 0, which
 	means fio does not periodically issue and wait for a sync to complete. Also
-	see :option:`end_fsync` and :option:`fsync_on_close`.
+	see :option:`end_fsync`, :option:`fsync_on_close`, and :option:`end_syncfs`.
 
 .. option:: fdatasync=int
 
@@ -1494,6 +1494,13 @@ I/O type
 	If true, :manpage:`fsync(2)` file contents when a write stage has completed.
 	Default: false.
 
+.. option:: end_syncfs=bool
+
+        Equivalent to :option:`end_fsync` but instead of executing
+        :manpage:`fsync(2)` for each file of a write stage, executes
+        :manpage:`syncfs(2)` to synchronize all written files with a single
+        system call when a write stage has completed.  Default: false.
+
 .. option:: fsync_on_close=bool
 
 	If true, fio will :manpage:`fsync(2)` a dirty file on close.  This differs
diff --git a/backend.c b/backend.c
index 568f306c..9912a94c 100644
--- a/backend.c
+++ b/backend.c
@@ -231,7 +231,8 @@ static bool check_min_rate(struct thread_data *td, struct timespec *now)
  * Helper to handle the final sync of a file. Works just like the normal
  * io path, just does everything sync.
  */
-static bool fio_io_sync(struct thread_data *td, struct fio_file *f)
+static bool fio_io_sync(struct thread_data *td, struct fio_file *f,
+			enum fio_ddir ddir)
 {
 	struct io_u *io_u = __get_io_u(td);
 	enum fio_q_status ret;
@@ -239,7 +240,7 @@ static bool fio_io_sync(struct thread_data *td, struct fio_file *f)
 	if (!io_u)
 		return true;
 
-	io_u->ddir = DDIR_SYNC;
+	io_u->ddir = ddir;
 	io_u->file = f;
 	io_u_set(td, io_u, IO_U_F_NO_FILE_PUT);
 
@@ -278,18 +279,52 @@ static int fio_file_fsync(struct thread_data *td, struct fio_file *f)
 	int ret, ret2;
 
 	if (fio_file_open(f))
-		return fio_io_sync(td, f);
+		return fio_io_sync(td, f, DDIR_SYNC);
 
 	if (td_io_open_file(td, f))
 		return 1;
 
-	ret = fio_io_sync(td, f);
+	ret = fio_io_sync(td, f, DDIR_SYNC);
 	ret2 = 0;
 	if (fio_file_open(f))
 		ret2 = td_io_close_file(td, f);
 	return (ret || ret2);
 }
 
+static int fio_syncfs(struct thread_data *td)
+{
+#ifdef CONFIG_SYNCFS
+	struct flist_head *n;
+	struct fio_mount *fm;
+	int err = 0;
+
+	/* Sync all file system mounts. */
+	flist_for_each(n, &td->fs_list) {
+		fm = flist_entry(n, struct fio_mount, list);
+
+		dprint(FD_IO, "sync FS %s\n", fm->base);
+
+		if (fio_open_fs(td, fm)) {
+			log_err("open %s for syncfs failed\n", fm->base);
+			err = -1;
+			continue;
+		}
+
+		if (fio_io_sync(td, fm->f, DDIR_SYNCFS)) {
+			log_err("syncfs %s failed\n", fm->base);
+			err = -1;
+			continue;
+		}
+
+		fio_close_fs(fm);
+	}
+
+	return err;
+#else
+	return -ENOSYS;
+#endif
+}
+
 static inline void __update_ts_cache(struct thread_data *td)
 {
 	fio_gettime(&td->ts_cache, NULL);
@@ -598,7 +633,7 @@ static void do_verify(struct thread_data *td, uint64_t verify_bytes)
 	for_each_file(td, f, i) {
 		if (!fio_file_open(f))
 			continue;
-		if (fio_io_sync(td, f))
+		if (fio_io_sync(td, f, DDIR_SYNC))
 			break;
 		if (file_invalidate_cache(td, f))
 			break;
@@ -1274,15 +1309,21 @@ reap:
 				td->error = 0;
 		}
 
-		if (should_fsync(td) && (td->o.end_fsync || td->o.fsync_on_close)) {
+		if (should_fsync(td) &&
+		    (td->o.end_fsync || td->o.end_syncfs ||
+		     td->o.fsync_on_close)) {
 			td_set_runstate(td, TD_FSYNCING);
 
-			for_each_file(td, f, i) {
-				if (!fio_file_fsync(td, f))
-					continue;
+			if (td->o.end_syncfs) {
+				fio_syncfs(td);
+			} else {
+				for_each_file(td, f, i) {
+					if (!fio_file_fsync(td, f))
+						continue;
 
-				log_err("fio: end_fsync failed for file %s\n",
-								f->file_name);
+					log_err("fio: end_fsync failed for file %s\n",
+						f->file_name);
+				}
 			}
 		}
 	} else {
diff --git a/cconv.c b/cconv.c
index 9f82c724..4e9c4b32 100644
--- a/cconv.c
+++ b/cconv.c
@@ -176,6 +176,7 @@ int convert_thread_options_to_cpu(struct thread_options *o,
 	o->create_only = le32_to_cpu(top->create_only);
 	o->filetype = le32_to_cpu(top->filetype);
 	o->end_fsync = le32_to_cpu(top->end_fsync);
+	o->end_syncfs = le32_to_cpu(top->end_syncfs);
 	o->pre_read = le32_to_cpu(top->pre_read);
 	o->sync_io = le32_to_cpu(top->sync_io);
 	o->write_hint = le32_to_cpu(top->write_hint);
@@ -447,6 +448,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->create_only = cpu_to_le32(o->create_only);
 	top->filetype = cpu_to_le32(o->filetype);
 	top->end_fsync = cpu_to_le32(o->end_fsync);
+	top->end_syncfs = cpu_to_le32(o->end_syncfs);
 	top->pre_read = cpu_to_le32(o->pre_read);
 	top->sync_io = cpu_to_le32(o->sync_io);
 	top->write_hint = cpu_to_le32(o->write_hint);
diff --git a/configure b/configure
index 9927976e..664ce299 100755
--- a/configure
+++ b/configure
@@ -1327,6 +1327,29 @@ if compile_prog "" "" "sync_file_range"; then
 fi
 print_config "sync_file_range" "$sync_file_range"
 
+##########################################
+# syncfs() probe
+if test "$syncfs" != "yes" ; then
+  syncfs="no"
+fi
+cat > $TMPC << EOF
+#include <sys/types.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <libgen.h>
+#include <dirent.h>
+int main(int argc, char **argv)
+{
+  char *dir = dirname("/foo/bar");
+  DIR *foo = NULL;
+  return syncfs(dirfd(foo));
+}
+EOF
+if compile_prog "" "" "syncfs"; then
+  syncfs="yes"
+fi
+print_config "syncfs" "$syncfs"
+
 ##########################################
 # ASharedMemory_create() probe
 if test "$ASharedMemory_create" != "yes" ; then
@@ -3132,6 +3155,9 @@ fi
 if test "$sync_file_range" = "yes" ; then
   output_sym "CONFIG_SYNC_FILE_RANGE"
 fi
+if test "$syncfs" = "yes" ; then
+  output_sym "CONFIG_SYNCFS"
+fi
 if test "$ASharedMemory_create" = "yes" ; then
   output_sym "CONFIG_ASHAREDMEMORY_CREATE"
 fi
diff --git a/engines/falloc.c b/engines/falloc.c
index 5bd5aa54..7fc49e36 100644
--- a/engines/falloc.c
+++ b/engines/falloc.c
@@ -76,7 +76,7 @@ static enum fio_q_status fio_fallocate_queue(struct thread_data *td,
 
 	fio_ro_check(td, io_u);
 
-	if (io_u->ddir != DDIR_SYNC) {
+	if (!ddir_sync(io_u->ddir)) {
 		if (io_u->ddir == DDIR_READ)
 			flags = FALLOC_FL_KEEP_SIZE;
 		else if (io_u->ddir == DDIR_WRITE)
@@ -102,7 +102,7 @@ static struct ioengine_ops ioengine = {
 	.open_file	= open_file,
 	.close_file	= generic_close_file,
 	.get_file_size	= generic_get_file_size,
-	.flags		= FIO_SYNCIO
+	.flags		= FIO_SYNCIO | FIO_SYNCFS,
 };
 
 static void fio_init fio_syncio_register(void)
diff --git a/engines/fileoperations.c b/engines/fileoperations.c
index ce3e7c39..880eab1e 100644
--- a/engines/fileoperations.c
+++ b/engines/fileoperations.c
@@ -264,7 +264,7 @@ static int invalidate_do_nothing(struct thread_data *td, struct fio_file *f)
 
 static enum fio_q_status queue_io(struct thread_data *td, struct io_u *io_u)
 {
-	if (io_u->ddir == DDIR_SYNC && do_io_u_sync(td, io_u))
+	if (ddir_sync(io_u->ddir) && do_io_u_sync(td, io_u))
 		io_u->error = errno;
 	return FIO_Q_COMPLETED;
 }
@@ -329,7 +329,7 @@ static struct ioengine_ops ioengine_filecreate = {
 	.open_file	= open_file,
 	.close_file	= generic_close_file,
 	.flags		= FIO_DISKLESSIO | FIO_SYNCIO | FIO_FAKEIO |
-				FIO_NOSTATS | FIO_NOFILEHASH,
+				FIO_SYNCFS | FIO_NOSTATS | FIO_NOFILEHASH,
 };
 
 static struct ioengine_ops ioengine_filestat = {
@@ -357,7 +357,7 @@ static struct ioengine_ops ioengine_filedelete = {
 	.get_file_size	= generic_get_file_size,
 	.open_file	= delete_file,
 	.flags		=  FIO_SYNCIO | FIO_FAKEIO |
-				FIO_NOSTATS | FIO_NOFILEHASH,
+				FIO_SYNCFS | FIO_NOSTATS | FIO_NOFILEHASH,
 };
 
 static struct ioengine_ops ioengine_dircreate = {
@@ -403,7 +403,7 @@ static struct ioengine_ops ioengine_dirdelete = {
 	.open_file	= delete_file,
 	.unlink_file	= remove_dir,
 	.flags		= FIO_DISKLESSIO | FIO_SYNCIO | FIO_FAKEIO |
-				FIO_NOSTATS | FIO_NOFILEHASH,
+				FIO_SYNCFS | FIO_NOSTATS | FIO_NOFILEHASH,
 };
 
 static void fio_init fio_fileoperations_register(void)
diff --git a/engines/ftruncate.c b/engines/ftruncate.c
index 70211e07..c1dcba7d 100644
--- a/engines/ftruncate.c
+++ b/engines/ftruncate.c
@@ -21,7 +21,7 @@ static enum fio_q_status fio_ftruncate_queue(struct thread_data *td,
 
 	if (io_u->ddir == DDIR_WRITE)
 		ret = ftruncate(f->fd, io_u->offset);
-	else if (io_u->ddir == DDIR_SYNC)
+	else if (ddir_sync(io_u->ddir))
 		ret = do_io_u_sync(td, io_u);
 	else
 		io_u->error = EINVAL;
@@ -39,7 +39,7 @@ static struct ioengine_ops ioengine = {
 	.open_file	= generic_open_file,
 	.close_file	= generic_close_file,
 	.get_file_size	= generic_get_file_size,
-	.flags		= FIO_SYNCIO | FIO_FAKEIO
+	.flags		= FIO_SYNCIO | FIO_FAKEIO | FIO_SYNCFS,
 };
 
 static void fio_init fio_syncio_register(void)
diff --git a/engines/io_uring.c b/engines/io_uring.c
index 0ea3aba1..d4dff3b8 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -890,12 +890,19 @@ static enum fio_q_status fio_ioring_queue(struct thread_data *td,
 	if (ld->queued == td->o.iodepth)
 		return FIO_Q_BUSY;
 
-	/* if async trim has been tried and failed, punt to sync */
-	if (io_u->ddir == DDIR_TRIM && ld->async_trim_fail) {
+	/*
+	 * If this is a syncfs request, or if async trim has been tried and
+	 * failed, punt to sync.
+	 * */
+	if (io_u->ddir == DDIR_SYNCFS ||
+	    (io_u->ddir == DDIR_TRIM && ld->async_trim_fail)) {
 		if (ld->queued)
 			return FIO_Q_BUSY;
 
-		do_io_u_trim(td, io_u);
+		if (io_u->ddir == DDIR_TRIM)
+			do_io_u_trim(td, io_u);
+		else
+			do_io_u_sync(td, io_u);
 
 		io_u_mark_submit(td, 1);
 		io_u_mark_complete(td, 1);
@@ -2013,7 +2020,8 @@ static struct ioengine_ops ioengine_uring_cmd = {
 	.version		= FIO_IOOPS_VERSION,
 	.flags			= FIO_NO_OFFLOAD | FIO_MEMALIGN | FIO_RAWIO |
 					FIO_ASYNCIO_SETS_ISSUE_TIME |
-					FIO_MULTI_RANGE_TRIM,
+					FIO_MULTI_RANGE_TRIM |
+					FIO_ASYNCIO_SYNC_SYNCFS,
 	.init			= fio_ioring_init,
 	.post_init		= fio_ioring_cmd_post_init,
 	.io_u_init		= fio_ioring_io_u_init,
diff --git a/engines/libaio.c b/engines/libaio.c
index 0c207d60..3242dadd 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -274,11 +274,14 @@ static enum fio_q_status fio_libaio_queue(struct thread_data *td,
 	if (ld->queued == td->o.iodepth)
 		return FIO_Q_BUSY;
 
-	if (io_u->ddir == DDIR_TRIM) {
+	if (io_u->ddir == DDIR_TRIM || io_u->ddir == DDIR_SYNCFS) {
 		if (ld->queued)
 			return FIO_Q_BUSY;
 
-		do_io_u_trim(td, io_u);
+		if (io_u->ddir == DDIR_TRIM)
+			do_io_u_trim(td, io_u);
+		else
+			do_io_u_sync(td, io_u);
 		io_u_mark_submit(td, 1);
 		io_u_mark_complete(td, 1);
 		return FIO_Q_COMPLETED;
@@ -456,6 +459,7 @@ FIO_STATIC struct ioengine_ops ioengine = {
 	.name			= "libaio",
 	.version		= FIO_IOOPS_VERSION,
 	.flags			= FIO_ASYNCIO_SYNC_TRIM |
+					FIO_ASYNCIO_SYNC_SYNCFS |
 					FIO_ASYNCIO_SETS_ISSUE_TIME |
 					FIO_ATOMICWRITES,
 	.init			= fio_libaio_init,
diff --git a/engines/posixaio.c b/engines/posixaio.c
index 2d0ac9fc..828e5351 100644
--- a/engines/posixaio.c
+++ b/engines/posixaio.c
@@ -142,7 +142,10 @@ static enum fio_q_status fio_posixaio_queue(struct thread_data *td,
 		return FIO_Q_COMPLETED;
 	} else {
 #ifdef CONFIG_POSIXAIO_FSYNC
-		ret = aio_fsync(O_SYNC, aiocb);
+		if (io_u->ddir != DDIR_SYNCFS)
+			ret = aio_fsync(O_SYNC, aiocb);
+		else
+			ret = 0;
 #else
 		if (pd->queued)
 			return FIO_Q_BUSY;
@@ -196,7 +199,8 @@ static int fio_posixaio_init(struct thread_data *td)
 static struct ioengine_ops ioengine = {
 	.name		= "posixaio",
 	.version	= FIO_IOOPS_VERSION,
-	.flags		= FIO_ASYNCIO_SYNC_TRIM,
+	.flags		= FIO_ASYNCIO_SYNC_TRIM |
+				FIO_ASYNCIO_SYNC_SYNCFS,
 	.init		= fio_posixaio_init,
 	.prep		= fio_posixaio_prep,
 	.queue		= fio_posixaio_queue,
diff --git a/engines/sync.c b/engines/sync.c
index 89466ca5..ba71ee04 100644
--- a/engines/sync.c
+++ b/engines/sync.c
@@ -433,7 +433,7 @@ static struct ioengine_ops ioengine_rw = {
 	.open_file	= generic_open_file,
 	.close_file	= generic_close_file,
 	.get_file_size	= generic_get_file_size,
-	.flags		= FIO_SYNCIO,
+	.flags		= FIO_SYNCIO | FIO_SYNCFS,
 };
 
 static struct ioengine_ops ioengine_prw = {
@@ -443,7 +443,7 @@ static struct ioengine_ops ioengine_prw = {
 	.open_file	= generic_open_file,
 	.close_file	= generic_close_file,
 	.get_file_size	= generic_get_file_size,
-	.flags		= FIO_SYNCIO,
+	.flags		= FIO_SYNCIO | FIO_SYNCFS,
 };
 
 static struct ioengine_ops ioengine_vrw = {
@@ -458,7 +458,7 @@ static struct ioengine_ops ioengine_vrw = {
 	.open_file	= generic_open_file,
 	.close_file	= generic_close_file,
 	.get_file_size	= generic_get_file_size,
-	.flags		= FIO_SYNCIO,
+	.flags		= FIO_SYNCIO | FIO_SYNCFS,
 };
 
 #ifdef CONFIG_PWRITEV
@@ -471,7 +471,7 @@ static struct ioengine_ops ioengine_pvrw = {
 	.open_file	= generic_open_file,
 	.close_file	= generic_close_file,
 	.get_file_size	= generic_get_file_size,
-	.flags		= FIO_SYNCIO,
+	.flags		= FIO_SYNCIO | FIO_SYNCFS,
 };
 #endif
 
@@ -485,8 +485,7 @@ static struct ioengine_ops ioengine_pvrw2 = {
 	.open_file	= generic_open_file,
 	.close_file	= generic_close_file,
 	.get_file_size	= generic_get_file_size,
-	.flags		= FIO_SYNCIO |
-			  FIO_ATOMICWRITES,
+	.flags		= FIO_SYNCIO | FIO_ATOMICWRITES | FIO_SYNCFS,
 	.options	= options,
 	.option_struct_size	= sizeof(struct psyncv2_options),
 };
diff --git a/file.h b/file.h
index f400155f..6fcf409b 100644
--- a/file.h
+++ b/file.h
@@ -22,6 +22,7 @@ enum fio_filetype {
 	FIO_TYPE_BLOCK,			/* block device */
 	FIO_TYPE_CHAR,			/* character device */
 	FIO_TYPE_PIPE,			/* pipe */
+	FIO_TYPE_DIR,			/* directory */
 };
 
 enum fio_file_flags {
@@ -194,6 +195,18 @@ FILE_FLAG_FNS(lfsr);
 FILE_FLAG_FNS(smalloc);
 #undef FILE_FLAG_FNS
 
+/*
+ * File FS mount information.
+ */
+struct fio_mount {
+	struct flist_head list;
+	const char *base;
+	char __base[256];
+	unsigned int key;
+	struct fio_file *f;
+	void *dir;
+};
+
 /*
  * File setup/shutdown
  */
@@ -235,5 +248,9 @@ extern bool fio_files_done(struct thread_data *);
 extern bool exists_and_not_regfile(const char *);
 extern int fio_set_directio(struct thread_data *, struct fio_file *);
 extern void fio_file_free(struct fio_file *);
+#ifdef CONFIG_SYNCFS
+extern int fio_open_fs(struct thread_data *td, struct fio_mount *fm);
+extern void fio_close_fs(struct fio_mount *fm);
+#endif
 
 #endif
diff --git a/filesetup.c b/filesetup.c
index a766c39a..740a2f47 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -874,12 +874,63 @@ static int get_file_sizes(struct thread_data *td)
 	return err;
 }
 
-struct fio_mount {
-	struct flist_head list;
-	const char *base;
-	char __base[256];
-	unsigned int key;
-};
+static void free_fs_list(struct thread_data *td)
+{
+	struct flist_head *n, *tmp;
+	struct fio_mount *fm;
+
+	flist_for_each_safe(n, tmp, &td->fs_list) {
+		fm = flist_entry(n, struct fio_mount, list);
+		flist_del(&fm->list);
+		free(fm);
+	}
+}
+
+/*
+ * Get the list of unique file system mounts storing the thread files.
+ */
+static int add_file_fs(struct thread_data *td, struct fio_file *f)
+{
+#ifdef CONFIG_SYNCFS
+	struct flist_head *n;
+	struct fio_mount *fm;
+	struct stat sb;
+	char buf[256];
+	char *fsdir;
+
+	if (f->filetype != FIO_TYPE_FILE)
+		return 0;
+
+	snprintf(buf, FIO_ARRAY_SIZE(buf), "%s", f->file_name);
+	fsdir = dirname(buf);
+	if (stat(fsdir, &sb) < 0) {
+		log_err("fio: failed to get dir %s information (%s)\n",
+			fsdir, strerror(errno));
+		return 1;
+	}
+
+	fm = NULL;
+	flist_for_each(n, &td->fs_list) {
+		fm = flist_entry(n, struct fio_mount, list);
+		if (fm->key == sb.st_dev)
+			return 0;
+	}
+
+	fm = calloc(1, sizeof(*fm));
+	if (!fm) {
+		free_fs_list(td);
+		return 1;
+	}
+
+	snprintf(fm->__base, FIO_ARRAY_SIZE(fm->__base), "%s", fsdir);
+	fm->base = fm->__base;
+	fm->key = sb.st_dev;
+	flist_add(&fm->list, &td->fs_list);
+
+	dprint(FD_FILE, "Add FS %s\n", fm->base);
+#endif
+	return 0;
+}
 
 /*
  * Get free number of bytes for each file on each unique mount.
@@ -1100,6 +1151,14 @@ int setup_files(struct thread_data *td)
 			goto err_out;
 	}
 
+	if (td->o.end_syncfs &&
+	    !td_ioengine_flagged(td, FIO_SYNCFS) &&
+	    !td_ioengine_flagged(td, FIO_ASYNCIO_SYNC_SYNCFS)) {
+		log_err("%s: I/O engine does not support syncfs\n", o->name);
+		td_verror(td, EINVAL, "end_syncfs");
+		goto err_out;
+	}
+
 	/*
 	 * Find out physical size of files or devices for this thread,
 	 * before we determine I/O size and range of our targets.
@@ -1127,7 +1186,8 @@ int setup_files(struct thread_data *td)
 
 	/*
 	 * check sizes. if the files/devices do not exist and the size
-	 * isn't passed to fio, abort.
+	 * isn't passed to fio, abort. While at it, build the list of file
+	 * system mounts if end_syncfs is specified.
 	 */
 	total_size = 0;
 	for_each_file(td, f, i) {
@@ -1136,6 +1196,12 @@ int setup_files(struct thread_data *td)
 			total_size = -1ULL;
 		else
 			total_size += f->real_file_size;
+
+		if (td->o.end_syncfs) {
+			err = add_file_fs(td, f);
+			if (err)
+				goto err_out;
+		}
 	}
 
 	if (o->fill_device)
@@ -2096,6 +2162,8 @@ int get_fileno(struct thread_data *td, const char *fname)
  */
 void free_release_files(struct thread_data *td)
 {
+	free_fs_list(td);
+
 	close_files(td);
 	td->o.nr_files = 0;
 	td->o.open_files = 0;
@@ -2165,3 +2233,53 @@ int fio_set_directio(struct thread_data *td, struct fio_file *f)
 	return -1;
 #endif
 }
+
+#ifdef CONFIG_SYNCFS
+int fio_open_fs(struct thread_data *td, struct fio_mount *fm)
+{
+	struct fio_file *f;
+
+	assert(!fm->f);
+	assert(!fm->dir);
+
+	f = alloc_new_file(td);
+	if (!f)
+		return -1;
+
+	if (td_ioengine_flagged(td, FIO_NOFILEHASH))
+		f->file_name = strdup(fm->base);
+	else
+		f->file_name = smalloc_strdup(fm->base);
+
+	fm->dir = opendir(fm->base);
+	if (!fm->dir) {
+		log_err("fio: open dir %s failed (%s)\n",
+			fm->base, strerror(errno));
+		return -1;
+	}
+
+	f->filetype = FIO_TYPE_DIR;
+	f->fd = dirfd(fm->dir);
+	fio_file_set_open(f);
+
+	fm->f = f;
+
+	return 0;
+}
+
+void fio_close_fs(struct fio_mount *fm)
+{
+	struct fio_file *f = fm->f;
+
+	assert(f && fio_file_open(f));
+	assert(f->filetype == FIO_TYPE_DIR);
+	assert(fm->dir);
+
+	closedir(fm->dir);
+	fm->dir = NULL;
+
+	fio_file_clear_open(f);
+	fio_file_free(f);
+	fm->f = NULL;
+}
+#endif
diff --git a/fio.1 b/fio.1
index bc3efa5f..207fdb42 100644
--- a/fio.1
+++ b/fio.1
@@ -1239,7 +1239,7 @@ as a parameter, fio will sync the file after every 32 writes issued. If fio is
 using non-buffered I/O, we may not sync the file. The exception is the sg
 I/O engine, which synchronizes the disk cache anyway. Defaults to 0, which
 means fio does not periodically issue and wait for a sync to complete. Also
-see \fBend_fsync\fR and \fBfsync_on_close\fR.
+see \fBend_fsync\fR, \fBend_syncfs\fR and \fBfsync_on_close\fR.
 .TP
 .BI fdatasync \fR=\fPint
 Like \fBfsync\fR but uses \fBfdatasync\fR\|(2) to only sync data and
@@ -1284,6 +1284,12 @@ will be done. Default: false.
 If true, \fBfsync\fR\|(2) file contents when a write stage has completed.
 Default: false.
 .TP
+.BI end_syncfs \fR=\fPbool
+Equivalent to \fBend_fsync\fR but instead of executing \fBfsync\fR\|(2) for
+each file of a write stage, execute \fBsyncfs\fR\|(2) to synchronize all
+written files with a single system call when a write stage has completed.
+Default: false.
+.TP
 .BI fsync_on_close \fR=\fPbool
 If true, fio will \fBfsync\fR\|(2) a dirty file on close. This differs
 from \fBend_fsync\fR in that it will happen on every file close, not
diff --git a/fio.h b/fio.h
index 65c68d4b..8708f048 100644
--- a/fio.h
+++ b/fio.h
@@ -230,6 +230,7 @@ struct thread_data {
 	struct rusage ru_start;
 	struct rusage ru_end;
 
+	struct flist_head fs_list;
 	struct fio_file **files;
 	unsigned char *file_locks;
 	unsigned int files_size;
diff --git a/helpers.c b/helpers.c
index ab9d706d..d340a235 100644
--- a/helpers.c
+++ b/helpers.c
@@ -26,6 +26,14 @@ int sync_file_range(int fd, uint64_t offset, uint64_t nbytes,
 }
 #endif
 
+#ifndef CONFIG_SYNCFS
+int syncfs(int fd)
+{
+	errno = ENOSYS;
+	return -1;
+}
+#endif
+
 #ifndef CONFIG_POSIX_FADVISE
 int posix_fadvise(int fd, off_t offset, off_t len, int advice)
 {
diff --git a/helpers.h b/helpers.h
index 4ec0f052..f6670b88 100644
--- a/helpers.h
+++ b/helpers.h
@@ -11,6 +11,9 @@ extern int posix_fallocate(int fd, off_t offset, off_t len);
 extern int sync_file_range(int fd, uint64_t offset, uint64_t nbytes,
 					unsigned int flags);
 #endif
+#ifndef CONFIG_SYNCFS
+extern int syncfs(int fd);
+#endif
 extern int posix_fadvise(int fd, off_t offset, off_t len, int advice);
 
 #endif /* FIO_HELPERS_H_ */
diff --git a/init.c b/init.c
index 130158cb..07278619 100644
--- a/init.c
+++ b/init.c
@@ -508,6 +508,7 @@ static struct thread_data *get_new_job(bool global, struct thread_data *parent,
 
 	td->o.uid = td->o.gid = -1U;
 
+	INIT_FLIST_HEAD(&td->fs_list);
 	dup_files(td, parent);
 	fio_options_mem_dupe(td);
 
diff --git a/io_ddir.h b/io_ddir.h
index 280c1e79..203b6898 100644
--- a/io_ddir.h
+++ b/io_ddir.h
@@ -8,6 +8,7 @@ enum fio_ddir {
 	DDIR_SYNC = 3,
 	DDIR_DATASYNC,
 	DDIR_SYNC_FILE_RANGE,
+	DDIR_SYNCFS,
 	DDIR_WAIT,
 	DDIR_LAST,
 	DDIR_INVAL = -1,
@@ -59,7 +60,7 @@ enum td_ddir {
 static inline int ddir_sync(enum fio_ddir ddir)
 {
 	return ddir == DDIR_SYNC || ddir == DDIR_DATASYNC ||
-	       ddir == DDIR_SYNC_FILE_RANGE;
+	       ddir == DDIR_SYNC_FILE_RANGE || ddir == DDIR_SYNCFS;
 }
 
 static inline int ddir_rw(enum fio_ddir ddir)
diff --git a/io_u.c b/io_u.c
index 653a700c..756aa090 100644
--- a/io_u.c
+++ b/io_u.c
@@ -2482,9 +2482,11 @@ int do_io_u_sync(const struct thread_data *td, struct io_u *io_u)
 		ret = io_u->xfer_buflen;
 		io_u->error = EINVAL;
 #endif
-	} else if (io_u->ddir == DDIR_SYNC_FILE_RANGE)
+	} else if (io_u->ddir == DDIR_SYNC_FILE_RANGE) {
 		ret = do_sync_file_range(td, io_u->file);
-	else {
+	} else if (io_u->ddir == DDIR_SYNCFS) {
+		ret = syncfs(io_u->file->fd);
+	} else {
 		ret = io_u->xfer_buflen;
 		io_u->error = EINVAL;
 	}
diff --git a/ioengines.c b/ioengines.c
index 9f75e66c..60565e03 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -32,6 +32,13 @@ static inline bool async_ioengine_sync_trim(struct thread_data *td,
 		io_u->ddir == DDIR_TRIM;
 }
 
+static inline bool async_ioengine_sync_syncfs(struct thread_data *td,
+					      struct io_u *io_u)
+{
+	return td_ioengine_flagged(td, FIO_ASYNCIO_SYNC_SYNCFS) &&
+		io_u->ddir == DDIR_SYNCFS;
+}
+
 static bool check_engine_ops(struct thread_data *td, struct ioengine_ops *ops)
 {
 	if (ops->version != FIO_IOOPS_VERSION) {
@@ -363,7 +370,8 @@ enum fio_q_status td_io_queue(struct thread_data *td, struct io_u *io_u)
 	io_u->resid = 0;
 
 	if (td_ioengine_flagged(td, FIO_SYNCIO) ||
-		async_ioengine_sync_trim(td, io_u)) {
+	    async_ioengine_sync_trim(td, io_u) ||
+	    async_ioengine_sync_syncfs(td, io_u)) {
 		if (fio_fill_issue_time(td)) {
 			fio_gettime(&io_u->issue_time, NULL);
 
diff --git a/ioengines.h b/ioengines.h
index 3d220a73..b0a767ba 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -90,6 +90,7 @@ enum {
 	__FIO_NOSTATS,			/* don't do IO stats */
 	__FIO_NOFILEHASH,		/* doesn't hash the files for lookup later. */
 	__FIO_ASYNCIO_SYNC_TRIM,	/* io engine has async ->queue except for trim */
+	__FIO_ASYNCIO_SYNC_SYNCFS,	/* io engine has async ->queue except for syncfs */
 	__FIO_NO_OFFLOAD,		/* no async offload */
 	__FIO_ASYNCIO_SETS_ISSUE_TIME,	/* async ioengine with commit function that sets
 					   issue_time */
@@ -98,6 +99,7 @@ enum {
 					   affects ioengines using generic_open_file */
 	__FIO_MULTI_RANGE_TRIM,		/* ioengine supports trim with more than one range */
 	__FIO_ATOMICWRITES,		/* ioengine supports atomic writes */
+	__FIO_SYNCFS,			/* ioengine supports syncfs */
 	__FIO_IOENGINE_F_LAST,		/* not a real bit; used to count number of bits */
 };
 
@@ -117,12 +119,14 @@ enum fio_ioengine_flags {
 	FIO_NOSTATS			= 1 << __FIO_NOSTATS,
 	FIO_NOFILEHASH			= 1 << __FIO_NOFILEHASH,
 	FIO_ASYNCIO_SYNC_TRIM		= 1 << __FIO_ASYNCIO_SYNC_TRIM,
+	FIO_ASYNCIO_SYNC_SYNCFS		= 1 << __FIO_ASYNCIO_SYNC_SYNCFS,
 	FIO_NO_OFFLOAD			= 1 << __FIO_NO_OFFLOAD,
 	FIO_ASYNCIO_SETS_ISSUE_TIME	= 1 << __FIO_ASYNCIO_SETS_ISSUE_TIME,
 	FIO_SKIPPABLE_IOMEM_ALLOC	= 1 << __FIO_SKIPPABLE_IOMEM_ALLOC,
 	FIO_RO_NEEDS_RW_OPEN		= 1 << __FIO_RO_NEEDS_RW_OPEN,
 	FIO_MULTI_RANGE_TRIM		= 1 << __FIO_MULTI_RANGE_TRIM,
 	FIO_ATOMICWRITES		= 1 << __FIO_ATOMICWRITES,
+	FIO_SYNCFS			= 1 << __FIO_SYNCFS,
 };
 
 /*
diff --git a/options.c b/options.c
index f592bc24..6406dd0c 100644
--- a/options.c
+++ b/options.c
@@ -4655,6 +4655,25 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_FILE,
 		.group	= FIO_OPT_G_INVALID,
 	},
+#ifdef CONFIG_SYNCFS
+	{
+		.name	= "end_syncfs",
+		.lname	= "End sync FS",
+		.type	= FIO_OPT_BOOL,
+		.off1	= offsetof(struct thread_options, end_syncfs),
+		.help	= "Include sync of FS at the end of job",
+		.def	= "0",
+		.category = FIO_OPT_C_FILE,
+		.group	= FIO_OPT_G_INVALID,
+	},
+#else
+	{
+		.name	= "end_syncfs",
+		.lname	= "End sync FS",
+		.type	= FIO_OPT_UNSUPPORTED,
+		.help	= "Your platform does not support syncfs",
+	},
+#endif
 	{
 		.name	= "unlink",
 		.lname	= "Unlink file",
diff --git a/server.h b/server.h
index e0a921b8..589e8bea 100644
--- a/server.h
+++ b/server.h
@@ -51,7 +51,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 118,
+	FIO_SERVER_VER			= 119,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/stat.c b/stat.c
index 620b4626..0e4e482d 100644
--- a/stat.c
+++ b/stat.c
@@ -539,7 +539,8 @@ static void show_ddir_status(const struct group_run_stats *rs, struct thread_sta
 
 	if (ddir_sync(ddir)) {
 		if (calc_lat(&ts->sync_stat, &min, &max, &mean, &dev)) {
-			log_buf(out, "  %s:\n", "fsync/fdatasync/sync_file_range");
+			log_buf(out, "  %s:\n",
+				"fsync/fdatasync/sync_file_range/syncfs");
 			display_lat(io_ddir_name(ddir), min, max, mean, dev, out);
 			show_clat_percentiles(ts->io_u_sync_plat,
 						ts->sync_stat.samples,
diff --git a/thread_options.h b/thread_options.h
index 3e66d477..ff1f40ec 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -138,6 +138,7 @@ struct thread_options {
 	unsigned int create_on_open;
 	unsigned int create_only;
 	unsigned int end_fsync;
+	unsigned int end_syncfs;
 	unsigned int pre_read;
 	unsigned int sync_io;
 	unsigned int write_hint;
@@ -528,6 +529,8 @@ struct thread_options_pack {
 	uint32_t exitall_error;
 
 	uint32_t sync_file_range;
+	uint32_t end_syncfs;
+	uint32_t pad;
 
 	struct zone_split zone_split[DDIR_RWDIR_CNT][ZONESPLIT_MAX];
 	uint32_t zone_split_nr[DDIR_RWDIR_CNT];
@@ -627,7 +630,7 @@ struct thread_options_pack {
 	uint32_t lat_percentiles;
 	uint32_t slat_percentiles;
 	uint32_t percentile_precision;
-	uint32_t pad;
+	uint32_t pad2;
 	fio_fp64_t percentile_list[FIO_IO_U_LIST_MAX_LEN];
 
 	uint8_t read_iolog_file[FIO_TOP_STR_MAX];
diff --git a/zbd.c b/zbd.c
index 7a66b665..08c537d7 100644
--- a/zbd.c
+++ b/zbd.c
@@ -2310,6 +2310,7 @@ retry:
 		/* fall-through */
 	case DDIR_DATASYNC:
 	case DDIR_SYNC_FILE_RANGE:
+	case DDIR_SYNCFS:
 	case DDIR_WAIT:
 	case DDIR_LAST:
 	case DDIR_INVAL:
