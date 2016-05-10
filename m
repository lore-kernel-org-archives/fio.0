Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46995 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbcEJMAD (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 10 May 2016 08:00:03 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1b06KY-00082S-TT
	for fio@vger.kernel.org; Tue, 10 May 2016 12:00:02 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160510120002.3730E2C00D8@kernel.dk>
Date: Tue, 10 May 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit d5bdff69e877a3f65928278df9d252d8881ff864:

  Makefile: fix path to tools/fiologparser.py (2016-05-06 17:10:33 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to df96a39edc86394bca0643e9aa2a8f4dfc76c7c9:

  Change default IO engine from sync to psync (2016-05-09 13:35:09 -0600)

----------------------------------------------------------------
Jens Axboe (3):
      filesetup: ensure that we align file starting offset
      io_u: if we're doing backwards IO, wrap to end (not start)
      Change default IO engine from sync to psync

 filesetup.c |  8 ++++++--
 io_u.c      | 11 ++++++++---
 os/os.h     |  2 +-
 3 files changed, 15 insertions(+), 6 deletions(-)

---

Diff of recent changes:

diff --git a/filesetup.c b/filesetup.c
index 3fc1464..9c37ae5 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -761,12 +761,16 @@ static unsigned long long get_fs_free_counts(struct thread_data *td)
 uint64_t get_start_offset(struct thread_data *td, struct fio_file *f)
 {
 	struct thread_options *o = &td->o;
+	uint64_t offset;
 
 	if (o->file_append && f->filetype == FIO_TYPE_FILE)
 		return f->real_file_size;
 
-	return td->o.start_offset +
-		td->subjob_number * td->o.offset_increment;
+	offset = td->o.start_offset + td->subjob_number * td->o.offset_increment;
+	if (offset % td_max_bs(td))
+		offset -= (offset % td_max_bs(td));
+
+	return offset;
 }
 
 /*
diff --git a/io_u.c b/io_u.c
index eb15dc2..f9870e7 100644
--- a/io_u.c
+++ b/io_u.c
@@ -371,10 +371,15 @@ static int get_next_seq_offset(struct thread_data *td, struct fio_file *f,
 			/*
 			 * If we reach beyond the end of the file
 			 * with holed IO, wrap around to the
-			 * beginning again.
+			 * beginning again. If we're doing backwards IO,
+			 * wrap to the end.
 			 */
-			if (pos >= f->real_file_size)
-				pos = f->file_offset;
+			if (pos >= f->real_file_size) {
+				if (o->ddir_seq_add > 0)
+					pos = f->file_offset;
+				else
+					pos = f->real_file_size + o->ddir_seq_add;
+			}
 		}
 
 		*offset = pos;
diff --git a/os/os.h b/os/os.h
index 02ab40d..9877383 100644
--- a/os/os.h
+++ b/os/os.h
@@ -151,7 +151,7 @@ extern int fio_cpus_split(os_cpu_mask_t *mask, unsigned int cpu);
 #endif
 
 #ifndef FIO_PREFERRED_ENGINE
-#define FIO_PREFERRED_ENGINE	"sync"
+#define FIO_PREFERRED_ENGINE	"psync"
 #endif
 
 #ifndef FIO_OS_PATH_SEPARATOR
