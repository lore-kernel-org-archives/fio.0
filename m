Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:44850 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753783AbeAGNAR (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 7 Jan 2018 08:00:17 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.89 #1 (Red Hat Linux))
        id 1eYAYj-0004MV-3J
        for fio@vger.kernel.org; Sun, 07 Jan 2018 13:00:17 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180107130002.482742C00C4@kernel.dk>
Date: Sun,  7 Jan 2018 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 57a61cd0e4c5f131cfe75587d8b995191d87ba57:

  verify: don't adjust verification length based on interval when unaligned (2018-01-05 13:38:40 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 702bd977555105292f3d60dee896cd35ff8b11ef:

  stat: don't add duplicate clat entries for json (2018-01-06 14:47:01 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      stat: don't add duplicate clat entries for json

 stat.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/stat.c b/stat.c
index 509bd6d..80f804a 100644
--- a/stat.c
+++ b/stat.c
@@ -1030,16 +1030,14 @@ static void add_ddir_status_json(struct thread_stat *ts,
 					ts->clat_stat[ddir].samples,
 					ts->percentile_list, &ovals, &maxv,
 					&minv);
+		if (len > FIO_IO_U_LIST_MAX_LEN)
+			len = FIO_IO_U_LIST_MAX_LEN;
 	} else
 		len = 0;
 
 	percentile_object = json_create_object();
 	json_object_add_value_object(tmp_object, "percentile", percentile_object);
-	for (i = 0; i < FIO_IO_U_LIST_MAX_LEN; i++) {
-		if (i >= len) {
-			json_object_add_value_int(percentile_object, "0.00", 0);
-			continue;
-		}
+	for (i = 0; i < len; i++) {
 		snprintf(buf, sizeof(buf), "%f", ts->percentile_list[i].u.f);
 		json_object_add_value_int(percentile_object, (const char *)buf, ovals[i]);
 	}
