Return-Path: <prvs=49599655b=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 4/7] t/zbd: Improve usage message of test-zbd-support script
Date: Fri, 21 Aug 2020 15:37:36 +0900
Message-Id: <20200821063739.390353-5-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20200821063739.390353-1-shinichiro.kawasaki@wdc.com>
References: <20200821063739.390353-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

The usage message of t/zbd/test-zbd-support does not explain meaning of
each option. Elaborate meaning of the options.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Dmitry Fomichev: <dmitry.fomichev@wdc.com>
---
 t/zbd/test-zbd-support | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 139495d3..9e398cab 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -5,7 +5,15 @@
 # This file is released under the GPL.
 
 usage() {
-    echo "Usage: $(basename "$0") [-d] [-e] [-l] [-r] [-v] [-t <test>] [-z] <SMR drive device node>"
+	echo "Usage: $(basename "$0") [OPTIONS] <test target device file>"
+	echo "Options:"
+	echo -e "\t-d Run fio with valgrind using DRD tool"
+	echo -e "\t-e Run fio with valgrind using helgrind tool"
+	echo -e "\t-v Run fio with valgrind --read-var-info option"
+	echo -e "\t-l Test with libzbc ioengine"
+	echo -e "\t-r Reset all zones before test start"
+	echo -e "\t-t <test #> Run only a single test case with specified number"
+	echo -e "\t-z Run fio with debug=zbd option"
 }
 
 max() {
-- 
2.26.2


