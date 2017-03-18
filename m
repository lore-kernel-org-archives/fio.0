Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:54068 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751320AbdCRNpP (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 18 Mar 2017 09:45:15 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cpD1r-0005Ox-O9
        for fio@vger.kernel.org; Sat, 18 Mar 2017 12:00:15 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170318120002.099902C27A6@kernel.dk>
Date: Sat, 18 Mar 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 8243be59aa35aa016fcbeee99353b08376953911:

  Add 'stats' option (2017-03-16 14:43:37 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d9bb03d475e918e08c38bd882032ff788daa297f:

  is_power_of_2() should return bool (2017-03-17 10:39:42 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      io_u: we don't need to set power_2 to false
      is_power_of_2() should return bool

Pan Liu (1):
      fixed the error=invalid argument when the lower bound of bsrange is not power of 2.

 io_u.c     | 7 +++++--
 lib/pow2.h | 3 ++-
 2 files changed, 7 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/io_u.c b/io_u.c
index f6efae0..5f01c1b 100644
--- a/io_u.c
+++ b/io_u.c
@@ -533,6 +533,7 @@ static unsigned int __get_next_buflen(struct thread_data *td, struct io_u *io_u,
 	unsigned int buflen = 0;
 	unsigned int minbs, maxbs;
 	uint64_t frand_max, r;
+	bool power_2;
 
 	assert(ddir_rw(ddir));
 
@@ -577,9 +578,11 @@ static unsigned int __get_next_buflen(struct thread_data *td, struct io_u *io_u,
 			}
 		}
 
-		if (!td->o.bs_unaligned && is_power_of_2(minbs))
+		power_2 = is_power_of_2(minbs);
+		if (!td->o.bs_unaligned && power_2)
 			buflen &= ~(minbs - 1);
-
+		else if (!td->o.bs_unaligned && !power_2) 
+			buflen -= buflen % minbs; 
 	} while (!io_u_fits(td, io_u, buflen));
 
 	return buflen;
diff --git a/lib/pow2.h b/lib/pow2.h
index f3ca4d7..2cbca1a 100644
--- a/lib/pow2.h
+++ b/lib/pow2.h
@@ -2,8 +2,9 @@
 #define FIO_POW2_H
 
 #include <inttypes.h>
+#include "types.h"
 
-static inline int is_power_of_2(uint64_t val)
+static inline bool is_power_of_2(uint64_t val)
 {
 	return (val != 0 && ((val & (val - 1)) == 0));
 }
