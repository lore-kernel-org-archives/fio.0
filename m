Return-Path: <prvs=6542a1e1f=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v4 23/38] t/zbd: check for error in test #2
Date: Wed, 27 Jan 2021 13:19:30 +0900
Message-Id: <20210127041945.36909-24-dmitry.fomichev@wdc.com>
In-Reply-To: <20210127041945.36909-1-dmitry.fomichev@wdc.com>
References: <20210127041945.36909-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Aravind Ramesh <aravind.ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

With the preceding commit in place, fio gives an error if user attempts
to run write I/O size that is larger than the zone size. Grep for that
message instead of checking that no write has happened.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Reviewed-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index acde3b3a..652dddfc 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -221,8 +221,8 @@ test2() {
     if [ -z "$is_zbd" ]; then
 	opts+=("--zonesize=${zone_size}")
     fi
-    run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
-    ! grep -q 'WRITE:' "${logfile}.${test_number}"
+    run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 && return 1
+    grep -q 'buflen exceeds zone size' "${logfile}.${test_number}"
 }
 
 # Run fio against an empty zone. This causes fio to report "No I/O performed".
-- 
2.28.0


