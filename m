Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 08/17] Drop redundant td_rw(td) tests
Date: Tue,  7 Mar 2017 22:12:59 +0200
Message-Id: <20170307201308.66814-9-tkusumi@tuxera.com>
In-Reply-To: <20170307201308.66814-1-tkusumi@tuxera.com>
References: <20170307201308.66814-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Since TD_DDIR_READ is 1, TD_DDIR_WRITE is 1<<1, and td_rw() requires
both TD_DDIR_READ/WRITE bits set, testing (td_read(td) || td_rw(td))
turns out to be

if td_read(td) is false, td_rw(td) is always false,
if td_read(td) is true, td_rw(td) won't be tested,
thus the result equals that of td_read(td).

It's the same for td_write(td) as well.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 backend.c | 2 +-
 fio.h     | 2 +-
 init.c    | 2 +-
 verify.c  | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/backend.c b/backend.c
index 4bc00e6..2e8a994 100644
--- a/backend.c
+++ b/backend.c
@@ -1693,7 +1693,7 @@ static void *thread_main(void *data)
 
 		prune_io_piece_log(td);
 
-		if (td->o.verify_only && (td_write(td) || td_rw(td)))
+		if (td->o.verify_only && td_write(td))
 			verify_bytes = do_dry_run(td);
 		else {
 			uint64_t bytes_done[DDIR_RWDIR_CNT];
diff --git a/fio.h b/fio.h
index b2f0e2f..b573ac5 100644
--- a/fio.h
+++ b/fio.h
@@ -490,7 +490,7 @@ static inline int should_fsync(struct thread_data *td)
 {
 	if (td->last_was_sync)
 		return 0;
-	if (td_write(td) || td_rw(td) || td->o.override_sync)
+	if (td_write(td) || td->o.override_sync)
 		return 1;
 
 	return 0;
diff --git a/init.c b/init.c
index acdc659..5353890 100644
--- a/init.c
+++ b/init.c
@@ -619,7 +619,7 @@ static int fixup_options(struct thread_data *td)
 	/*
 	 * Reads can do overwrites, we always need to pre-create the file
 	 */
-	if (td_read(td) || td_rw(td))
+	if (td_read(td))
 		o->overwrite = 1;
 
 	if (!o->min_bs[DDIR_READ])
diff --git a/verify.c b/verify.c
index 5c7e43d..f2841c7 100644
--- a/verify.c
+++ b/verify.c
@@ -760,7 +760,7 @@ static int verify_header(struct io_u *io_u, struct thread_data *td,
 	 * state of numberio, that would have been written to each block
 	 * in a previous run of fio, has been reached.
 	 */
-	if ((td_write(td) || td_rw(td)) && (td_min_bs(td) == td_max_bs(td)) &&
+	if (td_write(td) && (td_min_bs(td) == td_max_bs(td)) &&
 	    !td->o.time_based)
 		if (!td->o.verify_only || td->o.loops == 0)
 			if (hdr->numberio != io_u->numberio) {
-- 
2.9.3


