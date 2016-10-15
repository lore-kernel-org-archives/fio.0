Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38905 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754396AbcJOMkP (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 15 Oct 2016 08:40:15 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1bvNdD-0005Q3-6h
        for fio@vger.kernel.org; Sat, 15 Oct 2016 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20161015120002.545B42C0400@kernel.dk>
Date: Sat, 15 Oct 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit afd2ceffd65514a54665493075d7957ec9d0e5fc:

  Add alias for 'disable_bw_measurement' option (2016-10-12 08:59:25 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a4f581f981a2a0e19d22339d9fdf17b3aaeb12b8:

  Update REPORTING-BUGS (2016-10-14 14:07:43 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Update REPORTING-BUGS

 REPORTING-BUGS | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/REPORTING-BUGS b/REPORTING-BUGS
index c6150d1..d8876ae 100644
--- a/REPORTING-BUGS
+++ b/REPORTING-BUGS
@@ -2,8 +2,10 @@ Reporting a bug
 ---------------
 
 If you notice anything that seems like a fio bug, please do send email
-to the list (fio@vger.kernel.org, see README) about it. You'll need
-to report at least:
+to the list (fio@vger.kernel.org, see README) about it. If you are not
+running the newest release of fio, upgrading first is recommended.
+
+When reporting a bug, you'll need to include:
 
 1) A description of what you think the bug is
 2) Environment (Linux distro version, kernel version). This is mostly
@@ -12,4 +14,8 @@ to report at least:
 4) How to reproduce. Please include a full list of the parameters
    passed to fio and the job file used (if any).
 
+A bug report can never have too much information. Any time information
+is left out and has to be asked for, it'll add to the turn-around time
+of getting to the bottom of it and committing a fix.
+
 That's it!
