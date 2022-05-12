Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24A24C433F5
	for <fio@archiver.kernel.org>; Thu, 12 May 2022 16:44:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356622AbiELQoa (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 12 May 2022 12:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356633AbiELQo0 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 12 May 2022 12:44:26 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5716C268233
        for <fio@vger.kernel.org>; Thu, 12 May 2022 09:44:21 -0700 (PDT)
Received: from integral2.. (unknown [180.242.99.67])
        by gnuweeb.org (Postfix) with ESMTPSA id 3FED87F62E;
        Thu, 12 May 2022 16:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1652373861;
        bh=7L8RLQsdJnbdr2VgDtADGXZUb3D/RCbXhpE41rdG++I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L9bWWXTCaHa7nW63haDGXB5Pa8hwg8d+W/oG+8e8ua/RItQbsKFeoSX/RsoFKmpZs
         12jIS5n6uPvvLad7R2m5EIUk8LgK2z8YQcy7APyAJ4WvuSTTm5wdQf03hxRYgyem0a
         HAQb+L4ov3V3FBzikywPA/lXfgxn7GDTTN8eQUdXKgGzRzsJCOPblh6mr52ntGWwLp
         N7KF3t7nPDTKtuBy5m3NlsLiyhdFLekq7vPQlTnQcHI/bzowEuGZ0RiJY6H5zyrQwZ
         7QnvfTksklxhNv6DWsR/ZFpYKpdVAM0PDcfDkZelm+O/7VhVYLwHNmX6fH5SvzI/JU
         iDpn14cqqRgGg==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>,
        fio Mailing List <fio@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH v4 3/3] Makefile: Suppress `-Wimplicit-fallthrough` when compiling `lex.yy`
Date:   Thu, 12 May 2022 23:43:33 +0700
Message-Id: <20220512164333.46516-4-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220512164333.46516-1-ammarfaizi2@gnuweeb.org>
References: <20220512164333.46516-1-ammarfaizi2@gnuweeb.org>
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

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 Makefile | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 8495e727..ed66305a 100644
--- a/Makefile
+++ b/Makefile
@@ -535,8 +535,12 @@ else
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

