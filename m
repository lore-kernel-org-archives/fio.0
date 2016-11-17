Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49050 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932335AbcKQRF7 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 17 Nov 2016 12:05:59 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1c7MIM-0002lW-W9
        for fio@vger.kernel.org; Thu, 17 Nov 2016 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20161117130001.DFAFB2C0063@kernel.dk>
Date: Thu, 17 Nov 2016 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit effe99e4b18eb5c345629d7bbaae1879a2594b20:

  posixaio: fix bad type passed to memset (2016-11-15 10:42:58 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 42f1ee68ceec87fbbfdc4972c35d3cdf7c08d9f6:

  Improve informativeness about directIO support or rather lackthereof on Solaris when errno is set to ENOTTY (2016-11-16 10:16:55 -0800)

----------------------------------------------------------------
Sam Zaydel (1):
      Improve informativeness about directIO support or rather lackthereof on Solaris when errno is set to ENOTTY

 ioengines.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/ioengines.c b/ioengines.c
index ae55f95..4c53fe5 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -483,7 +483,12 @@ int td_io_open_file(struct thread_data *td, struct fio_file *f)
 
 		if (ret) {
 			td_verror(td, ret, "fio_set_odirect");
-			log_err("fio: the file system does not seem to support direct IO\n");
+			if (ret == ENOTTY) { /* ENOTTY suggests RAW device or ZFS */
+				log_err("fio: doing directIO to RAW devices or ZFS not supported\n");
+			} else {
+				log_err("fio: the file system does not seem to support direct IO\n");
+			}
+
 			goto err;
 		}
 	}
