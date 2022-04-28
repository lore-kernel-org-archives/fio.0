Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB7DEC433F5
	for <fio@archiver.kernel.org>; Thu, 28 Apr 2022 20:40:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237015AbiD1Und (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 28 Apr 2022 16:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236992AbiD1Unc (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 28 Apr 2022 16:43:32 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36649205D7
        for <fio@vger.kernel.org>; Thu, 28 Apr 2022 13:40:17 -0700 (PDT)
Received: from integral2.. (unknown [180.246.147.8])
        by gnuweeb.org (Postfix) with ESMTPSA id 20C567E78A;
        Thu, 28 Apr 2022 20:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1651178416;
        bh=pC15MnaDsC3mIOnzRDiBqcjRGmNPboBoRcOKm4uYY/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b83RWWk8CgnSYT4VjQkuiYXEmvvUXnbxao5RKsEs1egHefhgl1wXiWBq/cFU5iKWp
         PpOR6y3ulzOnHoFj7jpplQV70c2ROrkrzOz89Kj6hayjHU8QLjOOHRcKKYPdkLVVG+
         eOhJkvNZMXlanMS4lc/SXcWTo8r0/gdUYsHyENH7CwgILpLYxnYfXNvfTgZKap7B7k
         kIIQimZxc6Er12K+H+rlHYFhsYI2iBE/AdqUOK3C2WxLHr5JJrXPHVxr5tGtEOUxik
         hAHkzlLx1dX47l1Mn9i9ggQdeiRiP9Ux82stCPkmTvgMDWNQHx8MIAfZUzoLH0BF6d
         tD8ym2Fy5ee5w==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        fio Mailing List <fio@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH v3 2/3] json: Change `if (!strlen(str))` to `if (!str[0])`
Date:   Fri, 29 Apr 2022 03:39:53 +0700
Message-Id: <20220428203954.222165-3-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220428203954.222165-1-ammarfaizi2@gnuweeb.org>
References: <20220428203954.222165-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

No need to traverse the whole string. Using `!strlen(str)` as a
*conditional expression* is effectively the same with `!str[0]`.

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

