Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 08/15] Ignore exit_io_done= option if no I/O threads are configured
Date: Wed, 27 Jul 2016 22:37:13 +0900
Message-Id: <1469626640-13335-8-git-send-email-kusumi.tomohiro@gmail.com>
In-Reply-To: <1469626640-13335-1-git-send-email-kusumi.tomohiro@gmail.com>
References: <1469626640-13335-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

The cpuio engine option exit_io_done= should be effective only if
there is at least one real I/O thread configured.

The existing fio_cpuio_queue() with exit_io_done= option enabled
lets cpuio threads exit even if cpuio threads are the only threads
configured.

Since this option is supposed to mean "exit when I/O threads are done",
cpuio threads exiting (but only after the first spin cycle is done)
when no threads have done any I/O is a bit confusing.

> [cpu] exit_on_io_done=bool Detect when IO threads are done, then exit.

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 libfio.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/libfio.c b/libfio.c
index 55762d7..2586675 100644
--- a/libfio.c
+++ b/libfio.c
@@ -274,14 +274,18 @@ int fio_running_or_pending_io_threads(void)
 {
 	struct thread_data *td;
 	int i;
+	int nr_io_threads = 0;
 
 	for_each_td(td, i) {
 		if (td->flags & TD_F_NOIO)
 			continue;
+		nr_io_threads++;
 		if (td->runstate < TD_EXITED)
 			return 1;
 	}
 
+	if (!nr_io_threads)
+		return -1; /* we only had cpuio threads to begin with */
 	return 0;
 }
 
-- 
2.5.5


