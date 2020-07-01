Return-Path: <fio-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:48983 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728577AbgGAIaf (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 1 Jul 2020 04:30:35 -0400
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 3/6] t/zbd: Mandate blkzone capacity report for devices with zone capacity
Date: Wed,  1 Jul 2020 17:30:26 +0900
Message-Id: <20200701083029.140741-4-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20200701083029.140741-1-shinichiro.kawasaki@wdc.com>
References: <20200701083029.140741-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Hans Holmberg <hans.holmberg@wdc.com>, Aravind Ramesh <aravind.ramesh@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>

For NVMe ZNS and null_blk zoned drives, the zone capacity can be smaller
than the zone size. To test zone capacity handling by fio for these
devices, need to know each zone's zone capacity. If the blkzone tool is
old and does not report zone capacity, t/zbd/test-zbd-support script run
will fail for the devices.

To avoid the failures, make zone capacity report by blkzone mandatory if
the test target device is a ZNS device or a null_blk device.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/functions        | 45 ++++++++++++++++++++++++++++++++++++++++++
 t/zbd/test-zbd-support |  3 +++
 2 files changed, 48 insertions(+)

diff --git a/t/zbd/functions b/t/zbd/functions
index 1bd22ec4..344836c8 100644
--- a/t/zbd/functions
+++ b/t/zbd/functions
@@ -19,6 +19,51 @@ if [ -n "${use_libzbc}" ] &&
     exit 1
 fi
 
+blkzone_reports_capacity() {
+	local dev="${1}"
+
+	[[ -n "${blkzone}" ]] &&
+		"${blkzone}" report -c 1 -o 0 "${dev}" | grep -q 'cap '
+}
+
+# Whether or not $1 (/dev/...) is a NVME ZNS device.
+is_nvme_zns() {
+	local s
+
+	s=/sys/block/$(basename "${1}")/device/subsystem
+
+	if [[ ! -h "${s}" || $(realpath "${s}") != /sys/class/nvme ]]; then
+		return 1
+	fi
+
+	[[ $(</sys/block/$(basename "${1}")/queue/zoned) == host-managed ]]
+}
+
+# Whether or not $1 (/dev/...) is a null_blk device with zone capacity smaller
+# than zone size.
+is_nullb_with_zone_cap() {
+	local f
+
+	f=/sys/kernel/config/nullb/$(basename "${1}")
+	[[ -r "${f}/zone_capacity" &&
+		   $(<"${f}/zone_capacity") -lt $(<"${f}/zone_size") ]]
+}
+
+# Check if blkzone is available and suitable for the test target device. If not
+# available, print error message and return 1. Otherwise return 0.
+check_blkzone() {
+	local dev="${1}"
+
+	# If the devices supports zone capacity, mandate zone capacity report by
+	# blkzone.
+	if is_nvme_zns "${dev}" || is_nullb_with_zone_cap "${dev}" &&
+				! blkzone_reports_capacity "${dev}"; then
+		echo "Error: blkzone does not report zone capacity"
+		echo "Error: install latest util-linux with blkzone"
+		return 1
+	fi
+}
+
 # Reports the starting sector and length of the first sequential zone of device
 # $1.
 first_sequential_zone() {
diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 80dc3f30..f086bd10 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -863,6 +863,9 @@ if [[ -b "$realdev" ]]; then
 	case "$(<"/sys/class/block/$basename/queue/zoned")" in
 	host-managed|host-aware)
 		is_zbd=true
+		if ! check_blkzone "${dev}"; then
+			exit 1
+		fi
 		if ! result=($(first_sequential_zone "$dev")); then
 			echo "Failed to determine first sequential zone"
 			exit 1
-- 
2.26.2


