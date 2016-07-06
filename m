Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42052 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbcGFMAE (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 6 Jul 2016 08:00:04 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1bKlUp-0007H3-Kv
	for fio@vger.kernel.org; Wed, 06 Jul 2016 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160706120002.969322C23FF@kernel.dk>
Date: Wed,  6 Jul 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 8a09277d18f942ed35354e31e38df50d991a595a:

  HOWTO: remove old use cases for the net IO engine (2016-06-29 13:09:15 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f1c4b3727386bd8da3617a6730ad55cf2ba04ec8:

  gfio: call g_thread_init() for <= 2.31.0 (2016-07-05 14:23:56 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      gfio: call g_thread_init() for <= 2.31.0

 gfio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/gfio.c b/gfio.c
index e3bcbdf..37c1818 100644
--- a/gfio.c
+++ b/gfio.c
@@ -1677,7 +1677,7 @@ static void init_ui(int *argc, char **argv[], struct gui *ui)
 	 * Without it, the update that happens in gfio_update_thread_status
 	 * doesn't really happen in a timely fashion, you need expose events
 	 */
-#if !GTK_CHECK_VERSION(2, 24, 0)
+#if !GLIB_CHECK_VERSION(2, 31, 0)
 	if (!g_thread_supported())
 		g_thread_init(NULL);
 #endif
