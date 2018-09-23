Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56742 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbeIWR5Z (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 23 Sep 2018 13:57:25 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g433a-0006YY-Et
        for fio@vger.kernel.org; Sun, 23 Sep 2018 12:00:10 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180923120001.80C182C031B@kernel.dk>
Date: Sun, 23 Sep 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 843c6b5e081900394da002b45253e541b794ac54:

  Merge branch 'steadystate-doc' of https://github.com/vincentkfu/fio (2018-09-21 09:50:07 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 9f2cd5e0ccbce6b65276c1401cdcf2cb8b77b9ff:

  stat: print the right percentile variant for json output (2018-09-22 15:02:04 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      stat: print the right percentile variant for json output

 stat.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/stat.c b/stat.c
index 5fca998..ef9c4af 100644
--- a/stat.c
+++ b/stat.c
@@ -1059,10 +1059,16 @@ static void add_ddir_status_json(struct thread_stat *ts,
 
 	if (ts->clat_percentiles || ts->lat_percentiles) {
 		if (ddir_rw(ddir)) {
+			uint64_t samples;
+
+			if (ts->clat_percentiles)
+				samples = ts->clat_stat[ddir].samples;
+			else
+				samples = ts->lat_stat[ddir].samples;
+
 			len = calc_clat_percentiles(ts->io_u_plat[ddir],
-					ts->clat_stat[ddir].samples,
-					ts->percentile_list, &ovals, &maxv,
-					&minv);
+					samples, ts->percentile_list, &ovals,
+					&maxv, &minv);
 		} else {
 			len = calc_clat_percentiles(ts->io_u_sync_plat,
 					ts->sync_stat.samples,

