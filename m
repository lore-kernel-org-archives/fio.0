Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E187EC77B6F
	for <fio@archiver.kernel.org>; Tue, 11 Apr 2023 12:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbjDKMAK (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 11 Apr 2023 08:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjDKMAK (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 11 Apr 2023 08:00:10 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F84C2712
        for <fio@vger.kernel.org>; Tue, 11 Apr 2023 05:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=aopmG81ZouPJabmzZ76EP1bD1JMLVUv9fmcyyrXmdAI=; b=gHwsTsGXvx1Y+9hVYSWdwg3WZC
        fVJMyAwtRmED4FRMABOB+CiiTleSbxfH//Y2e5x9Qm8j8UjZgCuL6usT4hHRsevldhh9ASeJM3HoC
        Nwudkqy0gG+01tmAcxNdxMp+Y+bgikbAz8rSXTT9yMU/sbijV+BqZ/d2ifSO3MXb6Ujgvvm0CV8GT
        1wnKeo536BUjv8z5tRB/xAX7FI0ZLdsgJRfDWrChGTF9uviowd5D9DsMzKRAupt5Ap1mL71EdXGhg
        GqgAhsGhhUg2bX2JM4mUNBRuGpViny0951CMgFxoV30C/n/Vo/O96CzOe9eksK4cZdeFf8BBacpjg
        qVB10ISQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pmCfN-00DL2b-0E
        for fio@vger.kernel.org;
        Tue, 11 Apr 2023 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 0A3841BC016E; Tue, 11 Apr 2023 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230411120002.0A3841BC016E@kernel.dk>
Date:   Tue, 11 Apr 2023 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 2bb86015831c3ef3f8a077f417ad79ed6998ed48:

  Merge branch 'libaio-hang' of https://github.com/lrumancik/fio (2023-04-07 16:42:07 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 07ed2b57741afa53afa7b2b9fa742c652f1ed8c1:

  Merge branch 'libaio-hang' of https://github.com/lrumancik/fio (2023-04-10 15:40:45 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'libaio-hang' of https://github.com/lrumancik/fio

Leah Rumancik (1):
      engines/io_uring: update getevents max to reflect previously seen events

 engines/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index f10a4593..7f743c2a 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -529,6 +529,7 @@ static int fio_ioring_getevents(struct thread_data *td, unsigned int min,
 		r = fio_ioring_cqring_reap(td, events, max);
 		if (r) {
 			events += r;
+			max -= r;
 			if (actual_min != 0)
 				actual_min -= r;
 			continue;
