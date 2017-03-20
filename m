Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 7/7] Test fsync/fdatasync/sync_file_range for the next i/o only if should_fsync(td)
Date: Mon, 20 Mar 2017 23:28:47 +0200
Message-Id: <20170320212847.71404-7-tkusumi@tuxera.com>
In-Reply-To: <20170320212847.71404-1-tkusumi@tuxera.com>
References: <20170320212847.71404-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Checking an inline function should_fsync() first is better since
should_fsync() itself contains td_write() as a condition to return true,
and there's no need for non-write td to go through the rest of checks
when they result in false due to td->io_issues[DDIR_WRITE] being 0.

(This commit directly goes on top of the previous one)

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 io_u.c | 36 +++++++++++++++---------------------
 1 file changed, 15 insertions(+), 21 deletions(-)

diff --git a/io_u.c b/io_u.c
index 1de35c8..c6d814b 100644
--- a/io_u.c
+++ b/io_u.c
@@ -717,28 +717,22 @@ static enum fio_ddir get_rw_ddir(struct thread_data *td)
 	enum fio_ddir ddir;
 
 	/*
-	 * see if it's time to fsync
+	 * See if it's time to fsync/fdatasync/sync_file_range first,
+	 * and if not then move on to check regular I/Os.
 	 */
-	if (td->o.fsync_blocks && td->io_issues[DDIR_WRITE] &&
-	    !(td->io_issues[DDIR_WRITE] % td->o.fsync_blocks) &&
-	    should_fsync(td))
-		return DDIR_SYNC;
-
-	/*
-	 * see if it's time to fdatasync
-	 */
-	if (td->o.fdatasync_blocks && td->io_issues[DDIR_WRITE] &&
-	    !(td->io_issues[DDIR_WRITE] % td->o.fdatasync_blocks) &&
-	    should_fsync(td))
-		return DDIR_DATASYNC;
-
-	/*
-	 * see if it's time to sync_file_range
-	 */
-	if (td->sync_file_range_nr && td->io_issues[DDIR_WRITE] &&
-	    !(td->io_issues[DDIR_WRITE] % td->sync_file_range_nr) &&
-	    should_fsync(td))
-		return DDIR_SYNC_FILE_RANGE;
+	if (should_fsync(td)) {
+		if (td->o.fsync_blocks && td->io_issues[DDIR_WRITE] &&
+		    !(td->io_issues[DDIR_WRITE] % td->o.fsync_blocks))
+			return DDIR_SYNC;
+
+		if (td->o.fdatasync_blocks && td->io_issues[DDIR_WRITE] &&
+		    !(td->io_issues[DDIR_WRITE] % td->o.fdatasync_blocks))
+			return DDIR_DATASYNC;
+
+		if (td->sync_file_range_nr && td->io_issues[DDIR_WRITE] &&
+		    !(td->io_issues[DDIR_WRITE] % td->sync_file_range_nr))
+			return DDIR_SYNC_FILE_RANGE;
+	}
 
 	if (td_rw(td)) {
 		/*
-- 
2.9.3


