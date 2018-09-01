Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:40010 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726827AbeIAQME (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 1 Sep 2018 12:12:04 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fw4ZZ-0001AL-M4
        for fio@vger.kernel.org; Sat, 01 Sep 2018 12:00:13 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180901120001.6A2662C00A1@kernel.dk>
Date: Sat,  1 Sep 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c6cc1cfed2aec5ea348cbe8b8762ba8fd5fad966:

  Merge branch 'configure-help' of https://github.com/hahnjo/fio (2018-08-30 08:22:21 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 7df9ac895f4af7ac4500379d5a5e204be9210fb2:

  client: fix nr_samples (2018-08-31 12:43:59 -0600)

----------------------------------------------------------------
Jeff Furlong (1):
      client: fix nr_samples

 client.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/client.c b/client.c
index a868e3a..31c7c64 100644
--- a/client.c
+++ b/client.c
@@ -1539,7 +1539,7 @@ static struct cmd_iolog_pdu *convert_iolog_gz(struct fio_net_cmd *cmd,
 #ifdef CONFIG_ZLIB
 	struct cmd_iolog_pdu *ret;
 	z_stream stream;
-	uint32_t nr_samples;
+	uint64_t nr_samples;
 	size_t total;
 	char *p;
 

