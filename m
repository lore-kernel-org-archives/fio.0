Return-Path: <bvanassche@acm.org>
From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 3/6] t/zbd/test-zbd-support: Set fio aux path and forbid file creation
Date: Fri, 28 Sep 2018 14:51:30 -0700
Message-Id: <20180928215133.35222-4-bvanassche@acm.org>
In-Reply-To: <20180928215133.35222-1-bvanassche@acm.org>
References: <20180928215133.35222-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

Set the fio aux path to /tmp to avoid cluttering the directory from which the
test scripts are run. Disallow file creation to make tests fail if the block
device against which these are run does not exist.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Damien Le Moal <damien.lemoal@wdc.com>
---
 t/zbd/test-zbd-support | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index afe229097ef6..fd30f5c6ecca 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -81,13 +81,14 @@ is_scsi_device() {
 }
 
 run_fio() {
-    local fio
+    local fio opts
 
     fio=$(dirname "$0")/../../fio
 
-    { echo; echo "fio $*"; echo; } >>"${logfile}.${test_number}"
+    opts=("--aux-path=/tmp" "--allow_file_create=0" "$@")
+    { echo; echo "fio ${opts[*]}"; echo; } >>"${logfile}.${test_number}"
 
-    "${dynamic_analyzer[@]}" "$fio" "$@"
+    "${dynamic_analyzer[@]}" "$fio" "${opts[@]}"
 }
 
 run_one_fio_job() {
-- 
2.19.0.605.g01d371f741-goog


