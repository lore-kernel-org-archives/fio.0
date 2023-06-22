Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEFF8EB64DD
	for <fio@archiver.kernel.org>; Thu, 22 Jun 2023 12:00:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjFVMAg (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 22 Jun 2023 08:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbjFVMAd (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 22 Jun 2023 08:00:33 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9306F1FF1
        for <fio@vger.kernel.org>; Thu, 22 Jun 2023 05:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=fSGrVcYV655i7PG6LSQ5nmGOD5WqZYM01HMXD709ZFc=; b=JQSuF2V7WHPZ4lOL3XqSwfwgYv
        N9K7/RlcZdqH/Op6z8npftCix1TaTQTSpNOkmgM59tTuZKh+J7pjZcLqaZOB1rnHJXilfhqFLPZye
        vPWp7cAdDGadZ8+3rVGmHOyUiYiygXClsj+atlRsxXV48ET5ZUnPKDd0ndtbHvR5CwVjLedV0oMYZ
        8lG7FasGkSCzfor0PJk6fiCvgcn8p9/9Onm4GlCxZ6xe773MlSJiZFZ9jIz7VCfxHyIxNY92D1k3l
        qweaGqdUKPKw8NxstNoQmiTl5gWM+AN+1yf2iXPhq1J00/CFjLJWKlLw32Jd2xiyZolR9Qzb0pwE7
        gdEjLT8w==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qCIyq-00FZbZ-Ix
        for fio@vger.kernel.org; Thu, 22 Jun 2023 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id F045D1BC0136; Thu, 22 Jun 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230622120001.F045D1BC0136@kernel.dk>
Date:   Thu, 22 Jun 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 8ce9c4003aeaafa91c3278c1c7de4a32fadc5ea0:

  docs: clarify opendir description (2023-06-16 10:41:25 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5087502fb05b2b4d756045c594a2e09c2ffc97dc:

  init: don't adjust time units again for subjobs (2023-06-20 14:11:36 -0400)

----------------------------------------------------------------
Vincent Fu (1):
      init: don't adjust time units again for subjobs

 init.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

---

Diff of recent changes:

diff --git a/init.c b/init.c
index 437406ec..10e63cca 100644
--- a/init.c
+++ b/init.c
@@ -951,13 +951,16 @@ static int fixup_options(struct thread_data *td)
 	if (o->disable_slat)
 		o->slat_percentiles = 0;
 
-	/*
-	 * Fix these up to be nsec internally
-	 */
-	for_each_rw_ddir(ddir)
-		o->max_latency[ddir] *= 1000ULL;
+	/* Do this only for the parent job */
+	if (!td->subjob_number) {
+		/*
+		 * Fix these up to be nsec internally
+		 */
+		for_each_rw_ddir(ddir)
+			o->max_latency[ddir] *= 1000ULL;
 
-	o->latency_target *= 1000ULL;
+		o->latency_target *= 1000ULL;
+	}
 
 	/*
 	 * Dedupe working set verifications
