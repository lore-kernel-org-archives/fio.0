Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:45990 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388056AbfCVMAL (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 22 Mar 2019 08:00:11 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1h7IqI-0000No-Ue
        for fio@vger.kernel.org; Fri, 22 Mar 2019 12:00:11 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190322120002.58EA42C0117@kernel.dk>
Date: Fri, 22 Mar 2019 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit d9c50de7c1d95e5c173ac6d7f5b3f0d63131f8b4:

  t/io_uring: memset() allocated memory (2019-03-11 10:46:47 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c5daece64fd56763f264a59965a547433d4da799:

  stat: fix accumulation of latency buckets (2019-03-21 10:53:39 -0600)

----------------------------------------------------------------
Vincent Fu (1):
      stat: fix accumulation of latency buckets

 stat.c | 4 ++++
 1 file changed, 4 insertions(+)

---

Diff of recent changes:

diff --git a/stat.c b/stat.c
index 66a13bca..ecef1099 100644
--- a/stat.c
+++ b/stat.c
@@ -1684,7 +1684,11 @@ void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src,
 	}
 	for (k = 0; k < FIO_IO_U_LAT_N_NR; k++) {
 		dst->io_u_lat_n[k] += src->io_u_lat_n[k];
+	}
+	for (k = 0; k < FIO_IO_U_LAT_U_NR; k++) {
 		dst->io_u_lat_u[k] += src->io_u_lat_u[k];
+	}
+	for (k = 0; k < FIO_IO_U_LAT_M_NR; k++) {
 		dst->io_u_lat_m[k] += src->io_u_lat_m[k];
 	}
 	for (k = 0; k < FIO_IO_U_PLAT_NR; k++)

