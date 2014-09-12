Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:33142 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060AbaILMAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 12 Sep 2014 08:00:05 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XSPWF-0000Y8-Vm
	for fio@vger.kernel.org; Fri, 12 Sep 2014 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140912120002.C721F40128@lyth.info>
Date: Fri, 12 Sep 2014 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 5fb4b36674b194ae6c6756314dc0c665fcaea06d:

  Fix hangs due to iodepth_low (2014-09-04 13:51:05 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 44c8268d6e6d3b3f1efb1eb8a1c2d7bba1e8477b:

  server: fix wrong use of exit() in server when daemonized (2014-09-11 17:05:58 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      server: fix wrong use of exit() in server when daemonized

 server.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/server.c b/server.c
index e2a6f73..36713ee 100644
--- a/server.c
+++ b/server.c
@@ -1709,7 +1709,7 @@ int fio_start_server(char *pidfile)
 		int ret = write_pid(pid, pidfile);
 
 		free(pidfile);
-		exit(ret);
+		_exit(ret);
 	}
 
 	setsid();
