Return-Path: <fio-owner@vger.kernel.org>
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:41008 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422649AbaD3TDq (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 30 Apr 2014 15:03:46 -0400
From: Danny Al-Gaaf <danny.al-gaaf@bisect.de>
Subject: [PATCH] crc/test.c: fix include of time.h
Date: Wed, 30 Apr 2014 20:48:16 +0200
Message-Id: <1398883696-12041-1-git-send-email-danny.al-gaaf@bisect.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Daniel Gollub <daniel.gollub@t-online.de>, Danny Al-Gaaf <d.al-gaaf@telekom.de>

Replace include of time.h with renamed fio_time.h to fix build.

Signed-off-by: Danny Al-Gaaf <danny.al-gaaf@bisect.de>
---
 crc/test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crc/test.c b/crc/test.c
index 2cc7c0f..3773b71 100644
--- a/crc/test.c
+++ b/crc/test.c
@@ -4,7 +4,7 @@
 
 #include "../fio.h"
 #include "../gettime.h"
-#include "../time.h"
+#include "../fio_time.h"
 #include "../verify.h"
 
 #include "../crc/md5.h"
-- 
1.8.5.2

