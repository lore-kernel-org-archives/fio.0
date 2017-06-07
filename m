Return-Path: <fio-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:57872 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752734AbdFGXyd (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 7 Jun 2017 19:54:33 -0400
From: Daniel Verkamp <daniel.verkamp@intel.com>
Subject: [PATCH] lib/ffz: remove dead store
Date: Wed,  7 Jun 2017 16:53:36 -0700
Message-Id: <20170607235336.48859-1-daniel.verkamp@intel.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Daniel Verkamp <daniel.verkamp@intel.com>

'word' is written in the last 'if' block but never read again.

This is harmless, but scan-build (clang-analyzer) flags it as a warning.

Signed-off-by: Daniel Verkamp <daniel.verkamp@intel.com>
---
 lib/ffz.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/ffz.h b/lib/ffz.h
index e2c1b8e..b98dad6 100644
--- a/lib/ffz.h
+++ b/lib/ffz.h
@@ -28,7 +28,6 @@ static inline int ffs64(uint64_t word)
 		r += 2;
 	}
 	if (!(word & 1)) {
-		word >>= 1;
 		r += 1;
 	}
 
-- 
2.9.4

