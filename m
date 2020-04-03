Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:50352 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403836AbgDCMAG (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 3 Apr 2020 08:00:06 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jKKzU-0005yL-Ca
        for fio@vger.kernel.org; Fri, 03 Apr 2020 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200403120001.78C9D1BC00EA@kernel.dk>
Date: Fri,  3 Apr 2020 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 839f607b5771081e96942977a1ff9f1b24b77bca:

  Merge branch 'github-issue-947' of https://github.com/vincentkfu/fio (2020-03-31 10:21:48 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6463db6c1d3a2a961008e87a86d464b596886f1a:

  fio: fix interaction between offset/size limited threads and "max_open_zones" (2020-04-02 13:33:49 -0600)

----------------------------------------------------------------
Alexey Dobriyan (1):
      fio: fix interaction between offset/size limited threads and "max_open_zones"

 zbd.c | 43 ++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 38 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/zbd.c b/zbd.c
index b2d94249..0dd5a619 100644
--- a/zbd.c
+++ b/zbd.c
@@ -945,6 +945,13 @@ static void zone_lock(struct thread_data *td, struct fio_zone_info *z)
 	}
 }
 
+/* Anything goes as long as it is not a constant. */
+static uint32_t pick_random_zone_idx(const struct fio_file *f,
+				     const struct io_u *io_u)
+{
+	return io_u->offset * f->zbd_info->num_open_zones / f->real_file_size;
+}
+
 /*
  * Modify the offset of an I/O unit that does not refer to an open zone such
  * that it refers to an open zone. Close an open zone and open a new zone if
@@ -969,9 +976,7 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 		 * This statement accesses f->zbd_info->open_zones[] on purpose
 		 * without locking.
 		 */
-		zone_idx = f->zbd_info->open_zones[(io_u->offset -
-						    f->file_offset) *
-				f->zbd_info->num_open_zones / f->io_size];
+		zone_idx = f->zbd_info->open_zones[pick_random_zone_idx(f, io_u)];
 	} else {
 		zone_idx = zbd_zone_idx(f, io_u->offset);
 	}
@@ -985,6 +990,8 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 	 * has been obtained. Hence the loop.
 	 */
 	for (;;) {
+		uint32_t tmp_idx;
+
 		z = &f->zbd_info->zone_info[zone_idx];
 
 		zone_lock(td, z);
@@ -998,9 +1005,35 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 			       __func__, f->file_name);
 			return NULL;
 		}
-		open_zone_idx = (io_u->offset - f->file_offset) *
-			f->zbd_info->num_open_zones / f->io_size;
+
+		/*
+		 * List of opened zones is per-device, shared across all threads.
+		 * Start with quasi-random candidate zone.
+		 * Ignore zones which don't belong to thread's offset/size area.
+		 */
+		open_zone_idx = pick_random_zone_idx(f, io_u);
 		assert(open_zone_idx < f->zbd_info->num_open_zones);
+		tmp_idx = open_zone_idx;
+		for (i = 0; i < f->zbd_info->num_open_zones; i++) {
+			uint32_t tmpz;
+
+			if (tmp_idx >= f->zbd_info->num_open_zones)
+				tmp_idx = 0;
+			tmpz = f->zbd_info->open_zones[tmp_idx];
+
+			if (is_valid_offset(f, f->zbd_info->zone_info[tmpz].start)) {
+				open_zone_idx = tmp_idx;
+				goto found_candidate_zone;
+			}
+
+			tmp_idx++;
+		}
+
+		dprint(FD_ZBD, "%s(%s): no candidate zone\n",
+			__func__, f->file_name);
+		return NULL;
+
+found_candidate_zone:
 		new_zone_idx = f->zbd_info->open_zones[open_zone_idx];
 		if (new_zone_idx == zone_idx)
 			break;

