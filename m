Return-Path: <fio-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:34687 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726928AbgB1HOp (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 28 Feb 2020 02:14:45 -0500
From: Naohiro Aota <naohiro.aota@wdc.com>
Subject: [PATCH 6/6] zbd: add test for stressing zone locking
Date: Fri, 28 Feb 2020 16:12:48 +0900
Message-Id: <20200228071248.3981623-7-naohiro.aota@wdc.com>
In-Reply-To: <20200228071248.3981623-1-naohiro.aota@wdc.com>
References: <20200228071248.3981623-1-naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>

Add a test to stress zone locking mechanism by having a large number of
threads with a small number of max_open_zones. Run 30 seconds time-based
fio under the timeout command. After 45 seconds, "timeout" kill -KILL the
fio process. If a zone lock deadlocks, fio is killed by the timeout
command, and this test fails. If not, fio runs to the end and this test
success.

Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
---
 t/zbd/test-zbd-support | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 5d079a8b7873..bd41fffb3298 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -755,6 +755,36 @@ test47() {
     grep -q 'zoneskip 1 is not a multiple of the device zone size' "${logfile}.${test_number}"
 }
 
+# Multiple overlapping random write jobs for the same drive and with a
+# limited number of open zones. This is similar to test29, but uses libaio
+# to stress test zone locking.
+test48() {
+    local i jobs=16 off opts=()
+
+    off=$((first_sequential_zone_sector * 512 + 64 * zone_size))
+    size=$((16*zone_size))
+    [ -n "$is_zbd" ] && reset_zone "$dev" $((off / 512))
+    opts=("--aux-path=/tmp" "--allow_file_create=0" "--significant_figures=10")
+    opts+=("--debug=zbd")
+    opts+=("--ioengine=libaio" "--rw=randwrite" "--direct=1")
+    opts+=("--time_based" "--runtime=30")
+    opts+=("--zonemode=zbd" "--zonesize=${zone_size}")
+    opts+=("--max_open_zones=4")
+    for ((i=0;i<jobs;i++)); do
+	opts+=("--name=job$i" "--filename=$dev" "--offset=$off" "--bs=16K")
+	opts+=("--io_size=$zone_size" "--iodepth=256" "--thread=1")
+	opts+=("--group_reporting=1")
+    done
+
+    fio=$(dirname "$0")/../../fio
+
+    { echo; echo "fio ${opts[*]}"; echo; } >>"${logfile}.${test_number}"
+
+    timeout -v -s KILL 45s \
+	    "${dynamic_analyzer[@]}" "$fio" "${opts[@]}" \
+	    >> "${logfile}.${test_number}" 2>&1 || return $?
+}
+
 tests=()
 dynamic_analyzer=()
 reset_all_zones=
-- 
2.25.1


