Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:54372 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965999AbaFRMAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 18 Jun 2014 08:00:05 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WxEX6-0004E9-2f
	for fio@vger.kernel.org; Wed, 18 Jun 2014 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140618120002.C74A140136@lyth.info>
Date: Wed, 18 Jun 2014 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 3e2e48a72851354f7d6d4da9fc83d4a6df20e955:

  Add string condensing for the ETA output (2014-06-16 14:42:05 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6c784104cf90299aeec1d79f536a8e534c341c5f:

  Fixup run_str[] condensing with client/server (2014-06-17 09:22:34 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Fixup run_str[] condensing with client/server

 eta.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

---

Diff of recent changes:

diff --git a/eta.c b/eta.c
index 52c1728..0dd04be 100644
--- a/eta.c
+++ b/eta.c
@@ -36,18 +36,16 @@ new:
 		} else if (last == run_str[i]) {
 			nr++;
 		} else {
-			int elen;
-
-			elen = sprintf(&run_str_condensed[ci], "(%u),", nr);
-			ci += elen;
+			ci += sprintf(&run_str_condensed[ci], "(%u),", nr);
 			goto new;
 		}
 	}
 
 	if (nr)
-		sprintf(&run_str_condensed[ci], "(%u)", nr);
-}
+		ci += sprintf(&run_str_condensed[ci], "(%u)", nr);
 
+	run_str_condensed[ci + 1] = '\0';
+}
 
 /*
  * Sets the status of the 'td' in the printed status map.
@@ -487,7 +485,8 @@ int calc_thread_status(struct jobs_eta *je, int force)
 		return 0;
 
 	je->nr_threads = thread_number;
-	memcpy(je->run_str, run_str, thread_number * sizeof(char));
+	update_condensed_str(__run_str, run_str);
+	memcpy(je->run_str, run_str, strlen(run_str));
 	return 1;
 }
 
