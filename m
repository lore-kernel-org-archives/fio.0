Return-Path: <prvs=390c41bd8=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v2 7/7] t/zbd: Use max-jobs=16 option
Date: Fri,  8 May 2020 16:56:45 +0900
Message-Id: <20200508075645.543890-8-damien.lemoal@wdc.com>
In-Reply-To: <20200508075645.543890-1-damien.lemoal@wdc.com>
References: <20200508075645.543890-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Use max-jobs option to reduce memory usage and speedup execution of
test-zbd-support.

With --max-jobs=16, twice the largest number of jobs used in all test
cases, the execution time of test-zbd-support against a zoned nullblk
device is lowered from 64s to 41s on a laptop.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 t/zbd/test-zbd-support | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index be889f34..de05f438 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -93,8 +93,8 @@ run_fio() {
 
     fio=$(dirname "$0")/../../fio
 
-    opts=("--aux-path=/tmp" "--allow_file_create=0" \
-			    "--significant_figures=10" "$@")
+    opts=("--max-jobs=16" "--aux-path=/tmp" "--allow_file_create=0" \
+	  "--significant_figures=10" "$@")
     opts+=(${var_opts[@]})
     { echo; echo "fio ${opts[*]}"; echo; } >>"${logfile}.${test_number}"
 
-- 
2.25.4


