Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:34718 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751214AbdBYNAN (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 25 Feb 2017 08:00:13 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1chbxL-00088o-Hb
        for fio@vger.kernel.org; Sat, 25 Feb 2017 13:00:11 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170225130001.81A542C0086@kernel.dk>
Date: Sat, 25 Feb 2017 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c9057434a99a85f643ce433c7fec9b8f7fad9761:

  Fio 2.18 (2017-02-23 08:44:32 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 4ed22fe532123f81e618269e9a77b7b41e0e9cad:

  fio: fix overflow trying to use 'd' suffix (2017-02-24 01:45:07 +0000)

----------------------------------------------------------------
Sitsofe Wheeler (1):
      fio: fix overflow trying to use 'd' suffix

 parse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/parse.c b/parse.c
index fc508b6..fd5605f 100644
--- a/parse.c
+++ b/parse.c
@@ -167,7 +167,7 @@ static unsigned long long get_mult_time(const char *str, int len,
 	else if (!strcmp("h", c))
 		mult = 60 * 60 * 1000000UL;
 	else if (!strcmp("d", c))
-		mult = 24 * 60 * 60 * 1000000UL;
+		mult = 24 * 60 * 60 * 1000000ULL;
 
 	free(c);
 	return mult;
