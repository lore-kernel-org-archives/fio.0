Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33244 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405217AbfIYMAP (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 25 Sep 2019 08:00:15 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iD5xu-0006OJ-MY
        for fio@vger.kernel.org; Wed, 25 Sep 2019 12:00:14 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190925120001.5D13F2C02E8@kernel.dk>
Date: Wed, 25 Sep 2019 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 3982ec03ab0c125d01b62876f5139b2c07082c7a:

  verify: check that the block size is big enough (2019-09-24 02:43:39 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 3c029ac46c3478243932f76cadf04ca10b64ab3e:

  filesetup: Extend file size for 'null' and 'filecreate' ioengines (2019-09-25 03:12:05 -0600)

----------------------------------------------------------------
Shin'ichiro Kawasaki (2):
      Revert "filesetup: honor the offset option"
      filesetup: Extend file size for 'null' and 'filecreate' ioengines

 filesetup.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/filesetup.c b/filesetup.c
index b8d1d838..a439b6d6 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1047,7 +1047,7 @@ int setup_files(struct thread_data *td)
 			 * doesn't divide nicely with the min blocksize,
 			 * make the first files bigger.
 			 */
-			f->io_size = fs - f->file_offset;
+			f->io_size = fs;
 			if (nr_fs_extra) {
 				nr_fs_extra--;
 				f->io_size += bs;
@@ -1104,13 +1104,15 @@ int setup_files(struct thread_data *td)
 		}
 
 		if (f->filetype == FIO_TYPE_FILE &&
-		    (f->io_size + f->file_offset) > f->real_file_size &&
-		    !td_ioengine_flagged(td, FIO_DISKLESSIO)) {
-			if (!o->create_on_open) {
+		    (f->io_size + f->file_offset) > f->real_file_size) {
+			if (!td_ioengine_flagged(td, FIO_DISKLESSIO) &&
+			    !o->create_on_open) {
 				need_extend++;
 				extend_size += (f->io_size + f->file_offset);
 				fio_file_set_extend(f);
-			} else
+			} else if (!td_ioengine_flagged(td, FIO_DISKLESSIO) ||
+				   (td_ioengine_flagged(td, FIO_DISKLESSIO) &&
+				    td_ioengine_flagged(td, FIO_FAKEIO)))
 				f->real_file_size = f->io_size + f->file_offset;
 		}
 	}

