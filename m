Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B1FBC004C0
	for <fio@archiver.kernel.org>; Mon, 23 Oct 2023 12:00:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233444AbjJWMAV (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 23 Oct 2023 08:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233428AbjJWMAU (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 23 Oct 2023 08:00:20 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2987FE8
        for <fio@vger.kernel.org>; Mon, 23 Oct 2023 05:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=eTvKBrZ1Xs7+NZ2LOOyxcBk++0sVM1SXfEMoYTpPx98=; b=hOShpby8PNhvD7D2JXPOMhFUiK
        ar5YzUDOUCZQtAm9WLj6IBuv5rka+rFSvx7mbMY3FA3skPSyqjdDnmfWH9Wik6YeH3DvAFZ59j+2F
        DVvJxBEsBLPo2cokSnnna58cHlMhEheWrYno+WrxTqPptOEBLVWxFeOIG9WA18LdXqgjFfl37VTQZ
        F6N0D44uFDa3jim3dW+wZP5Pre5+iPlmdKgCoO/fDSuNCH6VrzcTi1biDqSk7TFG9tQtfDmeDaPPW
        YEh5O4k3CB5p76KvT7nwwrrsA7Umv7oq8xFMCMjuDzDgw7gQ8bMtDvdHALsDpMB1yEx5lMZRl5LCk
        0G9419dg==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qutbP-00ENtw-1T
        for fio@vger.kernel.org;
        Mon, 23 Oct 2023 12:00:11 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 9207F1BC017B; Mon, 23 Oct 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20231023120001.9207F1BC017B@kernel.dk>
Date:   Mon, 23 Oct 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit f8735bf1fb208bc1b6b1ca818413c9e41944e813:

  Merge branch 'master' of https://github.com/michalbiesek/fio (2023-10-20 04:32:39 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d4fdbe3fa91bbcc9583886af35b56cc7b691f8fa:

  Merge branch 'fix-riscv64-cpu-clock' of https://github.com/gilbsgilbs/fio (2023-10-22 18:52:51 -0600)

----------------------------------------------------------------
Gilbert Gilb's (1):
      riscv64: get clock from `rdtime` instead of `rdcycle`

Jens Axboe (1):
      Merge branch 'fix-riscv64-cpu-clock' of https://github.com/gilbsgilbs/fio

 arch/arch-riscv64.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/arch/arch-riscv64.h b/arch/arch-riscv64.h
index 9b8fd001..8ac33fa3 100644
--- a/arch/arch-riscv64.h
+++ b/arch/arch-riscv64.h
@@ -16,7 +16,7 @@ static inline unsigned long long get_cpu_clock(void)
 {
 	unsigned long val;
 
-	asm volatile("rdcycle %0" : "=r"(val));
+	asm volatile("rdtime %0" : "=r"(val));
 	return val;
 }
 #define ARCH_HAVE_CPU_CLOCK
