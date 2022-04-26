Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4408C433EF
	for <fio@archiver.kernel.org>; Tue, 26 Apr 2022 21:21:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346507AbiDZVYl (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 26 Apr 2022 17:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355397AbiDZVYh (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 26 Apr 2022 17:24:37 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 774E4152493
        for <fio@vger.kernel.org>; Tue, 26 Apr 2022 14:21:27 -0700 (PDT)
Received: from integral2.. (unknown [180.246.147.8])
        by gnuweeb.org (Postfix) with ESMTPSA id CAFC17E790;
        Tue, 26 Apr 2022 21:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1651008087;
        bh=e/Fdmte9Mm/Pr8AHosjrUIo9lGkvhgiA/qizii2Tt18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qa++ndkok2xp5Yd66pzSPzmkZD6TjagIsmmCCfWaR/JXil+em3psjb208wPitXfZh
         /wgtMkPX8LOX5OpAbzBGr1sp53Rl8T7UCCDI9cLEZGAwLVDNCTw9fYOj0rJbjU5Fg3
         erTeEhvDEHY5E6uXHP0oGOa1b0c5tJUtTKUFAXIvEXORKt0xISPoBlaflyO1R3Eh8L
         8co+fWJ/Q3G9poe47+IrbQmsA5CvoN+xtp9+/yrHxAyHy7C0s4Hi4M4BY+UZt8978t
         zljPoWGCq9x92ldN5P9iALoFIRSyWlwvCBdFaAV4JhN6OhPsXleclwQ3+9jmYSASD7
         0QfshpX3mSDNA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     fio Mailing List <fio@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH v1 6/6] Makefile: Suppress `-Wimplicit-fallthrough` when compiling `lex.yy`
Date:   Wed, 27 Apr 2022 04:20:44 +0700
Message-Id: <20220426212044.78898-7-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220426212044.78898-1-ammarfaizi2@gnuweeb.org>
References: <20220426212044.78898-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

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
file. Append `-Wno-implicit-fallthrough` when compiling this file if we
have -Wimplicit-fallthrough enabled.

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

