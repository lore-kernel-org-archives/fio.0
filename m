Return-Path: <dehrenberg@google.com>
Return-Path: <dehrenberg@google.com>
Sender: Daniel Ehrenberg <dehrenberg@google.com>
From: Dan Ehrenberg <dehrenberg@chromium.org>
Subject: [PATCH] Don't export state variable
Date: Mon, 20 Apr 2015 16:20:30 -0700
Message-Id: <1429572030-6287-1-git-send-email-dehrenberg@chromium.org>
To: fio@vger.kernel.org, axboe@kernel.dk
Cc: gwendal@chromium.org, Dan Ehrenberg <dehrenberg@chromium.org>
List-ID: <fio@vger.kernel.org>

There was no reason to export this extra variable. It was just a typo
and it is never used.

Signed-off-by: Dan Ehrenberg <dehrenberg@chromium.org>
---
 stat.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/stat.h b/stat.h
index dd34012..e87dae0 100644
--- a/stat.h
+++ b/stat.h
@@ -132,7 +132,7 @@ enum block_info_state {
 	BLOCK_STATE_TRIM_FAILURE,
 	BLOCK_STATE_WRITE_FAILURE,
 	BLOCK_STATE_COUNT,
-} state;
+};
 
 #define MAX_PATTERN_SIZE	512
 #define FIO_JOBNAME_SIZE	128
-- 
2.2.0.rc0.207.ga3a616c


