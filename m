Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DC93C433EF
	for <fio@archiver.kernel.org>; Thu, 28 Apr 2022 20:40:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236990AbiD1Unb (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 28 Apr 2022 16:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236992AbiD1Una (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 28 Apr 2022 16:43:30 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF54713DCC
        for <fio@vger.kernel.org>; Thu, 28 Apr 2022 13:40:14 -0700 (PDT)
Received: from integral2.. (unknown [180.246.147.8])
        by gnuweeb.org (Postfix) with ESMTPSA id C97657E7AA;
        Thu, 28 Apr 2022 20:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1651178414;
        bh=GMIrhIHR94G7iYaT4pAXW1sl+JI8lPQNGrFANoaKs/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qouqex15FYNqfXsxP3KniY6qHm63+s/P8rDHpbo2P6Tyc7Qj74efyhSqH81Wh/oPD
         0mpO/6UpCgL1pWDsao5+ITUY+kC3Fi3NrVZQbcuv9pJycpXPsubhQs8ffIPwuxSoyv
         jIltEe61YWLpErQYA9n0HZ5fOrrjDkoo8WbXgwDwfJn9HitMLy5hOs2ISmotCfcqrM
         tLiQHZSEJZRSvuWl/NEB44/GHSR6MlUqoUMGY/Olq0vue6p+cWufb02ZZINn2KEbq3
         VNAGrU6Npz5oVk3945uGs/rUhEkVVimhrhKEpXMjEKpMmhSMALauWU/VSOjnJ4jqpL
         QwM1riiQtxWsw==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        fio Mailing List <fio@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH v3 1/3] backend: Fix indentation
Date:   Fri, 29 Apr 2022 03:39:52 +0700
Message-Id: <20220428203954.222165-2-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220428203954.222165-1-ammarfaizi2@gnuweeb.org>
References: <20220428203954.222165-1-ammarfaizi2@gnuweeb.org>
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

