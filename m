Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:59938 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751245AbeACNAP (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 3 Jan 2018 08:00:15 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.89 #1 (Red Hat Linux))
        id 1eWieT-00043r-VR
        for fio@vger.kernel.org; Wed, 03 Jan 2018 13:00:14 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180103130002.7B91D2C009F@kernel.dk>
Date: Wed,  3 Jan 2018 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit df4bf1178ed773986129da6038961388af926971:

  log: fix bad < 0 check for unsigned (2017-12-29 08:45:22 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c619c0fdb28fbe043d7a7f75bba2ea82b4eca298:

  Merge branch 'percentiles' of https://github.com/sitsofe/fio (2018-01-02 09:05:44 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'percentiles' of https://github.com/sitsofe/fio

Sitsofe Wheeler (2):
      stat: make lat_percentiles=1 use sample count from lat_stat
      init: disable percentiles when latency gathering is disabled

 init.c | 5 +++++
 stat.c | 9 ++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/init.c b/init.c
index f7d79c1..decd3b4 100644
--- a/init.c
+++ b/init.c
@@ -938,6 +938,11 @@ static int fixup_options(struct thread_data *td)
 		ret = 1;
 	}
 
+	if (o->disable_lat)
+		o->lat_percentiles = 0;
+	if (o->disable_clat)
+		o->clat_percentiles = 0;
+
 	/*
 	 * Fix these up to be nsec internally
 	 */
diff --git a/stat.c b/stat.c
index 863aa45..cc171a4 100644
--- a/stat.c
+++ b/stat.c
@@ -460,8 +460,15 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 		display_lat(" lat", min, max, mean, dev, out);
 
 	if (ts->clat_percentiles || ts->lat_percentiles) {
+		uint64_t samples;
+
+		if (ts->clat_percentiles)
+			samples = ts->clat_stat[ddir].samples;
+		else
+			samples = ts->lat_stat[ddir].samples;
+
 		show_clat_percentiles(ts->io_u_plat[ddir],
-					ts->clat_stat[ddir].samples,
+					samples,
 					ts->percentile_list,
 					ts->percentile_precision,
 					ts->clat_percentiles, out);
