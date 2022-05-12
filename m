Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D949EC433FE
	for <fio@archiver.kernel.org>; Thu, 12 May 2022 16:44:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356631AbiELQoW (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 12 May 2022 12:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356636AbiELQoU (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 12 May 2022 12:44:20 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB90B2685F6
        for <fio@vger.kernel.org>; Thu, 12 May 2022 09:44:16 -0700 (PDT)
Received: from integral2.. (unknown [180.242.99.67])
        by gnuweeb.org (Postfix) with ESMTPSA id 8A3047F62E;
        Thu, 12 May 2022 16:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1652373856;
        bh=amB2JGpE9Q9AlGgki7hCggr4UupqbE21rYBj7Tox8Tw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FV35S9IEG9ZDM1CmiBdK5+bjpRYQf6G95uIYatOMMJTSlHogN//zLwnzZ5xQGH+fs
         sgFN2PIAxMwpUYzXDr26F+Tw8+UdJpLNKxGqGtKsuLiDo5xD7bq+N8NezLevc7tajp
         I4nO2DQQcU4ErJRFBHa8rGvg3TvUrJzrqqlcjkKVj9MBIvsFeQ4mrROFZhDOAiBEEe
         qFEWx0UDT23fkmsAcM3weQaSC8MZJ0xzy3TQFomaNa3ZKg9UrZl1YSsFKJF4cuv+h9
         198nnR57qpiqQUVylU7exUGi7q779kVp5feqDSlAzTPRyF//CxVhiXkxghBORIrXK6
         V/eR9S/thVFyw==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>,
        fio Mailing List <fio@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH v4 1/3] backend: Fix indentation
Date:   Thu, 12 May 2022 23:43:31 +0700
Message-Id: <20220512164333.46516-2-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220512164333.46516-1-ammarfaizi2@gnuweeb.org>
References: <20220512164333.46516-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 backend.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/backend.c b/backend.c
index ffbb7e2a..e5bb4e25 100644
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

