Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:59497 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752021AbdGGMAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 7 Jul 2017 08:00:08 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dTRvb-00020m-SZ
        for fio@vger.kernel.org; Fri, 07 Jul 2017 12:00:07 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170707120001.D71A42C008E@kernel.dk>
Date: Fri,  7 Jul 2017 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit b034c0dd2cdb27d3523b300c1b4b93a1c5b84b3c:

  HOWTO: fix indentation for options and job parameters (2017-07-04 16:07:50 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f25f4ef6d123173d7669553ec712419f95c1a3ea:

  oslib/libmtd: kill dead code (2017-07-06 08:09:22 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      oslib/libmtd: kill dead code

 oslib/libmtd_common.h | 42 ------------------------------------------
 1 file changed, 42 deletions(-)

---

Diff of recent changes:

diff --git a/oslib/libmtd_common.h b/oslib/libmtd_common.h
index 3f9e1b8..35628fe 100644
--- a/oslib/libmtd_common.h
+++ b/oslib/libmtd_common.h
@@ -119,48 +119,6 @@ extern "C" {
 	fprintf(stderr, "%s: warning!: " fmt "\n", PROGRAM_NAME, ##__VA_ARGS__); \
 } while(0)
 
-static inline int mtd_rpmatch(const char *resp)
-{
-    return (resp[0] == 'y' || resp[0] == 'Y') ? 1 :
-	(resp[0] == 'n' || resp[0] == 'N') ? 0 : -1;
-}
-
-/**
- * prompt the user for confirmation
- */
-static inline bool prompt(const char *msg, bool def)
-{
-	char *line = NULL;
-	size_t len;
-	bool ret = def;
-
-	do {
-		normsg_cont("%s (%c/%c) ", msg, def ? 'Y' : 'y', def ? 'n' : 'N');
-		fflush(stdout);
-
-		while (getline(&line, &len, stdin) == -1) {
-			printf("failed to read prompt; assuming '%s'\n",
-				def ? "yes" : "no");
-			break;
-		}
-
-		if (strcmp("\n", line) != 0) {
-			switch (mtd_rpmatch(line)) {
-			case 0: ret = false; break;
-			case 1: ret = true; break;
-			case -1:
-				puts("unknown response; please try again");
-				continue;
-			}
-		}
-		break;
-	} while (1);
-
-	free(line);
-
-	return ret;
-}
-
 static inline int is_power_of_2(unsigned long long n)
 {
 	return (n != 0 && ((n & (n - 1)) == 0));
