Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 430F0C433EF
	for <fio@archiver.kernel.org>; Thu, 14 Oct 2021 12:00:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 248D5610EA
	for <fio@archiver.kernel.org>; Thu, 14 Oct 2021 12:00:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbhJNMCM (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 14 Oct 2021 08:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbhJNMCM (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 14 Oct 2021 08:02:12 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA1FFC061570
        for <fio@vger.kernel.org>; Thu, 14 Oct 2021 05:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=KNam9w8PaiWYXAYskmkXTXNTKd0G3aIvusbzmigiCGU=; b=TZeoEc+GKyH9Xcy2NhgCTbKoZd
        24b02g3l5+yZ6NofDwso3lJK6pyIDCpvDN3Bb8am4CM9OII6KSdEu9qL2NC9AvjSuGV8KZa9TIw8Z
        L3hCaDDFGjJl4dvLvLLxcsEBKSEmnkVl6hLeF5tN3mMJmZs8FKe9vGklZtmi/nTg1xf+e5pTt8VhX
        A6fozGHvF2tMRjX6meblxhIa7W0/omiS5TWW8Sgl+H7SZtkyzmpFhhQIzp/XBPiMPAfv6GkHQGz+L
        rTrxo3nIBDhl/0l08hxaodm48bjEDPc6Bf/+leH537xIY4cm/h6rMQF84QZO5lv/8AZXEPNwF3OGv
        t+0hVOxQ==;
Received: from [65.144.74.35] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mazP3-009pU2-J7
        for fio@vger.kernel.org; Thu, 14 Oct 2021 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 68F1B1BC012E; Thu, 14 Oct 2021 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20211014120002.68F1B1BC012E@kernel.dk>
Date:   Thu, 14 Oct 2021 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 702b0be2fe3b6cf5b3556920edaf0637a33b36e1:

  t/io_uring: update for new DMA map buffers API (2021-10-12 18:41:14 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 53b5fa1ea4f821899440637ab632ce0e1687c916:

  t/io_uring: don't append 'K' to IOPS if we don't divide by 1000 (2021-10-13 06:17:44 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      t/io_uring: don't append 'K' to IOPS if we don't divide by 1000

 t/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/t/io_uring.c b/t/io_uring.c
index 84960ba9..1b729ebf 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -1361,7 +1361,7 @@ int main(int argc, char *argv[])
 		if (iops > 100000)
 			printf("IOPS=%luK, ", iops / 1000);
 		else
-			printf("IOPS=%luK, ", iops);
+			printf("IOPS=%lu, ", iops);
 		if (!do_nop)
 			printf("BW=%luMiB/s, ", bw);
 		printf("IOS/call=%ld/%ld, inflight=(%s)\n", rpc, ipc, fdepths);
