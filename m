Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:43672 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751005AbeFVMAQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 22 Jun 2018 08:00:16 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fWKjf-0006wj-56
        for fio@vger.kernel.org; Fri, 22 Jun 2018 12:00:15 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180622120001.D4B2B2C013D@kernel.dk>
Date: Fri, 22 Jun 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 5de1d4ba1e6ae82bb4ad559463801cb6b7096ac3:

  Merge branch 'readonly-trim' of https://github.com/vincentkfu/fio (2018-06-18 13:58:26 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 9caaf02b06deecf0b0a13c16b6d59dddc64b8c35:

  Merge branch 'doc-norandommap' of https://github.com/larrystevenwise/fio (2018-06-21 11:22:41 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      Merge branch 'wip-single-glfs-instance' of https://github.com/zhanghuan/fio
      Merge branch 'doc-norandommap' of https://github.com/larrystevenwise/fio

Steve Wise (1):
      doc: add text about possibly verify errors with norandommap

Zhang Huan (1):
      glusterfs: capable to test with one single glfs instance

 HOWTO               |   9 ++-
 engines/gfapi.h     |   1 +
 engines/glusterfs.c | 179 +++++++++++++++++++++++++++++++++++++++++++---------
 fio.1               |   9 ++-
 4 files changed, 167 insertions(+), 31 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index e1399b4..70eed28 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1329,7 +1329,9 @@ I/O type
 	and that some blocks may be read/written more than once. If this option is
 	used with :option:`verify` and multiple blocksizes (via :option:`bsrange`),
 	only intact blocks are verified, i.e., partially-overwritten blocks are
-	ignored.
+	ignored.  With an async I/O engine and an I/O depth > 1, it is possible for
+	the same block to be overwritten, which can cause verification errors.  Either
+	do not use norandommap in this case, or also use the lfsr random generator.
 
 .. option:: softrandommap=bool
 
@@ -2663,6 +2665,11 @@ Verification
 	previously written file. If the data direction includes any form of write,
 	the verify will be of the newly written data.
 
+	To avoid false verification errors, do not use the norandommap option when
+	verifying data with async I/O engines and I/O depths > 1.  Or use the
+	norandommap and the lfsr random generator together to avoid writing to the
+	same offset with muliple outstanding I/Os.
+
 .. option:: verify_offset=int
 
 	Swap the verification header with data somewhere else in the block before
diff --git a/engines/gfapi.h b/engines/gfapi.h
index 1028431..e4cdbcb 100644
--- a/engines/gfapi.h
+++ b/engines/gfapi.h
@@ -5,6 +5,7 @@ struct gf_options {
 	void *pad;
 	char *gf_vol;
 	char *gf_brick;
+	int gf_single_instance;
 };
 
 struct gf_data {
diff --git a/engines/glusterfs.c b/engines/glusterfs.c
index 981dfa3..d0250b7 100644
--- a/engines/glusterfs.c
+++ b/engines/glusterfs.c
@@ -28,16 +28,159 @@ struct fio_option gfapi_options[] = {
 	 .group = FIO_OPT_G_GFAPI,
 	 },
 	{
+	 .name = "single-instance",
+	 .lname = "Single glusterfs instance",
+	 .type = FIO_OPT_BOOL,
+	 .help = "Only one glusterfs instance",
+	 .off1 = offsetof(struct gf_options, gf_single_instance),
+	 .category = FIO_OPT_C_ENGINE,
+	 .group = FIO_OPT_G_GFAPI,
+	 },
+	{
 	 .name = NULL,
 	 },
 };
 
-int fio_gf_setup(struct thread_data *td)
+struct glfs_info {
+	struct flist_head	list;
+	char			*volume;
+	char			*brick;
+	glfs_t			*fs;
+	int			refcount;
+};
+
+static pthread_mutex_t glfs_lock = PTHREAD_MUTEX_INITIALIZER;
+static FLIST_HEAD(glfs_list_head);
+
+static glfs_t *fio_gf_new_fs(char *volume, char *brick)
 {
 	int r = 0;
+	glfs_t *fs;
+	struct stat sb = { 0, };
+
+	fs = glfs_new(volume);
+	if (!fs) {
+		log_err("glfs_new failed.\n");
+		goto out;
+	}
+	glfs_set_logging(fs, "/tmp/fio_gfapi.log", 7);
+	/* default to tcp */
+	r = glfs_set_volfile_server(fs, "tcp", brick, 0);
+	if (r) {
+		log_err("glfs_set_volfile_server failed.\n");
+		goto out;
+	}
+	r = glfs_init(fs);
+	if (r) {
+		log_err("glfs_init failed. Is glusterd running on brick?\n");
+		goto out;
+	}
+	sleep(2);
+	r = glfs_lstat(fs, ".", &sb);
+	if (r) {
+		log_err("glfs_lstat failed.\n");
+		goto out;
+	}
+
+out:
+	if (r) {
+		glfs_fini(fs);
+		fs = NULL;
+	}
+	return fs;
+}
+
+static glfs_t *fio_gf_get_glfs(struct gf_options *opt,
+			       char *volume, char *brick)
+{
+	struct glfs_info *glfs = NULL;
+	struct glfs_info *tmp;
+	struct flist_head *entry;
+
+	if (!opt->gf_single_instance)
+		return fio_gf_new_fs(volume, brick);
+
+	pthread_mutex_lock (&glfs_lock);
+
+	flist_for_each(entry, &glfs_list_head) {
+		tmp = flist_entry(entry, struct glfs_info, list);
+		if (!strcmp(volume, tmp->volume) &&
+		    !strcmp(brick, tmp->brick)) {
+			glfs = tmp;
+			break;
+		}
+	}
+
+	if (glfs) {
+		glfs->refcount++;
+	} else {
+		glfs = malloc(sizeof(*glfs));
+		if (!glfs)
+			goto out;
+		INIT_FLIST_HEAD(&glfs->list);
+		glfs->refcount = 0;
+		glfs->volume = strdup(volume);
+		glfs->brick = strdup(brick);
+		glfs->fs = fio_gf_new_fs(volume, brick);
+		if (!glfs->fs) {
+			free(glfs);
+			glfs = NULL;
+			goto out;
+		}
+
+		flist_add_tail(&glfs->list, &glfs_list_head);
+		glfs->refcount = 1;
+	}
+
+out:
+	pthread_mutex_unlock (&glfs_lock);
+
+	if (glfs)
+		return glfs->fs;
+	return NULL;
+}
+
+static void fio_gf_put_glfs(struct gf_options *opt, glfs_t *fs)
+{
+	struct glfs_info *glfs = NULL;
+	struct glfs_info *tmp;
+	struct flist_head *entry;
+
+	if (!opt->gf_single_instance) {
+		glfs_fini(fs);
+		return;
+	}
+
+	pthread_mutex_lock (&glfs_lock);
+
+	flist_for_each(entry, &glfs_list_head) {
+		tmp = flist_entry(entry, struct glfs_info, list);
+		if (tmp->fs == fs) {
+			glfs = tmp;
+			break;
+		}
+	}
+
+	if (!glfs) {
+		log_err("glfs not found to fini.\n");
+	} else {
+		glfs->refcount--;
+
+		if (glfs->refcount == 0) {
+			glfs_fini(glfs->fs);
+			free(glfs->volume);
+			free(glfs->brick);
+			flist_del(&glfs->list);
+		}
+	}
+
+	pthread_mutex_unlock (&glfs_lock);
+}
+
+int fio_gf_setup(struct thread_data *td)
+{
 	struct gf_data *g = NULL;
 	struct gf_options *opt = td->eo;
-	struct stat sb = { 0, };
 
 	dprint(FD_IO, "fio setup\n");
 
@@ -49,42 +192,20 @@ int fio_gf_setup(struct thread_data *td)
 		log_err("malloc failed.\n");
 		return -ENOMEM;
 	}
-	g->fs = NULL;
 	g->fd = NULL;
 	g->aio_events = NULL;
 
-	g->fs = glfs_new(opt->gf_vol);
-	if (!g->fs) {
-		log_err("glfs_new failed.\n");
-		goto cleanup;
-	}
-	glfs_set_logging(g->fs, "/tmp/fio_gfapi.log", 7);
-	/* default to tcp */
-	r = glfs_set_volfile_server(g->fs, "tcp", opt->gf_brick, 0);
-	if (r) {
-		log_err("glfs_set_volfile_server failed.\n");
+	g->fs = fio_gf_get_glfs(opt, opt->gf_vol, opt->gf_brick);
+	if (!g->fs)
 		goto cleanup;
-	}
-	r = glfs_init(g->fs);
-	if (r) {
-		log_err("glfs_init failed. Is glusterd running on brick?\n");
-		goto cleanup;
-	}
-	sleep(2);
-	r = glfs_lstat(g->fs, ".", &sb);
-	if (r) {
-		log_err("glfs_lstat failed.\n");
-		goto cleanup;
-	}
+
 	dprint(FD_FILE, "fio setup %p\n", g->fs);
 	td->io_ops_data = g;
 	return 0;
 cleanup:
-	if (g->fs)
-		glfs_fini(g->fs);
 	free(g);
 	td->io_ops_data = NULL;
-	return r;
+	return -EIO;
 }
 
 void fio_gf_cleanup(struct thread_data *td)
@@ -97,7 +218,7 @@ void fio_gf_cleanup(struct thread_data *td)
 		if (g->fd)
 			glfs_close(g->fd);
 		if (g->fs)
-			glfs_fini(g->fs);
+			fio_gf_put_glfs(td->eo, g->fs);
 		free(g);
 		td->io_ops_data = NULL;
 	}
diff --git a/fio.1 b/fio.1
index c744d1a..6d2eba6 100644
--- a/fio.1
+++ b/fio.1
@@ -1120,7 +1120,9 @@ at past I/O history. This means that some blocks may not be read or written,
 and that some blocks may be read/written more than once. If this option is
 used with \fBverify\fR and multiple blocksizes (via \fBbsrange\fR),
 only intact blocks are verified, i.e., partially\-overwritten blocks are
-ignored.
+ignored.  With an async I/O engine and an I/O depth > 1, it is possible for
+the same block to be overwritten, which can cause verification errors.  Either
+do not use norandommap in this case, or also use the lfsr random generator.
 .TP
 .BI softrandommap \fR=\fPbool
 See \fBnorandommap\fR. If fio runs with the random block map enabled and
@@ -2370,6 +2372,11 @@ that the written data is also correctly read back. If the data direction
 given is a read or random read, fio will assume that it should verify a
 previously written file. If the data direction includes any form of write,
 the verify will be of the newly written data.
+.P
+To avoid false verification errors, do not use the norandommap option when
+verifying data with async I/O engines and I/O depths > 1.  Or use the
+norandommap and the lfsr random generator together to avoid writing to the
+same offset with muliple outstanding I/Os.
 .RE
 .TP
 .BI verify_offset \fR=\fPint
