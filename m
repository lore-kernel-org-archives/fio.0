Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbhHUMBK (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 21 Aug 2021 08:01:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7A7C061575
        for <fio@vger.kernel.org>; Sat, 21 Aug 2021 05:00:31 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mHPfR-007Zi7-5C
        for fio@vger.kernel.org; Sat, 21 Aug 2021 12:00:14 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210821120002.34F2D1BC0139@kernel.dk>
Date: Sat, 21 Aug 2021 06:00:02 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 864314464e2772a9885da34ea041f130073affe9:

  Merge branch 'patch-1' of https://github.com/antroseco/fio (2021-08-18 10:47:55 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 15ce99bb71e7c289f62ddee94e0149f6c81549de:

  Merge branch 'master' of https://github.com/DamonPalovaara/fio (2021-08-20 20:58:42 -0600)

----------------------------------------------------------------
Damon Palovaara (1):
      fixed type boot->bool

Jens Axboe (1):
      Merge branch 'master' of https://github.com/DamonPalovaara/fio

 HOWTO | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 9bfd38b4..a2cf20f6 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2600,7 +2600,7 @@ with the caveat that when used on the command line, they must come after the
 
 	Specify the time between the SIGTERM and SIGKILL signals. Default is 1 second.
 
-.. option:: std_redirect=boot : [exec]
+.. option:: std_redirect=bool : [exec]
 
 	If set, stdout and stderr streams are redirected to files named from the job name. Default is true.
 

