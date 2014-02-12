Return-Path: <fio-owner@vger.kernel.org>
Received: from mailout11.t-online.de ([194.25.134.85]:56049 "EHLO
	mailout11.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbaBLS0I (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 12 Feb 2014 13:26:08 -0500
From: "Daniel Gollub" <daniel.gollub@t-online.de>
Subject: [PATCH] Fix g++ warning about void* used in arithmetic
Date: Wed, 12 Feb 2014 19:25:42 +0100
Message-Id: <1392229542-14083-1-git-send-email-d.gollub@telekom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Daniel Gollub <d.gollub@telekom.de>

../parse.h: In function ‘void* td_var(thread_options*, fio_option*, unsigned int)’:
../parse.h:110:10: warning: pointer of type ‘void *’ used in arithmetic [-Wpointer-arith]
../parse.h:112:9: warning: pointer of type ‘void *’ used in arithmetic [-Wpointer-arith]

Signed-off-by: Daniel Gollub <d.gollub@telekom.de>
---
 parse.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/parse.h b/parse.h
index 5273d23..1009252 100644
--- a/parse.h
+++ b/parse.h
@@ -100,7 +100,7 @@ typedef int (fio_opt_str_val_fn)(void *, long long *);
 typedef int (fio_opt_int_fn)(void *, int *);
 typedef int (fio_opt_str_set_fn)(void *);
 
-#define __td_var(start, offset)	((void *) start + (offset))
+#define __td_var(start, offset)	((char *) start + (offset))
 
 struct thread_options;
 static inline void *td_var(struct thread_options *to, struct fio_option *o,
-- 
1.7.10.4

