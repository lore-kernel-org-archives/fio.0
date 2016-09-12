Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:42008 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754615AbcILMAF (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 12 Sep 2016 08:00:05 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1bjPu7-0003ot-KP
        for fio@vger.kernel.org; Mon, 12 Sep 2016 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160912120001.C64452C1A70@kernel.dk>
Date: Mon, 12 Sep 2016 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 27c9aab2d9a45a1babf01a3aa0123e1f5ce36a24:

  Makes use of configparser portable to older versions by: - relying on its' own NoOptionError exception - using getter method instead of dictionary overriding - and using readfp() as older version does not autodetect fp vs string types (2016-09-06 10:22:00 -0400)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5e333ada464c885d2a33a30e98812bfb666e6052:

  init: pass in right pointer to def thread options free (2016-09-11 19:14:10 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      init: pass in right pointer to def thread options free

 init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/init.c b/init.c
index 4b4a86a..bc17b40 100644
--- a/init.c
+++ b/init.c
@@ -309,7 +309,7 @@ static void free_shm(void)
 	free(trigger_remote_cmd);
 	trigger_file = trigger_cmd = trigger_remote_cmd = NULL;
 
-	options_free(fio_options, &def_thread);
+	options_free(fio_options, &def_thread.o);
 	fio_filelock_exit();
 	scleanup();
 }
