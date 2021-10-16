Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B465C433EF
	for <fio@archiver.kernel.org>; Sat, 16 Oct 2021 12:00:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F48C6115C
	for <fio@archiver.kernel.org>; Sat, 16 Oct 2021 12:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240327AbhJPMCS (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 16 Oct 2021 08:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237354AbhJPMCR (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 16 Oct 2021 08:02:17 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE1AEC061570
        for <fio@vger.kernel.org>; Sat, 16 Oct 2021 05:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=m6SkR6vi99efPdIfElCEvaUi/163Xgo0TfU4ejkz+JE=; b=IPcxwjnrsc48HHQzXQDHHYc8CL
        Go3LBFi/r9yNG8FRP8bPq5IdlqnwpAcJT0astNHCpFegNiQc8jpb0oRmsz2ElE4zR08SD8BVztX5u
        l8nlpbnRViC6P6p6MUBUQ7v69UOejsOWjOPuR2dVES1cDE5KkwkxzIdwcNbJefLzZnaN1QHP9HDZO
        8aeGoKueaK1L0kq8P7lhCa6VeTgfhl4VrpNj+oa3ZPWID0TmqhwrFK55jy2gDscqVqhpcmA6Jz5Ch
        A4+QW89zM/liIhTjA8Sa5mMJh0wb95yedt4IsS9DMoCKP/AXDuhaqwqJ+HwLADeXEJsL/73YzEk0X
        V10xlsLw==;
Received: from [65.144.74.35] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mbiMB-00ABTO-OU
        for fio@vger.kernel.org; Sat, 16 Oct 2021 12:00:08 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id C623E1BC015D; Sat, 16 Oct 2021 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20211016120001.C623E1BC015D@kernel.dk>
Date:   Sat, 16 Oct 2021 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 246054544cc74b56b063640ecb538893ea613936:

  Merge branch 'evelu-typo' of https://github.com/ErwanAliasr1/fio (2021-10-14 15:01:30 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 7d1ce4b752e67868b3c7eb9aa5972ceec51210aa:

  t/io_uring: Fix the parameters calculation for multiple threads scenario (2021-10-15 06:20:47 -0600)

----------------------------------------------------------------
Pankaj Raghav (1):
      t/io_uring: Fix the parameters calculation for multiple threads scenario

 t/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

---

Diff of recent changes:

diff --git a/t/io_uring.c b/t/io_uring.c
index 5a80e074..a87042f8 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -1348,6 +1348,7 @@ int main(int argc, char *argv[])
 			stats_running = 1;
 
 		for (j = 0; j < nthreads; j++) {
+			s = get_submitter(j);
 			this_done += s->done;
 			this_call += s->calls;
 			this_reap += s->reaps;
