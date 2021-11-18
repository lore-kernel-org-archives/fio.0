Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3821BC433FE
	for <fio@archiver.kernel.org>; Thu, 18 Nov 2021 13:03:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F0E961ABA
	for <fio@archiver.kernel.org>; Thu, 18 Nov 2021 13:03:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232695AbhKRNGC (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 18 Nov 2021 08:06:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232304AbhKRNEE (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 18 Nov 2021 08:04:04 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F38EC061766
        for <fio@vger.kernel.org>; Thu, 18 Nov 2021 05:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=Pd0lIaJ0tuhPXVvXPC4qCXPrbMMmxVXCm+dVVifb7YE=; b=F6VrADdLIC7JzS6OvA/3olVeHo
        Ws+Fkl8VXewHG64u0DEFdpsXkQNSuM3nC942AFrs0psbj9IqM2WNk+ZGKKNre2WhpT/N0G300ayj3
        RJPfNHFo/zxkuZT75g1QhMiCVrq95nB0vrQtVQeswvZ3067IWDihpQyWL0NHmt6B02vqqSWMLgLQ9
        upMGZcDjFaR6wEb9wMVqKtEAQ+17rH3KLIwIA+2EmZKozDKfInfEZI+nqNw882SDmXxoFQequ9E/B
        vfoUtB2R7s20/F+EPeYumvDQIZTNe+4jhl//MJ/Ec4sBgz+BAXgid+e60j6a5yOr3DMI66mZjz7EY
        Ra/bZbuQ==;
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mnh1I-008TXE-6V
        for fio@vger.kernel.org; Thu, 18 Nov 2021 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 6825A1BC014E; Thu, 18 Nov 2021 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20211118130002.6825A1BC014E@kernel.dk>
Date:   Thu, 18 Nov 2021 06:00:02 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit f7c3f31db877d30056d19761e48499f5b0bfa0b6:

  Merge branch 'jf_readme_typo' of https://github.com/jfpanisset/fio (2021-11-12 09:22:21 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5711325cbb37d10c21a6975d1f1ebea11799c05e:

  Makefile: Fix android compilation (2021-11-17 16:14:27 -0700)

----------------------------------------------------------------
Gwendal Grignou (1):
      Makefile: Fix android compilation

 Makefile | 1 +
 1 file changed, 1 insertion(+)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index e9028dce..04c1e0a7 100644
--- a/Makefile
+++ b/Makefile
@@ -236,6 +236,7 @@ endif
 ifeq ($(CONFIG_TARGET_OS), Android)
   SOURCE += diskutil.c fifo.c blktrace.c cgroup.c trim.c profiles/tiobench.c \
 		oslib/linux-dev-lookup.c engines/io_uring.c
+  cmdprio_SRCS = engines/cmdprio.c
 ifdef CONFIG_HAS_BLKZONED
   SOURCE += oslib/linux-blkzoned.c
 endif
