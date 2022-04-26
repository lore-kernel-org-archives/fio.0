Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2504CC433F5
	for <fio@archiver.kernel.org>; Tue, 26 Apr 2022 21:21:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346390AbiDZVY1 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 26 Apr 2022 17:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237364AbiDZVYZ (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 26 Apr 2022 17:24:25 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F591444F2
        for <fio@vger.kernel.org>; Tue, 26 Apr 2022 14:21:17 -0700 (PDT)
Received: from integral2.. (unknown [180.246.147.8])
        by gnuweeb.org (Postfix) with ESMTPSA id E7BB37E79F;
        Tue, 26 Apr 2022 21:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1651008077;
        bh=GMIrhIHR94G7iYaT4pAXW1sl+JI8lPQNGrFANoaKs/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BW9ngXvGyUCy1CiQk2MUIrU3MX5JycW9ieZ+Am3k0R8rlHaTjFNZ7ywtctNpVKrxt
         GHa/l4jB3oCP5baULFUxwOBfxujdCcLHxd+oRhfznehk5jFxvfkcrh9jecKjzrCNvK
         yHRRwmuvoxIplXJMOkWRgAhFC6eLePt72iAaTunFwLTLaP0ZgIsTeFKlM+cegKnbYK
         jFPQ9hV5tB20l0bLQ8+epaQq4wCBdEqVdhctwgN1O6CctHZnoKcKbvKDzhZUrK/drg
         DPGoiyVXtvmqwAr0vYeZ/S6Y/pttR3Zg6CDGuhbLFozR3lWmp4aFKHPSEG5uvp8OyF
         hbKdLW5Nx3cgQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     fio Mailing List <fio@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH v1 1/6] backend: Fix indentation
Date:   Wed, 27 Apr 2022 04:20:39 +0700
Message-Id: <20220426212044.78898-2-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220426212044.78898-1-ammarfaizi2@gnuweeb.org>
References: <20220426212044.78898-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

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

