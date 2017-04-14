Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:35512 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752402AbdDNVHQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 14 Apr 2017 17:07:16 -0400
Received: by mail-lf0-f66.google.com with SMTP id i3so11016453lfh.2
        for <fio@vger.kernel.org>; Fri, 14 Apr 2017 14:07:15 -0700 (PDT)
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 3/9] Make lib/strntol.c a stand-alone library
Date: Sat, 15 Apr 2017 00:06:20 +0300
Message-Id: <20170414210626.32763-4-tkusumi@tuxera.com>
In-Reply-To: <20170414210626.32763-1-tkusumi@tuxera.com>
References: <20170414210626.32763-1-tkusumi@tuxera.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

It needs to include strntol.h from local directory where strntol.c
is also located, to be able to use this as a stand-alone library,
which is useful for debugging purpose. In fact, most of the files
under lib/ directory do things this way.

--
 # cat ./test5.c
 #include <stdio.h>
 #include "lib/strntol.h"
 int main(void) {
         /* just to see if it compiles */
         strntol(NULL, 0, NULL, 0);
         return 0;
 }
 # gcc -Wall -g ./test5.c ./lib/strntol.c

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 lib/strntol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/strntol.c b/lib/strntol.c
index adf45bd..f622c8d 100644
--- a/lib/strntol.c
+++ b/lib/strntol.c
@@ -2,7 +2,7 @@
 #include <stdlib.h>
 #include <limits.h>
 
-#include "lib/strntol.h"
+#include "strntol.h"
 
 long strntol(const char *str, size_t sz, char **end, int base)
 {
-- 
2.9.3

