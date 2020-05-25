Return-Path: <prvs=407053df0=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH 4/4] t/zbd: make the test script easier to terminate
Date: Tue, 26 May 2020 06:32:56 +0900
Message-Id: <20200525213256.7476-5-dmitry.fomichev@wdc.com>
In-Reply-To: <20200525213256.7476-1-dmitry.fomichev@wdc.com>
References: <20200525213256.7476-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

Very often, it takes more than one ^C to terminate test-zbd-support
script. Just a single ^C does end the test that is currently being
executed, but then the script proceeds to the next test. This commit
adds a simple signal handler to exit the test loop after receiving
a Ctrl-C.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 t/zbd/test-zbd-support | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 51b05dfd..4001be3b 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -940,6 +940,9 @@ else
 fi
 rc=0
 
+intr=0
+trap 'intr=1' SIGINT
+
 for test_number in "${tests[@]}"; do
     rm -f "${logfile}.${test_number}"
     echo -n "Running test $(printf "%02d" $test_number) ... "
@@ -955,6 +958,7 @@ for test_number in "${tests[@]}"; do
     fi
     echo -e "$cc_status"
     echo "$status" >> "${logfile}.${test_number}"
+    [ $intr -ne 0 ] && exit 1
 done
 
 echo "$passed tests passed"
-- 
2.21.0


