Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 151D3C4332F
	for <fio@archiver.kernel.org>; Wed, 19 Oct 2022 12:31:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiJSMbA (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 19 Oct 2022 08:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233023AbiJSMa3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 19 Oct 2022 08:30:29 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC35D18DD75
        for <fio@vger.kernel.org>; Wed, 19 Oct 2022 05:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=x4tmi+laCMc6bMzmX96MEnwaG856x2p9npnNiNz24V4=; b=SCkkaKp6icDC/gllSkSHStzCLs
        Hd0k+03qCBgmk6Pqaf+RGgwZuyMpkt6cZMOACnqu8DQ2QJeICr4R4nd53HLmoQ3kWJCNlrFhKJnCT
        uZyjO4GiyzivqWiW+zaIj3E1gUMmJ2wJKiMi+q8Z92wU2PF+mqJwqec61Wc/wA83LMYVLC5k7xB2c
        dcss3lZ7duXOp4g+hR4t8qIgxEFsoV6NUHBcBr6/4Y1GxDOrOBgGL3/GAb2Q3EBzCZUBCJCpGuhsP
        hwjY8EjhrvUVWCjdkbx5/67oO9GXA2OkEGE4KlDIa0uTTlh5LKgUFf22/RkTfyl1QlGQd3KUafeaj
        lf9TcpJw==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ol7k1-00BWMh-9t
        for fio@vger.kernel.org; Wed, 19 Oct 2022 12:00:09 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id AB0531BC0106; Wed, 19 Oct 2022 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20221019120001.AB0531BC0106@kernel.dk>
Date:   Wed, 19 Oct 2022 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 0360d61fbfcc1f07bcdc16672f5040f8cf49681f:

  t/zbd: add a CLI option to force io_uring (2022-10-16 17:05:03 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2f160e0c8848bab566427a11eee116d8e834bcf0:

  test: change GitHub actions checkout from v2 to v3 (2022-10-18 11:13:03 -0400)

----------------------------------------------------------------
Vincent Fu (1):
      test: change GitHub actions checkout from v2 to v3

 .github/workflows/ci.yml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/.github/workflows/ci.yml b/.github/workflows/ci.yml
index bdc4db85..1b8c0701 100644
--- a/.github/workflows/ci.yml
+++ b/.github/workflows/ci.yml
@@ -39,7 +39,7 @@ jobs:
 
     steps:
     - name: Checkout repo
-      uses: actions/checkout@v2
+      uses: actions/checkout@v3
     - name: Install dependencies
       run: ./ci/actions-install.sh
     - name: Build
