Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:34438 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbaEAMHN (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 1 May 2014 08:07:13 -0400
Received: by mail-ee0-f53.google.com with SMTP id b15so1062040eek.40
        for <fio@vger.kernel.org>; Thu, 01 May 2014 05:07:12 -0700 (PDT)
From: Daniel Gollub <daniel.gollub@gmail.com>
Subject: [PATCH 3/4] Avoid double-declaration of ARRAY_SIZE
Date: Thu,  1 May 2014 14:07:03 +0200
Message-Id: <1398946024-13566-3-git-send-email-daniel.gollub@gmail.com>
In-Reply-To: <1398946024-13566-1-git-send-email-daniel.gollub@gmail.com>
References: <1398946024-13566-1-git-send-email-daniel.gollub@gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Daniel Gollub <daniel.gollub@gmail.com>

for external ioengines. ARRAY_SIZE is a very common
declaration - e.g. Ceph is using this as well.

Signed-off-by: Daniel Gollub <daniel.gollub@gmail.com>
---
 fio.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fio.h b/fio.h
index ed034cb..4d4af0a 100644
--- a/fio.h
+++ b/fio.h
@@ -618,7 +618,9 @@ static inline void td_io_u_free_notify(struct thread_data *td)
 extern const char *fio_get_arch_string(int);
 extern const char *fio_get_os_string(int);
 
+#ifdef FIO_INTERNAL
 #define ARRAY_SIZE(x) (sizeof((x)) / (sizeof((x)[0])))
+#endif
 
 enum {
 	FIO_OUTPUT_TERSE	= 0,
-- 
1.7.10.4

