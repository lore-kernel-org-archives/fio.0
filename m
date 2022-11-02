Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 474C5C43217
	for <fio@archiver.kernel.org>; Wed,  2 Nov 2022 12:00:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbiKBMAf (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 2 Nov 2022 08:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbiKBMAQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 2 Nov 2022 08:00:16 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60E882251C
        for <fio@vger.kernel.org>; Wed,  2 Nov 2022 05:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=N98zAsg7ChBxk0uVjlOnswYOfTrxCCdepbyTvNVhYU4=; b=Qiws57111/tFynip4oVOc3CGx7
        Xqscd8ia5nA4GILbFTop0khOnAo7u50FJ0uQmX1Se7P2fBoWVI3n4LvzXggVDr2tYlQjXK2lJVeXP
        KkTkNa2i9gapfz9BsFm9VEuxS8htrjubGHKWwWzg4mKo1f5lbt7U05jwrVDEsEbDZAZvVXlUW5+Ly
        bJ1dHq2FaYwMKde6yeSfo6QRUXgZlwVB/012wq8Sov7BwftUZnXTOQFHHeEIRTadQNe/jQ7CU3aKW
        moKhZdiKD86WPJDKeLdqFKBEpDcjUJJVEZh8yTw0/WbC+iR7clqEFtYjChFLNWuieNfhVtxeJAV7z
        CapAnCzw==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oqCPh-005UfQ-4L
        for fio@vger.kernel.org; Wed, 02 Nov 2022 12:00:09 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 296111BC012D; Wed,  2 Nov 2022 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20221102120002.296111BC012D@kernel.dk>
Date:   Wed,  2 Nov 2022 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit c4704c081a54160621227b42238f6e439c28fba3:

  test: add test for experimental verify with loops and time_based options (2022-10-24 10:34:57 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 73f168ea2c9a66145559c2217fc5a70c992cb80e:

  HOWTO: update description for flow option (2022-11-01 17:24:34 -0400)

----------------------------------------------------------------
Vincent Fu (1):
      HOWTO: update description for flow option

 HOWTO.rst | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index e89d05f0..53ae8c17 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -3329,13 +3329,13 @@ Threads, processes and job synchronization
 
 .. option:: flow=int
 
-	Weight in token-based flow control. If this value is used, then there is a
-	'flow counter' which is used to regulate the proportion of activity between
-	two or more jobs. Fio attempts to keep this flow counter near zero. The
-	``flow`` parameter stands for how much should be added or subtracted to the
-	flow counter on each iteration of the main I/O loop. That is, if one job has
-	``flow=8`` and another job has ``flow=-1``, then there will be a roughly 1:8
-	ratio in how much one runs vs the other.
+        Weight in token-based flow control. If this value is used, then fio
+        regulates the activity between two or more jobs sharing the same
+        flow_id. Fio attempts to keep each job activity proportional to other
+        jobs' activities in the same flow_id group, with respect to requested
+        weight per job. That is, if one job has `flow=3', another job has
+        `flow=2' and another with `flow=1`, then there will be a roughly 3:2:1
+        ratio in how much one runs vs the others.
 
 .. option:: flow_sleep=int
 
