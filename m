Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11933C433F5
	for <fio@archiver.kernel.org>; Wed, 27 Apr 2022 09:23:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbiD0J0w (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 27 Apr 2022 05:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiD0J0v (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 27 Apr 2022 05:26:51 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727A822B02
        for <fio@vger.kernel.org>; Wed, 27 Apr 2022 02:22:35 -0700 (PDT)
Received: from integral2.. (unknown [180.246.147.8])
        by gnuweeb.org (Postfix) with ESMTPSA id EF9B17E787;
        Wed, 27 Apr 2022 09:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1651050728;
        bh=lAW7sqkF/WHg8oPphy7X/CIjmN8AP+Po5P9TJnn13bY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z5HwdYOplp4YY3jHyZ+7hnEyYsZ62cJ3PuCwm+FJ/zxM7HWR0b4zeZHk2tYUeBbpC
         QA4+WULbXjdwJpIfWYqpwwmr5XhDnQ44Eju2irB+M+IINm2V92vQFf/TWvnPqAWlMZ
         pbmnj6ZtGsReEe+yggylBFMuzPYvPRDPreFHnHpkqLLngMWGhT3AAeYN3ffdWDN7Pd
         r/x/hco6bWlP+c4YrBKjrAURWFtUjbWJ1EiZ7oR//4k7IQnK8BqZ2JGqbcdiZwjyrr
         yZv4UPs4BIlTRnTZ4ksXSS33mJ5pCwO4HrQsdTc7V1LcTJh7laQbzV3dd7KOPiCnsN
         jzeMlGbTGnDWg==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     fio Mailing List <fio@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH v2 6/6] Makefile: Suppress `-Wimplicit-fallthrough` when compiling `lex.yy`
Date:   Wed, 27 Apr 2022 16:11:25 +0700
Message-Id: <20220427091125.114146-7-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220427091125.114146-1-ammarfaizi2@gnuweeb.org>
References: <20220427091125.114146-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

lex.yy.c is an auto generated C file. When compiling with clang-15, we
got the following warning:

```
      CC lex.yy.o
  lex.yy.c:1444:5: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
                                  case EOB_ACT_END_OF_FILE:
                                  ^
  lex.yy.c:1444:5: note: insert '__attribute__((fallthrough));' to silence this warning
                                  case EOB_ACT_END_OF_FILE:
                                  ^
                                  __attribute__((fallthrough));
  lex.yy.c:1444:5: note: insert 'break;' to avoid fall-through
                                  case EOB_ACT_END_OF_FILE:
                                  ^
                                  break;
  1 warning generated.
```

There is nothing we can do to fix lex.yy.c since it's an auto generated
file. Fix this by appending `-Wno-implicit-fallthrough` when compiling
this file if we have `-Wimplicit-fallthrough` flag enabled.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 Makefile | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index e670c1f2..1e15a69e 100644
--- a/Makefile
+++ b/Makefile
@@ -530,8 +530,12 @@ else
 	$(QUIET_LEX)$(LEX) $<
 endif
 
+ifneq (,$(findstring -Wimplicit-fallthrough,$(CFLAGS)))
+LEX_YY_CFLAGS := -Wno-implicit-fallthrough
+endif
+
 lex.yy.o: lex.yy.c y.tab.h
-	$(QUIET_CC)$(CC) -o $@ $(CFLAGS) $(CPPFLAGS) -c $<
+	$(QUIET_CC)$(CC) -o $@ $(CFLAGS) $(CPPFLAGS) $(LEX_YY_CFLAGS) -c $<
 
 y.tab.o: y.tab.c y.tab.h
 	$(QUIET_CC)$(CC) -o $@ $(CFLAGS) $(CPPFLAGS) -c $<
-- 
Ammar Faizi

