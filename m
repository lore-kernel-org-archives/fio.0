Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 636D8EE3F3F
	for <fio@archiver.kernel.org>; Wed, 13 Sep 2023 01:52:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbjIMBw6 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 12 Sep 2023 21:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbjIMBw5 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 12 Sep 2023 21:52:57 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1897E10DF
        for <fio@vger.kernel.org>; Tue, 12 Sep 2023 18:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1694569974; x=1726105974;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=17DnmvONCmMAM2CeYbYs43hW/j8+g9gswV6kMcj3AXs=;
  b=Xp952dYP4uDJvxDix+QbC2BGY8dmB4TRLYzNeCoVM7+69dKBOXKOGY5P
   LfT2/xgFmOZtHXQP9Jyzv9x4cyR6LpnF9+m1B771uTa8RloSuZrphoN0/
   mDBTSduq3BJr9cmTHs9HN8HsWxYyzCAnkUNAZLm3fuljhQBP2Ae8K+sKC
   GpjxYOvEkEcQzs9hfAEi1usdnQhYpfkVKLqrP4D/w63GbNvpfBYpw0X2o
   trSyV+OW9ZsAOCuyZLGgZhOQfOi/JE4z+JNe5O9pQSf319lieyCMa5+wI
   wT8s7yWoY758NZomqSEo2D2DuX1KDcEsFAoTv3Lud24YSt8QLARt0rXOv
   A==;
X-CSE-ConnectionGUID: Lz0IfRiNRMeJDkkQZTY+eg==
X-CSE-MsgGUID: 8AFXZpH3SDmErunBAXcuog==
X-IronPort-AV: E=Sophos;i="6.02,142,1688400000"; 
   d="scan'208";a="349107420"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 13 Sep 2023 09:52:53 +0800
IronPort-SDR: Ao4Ae0a9SzDG9PHUc0qaYX+Ay8W5VY4DCIoe/IaHf9PF0Gtrou9bLp+PL1LrwQY49MVy1n6Gcu
 eZ7px7Bpke8VbTMmuV3nC28PrbV7vrBLxZ8MKdoCAnb61B9I+hwwjtl4gjMYCpEMpZr2D9Z+qD
 84uuSv3D04ziawiu26f+9KrSjSzjoCyhAXtVNzKaiZNyENg38tbYMYW5xyO9V/nZYEPN8IDU1R
 X7KXl9aqy0+l7FR+AD6PltY1AefzUbI2Ywb7LDOqOnrbBRvE9BAithVslk2Vpe/lvsRer/umf9
 K50=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Sep 2023 18:05:38 -0700
IronPort-SDR: wUO0KHfJfRYNI2MNGvVOiGPebjdlswp/YaYGV3P48t05HyVeodVwDLCM3Hur5TFdMoH9N45vp5
 Z831IDE23BU3EdLZGfv+U3psXx9WleZLQp+RzaQZqrRx1K42zx3BB6hpqaBP6tVlsG+ncKZswt
 5MMQfU0sdFt6cfZyNMRUzLfn3Cn5KHOCa6IO1RWWCWllSadlLa2OIopX3Rr5QNdX2TiP4no6R+
 UxobIaXWrXbOo/rJAqGJlPajLdr3t+fNyUmyjg/uZqp9v/83hLCXxNJnvTFGKHjdiuSGTl9McF
 XG8=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip02.wdc.com with ESMTP; 12 Sep 2023 18:52:50 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH] t/zbd: set mq-deadline scheduler to device-mapper destination devices
Date:   Wed, 13 Sep 2023 10:52:49 +0900
Message-ID: <20230913015249.2226799-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

When write workloads run on zoned block devices, mq-deadline scheduler is
required to ensure write operations are sequential. To fulfill this
requirement, the test script t/zbd/test-zbd-support sets mq-deadline to
the sysfs attribute "queue/scheduler". However, this preparation does
not work when the write target device is a bio based device-mapper
device. The device is bio based then I/O scheduler does not work.
Setting mq-deadline to the sysfs attribute has no effect. On top of
that, the sysfs attribute "queue/scheduler" is no longer available for
bio based device-mapper devices since Linux kernel version v6.5.

To ensure mq-deadline scheduler for bio based device-mapper devices,
improve the helper function set_io_scheduler. If the sysfs attribute
"queue/scheduler" is available, use it. Otherwise, check if the test
device is a zoned device-mapper (linear, flakey or crypt). If so, set
mq-deadline scheduler to destination devices of the device-mapper
device. To implement these, add some helper functions.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/functions        | 11 ++++++++
 t/zbd/test-zbd-support | 61 +++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 71 insertions(+), 1 deletion(-)

diff --git a/t/zbd/functions b/t/zbd/functions
index 4faa45a9..028df404 100644
--- a/t/zbd/functions
+++ b/t/zbd/functions
@@ -27,6 +27,17 @@ blkzone_reports_capacity() {
 		"${blkzone}" report -c 1 -o 0 "${dev}" | grep -q 'cap '
 }
 
+has_command() {
+	local cmd="${1}"
+
+	cmd_path=$(type -p "${cmd}" 2>/dev/null)
+	if [ -z "${cmd_path}" ]; then
+		echo "${cmd} is not available"
+		return 1
+	fi
+	return 0
+}
+
 # Whether or not $1 (/dev/...) is a NVME ZNS device.
 is_nvme_zns() {
 	local s
diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index c8f3eb61..0436d319 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -46,6 +46,55 @@ ioengine() {
 	fi
 }
 
+get_dev_path_by_id() {
+	for d in /sys/block/* /sys/block/*/*; do
+		if [[ ! -r "${d}/dev" ]]; then
+			continue
+		fi
+		if [[ "${1}" == "$(<"${d}/dev")" ]]; then
+			echo "/dev/${d##*/}"
+			return 0
+		fi
+	done
+	return 1
+}
+
+dm_destination_dev_set_io_scheduler() {
+	local dev=$1 sched=$2
+	local dest_dev_id dest_dev path
+
+	has_command dmsetup || return 1
+
+	while read -r dest_dev_id; do
+		if ! dest_dev=$(get_dev_path_by_id "${dest_dev_id}"); then
+			continue
+		fi
+		path=${dest_dev/dev/sys\/block}/queue/scheduler
+		if [[ ! -w ${path} ]]; then
+			echo "Can not set scheduler of device mapper destination: ${dest_dev}"
+			continue
+		fi
+		echo "${2}" > "${path}"
+	done < <(dmsetup table "$(<"/sys/block/$dev/dm/name")" |
+			 sed -n  's/.* \([0-9]*:[0-9]*\).*/\1/p')
+}
+
+dev_has_dm_map() {
+	local dev=${1} target_type=${2}
+	local dm_name
+
+	has_command dmsetup || return 1
+
+	dm_name=$(<"/sys/block/$dev/dm/name")
+	if ! dmsetup status "${dm_name}" | grep -qe "${target_type}"; then
+		return 1
+	fi
+	if dmsetup status "${dm_name}" | grep -v "${target_type}"; then
+		return 1
+	fi
+	return 0
+}
+
 set_io_scheduler() {
     local dev=$1 sched=$2
 
@@ -62,7 +111,17 @@ set_io_scheduler() {
 	esac
     fi
 
-    echo "$sched" >"/sys/block/$dev/queue/scheduler"
+    if [ -w "/sys/block/$dev/queue/scheduler" ]; then
+	echo "$sched" >"/sys/block/$dev/queue/scheduler"
+    elif [ -r  "/sys/block/$dev/dm/name" ] &&
+		 ( dev_has_dm_map "$dev" linear ||
+		   dev_has_dm_map "$dev" flakey ||
+		   dev_has_dm_map "$dev" crypt ); then
+	dm_destination_dev_set_io_scheduler "$dev" "$sched"
+    else
+	echo "can not set io scheduler"
+	exit 1
+    fi
 }
 
 check_read() {
-- 
2.41.0

