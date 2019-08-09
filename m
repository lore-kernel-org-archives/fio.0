Return-Path: <prvs=117483739=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH] t/zbd: Fix I/O bytes rounding errors
Date: Fri,  9 Aug 2019 12:28:36 +0900
Message-Id: <20190809032836.10163-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

When fio reports write bytes or read bytes, it rounds the number with
units MiB or KiB to fit the number within limited number of digits.
This results in rounding errors of the reported bytes and sometimes
causes test failures for test case #17 in test-zbd-support
which reports incorrect total I/O bytes in case both of write bytes
and read bytes are rounded up.

To avoid the rounding error, increase the number of digits from default
value 4 to 10 to keep precision. For example, a number "256MiB" will be
reported as "267911168B" with this change.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 10c78e9a..6fb48ef0 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -85,7 +85,8 @@ run_fio() {
 
     fio=$(dirname "$0")/../../fio
 
-    opts=("--aux-path=/tmp" "--allow_file_create=0" "$@")
+    opts=("--aux-path=/tmp" "--allow_file_create=0" \
+			    "--significant_figures=10" "$@")
     { echo; echo "fio ${opts[*]}"; echo; } >>"${logfile}.${test_number}"
 
     "${dynamic_analyzer[@]}" "$fio" "${opts[@]}"
-- 
2.21.0


