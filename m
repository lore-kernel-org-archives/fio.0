Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85476C433EF
	for <fio@archiver.kernel.org>; Tue, 19 Oct 2021 12:00:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6518E608FE
	for <fio@archiver.kernel.org>; Tue, 19 Oct 2021 12:00:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235425AbhJSMCU (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 19 Oct 2021 08:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235389AbhJSMCT (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 19 Oct 2021 08:02:19 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E673C06161C
        for <fio@vger.kernel.org>; Tue, 19 Oct 2021 05:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=W3I+R9Mggq92QNyLLIny5flxhuU7l03kjaRERT64oEA=; b=rTWcOY/hCGlJ5rThVoXVgRjBAm
        NK0TvYODDrwB0x+AjZlrWD7ALUKkpcPUPC4GL5QqQdRA68ahCGJvGaX6YsQSwarCJRwhQtD9Mz0OK
        USlkpnVRGJHTc6Q6l7VtW3O/AZp1dF+o4AIr7Lf8PYu7qH+pIpqQ5mbX9tqU4/rwj02U2RxotvGWE
        WU0hzc3yCJHuiCeSrMvD5GM/elSRg86ttYGhpk8q50IWVmtIN+G9S6UsJ9b0NNsNdWbGa2ZFjXPKt
        Oj0QFPygT4t5+0Bhh/RkTUSO34Thw6o442UUsecPvaUugkKAu+LlRj5SFzvvEoL8pSmFTVfIWKabG
        z32k7a5A==;
Received: from [65.144.74.35] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mcnmm-00AlgC-JD
        for fio@vger.kernel.org; Tue, 19 Oct 2021 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id E02D91BC0165; Tue, 19 Oct 2021 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20211019120001.E02D91BC0165@kernel.dk>
Date:   Tue, 19 Oct 2021 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit aa9f26276e1961fab2d33e188f5a2432360c9c14:

  run-fio-tests: make test runs more resilient (2021-10-17 07:22:55 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a7194b2d3d427e7e5678c55a128639df9caf4a48:

  Merge branch 'fixes_1290' of https://github.com/rthardin/fio (2021-10-18 19:29:46 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'fixes_1290' of https://github.com/rthardin/fio

Ryan Hardin (1):
      Use min_bs in rate_process=poisson

 backend.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 86fa6d41..c167f908 100644
--- a/backend.c
+++ b/backend.c
@@ -837,7 +837,7 @@ static long long usec_for_io(struct thread_data *td, enum fio_ddir ddir)
 	if (td->o.rate_process == RATE_PROCESS_POISSON) {
 		uint64_t val, iops;
 
-		iops = bps / td->o.bs[ddir];
+		iops = bps / td->o.min_bs[ddir];
 		val = (int64_t) (1000000 / iops) *
 				-logf(__rand_0_1(&td->poisson_state[ddir]));
 		if (val) {
