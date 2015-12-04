Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37427 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbbLDNAD (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 4 Dec 2015 08:00:03 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1a4pxy-0001ct-VN
	for fio@vger.kernel.org; Fri, 04 Dec 2015 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20151204130001.BF0452C00CC@kernel.dk>
Date: Fri,  4 Dec 2015 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit a655bbc42903e27775600dc4d359ed8ac9d0992d:

  configure: add --disable-lex (2015-12-01 09:25:08 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 0b139881150f7179688243c224a07b57eedbdfa0:

  posix_fadvise() returns positive error values (2015-12-03 15:08:08 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      filesetup: properly propagate error value from invalidate
      posix_fadvise() returns positive error values

 filesetup.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

---

Diff of recent changes:

diff --git a/filesetup.c b/filesetup.c
index b5628ce..7666754 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -391,7 +391,7 @@ static int __file_invalidate_cache(struct thread_data *td, struct fio_file *f,
 				   unsigned long long off,
 				   unsigned long long len)
 {
-	int ret = 0;
+	int errval = 0, ret = 0;
 
 #ifdef CONFIG_ESX
 	return 0;
@@ -408,11 +408,15 @@ static int __file_invalidate_cache(struct thread_data *td, struct fio_file *f,
 	dprint(FD_IO, "invalidate cache %s: %llu/%llu\n", f->file_name, off,
 								len);
 
-	if (td->io_ops->invalidate)
+	if (td->io_ops->invalidate) {
 		ret = td->io_ops->invalidate(td, f);
-	else if (f->filetype == FIO_TYPE_FILE)
+		if (ret < 0)
+			errval = ret;
+	} else if (f->filetype == FIO_TYPE_FILE) {
 		ret = posix_fadvise(f->fd, off, len, POSIX_FADV_DONTNEED);
-	else if (f->filetype == FIO_TYPE_BD) {
+		if (ret)
+			errval = ret;
+	} else if (f->filetype == FIO_TYPE_BD) {
 		int retry_count = 0;
 
 		ret = blockdev_invalidate_cache(f);
@@ -434,6 +438,8 @@ static int __file_invalidate_cache(struct thread_data *td, struct fio_file *f,
 			}
 			ret = 0;
 		}
+		if (ret < 0)
+			errval = errno;
 	} else if (f->filetype == FIO_TYPE_CHAR || f->filetype == FIO_TYPE_PIPE)
 		ret = 0;
 
@@ -443,10 +449,8 @@ static int __file_invalidate_cache(struct thread_data *td, struct fio_file *f,
 	 * function to flush eg block device caches. So just warn and
 	 * continue on our way.
 	 */
-	if (ret) {
-		log_info("fio: cache invalidation of %s failed: %s\n", f->file_name, strerror(errno));
-		ret = 0;
-	}
+	if (errval)
+		log_info("fio: cache invalidation of %s failed: %s\n", f->file_name, strerror(errval));
 
 	return 0;
 
