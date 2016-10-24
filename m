Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:55626 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757498AbcJXMAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 24 Oct 2016 08:00:09 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1bydvA-0004ox-Ed
        for fio@vger.kernel.org; Mon, 24 Oct 2016 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20161024120001.EF4DF2C00C8@kernel.dk>
Date: Mon, 24 Oct 2016 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e291cff14e97feb3cff711f5a5cbcb63b32f9c72:

  Use fmt -w WIDTH option instead of -WIDTH (2016-10-20 08:10:10 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ca0122d822ea7dd573f05ca4cf43c5d0ff9f4adb:

  backend: if we can't grab stat_mutex, report a deadlock error and exit (2016-10-23 08:35:14 -0600)

----------------------------------------------------------------
Theodore Ts'o (1):
      backend: if we can't grab stat_mutex, report a deadlock error and exit

 backend.c | 7 +++++++
 1 file changed, 7 insertions(+)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index fb2a855..093b6a3 100644
--- a/backend.c
+++ b/backend.c
@@ -1471,6 +1471,7 @@ static void *thread_main(void *data)
 	struct thread_data *td = fd->td;
 	struct thread_options *o = &td->o;
 	struct sk_out *sk_out = fd->sk_out;
+	int deadlock_loop_cnt;
 	int clear_state;
 	int ret;
 
@@ -1731,11 +1732,17 @@ static void *thread_main(void *data)
 		 * the rusage_sem, which would never get upped because
 		 * this thread is waiting for the stat mutex.
 		 */
+		deadlock_loop_cnt = 0;
 		do {
 			check_update_rusage(td);
 			if (!fio_mutex_down_trylock(stat_mutex))
 				break;
 			usleep(1000);
+			if (deadlock_loop_cnt++ > 5000) {
+				log_err("fio seems to be stuck grabbing stat_mutex, forcibly exiting\n");
+				td->error = EDEADLOCK;
+				goto err;
+			}
 		} while (1);
 
 		if (td_read(td) && td->io_bytes[DDIR_READ])
