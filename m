Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62179C433EF
	for <fio@archiver.kernel.org>; Thu, 12 May 2022 16:44:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356623AbiELQoV (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 12 May 2022 12:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356635AbiELQoU (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 12 May 2022 12:44:20 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3442685D3
        for <fio@vger.kernel.org>; Thu, 12 May 2022 09:44:19 -0700 (PDT)
Received: from integral2.. (unknown [180.242.99.67])
        by gnuweeb.org (Postfix) with ESMTPSA id D9D757F629;
        Thu, 12 May 2022 16:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1652373858;
        bh=ayuXrihff8eK7caf2Wz1Zmx91AhIjZLaFydT/wzpk9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EY2LNBqpTVE9f2jO8nI9ki0UA2u+tfAu/XrHvL5FDzmqOecINv8RvturVtQ4h/0lH
         pRNwoqpB8W/2JodnmmAODm4lXuOzEfz5eGEtI/mwuw4440WR+nuP8EXgQJ2vpunG0f
         qH+w4iDPkhWNQ5hndAg4enLfGNkzUvXEV+hfxQhDwGgFgWEj816nw6qRU1RWsczR29
         sSGnLhiY5XwTgPB9Of+dI375zmJVFUKfmCwY/CQaNtHLsEd0x2PhGFgzjSqK7t5XWl
         jUUwqzkbmG+8KOHtxyURIG9S/Rs9wYTC+I3/R3hkMrgrXvPrAc/q+giT5+Palx/hmz
         fZUA5g2CERt3g==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>,
        fio Mailing List <fio@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH v4 2/3] json: Change `if (!strlen(str))` to `if (!str[0])`
Date:   Thu, 12 May 2022 23:43:32 +0700
Message-Id: <20220512164333.46516-3-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220512164333.46516-1-ammarfaizi2@gnuweeb.org>
References: <20220512164333.46516-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

No need to traverse the whole string. Using `!strlen(str)` as a
*conditional expression* is effectively the same with `!str[0]`.

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
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

