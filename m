Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A374E95A60
	for <fio@archiver.kernel.org>; Sat,  7 Oct 2023 12:00:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343869AbjJGMAQ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 7 Oct 2023 08:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343680AbjJGMAQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 7 Oct 2023 08:00:16 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14764B6
        for <fio@vger.kernel.org>; Sat,  7 Oct 2023 05:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=HX3Y2IHUlbSyXgTCJ9VFYpT/AmfL9bKc1VzuEhoT2BI=; b=aa2rQq4d84fb+racMgt1Pp+taV
        Gi02vjj6OWsQCGIdrjEP7ZSCMC01PFX4UkNOdCzMXPXSxhyb/93qgjoyq928N/FhH2D4NzKxV9hfO
        mb2oD0zksQ3XoXCsYDUhjFEepwjSkYZk7aQEP698qQFtEOwofV1xSyOb22rq2EDBqmXC/iJ8E5/fj
        F2Ur3zUEOLqfpuNHVHbzMRBPmg2x6unidPalDAIEKQvDjXKSx00zR5+NSDQfPGbC9d0jj1/sgScyF
        SwPLzOTHv1V6LjTMp1EIn1LH+m9Dm5UyXRrgFHR0eRoca1kas1qUQyqh6stRE4MSQtxxWhfKnXk62
        HpDojWkg==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qp5yd-003Wrz-Bt
        for fio@vger.kernel.org; Sat, 07 Oct 2023 12:00:11 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id A27221BC0165; Sat,  7 Oct 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20231007120001.A27221BC0165@kernel.dk>
Date:   Sat,  7 Oct 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 6f9cdcfcc7598c7d7b19c4a5120a251a80dab183:

  iolog: don't truncate time values (2023-10-02 14:29:29 +0000)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 16b9f29dab1d105951da663474ec243942fda400:

  Merge branch 'fix-stat-overflow' of https://github.com/stilor/fio (2023-10-06 15:27:23 -0400)

----------------------------------------------------------------
Alexey Neyman (2):
      Change memcpy() calls to assignments
      Handle 32-bit overflows in disk utilization stats

Vincent Fu (1):
      Merge branch 'fix-stat-overflow' of https://github.com/stilor/fio

 diskutil.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

---

Diff of recent changes:

diff --git a/diskutil.c b/diskutil.c
index cf4ede85..69b3dd26 100644
--- a/diskutil.c
+++ b/diskutil.c
@@ -77,6 +77,23 @@ static int get_io_ticks(struct disk_util *du, struct disk_util_stat *dus)
 	return ret != 10;
 }
 
+static uint64_t safe_32bit_diff(uint64_t nval, uint64_t oval)
+{
+	/* Linux kernel prints some of the stat fields as 32-bit integers. It is
+	 * possible that the value overflows, but since fio uses unsigned 64-bit
+	 * arithmetic in update_io_tick_disk(), it instead results in a huge
+	 * bogus value being added to the respective accumulating field. Just
+	 * in case Linux starts reporting these metrics as 64-bit values in the
+	 * future, check that overflow actually happens around the 32-bit
+	 * unsigned boundary; assume overflow only happens once between
+	 * successive polls.
+	 */
+	if (oval <= nval || oval >= (1ull << 32))
+		return nval - oval;
+	else
+		return (1ull << 32) + nval - oval;
+}
+
 static void update_io_tick_disk(struct disk_util *du)
 {
 	struct disk_util_stat __dus, *dus, *ldus;
@@ -96,15 +113,16 @@ static void update_io_tick_disk(struct disk_util *du)
 	dus->s.ios[1] += (__dus.s.ios[1] - ldus->s.ios[1]);
 	dus->s.merges[0] += (__dus.s.merges[0] - ldus->s.merges[0]);
 	dus->s.merges[1] += (__dus.s.merges[1] - ldus->s.merges[1]);
-	dus->s.ticks[0] += (__dus.s.ticks[0] - ldus->s.ticks[0]);
-	dus->s.ticks[1] += (__dus.s.ticks[1] - ldus->s.ticks[1]);
-	dus->s.io_ticks += (__dus.s.io_ticks - ldus->s.io_ticks);
-	dus->s.time_in_queue += (__dus.s.time_in_queue - ldus->s.time_in_queue);
+	dus->s.ticks[0] += safe_32bit_diff(__dus.s.ticks[0], ldus->s.ticks[0]);
+	dus->s.ticks[1] += safe_32bit_diff(__dus.s.ticks[1], ldus->s.ticks[1]);
+	dus->s.io_ticks += safe_32bit_diff(__dus.s.io_ticks, ldus->s.io_ticks);
+	dus->s.time_in_queue +=
+			safe_32bit_diff(__dus.s.time_in_queue, ldus->s.time_in_queue);
 
 	fio_gettime(&t, NULL);
 	dus->s.msec += mtime_since(&du->time, &t);
-	memcpy(&du->time, &t, sizeof(t));
-	memcpy(&ldus->s, &__dus.s, sizeof(__dus.s));
+	du->time = t;
+	ldus->s = __dus.s;
 }
 
 int update_io_ticks(void)
