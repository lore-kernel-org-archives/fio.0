Return-Path: <puthik@google.com>
Return-Path: <puthik@google.com>
From: Puthikorn Voravootivat <puthik@chromium.org>
Subject: [PATCH] fix rand_seed mismatches in verify phase
Date: Mon,  3 Feb 2014 13:31:17 -0800
Message-Id: <1391463077-14292-1-git-send-email-puthik@chromium.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: FIO List <fio@vger.kernel.org>, Gwendal Grignou <gwendal@chromium.org>, Grant Grundler <grundler@chromium.org>, Puthikorn Voravootivat <puthik@chromium.org>
List-ID: <fio@vger.kernel.org>

In verify phase, the rand_seed generated on replay does not match
the written rand_seed.

Multiple problems are causing this:
1. In verify phase fio does not set io_u->rand_seed to compare with
   hdr->rand_seed
2. In randrw scenario, fio log is stored in red-black tree in "sorted by LBA"
   order.  Thus, it is imposible to replay the written order, or rather
   generate the seeds again in the same order.
3. In write phase, the code currently will generate rand_seed, write data
   and log rand_seed. When queuedepth > 1, it's possible the writes complete
   in a different order than rand_seed was generated.  Thus when replaying
   the log, the generated rand_seed might not match what was written.
4. verify_backlog option will start verification before all the data has been
   written and it make rand_seed replay code broken with current design.

Proposed fixes:
1. Use of existing verify_state to generate verify header.
   (and assumes this was the original intention of verify_state). And also
   adds code to replay rand_seed in verify phase.
2. If verifysort option is not enabled, store the write log in a list instead
   of the red-black tree. Otherwise, don't attempt to verify the rand_seed
   in the header.
3. In write phase,  generate rand_seed, log rand_seed, write data. I.e. log
   IO transactions in the order generated, not completed.
4. Don't verify rand_seed when verify_backlog is enabled.

Signed-off-by: Puthikorn Voravootivat <puthik@chromium.org>
---
 backend.c | 13 +++++++++++++
 io_u.c    |  6 ------
 iolog.c   |  2 +-
 verify.c  | 14 ++++++++++++--
 4 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/backend.c b/backend.c
index 93e6632..bf9d066 100644
--- a/backend.c
+++ b/backend.c
@@ -697,6 +697,13 @@ static uint64_t do_io(struct thread_data *td)
 		 */
 		if (td->o.verify != VERIFY_NONE && io_u->ddir == DDIR_READ &&
 		    ((io_u->flags & IO_U_F_VER_LIST) || !td_rw(td))) {
+
+			if (!td->o.verify_pattern_bytes) {
+				io_u->rand_seed = __rand(&td->__verify_state);
+				if (sizeof(int) != sizeof(long *))
+					io_u->rand_seed *= __rand(&td->__verify_state);
+			}
+
 			if (td->o.verify_async)
 				io_u->end_io = verify_io_u_async;
 			else
@@ -707,6 +714,12 @@ static uint64_t do_io(struct thread_data *td)
 		else
 			td_set_runstate(td, TD_RUNNING);
 
+		if (td_write(td) && io_u->ddir == DDIR_WRITE &&
+		    td->o.do_verify &&
+		    td->o.verify != VERIFY_NONE &&
+		    !td->o.experimental_verify)
+			log_io_piece(td, io_u);
+
 		ret = td_io_queue(td, io_u);
 		switch (ret) {
 		case FIO_Q_COMPLETED:
diff --git a/io_u.c b/io_u.c
index 518d884..f68b213 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1623,12 +1623,6 @@ static void io_completed(struct thread_data *td, struct io_u *io_u,
 					 utime_since_now(&td->start));
 		}
 
-		if (td_write(td) && idx == DDIR_WRITE &&
-		    td->o.do_verify &&
-		    td->o.verify != VERIFY_NONE &&
-		    !td->o.experimental_verify)
-			log_io_piece(td, io_u);
-
 		icd->bytes_done[idx] += bytes;
 
 		if (io_u->end_io) {
diff --git a/iolog.c b/iolog.c
index ec29971..017b235 100644
--- a/iolog.c
+++ b/iolog.c
@@ -209,7 +209,7 @@ void log_io_piece(struct thread_data *td, struct io_u *io_u)
 	 * drop the old one, which we rely on the rb insert/lookup for
 	 * handling.
 	 */
-	if ((!td_random(td) || !td->o.overwrite) &&
+	if (((!td->o.verifysort) || !td_random(td) || !td->o.overwrite) &&
 	      (file_randommap(td, ipo->file) || td->o.verify == VERIFY_NONE)) {
 		INIT_FLIST_HEAD(&ipo->list);
 		flist_add_tail(&ipo->list, &td->io_hist_list);
diff --git a/verify.c b/verify.c
index 568bae8..970b867 100644
--- a/verify.c
+++ b/verify.c
@@ -72,10 +72,10 @@ void fill_verify_pattern(struct thread_data *td, void *p, unsigned int len,
 		if (use_seed)
 			__fill_random_buf(p, len, seed);
 		else
-			io_u->rand_seed = fill_random_buf(&td->buf_state, p, len);
+			io_u->rand_seed = fill_random_buf(&td->__verify_state, p, len);
 		return;
 	}
-	
+
 	if (io_u->buf_filled_len >= len) {
 		dprint(FD_VERIFY, "using already filled verify pattern b=%d len=%u\n",
 			td->o.verify_pattern_bytes, len);
@@ -718,6 +718,10 @@ int verify_io_u(struct thread_data *td, struct io_u *io_u)
 			memswp(p, p + td->o.verify_offset, header_size);
 		hdr = p;
 
+		// Make rand_seed check pass when have verifysort or verify_backlog.
+		if (td->o.verifysort || (td->flags & TD_F_VER_BACKLOG))
+			io_u->rand_seed = hdr->rand_seed;
+
 		ret = verify_header(io_u, hdr);
 		switch (ret) {
 		case 0:
@@ -1056,6 +1060,12 @@ int get_next_verify(struct thread_data *td, struct io_u *io_u)
 		remove_trim_entry(td, ipo);
 		free(ipo);
 		dprint(FD_VERIFY, "get_next_verify: ret io_u %p\n", io_u);
+
+		if (!td->o.verify_pattern_bytes) {
+			io_u->rand_seed = __rand(&td->__verify_state);
+			if (sizeof(int) != sizeof(long *))
+				io_u->rand_seed *= __rand(&td->__verify_state);
+		}
 		return 0;
 	}
 
-- 
1.9.0.rc1.175.g0b1dcb5


