Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 377D5C001B0
	for <fio@archiver.kernel.org>; Wed, 19 Jul 2023 10:58:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbjGSK6J (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 19 Jul 2023 06:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbjGSK6H (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 19 Jul 2023 06:58:07 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E4DE42
        for <fio@vger.kernel.org>; Wed, 19 Jul 2023 03:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1689764285; x=1721300285;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tIx9NQ/4OdBEs1id97qGkZs1NtZ04ndtoJvL4hm8uHE=;
  b=p2KJyqbekgZNiImwmpk92EtsAjrRcM7fs5CbBaBIZ+eDTl4LduYiJuwL
   aQrBDsyLfQU6zy8T5uRErXRDZj4u5eMQs6dHSduxWPsiIImQDs9E46l9U
   IF2l8Qt1K7xVOb6JOV2ErklWLmFQJRU3nvu2rNQSw8Fj72aQyN60xBzXD
   TWmhuVv9qO1pUTfMaWK9gyNh3mLeBr1IIS3MVsCj7Q4IwWpOhvnkrO2df
   +7rOlowXW/tXwxQU3obedzqz3HZYI7gzzq0o7wJdVDut9hsaFciiQMeTD
   miqZzH/Bc9HkjjuR47eIPIKo690vKyEf/sQyeD8JresqMlHk11SFljyAg
   g==;
X-IronPort-AV: E=Sophos;i="6.01,216,1684771200"; 
   d="scan'208";a="236860329"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jul 2023 18:58:05 +0800
IronPort-SDR: oEbRDuSMyLVzSqT/L45EWqi3rGDVmoBftRoI21i40s89zebt3KX/680xA8cWVO9+R2AvKNOM2J
 dq5ahPFz7AR+VOWDns2GOSdCFIgX1ygw7jqcSDxd9doCWrAGLmlDOEL4FDie1Prq5NvPmoBkLg
 v1eR74SR6zJwtCwtZWyIfK1mn6oqFv/H9Eduo+c4g32SWLZ9grv0GhE9NH6HHuuMWxagt13qvx
 N/VN+2hrGH9zBNWFBoinxzgarX2Ngycw1SAWLx6Z7m21II5PIniUUKjAjqjsuxOSzxTEoT2Jz5
 ZxM=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Jul 2023 03:06:17 -0700
IronPort-SDR: /gsTnT6P/2yE9xiPJxOHeGQmmtkod9nBaZan+u4gU/M61XOwiaQ8HHCdxcNMtWX7Z92XkyEmgz
 lJV+QSPvcmRGWsILRroz1Dco1CWBVrvBMtmfLPN4xZ7kuBVB/eiDyehA4urkuS4Kn8E+HTINTy
 j4uyHgy+qphBk6AWrZcoCMgrYM/xRlRkn6sxrWNklNIG992mPOFVIU7IQlRqKPEhe/h4cPyPkF
 Uw7GDXXeC8FiA9xUZ/rhQE9vty8T5HllUoZgDyeZDrTkdYVibYmMEsy//1WxC/pOpMA5TDYoSG
 OKE=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip02.wdc.com with ESMTP; 19 Jul 2023 03:58:05 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 06/13] t/zbd: add max_active_zone variable
Date:   Wed, 19 Jul 2023 19:57:49 +0900
Message-Id: <20230719105756.553146-7-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230719105756.553146-1-shinichiro.kawasaki@wdc.com>
References: <20230719105756.553146-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

To test fio behavior on zoned block devices with max_active_zones limit,
add a global variable which holds the limit value. Also add helper
functions to check max_active_zones limit of the test target devices and
max_active_zones requirement of test cases.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/functions        | 12 ++++++++++++
 t/zbd/test-zbd-support | 17 +++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/t/zbd/functions b/t/zbd/functions
index fe5b3397..529e7944 100644
--- a/t/zbd/functions
+++ b/t/zbd/functions
@@ -239,6 +239,18 @@ max_open_zones() {
     fi
 }
 
+# If sysfs provides, get max_active_zones limit of the zoned block device.
+max_active_zones() {
+	local dev=$1
+	local sys_queue="/sys/block/${dev##*/}/queue/"
+
+	if [[ -e "$sys_queue/max_active_zones" ]]; then
+		cat "$sys_queue/max_active_zones"
+		return
+	fi
+	echo 0
+}
+
 # Get minimum block size to write to seq zones. Refer the sysfs attribute
 # zone_write_granularity which shows the valid minimum size regardless of zoned
 # block device type. If the sysfs attribute is not available, refer physical
diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index a3d37a7d..eed3d00d 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -272,6 +272,20 @@ require_max_open_zones() {
 	return 0
 }
 
+require_max_active_zones() {
+	local min=${1}
+
+	if ((max_active_zones == 0)); then
+		SKIP_REASON="$dev does not have max_active_zones limit"
+		return 1
+	fi
+	if ((max_active_zones < min)); then
+		SKIP_REASON="max_active_zones of $dev is smaller than $min"
+		return 1
+	fi
+	return 0
+}
+
 # Check whether buffered writes are refused for block devices.
 test1() {
     require_block_dev || return $SKIP_TESTCASE
@@ -1497,6 +1511,7 @@ if [[ -b "$realdev" ]]; then
 			echo "Failed to determine maximum number of open zones"
 			exit 1
 		fi
+		max_active_zones=$(max_active_zones "$dev")
 		set_io_scheduler "$basename" deadline || exit $?
 		if [ -n "$reset_all_zones" ]; then
 			reset_zone "$dev" -1
@@ -1508,6 +1523,7 @@ if [[ -b "$realdev" ]]; then
 		zone_size=$(max 65536 "$min_seq_write_size")
 		sectors_per_zone=$((zone_size / 512))
 		max_open_zones=128
+		max_active_zones=0
 		set_io_scheduler "$basename" none || exit $?
 		;;
 	esac
@@ -1543,6 +1559,7 @@ elif [[ -c "$realdev" ]]; then
 		echo "Failed to determine maximum number of open zones"
 		exit 1
 	fi
+	max_active_zones=0
 	if [ -n "$reset_all_zones" ]; then
 		reset_zone "$dev" -1
 	fi
-- 
2.40.1

