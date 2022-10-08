Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98053C433FE
	for <fio@archiver.kernel.org>; Sat,  8 Oct 2022 12:00:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbiJHMAN (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 8 Oct 2022 08:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiJHMAM (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 8 Oct 2022 08:00:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADD581CFEB
        for <fio@vger.kernel.org>; Sat,  8 Oct 2022 05:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=GM8Up7f3qXoUgap7LrlfEhWdOiZBJdmZuqf87sb8u0k=; b=NK93viRqVHNQFcGA7p0g8Eth2N
        A+dGSdpNHIhkCfvfsWbD3cRhPJWTYJiRGQH/siqcjqFF0QqBwdNOIaKXx/eJEf7R3aKc0c2FWtqVW
        R9jMlBSrDXL5fYqMTUWAAFqAtmD2RjJOl/rEKCXOCrwyODuu/p2a1L490fTJZTpD7Ju0NbFlUyLvx
        AMKzRgjxxg6qyOKxk1COkqXgZxPdk3tmfXMlmvE96vtVUupESo8ijoQAwUGW0PVXZFeSeyGA0leVE
        oa9hr4TdZgZpoPT7PyA+6NwwYsX5/jzVPc405wM8Zdeiu5n7HrncNd5c0i4LWyVp/jcuImev8d7K2
        sd+XbU8A==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oh8Uz-002fQA-3q
        for fio@vger.kernel.org; Sat, 08 Oct 2022 12:00:09 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 782351BC0128; Sat,  8 Oct 2022 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20221008120002.782351BC0128@kernel.dk>
Date:   Sat,  8 Oct 2022 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 7aeb498947d6f2d6c96b571520f12b80365fa8a1:

  test: make t0014.fio time_based (2022-10-05 18:34:41 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b19c5ee1357ffb74f4de57b1617364bbbaacf1a0:

  examples: uring-cmd-zoned: expand the reasoning behind QD1 (2022-10-07 09:50:37 -0400)

----------------------------------------------------------------
Pankaj Raghav (1):
      examples: uring-cmd-zoned: expand the reasoning behind QD1

 examples/uring-cmd-zoned.fio | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/examples/uring-cmd-zoned.fio b/examples/uring-cmd-zoned.fio
index 58e8f79e..89be61be 100644
--- a/examples/uring-cmd-zoned.fio
+++ b/examples/uring-cmd-zoned.fio
@@ -1,7 +1,11 @@
 # io_uring_cmd I/O engine for nvme-ns generic zoned character device
 #
-# NOTE: with write workload iodepth must be set to 1 as there is no IO
-# scheduler.
+# NOTE:
+# Regular writes against a zone should be limited to QD1, as the device can
+# reorder the requests.
+#
+# As the passthrough path do not use an IO scheduler (such as mq-deadline),
+# the queue depth should be limited to 1 to avoid zone invalid writes.
 
 [global]
 filename=/dev/ng0n1
