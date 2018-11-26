Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:32890 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbeKZXyU (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 26 Nov 2018 18:54:20 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gRGUo-0004Vk-DI
        for fio@vger.kernel.org; Mon, 26 Nov 2018 13:00:14 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20181126130002.9D1962C0119@kernel.dk>
Date: Mon, 26 Nov 2018 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 92a1a1d701f8af640859a75cc74f82b7bf9e3a0a:

  options: fix 'unit_base' being of the wrong type (2018-11-24 15:10:39 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 41dd12d62f43160bc8d8574127d0c2b861e1ee1d:

  options: fix 'kb_base' being of the wrong type (2018-11-25 09:56:06 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      options: fix 'kb_base' being of the wrong type

 options.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/options.c b/options.c
index cf087ed..7a7006c 100644
--- a/options.c
+++ b/options.c
@@ -4530,7 +4530,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	{
 		.name	= "kb_base",
 		.lname	= "KB Base",
-		.type	= FIO_OPT_INT,
+		.type	= FIO_OPT_STR,
 		.off1	= offsetof(struct thread_options, kb_base),
 		.prio	= 1,
 		.def	= "1024",

