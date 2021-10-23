Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69701C433EF
	for <fio@archiver.kernel.org>; Sat, 23 Oct 2021 12:00:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CF8360F9C
	for <fio@archiver.kernel.org>; Sat, 23 Oct 2021 12:00:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbhJWMC1 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 23 Oct 2021 08:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbhJWMC1 (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 23 Oct 2021 08:02:27 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3012C061764
        for <fio@vger.kernel.org>; Sat, 23 Oct 2021 05:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=Y3RkPIBe+LthTB1Q1zQf7GyRX5HFP1LkmWIEL8A7Z7U=; b=TgOA+CpEx+G21diWctDBdpvP9M
        lVpqRx54Rbx2Epe/y2u2hQ9O4K2SYwFgd83KuLYVzJ1eEika12i9WVk15fr6AE/i5OiiTB/qkJiMQ
        kKteSHssa6qEriMrM1ieF59KTnbQUX8TUAWGdLHCs8zuQzIAAM8nIP9wjAT7zOET3fjwbsS2f4sGg
        D3hNLcuBeSRaE6YTJ6DfosKObNWrqKwrmuHXXdl8VnH4uGiG8bw9dqgh6okIF3CA37TnnX2wjJo1Y
        znB8IaEoI1hUTUEMGEgLi+PvzYnG7LmfS/GtpymCEjlWH/PeoBNJKXZQuTIATmQjlxjlew/GgI64m
        n6q4BWLA==;
Received: from [65.144.74.35] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1meFgz-00Bkhv-6N
        for fio@vger.kernel.org; Sat, 23 Oct 2021 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id B33411BC0139; Sat, 23 Oct 2021 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20211023120001.B33411BC0139@kernel.dk>
Date:   Sat, 23 Oct 2021 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 09d0a62931df0bb7ed4ae92b83a245e35d04100a:

  Merge branch 'patch-1' of https://github.com/sweettea/fio (2021-10-19 16:09:21 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 515418094c61cf135513a34651af6134a8794b5d:

  Merge branch 'master' of https://github.com/bvanassche/fio (2021-10-22 10:19:04 -0600)

----------------------------------------------------------------
Bart Van Assche (1):
      Android: Add io_uring support

Jens Axboe (1):
      Merge branch 'master' of https://github.com/bvanassche/fio

 Makefile        | 2 +-
 os/os-android.h | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index f28c130a..4ae5a371 100644
--- a/Makefile
+++ b/Makefile
@@ -233,7 +233,7 @@ endif
 endif
 ifeq ($(CONFIG_TARGET_OS), Android)
   SOURCE += diskutil.c fifo.c blktrace.c cgroup.c trim.c profiles/tiobench.c \
-		oslib/linux-dev-lookup.c
+		oslib/linux-dev-lookup.c engines/io_uring.c
 ifdef CONFIG_HAS_BLKZONED
   SOURCE += oslib/linux-blkzoned.c
 endif
diff --git a/os/os-android.h b/os/os-android.h
index 18eb39ce..10c51b83 100644
--- a/os/os-android.h
+++ b/os/os-android.h
@@ -309,4 +309,8 @@ static inline int fio_set_sched_idle(void)
 }
 #endif
 
+#ifndef RWF_UNCACHED
+#define RWF_UNCACHED	0x00000040
+#endif
+
 #endif
