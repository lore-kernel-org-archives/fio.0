Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728256AbhAPRKo (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 16 Jan 2021 12:10:44 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54710C061757
        for <fio@vger.kernel.org>; Sat, 16 Jan 2021 05:00:07 -0800 (PST)
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l0lBU-0006lE-Pj
        for fio@vger.kernel.org; Sat, 16 Jan 2021 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210116130001.A5F2A1BC00E9@kernel.dk>
Date: Sat, 16 Jan 2021 06:00:01 -0700 (MST)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 4008b7fc8e2bff60a4e98de0005e6bc71b1a8641:

  Merge branch 'zipf-pareto-lock' of https://github.com/aclamk/fio (2021-01-12 10:52:54 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e4d9a7bf68d0ffb9fd7ab328a4f0edddc89297be:

  Merge branch 'fix_keyword_sub' of https://github.com/sitsofe/fio (2021-01-15 20:52:57 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'fix_keyword_sub' of https://github.com/sitsofe/fio

Sitsofe Wheeler (1):
      options: fix keyword substitution heap overrun

 options.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/options.c b/options.c
index 47b20c24..0b4c48d6 100644
--- a/options.c
+++ b/options.c
@@ -5115,10 +5115,10 @@ static char *fio_keyword_replace(char *opt)
 			 * If there's more in the original string, copy that
 			 * in too
 			 */
-			opt += strlen(kw->word) + olen;
+			opt += olen + strlen(kw->word);
 			/* keeps final zero thanks to calloc */
 			if (strlen(opt))
-				memcpy(new + olen + len, opt, opt - o_org - 1);
+				memcpy(new + olen + len, opt, strlen(opt));
 
 			/*
 			 * replace opt and free the old opt

