Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45500 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598AbbDAMAO (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 1 Apr 2015 08:00:14 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YdHJb-0003wT-4R
	for fio@vger.kernel.org; Wed, 01 Apr 2015 12:00:11 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150401120003.38E6040161@lyth.info>
Date: Wed,  1 Apr 2015 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 37659335ac616d7c13bf8bfbb76366424b50ea67:

  Add support for POSIX_FADV_STREAMID (2015-03-24 10:20:22 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 16ada7542f32b38c1189390a97b595948079b100:

  sg: don't return success if non bdev/char is used (2015-03-31 13:41:18 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      sg: don't return success if non bdev/char is used

 engines/sg.c |    1 +
 1 file changed, 1 insertion(+)

---

Diff of recent changes:

diff --git a/engines/sg.c b/engines/sg.c
index 6272b79..8acbd50 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -368,6 +368,7 @@ static int fio_sgio_type_check(struct thread_data *td, struct fio_file *f)
 		if (ret)
 			return 1;
 	} else {
+		td_verror(td, EINVAL, "wrong file type");
 		log_err("ioengine sg only works on block devices\n");
 		return 1;
 	}
