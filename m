Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D5B3C77B7A
	for <fio@archiver.kernel.org>; Wed, 24 May 2023 12:00:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjEXMAJ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 24 May 2023 08:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjEXMAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 24 May 2023 08:00:08 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B6FB135
        for <fio@vger.kernel.org>; Wed, 24 May 2023 05:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=YawILr8en0Mu3Z0DstKTbdMP6s06NVJprOixcS+OxHE=; b=DmFva4Xd2zg9HPzXCNFh9tchyD
        6AJwBFgxwKj04to95YQpyQwkeAVPJUW2KeYqpJMYzGImpjSWgzSvgoC45gVLFpt76qOiBDygkMhVL
        PaQofbKqtEqK2F8I1lopNHeNV3F6DajYODwE0Nrf9OhfOpljlKGLKbUoehVNTdS9MGnbvg9D+JiOv
        FKywskEBsT2nOyv1NvTLHo2pBeKhvezjNUzQ+7HuIOulf7haqpd2RQKvStntHZsk3g6fKYGKobTxx
        YxL6Z5ZluD09LYDEX3o33Xt+57M/3bOYe7Yxupn4REvbPlHMZo3xN1SWshJdffJOGR8ccO4JRb/gz
        Xgpy4PbA==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1q1n9w-004ymk-2e
        for fio@vger.kernel.org;
        Wed, 24 May 2023 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 558971BC017F; Wed, 24 May 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230524120001.558971BC017F@kernel.dk>
Date:   Wed, 24 May 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 870ea00243b1290541334bec2a56428c9f68dba6:

  io_ur: make sure that sync errors are noticed upfront (2023-05-19 19:30:38 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5a649e2dddc4d8ad163b0cf57f7cea00a2e94a33:

  Fio 3.35 (2023-05-23 12:33:03 -0600)

----------------------------------------------------------------
Bart Van Assche (2):
      zbd: Make an error message more detailed
      zbd: Report the zone capacity

Jens Axboe (1):
      Fio 3.35

Vincent Fu (1):
      Merge branch 'master' of https://github.com/bvanassche/fio

 FIO-VERSION-GEN |  2 +-
 zbd.c           | 15 ++++++++++++---
 2 files changed, 13 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index f1585d34..4b0d56d0 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-3.34
+DEF_VER=fio-3.35
 
 LF='
 '
diff --git a/zbd.c b/zbd.c
index 351b3971..5f1a7d7f 100644
--- a/zbd.c
+++ b/zbd.c
@@ -213,8 +213,8 @@ static int zbd_report_zones(struct thread_data *td, struct fio_file *f,
 		ret = blkzoned_report_zones(td, f, offset, zones, nr_zones);
 	if (ret < 0) {
 		td_verror(td, errno, "report zones failed");
-		log_err("%s: report zones from sector %"PRIu64" failed (%d).\n",
-			f->file_name, offset >> 9, errno);
+		log_err("%s: report zones from sector %"PRIu64" failed (nr_zones=%d; errno=%d).\n",
+			f->file_name, offset >> 9, nr_zones, errno);
 	} else if (ret == 0) {
 		td_verror(td, errno, "Empty zone report");
 		log_err("%s: report zones from sector %"PRIu64" is empty.\n",
@@ -776,7 +776,8 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 	int nr_zones, nrz;
 	struct zbd_zone *zones, *z;
 	struct fio_zone_info *p;
-	uint64_t zone_size, offset;
+	uint64_t zone_size, offset, capacity;
+	bool same_zone_cap = true;
 	struct zoned_block_device_info *zbd_info = NULL;
 	int i, j, ret = -ENOMEM;
 
@@ -793,6 +794,7 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 	}
 
 	zone_size = zones[0].len;
+	capacity = zones[0].capacity;
 	nr_zones = (f->real_file_size + zone_size - 1) / zone_size;
 
 	if (td->o.zone_size == 0) {
@@ -821,6 +823,8 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 						     PTHREAD_MUTEX_RECURSIVE);
 			p->start = z->start;
 			p->capacity = z->capacity;
+			if (capacity != z->capacity)
+				same_zone_cap = false;
 
 			switch (z->cond) {
 			case ZBD_ZONE_COND_NOT_WP:
@@ -876,6 +880,11 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 	f->zbd_info->zone_size_log2 = is_power_of_2(zone_size) ?
 		ilog2(zone_size) : 0;
 	f->zbd_info->nr_zones = nr_zones;
+
+	if (same_zone_cap)
+		dprint(FD_ZBD, "Zone capacity = %"PRIu64" KB\n",
+		       capacity / 1024);
+
 	zbd_info = NULL;
 	ret = 0;
 
