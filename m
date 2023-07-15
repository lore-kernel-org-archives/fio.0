Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B843EB64DC
	for <fio@archiver.kernel.org>; Sat, 15 Jul 2023 12:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjGOMAK (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 15 Jul 2023 08:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjGOMAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 15 Jul 2023 08:00:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B3C22120
        for <fio@vger.kernel.org>; Sat, 15 Jul 2023 05:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=W62BsQuPA3P9XXwVHdZ4OiH/XwsX/vU7q8pDk3mVDDw=; b=c8gMROMIMkM91K6KM8nm+siX2N
        e3lJdBK3LR7Gwxj/ZJ0OmzFpR4fAOqaD3oZMdaOxaTuX1TWEXcjWNwXlHYUSETTXilFdi2HjciOUv
        hUz3n5XfFQ/VwXbGBU7v1Sk8KkACwnO8JIqMw0kVlXVzaQADMXIBH/YPreRvPSz166tslGnGWPNA2
        Zbuc3w6AAd6uTK8eQRARxR4Pt1nNpV7WQi7vra8xrHcQSJLahumERp0/QG6qIytRqb7JFIgiphb8N
        cdTrWV1p0Gb88QzTer8OeIGbKqMtRlFIz/Qcb62wn6aJhB96XMSF25parcL9HnBdQs1fUJBtM2rXx
        vzoftRcw==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qKdwS-002949-DI
        for fio@vger.kernel.org; Sat, 15 Jul 2023 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 3A7851BC01AA; Sat, 15 Jul 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230715120001.3A7851BC01AA@kernel.dk>
Date:   Sat, 15 Jul 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 270316dd2566346a12cfdf3cbe9996a88307f87d:

  Merge branch 'master' of https://github.com/bvanassche/fio (2023-07-13 15:28:20 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 14adf6e31487aa2bc8e47cd037428036089a3834:

  thinktime: Avoid calculating a negative time left to wait (2023-07-14 14:03:34 -0400)

----------------------------------------------------------------
Michael Kelley (1):
      thinktime: Avoid calculating a negative time left to wait

Vincent Fu (2):
      stat: add new diskutil sectors to json output
      stat: add diskutil aggregated sectors to normal output

 backend.c | 11 ++++++++++-
 stat.c    | 14 +++++++++++---
 2 files changed, 21 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index d67a4a07..b06a11a5 100644
--- a/backend.c
+++ b/backend.c
@@ -897,7 +897,16 @@ static void handle_thinktime(struct thread_data *td, enum fio_ddir ddir,
 	if (left)
 		total = usec_spin(left);
 
-	left = td->o.thinktime - total;
+	/*
+	 * usec_spin() might run for slightly longer than intended in a VM
+	 * where the vCPU could get descheduled or the hypervisor could steal
+	 * CPU time. Ensure "left" doesn't become negative.
+	 */
+	if (total < td->o.thinktime)
+		left = td->o.thinktime - total;
+	else
+		left = 0;
+
 	if (td->o.timeout) {
 		runtime_left = td->o.timeout - utime_since_now(&td->epoch);
 		if (runtime_left < (unsigned long long)left)
diff --git a/stat.c b/stat.c
index ced73645..7fad73d1 100644
--- a/stat.c
+++ b/stat.c
@@ -957,11 +957,13 @@ static void show_agg_stats(struct disk_util_agg *agg, int terse,
 		return;
 
 	if (!terse) {
-		log_buf(out, ", aggrios=%llu/%llu, aggrmerge=%llu/%llu, "
-			 "aggrticks=%llu/%llu, aggrin_queue=%llu, "
-			 "aggrutil=%3.2f%%",
+		log_buf(out, ", aggrios=%llu/%llu, aggsectors=%llu/%llu, "
+			 "aggrmerge=%llu/%llu, aggrticks=%llu/%llu, "
+			 "aggrin_queue=%llu, aggrutil=%3.2f%%",
 			(unsigned long long) agg->ios[0] / agg->slavecount,
 			(unsigned long long) agg->ios[1] / agg->slavecount,
+			(unsigned long long) agg->sectors[0] / agg->slavecount,
+			(unsigned long long) agg->sectors[1] / agg->slavecount,
 			(unsigned long long) agg->merges[0] / agg->slavecount,
 			(unsigned long long) agg->merges[1] / agg->slavecount,
 			(unsigned long long) agg->ticks[0] / agg->slavecount,
@@ -1084,6 +1086,8 @@ void json_array_add_disk_util(struct disk_util_stat *dus,
 	json_object_add_value_string(obj, "name", (const char *)dus->name);
 	json_object_add_value_int(obj, "read_ios", dus->s.ios[0]);
 	json_object_add_value_int(obj, "write_ios", dus->s.ios[1]);
+	json_object_add_value_int(obj, "read_sectors", dus->s.sectors[0]);
+	json_object_add_value_int(obj, "write_sectors", dus->s.sectors[1]);
 	json_object_add_value_int(obj, "read_merges", dus->s.merges[0]);
 	json_object_add_value_int(obj, "write_merges", dus->s.merges[1]);
 	json_object_add_value_int(obj, "read_ticks", dus->s.ticks[0]);
@@ -1101,6 +1105,10 @@ void json_array_add_disk_util(struct disk_util_stat *dus,
 				agg->ios[0] / agg->slavecount);
 	json_object_add_value_int(obj, "aggr_write_ios",
 				agg->ios[1] / agg->slavecount);
+	json_object_add_value_int(obj, "aggr_read_sectors",
+				agg->sectors[0] / agg->slavecount);
+	json_object_add_value_int(obj, "aggr_write_sectors",
+				agg->sectors[1] / agg->slavecount);
 	json_object_add_value_int(obj, "aggr_read_merges",
 				agg->merges[0] / agg->slavecount);
 	json_object_add_value_int(obj, "aggr_write_merge",
