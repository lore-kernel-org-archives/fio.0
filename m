Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:52442 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726921AbfBYNAF (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 25 Feb 2019 08:00:05 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gyFrY-0002My-He
        for fio@vger.kernel.org; Mon, 25 Feb 2019 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190225130002.9D5492C008C@kernel.dk>
Date: Mon, 25 Feb 2019 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit bc596cbcdbb58b81da53a29acf1370d8a7e94429:

  t/zbd: Add multi-job libaio test (2019-02-23 21:19:01 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 66a8a1bf98d714e013ee329dc975f3b6b552de6d:

  engines/sg: kill dead function (2019-02-24 08:13:39 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      engines/sg: kill dead function

 engines/sg.c | 5 -----
 1 file changed, 5 deletions(-)

---

Diff of recent changes:

diff --git a/engines/sg.c b/engines/sg.c
index d681ac93..bf437c8d 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -157,11 +157,6 @@ struct sgio_data {
 #endif
 };
 
-static inline uint16_t sgio_get_be16(uint8_t *buf)
-{
-	return be16_to_cpu(*((uint16_t *) buf));
-}
-
 static inline uint32_t sgio_get_be32(uint8_t *buf)
 {
 	return be32_to_cpu(*((uint32_t *) buf));

