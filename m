Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BC6AC433F5
	for <fio@archiver.kernel.org>; Wed,  9 Feb 2022 13:00:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbiBINAE (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 9 Feb 2022 08:00:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233764AbiBINAE (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 9 Feb 2022 08:00:04 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB01C0613CA
        for <fio@vger.kernel.org>; Wed,  9 Feb 2022 05:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=qtZ/hrvyjP7qHgS9rlNSasLQHgl3i8VgF5JCqBpAjZA=; b=MeRPFGlLJUi7Jy2pSAWV4wkh+p
        YdWM3yZpG1AOsUieCWIRyFe1SvFcQL0qUj+D4a/dPRQv4H9jQ5qfpi5r4JgsqhxqirbUEZSysitUD
        51ThUOh7BNt8uT50i722RBVtu6zT5ABXLsaNV0RkJrrOHGjGdL70w+a3VozA0LZ/J6HyNsUazGUvy
        7m5O2nxIekgc0+zMA4blG7Csu+SwzAcz/KlpDllYhGYfK6u26OxnbJ0/o7hmR1i/1D5fCZxk/9+MZ
        8D+pssUU9eSux33mDR2zekKfk8DmAzdt2Y6e3EIfk9WTP/cqGRzyi9YS7+6hwjnuqDvGDbpAoQDcp
        gsC9ipWw==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nHmZo-008QVF-P0
        for fio@vger.kernel.org; Wed, 09 Feb 2022 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 0BBC81BC0181; Wed,  9 Feb 2022 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220209130002.0BBC81BC0181@kernel.dk>
Date:   Wed,  9 Feb 2022 06:00:02 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit b65c1fc07d4794920224312c56c785de2f3f1692:

  t/io_uring: fix warnings for !ARCH_HAVE_CPU_CLOCK (2022-02-04 09:02:49 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to df597be63e26ef59c1538b3ce2026c83684ff7fb:

  fio: really use LDFLAGS when linking dynamic engines (2022-02-08 09:28:30 -0700)

----------------------------------------------------------------
Eric Sandeen (1):
      fio: really use LDFLAGS when linking dynamic engines

 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 2432f519..0ab4f82c 100644
--- a/Makefile
+++ b/Makefile
@@ -295,7 +295,7 @@ define engine_template =
 $(1)_OBJS := $$($(1)_SRCS:.c=.o)
 $$($(1)_OBJS): CFLAGS := -fPIC $$($(1)_CFLAGS) $(CFLAGS)
 engines/fio-$(1).so: $$($(1)_OBJS)
-	$$(QUIET_LINK)$(CC) $(DYNAMIC) -shared -rdynamic -fPIC -Wl,-soname,fio-$(1).so.1 -o $$@ $$< $$($(1)_LIBS)
+	$$(QUIET_LINK)$(CC) $(LDFLAGS) -shared -rdynamic -fPIC -Wl,-soname,fio-$(1).so.1 -o $$@ $$< $$($(1)_LIBS)
 ENGS_OBJS += engines/fio-$(1).so
 endef
 else # !CONFIG_DYNAMIC_ENGINES
