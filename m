Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:38289 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965398AbaCUMAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 21 Mar 2014 08:00:05 -0400
Received: from kernel.dk ([54.225.238.116] helo=strynoevaenget.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WQy7I-0002Q7-8c
	for fio@vger.kernel.org; Fri, 21 Mar 2014 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140321120002.CBC07400A9@strynoevaenget.dk>
Date: Fri, 21 Mar 2014 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit b1bebc321e3b831d424dd49626833dd642224bd4:

  Prevent file_append=1 with IO engine that can't extend files (2014-03-18 13:30:32 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 1417daeb92c44632f2e1e376d736a0f198d7af8d:

  Don't re-create/unlink write file for append workload (2014-03-20 09:33:13 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      Unlink after file close
      Don't re-create/unlink write file for append workload

 filesetup.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

---

Diff of recent changes:

diff --git a/filesetup.c b/filesetup.c
index c3c0fc4..5ce0f68 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -50,10 +50,11 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 	 * does that for operations involving reads, or for writes
 	 * where overwrite is set
 	 */
-	if (td_read(td) || (td_write(td) && td->o.overwrite) ||
+	if (td_read(td) ||
+	   (td_write(td) && td->o.overwrite && !td->o.file_append) ||
 	    (td_write(td) && td->io_ops->flags & FIO_NOEXTEND))
 		new_layout = 1;
-	if (td_write(td) && !td->o.overwrite)
+	if (td_write(td) && !td->o.overwrite && !td->o.file_append)
 		unlink_file = 1;
 
 	if (unlink_file || new_layout) {
@@ -1057,16 +1058,16 @@ void close_and_free_files(struct thread_data *td)
 	dprint(FD_FILE, "close files\n");
 
 	for_each_file(td, f, i) {
-		if (td->o.unlink && f->filetype == FIO_TYPE_FILE) {
-			dprint(FD_FILE, "free unlink %s\n", f->file_name);
-			unlink(f->file_name);
-		}
-
 		if (fio_file_open(f))
 			td_io_close_file(td, f);
 
 		remove_file_hash(f);
 
+		if (td->o.unlink && f->filetype == FIO_TYPE_FILE) {
+			dprint(FD_FILE, "free unlink %s\n", f->file_name);
+			unlink(f->file_name);
+		}
+
 		sfree(f->file_name);
 		f->file_name = NULL;
 		axmap_free(f->io_axmap);
