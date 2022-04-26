Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BFC4C433F5
	for <fio@archiver.kernel.org>; Tue, 26 Apr 2022 21:21:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352911AbiDZVYi (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 26 Apr 2022 17:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355393AbiDZVYe (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 26 Apr 2022 17:24:34 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A29151F1F
        for <fio@vger.kernel.org>; Tue, 26 Apr 2022 14:21:25 -0700 (PDT)
Received: from integral2.. (unknown [180.246.147.8])
        by gnuweeb.org (Postfix) with ESMTPSA id B9E9C7E75B;
        Tue, 26 Apr 2022 21:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1651008085;
        bh=kMsLAhX3igfwO2drA96DmF1la3zOYbhCbENXa+PfQyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b811WTy9DF3tq+Wb/SHoQdxE3sk6KxItD6OKq/D5v87BLIxWdBhPN1Qa+EmsXGwsS
         V7arvvMefNt74HXXBVqIbD4n8+qJ1kODOzgAK93D5OdyO6sWhHX9X3/SzsJsxjAudA
         C+YhgJk7xk9/N/u6fwuEMRxqnl+okoulOMKt/OEm0Lx5sDfp2rZxhvK577Ct6J3Tya
         UPluEjNnoVT2949pAFPHZAZW08sQ9qUlmazIBd5XPqgZiAtSoD4r8W7Nqwvv/cNAuo
         PH9wibVjwJ+myx800V3Tuqj0U/SJu6sJz6AiAl6/w9NZSbGVCno4lBHm2gw44OLg+A
         5l/FzgwSBT1SQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     fio Mailing List <fio@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH v1 5/6] json: Change `if (!strlen(str))` to `if (!str[0])`
Date:   Wed, 27 Apr 2022 04:20:43 +0700
Message-Id: <20220426212044.78898-6-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220426212044.78898-1-ammarfaizi2@gnuweeb.org>
References: <20220426212044.78898-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

No need to traverse the whole string. Using `!strlen(str)` as a
conditional expression is effectively the same with `!str[0]`.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 json.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/json.c b/json.c
index cd3d5d74..8b650721 100644
--- a/json.c
+++ b/json.c
@@ -56,7 +56,7 @@ static char *strdup_escape(const char *str)
 	char *p, *ret;
 	int escapes;
 
-	if (!strlen(str))
+	if (!str[0])
 		return NULL;
 
 	escapes = 0;
-- 
Ammar Faizi

