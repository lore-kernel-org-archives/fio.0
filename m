Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:34967 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbbHSKdX (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 19 Aug 2015 06:33:23 -0400
Received: by wicne3 with SMTP id ne3so116795970wic.0
        for <fio@vger.kernel.org>; Wed, 19 Aug 2015 03:33:22 -0700 (PDT)
From: Roman Pen <r.peniaev@gmail.com>
Subject: [RFC 5/6] add FIELD_SIZE macro to calculate the size of the specified field
Date: Wed, 19 Aug 2015 12:33:10 +0200
Message-Id: <1439980391-2311-6-git-send-email-r.peniaev@gmail.com>
In-Reply-To: <1439980391-2311-1-git-send-email-r.peniaev@gmail.com>
References: <1439980391-2311-1-git-send-email-r.peniaev@gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: 
Cc: Roman Pen <r.peniaev@gmail.com>, fio@vger.kernel.org

Will use this stuff later.

Signed-off-by: Roman Pen <r.peniaev@gmail.com>
---
 fio.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fio.h b/fio.h
index 17bc02b..ab858fa 100644
--- a/fio.h
+++ b/fio.h
@@ -667,7 +667,8 @@ extern const char *fio_get_arch_string(int);
 extern const char *fio_get_os_string(int);
 
 #ifdef FIO_INTERNAL
-#define ARRAY_SIZE(x) (sizeof((x)) / (sizeof((x)[0])))
+#define ARRAY_SIZE(x)    (sizeof((x)) / (sizeof((x)[0])))
+#define FIELD_SIZE(s, f) (sizeof(((typeof(s))0)->f))
 #endif
 
 enum {
-- 
2.4.4

