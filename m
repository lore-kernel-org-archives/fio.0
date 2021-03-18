Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbhCRMAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 18 Mar 2021 08:00:07 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07D7FC06174A
        for <fio@vger.kernel.org>; Thu, 18 Mar 2021 05:00:07 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lMrJr-0059FT-Uh
        for fio@vger.kernel.org; Thu, 18 Mar 2021 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210318120001.D19F71BC0152@kernel.dk>
Date: Thu, 18 Mar 2021 06:00:01 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 014ab48afcbcf442464acc7427fcd0f194f64bf4:

  Merge branch 'dev_luye_github' of https://github.com/louisluSCU/fio (2021-03-11 11:50:49 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to dede9b9fae3ab670c1ca864ac66aea5e997e1f34:

  Merge branch 'free-dump-options' of https://github.com/floatious/fio (2021-03-17 09:25:46 -0600)

----------------------------------------------------------------
Jens Axboe (3):
      Merge branch 'dfs_engine' of https://github.com/johannlombardi/fio
      Merge branch 'patch-1' of https://github.com/ihsinme/fio
      Merge branch 'free-dump-options' of https://github.com/floatious/fio

Johann Lombardi (2):
      Disable pthread_condattr_setclock on cygwin
      engines/dfs: add DAOS File System (dfs) engine

Niklas Cassel (1):
      options: free dump options list on exit

ihsinme (1):
      fix loop with unreachable exit condition

 HOWTO            |  21 ++
 Makefile         |   5 +
 backend.c        |   1 +
 configure        |  52 ++++-
 engines/dfs.c    | 583 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 examples/dfs.fio |  33 ++++
 fio.1            |  18 ++
 init.c           |  13 --
 optgroup.c       |   4 +
 optgroup.h       |   2 +
 options.c        |  18 ++
 options.h        |   1 +
 server.c         |   2 +-
 13 files changed, 730 insertions(+), 23 deletions(-)
 create mode 100644 engines/dfs.c
 create mode 100644 examples/dfs.fio

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 1e5ebd5d..041b91fa 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2067,6 +2067,9 @@ I/O engine
 			unless :option:`verify` is set or :option:`cuda_io` is `posix`.
 			:option:`iomem` must not be `cudamalloc`. This ioengine defines
 			engine specific options.
+		**dfs**
+			I/O engine supporting asynchronous read and write operations to the
+			DAOS File System (DFS) via libdfs.
 
 I/O engine specific parameters
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
@@ -2452,6 +2455,24 @@ with the caveat that when used on the command line, they must come after the
 		GPU to RAM before a write and copied from RAM to GPU after a
 		read. :option:`verify` does not affect use of cudaMemcpy.
 
+.. option:: pool=str : [dfs]
+
+	Specify the UUID of the DAOS pool to connect to.
+
+.. option:: cont=str : [dfs]
+
+	Specify the UUID of the DAOS container to open.
+
+.. option:: chunk_size=int : [dfs]
+
+	Specificy a different chunk size (in bytes) for the dfs file.
+	Use DAOS container's chunk size by default.
+
+.. option:: object_class=str : [dfs]
+
+	Specificy a different object class for the dfs file.
+	Use DAOS container's object class by default.
+
 I/O depth
 ~~~~~~~~~
 
diff --git a/Makefile b/Makefile
index 612344d1..87a47b66 100644
--- a/Makefile
+++ b/Makefile
@@ -130,6 +130,11 @@ ifdef CONFIG_HTTP
   http_LIBS = -lcurl -lssl -lcrypto
   ENGINES += http
 endif
+ifdef CONFIG_DFS
+  dfs_SRCS = engines/dfs.c
+  dfs_LIBS = -luuid -ldaos -ldfs
+  ENGINES += dfs
+endif
 SOURCE += oslib/asprintf.c
 ifndef CONFIG_STRSEP
   SOURCE += oslib/strsep.c
diff --git a/backend.c b/backend.c
index f2efddd6..52b4ca7e 100644
--- a/backend.c
+++ b/backend.c
@@ -2537,6 +2537,7 @@ int fio_backend(struct sk_out *sk_out)
 	for_each_td(td, i) {
 		steadystate_free(td);
 		fio_options_free(td);
+		fio_dump_options_free(td);
 		if (td->rusage_sem) {
 			fio_sem_remove(td->rusage_sem);
 			td->rusage_sem = NULL;
diff --git a/configure b/configure
index 71b31868..d79f6521 100755
--- a/configure
+++ b/configure
@@ -171,6 +171,7 @@ march_set="no"
 libiscsi="no"
 libnbd="no"
 libzbc=""
+dfs=""
 dynamic_engines="no"
 prefix=/usr/local
 
@@ -242,6 +243,8 @@ for opt do
   ;;
   --dynamic-libengines) dynamic_engines="yes"
   ;;
+  --disable-dfs) dfs="no"
+  ;;
   --help)
     show_help="yes"
     ;;
@@ -284,6 +287,7 @@ if test "$show_help" = "yes" ; then
   echo "--disable-libzbc        Disable libzbc even if found"
   echo "--disable-tcmalloc	Disable tcmalloc support"
   echo "--dynamic-libengines	Lib-based ioengines as dynamic libraries"
+  echo "--disable-dfs		Disable DAOS File System support even if found"
   exit $exit_val
 fi
 
@@ -413,6 +417,7 @@ CYGWIN*)
   clock_gettime="yes" # clock_monotonic probe has dependency on this
   clock_monotonic="yes"
   sched_idle="yes"
+  pthread_condattr_setclock="no"
   ;;
 esac
 
@@ -758,10 +763,8 @@ print_config "POSIX pshared support" "$posix_pshared"
 
 ##########################################
 # POSIX pthread_condattr_setclock() probe
-if test "$pthread_condattr_setclock" != "yes" ; then
-  pthread_condattr_setclock="no"
-fi
-cat > $TMPC <<EOF
+if test "$pthread_condattr_setclock" != "no" ; then
+  cat > $TMPC <<EOF
 #include <pthread.h>
 int main(void)
 {
@@ -770,11 +773,12 @@ int main(void)
   return 0;
 }
 EOF
-if compile_prog "" "$LIBS" "pthread_condattr_setclock" ; then
-  pthread_condattr_setclock=yes
-elif compile_prog "" "$LIBS -lpthread" "pthread_condattr_setclock" ; then
-  pthread_condattr_setclock=yes
-  LIBS="$LIBS -lpthread"
+  if compile_prog "" "$LIBS" "pthread_condattr_setclock" ; then
+    pthread_condattr_setclock=yes
+  elif compile_prog "" "$LIBS -lpthread" "pthread_condattr_setclock" ; then
+    pthread_condattr_setclock=yes
+    LIBS="$LIBS -lpthread"
+  fi
 fi
 print_config "pthread_condattr_setclock()" "$pthread_condattr_setclock"
 
@@ -2179,6 +2183,33 @@ if test "$libnbd" != "no" ; then
 fi
 print_config "NBD engine" "$libnbd"
 
+##########################################
+# check for dfs (DAOS File System)
+if test "$dfs" != "no" ; then
+  cat > $TMPC << EOF
+#include <fcntl.h>
+#include <daos.h>
+#include <daos_fs.h>
+
+int main(int argc, char **argv)
+{
+  daos_handle_t	poh;
+  daos_handle_t	coh;
+  dfs_t		*dfs;
+
+  (void) dfs_mount(poh, coh, O_RDWR, &dfs);
+
+  return 0;
+}
+EOF
+  if compile_prog "" "-luuid -ldfs -ldaos" "dfs"; then
+    dfs="yes"
+  else
+    dfs="no"
+  fi
+fi
+print_config "DAOS File System (dfs) Engine" "$dfs"
+
 ##########################################
 # Check if we have lex/yacc available
 yacc="no"
@@ -2988,6 +3019,9 @@ fi
 if test "$libcufile" = "yes" ; then
   output_sym "CONFIG_LIBCUFILE"
 fi
+if test "$dfs" = "yes" ; then
+  output_sym "CONFIG_DFS"
+fi
 if test "$march_set" = "no" && test "$build_native" = "yes" ; then
   output_sym "CONFIG_BUILD_NATIVE"
 fi
diff --git a/engines/dfs.c b/engines/dfs.c
new file mode 100644
index 00000000..0343b101
--- /dev/null
+++ b/engines/dfs.c
@@ -0,0 +1,583 @@
+/**
+ * FIO engine for DAOS File System (dfs).
+ *
+ * (C) Copyright 2020-2021 Intel Corporation.
+ */
+
+#include <fio.h>
+#include <optgroup.h>
+
+#include <daos.h>
+#include <daos_fs.h>
+
+static bool		daos_initialized;
+static int		num_threads;
+static pthread_mutex_t	daos_mutex = PTHREAD_MUTEX_INITIALIZER;
+daos_handle_t		poh;  /* pool handle */
+daos_handle_t		coh;  /* container handle */
+daos_oclass_id_t	cid = OC_UNKNOWN;  /* object class */
+dfs_t			*dfs; /* dfs mount reference */
+
+struct daos_iou {
+	struct io_u	*io_u;
+	daos_event_t	ev;
+	d_sg_list_t	sgl;
+	d_iov_t		iov;
+	daos_size_t	size;
+	bool		complete;
+};
+
+struct daos_data {
+	daos_handle_t	eqh;
+	dfs_obj_t	*obj;
+	struct io_u	**io_us;
+	int		queued;
+	int		num_ios;
+};
+
+struct daos_fio_options {
+	void		*pad;
+	char		*pool;   /* Pool UUID */
+	char		*cont;   /* Container UUID */
+	daos_size_t	chsz;    /* Chunk size */
+	char		*oclass; /* object class */
+#if !defined(DAOS_API_VERSION_MAJOR) || DAOS_API_VERSION_MAJOR < 1
+	char		*svcl;   /* service replica list, deprecated */
+#endif
+};
+
+static struct fio_option options[] = {
+	{
+		.name		= "pool",
+		.lname		= "pool uuid",
+		.type		= FIO_OPT_STR_STORE,
+		.off1		= offsetof(struct daos_fio_options, pool),
+		.help		= "DAOS pool uuid",
+		.category	= FIO_OPT_C_ENGINE,
+		.group		= FIO_OPT_G_DFS,
+	},
+	{
+		.name           = "cont",
+		.lname          = "container uuid",
+		.type           = FIO_OPT_STR_STORE,
+		.off1           = offsetof(struct daos_fio_options, cont),
+		.help           = "DAOS container uuid",
+		.category	= FIO_OPT_C_ENGINE,
+		.group		= FIO_OPT_G_DFS,
+	},
+	{
+		.name           = "chunk_size",
+		.lname          = "DFS chunk size",
+		.type           = FIO_OPT_ULL,
+		.off1           = offsetof(struct daos_fio_options, chsz),
+		.help           = "DFS chunk size in bytes",
+		.def		= "0", /* use container default */
+		.category	= FIO_OPT_C_ENGINE,
+		.group		= FIO_OPT_G_DFS,
+	},
+	{
+		.name           = "object_class",
+		.lname          = "object class",
+		.type           = FIO_OPT_STR_STORE,
+		.off1           = offsetof(struct daos_fio_options, oclass),
+		.help           = "DAOS object class",
+		.category	= FIO_OPT_C_ENGINE,
+		.group		= FIO_OPT_G_DFS,
+	},
+#if !defined(DAOS_API_VERSION_MAJOR) || DAOS_API_VERSION_MAJOR < 1
+	{
+		.name           = "svcl",
+		.lname          = "List of service ranks",
+		.type           = FIO_OPT_STR_STORE,
+		.off1           = offsetof(struct daos_fio_options, svcl),
+		.help           = "List of pool replicated service ranks",
+		.category	= FIO_OPT_C_ENGINE,
+		.group		= FIO_OPT_G_DFS,
+	},
+#endif
+	{
+		.name           = NULL,
+	},
+};
+
+static int daos_fio_global_init(struct thread_data *td)
+{
+	struct daos_fio_options	*eo = td->eo;
+	uuid_t			pool_uuid, co_uuid;
+	daos_pool_info_t	pool_info;
+	daos_cont_info_t	co_info;
+	int			rc = 0;
+
+#if !defined(DAOS_API_VERSION_MAJOR) || DAOS_API_VERSION_MAJOR < 1
+	if (!eo->pool || !eo->cont || !eo->svcl) {
+#else
+	if (!eo->pool || !eo->cont) {
+#endif
+		log_err("Missing required DAOS options\n");
+		return EINVAL;
+	}
+
+	rc = daos_init();
+	if (rc != -DER_ALREADY && rc) {
+		log_err("Failed to initialize daos %d\n", rc);
+		td_verror(td, rc, "daos_init");
+		return rc;
+	}
+
+	rc = uuid_parse(eo->pool, pool_uuid);
+	if (rc) {
+		log_err("Failed to parse 'Pool uuid': %s\n", eo->pool);
+		td_verror(td, EINVAL, "uuid_parse(eo->pool)");
+		return EINVAL;
+	}
+
+	rc = uuid_parse(eo->cont, co_uuid);
+	if (rc) {
+		log_err("Failed to parse 'Cont uuid': %s\n", eo->cont);
+		td_verror(td, EINVAL, "uuid_parse(eo->cont)");
+		return EINVAL;
+	}
+
+	/* Connect to the DAOS pool */
+#if !defined(DAOS_API_VERSION_MAJOR) || DAOS_API_VERSION_MAJOR < 1
+	d_rank_list_t *svcl = NULL;
+
+	svcl = daos_rank_list_parse(eo->svcl, ":");
+	if (svcl == NULL) {
+		log_err("Failed to parse svcl\n");
+		td_verror(td, EINVAL, "daos_rank_list_parse");
+		return EINVAL;
+	}
+
+	rc = daos_pool_connect(pool_uuid, NULL, svcl, DAOS_PC_RW,
+			&poh, &pool_info, NULL);
+	d_rank_list_free(svcl);
+#else
+	rc = daos_pool_connect(pool_uuid, NULL, DAOS_PC_RW, &poh, &pool_info,
+			       NULL);
+#endif
+	if (rc) {
+		log_err("Failed to connect to pool %d\n", rc);
+		td_verror(td, rc, "daos_pool_connect");
+		return rc;
+	}
+
+	/* Open the DAOS container */
+	rc = daos_cont_open(poh, co_uuid, DAOS_COO_RW, &coh, &co_info, NULL);
+	if (rc) {
+		log_err("Failed to open container: %d\n", rc);
+		td_verror(td, rc, "daos_cont_open");
+		(void)daos_pool_disconnect(poh, NULL);
+		return rc;
+	}
+
+	/* Mount encapsulated filesystem */
+	rc = dfs_mount(poh, coh, O_RDWR, &dfs);
+	if (rc) {
+		log_err("Failed to mount DFS namespace: %d\n", rc);
+		td_verror(td, rc, "dfs_mount");
+		(void)daos_pool_disconnect(poh, NULL);
+		(void)daos_cont_close(coh, NULL);
+		return rc;
+	}
+
+	/* Retrieve object class to use, if specified */
+	if (eo->oclass)
+		cid = daos_oclass_name2id(eo->oclass);
+
+	return 0;
+}
+
+static int daos_fio_global_cleanup()
+{
+	int rc;
+	int ret = 0;
+
+	rc = dfs_umount(dfs);
+	if (rc) {
+		log_err("failed to umount dfs: %d\n", rc);
+		ret = rc;
+	}
+	rc = daos_cont_close(coh, NULL);
+	if (rc) {
+		log_err("failed to close container: %d\n", rc);
+		if (ret == 0)
+			ret = rc;
+	}
+	rc = daos_pool_disconnect(poh, NULL);
+	if (rc) {
+		log_err("failed to disconnect pool: %d\n", rc);
+		if (ret == 0)
+			ret = rc;
+	}
+	rc = daos_fini();
+	if (rc) {
+		log_err("failed to finalize daos: %d\n", rc);
+		if (ret == 0)
+			ret = rc;
+	}
+
+	return ret;
+}
+
+static int daos_fio_setup(struct thread_data *td)
+{
+	return 0;
+}
+
+static int daos_fio_init(struct thread_data *td)
+{
+	struct daos_data	*dd;
+	int			rc = 0;
+
+	pthread_mutex_lock(&daos_mutex);
+
+	dd = malloc(sizeof(*dd));
+	if (dd == NULL) {
+		log_err("Failed to allocate DAOS-private data\n");
+		rc = ENOMEM;
+		goto out;
+	}
+
+	dd->queued	= 0;
+	dd->num_ios	= td->o.iodepth;
+	dd->io_us	= calloc(dd->num_ios, sizeof(struct io_u *));
+	if (dd->io_us == NULL) {
+		log_err("Failed to allocate IO queue\n");
+		rc = ENOMEM;
+		goto out;
+	}
+
+	/* initialize DAOS stack if not already up */
+	if (!daos_initialized) {
+		rc = daos_fio_global_init(td);
+		if (rc)
+			goto out;
+		daos_initialized = true;
+	}
+
+	rc = daos_eq_create(&dd->eqh);
+	if (rc) {
+		log_err("Failed to create event queue: %d\n", rc);
+		td_verror(td, rc, "daos_eq_create");
+		goto out;
+	}
+
+	td->io_ops_data = dd;
+	num_threads++;
+out:
+	if (rc) {
+		if (dd) {
+			free(dd->io_us);
+			free(dd);
+		}
+		if (num_threads == 0 && daos_initialized) {
+			/* don't clobber error return value */
+			(void)daos_fio_global_cleanup();
+			daos_initialized = false;
+		}
+	}
+	pthread_mutex_unlock(&daos_mutex);
+	return rc;
+}
+
+static void daos_fio_cleanup(struct thread_data *td)
+{
+	struct daos_data	*dd = td->io_ops_data;
+	int			rc;
+
+	if (dd == NULL)
+		return;
+
+	rc = daos_eq_destroy(dd->eqh, DAOS_EQ_DESTROY_FORCE);
+	if (rc < 0) {
+		log_err("failed to destroy event queue: %d\n", rc);
+		td_verror(td, rc, "daos_eq_destroy");
+	}
+
+	free(dd->io_us);
+	free(dd);
+
+	pthread_mutex_lock(&daos_mutex);
+	num_threads--;
+	if (daos_initialized && num_threads == 0) {
+		int ret;
+
+		ret = daos_fio_global_cleanup();
+		if (ret < 0 && rc == 0) {
+			log_err("failed to clean up: %d\n", ret);
+			td_verror(td, ret, "daos_fio_global_cleanup");
+		}
+		daos_initialized = false;
+	}
+	pthread_mutex_unlock(&daos_mutex);
+}
+
+static int daos_fio_get_file_size(struct thread_data *td, struct fio_file *f)
+{
+	char		*file_name = f->file_name;
+	struct stat	stbuf = {0};
+	int		rc;
+
+	dprint(FD_FILE, "dfs stat %s\n", f->file_name);
+
+	if (!daos_initialized)
+		return 0;
+
+	rc = dfs_stat(dfs, NULL, file_name, &stbuf);
+	if (rc) {
+		log_err("Failed to stat %s: %d\n", f->file_name, rc);
+		td_verror(td, rc, "dfs_stat");
+		return rc;
+	}
+
+	f->real_file_size = stbuf.st_size;
+	return 0;
+}
+
+static int daos_fio_close(struct thread_data *td, struct fio_file *f)
+{
+	struct daos_data	*dd = td->io_ops_data;
+	int			rc;
+
+	dprint(FD_FILE, "dfs release %s\n", f->file_name);
+
+	rc = dfs_release(dd->obj);
+	if (rc) {
+		log_err("Failed to release %s: %d\n", f->file_name, rc);
+		td_verror(td, rc, "dfs_release");
+		return rc;
+	}
+
+	return 0;
+}
+
+static int daos_fio_open(struct thread_data *td, struct fio_file *f)
+{
+	struct daos_data	*dd = td->io_ops_data;
+	struct daos_fio_options	*eo = td->eo;
+	int			flags = 0;
+	int			rc;
+
+	dprint(FD_FILE, "dfs open %s (%s/%d/%d)\n",
+	       f->file_name, td_write(td) & !read_only ? "rw" : "r",
+	       td->o.create_on_open, td->o.allow_create);
+
+	if (td->o.create_on_open && td->o.allow_create)
+		flags |= O_CREAT;
+
+	if (td_write(td)) {
+		if (!read_only)
+			flags |= O_RDWR;
+		if (td->o.allow_create)
+			flags |= O_CREAT;
+	} else if (td_read(td)) {
+		flags |= O_RDONLY;
+	}
+
+	rc = dfs_open(dfs, NULL, f->file_name,
+		      S_IFREG | S_IRUSR | S_IWUSR,
+		      flags, cid, eo->chsz, NULL, &dd->obj);
+	if (rc) {
+		log_err("Failed to open %s: %d\n", f->file_name, rc);
+		td_verror(td, rc, "dfs_open");
+		return rc;
+	}
+
+	return 0;
+}
+
+static int daos_fio_unlink(struct thread_data *td, struct fio_file *f)
+{
+	int rc;
+
+	dprint(FD_FILE, "dfs remove %s\n", f->file_name);
+
+	rc = dfs_remove(dfs, NULL, f->file_name, false, NULL);
+	if (rc) {
+		log_err("Failed to remove %s: %d\n", f->file_name, rc);
+		td_verror(td, rc, "dfs_remove");
+		return rc;
+	}
+
+	return 0;
+}
+
+static int daos_fio_invalidate(struct thread_data *td, struct fio_file *f)
+{
+	dprint(FD_FILE, "dfs invalidate %s\n", f->file_name);
+	return 0;
+}
+
+static void daos_fio_io_u_free(struct thread_data *td, struct io_u *io_u)
+{
+	struct daos_iou *io = io_u->engine_data;
+
+	if (io) {
+		io_u->engine_data = NULL;
+		free(io);
+	}
+}
+
+static int daos_fio_io_u_init(struct thread_data *td, struct io_u *io_u)
+{
+	struct daos_iou *io;
+
+	io = malloc(sizeof(struct daos_iou));
+	if (!io) {
+		td_verror(td, ENOMEM, "malloc");
+		return ENOMEM;
+	}
+	io->io_u = io_u;
+	io_u->engine_data = io;
+	return 0;
+}
+
+static struct io_u * daos_fio_event(struct thread_data *td, int event)
+{
+	struct daos_data *dd = td->io_ops_data;
+
+	return dd->io_us[event];
+}
+
+static int daos_fio_getevents(struct thread_data *td, unsigned int min,
+			      unsigned int max, const struct timespec *t)
+{
+	struct daos_data	*dd = td->io_ops_data;
+	daos_event_t		*evp[max];
+	unsigned int		events = 0;
+	int			i;
+	int			rc;
+
+	while (events < min) {
+		rc = daos_eq_poll(dd->eqh, 0, DAOS_EQ_NOWAIT, max, evp);
+		if (rc < 0) {
+			log_err("Event poll failed: %d\n", rc);
+			td_verror(td, rc, "daos_eq_poll");
+			return events;
+		}
+
+		for (i = 0; i < rc; i++) {
+			struct daos_iou	*io;
+			struct io_u	*io_u;
+
+			io = container_of(evp[i], struct daos_iou, ev);
+			if (io->complete)
+				log_err("Completion on already completed I/O\n");
+
+			io_u = io->io_u;
+			if (io->ev.ev_error)
+				io_u->error = io->ev.ev_error;
+			else
+				io_u->resid = 0;
+
+			dd->io_us[events] = io_u;
+			dd->queued--;
+			daos_event_fini(&io->ev);
+			io->complete = true;
+			events++;
+		}
+	}
+
+	dprint(FD_IO, "dfs eq_pool returning %d (%u/%u)\n", events, min, max);
+
+	return events;
+}
+
+static enum fio_q_status daos_fio_queue(struct thread_data *td,
+					struct io_u *io_u)
+{
+	struct daos_data	*dd = td->io_ops_data;
+	struct daos_iou		*io = io_u->engine_data;
+	daos_off_t		offset = io_u->offset;
+	int			rc;
+
+	if (dd->queued == td->o.iodepth)
+		return FIO_Q_BUSY;
+
+	io->sgl.sg_nr = 1;
+	io->sgl.sg_nr_out = 0;
+	d_iov_set(&io->iov, io_u->xfer_buf, io_u->xfer_buflen);
+	io->sgl.sg_iovs = &io->iov;
+	io->size = io_u->xfer_buflen;
+
+	io->complete = false;
+	rc = daos_event_init(&io->ev, dd->eqh, NULL);
+	if (rc) {
+		log_err("Event init failed: %d\n", rc);
+		io_u->error = rc;
+		return FIO_Q_COMPLETED;
+	}
+
+	switch (io_u->ddir) {
+	case DDIR_WRITE:
+		rc = dfs_write(dfs, dd->obj, &io->sgl, offset, &io->ev);
+		if (rc) {
+			log_err("dfs_write failed: %d\n", rc);
+			io_u->error = rc;
+			return FIO_Q_COMPLETED;
+		}
+		break;
+	case DDIR_READ:
+		rc = dfs_read(dfs, dd->obj, &io->sgl, offset, &io->size,
+			      &io->ev);
+		if (rc) {
+			log_err("dfs_read failed: %d\n", rc);
+			io_u->error = rc;
+			return FIO_Q_COMPLETED;
+		}
+		break;
+	case DDIR_SYNC:
+		io_u->error = 0;
+		return FIO_Q_COMPLETED;
+	default:
+		dprint(FD_IO, "Invalid IO type: %d\n", io_u->ddir);
+		io_u->error = -DER_INVAL;
+		return FIO_Q_COMPLETED;
+	}
+
+	dd->queued++;
+	return FIO_Q_QUEUED;
+}
+
+static int daos_fio_prep(struct thread_data fio_unused *td, struct io_u *io_u)
+{
+	return 0;
+}
+
+/* ioengine_ops for get_ioengine() */
+FIO_STATIC struct ioengine_ops ioengine = {
+	.name			= "dfs",
+	.version		= FIO_IOOPS_VERSION,
+	.flags			= FIO_DISKLESSIO | FIO_NODISKUTIL,
+
+	.setup			= daos_fio_setup,
+	.init			= daos_fio_init,
+	.prep			= daos_fio_prep,
+	.cleanup		= daos_fio_cleanup,
+
+	.open_file		= daos_fio_open,
+	.invalidate		= daos_fio_invalidate,
+	.get_file_size		= daos_fio_get_file_size,
+	.close_file		= daos_fio_close,
+	.unlink_file		= daos_fio_unlink,
+
+	.queue			= daos_fio_queue,
+	.getevents		= daos_fio_getevents,
+	.event			= daos_fio_event,
+	.io_u_init		= daos_fio_io_u_init,
+	.io_u_free		= daos_fio_io_u_free,
+
+	.option_struct_size	= sizeof(struct daos_fio_options),
+	.options		= options,
+};
+
+static void fio_init fio_dfs_register(void)
+{
+	register_ioengine(&ioengine);
+}
+
+static void fio_exit fio_dfs_unregister(void)
+{
+	unregister_ioengine(&ioengine);
+}
diff --git a/examples/dfs.fio b/examples/dfs.fio
new file mode 100644
index 00000000..5de887d7
--- /dev/null
+++ b/examples/dfs.fio
@@ -0,0 +1,33 @@
+[global]
+ioengine=dfs
+pool=${POOL}
+cont=${CONT}
+filename_format=fio-test.$jobnum
+
+cpus_allowed_policy=split
+group_reporting=1
+time_based=0
+percentile_list=99.0:99.9:99.99:99.999:99.9999:100
+disable_slat=1
+disable_clat=1
+
+bs=1M
+size=100G
+iodepth=16
+numjobs=16
+
+[daos-seqwrite]
+rw=write
+stonewall
+
+[daos-seqread]
+rw=read
+stonewall
+
+[daos-randwrite]
+rw=randwrite
+stonewall
+
+[daos-randread]
+rw=randread
+stonewall
diff --git a/fio.1 b/fio.1
index b95a67ab..27cf2f15 100644
--- a/fio.1
+++ b/fio.1
@@ -1856,6 +1856,10 @@ GPUDirect Storage-supported filesystem. This engine performs
 I/O without transferring buffers between user-space and the kernel,
 unless \fBverify\fR is set or \fBcuda_io\fR is \fBposix\fR. \fBiomem\fR must
 not be \fBcudamalloc\fR. This ioengine defines engine specific options.
+.TP
+.B dfs
+I/O engine supporting asynchronous read and write operations to the DAOS File
+System (DFS) via libdfs.
 .SS "I/O engine specific parameters"
 In addition, there are some parameters which are only valid when a specific
 \fBioengine\fR is in use. These are used identically to normal parameters,
@@ -2209,6 +2213,20 @@ from RAM to GPU after a read. \fBverify\fR does not affect
 the use of cudaMemcpy.
 .RE
 .RE
+.TP
+.BI (dfs)pool
+Specify the UUID of the DAOS pool to connect to.
+.TP
+.BI (dfs)cont
+Specify the UUID of the DAOS DAOS container to open.
+.TP
+.BI (dfs)chunk_size
+Specificy a different chunk size (in bytes) for the dfs file.
+Use DAOS container's chunk size by default.
+.TP
+.BI (dfs)object_class
+Specificy a different object class for the dfs file.
+Use DAOS container's object class by default.
 .SS "I/O depth"
 .TP
 .BI iodepth \fR=\fPint
diff --git a/init.c b/init.c
index e8530fec..37bff876 100644
--- a/init.c
+++ b/init.c
@@ -448,19 +448,6 @@ static void dump_opt_list(struct thread_data *td)
 	}
 }
 
-static void fio_dump_options_free(struct thread_data *td)
-{
-	while (!flist_empty(&td->opt_list)) {
-		struct print_option *p;
-
-		p = flist_first_entry(&td->opt_list, struct print_option, list);
-		flist_del_init(&p->list);
-		free(p->name);
-		free(p->value);
-		free(p);
-	}
-}
-
 static void copy_opt_list(struct thread_data *dst, struct thread_data *src)
 {
 	struct flist_head *entry;
diff --git a/optgroup.c b/optgroup.c
index 64774896..4cdea71f 100644
--- a/optgroup.c
+++ b/optgroup.c
@@ -177,6 +177,10 @@ static const struct opt_group fio_opt_cat_groups[] = {
 		.name	= "libcufile I/O engine", /* libcufile */
 		.mask	= FIO_OPT_G_LIBCUFILE,
 	},
+	{
+		.name	= "DAOS File System (dfs) I/O engine", /* dfs */
+		.mask	= FIO_OPT_G_DFS,
+	},
 	{
 		.name	= NULL,
 	},
diff --git a/optgroup.h b/optgroup.h
index d2f1ceb3..25b7fec1 100644
--- a/optgroup.h
+++ b/optgroup.h
@@ -68,6 +68,7 @@ enum opt_category_group {
 	__FIO_OPT_G_FILESTAT,
 	__FIO_OPT_G_NR,
 	__FIO_OPT_G_LIBCUFILE,
+	__FIO_OPT_G_DFS,
 
 	FIO_OPT_G_RATE		= (1ULL << __FIO_OPT_G_RATE),
 	FIO_OPT_G_ZONE		= (1ULL << __FIO_OPT_G_ZONE),
@@ -110,6 +111,7 @@ enum opt_category_group {
 	FIO_OPT_G_IOURING	= (1ULL << __FIO_OPT_G_IOURING),
 	FIO_OPT_G_FILESTAT	= (1ULL << __FIO_OPT_G_FILESTAT),
 	FIO_OPT_G_LIBCUFILE	= (1ULL << __FIO_OPT_G_LIBCUFILE),
+	FIO_OPT_G_DFS		= (1ULL << __FIO_OPT_G_DFS),
 };
 
 extern const struct opt_group *opt_group_from_mask(uint64_t *mask);
diff --git a/options.c b/options.c
index 0791101e..151e7a7e 100644
--- a/options.c
+++ b/options.c
@@ -2011,6 +2011,11 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			  { .ival = "nbd",
 			    .help = "Network Block Device (NBD) IO engine"
 			  },
+#ifdef CONFIG_DFS
+			  { .ival = "dfs",
+			    .help = "DAOS File System (dfs) IO engine",
+			  },
+#endif
 		},
 	},
 	{
@@ -5456,6 +5461,19 @@ void fio_options_free(struct thread_data *td)
 	}
 }
 
+void fio_dump_options_free(struct thread_data *td)
+{
+	while (!flist_empty(&td->opt_list)) {
+		struct print_option *p;
+
+		p = flist_first_entry(&td->opt_list, struct print_option, list);
+		flist_del_init(&p->list);
+		free(p->name);
+		free(p->value);
+		free(p);
+	}
+}
+
 struct fio_option *fio_option_find(const char *name)
 {
 	return find_option(fio_options, name);
diff --git a/options.h b/options.h
index 5276f31e..df80fd98 100644
--- a/options.h
+++ b/options.h
@@ -16,6 +16,7 @@ void add_opt_posval(const char *, const char *, const char *);
 void del_opt_posval(const char *, const char *);
 struct thread_data;
 void fio_options_free(struct thread_data *);
+void fio_dump_options_free(struct thread_data *);
 char *get_next_str(char **ptr);
 int get_max_str_idx(char *input);
 char* get_name_by_idx(char *input, int index);
diff --git a/server.c b/server.c
index 1b65297e..8daefbab 100644
--- a/server.c
+++ b/server.c
@@ -1909,7 +1909,7 @@ static int fio_append_iolog_gz(struct sk_entry *first, struct io_log *log)
 			break;
 		}
 		flist_add_tail(&entry->list, &first->next);
-	} while (ret != Z_STREAM_END);
+	}
 
 	ret = deflateEnd(&stream);
 	if (ret == Z_OK)

