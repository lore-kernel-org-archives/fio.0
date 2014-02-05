Return-Path: <puthik@google.com>
Return-Path: <puthik@google.com>
From: Puthikorn Voravootivat <puthik@chromium.org>
Subject: [PATCH] Fix verify_backlog start verification before finish writing
Date: Wed,  5 Feb 2014 10:28:15 -0800
Message-Id: <1391624895-9543-1-git-send-email-puthik@chromium.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: FIO List <fio@vger.kernel.org>, Gwendal Grignou <gwendal@chromium.org>, Grant Grundler <grundler@chromium.org>, Puthikorn Voravootivat <puthik@chromium.org>
List-ID: <fio@vger.kernel.org>

Due to recent fix for checking rand_seed in verify phase. In write phase,
the IO transaction will be logged before completing the actual data write.
If verify_backlog is enabled, verification may start before all data has
been written. This patch disable that fix if the verify_backlog is enabled.

Signed-off-by: Puthikorn Voravootivat <puthik@chromium.org>
---
I was going to send the v2 to the last patch. But saw that you have already
applied it. So here is the additional fix.

 backend.c |  7 ++++++-
 io_u.c    | 11 +++++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/backend.c b/backend.c
index bf9d066..31b2790 100644
--- a/backend.c
+++ b/backend.c
@@ -714,10 +714,15 @@ static uint64_t do_io(struct thread_data *td)
 		else
 			td_set_runstate(td, TD_RUNNING);
 
+		/*
+		 * Verify_backlog disabled: We need to log rand seed before the
+		 * actual IO to be able to replay it correctly in the verify phase.
+		 */
 		if (td_write(td) && io_u->ddir == DDIR_WRITE &&
 		    td->o.do_verify &&
 		    td->o.verify != VERIFY_NONE &&
-		    !td->o.experimental_verify)
+		    !td->o.experimental_verify &&
+		    !(td->flags & TD_F_VER_BACKLOG))
 			log_io_piece(td, io_u);
 
 		ret = td_io_queue(td, io_u);
diff --git a/io_u.c b/io_u.c
index f68b213..127564e 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1623,6 +1623,17 @@ static void io_completed(struct thread_data *td, struct io_u *io_u,
 					 utime_since_now(&td->start));
 		}
 
+		/*
+		 * Verify_backlog enable: We need to log the write job after
+		 * finishing it to prevent verifying before finish writing.
+		 */
+		if (td_write(td) && idx == DDIR_WRITE &&
+		    td->o.do_verify &&
+		    td->o.verify != VERIFY_NONE &&
+		    !td->o.experimental_verify &&
+		    (td->flags & TD_F_VER_BACKLOG))
+			log_io_piece(td, io_u);
+
 		icd->bytes_done[idx] += bytes;
 
 		if (io_u->end_io) {
-- 
1.9.0.rc1.175.g0b1dcb5


