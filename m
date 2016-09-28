Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:43412 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753232AbcI1MAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 28 Sep 2016 08:00:07 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1bpDWv-0004Vv-Nx
        for fio@vger.kernel.org; Wed, 28 Sep 2016 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160928120002.F2A862C0097@kernel.dk>
Date: Wed, 28 Sep 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 63a26e05622b0ced2cc685f545f493e794ccc325:

  filehash: move to separate allocation (2016-09-26 01:40:52 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d619275cfad893e37e8c59e5c9e0bc5ca4946b82:

  filehash: fix init/exit (2016-09-27 10:28:29 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      init: remove unused variable
      filehash: fix init/exit

 init.c   | 5 +----
 libfio.c | 3 +++
 2 files changed, 4 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/init.c b/init.c
index 5151ff1..c556fa2 100644
--- a/init.c
+++ b/init.c
@@ -298,7 +298,6 @@ void free_threads_shm(void)
 static void free_shm(void)
 {
 	if (threads) {
-		file_hash_exit();
 		flow_exit();
 		fio_debug_jobp = NULL;
 		free_threads_shm();
@@ -311,6 +310,7 @@ static void free_shm(void)
 
 	options_free(fio_options, &def_thread.o);
 	fio_filelock_exit();
+	file_hash_exit();
 	scleanup();
 }
 
@@ -322,8 +322,6 @@ static void free_shm(void)
  */
 static int setup_thread_area(void)
 {
-	void *hash;
-
 	if (threads)
 		return 0;
 
@@ -368,7 +366,6 @@ static int setup_thread_area(void)
 	fio_debug_jobp = (void *) threads + max_jobs * sizeof(struct thread_data);
 	*fio_debug_jobp = -1;
 
-	file_hash_init();
 	flow_init();
 
 	return 0;
diff --git a/libfio.c b/libfio.c
index d88ed4e..0f9f4e7 100644
--- a/libfio.c
+++ b/libfio.c
@@ -34,6 +34,7 @@
 #include "os/os.h"
 #include "filelock.h"
 #include "helper_thread.h"
+#include "filehash.h"
 
 /*
  * Just expose an empty list, if the OS does not support disk util stats
@@ -376,6 +377,8 @@ int initialize_fio(char *envp[])
 		return 1;
 	}
 
+	file_hash_init();
+
 	/*
 	 * We need locale for number printing, if it isn't set then just
 	 * go with the US format.
