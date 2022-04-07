Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33689C433F5
	for <fio@archiver.kernel.org>; Thu,  7 Apr 2022 12:00:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234587AbiDGMCK (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 7 Apr 2022 08:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiDGMCJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 7 Apr 2022 08:02:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B881CAF33
        for <fio@vger.kernel.org>; Thu,  7 Apr 2022 05:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=KNEYNg/aEG0Hd+Hsnfrgk5fV+ra2yJyDUNxY1/GvqFI=; b=gHvzTn8Z+uyAc8cN0oM5kiL7ZY
        0mWkT1Z/EPvpOGBPpX3TAbaRSNR8NjZq3Caxqfp+hUED+HlQI5ixngB8ga1yNP7CpjnJh48mHr+CG
        wB8bWGPe+0xwxRnqk9Wsj8vAElNC5hQ6KX4v4RkeIboaxXMrk2Qloa91tC1FbYSTqbAD2Vo914c96
        aw3gJONl2yv6Pf7mT2UkkZSLNCkxJ8LOcF8iQts1g/tJjLUIVHRqy+NarBz9VU7qxUpHY91BciYCo
        YhOpQdkH7crRDQXu/05DfKcTdIfMStbSUwXCG8tTm5iEihiIU6uBcVnOr8WL1fo8jf0bV/EYOSMFk
        gBicXNqA==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ncQo2-008na3-18
        for fio@vger.kernel.org; Thu, 07 Apr 2022 12:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 489FE1BC0177; Thu,  7 Apr 2022 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220407120002.489FE1BC0177@kernel.dk>
Date:   Thu,  7 Apr 2022 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 06bbdc1cb857a11e6d1b7c089126397daca904fe:

  smalloc: fix ptr address in redzone error message (2022-04-05 11:47:35 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a3e48f483db27d20e02cbd81e3a8f18c6c5c50f5:

  Fio 3.30 (2022-04-06 17:10:00 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Fio 3.30

 FIO-VERSION-GEN | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 60f7bb21..fa64f50f 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-3.29
+DEF_VER=fio-3.30
 
 LF='
 '
