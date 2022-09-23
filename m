Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AC3EC6FA82
	for <fio@archiver.kernel.org>; Fri, 23 Sep 2022 12:06:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbiIWMGc (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 23 Sep 2022 08:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231652AbiIWMET (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 23 Sep 2022 08:04:19 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 199046E8BD
        for <fio@vger.kernel.org>; Fri, 23 Sep 2022 05:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=aOTvz0s2VoGBlbeffeROTYPZzWJilAYqaFDSX6rD1ZY=; b=nQBiuRMjsVv5oJvWeCNIbc7sRB
        FFi6ZuII5iMlSgEJbacUabl3nTR5BWEKOPlB79kDKgKprBxFQm67fUxXnmWiur/YPBliUMB48Kbr1
        +XtX5LRGSbLtVC4dwe9RPLGuGU0m3/NZ3kiYL+SFX9efH1w2wN3Vd4OrkdET9DH/CPhWvRIcdPzsc
        aC5dr41h5Y+FxF8ftwnHt3R1ifiFBu0BhXVOJAP4R8RhTM8W6sXt0fTksEXDrK4YF2ocKoqMwVfYB
        sE1EJfQR+yhoDlXizPZm57me4He/pBNu9x/geTIOXuy6WGt1m+QZPDHWnMm4vRI3Om/qL129pPSEl
        wqOOkSwA==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1obhLh-00FD3G-5G
        for fio@vger.kernel.org; Fri, 23 Sep 2022 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 72AB61BC0124; Fri, 23 Sep 2022 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220923120002.72AB61BC0124@kernel.dk>
Date:   Fri, 23 Sep 2022 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit d14687025c0c61d047e4252036d1b024d62cb0a6:

  configure: change grep -P to grep -E (2022-09-19 09:42:14 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 0574e8c3b2b47e1e2564c2f50ea0b6f2629f2e48:

  arm64: ensure CPU clock retrieval issues isb() (2022-09-22 10:03:51 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      arm64: ensure CPU clock retrieval issues isb()

 arch/arch-aarch64.h | 3 +++
 1 file changed, 3 insertions(+)

---

Diff of recent changes:

diff --git a/arch/arch-aarch64.h b/arch/arch-aarch64.h
index 951d1718..919e5796 100644
--- a/arch/arch-aarch64.h
+++ b/arch/arch-aarch64.h
@@ -27,10 +27,13 @@ static inline int arch_ffz(unsigned long bitmask)
 
 #define ARCH_HAVE_FFZ
 
+#define isb()	asm volatile("isb" : : : "memory")
+
 static inline unsigned long long get_cpu_clock(void)
 {
 	unsigned long val;
 
+	isb();
 	asm volatile("mrs %0, cntvct_el0" : "=r" (val));
 	return val;
 }
