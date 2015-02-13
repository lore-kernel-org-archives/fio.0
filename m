Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:33405 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbbBMOqY (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 13 Feb 2015 09:46:24 -0500
Received: by pdjz10 with SMTP id z10so19855237pdj.0
        for <fio@vger.kernel.org>; Fri, 13 Feb 2015 06:46:23 -0800 (PST)
From: castor.fu@egocast.org
Subject: [PATCH 1/1] gettime.h: use time_t instead of size_t for copy of tv_sec
Date: Fri, 13 Feb 2015 06:46:04 -0800
Message-Id: <1423838764-40731-1-git-send-email-castor.fu@egocast.org>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Castor Fu <castor@egocast.org>

From: Castor Fu <castor@egocast.org>

This addresses a small nit that our compiler was complaining about.
Thanks!

---
 gettime.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/gettime.h b/gettime.h
index eb3537b..86d55bd 100644
--- a/gettime.h
+++ b/gettime.h
@@ -24,7 +24,7 @@ extern struct timeval *fio_tv;
 
 static inline int fio_gettime_offload(struct timeval *tv)
 {
-	size_t last_sec;
+	time_t last_sec;
 
 	if (!fio_tv)
 		return 0;
-- 
1.8.4

