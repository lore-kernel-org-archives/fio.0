Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57A56C61DA3
	for <fio@archiver.kernel.org>; Fri, 24 Feb 2023 13:00:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbjBXNAL (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 24 Feb 2023 08:00:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbjBXNAK (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 24 Feb 2023 08:00:10 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBD7463DF3
        for <fio@vger.kernel.org>; Fri, 24 Feb 2023 05:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=nOqfkDopxID/jpxjEbaz+MAh2ROdVbBxhSIPIU8izkI=; b=awMwYMWhOpqRk7Dq45/9vbPuOr
        UstrU9IOxrF2qsAZ4+ehrUXPagpl/bvK7PQXTIZhWN1+/26aLND/WoXUf/sriaev74fdbQLv/0TZV
        8zlrzyS7DMB9SSkJ+9UC8PIY3xLfVM19nmlG6jr/3vhp4oIM0+4+KaEQXFcHMbM1s8bWWT4HaDyd/
        iwPk3PpUm0140PTu6bfLqIzpP4TrTk2vWHS99kz5Nr7HdzJYFa4/2Z2Qi5T4dlgmGt0v8W2JzSILA
        Fnrvg0gNzKDo1g+SKfVoiR6wGpErtx57jb2sPqMiGaVdwkdR/0zgs49CIEg7O2Mb8BuPqYipuGadh
        WDZfsW3w==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pVXgD-00FFf8-8A
        for fio@vger.kernel.org; Fri, 24 Feb 2023 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 3041F1BC0175; Fri, 24 Feb 2023 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230224130002.3041F1BC0175@kernel.dk>
Date:   Fri, 24 Feb 2023 06:00:02 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 6946ad5940565d573d85e210b8ea4da5884f0323:

  Merge branch 'Verify_Bad_Hdr_Rand_Seed_Mult_Workload_Iterations_Non_Repeating_Seed' of https://github.com/horshack-dpreview/fio (2023-02-21 09:37:09 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b5904c0d7434a49770cdb90eada1c724f0f7fe4e:

  Merge branch 'master' of https://github.com/bvanassche/fio (2023-02-23 20:17:31 -0500)

----------------------------------------------------------------
Bart Van Assche (3):
      io_u: Add a debug message in fill_io_u()
      zbd: Report the zone capacity
      zbd: Make an error message more detailed

Vincent Fu (1):
      Merge branch 'master' of https://github.com/bvanassche/fio

 io_u.c | 4 +++-
 zbd.c  | 9 +++++----
 2 files changed, 8 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/io_u.c b/io_u.c
index eb617e64..d50d8465 100644
--- a/io_u.c
+++ b/io_u.c
@@ -984,8 +984,10 @@ static int fill_io_u(struct thread_data *td, struct io_u *io_u)
 	offset = io_u->offset;
 	if (td->o.zone_mode == ZONE_MODE_ZBD) {
 		ret = zbd_adjust_block(td, io_u);
-		if (ret == io_u_eof)
+		if (ret == io_u_eof) {
+			dprint(FD_IO, "zbd_adjust_block() returned io_u_eof\n");
 			return 1;
+		}
 	}
 
 	if (io_u->offset + io_u->buflen > io_u->file->real_file_size) {
diff --git a/zbd.c b/zbd.c
index ba2c0401..d6f8f800 100644
--- a/zbd.c
+++ b/zbd.c
@@ -807,8 +807,8 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 		goto out;
 	}
 
-	dprint(FD_ZBD, "Device %s has %d zones of size %"PRIu64" KB\n",
-	       f->file_name, nr_zones, zone_size / 1024);
+	dprint(FD_ZBD, "Device %s has %d zones of size %"PRIu64" KB and capacity %"PRIu64" KB\n",
+	       f->file_name, nr_zones, zone_size / 1024, zones[0].capacity / 1024);
 
 	zbd_info = scalloc(1, sizeof(*zbd_info) +
 			   (nr_zones + 1) * sizeof(zbd_info->zone_info[0]));
@@ -848,8 +848,9 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 			p->cond = z->cond;
 
 			if (j > 0 && p->start != p[-1].start + zone_size) {
-				log_info("%s: invalid zone data\n",
-					 f->file_name);
+				log_info("%s: invalid zone data [%d:%d]: %"PRIu64" + %"PRIu64" != %"PRIu64"\n",
+					 f->file_name, j, i,
+					 p[-1].start, zone_size, p->start);
 				ret = -EINVAL;
 				goto out;
 			}
