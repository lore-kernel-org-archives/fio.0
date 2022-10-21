Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF750C43219
	for <fio@archiver.kernel.org>; Fri, 21 Oct 2022 06:34:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbiJUGem (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 21 Oct 2022 02:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbiJUGek (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Oct 2022 02:34:40 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8932F3A2
        for <fio@vger.kernel.org>; Thu, 20 Oct 2022 23:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666334076; x=1697870076;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hBhQeWxDg2ksk5lSUhQNmj/wEraAbhcFUCu0gcmkybM=;
  b=LSjQOobbZUqNuznkfHxF1NTgnmSTdy3nYRyGOc8b0qKG0w7ycUVbxMKV
   K5bo+PQjaLw7+qPdyhRhVCmp6dPpkYDcCw0O861KOCK1gSQHoHKQjFarP
   dpXr6p/jmNo8lvw3kwMYVOC9Gd6yYolSil9NinXQIDjLickGvjRdSQRDP
   0eO5o9pjoAfRMr5h39klnl1lgKV3Dx5P6xtfT9AS/0l6KOmmSWIbaa3iZ
   t1smHHDhh+NEL8/rwlOztaEE3iur9nX6d4n4fBAMwOMlZVBmDoGi4nz3J
   rQ93qt8C8m8JaPYX9miRQdYMdi7vM10TxrXynZRJtMpHMtrJlinbpmOop
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,200,1661788800"; 
   d="scan'208";a="318733121"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Oct 2022 14:34:29 +0800
IronPort-SDR: tQWLaffgBUlAxHs+BBoQKTHqf7fRDV471cS9CazwXzqA4ijViKmWjdr3liwv3j1QLOGRdqP3Fc
 NzQ+O/r0pFoOUkqeUnA9KI5ZwOwFhDK16laUH4Ua4WRUSv8hPKT6dUR38b7InQGO2aNj7cq5YC
 RE1QgaElGSLX6W5hLu0i36L4MchZ0vcdoJOOarlKLMlfZtI7EPFD2kI0V7hHXFnBUk7c+Q1JWu
 1jURQN4IIa2EHY5tq5M5fLOYALqKUfvOOFkPjuN54Uisi8YoOfwwal0UXWjv8G4r4pyTwhmyrx
 AQLhtMFSMasRaMRXn/5X7Ibc
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Oct 2022 22:48:17 -0700
IronPort-SDR: JGT5H02EihDDQFuHbeucp03o96OqAh7LfdNlLmTzxDGaCueg1o9GojwlHslCtSUg0L20WkYsTB
 m3g0E1DREpdi093c/e3wCbRyV7BdoeAwlzpfDJjPtda5O5CZTpAM2zPoXu3svC8ov7VyuZpsGk
 HrtF8XPbKUDNrTgGcbz6uU/NKXu23rrKpoNJ1xqAuPcX4kdGom1eKD+ZLeyrDhJUQcKZVAlt29
 XkYWzWklQjUGLVxjYG35h6r04nP8rXd2yGjJPezaNflUthBD7YWMawKyl4pbo5JOSi9M2Uiuie
 tqU=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 20 Oct 2022 23:34:29 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 09/11] t/zbd: modify test case #34 for block size unaligned to zone size
Date:   Fri, 21 Oct 2022 15:34:14 +0900
Message-Id: <20221021063416.860438-10-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221021063416.860438-1-shinichiro.kawasaki@wdc.com>
References: <20221021063416.860438-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The test case #34 confirmed that the block size unaligned to zone size
is handled as an error. After recent fix, now fio is able to handle such
block sizes, then the check for the error is no longer required.

Instead of removing this unnecessary test case, change it to cover
verify with complex workload. It runs read-write mix workload with high
queue depth with verify and block size unaligned to zone size. This test
is same as test case #57 except the verify option.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index debe3763..e17a81de 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -826,17 +826,23 @@ test33() {
     check_written $((io_size / bs * bs)) || return $?
 }
 
-# Write to sequential zones with a block size that is not a divisor of the
-# zone size and with data verification enabled.
+# Test repeated async write job with verify.
 test34() {
-    local size
+	local bs off
 
-    prep_write
-    size=$((2 * zone_size))
-    run_fio_on_seq "$(ioengine "psync")" --iodepth=1 --rw=write --size=$size \
-		   --do_verify=1 --verify=md5 --bs=$((3 * zone_size / 4)) \
-		   >> "${logfile}.${test_number}" 2>&1 && return 1
-    grep -q 'not a divisor of' "${logfile}.${test_number}"
+	require_zbd || return $SKIP_TESTCASE
+	prep_write
+
+	bs=$((4096 * 7))
+	off=$((first_sequential_zone_sector * 512))
+
+	run_fio --name=job --filename="${dev}" --rw=randwrite --bs="${bs}" \
+		--offset="${off}" --size=$((4 * zone_size)) --iodepth=256 \
+		"$(ioengine "libaio")" --time_based=1 --runtime=30s \
+		--zonemode=zbd --direct=1 --zonesize="${zone_size}" \
+		--verify=crc32c --do_verify=1 \
+		${job_var_opts[@]} \
+		>> "${logfile}.${test_number}" 2>&1 || return $?
 }
 
 # Test 1/4 for the I/O boundary rounding code: $size < $zone_size.
-- 
2.37.1

