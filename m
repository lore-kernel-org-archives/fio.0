Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36D0DCDB465
	for <fio@archiver.kernel.org>; Sat, 14 Oct 2023 12:00:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233113AbjJNMAU (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 14 Oct 2023 08:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232937AbjJNMAU (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 14 Oct 2023 08:00:20 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B444AD
        for <fio@vger.kernel.org>; Sat, 14 Oct 2023 05:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=c738K6In4UuEXpRm4KxlFN056RufbmnUnh/36wggugQ=; b=VOBiNj0bHsE3BsVgR+37fFXNkq
        2dtzvc2hNe56sOj6mA7oUMWbONFXsT/HiYuUm7BBjF0ySd3WZ2uosI3T+dVlNiEj3xi2nNk3m+eOr
        NqLelnOW42jD2T7rfUdckKN1oBB78MbOEt4CXkPLoLIO5WIW0qHY6ZA2Zn6s1cayrRO89i2XBLVo+
        bxf4cKNaITDlABWRS+Qh05u2e5D5rr+WnLp4UUs4GnuF9WHZLX3e7UcY6P3K2UZd49owu7sKDWVrf
        wzTSnf88BsHnFN6jOgx3xMAm+OMsqdMBdrsILQUKUpfyZOk0Epg66hv1LbPEpqHM2R8uEgPL0r/70
        g5FRQ7jQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qrdJW-00BIJT-Vq
        for fio@vger.kernel.org; Sat, 14 Oct 2023 12:00:15 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id B8E821BC0143; Sat, 14 Oct 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20231014120001.B8E821BC0143@kernel.dk>
Date:   Sat, 14 Oct 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 16b9f29dab1d105951da663474ec243942fda400:

  Merge branch 'fix-stat-overflow' of https://github.com/stilor/fio (2023-10-06 15:27:23 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 50b94305b08a746c21a2c644ffb3cb56915d86ee:

  t/zbd: avoid test case 45 failure (2023-10-13 17:31:47 -0400)

----------------------------------------------------------------
Shin'ichiro Kawasaki (1):
      t/zbd: avoid test case 45 failure

 t/zbd/test-zbd-support | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 0436d319..2f15a191 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1058,15 +1058,20 @@ test44() {
 
 test45() {
     local bs i
+    local grep_str="fio: first I/O failed. If .* is a zoned block device, consider --zonemode=zbd"
 
     require_zbd || return $SKIP_TESTCASE
     prep_write
     bs=$((min_seq_write_size))
-    run_one_fio_job "$(ioengine "psync")" --iodepth=1 --rw=randwrite --bs=$bs\
-		    --offset=$((first_sequential_zone_sector * 512)) \
-		    --size="$zone_size" --do_verify=1 --verify=md5 2>&1 |
-	tee -a "${logfile}.${test_number}" |
-	grep -q "fio: first I/O failed. If .* is a zoned block device, consider --zonemode=zbd"
+    for ((i = 0; i < 10; i++)); do
+	    run_one_fio_job "$(ioengine "psync")" --iodepth=1 --rw=randwrite \
+			    --offset=$((first_sequential_zone_sector * 512)) \
+			    --bs="$bs" --time_based --runtime=1s \
+			    --do_verify=1 --verify=md5 \
+		    >> "${logfile}.${test_number}" 2>&1
+	    grep -qe "$grep_str" "${logfile}.${test_number}" && return 0
+    done
+    return 1
 }
 
 # Random write to sequential zones, libaio, 8 jobs, queue depth 64 per job
