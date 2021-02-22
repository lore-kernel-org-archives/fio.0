Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231613AbhBVNAv (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 22 Feb 2021 08:00:51 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA33C061786
        for <fio@vger.kernel.org>; Mon, 22 Feb 2021 05:00:11 -0800 (PST)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lEAom-006ajQ-Ht
        for fio@vger.kernel.org; Mon, 22 Feb 2021 13:00:07 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210222130001.A98D71BC0154@kernel.dk>
Date: Mon, 22 Feb 2021 06:00:01 -0700 (MST)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c4f5c92fac8a39ffff29d57e99c3c0163358dd7a:

  engines/io_uring: add verbose error for ENOSYS (2021-02-16 12:07:14 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ab02be41807ec9451c47b17129cf61457ef21db6:

  Add a new file to gitignore (2021-02-21 06:14:40 -0700)

----------------------------------------------------------------
Hongwei Qin (1):
      Add a new file to gitignore

 .gitignore | 1 +
 1 file changed, 1 insertion(+)

---

Diff of recent changes:

diff --git a/.gitignore b/.gitignore
index 0aa4a361..6651f96e 100644
--- a/.gitignore
+++ b/.gitignore
@@ -30,3 +30,4 @@ doc/output
 /tags
 /TAGS
 /t/zbd/test-zbd-support.log.*
+/t/fuzz/fuzz_parseini

