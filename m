Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:59664 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754889AbeAMNA2 (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 13 Jan 2018 08:00:28 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.89 #1 (Red Hat Linux))
        id 1eaLQA-00078W-Ug
        for fio@vger.kernel.org; Sat, 13 Jan 2018 13:00:27 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180113130002.2529E2C0098@kernel.dk>
Date: Sat, 13 Jan 2018 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 9d5fe300085759c0f764a62be27355fe80b5fd8f:

  io/examples/fio-seq-read: use direct=1 (2018-01-10 08:30:07 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 53bb5d9c037e842970b32bc828dbe809b42c144d:

  Merge branch 'diskless_invalidate' of https://github.com/sitsofe/fio (2018-01-12 10:59:08 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      Merge branch 'fio-issue-450' of https://github.com/gvkovai/fio
      Merge branch 'diskless_invalidate' of https://github.com/sitsofe/fio

Robert Elliott (1):
      ioengines: don't call munmap unless size boundary is exceeded

Sitsofe Wheeler (1):
      filesetup: skip fallback invalidation with diskless ioengines

gvkovai (1):
      Fix zoning issue with seq-io and randommap issue

 engines/dev-dax.c |  2 +-
 engines/libpmem.c |  2 +-
 engines/mmap.c    |  2 +-
 filesetup.c       |  4 ++++
 io_u.c            | 56 +++++++++++++++++++++++++++++++++++++++++--------------
 5 files changed, 49 insertions(+), 17 deletions(-)

---

Diff of recent changes:

diff --git a/engines/dev-dax.c b/engines/dev-dax.c
index b1f91a4..caae1e0 100644
--- a/engines/dev-dax.c
+++ b/engines/dev-dax.c
@@ -157,7 +157,7 @@ static int fio_devdax_prep(struct thread_data *td, struct io_u *io_u)
 	 * It fits within existing mapping, use it
 	 */
 	if (io_u->offset >= fdd->devdax_off &&
-	    io_u->offset + io_u->buflen < fdd->devdax_off + fdd->devdax_sz)
+	    io_u->offset + io_u->buflen <= fdd->devdax_off + fdd->devdax_sz)
 		goto done;
 
 	/*
diff --git a/engines/libpmem.c b/engines/libpmem.c
index 3f4e44f..3038784 100644
--- a/engines/libpmem.c
+++ b/engines/libpmem.c
@@ -430,7 +430,7 @@ static int fio_libpmem_prep(struct thread_data *td, struct io_u *io_u)
 			io_u->buflen, fdd->libpmem_sz);
 
 	if (io_u->offset >= fdd->libpmem_off &&
-	    (io_u->offset + io_u->buflen <
+	    (io_u->offset + io_u->buflen <=
 	     fdd->libpmem_off + fdd->libpmem_sz))
 		goto done;
 
diff --git a/engines/mmap.c b/engines/mmap.c
index 51606e1..7755658 100644
--- a/engines/mmap.c
+++ b/engines/mmap.c
@@ -137,7 +137,7 @@ static int fio_mmapio_prep(struct thread_data *td, struct io_u *io_u)
 	 * It fits within existing mapping, use it
 	 */
 	if (io_u->offset >= fmd->mmap_off &&
-	    io_u->offset + io_u->buflen < fmd->mmap_off + fmd->mmap_sz)
+	    io_u->offset + io_u->buflen <= fmd->mmap_off + fmd->mmap_sz)
 		goto done;
 
 	/*
diff --git a/filesetup.c b/filesetup.c
index 30af085..3cda606 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -490,6 +490,10 @@ static int __file_invalidate_cache(struct thread_data *td, struct fio_file *f,
 		ret = td->io_ops->invalidate(td, f);
 		if (ret < 0)
 			errval = -ret;
+	} else if (td_ioengine_flagged(td, FIO_DISKLESSIO)) {
+		dprint(FD_IO, "invalidate not supported by ioengine %s\n",
+		       td->io_ops->name);
+		ret = 0;
 	} else if (f->filetype == FIO_TYPE_FILE) {
 		dprint(FD_IO, "declare unneeded cache %s: %llu/%llu\n",
 			f->file_name, off, len);
diff --git a/io_u.c b/io_u.c
index 852b98e..1d6872e 100644
--- a/io_u.c
+++ b/io_u.c
@@ -922,6 +922,45 @@ void requeue_io_u(struct thread_data *td, struct io_u **io_u)
 	*io_u = NULL;
 }
 
+static void __fill_io_u_zone(struct thread_data *td, struct io_u *io_u)
+{
+	struct fio_file *f = io_u->file;
+
+	/*
+	 * See if it's time to switch to a new zone
+	 */
+	if (td->zone_bytes >= td->o.zone_size && td->o.zone_skip) {
+		td->zone_bytes = 0;
+		f->file_offset += td->o.zone_range + td->o.zone_skip;
+
+		/*
+		 * Wrap from the beginning, if we exceed the file size
+		 */
+		if (f->file_offset >= f->real_file_size)
+			f->file_offset = f->real_file_size - f->file_offset;
+		f->last_pos[io_u->ddir] = f->file_offset;
+		td->io_skip_bytes += td->o.zone_skip;
+	}
+
+	/*
+ 	 * If zone_size > zone_range, then maintain the same zone until
+ 	 * zone_bytes >= zone_size.
+ 	 */
+	if (f->last_pos[io_u->ddir] >= (f->file_offset + td->o.zone_range)) {
+		dprint(FD_IO, "io_u maintain zone offset=%" PRIu64 "/last_pos=%" PRIu64 "\n",
+				f->file_offset, f->last_pos[io_u->ddir]);
+		f->last_pos[io_u->ddir] = f->file_offset;
+	}
+
+	/*
+	 * For random: if 'norandommap' is not set and zone_size > zone_range,
+	 * map needs to be reset as it's done with zone_range everytime.
+	 */
+	if ((td->zone_bytes % td->o.zone_range) == 0) {
+		fio_file_reset(td, f);
+	}
+}
+
 static int fill_io_u(struct thread_data *td, struct io_u *io_u)
 {
 	unsigned int is_random;
@@ -938,21 +977,10 @@ static int fill_io_u(struct thread_data *td, struct io_u *io_u)
 		goto out;
 
 	/*
-	 * See if it's time to switch to a new zone
+	 * When file is zoned zone_range is always positive
 	 */
-	if (td->zone_bytes >= td->o.zone_size && td->o.zone_skip) {
-		struct fio_file *f = io_u->file;
-
-		td->zone_bytes = 0;
-		f->file_offset += td->o.zone_range + td->o.zone_skip;
-
-		/*
-		 * Wrap from the beginning, if we exceed the file size
-		 */
-		if (f->file_offset >= f->real_file_size)
-			f->file_offset = f->real_file_size - f->file_offset;
-		f->last_pos[io_u->ddir] = f->file_offset;
-		td->io_skip_bytes += td->o.zone_skip;
+	if (td->o.zone_range) {
+		__fill_io_u_zone(td, io_u);
 	}
 
 	/*
