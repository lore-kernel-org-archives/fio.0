Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:56180 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731004AbfJNMAM (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 14 Oct 2019 08:00:12 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iJz1H-0007sn-At
        for fio@vger.kernel.org; Mon, 14 Oct 2019 12:00:11 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20191014120002.1092E2C02DB@kernel.dk>
Date: Mon, 14 Oct 2019 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 983a656c11bf35043759de48aa5a85bdb4ffb106:

  Merge branch 'bumpflocks' of https://github.com/earlephilhower/fio (2019-10-08 20:58:57 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 9663e751c25d3bf52e959d8c9025460d2f645b1e:

  Merge branch 'fix-corrupt-hist-log' of https://github.com/sitsofe/fio (2019-10-13 11:02:00 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'fix-corrupt-hist-log' of https://github.com/sitsofe/fio

Sitsofe Wheeler (1):
      stat: fix corruption in histogram logs

 stat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/stat.c b/stat.c
index 33637900..05663e07 100644
--- a/stat.c
+++ b/stat.c
@@ -2580,7 +2580,7 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 			io_u_plat = (uint64_t *) td->ts.io_u_plat[ddir];
 			dst = malloc(sizeof(struct io_u_plat_entry));
 			memcpy(&(dst->io_u_plat), io_u_plat,
-				FIO_IO_U_PLAT_NR * sizeof(unsigned int));
+				FIO_IO_U_PLAT_NR * sizeof(uint64_t));
 			flist_add(&dst->list, &hw->list);
 			__add_log_sample(iolog, sample_plat(dst), ddir, bs,
 						elapsed, offset);

