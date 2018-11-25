Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:45316 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbeKYXvS (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 25 Nov 2018 18:51:18 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gQu1I-0007PL-JH
        for fio@vger.kernel.org; Sun, 25 Nov 2018 13:00:16 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20181125130001.CC6D02C0119@kernel.dk>
Date: Sun, 25 Nov 2018 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 0fcbc00994f49f73fe815b9dc074bd6a15eab522:

  engines/libaio: cleanup new vs old io_setup() system call path (2018-11-21 11:33:22 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 92a1a1d701f8af640859a75cc74f82b7bf9e3a0a:

  options: fix 'unit_base' being of the wrong type (2018-11-24 15:10:39 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      options: fix 'unit_base' being of the wrong type

 options.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/options.c b/options.c
index 98187de..cf087ed 100644
--- a/options.c
+++ b/options.c
@@ -4551,7 +4551,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	{
 		.name	= "unit_base",
 		.lname	= "Unit for quantities of data (Bits or Bytes)",
-		.type	= FIO_OPT_INT,
+		.type	= FIO_OPT_STR,
 		.off1	= offsetof(struct thread_options, unit_base),
 		.prio	= 1,
 		.posval = {

