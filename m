Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728147AbgFDMA2 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 4 Jun 2020 08:00:28 -0400
Received: from merlin.infradead.org (unknown [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B94C03E96D
        for <fio@vger.kernel.org>; Thu,  4 Jun 2020 05:00:26 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jgoXZ-0006oi-AV
        for fio@vger.kernel.org; Thu, 04 Jun 2020 12:00:09 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200604120001.A02171BC0CCC@kernel.dk>
Date: Thu,  4 Jun 2020 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 63a4b9cca4ba3aa4101051402cbbe946ced17a49:

  gfio: don't have multiple versions of main_ui (2020-06-02 08:20:03 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 00ca8df5468e90bbf1256ec90fc9ae14b1706ccc:

  zbd: Fix max_open_zones checks (2020-06-03 20:15:35 -0600)

----------------------------------------------------------------
Shin'ichiro Kawasaki (1):
      zbd: Fix max_open_zones checks

 zbd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/zbd.c b/zbd.c
index a7572c9a..dc302606 100644
--- a/zbd.c
+++ b/zbd.c
@@ -989,7 +989,7 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 
 	assert(is_valid_offset(f, io_u->offset));
 
-	if (td->o.job_max_open_zones) {
+	if (td->o.max_open_zones || td->o.job_max_open_zones) {
 		/*
 		 * This statement accesses f->zbd_info->open_zones[] on purpose
 		 * without locking.
@@ -1018,7 +1018,7 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 
 		zone_lock(td, f, z);
 		pthread_mutex_lock(&f->zbd_info->mutex);
-		if (td->o.job_max_open_zones == 0)
+		if (td->o.max_open_zones == 0 && td->o.job_max_open_zones == 0)
 			goto examine_zone;
 		if (f->zbd_info->num_open_zones == 0) {
 			pthread_mutex_unlock(&f->zbd_info->mutex);
@@ -1074,7 +1074,7 @@ examine_zone:
 	}
 	dprint(FD_ZBD, "%s(%s): closing zone %d\n", __func__, f->file_name,
 	       zone_idx);
-	if (td->o.job_max_open_zones)
+	if (td->o.max_open_zones || td->o.job_max_open_zones)
 		zbd_close_zone(td, f, open_zone_idx);
 	pthread_mutex_unlock(&f->zbd_info->mutex);
 

