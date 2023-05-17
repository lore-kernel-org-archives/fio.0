Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4BD3C7EE2E
	for <fio@archiver.kernel.org>; Wed, 17 May 2023 12:00:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbjEQMAb (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 17 May 2023 08:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231447AbjEQMA2 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 17 May 2023 08:00:28 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA7C61AF
        for <fio@vger.kernel.org>; Wed, 17 May 2023 05:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=Jz60oHelxo4J541QQl92mrUsAuzetUYCKJ9nZiUPSXU=; b=WKYJz1Qfy6VQ2kbtqPqzitOUGv
        uNFlxcL1tpgHrX00S5HOe87wPYhHtj8JxWywR0GmeDbEBKLBf43X8svuMTfSK7cLm5+DSRq0oFb8N
        S58Ml37UI0DuHBxSbGR9/ynmtdyo4I/RCIT5lHpRVCpndmaVIHGW83E0onDJF0NyqgiilTIlVh820
        VCjIxKaQegPWrBG4oFKujMjRsgES38O18lSDoEn1LoE+Ao2uzRfkUEu8XbeNNauixgq2iUMcocLRU
        vUWByLeqU2/9Z5bKjPmGcwGCf4sJXHOrbtQKZYSBHPI6KEd51N79rB08EdrJ4huHLJ8/Xd+k9tXHh
        If6PbQgg==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pzFpA-00DDMN-2q
        for fio@vger.kernel.org;
        Wed, 17 May 2023 12:00:09 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 9685A1BC012E; Wed, 17 May 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230517120001.9685A1BC012E@kernel.dk>
Date:   Wed, 17 May 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 83b2d4b78374055c3a2261136eedf03b5fbfc335:

  ci: stop testing Linux 32-bit builds (2023-05-15 08:51:27 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to be42eadd18fad2569dfc6517940db8bbe2469f6d:

  engines/io_uring: fix coverity issue (2023-05-16 09:01:57 -0600)

----------------------------------------------------------------
Ankit Kumar (1):
      engines/io_uring: fix coverity issue

 engines/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 90e5a856..ff64fc9f 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -1198,7 +1198,8 @@ static int fio_ioring_cmd_open_file(struct thread_data *td, struct fio_file *f)
 			FILE_SET_ENG_DATA(f, data);
 		}
 
-		lba_size = data->lba_ext ? data->lba_ext : (1 << data->lba_shift);
+		assert(data->lba_shift < 32);
+		lba_size = data->lba_ext ? data->lba_ext : (1U << data->lba_shift);
 
 		for_each_rw_ddir(ddir) {
 			if (td->o.min_bs[ddir] % lba_size ||
