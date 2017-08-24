Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:51310 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751270AbdHXMAW (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 24 Aug 2017 08:00:22 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dkqo9-0008PM-4k
        for fio@vger.kernel.org; Thu, 24 Aug 2017 12:00:21 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170824120002.5FB4B2C0094@kernel.dk>
Date: Thu, 24 Aug 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit deeb3c11c212e99e8d1162e03e0ef734bd0d01a7:

  Merge branch 'timespec_add_msec_overflow' of https://github.com/sitsofe/fio (2017-08-22 10:32:18 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b427f2e12beba7b0c9a655f8ecbd19187c0b6029:

  Merge branch 'stat_base_overflow' of https://github.com/football1222/fio (2017-08-23 08:34:37 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'stat_base_overflow' of https://github.com/football1222/fio

Richard Liu (1):
      stat: increase the size of base to avoid overflow

 stat.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/stat.c b/stat.c
index 4aa9cb8..91c74ab 100644
--- a/stat.c
+++ b/stat.c
@@ -100,7 +100,8 @@ static unsigned int plat_val_to_idx(unsigned long long val)
  */
 static unsigned long long plat_idx_to_val(unsigned int idx)
 {
-	unsigned int error_bits, k, base;
+	unsigned int error_bits;
+	unsigned long long k, base;
 
 	assert(idx < FIO_IO_U_PLAT_NR);
 
@@ -111,7 +112,7 @@ static unsigned long long plat_idx_to_val(unsigned int idx)
 
 	/* Find the group and compute the minimum value of that group */
 	error_bits = (idx >> FIO_IO_U_PLAT_BITS) - 1;
-	base = 1 << (error_bits + FIO_IO_U_PLAT_BITS);
+	base = ((unsigned long long) 1) << (error_bits + FIO_IO_U_PLAT_BITS);
 
 	/* Find its bucket number of the group */
 	k = idx % FIO_IO_U_PLAT_VAL;
