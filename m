Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C13EC6FA99
	for <fio@archiver.kernel.org>; Mon,  6 Mar 2023 05:58:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbjCFF6r (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 6 Mar 2023 00:58:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCFF6q (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 6 Mar 2023 00:58:46 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D67BD1FFC
        for <fio@vger.kernel.org>; Sun,  5 Mar 2023 21:58:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1678082324; x=1709618324;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=b4PwXlt4gFHeo/iu+JCxvAbv2hNZ1xjcp78LX5oXM1g=;
  b=BvlGSo0ohfoEbNGRyqjh5kcNJyIcB8X+BiC6I4F14jt93S6jaGJfsFpH
   Z+e9ACKTjoJ2pRKDguenIqJz6pQlqtn6RPJuuc+aDs3lB/TM4aj8FaPBx
   08ZDTb4bePOFcpEi75vysXGhUY4x0nnoweLF+UZ2+ZeJVO18DR4TZ1k9J
   TABppHJzi0KWgIy2UfA9CKYKCL+V8SDeiwVkp5vcytj84+wdIECsIOsHg
   xT1kQwWeUvP6F7ynmd6MZ/CUfVkjbe3Uc6iJsew2Y+7v3nSIKGlh95hrO
   gOdvBeLziQo0pOV1wGfzNs0zorXoGvvSuq3seRuzqNYtVMoZ4Aq9m0ChM
   w==;
X-IronPort-AV: E=Sophos;i="5.98,236,1673884800"; 
   d="scan'208";a="223161445"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 06 Mar 2023 13:58:44 +0800
IronPort-SDR: GDTZ38GXA+2WgEmc3Jrr7Tcf7wThOkeZvE+N6xTom9wZWIUDOBuKWNmpdkSZ6iL6XG1wdHEecr
 6m8ZropwmwhPBzOr7iTCHfT5QiFcAkfgG6mu9hbXWsI/ydkwRqv7psO/IGh0h6htHcGgiosySe
 GzV0LY3sKJE3wtKuQbwPTtR20g2L96fiDOWvndH1S83JPxTTCJM52BzERoKOxVqfvEw3mP2Eo3
 DXAX/WbLPG+dz15b+Cy1r/1FbdZYP0gpOV6Y+BuOsFs+IMFmc7aq3exrBdn23ceqnDFK9zoeUk
 UV8=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Mar 2023 21:15:25 -0800
IronPort-SDR: ww6+eff6tWj38qUPGkeXbcckWU+zr5++j56owzJqAHHy8IZpTN8Z7xFX1fiBp0xiW0XQyMEPus
 UvyddX5MY1+6Suzd5JoA9Kj861oioiBbeWKZSOO4geu01vP1q9PNvYDnjCAuEMnICNUzCxyC2J
 3nGvm27bEZXF0NJhDLnLpbpQiMztrjo/vOxQOW4ysDgQ465iYYltUpMVgn41w024cAjTBj+TRT
 rm98KkhHOBQtzneS+dEWqjuW2D1224d0B5QMoMGqRsvr+mJl6ylAtC+17WbUwt1P++lsQwbZ9N
 M0I=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 05 Mar 2023 21:58:44 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 2/2] t/zbd: fix minimum write size to sequential write required zones
Date:   Mon,  6 Mar 2023 14:58:40 +0900
Message-Id: <20230306055840.3375830-3-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230306055840.3375830-1-shinichiro.kawasaki@wdc.com>
References: <20230306055840.3375830-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

ZBC and ZAC require that writes to sequential write required zones shall
be aligned to physical block size. However, the t/zbd/test-zbd-support
script uses logical block size as the minimum write size. When SMR
drives have the physical block size larger than the logical block size,
writes with the logical block size causes unaligned write command error.

To fix it, use correct value as the minimum write size. As for zoned
block devices, introduce a helper function min_seq_write_size(), which
checks sysfs attributes and returns the correct size. Refer the
attribute zone_write_granularity when it is available, which provides the
minimum write size regardless of the device type. If the attribute is
not available, refer the attribute physical_block_size for SMR devices,
and the logical_block_size attribute for other devices. As for SG node
device, refer physical block size that zbc_info command reports.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/functions        | 28 +++++++++++++++++++++++++---
 t/zbd/test-zbd-support |  6 +++---
 2 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/t/zbd/functions b/t/zbd/functions
index 812320f5..9a6d6999 100644
--- a/t/zbd/functions
+++ b/t/zbd/functions
@@ -238,18 +238,40 @@ max_open_zones() {
     fi
 }
 
+# Get minimum block size to write to seq zones. Refer the sysfs attribute
+# zone_write_granularity which shows the valid minimum size regardless of zoned
+# block device type. If the sysfs attribute is not available, refer physical
+# block size for rotational SMR drives. For non-rotational devices such as ZNS
+# devices, refer logical block size.
+min_seq_write_size() {
+	local sys_path="/sys/block/$1/queue"
+	local -i size=0
+
+	if [[ -r "$sys_path/zone_write_granularity" ]]; then
+		size=$(<"$sys_path/zone_write_granularity")
+	fi
+
+	if ((size)); then
+		echo "$size"
+	elif (($(<"$sys_path/rotational"))); then
+		cat "$sys_path/physical_block_size"
+	else
+		cat "$sys_path/logical_block_size"
+	fi
+}
+
 is_zbc() {
 	local dev=$1
 
 	[[ -z "$(${zbc_info} "$dev" | grep "is not a zoned block device")" ]]
 }
 
-zbc_logical_block_size() {
+zbc_physical_block_size() {
 	local dev=$1
 
 	${zbc_info} "$dev" |
-		grep "logical blocks" |
-		sed -n 's/^[[:blank:]]*[0-9]* logical blocks of[[:blank:]]*//p' |
+		grep "physical blocks" |
+		sed -n 's/^[[:blank:]]*[0-9]* physical blocks of[[:blank:]]*//p' |
 		sed 's/ B//'
 }
 
diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 7b229002..996160e7 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1427,7 +1427,7 @@ if [[ -b "$realdev" ]]; then
 		realsysfs=$(readlink "/sys/dev/block/$major:$minor")
 		basename=$(basename "${realsysfs%/*}")
 	fi
-	min_seq_write_size=$(<"/sys/block/$basename/queue/logical_block_size")
+	min_seq_write_size=$(min_seq_write_size "$basename")
 	case "$(<"/sys/class/block/$basename/queue/zoned")" in
 	host-managed|host-aware)
 		is_zbd=true
@@ -1476,8 +1476,8 @@ elif [[ -c "$realdev" ]]; then
 		echo "Failed to determine disk size"
 		exit 1
 	fi
-	if ! min_seq_write_size=($(zbc_logical_block_size "$dev")); then
-		echo "Failed to determine logical block size"
+	if ! min_seq_write_size=($(zbc_physical_block_size "$dev")); then
+		echo "Failed to determine physical block size"
 		exit 1
 	fi
 	if ! result=($(first_sequential_zone "$dev")); then
-- 
2.38.1

