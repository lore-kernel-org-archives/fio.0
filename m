Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0E9FC433F5
	for <fio@archiver.kernel.org>; Sat, 25 Sep 2021 12:00:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C242461100
	for <fio@archiver.kernel.org>; Sat, 25 Sep 2021 12:00:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244519AbhIYMBo (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 25 Sep 2021 08:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237275AbhIYMBn (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 25 Sep 2021 08:01:43 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24329C061570
        for <fio@vger.kernel.org>; Sat, 25 Sep 2021 05:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=GtwbNWqr5y//JTnbsiBlvx09DtCB2UB+MORdc2CPzrI=; b=Aeg3rHzZanyu7N13e1peCNZUbT
        /S+nq8JScEnV5H2NdiFlZ/w4KJMVdC+1w3fUmjLVrmC/euY/k08Gok6Gj1WFtbgE75RvFPpiy3bfT
        Mi6MDxVWWgmfgd8KyxCGEQnkfzu8ocTmdnLcKsLOW7UCXpqB3EoIZ30Kk+2bo2L5q0mWGSdPrp3kh
        xMGiOa4ZIfPTXlJcYgxo37fynOTW9o2OHWPRf1bCwtfFt7LaLLOFY+j6mI81Zj6rxBWNVjTOJ0feg
        iPmD/t2m3mtjTlvJSOr4mYW2i9PCXhqZKRWZPxndlj2gg5AKCHmN3cYBmlIlbx56RqX6ojaamzDxg
        R0XJKuZA==;
Received: from [65.144.74.35] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mU6Lc-005lfM-Rb
        for fio@vger.kernel.org; Sat, 25 Sep 2021 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 83E651BC015D; Sat, 25 Sep 2021 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20210925120001.83E651BC015D@kernel.dk>
Date:   Sat, 25 Sep 2021 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit c53476111d5ede61d24b3fa181fa2d19d3a3e6bc:

  t/io_uring: ensure batch counts are smaller or equal to depth (2021-09-23 09:15:16 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6c5d3a1c08bda1bbf22187c7b80573400e1c1053:

  t/io_uring: don't print BW numbers for do_nop (2021-09-24 15:17:44 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      t/io_uring: don't print BW numbers for do_nop

 t/io_uring.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/t/io_uring.c b/t/io_uring.c
index af1b8fa8..d5636380 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -751,8 +751,10 @@ int main(int argc, char *argv[])
 			bw = iops * (bs / 1048576);
 		else
 			bw = iops / (1048576 / bs);
-		printf("IOPS=%lu, BW=%luMiB/s, IOS/call=%ld/%ld, inflight=(%s)\n",
-				iops, bw, rpc, ipc, fdepths);
+		printf("IOPS=%lu, ", iops);
+		if (!do_nop)
+			printf("BW=%luMiB/s, ", bw);
+		printf("IOS/call=%ld/%ld, inflight=(%s)\n", rpc, ipc, fdepths);
 		done = this_done;
 		calls = this_call;
 		reap = this_reap;
