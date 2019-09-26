Return-Path: <prvs=165d1baa7=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH] t/zbd: Avoid magic number of test case count
Date: Thu, 26 Sep 2019 10:00:44 +0900
Message-Id: <20190926010044.21020-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

In the test script t/zbd/test-zbd-support, the number of test cases is
defined as a raw constant. Every time a new test case is added, need to
update the constant but this chore tends to be overlooked. When test
case 47 was added recently, the number was not incremented from 46. Then
the test script does not run the test case 47.

To avoid the constant increment chore, automate the test case number
counting. List bash functions which implement test cases and convert the
list to test case numbers.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 90f9f87b..5d079a8b 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -826,9 +826,8 @@ case "$(<"/sys/class/block/$basename/queue/zoned")" in
 esac
 
 if [ "${#tests[@]}" = 0 ]; then
-    for ((i=1;i<=46;i++)); do
-	tests+=("$i")
-    done
+    readarray -t tests < <(declare -F | grep "test[0-9]*" | \
+				   tr -c -d "[:digit:]\n" | sort -n)
 fi
 
 logfile=$0.log
-- 
2.21.0


