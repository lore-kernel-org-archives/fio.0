Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43253 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbbKKNAE (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 11 Nov 2015 08:00:04 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ZwV0N-0002y4-3R
	for fio@vger.kernel.org; Wed, 11 Nov 2015 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20151111130001.A36292C1958@kernel.dk>
Date: Wed, 11 Nov 2015 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 0127c57b82cfef26149c04b1d785897a68a6dffa:

  smalloc: get rid of global lock (2015-11-09 19:38:15 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ced5db250347606cbd966d28cd193cc9f0880dff:

  Fix verification error with bsrange and split read/write phase (2015-11-10 18:13:40 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Fix verification error with bsrange and split read/write phase

 io_u.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/io_u.c b/io_u.c
index 6dda579..6b6b47d 100644
--- a/io_u.c
+++ b/io_u.c
@@ -488,7 +488,7 @@ static unsigned int __get_next_buflen(struct thread_data *td, struct io_u *io_u,
 			}
 		}
 
-		if (td->o.do_verify && td->o.verify != VERIFY_NONE)
+		if (td->o.verify != VERIFY_NONE)
 			buflen = (buflen + td->o.verify_interval - 1) &
 				~(td->o.verify_interval - 1);
 
