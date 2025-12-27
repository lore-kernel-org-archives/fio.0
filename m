Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE182459DD
	for <fio@vger.kernel.org>; Sat, 27 Dec 2025 08:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766824183; cv=none; b=tjGNJZKroSvOm0mDGpmdgd5r8/6zK17ecY7gd6bKDjCSVUrU+FP+mhsNoaqGKsVQEZU7WOUCLT5oMWRPHXHzZkBUZj5D7SMwZwP8yWf3gPnutPl7l561VvbDlzUhZsTz5K8VCEpMo69bGZ9VTR60OHpDIC2kPK4cogEtumPcj5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766824183; c=relaxed/simple;
	bh=MiGk+Y95Mpdej41b2OdoBxSYeym+Cbc8Dp4IipfEGTY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=fb0c+QK0tXUCgn2qMDNjpVfvrxZSR7Z5ZosnUF9OsQtThCqXfCW6m41Z0dPiZzcBEvVGwHKQLIYykSuhdpnZjsPfTchqG3+7xWWNtA2Y5Cw+kS0XHiybeFHr44/lZApryWOfGUWWgJoB1v8Z6tRnoAV3w7DMHxz3X5x3NtaqoAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u3EZ94Sn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u3EZ94Sn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 163FEC4CEF1;
	Sat, 27 Dec 2025 08:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766824182;
	bh=MiGk+Y95Mpdej41b2OdoBxSYeym+Cbc8Dp4IipfEGTY=;
	h=From:To:Subject:Date:From;
	b=u3EZ94SnQnNa9+soK+TY1OT0fC1SkcKogw6YTcaLGMTLaVHfsG2XO13wNjJTZJy+E
	 5ADABj8vi60vtfksbdmRVJ7w4DiwQfS59yGPAB+djOupXuJKjrnq3kRATT1Kow6x7w
	 yReLlUkZLJJDvLskIovt8BwN4Xv8nbEajQYawbKggSzX7zkQoFmEiBdQM6FEpckxQ7
	 3xR7xdjdWm1QbYsk8SnvWWoTCw4jfyR2/upUsHwZbCt27g8rotg2FR4EEKWJihPVKv
	 w2UHb3rrpdiFk2XklwBgj33nU2+lmXsEp97tXRW+UAit5aE74PpaikILq/CuseDlWl
	 +NlIQWVu757GA==
From: Damien Le Moal <dlemoal@kernel.org>
To: fio@vger.kernel.org,
	Vincent Fu <vincentfu@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] Introduce the end_syncfs option
Date: Sat, 27 Dec 2025 17:25:11 +0900
Message-ID: <20251227082511.863845-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When benchmarking a file system file writes with buffered I/Os, the
options fsync, fsync_on_close and end_fsync allow for accounting for all
performance with the file data safely written to media. All these
options can be used in different scenarios to emulate applications use
of the fsync() system call.

However, these different possibilities all involve the fsync() system
call which implies that when called the written files are always open.
Depending on the file system, this characteristic is very limiting. E.g.
the XFS file system optimizes data placement of closed files to the same
block group in order to generate a write command pattern that is very
sequential and localized (tight packing). The use of fio existing sync
option variants thus does not allow measuring the performance benefits
of this optimization. Furthermore, the option end_fsync applies to all
files of a job, causing a loop to open, fsync() and close each written
file. For benchmarks with a very large number of files (e.g. a long
run), this is very ineficient and slow, and often causes the performance
results to much lower than expected.

Solve this by introducing the end_syncfs option. If enabled, this option
results in a call to the syncfs() system call when a job completes. This
allows syncing all written files with a single system call and also
avoids the need to reopen all written files. This is thus much faster
than using end_fsync, and also enables file system writeback
optimizations that rely on the files being written back to be closed.

The syncfs() system call is supported by Linux only. This support is
detected in the configure script and if detected, the CONFIG_SYNCFS
configuration option defined. When not supported, the helpers.c file
defines the syncfs() function to return an error.

Like other sync variants, end_syncfs causes issuing an io_u when a job
completes so that the time taken to write back all written files is
accounted for in the final performance statistics. The io_u data
direction DDIR_SYNCFS is defined to control this and used in the
fio_file_syncfs() function in backend.c

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 HOWTO.rst        |  7 +++++++
 backend.c        | 37 ++++++++++++++++++++++++++++++++-----
 cconv.c          |  2 ++
 configure        | 21 +++++++++++++++++++++
 fio.1            |  6 ++++++
 helpers.c        |  8 ++++++++
 helpers.h        |  3 +++
 io_ddir.h        |  1 +
 io_u.c           | 11 +++++++++--
 options.c        | 10 ++++++++++
 server.h         |  2 +-
 thread_options.h |  5 ++++-
 zbd.c            |  1 +
 13 files changed, 105 insertions(+), 9 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 3d74cb9f6fda..a63c18f27de6 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1484,6 +1484,13 @@ I/O type
 	If true, :manpage:`fsync(2)` file contents when a write stage has completed.
 	Default: false.
 
+.. option:: end_syncfs=bool
+
+        Equivalent to :option:`end_fsync` but instead of executing
+        :manpage:`fsync(2)` for each file of a write stage, execute
+        :manpage:`syncfs(2)` to synchronize all written files with a single
+        system call when a write stage has completed.  Default: false.
+
 .. option:: fsync_on_close=bool
 
 	If true, fio will :manpage:`fsync(2)` a dirty file on close.  This differs
diff --git a/backend.c b/backend.c
index 13c77552a1ed..61b08a68d4f0 100644
--- a/backend.c
+++ b/backend.c
@@ -226,7 +226,8 @@ static bool check_min_rate(struct thread_data *td, struct timespec *now)
  * Helper to handle the final sync of a file. Works just like the normal
  * io path, just does everything sync.
  */
-static bool fio_io_sync(struct thread_data *td, struct fio_file *f)
+static bool fio_io_sync(struct thread_data *td, struct fio_file *f,
+			enum fio_ddir ddir)
 {
 	struct io_u *io_u = __get_io_u(td);
 	enum fio_q_status ret;
@@ -234,7 +235,7 @@ static bool fio_io_sync(struct thread_data *td, struct fio_file *f)
 	if (!io_u)
 		return true;
 
-	io_u->ddir = DDIR_SYNC;
+	io_u->ddir = ddir;
 	io_u->file = f;
 	io_u_set(td, io_u, IO_U_F_NO_FILE_PUT);
 
@@ -273,18 +274,34 @@ static int fio_file_fsync(struct thread_data *td, struct fio_file *f)
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
 
+static int fio_file_syncfs(struct thread_data *td, struct fio_file *f)
+{
+	int ret;
+
+	if (fio_file_open(f))
+		return fio_io_sync(td, f, DDIR_SYNCFS);
+
+	if (td_io_open_file(td, f))
+		return 1;
+
+	ret = fio_io_sync(td, f, DDIR_SYNCFS);
+	td_io_close_file(td, f);
+
+	return ret;
+}
+
 static inline void __update_ts_cache(struct thread_data *td)
 {
 	fio_gettime(&td->ts_cache, NULL);
@@ -593,7 +610,7 @@ static void do_verify(struct thread_data *td, uint64_t verify_bytes)
 	for_each_file(td, f, i) {
 		if (!fio_file_open(f))
 			continue;
-		if (fio_io_sync(td, f))
+		if (fio_io_sync(td, f, DDIR_SYNC))
 			break;
 		if (file_invalidate_cache(td, f))
 			break;
@@ -1280,6 +1297,16 @@ reap:
 								f->file_name);
 			}
 		}
+
+		if (td->o.end_syncfs) {
+			td_set_runstate(td, TD_FSYNCING);
+
+			for_each_file(td, f, i) {
+				if (fio_file_syncfs(td, f))
+					log_err("fio: end_syncfs failed\n");
+				break;
+			}
+		}
 	} else {
 		if (td->o.io_submit_mode == IO_MODE_OFFLOAD)
 			workqueue_flush(&td->io_wq);
diff --git a/cconv.c b/cconv.c
index e7bbfc53bc64..cd5001d86baf 100644
--- a/cconv.c
+++ b/cconv.c
@@ -174,6 +174,7 @@ int convert_thread_options_to_cpu(struct thread_options *o,
 	o->create_only = le32_to_cpu(top->create_only);
 	o->filetype = le32_to_cpu(top->filetype);
 	o->end_fsync = le32_to_cpu(top->end_fsync);
+	o->end_syncfs = le32_to_cpu(top->end_syncfs);
 	o->pre_read = le32_to_cpu(top->pre_read);
 	o->sync_io = le32_to_cpu(top->sync_io);
 	o->write_hint = le32_to_cpu(top->write_hint);
@@ -442,6 +443,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->create_only = cpu_to_le32(o->create_only);
 	top->filetype = cpu_to_le32(o->filetype);
 	top->end_fsync = cpu_to_le32(o->end_fsync);
+	top->end_syncfs = cpu_to_le32(o->end_syncfs);
 	top->pre_read = cpu_to_le32(o->pre_read);
 	top->sync_io = cpu_to_le32(o->sync_io);
 	top->write_hint = cpu_to_le32(o->write_hint);
diff --git a/configure b/configure
index 64e58b650ec0..38752abd9784 100755
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
@@ -3107,6 +3125,9 @@ fi
 if test "$sync_file_range" = "yes" ; then
   output_sym "CONFIG_SYNC_FILE_RANGE"
 fi
+if test "$syncfs" = "yes" ; then
+  output_sym "CONFIG_SYNCFS"
+fi
 if test "$ASharedMemory_create" = "yes" ; then
   output_sym "CONFIG_ASHAREDMEMORY_CREATE"
 fi
diff --git a/fio.1 b/fio.1
index 9c4ff08c86ad..2e42fa93dcde 100644
--- a/fio.1
+++ b/fio.1
@@ -1275,6 +1275,12 @@ will be done. Default: false.
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
diff --git a/io_ddir.h b/io_ddir.h
index 280c1e796a26..2254cd687be4 100644
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
diff --git a/io_u.c b/io_u.c
index ec3f668cae49..76818262017a 100644
--- a/io_u.c
+++ b/io_u.c
@@ -2445,6 +2445,11 @@ void io_u_fill_buffer(struct thread_data *td, struct io_u *io_u,
 	fill_io_buffer(td, io_u->buf, min_write, max_bs);
 }
 
+static int do_syncfs(const struct thread_data *td, struct fio_file *f)
+{
+	return syncfs(f->fd);
+}
+
 static int do_sync_file_range(const struct thread_data *td,
 			      struct fio_file *f)
 {
@@ -2476,9 +2481,11 @@ int do_io_u_sync(const struct thread_data *td, struct io_u *io_u)
 		ret = io_u->xfer_buflen;
 		io_u->error = EINVAL;
 #endif
-	} else if (io_u->ddir == DDIR_SYNC_FILE_RANGE)
+	} else if (io_u->ddir == DDIR_SYNC_FILE_RANGE) {
 		ret = do_sync_file_range(td, io_u->file);
-	else {
+	} else if (io_u->ddir == DDIR_SYNCFS) {
+		ret = do_syncfs(td, io_u->file);
+	} else {
 		ret = io_u->xfer_buflen;
 		io_u->error = EINVAL;
 	}
diff --git a/options.c b/options.c
index 6bd94e13c5b9..424cca9b5fde 100644
--- a/options.c
+++ b/options.c
@@ -4600,6 +4600,16 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_FILE,
 		.group	= FIO_OPT_G_INVALID,
 	},
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
 	{
 		.name	= "unlink",
 		.lname	= "Unlink file",
diff --git a/server.h b/server.h
index a3b163b13a44..09e6663e4dde 100644
--- a/server.h
+++ b/server.h
@@ -51,7 +51,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 115,
+	FIO_SERVER_VER			= 116,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index 3abce7318ce2..46c8d718f8a5 100644
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
@@ -524,6 +525,8 @@ struct thread_options_pack {
 	uint32_t exitall_error;
 
 	uint32_t sync_file_range;
+	uint32_t end_syncfs;
+	uint32_t pad;
 
 	struct zone_split zone_split[DDIR_RWDIR_CNT][ZONESPLIT_MAX];
 	uint32_t zone_split_nr[DDIR_RWDIR_CNT];
@@ -621,7 +624,7 @@ struct thread_options_pack {
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
2.52.0

