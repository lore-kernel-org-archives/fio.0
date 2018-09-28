Return-Path: <bvanassche@acm.org>
From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 2/6] t/zbd/test-zbd-support: Ensure that an assertion failure causes this test to fail
Date: Fri, 28 Sep 2018 14:51:29 -0700
Message-Id: <20180928215133.35222-3-bvanassche@acm.org>
In-Reply-To: <20180928215133.35222-1-bvanassche@acm.org>
References: <20180928215133.35222-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

Switch to threaded mode to make sure that an assertion failure results in
a non-zero exit status.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Damien Le Moal <damien.lemoal@wdc.com>
---
 t/zbd/test-zbd-support | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 6ee5055b57cf..afe229097ef6 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -113,7 +113,7 @@ run_fio_on_seq() {
 # Check whether buffered writes are refused.
 test1() {
     run_fio --name=job1 --filename="$dev" --rw=write --direct=0 --bs=4K	\
-	    --size="${zone_size}"					\
+	    --size="${zone_size}" --thread=1				\
 	    --zonemode=zbd --zonesize="${zone_size}" 2>&1 |
 	tee -a "${logfile}.${test_number}" |
 	grep -q 'Using direct I/O is mandatory for writing to ZBD drives'
-- 
2.19.0.605.g01d371f741-goog


