Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728563AbgJNMAG (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 14 Oct 2020 08:00:06 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44EAAC061755
        for <fio@vger.kernel.org>; Wed, 14 Oct 2020 05:00:05 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kSfRr-000227-1j
        for fio@vger.kernel.org; Wed, 14 Oct 2020 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20201014120001.9F1591BC0139@kernel.dk>
Date: Wed, 14 Oct 2020 06:00:01 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 60c52212520b905a1740d3c8815c34cc48471c5c:

  Merge branch 'master' of https://github.com/bvanassche/fio into master (2020-10-10 20:30:52 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 8cf503ce5956e4c287e13d5c7761a03fbb4b54cc:

  Merge branch 'patch-1' of https://github.com/chengli-rutgers/fio into master (2020-10-13 13:07:37 -0600)

----------------------------------------------------------------
Cheng Li (1):
      getopt_long: avoid variable global initialization

Jens Axboe (1):
      Merge branch 'patch-1' of https://github.com/chengli-rutgers/fio into master

 oslib/getopt_long.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/oslib/getopt_long.c b/oslib/getopt_long.c
index 8ec77413..463919fb 100644
--- a/oslib/getopt_long.c
+++ b/oslib/getopt_long.c
@@ -16,8 +16,8 @@
 
 #include "getopt.h"
 
-char *optarg = NULL;
-int optind = 0, opterr = 0, optopt = 0;
+char *optarg;
+int optind, opterr, optopt;
 
 static struct getopt_private_state {
 	const char *optptr;

