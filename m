Return-Path: <prvs=6542a1e1f=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v4 36/38] t/zbd: show elapsed time in test-zbd-support
Date: Wed, 27 Jan 2021 13:19:43 +0900
Message-Id: <20210127041945.36909-37-dmitry.fomichev@wdc.com>
In-Reply-To: <20210127041945.36909-1-dmitry.fomichev@wdc.com>
References: <20210127041945.36909-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Aravind Ramesh <aravind.ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

This script may take quite a lot of time to run against large
zoned HDDs. At the end of every run, show exactly how much time
it took.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Reviewed-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 0230f1af..f9427981 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1153,6 +1153,7 @@ test54() {
 		>> "${logfile}.${test_number}" 2>&1 || return $?
 }
 
+SECONDS=0
 tests=()
 dynamic_analyzer=()
 reset_all_zones=
@@ -1346,4 +1347,5 @@ fi
 if [ $failed -gt 0 ]; then
     echo " $failed tests failed"
 fi
+echo "Run time: $(TZ=UTC0 printf "%(%H:%M:%S)T\n" $(( SECONDS )) )"
 exit $rc
-- 
2.28.0


