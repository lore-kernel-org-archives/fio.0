Return-Path: <prvs=390c41bd8=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v2 6/7] io_u: Optimize set_rw_ddir()
Date: Fri,  8 May 2020 16:56:44 +0900
Message-Id: <20200508075645.543890-7-damien.lemoal@wdc.com>
In-Reply-To: <20200508075645.543890-1-damien.lemoal@wdc.com>
References: <20200508075645.543890-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

There is no need to execute zbd_adjust_ddir() for a job that is not
using zonemode=zbd. So move the job mode test out of zbd_adjust_ddir()
and conditionally execute this function by first testing the job mode
in set_rw_ddir().

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 io_u.c | 3 ++-
 zbd.c  | 4 +---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/io_u.c b/io_u.c
index 18e94617..aa8808b8 100644
--- a/io_u.c
+++ b/io_u.c
@@ -746,7 +746,8 @@ static void set_rw_ddir(struct thread_data *td, struct io_u *io_u)
 {
 	enum fio_ddir ddir = get_rw_ddir(td);
 
-	ddir = zbd_adjust_ddir(td, io_u, ddir);
+	if (td->o.zone_mode == ZONE_MODE_ZBD)
+		ddir = zbd_adjust_ddir(td, io_u, ddir);
 
 	if (td_trimwrite(td)) {
 		struct fio_file *f = io_u->file;
diff --git a/zbd.c b/zbd.c
index db6d09f2..d8fc7ef5 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1346,9 +1346,7 @@ enum fio_ddir zbd_adjust_ddir(struct thread_data *td, struct io_u *io_u,
 	 * devices with all empty zones. Overwrite the first I/O direction as
 	 * write to make sure data to read exists.
 	 */
-	if (td->o.zone_mode != ZONE_MODE_ZBD ||
-	    ddir != DDIR_READ ||
-	    !td_rw(td))
+	if (ddir != DDIR_READ || !td_rw(td))
 		return ddir;
 
 	if (io_u->file->zbd_info->sectors_with_data ||
-- 
2.25.4


