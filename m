Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:54208 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753109AbdDDMAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 4 Apr 2017 08:00:09 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cvN84-0002pT-IU
        for fio@vger.kernel.org; Tue, 04 Apr 2017 12:00:08 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170404120002.2619E2C319A@kernel.dk>
Date: Tue,  4 Apr 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 249ad5bfaded90c0431041b4a3816e7371c2d403:

  time: use correct size type for usecs (2017-04-02 16:01:18 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5ba01402d96e113ac451441f45d0c8b4dd281f4d:

  backend: move freeing of td->mutex to main thread (2017-04-03 08:46:34 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      backend: move freeing of td->mutex to main thread

 backend.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index b61de7c..38ef348 100644
--- a/backend.c
+++ b/backend.c
@@ -1836,9 +1836,6 @@ err:
 	if (o->write_iolog_file)
 		write_iolog_close(td);
 
-	fio_mutex_remove(td->mutex);
-	td->mutex = NULL;
-
 	td_set_runstate(td, TD_EXITED);
 
 	/*
@@ -2435,6 +2432,8 @@ int fio_backend(struct sk_out *sk_out)
 			fio_mutex_remove(td->rusage_sem);
 			td->rusage_sem = NULL;
 		}
+		fio_mutex_remove(td->mutex);
+		td->mutex = NULL;
 	}
 
 	free_disk_util();
