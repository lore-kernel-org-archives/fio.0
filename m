Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B7AEC433FE
	for <fio@archiver.kernel.org>; Wed, 27 Apr 2022 11:08:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231961AbiD0LLo (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 27 Apr 2022 07:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232331AbiD0LLW (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 27 Apr 2022 07:11:22 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B14C3AA7A
        for <fio@vger.kernel.org>; Wed, 27 Apr 2022 04:08:07 -0700 (PDT)
Received: from integral2.. (unknown [180.246.147.8])
        by gnuweeb.org (Postfix) with ESMTPSA id 340FB7E7AA;
        Wed, 27 Apr 2022 09:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1651050726;
        bh=/piwTpnIAFT82W4vT5Uz7c9cHlIyRYn1CP6dOFX7cn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rHUl/lcn0umeO4noKIo17srbLq63hy93TQkKWXKggsB048zUr8UaHOcPVbqWbOxwJ
         mr01pekvrqJ6guC+3Vw1lgK+4Nw5dmKibffiMtOixtxiqmsvgKanOOjLxV4lhzR/Hp
         8VARk44RPzx7gmlAvlnLfggCkFKA+AglU9/LUKws1AhcvWIIkA/4DPppGn381qp5N3
         7K8+paSPqRU3imLwwCECVF6b37k1YtCidYj4Zd5d8lo1qENd5iIR6Ll2g5LaRNMGxJ
         y+ieIQEBpxJMsUXZ2je0MIQzSlTIWbAsNP1lOAcqKEvzeebz4BHlucbSzG6Yx8u75f
         6zRsCU2TNPI4Q==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     fio Mailing List <fio@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH v2 5/6] json: Change `if (!strlen(str))` to `if (!str[0])`
Date:   Wed, 27 Apr 2022 16:11:24 +0700
Message-Id: <20220427091125.114146-6-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220427091125.114146-1-ammarfaizi2@gnuweeb.org>
References: <20220427091125.114146-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

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

