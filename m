Return-Path: <prvs=439ee04d1=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 3/8] t/zbd: Add write_and_run_one_fio_job() helper function
Date: Fri, 26 Jun 2020 18:43:26 +0900
Message-Id: <20200626094331.418309-4-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20200626094331.418309-1-shinichiro.kawasaki@wdc.com>
References: <20200626094331.418309-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

To test read workload behavior with zonemode=zbd and zoned block devices
with all zones empty, it is required to write data to the device before
the read workload. To avoid repeated codes for such test preparation,
introduce the helper function write_and_run_one_file_job(). It runs the
write job with specified offset and size to prepare the read data, then
run the specified job for read test.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 1178afd4..55363357 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -109,6 +109,20 @@ run_one_fio_job() {
 	    --thread=1 --direct=1
 }
 
+write_and_run_one_fio_job() {
+    local r
+    local write_offset="${1}"
+    local write_size="${2}"
+
+    shift 2
+    r=$(((RANDOM << 16) | RANDOM))
+    run_fio --filename="$dev" --randseed="$r"  --name="write_job" --rw=write \
+	    "$(ioengine "psync")" --bs="${logical_block_size}" \
+	    --zonemode=zbd --zonesize="${zone_size}" --thread=1 --direct=1 \
+	    --offset="${write_offset}" --size="${write_size}" \
+	    --name="$dev" --wait_for="write_job" "$@" --thread=1 --direct=1
+}
+
 # Run fio on the first four sequential zones of the disk.
 run_fio_on_seq() {
     local opts=()
-- 
2.26.2


