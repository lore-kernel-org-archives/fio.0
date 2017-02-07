Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([74.50.51.35]:12286 "EHLO muon.cran.org.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755190AbdBGQNc (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 7 Feb 2017 11:13:32 -0500
From: Rebecca Cran <rebecca@bluestop.org>
Subject: [PATCH] Fix the return type of log_err and log_info functions
Date: Tue,  7 Feb 2017 09:13:19 -0700
Message-Id: <20170207161319.15162-1-rebecca@bluestop.org>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Rebecca Cran <rebecca@bluestop.org>

---
 t/log.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/t/log.c b/t/log.c
index 1ed38519..929aac6c 100644
--- a/t/log.c
+++ b/t/log.c
@@ -2,7 +2,7 @@
 #include <stdarg.h>
 #include "../minmax.h"
 
-int log_err(const char *format, ...)
+size_t log_err(const char *format, ...)
 {
 	char buffer[1024];
 	va_list args;
@@ -16,7 +16,7 @@ int log_err(const char *format, ...)
 	return fwrite(buffer, len, 1, stderr);
 }
 
-int log_info(const char *format, ...)
+size_t log_info(const char *format, ...)
 {
 	char buffer[1024];
 	va_list args;
-- 
2.11.0

