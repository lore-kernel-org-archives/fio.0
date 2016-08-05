Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53471 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935030AbcHEMAP (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 5 Aug 2016 08:00:15 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1bVdnS-0000Fj-7k
	for fio@vger.kernel.org; Fri, 05 Aug 2016 12:00:14 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160805120002.33CCF2C00A2@kernel.dk>
Date: Fri,  5 Aug 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit ff56a4e2e0a87e4e3b1cc1e74547d55b295967a6:

  travis: don't enable rbd (2016-08-03 10:18:42 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5fd31680d0370c6b71ccfa456ade211477af81d6:

  Revert "filesetup: ensure that we catch a file flagged for extend" (2016-08-04 19:41:09 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Revert "filesetup: ensure that we catch a file flagged for extend"

 filesetup.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/filesetup.c b/filesetup.c
index f32d874..1ecdda6 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -900,12 +900,11 @@ int setup_files(struct thread_data *td)
 		if (f->filetype == FIO_TYPE_FILE &&
 		    (f->io_size + f->file_offset) > f->real_file_size &&
 		    !(td->io_ops->flags & FIO_DISKLESSIO)) {
-			if (!o->create_on_open)
+			if (!o->create_on_open) {
+				need_extend++;
 				extend_size += (f->io_size + f->file_offset);
-			else
+			} else
 				f->real_file_size = f->io_size + f->file_offset;
-
-			need_extend++;
 			fio_file_set_extend(f);
 		}
 	}
