Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE2B6C433EF
	for <fio@archiver.kernel.org>; Fri, 17 Sep 2021 12:01:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE8F3611C8
	for <fio@archiver.kernel.org>; Fri, 17 Sep 2021 12:01:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242509AbhIQMCa (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 17 Sep 2021 08:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242369AbhIQMCa (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 17 Sep 2021 08:02:30 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 835AFC061766
        for <fio@vger.kernel.org>; Fri, 17 Sep 2021 05:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=FxnWn7tbIctVBQog0ptxHarXcYcZTwkDHj4pWEaiaOM=; b=QpkVawM3dDlkZkwEHqaQBGVE5Y
        O64HODRkzTWmznoix0VvjXn2EyMsZURJaH78JSG1qZRKCz0LabkykwFzrVBbxZlbVuMuboXvIAYf5
        VeCt2r4bS0TOA8iWNLAuAFO/U0y9lClVitX0yPr9tBTc64n2obOTKbRBmY/9Ks3VOK99MGk1/kiOP
        A9wxSGpADgOldEkmZgItR63eNewDkJzEeTWX1eRbKRxL0KmxR8pxTnLQCPHQCCCiGgDIpfnW+9w89
        zDOQ7Kmx4e/B5e/rcnSPubNkYpVJjYw3ouiHjgsf+4jyhao04m3Qk4jUsut7bjE0AOox5E/czGpYu
        Ce7U/4pA==;
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mRCXH-000DEH-Do
        for fio@vger.kernel.org; Fri, 17 Sep 2021 12:00:38 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 1A1EC1BC015C; Fri, 17 Sep 2021 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20210917120002.1A1EC1BC015C@kernel.dk>
Date:   Fri, 17 Sep 2021 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 2686fc2279c0e1272a48657dc62c16059a672da9:

  t/io_uring: add switch -O for O_DIRECT vs buffered (2021-09-15 06:51:01 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f3057d268d98aeb638b659a284d087fb0c2f654c:

  t/io_uring: fix bandwidth calculation (2021-09-16 11:41:06 -0600)

----------------------------------------------------------------
Erwan Velu (1):
      t/io_uring: Reporting bandwidth

Jens Axboe (2):
      Merge branch 'bwps' of https://github.com/ErwanAliasr1/fio
      t/io_uring: fix bandwidth calculation

 t/io_uring.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/t/io_uring.c b/t/io_uring.c
index 0acbf0b4..1adb8789 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -727,6 +727,7 @@ int main(int argc, char *argv[])
 		unsigned long this_reap = 0;
 		unsigned long this_call = 0;
 		unsigned long rpc = 0, ipc = 0;
+		unsigned long iops, bw;
 
 		sleep(1);
 		for (j = 0; j < nthreads; j++) {
@@ -740,8 +741,13 @@ int main(int argc, char *argv[])
 		} else
 			rpc = ipc = -1;
 		file_depths(fdepths);
-		printf("IOPS=%lu, IOS/call=%ld/%ld, inflight=(%s)\n",
-				this_done - done, rpc, ipc, fdepths);
+		iops = this_done - done;
+		if (bs > 1048576)
+			bw = iops * (bs / 1048576);
+		else
+			bw = iops / (1048576 / bs);
+		printf("IOPS=%lu, BW=%luMiB/s, IOS/call=%ld/%ld, inflight=(%s)\n",
+				iops, bw, rpc, ipc, fdepths);
 		done = this_done;
 		calls = this_call;
 		reap = this_reap;
