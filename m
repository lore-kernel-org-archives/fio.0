Return-Path: <bvanassche@acm.org>
From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 1/6] t/zbd/functions: Make fio_reset_count() return 0 if no resets occurred
Date: Fri, 28 Sep 2018 14:51:28 -0700
Message-Id: <20180928215133.35222-2-bvanassche@acm.org>
In-Reply-To: <20180928215133.35222-1-bvanassche@acm.org>
References: <20180928215133.35222-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

This patch avoids that certain bash versions report the following complaint:

t/zbd/test-zbd-support: line 69: [: : integer expression expected

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Damien Le Moal <damien.lemoal@wdc.com>
---
 t/zbd/functions | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/t/zbd/functions b/t/zbd/functions
index 95f9bf456b9a..173f0ca64a42 100644
--- a/t/zbd/functions
+++ b/t/zbd/functions
@@ -102,5 +102,8 @@ fio_written() {
 }
 
 fio_reset_count() {
-    sed -n 's/^.*write:[^;]*; \([0-9]*\) zone resets$/\1/p'
+    local count
+
+    count=$(sed -n 's/^.*write:[^;]*; \([0-9]*\) zone resets$/\1/p')
+    echo "${count:-0}"
 }
-- 
2.19.0.605.g01d371f741-goog


