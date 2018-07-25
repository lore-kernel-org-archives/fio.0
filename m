Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:54546 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728684AbeGYNLd (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 25 Jul 2018 09:11:33 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fiISh-0001SJ-D7
        for fio@vger.kernel.org; Wed, 25 Jul 2018 12:00:11 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180725120002.5B4EA2C013E@kernel.dk>
Date: Wed, 25 Jul 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 464b6f76a69a1937d87a604346fa9c2b430f7465:

  libpmem: update print statement for bs now being ULL (2018-07-23 10:12:54 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 9a496382133e8003bd56ab6f3d260c5afadae555:

  init: unify 't' time period (2018-07-24 15:23:28 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      init: unify 't' time period

 init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/init.c b/init.c
index 8cb8117..ede0a8b 100644
--- a/init.c
+++ b/init.c
@@ -2158,7 +2158,7 @@ static void usage(const char *name)
 	printf("  --showcmd\t\tTurn a job file into command line options\n");
 	printf("  --eta=when\t\tWhen ETA estimate should be printed\n");
 	printf("            \t\tMay be \"always\", \"never\" or \"auto\"\n");
-	printf("  --eta-newline=time\tForce a new line for every 'time'");
+	printf("  --eta-newline=t\tForce a new line for every 't'");
 	printf(" period passed\n");
 	printf("  --status-interval=t\tForce full status dump every");
 	printf(" 't' period passed\n");
