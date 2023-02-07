Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD3D1C636CC
	for <fio@archiver.kernel.org>; Tue,  7 Feb 2023 06:37:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbjBGGh6 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 7 Feb 2023 01:37:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbjBGGh6 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 7 Feb 2023 01:37:58 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3EE2916C
        for <fio@vger.kernel.org>; Mon,  6 Feb 2023 22:37:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675751872; x=1707287872;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uVL7QJjzNYLcM8p+27/IaToxVYUBQuNteOSAgFzjloU=;
  b=NvW7tr+9xZ+5IJLUT9o5Pl9GyotrDbwWx3FteZJlRQnu1bsM1YB9izkq
   hYcSX4tzf8ikcLT5K77fxcNTAgUjxMJrQIPq0XQgYL4aqtfPpqnbLNhF/
   DwcFYNtk8QPLhtvJcoZ8HkG0IVTZsaXcw1GsAlN1PgYjDTbwgDjhW18gl
   4dfTywhQU8u7fntxQh7248n31VN2+4A+xWivJEXGd+/uS3mRD5/ohwfZ5
   OdPotMuvC6h+BaCmcG99b7fgnl5uELOldwRePoTQa0UvMjIAMQFEv7gaZ
   PEphZs/3ewnxeEW2xgFMcl8TSOU36gyk86PzSqgMwZuAc6Z0ZE0cfRVZr
   A==;
X-IronPort-AV: E=Sophos;i="5.97,278,1669046400"; 
   d="scan'208";a="326982673"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Feb 2023 14:37:52 +0800
IronPort-SDR: UJvDn2qQu7gtFILtKNmFHf/D36mw5bd2IKT9qUIZDHuo65EatXMzHXauB62u/YCS8Trj8iAihF
 +YbK3IZeYyG6C03WV46p9IsLQJCZ/RkCUZsHYw5JB9lNyWty+7GXdrgU8cQnO6l0cZhseXQSke
 yfPyeWbT2C8EcIFhKqa9V1GNb7fjPxB+CqDbb6rpHgz3WdOlFpUKgzxNO9EVhSLE3JpP+Esv8E
 g08pIdsYpgTdiIu3Im5q7XJrWWlUHN93qYdne76MgTWdDRtp4JYVb4GhmeEmPMor1uyUdkTR+/
 jXw=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Feb 2023 21:55:08 -0800
IronPort-SDR: DXY2SnablFM/LVzaRcc+w/AjU/i26vp8xB6JdVtYoRSnEQbfmLK3jhout/e5Hd7dt7ZND6dD9e
 NI3VmJQvHiqPd8tYKRA+7V1e2i+5nKf0pFbED23XNEhPf20qJs6meHcx7+pT+v0dGB/zE6cUSE
 4iZgGAqU9UtIdwKnGZEDKm1nDO/GuyRpGHifnMujRQFiSQySdCj6gaTwf8V2/bSUd54iqPeNY7
 eLmHUdFgWMiljhXega6+3uYa7JLzo3CGSZLLNzCFzhwHdnTno9Osda0v+KXlQfrrRhJOWWipQf
 yNo=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Feb 2023 22:37:51 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 8/8] t/zbd: add test cases for zone_reset_threshold option
Date:   Tue,  7 Feb 2023 15:37:39 +0900
Message-Id: <20230207063739.1661191-9-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230207063739.1661191-1-shinichiro.kawasaki@wdc.com>
References: <20230207063739.1661191-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The zone_reset_threshold option works for multiple jobs only when the
jobs have same write range. Add three test cases to confirm that the
option works for multiple jobs as expected. The first test case checks
that different write ranges are reported as an error. The second test
case checks that multiple write jobs work when they have same write
range. The third test case checks that a read job and a write job work
when they have different IO ranges.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 56 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index c32953c4..893aff3c 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1305,6 +1305,62 @@ test60() {
 	grep -q 'not support experimental verify' "${logfile}.${test_number}"
 }
 
+# Test fio errors out zone_reset_threshold option for multiple jobs with
+# different write ranges.
+test61() {
+	run_fio_on_seq "$(ioengine "psync")" --rw=write --size="$zone_size" \
+		       --numjobs=2 --offset_increment="$zone_size" \
+		       --zone_reset_threshold=0.1 --zone_reset_frequency=1 \
+		       --exitall_on_error=1 \
+		       >> "${logfile}.${test_number}" 2>&1 && return 1
+	grep -q 'different write ranges' "${logfile}.${test_number}"
+}
+
+# Test zone_reset_threshold option works for multiple jobs with same write
+# range.
+test62() {
+	local bs loops=2 size=$((zone_size))
+
+	[ -n "$is_zbd" ] && reset_zone "$dev" -1
+
+	# Two jobs write to single zone twice. Reset zone happens at next write
+	# after half of the zone gets filled. So 2 * 2 * 2 - 1 = 7 times zone
+	# resets are expected.
+	bs=$(min $((256*1024)) $((zone_size / 4)))
+	run_fio_on_seq "$(ioengine "psync")" --rw=write --bs="$bs" \
+		       --size=$size --loops=$loops --numjobs=2 \
+		       --zone_reset_frequency=1 --zone_reset_threshold=.5 \
+		       --group_reporting=1 \
+		       >> "${logfile}.${test_number}" 2>&1 || return $?
+	check_written $((size * loops * 2)) || return $?
+	check_reset_count -eq 7 || return $?
+}
+
+# Test zone_reset_threshold option works for a read job and a write job with
+# different IO range.
+test63() {
+	local bs loops=2 size=$((zone_size)) off1 off2
+
+	[ -n "$is_zbd" ] && reset_zone "$dev" -1
+
+	off1=$((first_sequential_zone_sector * 512))
+	off2=$((off1 + zone_size))
+	bs=$(min $((256*1024)) $((zone_size / 4)))
+
+	# One job writes to single zone twice. Reset zone happens at next write
+	# after half of the zone gets filled. So 2 * 2 - 1 = 3 times zone resets
+	# are expected.
+	run_fio "$(ioengine "psync")" --bs="$bs" --size=$size --loops=$loops \
+		--filename="$dev" --group_reporting=1 \
+		--zonemode=zbd --zonesize="$zone_size" --direct=1 \
+		--zone_reset_frequency=1 --zone_reset_threshold=.5 \
+		--name=r --rw=read --offset=$off1 "${job_var_opts[@]}" \
+		--name=w --rw=write --offset=$off2 "${job_var_opts[@]}" \
+		       >> "${logfile}.${test_number}" 2>&1 || return $?
+	check_written $((size * loops)) || return $?
+	check_reset_count -eq 3 || return $?
+}
+
 SECONDS=0
 tests=()
 dynamic_analyzer=()
-- 
2.38.1

