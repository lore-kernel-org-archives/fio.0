Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B870AC433FE
	for <fio@archiver.kernel.org>; Thu,  3 Nov 2022 12:00:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbiKCMAM (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 3 Nov 2022 08:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbiKCMAK (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 3 Nov 2022 08:00:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6777112AB2
        for <fio@vger.kernel.org>; Thu,  3 Nov 2022 05:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=WbeLjmho9GA+S5mWoca7sqLHG93pqiDXHqaDQXupqHw=; b=DZAfZ3KdR1mYdVudBpsE8WUv6b
        YBuiHzVLu/UALyjik0TQMQF+zs1lsLXy08h3UQqVmTYYqYw6hwuK4EcqHmjG7Y+esMT++TJxbzlNN
        x9YJ5M4BKTS1VvY2YHQ3fwP2y+a9O7l3WpjF6njW8Io/tQXul+sVskEM4boEaJQivu6GAEaOAdiHM
        o4F2RRNJdlQAInQYL79K4UNd9h5Gck0SOxNDfTOqelU1Rs/C7I69Jih9MNjPTDepq9Ywkkuc2MnRQ
        UCEf8C+3We/cnFaSRb0paFFww2ly4IlmN2ZG2+WcJs80huAiM6Jw+V7rvAG0kmayYqgQfnXrygwu7
        CUsxAtpg==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oqYtH-006Qyx-PO
        for fio@vger.kernel.org; Thu, 03 Nov 2022 12:00:12 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id EBA151BC0167; Thu,  3 Nov 2022 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20221103120001.EBA151BC0167@kernel.dk>
Date:   Thu,  3 Nov 2022 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 73f168ea2c9a66145559c2217fc5a70c992cb80e:

  HOWTO: update description for flow option (2022-11-01 17:24:34 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 7fc3a553beadd15cac09b1514547c4d382d292d9:

  HOWTO: clean up exit_what description (2022-11-02 10:26:36 -0400)

----------------------------------------------------------------
Vincent Fu (1):
      HOWTO: clean up exit_what description

 HOWTO.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 53ae8c17..0fb5593e 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -3356,10 +3356,10 @@ Threads, processes and job synchronization
 	make fio terminate all jobs in the same group, as soon as one job of that
 	group finishes.
 
-.. option:: exit_what
+.. option:: exit_what=str
 
 	By default, fio will continue running all other jobs when one job finishes.
-	Sometimes this is not the desired action. Setting ``exit_all`` will
+	Sometimes this is not the desired action. Setting ``exitall`` will
 	instead make fio terminate all jobs in the same group. The option
         ``exit_what`` allows to control which jobs get terminated when ``exitall`` is
         enabled. The default is ``group`` and does not change the behaviour of
