Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:37036 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbcDBMAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 2 Apr 2016 08:00:07 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.85 #2 (Red Hat Linux))
	id 1amKDk-0002OI-Ny
	for fio@vger.kernel.org; Sat, 02 Apr 2016 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160402120001.D98A52C00AE@kernel.dk>
Date: Sat,  2 Apr 2016 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 23a8e176c3725f3640eaaf31a0a4c7497366c40f:

  HOWTO/man: clarify that the usr/sys utilization numbers are averages (2016-03-29 08:34:06 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 526c403dc9b892ae1dda6ebb2a0f2d5883795d17:

  fio: register pvsync2 engine correctly (2016-04-01 20:56:52 -0600)

----------------------------------------------------------------
Jon Derrick (1):
      fio: register pvsync2 engine correctly

 engines/sync.c | 6 ++++++
 options.c      | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/engines/sync.c b/engines/sync.c
index 0b0d1a7..260ef66 100644
--- a/engines/sync.c
+++ b/engines/sync.c
@@ -453,6 +453,9 @@ static void fio_init fio_syncio_register(void)
 #ifdef CONFIG_PWRITEV
 	register_ioengine(&ioengine_pvrw);
 #endif
+#ifdef CONFIG_PWRITEV2
+	register_ioengine(&ioengine_pvrw2);
+#endif
 }
 
 static void fio_exit fio_syncio_unregister(void)
@@ -463,4 +466,7 @@ static void fio_exit fio_syncio_unregister(void)
 #ifdef CONFIG_PWRITEV
 	unregister_ioengine(&ioengine_pvrw);
 #endif
+#ifdef CONFIG_PWRITEV2
+	unregister_ioengine(&ioengine_pvrw2);
+#endif
 }
diff --git a/options.c b/options.c
index 062abb4..b6c980e 100644
--- a/options.c
+++ b/options.c
@@ -1471,7 +1471,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .help = "Use preadv/pwritev",
 			  },
 #endif
-#ifdef CONFIG_PWRITEV
+#ifdef CONFIG_PWRITEV2
 			  { .ival = "pvsync2",
 			    .help = "Use preadv2/pwritev2",
 			  },
