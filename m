Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:53323 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbaBKNAE (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 11 Feb 2014 08:00:04 -0500
Received: from kernel.dk ([54.225.238.116] helo=strynoevaenget.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WDCwW-0001hJ-3Z
	for fio@vger.kernel.org; Tue, 11 Feb 2014 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140211130003.22E4B4322D@strynoevaenget.dk>
Date: Tue, 11 Feb 2014 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 782744ef60b7ed47a529d30b9f8e0c528c436fdb:

  crc: add option to list possible crc types (2014-02-07 20:54:39 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ea66e04fe1a803f6a9ddf31cb999641d4396d67c:

  Fix issue with td->mutex being used-after-free (2014-02-10 13:57:09 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Fix issue with td->mutex being used-after-free

 backend.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 501c59a..a607134 100644
--- a/backend.c
+++ b/backend.c
@@ -1236,13 +1236,6 @@ static void *thread_main(void *data)
 	dprint(FD_MUTEX, "done waiting on td->mutex\n");
 
 	/*
-	 * the ->mutex mutex is now no longer used, close it to avoid
-	 * eating a file descriptor
-	 */
-	fio_mutex_remove(td->mutex);
-	td->mutex = NULL;
-
-	/*
 	 * A new gid requires privilege, so we need to do this before setting
 	 * the uid.
 	 */
@@ -1521,6 +1514,9 @@ err:
 	fio_mutex_remove(td->rusage_sem);
 	td->rusage_sem = NULL;
 
+	fio_mutex_remove(td->mutex);
+	td->mutex = NULL;
+
 	td_set_runstate(td, TD_EXITED);
 	return (void *) (uintptr_t) td->error;
 }
