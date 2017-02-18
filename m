Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:52404 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751162AbdBRNAG (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 18 Feb 2017 08:00:06 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cf4cP-0007zd-LR
        for fio@vger.kernel.org; Sat, 18 Feb 2017 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170218130001.D2C2F2C0218@kernel.dk>
Date: Sat, 18 Feb 2017 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit b3e7e59290577696dc76c08651cce1e121cff64a:

  Merge branch 'travis_osx' of https://github.com/sitsofe/fio (2017-02-16 09:00:08 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a0cb220bbb28c68fab0b175d01dcfce38a6f835c:

  Revert "Always set ->real_file_size to -1 when failed to get file size" (2017-02-17 13:30:43 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Revert "Always set ->real_file_size to -1 when failed to get file size"

 filesetup.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/filesetup.c b/filesetup.c
index e9976eb..e2585ee 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -375,12 +375,10 @@ static int get_file_size(struct thread_data *td, struct fio_file *f)
 	else if (f->filetype == FIO_TYPE_CHAR)
 		ret = char_size(td, f);
 	else
-		f->real_file_size = -1ULL;
+		f->real_file_size = -1;
 
-	if (ret) {
-		f->real_file_size = -1ULL;
+	if (ret)
 		return ret;
-	}
 
 	if (f->file_offset > f->real_file_size) {
 		log_err("%s: offset extends end (%llu > %llu)\n", td->o.name,
