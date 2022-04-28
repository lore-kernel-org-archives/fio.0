Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99A12C433F5
	for <fio@archiver.kernel.org>; Thu, 28 Apr 2022 20:40:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349931AbiD1Ung (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 28 Apr 2022 16:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237026AbiD1Unf (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 28 Apr 2022 16:43:35 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1494F29829
        for <fio@vger.kernel.org>; Thu, 28 Apr 2022 13:40:19 -0700 (PDT)
Received: from integral2.. (unknown [180.246.147.8])
        by gnuweeb.org (Postfix) with ESMTPSA id 4F5C87E39D;
        Thu, 28 Apr 2022 20:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1651178418;
        bh=IhGflcBLskqh6UhmitdEb7GIbwfcQNCnfEH0oYLs7dQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CKxalth96g5d56sBWaU6C96FSPbd7xv3eopEGDGk0tGOw0v59/8K1NyVH20AlA5PM
         O7LlQ5PwaSrhHWC6EOYl9GnmvoVymVEFJh1jyj81rptMtNwn9BGllyNUtS5gPBCbwz
         X+i2ak9QI75F4GtZGH6RRlTvMQwBQZPfPp73/k9feoDKAQ8jBnfN2EojYZtdW5xYXx
         HRh2gu36XhpRkJp1pR4I7mlCYcWaTseGkIQQlWDBjcqf6xV202Tfe0vnwuNvE95Q+V
         VmY0EhRq3ecaMn0WToMz2l0j6EtpCsxxqSKVefbSLhNbgu16FK8mp040R3bqH61SJ5
         s6CGU/NS0kriQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        fio Mailing List <fio@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH v3 3/3] Makefile: Suppress `-Wimplicit-fallthrough` when compiling `lex.yy`
Date:   Fri, 29 Apr 2022 03:39:54 +0700
Message-Id: <20220428203954.222165-4-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220428203954.222165-1-ammarfaizi2@gnuweeb.org>
References: <20220428203954.222165-1-ammarfaizi2@gnuweeb.org>
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

