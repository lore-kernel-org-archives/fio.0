Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbhBONAp (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 15 Feb 2021 08:00:45 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD4CC061756
        for <fio@vger.kernel.org>; Mon, 15 Feb 2021 05:00:05 -0800 (PST)
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1lBdTu-0006EY-T0
        for fio@vger.kernel.org; Mon, 15 Feb 2021 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210215130001.8F6C31BC013B@kernel.dk>
Date: Mon, 15 Feb 2021 06:00:01 -0700 (MST)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit b02c5eda07966d2e1c41870f64b741413b67a9aa:

  Merge branch 'taras/clientuid' of https://github.com/tarasglek/fio-1 (2021-02-10 13:22:04 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d16e84e256ffdcd3143c9439cf1e408d8db61c1a:

  Merge branch 'per-engine-pre-write-function' of https://github.com/lukaszstolarczuk/fio (2021-02-14 13:21:05 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'per-engine-pre-write-function' of https://github.com/lukaszstolarczuk/fio

��ukasz Stolarczuk (1):
      filesetup: add engine's io_ops to prepopulate file with data

 engines/libpmem.c |   1 +
 file.h            |   1 +
 filesetup.c       | 126 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ioengines.h       |   3 +-
 4 files changed, 130 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/engines/libpmem.c b/engines/libpmem.c
index eefb7767..2338f0fa 100644
--- a/engines/libpmem.c
+++ b/engines/libpmem.c
@@ -255,6 +255,7 @@ FIO_STATIC struct ioengine_ops ioengine = {
 	.open_file	= fio_libpmem_open_file,
 	.close_file	= fio_libpmem_close_file,
 	.get_file_size	= generic_get_file_size,
+	.prepopulate_file = generic_prepopulate_file,
 	.flags		= FIO_SYNCIO | FIO_RAWIO | FIO_DISKLESSIO | FIO_NOEXTEND |
 				FIO_NODISKUTIL | FIO_BARRIER | FIO_MEMALIGN,
 };
diff --git a/file.h b/file.h
index 493ec04a..faf65a2a 100644
--- a/file.h
+++ b/file.h
@@ -207,6 +207,7 @@ extern "C" {
 extern int __must_check generic_open_file(struct thread_data *, struct fio_file *);
 extern int __must_check generic_close_file(struct thread_data *, struct fio_file *);
 extern int __must_check generic_get_file_size(struct thread_data *, struct fio_file *);
+extern int __must_check generic_prepopulate_file(struct thread_data *, struct fio_file *);
 #ifdef __cplusplus
 }
 #endif
diff --git a/filesetup.c b/filesetup.c
index 9d033757..661d4c2f 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -338,6 +338,95 @@ error:
 	return ret;
 }
 
+/*
+ * Generic function to prepopulate regular file with data.
+ * Useful if you want to make sure I/O engine has data to read.
+ * Leaves f->fd open on success, caller must close.
+ */
+int generic_prepopulate_file(struct thread_data *td, struct fio_file *f)
+{
+	int flags;
+	unsigned long long left, bs;
+	char *b = NULL;
+
+	/* generic function for regular files only */
+	assert(f->filetype == FIO_TYPE_FILE);
+
+	if (read_only) {
+		log_err("fio: refusing to write a file due to read-only\n");
+		return 0;
+	}
+
+	flags = O_WRONLY;
+	if (td->o.allow_create)
+		flags |= O_CREAT;
+
+#ifdef WIN32
+	flags |= _O_BINARY;
+#endif
+
+	dprint(FD_FILE, "open file %s, flags %x\n", f->file_name, flags);
+	f->fd = open(f->file_name, flags, 0644);
+	if (f->fd < 0) {
+		int err = errno;
+
+		if (err == ENOENT && !td->o.allow_create)
+			log_err("fio: file creation disallowed by "
+					"allow_file_create=0\n");
+		else
+			td_verror(td, err, "open");
+		return 1;
+	}
+
+	left = f->real_file_size;
+	bs = td->o.max_bs[DDIR_WRITE];
+	if (bs > left)
+		bs = left;
+
+	b = malloc(bs);
+	if (!b) {
+		td_verror(td, errno, "malloc");
+		goto err;
+	}
+
+	while (left && !td->terminate) {
+		ssize_t r;
+
+		if (bs > left)
+			bs = left;
+
+		fill_io_buffer(td, b, bs, bs);
+
+		r = write(f->fd, b, bs);
+
+		if (r > 0) {
+			left -= r;
+		} else {
+			td_verror(td, errno, "write");
+			goto err;
+		}
+	}
+
+	if (td->terminate) {
+		dprint(FD_FILE, "terminate unlink %s\n", f->file_name);
+		td_io_unlink_file(td, f);
+	} else if (td->o.create_fsync) {
+		if (fsync(f->fd) < 0) {
+			td_verror(td, errno, "fsync");
+			goto err;
+		}
+	}
+
+	free(b);
+	return 0;
+err:
+	close(f->fd);
+	f->fd = -1;
+	if (b)
+		free(b);
+	return 1;
+}
+
 unsigned long long get_rand_file_size(struct thread_data *td)
 {
 	unsigned long long ret, sized;
@@ -1254,6 +1343,43 @@ int setup_files(struct thread_data *td)
 		temp_stall_ts = 0;
 	}
 
+	if (err)
+		goto err_out;
+
+	/*
+	 * Prepopulate files with data. It might be expected to read some
+	 * "real" data instead of zero'ed files (if no writes to file occurred
+	 * prior to a read job). Engine has to provide a way to do that.
+	 */
+	if (td->io_ops->prepopulate_file) {
+		temp_stall_ts = 1;
+
+		for_each_file(td, f, i) {
+			if (output_format & FIO_OUTPUT_NORMAL) {
+				log_info("%s: Prepopulating IO file (%s)\n",
+							o->name, f->file_name);
+			}
+
+			err = td->io_ops->prepopulate_file(td, f);
+			if (err)
+				break;
+
+			err = __file_invalidate_cache(td, f, f->file_offset,
+								f->io_size);
+
+			/*
+			 * Shut up static checker
+			 */
+			if (f->fd != -1)
+				close(f->fd);
+
+			f->fd = -1;
+			if (err)
+				break;
+		}
+		temp_stall_ts = 0;
+	}
+
 	if (err)
 		goto err_out;
 
diff --git a/ioengines.h b/ioengines.h
index 839b318d..1d01ab0a 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -8,7 +8,7 @@
 #include "io_u.h"
 #include "zbd_types.h"
 
-#define FIO_IOOPS_VERSION	28
+#define FIO_IOOPS_VERSION	29
 
 #ifndef CONFIG_DYNAMIC_ENGINES
 #define FIO_STATIC	static
@@ -47,6 +47,7 @@ struct ioengine_ops {
 	int (*invalidate)(struct thread_data *, struct fio_file *);
 	int (*unlink_file)(struct thread_data *, struct fio_file *);
 	int (*get_file_size)(struct thread_data *, struct fio_file *);
+	int (*prepopulate_file)(struct thread_data *, struct fio_file *);
 	void (*terminate)(struct thread_data *);
 	int (*iomem_alloc)(struct thread_data *, size_t);
 	void (*iomem_free)(struct thread_data *);

