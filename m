Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:49900 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728356AbeHVPYw (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 22 Aug 2018 11:24:52 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fsRo6-0007qv-Vt
        for fio@vger.kernel.org; Wed, 22 Aug 2018 12:00:15 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180822120002.6BD902C234E@kernel.dk>
Date: Wed, 22 Aug 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 78439a18225255f7f1b4f9efab950afcd638b606:

  Update HOWTO for read_iolog change (2018-08-20 08:34:13 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to daa899130fdd40f5df720ee54980b00b07903dc4:

  io_u: residiual size should be unsigned long long (2018-08-21 09:16:09 -0600)

----------------------------------------------------------------
Jeff Furlong (1):
      io_u: residiual size should be unsigned long long

 io_u.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/io_u.h b/io_u.h
index 9a423b2..2e0fd3f 100644
--- a/io_u.h
+++ b/io_u.h
@@ -75,7 +75,7 @@ struct io_u {
 
 	struct io_piece *ipo;
 
-	unsigned int resid;
+	unsigned long long resid;
 	unsigned int error;
 
 	/*

