Return-Path: <prvs=620a42eaa=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v2 35/36] t/zbd: increase timeout in test #48
Date: Thu, 24 Dec 2020 11:12:18 +0900
Message-Id: <20201224021219.189727-36-dmitry.fomichev@wdc.com>
In-Reply-To: <20201224021219.189727-1-dmitry.fomichev@wdc.com>
References: <20201224021219.189727-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org, Aravind Ramesh <aravind.ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

Test #48 runs some i/o to the test device for 30 seconds and then waits
45 seconds for fio to finish. If this wait times out, the test assumes
that fio is hung because of a zone locking issue and fails. It is
observed that 45s may not be enough for some HDDs, especially the ones
running specialized firmware.

Increase the timeout to 180 seconds to avoid any false positives.
There is no change in test duration for the most common devices.
The test will wait for the full 180 seconds only if it fails, otherwise
it will finish very soon after the 30 second i/o period ends.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 t/zbd/test-zbd-support | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index c1ee52ed..2a7faf38 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1008,7 +1008,7 @@ test48() {
 
     { echo; echo "fio ${opts[*]}"; echo; } >>"${logfile}.${test_number}"
 
-    timeout -v -s KILL 45s \
+    timeout -v -s KILL 180s \
 	    "${dynamic_analyzer[@]}" "$fio" "${opts[@]}" \
 	    >> "${logfile}.${test_number}" 2>&1 || return $?
 }
-- 
2.28.0


