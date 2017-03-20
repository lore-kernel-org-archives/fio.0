Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 6/7] Test uint,int before division uint/int for the next i/o
Date: Mon, 20 Mar 2017 23:28:46 +0200
Message-Id: <20170320212847.71404-6-tkusumi@tuxera.com>
In-Reply-To: <20170320212847.71404-1-tkusumi@tuxera.com>
References: <20170320212847.71404-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

When selecting ddir for the next i/o, test td->io_issues[DDIR_WRITE]
before division which is more expensive.

if (x && y && !(y % x))
rather than
if (x && !(y % x) && y)

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 io_u.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/io_u.c b/io_u.c
index 5f01c1b..1de35c8 100644
--- a/io_u.c
+++ b/io_u.c
@@ -719,25 +719,25 @@ static enum fio_ddir get_rw_ddir(struct thread_data *td)
 	/*
 	 * see if it's time to fsync
 	 */
-	if (td->o.fsync_blocks &&
-	   !(td->io_issues[DDIR_WRITE] % td->o.fsync_blocks) &&
-	     td->io_issues[DDIR_WRITE] && should_fsync(td))
+	if (td->o.fsync_blocks && td->io_issues[DDIR_WRITE] &&
+	    !(td->io_issues[DDIR_WRITE] % td->o.fsync_blocks) &&
+	    should_fsync(td))
 		return DDIR_SYNC;
 
 	/*
 	 * see if it's time to fdatasync
 	 */
-	if (td->o.fdatasync_blocks &&
-	   !(td->io_issues[DDIR_WRITE] % td->o.fdatasync_blocks) &&
-	     td->io_issues[DDIR_WRITE] && should_fsync(td))
+	if (td->o.fdatasync_blocks && td->io_issues[DDIR_WRITE] &&
+	    !(td->io_issues[DDIR_WRITE] % td->o.fdatasync_blocks) &&
+	    should_fsync(td))
 		return DDIR_DATASYNC;
 
 	/*
 	 * see if it's time to sync_file_range
 	 */
-	if (td->sync_file_range_nr &&
-	   !(td->io_issues[DDIR_WRITE] % td->sync_file_range_nr) &&
-	     td->io_issues[DDIR_WRITE] && should_fsync(td))
+	if (td->sync_file_range_nr && td->io_issues[DDIR_WRITE] &&
+	    !(td->io_issues[DDIR_WRITE] % td->sync_file_range_nr) &&
+	    should_fsync(td))
 		return DDIR_SYNC_FILE_RANGE;
 
 	if (td_rw(td)) {
-- 
2.9.3


