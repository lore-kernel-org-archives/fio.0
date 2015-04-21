Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:44407 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbbDUMAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 21 Apr 2015 08:00:05 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YkWqS-0002Ok-3G
	for fio@vger.kernel.org; Tue, 21 Apr 2015 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150421120002.D0864401B0@lyth.info>
Date: Tue, 21 Apr 2015 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 51e962a7610f1aa69ffe0374f92774fb83526dc7:

  Fix mtd valgrind warning (2015-04-16 16:36:22 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 1d6d3455a9ad610a423f5d4ca849fbe82049997c:

  Don't export state variable (2015-04-20 19:15:50 -0600)

----------------------------------------------------------------
Dan Ehrenberg (1):
      Don't export state variable

 stat.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/stat.h b/stat.h
index dd34012..e87dae0 100644
--- a/stat.h
+++ b/stat.h
@@ -132,7 +132,7 @@ enum block_info_state {
 	BLOCK_STATE_TRIM_FAILURE,
 	BLOCK_STATE_WRITE_FAILURE,
 	BLOCK_STATE_COUNT,
-} state;
+};
 
 #define MAX_PATTERN_SIZE	512
 #define FIO_JOBNAME_SIZE	128
