Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65C03C433F5
	for <fio@archiver.kernel.org>; Wed, 27 Apr 2022 09:23:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiD0J0O (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 27 Apr 2022 05:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiD0J0O (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 27 Apr 2022 05:26:14 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8218295A4A
        for <fio@vger.kernel.org>; Wed, 27 Apr 2022 02:22:02 -0700 (PDT)
Received: from integral2.. (unknown [180.246.147.8])
        by gnuweeb.org (Postfix) with ESMTPSA id 920B27E7A5;
        Wed, 27 Apr 2022 09:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1651050718;
        bh=F7Z675J2Hdg1vFoPzvsDZVmu3Iu50rh7XvcRLxUdQSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PEf5IR20m7TWwDx4TyxKR1sJM+yNdOJOvEWMmhNBae0fm3D1mq34xq+U9Z79klXLN
         Z+lda5EvXwkjcu9AHVHc3qArq9HsJCMNmZJY+UYQNzptNI+lawNB5+YYbvnfjBc8zT
         3GvHWBqgZpa8Pzj35BnZSRJmmkguWQvTQoWlTtIPsb4U939ahl+5JnXMq3yK6g4i1Z
         0AUe9kVXuFzYTZLIvYhyFHdILrhbu4bnF44jhUEOi9rAO5aCfrJbEXMVCkcmDZKjnd
         fJBTgRW7GpK6Zc6mNBXukWAF+LlZaLXQIdVV+PzWU4V91lyDgSx4O7ZcKDVX7zqbqp
         D1fuCE9GOhmrg==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     fio Mailing List <fio@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH v2 1/6] backend: Fix indentation
Date:   Wed, 27 Apr 2022 16:11:20 +0700
Message-Id: <20220427091125.114146-2-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220427091125.114146-1-ammarfaizi2@gnuweeb.org>
References: <20220427091125.114146-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 backend.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/backend.c b/backend.c
index 317e4f6c..071fd1d1 100644
--- a/backend.c
+++ b/backend.c
@@ -2021,7 +2021,7 @@ static void reap_threads(unsigned int *nr_running, uint64_t *t_rate,
 	for_each_td(td, i) {
 		int flags = 0;
 
-		 if (!strcmp(td->o.ioengine, "cpuio"))
+		if (!strcmp(td->o.ioengine, "cpuio"))
 			cputhreads++;
 		else
 			realthreads++;
-- 
Ammar Faizi

