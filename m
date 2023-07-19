Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80C42C001E0
	for <fio@archiver.kernel.org>; Wed, 19 Jul 2023 10:58:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjGSK6I (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 19 Jul 2023 06:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbjGSK6G (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 19 Jul 2023 06:58:06 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F40FF18D
        for <fio@vger.kernel.org>; Wed, 19 Jul 2023 03:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1689764285; x=1721300285;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ubMjELsAIahCLVZlcxFW1Ddte/7i8ofio7tf8KQsjpk=;
  b=TncBj2+/4M8iH3wve33zYQ/wVHg0bL8KHpD7f+5EaOiCAH7T3Wv9BSq3
   9NCy0w+9whpvUo64lMQaGoKZOVBeyX6qPyxkm2vx20W27l9PC1xE94usV
   /Sl+AXBMhNS9TIjoGoyuEClBMFMXirmUKvN/ulQw/cW9jOjcCJvXYlgL4
   xTocuyl7UjnKDjWa+tRtqWcezGCLX4xC0FdHCuGU8NkwUPImffbqxUka2
   k6ji12HSBFcNZbOqJNmuQSgYxoJwPfl5g/qNIvvJt/BAzzMlnQRcVFCg2
   Cd2z1E7GT9MZUgIMOZG/Df1w9o4sCX7RFXH3v8wFXXx4uN5JdiBosSldn
   g==;
X-IronPort-AV: E=Sophos;i="6.01,216,1684771200"; 
   d="scan'208";a="236860326"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jul 2023 18:58:04 +0800
IronPort-SDR: 0mqBKkmp6oPEVkOSlH23Y2uUO3OaXDBHHNeq4DE4qRBQNbJil6TTNM3kiJ1ZaDMtaqROaCch43
 /ZWFfzAYXy1iS6s4Uq5mJta8wrrcl9exX9O9PdVzC+4Yd+/Z0Qm3De5PAQ4H08b6ZcAfQiQgw5
 wtXm5VPzjjgx4/3SxvfveQ8Kegj6yU7Dpvw9LvI5ebYA49tsyserD0U63tDHfTZ4iJjkLQNnqz
 4362azPI7HKVfmY4GifiqOuXLjosfb0vD/yOEb672Jd07y06zbuRJGejczsbZhIIkeBtf399R5
 di8=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Jul 2023 03:06:16 -0700
IronPort-SDR: Z4ksba3IpA3VaHNM0CGVezo/VhsaARFZ7tMpv0G1SRcKee/7sIWPiOrrcTtrNOvCM4oCMKXhmj
 KSGnZWSRhCz/Gbqp3eyx+hNq0SvH5p1YMVC3CDBoCVJMjUqNiiwgZM1EbY0VDymVyKPADAIIiK
 k+WGb1kJq6K5PpiVKOObmfyBcF6umaZ/3aO2LS6sbhsJ9K9g4OpirJWxD8IP3SQMy6Xxdb3NRa
 CTK2iWmbcL7Km+rqGPqBjjxyWAEzYbFm27rreIc0x6m9Y1RCpEXKU+ps9En4KIH2ZEK9CDZMdL
 uiQ=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip02.wdc.com with ESMTP; 19 Jul 2023 03:58:04 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 05/13] t/zbd: add close_zone helper function
Date:   Wed, 19 Jul 2023 19:57:48 +0900
Message-Id: <20230719105756.553146-6-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230719105756.553146-1-shinichiro.kawasaki@wdc.com>
References: <20230719105756.553146-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Add a helper function which sets the specified zone in closed condition.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/functions | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/t/zbd/functions b/t/zbd/functions
index 9a6d6999..fe5b3397 100644
--- a/t/zbd/functions
+++ b/t/zbd/functions
@@ -4,6 +4,7 @@ blkzone=$(type -p blkzone 2>/dev/null)
 sg_inq=$(type -p sg_inq 2>/dev/null)
 zbc_report_zones=$(type -p zbc_report_zones 2>/dev/null)
 zbc_reset_zone=$(type -p zbc_reset_zone 2>/dev/null)
+zbc_close_zone=$(type -p zbc_close_zone 2>/dev/null)
 zbc_info=$(type -p zbc_info 2>/dev/null)
 if [ -z "${blkzone}" ] &&
        { [ -z "${zbc_report_zones}" ] || [ -z "${zbc_reset_zone}" ]; }; then
@@ -304,6 +305,18 @@ reset_zone() {
     fi
 }
 
+# Close the zone on device $1 at offset $2. The offset must be specified in
+# units of 512 byte sectors.
+close_zone() {
+	local dev=$1 offset=$2
+
+	if [ -n "${blkzone}" ] && [ -z "${use_libzbc}" ]; then
+		${blkzone} close -o "${offset}" -c 1 "$dev"
+	else
+		${zbc_close_zone} -sector "$dev" "${offset}" >/dev/null
+	fi
+}
+
 # Extract the number of bytes that have been transferred from a line like
 # READ: bw=6847KiB/s (7011kB/s), 6847KiB/s-6847KiB/s (7011kB/s-7011kB/s), io=257MiB (269MB), run=38406-38406msec
 fio_io() {
-- 
2.40.1

