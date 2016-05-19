Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:39067 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbcESMAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 19 May 2016 08:00:05 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1b3McW-0004xk-38
	for fio@vger.kernel.org; Thu, 19 May 2016 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160519120001.BFAFE2C00D0@kernel.dk>
Date: Thu, 19 May 2016 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 8c4693e2e578613f517dc42b38e204bf77fdab1d:

  add -A option for better stats (2016-05-17 18:48:30 -0400)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e391c70489d9f63612bce419d7fa0df5d15abf16:

  filesetup: align a size given as a percentage to the block size (2016-05-18 15:06:05 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      filesetup: align a size given as a percentage to the block size

 filesetup.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/filesetup.c b/filesetup.c
index 9c37ae5..f721c36 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -894,8 +894,10 @@ int setup_files(struct thread_data *td)
 		if (f->io_size == -1ULL)
 			total_size = -1ULL;
 		else {
-                        if (o->size_percent)
-                                f->io_size = (f->io_size * o->size_percent) / 100;
+                        if (o->size_percent) {
+				f->io_size = (f->io_size * o->size_percent) / 100;
+				f->io_size -= (f->io_size % td_min_bs(td));
+			}
 			total_size += f->io_size;
 		}
 
