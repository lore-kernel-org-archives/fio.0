Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:55648 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728738AbfAONAX (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 15 Jan 2019 08:00:23 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gjOKL-0003WI-GH
        for fio@vger.kernel.org; Tue, 15 Jan 2019 13:00:22 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190115130002.12D3F2C0164@kernel.dk>
Date: Tue, 15 Jan 2019 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c21198d9cd52b6239c8f9de2373574a7683a0593:

  t/io_uring: use the right check for when to wait (2019-01-13 22:52:07 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 93d1811ce6a510d36d61381840283d1ae9933b37:

  t/io_uring: pick next file if we're over the limti (2019-01-15 05:57:54 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      t/io_uring: pick next file if we're over the limti

 t/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

---

Diff of recent changes:

diff --git a/t/io_uring.c b/t/io_uring.c
index 7ddeef39..b5f1e094 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -172,6 +172,7 @@ static void init_io(struct submitter *s, unsigned index)
 			s->cur_file++;
 			if (s->cur_file == s->nr_files)
 				s->cur_file = 0;
+			f = &s->files[s->cur_file];
 		}
 	}
 	f->pending_ios++;

