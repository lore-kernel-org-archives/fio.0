Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:34192 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbaEAMHO (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 1 May 2014 08:07:14 -0400
Received: by mail-ee0-f51.google.com with SMTP id c13so2210044eek.38
        for <fio@vger.kernel.org>; Thu, 01 May 2014 05:07:13 -0700 (PDT)
From: Daniel Gollub <daniel.gollub@gmail.com>
Subject: [PATCH 4/4] Avoid double declaration of leXX_to_cpu
Date: Thu,  1 May 2014 14:07:04 +0200
Message-Id: <1398946024-13566-4-git-send-email-daniel.gollub@gmail.com>
In-Reply-To: <1398946024-13566-1-git-send-email-daniel.gollub@gmail.com>
References: <1398946024-13566-1-git-send-email-daniel.gollub@gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Daniel Gollub <daniel.gollub@gmail.com>

for external ioengines. leXX_to_cpu is a very common
declaration - e.g. Ceph is using this as well.

Signed-off-by: Daniel Gollub <daniel.gollub@gmail.com>
---
 os/os.h |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/os/os.h b/os/os.h
index 98b4532..b8eee66 100644
--- a/os/os.h
+++ b/os/os.h
@@ -200,6 +200,7 @@ static inline uint64_t fio_swap64(uint64_t val)
 #endif
 #endif /* FIO_HAVE_BYTEORDER_FUNCS */
 
+#ifdef FIO_INTERNAL
 #define le16_to_cpu(val) ({			\
 	__le16_to_cpu(val);			\
 })
@@ -209,6 +210,8 @@ static inline uint64_t fio_swap64(uint64_t val)
 #define le64_to_cpu(val) ({			\
 	__le64_to_cpu(val);				\
 })
+#endif
+
 #define cpu_to_le16(val) ({			\
 	__cpu_to_le16(val);			\
 })
-- 
1.7.10.4

