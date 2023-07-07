Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69EC1C001B0
	for <fio@archiver.kernel.org>; Fri,  7 Jul 2023 03:15:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbjGGDPS (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 6 Jul 2023 23:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbjGGDPQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 6 Jul 2023 23:15:16 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1DF51BFC
        for <fio@vger.kernel.org>; Thu,  6 Jul 2023 20:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1688699714; x=1720235714;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tIx9NQ/4OdBEs1id97qGkZs1NtZ04ndtoJvL4hm8uHE=;
  b=X8UTC5sRjVrYfkY94CBwkDh0eLUIquyFetazgNSUtfjs9F4rxbChwUTy
   4TgZ20wspyIBij69PyLei8NCnoHwlVp+45FoSY9ZE1IInixpHvBFQLeg9
   24eBIBj3CGeeMOq06aAIRK2rxQ17AhNmOA4RHOkN1auwU1WLE7JluEMKd
   3VTazcgqSwkeXPxu3cjXWBc88AqLC7yHolN1eQ7ybxgSUScqUSsf4c7I0
   HakmDCdwpwS4Dmtj61/LhHpxXF+eXH0LWKitZW0hBH+UkSJOTBUV61a3L
   /lq78Ix52vzmD3U0z+M4i4zmF2fpw6l9KfAObJc6D0oY0MrDAanPwuKce
   A==;
X-IronPort-AV: E=Sophos;i="6.01,187,1684771200"; 
   d="scan'208";a="342468803"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jul 2023 11:15:14 +0800
IronPort-SDR: cRlBbdhGfMNHThNxBEFPZQmRHmj3OHJ8YGYUaJO0Du72zxvnVIFIC8hqak2HF5SCFVbQF8pAXX
 LtWiFtO65cFcgcbp9crVDWdQUiPKl3/n2eosTvV09PplElbRnftWkYYIzIsdbjv1F5vuFYQtzn
 6AlaTyoimv6XnAoFlE0ZNqyNxBXTfJABIMIRiPBh1Hubq8zOcs7i2sRjqeDoLRWayH8sfJvNcH
 ubw4FT4dEGDvTXzQHhtL6zKgID5zHoQ1h6bfTMZjDX7myR5pWQc3aqWfcSGoBmdsEOAAqE8GzZ
 xNk=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Jul 2023 19:29:21 -0700
IronPort-SDR: qRF+hqDbgyUmwuhjA8I9accN6xEEWZ0cWkI7ABwL5w1ypKyOJAHz4PV6Y7CXVhx6UmsIHTJwjD
 FW3RjzJsK74MDK1tS2gKcc17k02+s86nu8c1MMUZt7daS+tMg4ITS3GOLGOKysovH/4cHUymei
 4IeMm1+YcU96cWmS9072BdaE3rgbzRdsXypy6aO8yW7anPQSEc67F4MiIBefAG1c5hk0wwA6cv
 mBzCajCrW5ITFRVaf3pwmZvIVXAXyrKPQk0jTOhGWhRPkJ5oyNG6AHCOWcvkZ8EAzBkNcRdtDM
 LDM=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 Jul 2023 20:15:13 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 06/13] t/zbd: add max_active_zone variable
Date:   Fri,  7 Jul 2023 12:14:58 +0900
Message-Id: <20230707031505.3468915-7-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230707031505.3468915-1-shinichiro.kawasaki@wdc.com>
References: <20230707031505.3468915-1-shinichiro.kawasaki@wdc.com>
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

