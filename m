Return-Path: <puthik@google.com>
Return-Path: <puthik@google.com>
From: Puthikorn Voravootivat <puthik@chromium.org>
Subject: [PATCH] Fix verify_only option not working properly
Date: Mon,  3 Mar 2014 15:33:32 -0800
Message-Id: <1393889612-14391-1-git-send-email-puthik@chromium.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: FIO List <fio@vger.kernel.org>, Gwendal Grignou <gwendal@chromium.org>, Grant Grundler <grundler@chromium.org>, Puthikorn Voravootivat <puthik@chromium.org>
List-ID: <fio@vger.kernel.org>

In commit c4b6117, we changed the place to call log_io_piece but
the new place won't be reached when using verify_only option so
that when we run with the verify_only option, fio won't verify
anything at all.

This patch fix that by also call the log_io_piece in the do_dry_run
function for the verify_only code path.

Signed-off-by: Puthikorn Voravootivat <puthik@chromium.org>
Reviewed-by: Gwendal Grignou <gwendal@chromium.org>

---
Fix my own patch bug. Didn't catch it that time.
 backend.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/backend.c b/backend.c
index 72d9d6d..992033c 100644
--- a/backend.c
+++ b/backend.c
@@ -1196,6 +1196,12 @@ static uint64_t do_dry_run(struct thread_data *td)
 			td->ts.total_io_u[io_u->ddir]++;
 		}
 
+		if (td_write(td) && io_u->ddir == DDIR_WRITE &&
+		    td->o.do_verify &&
+		    td->o.verify != VERIFY_NONE &&
+		    !td->o.experimental_verify)
+			log_io_piece(td, io_u);
+
 		ret = io_u_sync_complete(td, io_u, bytes_done);
 		(void) ret;
 	}
-- 
1.9.0.279.gdc9e3eb


