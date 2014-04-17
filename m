Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:57884 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbaDQMAE (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 17 Apr 2014 08:00:04 -0400
Received: from kernel.dk ([54.225.238.116] helo=rt116.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Wakz6-0007Gk-6W
	for fio@vger.kernel.org; Thu, 17 Apr 2014 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140417120002.EE9504006B@rt116.dk>
Date: Thu, 17 Apr 2014 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 3a35845f7756a8a86b420650bff41267192dce22:

  sg/binject: only restore file flags if they have been set (2014-04-15 09:07:44 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d1faa06dc74fcdcae02e70260c90121502ef01cf:

  Error out if the set blocksize is larger than the file size (2014-04-16 23:51:27 +0200)

----------------------------------------------------------------
Jens Axboe (1):
      Error out if the set blocksize is larger than the file size

 filesetup.c |    5 +++++
 1 file changed, 5 insertions(+)

---

Diff of recent changes:

diff --git a/filesetup.c b/filesetup.c
index 60e7947..79eea9f 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -885,6 +885,11 @@ int setup_files(struct thread_data *td)
 	if (!o->size || o->size > total_size)
 		o->size = total_size;
 
+	if (o->size < td_min_bs(td)) {
+		log_err("fio: blocksize too large for data set\n");
+		goto err_out;
+	}
+
 	/*
 	 * See if we need to extend some files
 	 */
