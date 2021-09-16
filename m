Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 549D4C433EF
	for <fio@archiver.kernel.org>; Thu, 16 Sep 2021 12:02:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33C2760EE5
	for <fio@archiver.kernel.org>; Thu, 16 Sep 2021 12:02:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238861AbhIPMDh (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 16 Sep 2021 08:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237820AbhIPMDg (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 16 Sep 2021 08:03:36 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2AE6C061574
        for <fio@vger.kernel.org>; Thu, 16 Sep 2021 05:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=NdSHiVawpmWOqv/k0Nbhe1AV9+1/S7PnFEnw5VzZxTg=; b=Fatfvso/B/Wz7n51U5TqOqNObP
        hBJcB/uf1nAOgKO+4bzr/eatFruskGTixWoSys8PIDBMESnTaxOPE5kwchEaH2sj3kkBD8xp3vm4u
        m77/+eyUwK1VjDrAc0Aqsr2m37/l0QFUCCFADclnsq7OA92/fn+7wB+EeMP3O47IND197w7Yb9WBU
        AnzoJfM5iQ0Yz9fcxZdW9QcwL0uFOYKdwJiYoYyw1hNYUNm6uh/wdY8HtucAWluNN0TKiCeXV+7F5
        Gew7AUhTP+N+RtcVEpmjuppRrBmvz3oBlPvGKFQ+8uMCZmN0c7YoH/NG+ZlFQgNaVfxM3Q4l+mLWJ
        7bqteBFg==;
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mQq3i-00GcmT-VX
        for fio@vger.kernel.org; Thu, 16 Sep 2021 12:00:55 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 60FDF1BC016F; Thu, 16 Sep 2021 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20210916120002.60FDF1BC016F@kernel.dk>
Date:   Thu, 16 Sep 2021 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit d5c3be105af97c71bc2095ffd19343e4217abcd7:

  zbd: remove dead zone retrieval call (2021-09-13 14:09:01 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2686fc2279c0e1272a48657dc62c16059a672da9:

  t/io_uring: add switch -O for O_DIRECT vs buffered (2021-09-15 06:51:01 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      t/io_uring: add switch -O for O_DIRECT vs buffered

 t/io_uring.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/t/io_uring.c b/t/io_uring.c
index aed6fdbd..0acbf0b4 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -554,9 +554,10 @@ static void usage(char *argv, int status)
 		" -B <bool> : Fixed buffers, default %d\n"
 		" -F <bool> : Register files, default %d\n"
 		" -n <int>  : Number of threads, default %d\n"
+		" -O <bool> : Use O_DIRECT, default %d\n"
 		" -N <bool> : Perform just no-op requests, default %d\n",
 		argv, DEPTH, BATCH_SUBMIT, BATCH_COMPLETE, BS, polled,
-		fixedbufs, register_files, nthreads, do_nop);
+		fixedbufs, register_files, nthreads, !buffered, do_nop);
 	exit(status);
 }
 
@@ -572,7 +573,7 @@ int main(int argc, char *argv[])
 	if (!do_nop && argc < 2)
 		usage(argv[0], 1);
 
-	while ((opt = getopt(argc, argv, "d:s:c:b:p:B:F:n:N:h?")) != -1) {
+	while ((opt = getopt(argc, argv, "d:s:c:b:p:B:F:n:N:O:h?")) != -1) {
 		switch (opt) {
 		case 'd':
 			depth = atoi(optarg);
@@ -605,6 +606,9 @@ int main(int argc, char *argv[])
 		case 'N':
 			do_nop = !!atoi(optarg);
 			break;
+		case 'O':
+			buffered = !atoi(optarg);
+			break;
 		case 'h':
 		case '?':
 		default:
