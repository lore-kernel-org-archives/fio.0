Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:32895 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754340AbdFWWIS (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 23 Jun 2017 18:08:18 -0400
Received: by mail-lf0-f66.google.com with SMTP id u62so7954887lfg.0
        for <fio@vger.kernel.org>; Fri, 23 Jun 2017 15:08:18 -0700 (PDT)
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 5/8] init: don't use void* for pointer arithmetic (gcc)
Date: Sat, 24 Jun 2017 01:07:58 +0300
Message-Id: <20170623220801.38178-6-tkusumi@tuxera.com>
In-Reply-To: <20170623220801.38178-1-tkusumi@tuxera.com>
References: <20170623220801.38178-1-tkusumi@tuxera.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

I think gcc extension should be avoided when it can be done by
just changing a pointer type.

(threads is a pointer to struct thread_data)

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init.c b/init.c
index 2b7768a..6efa5c1 100644
--- a/init.c
+++ b/init.c
@@ -361,7 +361,7 @@ static int setup_thread_area(void)
 #endif
 
 	memset(threads, 0, max_jobs * sizeof(struct thread_data));
-	fio_debug_jobp = (void *) threads + max_jobs * sizeof(struct thread_data);
+	fio_debug_jobp = (unsigned int *)(threads + max_jobs);
 	*fio_debug_jobp = -1;
 
 	flow_init();
-- 
2.9.4

