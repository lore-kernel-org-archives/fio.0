Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:34010 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752397AbdDNVHU (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 14 Apr 2017 17:07:20 -0400
Received: by mail-lf0-f65.google.com with SMTP id x72so11004284lfb.1
        for <fio@vger.kernel.org>; Fri, 14 Apr 2017 14:07:19 -0700 (PDT)
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 8/9] Make oslib/strlcat.c a stand-alone library
Date: Sat, 15 Apr 2017 00:06:25 +0300
Message-Id: <20170414210626.32763-9-tkusumi@tuxera.com>
In-Reply-To: <20170414210626.32763-1-tkusumi@tuxera.com>
References: <20170414210626.32763-1-tkusumi@tuxera.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

It needs to include strlcat.h from local directory where strlcat.c
is also located, to be able to use this as a stand-alone library,
which is useful for debugging purpose. In fact, most of the files
under oslib/ directory do things this way.

--
 # cat ./test9.c
 #include <stdio.h>
 #include "oslib/strlcat.h"
 int main(void) {
         /* just to see if it compiles */
         strlcat(NULL, NULL, 0);
         return 0;
 }
 # gcc -Wall -g ./test9.c ./oslib/strlcat.c

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 oslib/strlcat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/oslib/strlcat.c b/oslib/strlcat.c
index 3329b83..3b33d0e 100644
--- a/oslib/strlcat.c
+++ b/oslib/strlcat.c
@@ -1,5 +1,5 @@
 #include <string.h>
-#include "oslib/strlcat.h"
+#include "strlcat.h"
 
 size_t strlcat(char *dst, const char *src, size_t size)
 {
-- 
2.9.3

