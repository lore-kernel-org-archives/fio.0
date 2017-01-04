Return-Path: <fio-owner@vger.kernel.org>
Received: from g4t3425.houston.hpe.com ([15.241.140.78]:47676 "EHLO
        g4t3425.houston.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752358AbdADGvZ (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 4 Jan 2017 01:51:25 -0500
Received: from g9t2301.houston.hpecorp.net (g9t2301.houston.hpecorp.net [16.220.97.129])
        by g4t3425.houston.hpe.com (Postfix) with ESMTP id ACDA960
        for <fio@vger.kernel.org>; Wed,  4 Jan 2017 06:51:24 +0000 (UTC)
From: Robert Elliott <elliott@hpe.com>
Subject: [PATCH 3/4] pmemblk,dev-dax: clean up error logs
Date: Wed,  4 Jan 2017 00:54:52 -0600
Message-Id: <20170104065453.15106-4-elliott@hpe.com>
In-Reply-To: <20170104065453.15106-1-elliott@hpe.com>
References: <20170104065453.15106-1-elliott@hpe.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Robert Elliott <elliott@hpe.com>

Print the errno string rather than the number, and prefix
all log_err prints with pmemblk or dev-dax rather than fio.
---
 engines/dev-dax.c | 22 +++++++++++-----------
 engines/pmemblk.c |  9 ++++-----
 2 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/engines/dev-dax.c b/engines/dev-dax.c
index 45aca4e..235a31e 100644
--- a/engines/dev-dax.c
+++ b/engines/dev-dax.c
@@ -106,7 +106,7 @@ static int fio_devdax_prep_limited(struct thread_data *td, struct io_u *io_u)
 	struct fio_devdax_data *fdd = FILE_ENG_DATA(f);
 
 	if (io_u->buflen > f->real_file_size) {
-		log_err("fio: bs too big for dev-dax engine\n");
+		log_err("dev-dax: bs too big for dev-dax engine\n");
 		return EIO;
 	}
 
@@ -213,8 +213,8 @@ static int fio_devdax_init(struct thread_data *td)
 
 	if ((o->rw_min_bs & page_mask) &&
 	    (o->fsync_blocks || o->fdatasync_blocks)) {
-		log_err("fio: mmap options dictate a minimum block size of "
-			"%llu bytes\n", (unsigned long long) page_size);
+		log_err("dev-dax: mmap options dictate a minimum block size of %llu bytes\n",
+			(unsigned long long) page_size);
 		return 1;
 	}
 
@@ -272,8 +272,8 @@ fio_devdax_get_file_size(struct thread_data *td, struct fio_file *f)
 
 	rc = stat(f->file_name, &st);
 	if (rc < 0) {
-		log_err("%s: failed to stat file %s: %d\n",
-			td->o.name, f->file_name, errno);
+		log_err("%s: failed to stat file %s (%s)\n",
+			td->o.name, f->file_name, strerror(errno));
 		return -errno;
 	}
 
@@ -282,8 +282,8 @@ fio_devdax_get_file_size(struct thread_data *td, struct fio_file *f)
 
 	rpath = realpath(spath, npath);
 	if (!rpath) {
-		log_err("%s: realpath on %s failed: %d\n",
-			td->o.name, spath, errno);
+		log_err("%s: realpath on %s failed (%s)\n",
+			td->o.name, spath, strerror(errno));
 		return -errno;
 	}
 
@@ -298,15 +298,15 @@ fio_devdax_get_file_size(struct thread_data *td, struct fio_file *f)
 
 	sfile = fopen(spath, "r");
 	if (!sfile) {
-		log_err("%s: fopen on %s failed: %d\n",
-			td->o.name, spath, errno);
+		log_err("%s: fopen on %s failed (%s)\n",
+			td->o.name, spath, strerror(errno));
 		return 1;
 	}
 
 	rc = fscanf(sfile, "%lu", &size);
 	if (rc < 0) {
-		log_err("%s: fscanf on %s failed: %d\n",
-			td->o.name, spath, errno);
+		log_err("%s: fscanf on %s failed (%s)\n",
+			td->o.name, spath, strerror(errno));
 		return 1;
 	}
 
diff --git a/engines/pmemblk.c b/engines/pmemblk.c
index 7b1affa..7c609cf 100644
--- a/engines/pmemblk.c
+++ b/engines/pmemblk.c
@@ -203,9 +203,8 @@ static fio_pmemblk_file_t pmb_open(const char *pathspec, int flags)
 			    pmemblk_create(path, bsize, fsize, 0644);
 		}
 		if (!pmb->pmb_pool) {
-			log_err
-			    ("fio: enable to open pmemblk pool file (errno %d)\n",
-			     errno);
+			log_err("pmemblk: unable to open pmemblk pool file %s (%s)\n",
+			     path, strerror(errno));
 			goto error;
 		}
 
@@ -267,14 +266,14 @@ static int pmb_get_flags(struct thread_data *td, uint64_t *pflags)
 	if (!td->o.use_thread) {
 		if (!thread_warned) {
 			thread_warned = 1;
-			log_err("fio: must set thread=1 for pmemblk engine\n");
+			log_err("pmemblk: must set thread=1 for pmemblk engine\n");
 		}
 		return 1;
 	}
 
 	if (!td->o.odirect && !odirect_warned) {
 		odirect_warned = 1;
-		log_info("fio: direct == 0, but pmemblk is always direct\n");
+		log_info("pmemblk: direct == 0, but pmemblk is always direct\n");
 	}
 
 	if (td->o.allow_create)
-- 
2.9.3

