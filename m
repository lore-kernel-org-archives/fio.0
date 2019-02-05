Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:52120 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726769AbfBENKA (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 5 Feb 2019 08:10:00 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gr0UB-0007Pr-Od
        for fio@vger.kernel.org; Tue, 05 Feb 2019 13:09:59 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190205130002.227D52C3601@kernel.dk>
Date: Tue,  5 Feb 2019 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 154a95828fe08b01774b59602544de394b2d3aa6:

  t/io_uring: verbose error for -95/-EOPNOTSUPP failure (2019-01-31 22:55:52 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to fda82fda074d910fd2939d004b3a73c06da40445:

  Improve wording in REPORTING-BUGS (2019-02-04 09:01:48 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Improve wording in REPORTING-BUGS

 REPORTING-BUGS | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/REPORTING-BUGS b/REPORTING-BUGS
index d8876ae6..327b6caa 100644
--- a/REPORTING-BUGS
+++ b/REPORTING-BUGS
@@ -14,8 +14,8 @@ When reporting a bug, you'll need to include:
 4) How to reproduce. Please include a full list of the parameters
    passed to fio and the job file used (if any).
 
-A bug report can never have too much information. Any time information
-is left out and has to be asked for, it'll add to the turn-around time
-of getting to the bottom of it and committing a fix.
+A bug report can't have too much information. Any time information that
+is left out and has to be asked for will add to the turn-around time
+of getting to the bottom of the issue, and an eventual fix.
 
 That's it!

