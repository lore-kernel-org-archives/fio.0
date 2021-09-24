Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B256C433EF
	for <fio@archiver.kernel.org>; Fri, 24 Sep 2021 12:00:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0186060F9C
	for <fio@archiver.kernel.org>; Fri, 24 Sep 2021 12:00:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245069AbhIXMC1 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 24 Sep 2021 08:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244439AbhIXMC1 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 24 Sep 2021 08:02:27 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 731C8C061574
        for <fio@vger.kernel.org>; Fri, 24 Sep 2021 05:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=7jPFn0mT434LZNbwc7UcZnn4luQ0T99bA1T1pdsZZi0=; b=YmR0QjTW0+wGVhJAnSN4xpnnwx
        F4z9VjXq2lLKKrt3kS1jDBChfWz/MTlEYhArBCPkdOxJIwX44EAbBliYX9mDoVblS8QdhpPXY+tvl
        dIxo7HFOXZqi+KhF24iAob8C3BubJgR1Ee52qGj15cDNlJBTeIPaxsdB9dXLg4TJfLvEgTMVHoCYp
        0EDsSJfcqvC7aiU6yfrCLaVqAVrH7JBSFj1DXOvdM6giUCXi6RKRPIIwQ1TfRuFlrfEPrbgmIhZvj
        vfHgS2CLZk1+iRXCwswwisBE0KWb0+tAEvaOiJV9Awbri+mveyrYNu8pJe/1P+XMWnRPA5EOu6n1p
        i5UNb/9A==;
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mTjs5-0079wW-9W
        for fio@vger.kernel.org; Fri, 24 Sep 2021 12:00:21 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id C74771BC012A; Fri, 24 Sep 2021 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20210924120001.C74771BC012A@kernel.dk>
Date:   Fri, 24 Sep 2021 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit d9137307bc621280dcb1738e5df5d5ee4269a665:

  Merge branch 'one-core' of https://github.com/ErwanAliasr1/fio (2021-09-20 18:29:40 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c53476111d5ede61d24b3fa181fa2d19d3a3e6bc:

  t/io_uring: ensure batch counts are smaller or equal to depth (2021-09-23 09:15:16 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      t/io_uring: ensure batch counts are smaller or equal to depth

 t/io_uring.c | 5 +++++
 1 file changed, 5 insertions(+)

---

Diff of recent changes:

diff --git a/t/io_uring.c b/t/io_uring.c
index 1adb8789..af1b8fa8 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -617,6 +617,11 @@ int main(int argc, char *argv[])
 		}
 	}
 
+	if (batch_complete > depth)
+		batch_complete = depth;
+	if (batch_submit > depth)
+		batch_submit = depth;
+
 	submitter = calloc(nthreads, sizeof(*submitter) +
 				depth * sizeof(struct iovec));
 	for (j = 0; j < nthreads; j++) {
