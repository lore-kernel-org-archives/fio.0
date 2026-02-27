Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71AA03090D7
	for <fio@vger.kernel.org>; Fri, 27 Feb 2026 06:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772172056; cv=none; b=Q/bvnu8Z1YgWGucPusWPmSQs3cea/H6iVNUOFHjN0QSNRYKIZy4+ZvFUIyj2Y1587ioyKLS3FU9iuPt68Uan3D6lwAfqHmRmHj/TliVDJ95eOsyOS2FC4BPDpPAdyu4VVHwaKFoGjhNOGWb+i1vDHTtD8TiPWpUknTAVQoGXNMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772172056; c=relaxed/simple;
	bh=chm6pFJZgZQfPpYPdH8sbuD7F84d8zeiTMN/heZ2miE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CgtFWBXmnIKEqVqZSWbHVn+I0Jx+5fs9ZjTeaw8nT73jKVUhbKu3z2WrNbts/Lm5L6w7e2X+wu9cG0cPnWG62D+VoY8SqRU8I8s2udFsbaym24LrrDqHdGUPOm9TFlkGFYhKkPlxu/Nd4L1zOpBZ+A39gXrbx8dlfZUPfC7nRzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=glY+JwtC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="glY+JwtC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD58DC19421;
	Fri, 27 Feb 2026 06:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772172056;
	bh=chm6pFJZgZQfPpYPdH8sbuD7F84d8zeiTMN/heZ2miE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=glY+JwtC4dhCINSYcArP3KKzD8vE91F2HgfEOZ3qkK5i6/S6wfI8fOcVKThh7YFnZ
	 MpoMUHqfLn6LgfSNNk1rdWKqUoJVwaMi1oKt+OdsPxwP7gQh+W2siEtymP3LxX6niJ
	 l1pcVVhlF1nIwqJNMhVuHwPKVve50bAAlGfAzEbHkx7ok37sfdYD3Jrrh73sQn6vg4
	 Yq3ChuejNGecLVAEREAfg3TcBeeQuCHiL/WGiDsvEQqL/lhM8nXUYiu4cYOdY81hEt
	 3hFLnEWGo8dJaiwcwKptOpEy3upn4cSFkqLhnIeA6FqOmLSmEslG738dEofdIoDIJY
	 +7+amEpgfjW8g==
From: Damien Le Moal <dlemoal@kernel.org>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Subject: [PATCH v3 1/8] fio: introduce the end_syncfs option
Date: Fri, 27 Feb 2026 14:55:31 +0900
Message-ID: <20260227055538.2334916-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260227055538.2334916-1-dlemoal@kernel.org>
References: <20260227055538.2334916-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When benchmarking buffered I/O file write workloads with file systems,
the options fsync, fsync_on_close and end_fsync allow getting
performance statistics accounting for all file data safely written to
the file system device media. All these options can be used in
different scenarios to emulate applications use of the fsync() system
call.

However, these different options all involve using the fsync() system
call against every written files, with the files being open.
Depending on the file system, this characteristic is very limiting. E.g.
the XFS file system optimizes data placement of closed files to store
these files tightly in the same block group in order to generate a
write command pattern that is very sequential and localized. The use
of fio existing sync option variants thus does not allow measuring the
performance benefits of this optimization. Furthermore, the option
end_fsync applies to all files of a job, causing a loop to open, fsync()
and close each written file. For benchmarks with a very large number of
files (e.g. a long run), this is very ineficient and slow, and often
causes the performance results to be much lower than expected.

Extending the sync operation variants to include the ability to use the
syncfs() system call can solve these issues. Allow this by introducing
the new end_syncfs option.

If enabled, the end_syncfs option results in a call to the syncfs()
system call when a job completes. This allows syncing all written files
with a single system call and also avoids the need to reopen all written
files.  This is thus much faster than using end_fsync, and also enables
file system writeback optimizations that rely on the files being written
back to be closed.

The syncfs() system call is supported by Linux only. This support is
detected in the configure script and if detected, the CONFIG_SYNCFS
configuration option defined. When not supported, the helpers.c file
defines the syncfs() function to return an error. The option end_syncfs
is allowed only when CONFIG_SYNCFS is defined.

Like other sync variants, end_syncfs causes issuing an io_u when a job
completes so that the time taken to write back all written files is
accounted for in the final performance statistics. The io_u data
direction DDIR_SYNCFS is defined to control this. A DDIR_SYNCFS io_u is
issued using the same function fio_io_sync() as for other sync variants.
Calls to fio_io_sync() are driven with the new function fio_syncfs(),
which iterates a list of struct fio_mount representing the mounted file
systems for the files of a job thread. This list is built using the
helper function add_file_fs(), called from setup_files(), and using the
new fs_list struct flist_head defined for each thread. This list is
freed on completion of a thread with a call to free_fs_list() from
free_release_files().

struct fio_mount definition is moved to file.h to allow iterating a
thread fs_list entries in backend.c. This structure is also augmented
with a pointer to a struct fio_file and to an open directory stream (dir
field). These new entries are used to avoid opening one of the file of a
thread for a file system entry and instead used to allocate and
initialize a struct fio_file representing the parent directory of a file
of the file system entry. This is managed with the helper functions
fio_open_fs() and fio_close_fs() which are used before and after calling
fio_io_sync() in fio_syncfs().

Finally, since support for executing the syncfs() system call depends on
the IO engine used, the engine flags FIO_SYNCFS and
FIO_ASYNCIO_SYNC_SYNCFS are defined to allow indicating if an IO engine
supports DDIR_SYNCFS operations.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 HOWTO.rst        |   9 +++-
 backend.c        |  59 ++++++++++++++++++----
 cconv.c          |   2 +
 configure        |  21 ++++++++
 file.h           |  15 ++++++
 filesetup.c      | 129 ++++++++++++++++++++++++++++++++++++++++++++---
 fio.1            |   8 ++-
 fio.h            |   1 +
 helpers.c        |   8 +++
 helpers.h        |   3 ++
 init.c           |   1 +
 io_ddir.h        |   3 +-
 io_u.c           |   6 ++-
 ioengines.c      |  10 +++-
 ioengines.h      |   4 ++
 options.c        |  19 +++++++
 server.h         |   2 +-
 stat.c           |   3 +-
 thread_options.h |   5 +-
 zbd.c            |   1 +
 20 files changed, 282 insertions(+), 27 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index d31851e93ae4..2090349642f8 100644
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
index 568f306c242d..7a6540f4fe39 100644
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
 
@@ -278,18 +279,48 @@ static int fio_file_fsync(struct thread_data *td, struct fio_file *f)
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
+}
+
 static inline void __update_ts_cache(struct thread_data *td)
 {
 	fio_gettime(&td->ts_cache, NULL);
@@ -598,7 +629,7 @@ static void do_verify(struct thread_data *td, uint64_t verify_bytes)
 	for_each_file(td, f, i) {
 		if (!fio_file_open(f))
 			continue;
-		if (fio_io_sync(td, f))
+		if (fio_io_sync(td, f, DDIR_SYNC))
 			break;
 		if (file_invalidate_cache(td, f))
 			break;
@@ -1274,15 +1305,21 @@ reap:
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
index 9f82c724f416..4e9c4b32afaa 100644
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
index 9927976e705b..6c880b00c897 100755
--- a/configure
+++ b/configure
@@ -1327,6 +1327,24 @@ if compile_prog "" "" "sync_file_range"; then
 fi
 print_config "sync_file_range" "$sync_file_range"
 
+##########################################
+# syncfs() probe
+if test "$syncfs" != "yes" ; then
+  syncfs="no"
+fi
+cat > $TMPC << EOF
+#include <stdio.h>
+#include <unistd.h>
+int main(int argc, char **argv)
+{
+  return syncfs(0);
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
@@ -3132,6 +3150,9 @@ fi
 if test "$sync_file_range" = "yes" ; then
   output_sym "CONFIG_SYNC_FILE_RANGE"
 fi
+if test "$syncfs" = "yes" ; then
+  output_sym "CONFIG_SYNCFS"
+fi
 if test "$ASharedMemory_create" = "yes" ; then
   output_sym "CONFIG_ASHAREDMEMORY_CREATE"
 fi
diff --git a/file.h b/file.h
index f400155fd97f..4b08ada62292 100644
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
@@ -235,5 +248,7 @@ extern bool fio_files_done(struct thread_data *);
 extern bool exists_and_not_regfile(const char *);
 extern int fio_set_directio(struct thread_data *, struct fio_file *);
 extern void fio_file_free(struct fio_file *);
+extern int fio_open_fs(struct thread_data *td, struct fio_mount *fm);
+extern void fio_close_fs(struct fio_mount *fm);
 
 #endif
diff --git a/filesetup.c b/filesetup.c
index a766c39a6ba7..9392f0d6bd9b 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -874,12 +874,62 @@ static int get_file_sizes(struct thread_data *td)
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
+
+	return 0;
+}
 
 /*
  * Get free number of bytes for each file on each unique mount.
@@ -1100,6 +1150,14 @@ int setup_files(struct thread_data *td)
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
@@ -1127,7 +1185,8 @@ int setup_files(struct thread_data *td)
 
 	/*
 	 * check sizes. if the files/devices do not exist and the size
-	 * isn't passed to fio, abort.
+	 * isn't passed to fio, abort. While at it, build the list of file
+	 * system mounts if end_syncfs is specified.
 	 */
 	total_size = 0;
 	for_each_file(td, f, i) {
@@ -1136,6 +1195,12 @@ int setup_files(struct thread_data *td)
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
@@ -2096,6 +2161,8 @@ int get_fileno(struct thread_data *td, const char *fname)
  */
 void free_release_files(struct thread_data *td)
 {
+	free_fs_list(td);
+
 	close_files(td);
 	td->o.nr_files = 0;
 	td->o.open_files = 0;
@@ -2165,3 +2232,51 @@ int fio_set_directio(struct thread_data *td, struct fio_file *f)
 	return -1;
 #endif
 }
+
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
diff --git a/fio.1 b/fio.1
index bc3efa5f133c..207fdb4249ff 100644
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
index 65c68d4bba5b..8708f0488008 100644
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
index ab9d706da879..d340a2351f29 100644
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
index 4ec0f0525612..f6670b88ffef 100644
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
index 130158cbd3b3..072786196c89 100644
--- a/init.c
+++ b/init.c
@@ -508,6 +508,7 @@ static struct thread_data *get_new_job(bool global, struct thread_data *parent,
 
 	td->o.uid = td->o.gid = -1U;
 
+	INIT_FLIST_HEAD(&td->fs_list);
 	dup_files(td, parent);
 	fio_options_mem_dupe(td);
 
diff --git a/io_ddir.h b/io_ddir.h
index 280c1e796a26..203b6898f446 100644
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
index 653a700c83a5..756aa090ed78 100644
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
index 9f75e66c6ddf..60565e039c34 100644
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
index 3d220a73ca8e..b0a767ba81a4 100644
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
index f592bc24d9cf..6406dd0cf857 100644
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
index e0a921b84de4..589e8bea995b 100644
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
index 620b46262ea7..0e4e482d9a98 100644
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
index 3e66d4770982..ff1f40ece133 100644
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
index 7a66b665cd65..08c537d7a5c1 100644
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
-- 
2.53.0

