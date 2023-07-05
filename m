Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4800BEB64DD
	for <fio@archiver.kernel.org>; Wed,  5 Jul 2023 21:29:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbjGEV3Y (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 5 Jul 2023 17:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbjGEV3X (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 5 Jul 2023 17:29:23 -0400
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AFAD1980
        for <fio@vger.kernel.org>; Wed,  5 Jul 2023 14:29:22 -0700 (PDT)
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1b7e6512973so41657085ad.3
        for <fio@vger.kernel.org>; Wed, 05 Jul 2023 14:29:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688592561; x=1691184561;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L93CarvdKxKI4+N88FyJjjr2mkkCoeNnxt1pUfdmie8=;
        b=Y2pX+ZM6WV65Mud00Ys8d+3dQLLKkfbgaHr+yTa1RaLYrpGxI/oNg+Cubad3TURv/4
         iJsOvSAmeA7gi2heEl54sWdLrvo/xYEtxnnC7lW8PQoPDVmDrLofvq/+SFq6wglBR0es
         /nCyFvO6K4rg0qiTeuvimwkplAPTeP2uV/RVq8fryxdGOj+op5txa3fclJuCoDofq/Wz
         BJ5XpXVm4T3PqFokqK8qPlN2dZyni6BBrg6QYKBShE/CnXC7zAiZEZmm+CWIhE9A1t9r
         PkwByrJ0lqunkr1QjNE6p25fLCFRkAopp/7WXepU1pr1kJ1YasxJnu9VpIwGs0Rw+Z25
         vcqw==
X-Gm-Message-State: ABy/qLY1u3wox8F1CBX9korfC++9LLeKOUUwUeWdPf1QXNh8ZLidz/Xl
        7qddN+IW6Nf64EtfYqOHS0J+MAkc83k=
X-Google-Smtp-Source: APBJJlE0Nq1AiuLB0we5bbiStmnopKnoWn4MhUTh3FWLBwxaQyO800eNU1K2MioJV1mZC+hEVsO3yA==
X-Received: by 2002:a17:903:234e:b0:1b8:9bd4:297 with SMTP id c14-20020a170903234e00b001b89bd40297mr184757plh.15.1688592561491;
        Wed, 05 Jul 2023 14:29:21 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:2f70:a1a0:520:4dfc])
        by smtp.gmail.com with ESMTPSA id b1-20020a170902d50100b001b86f1b5797sm9847686plg.302.2023.07.05.14.29.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jul 2023 14:29:21 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     fio@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH] zbd: Support finishing zones on Android
Date:   Wed,  5 Jul 2023 14:29:15 -0700
Message-ID: <20230705212915.3373438-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

BLKFINISHZONE is missing from older versions of the Android NDK header
files. Hence, define BLKFINISHZONE if it has not been defined and detect
at runtime whether or not the kernel supports finishing zones.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 oslib/linux-blkzoned.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/oslib/linux-blkzoned.c b/oslib/linux-blkzoned.c
index c3130d0e2a1b..722e09925b3d 100644
--- a/oslib/linux-blkzoned.c
+++ b/oslib/linux-blkzoned.c
@@ -22,6 +22,9 @@
 #include "zbd_types.h"
 
 #include <linux/blkzoned.h>
+#ifndef BLKFINISHZONE
+#define BLKFINISHZONE _IOW(0x12, 136, struct blk_zone_range)
+#endif
 
 /*
  * If the uapi headers installed on the system lacks zone capacity support,
@@ -312,7 +315,6 @@ int blkzoned_reset_wp(struct thread_data *td, struct fio_file *f,
 int blkzoned_finish_zone(struct thread_data *td, struct fio_file *f,
 			 uint64_t offset, uint64_t length)
 {
-#ifdef BLKFINISHZONE
 	struct blk_zone_range zr = {
 		.sector         = offset >> 9,
 		.nr_sectors     = length >> 9,
@@ -327,21 +329,19 @@ int blkzoned_finish_zone(struct thread_data *td, struct fio_file *f,
 			return -errno;
 	}
 
-	if (ioctl(fd, BLKFINISHZONE, &zr) < 0)
+	if (ioctl(fd, BLKFINISHZONE, &zr) < 0) {
 		ret = -errno;
+		/*
+		 * Kernel versions older than 5.5 do not support BLKFINISHZONE
+		 * and return the ENOTTY error code. These old kernels only
+		 * support block devices that close zones automatically.
+		 */
+		if (ret == ENOTTY)
+			ret = 0;
+	}
 
 	if (f->fd < 0)
 		close(fd);
 
 	return ret;
-#else
-	/*
-	 * Kernel versions older than 5.5 does not support BLKFINISHZONE. These
-	 * old kernels assumed zones are closed automatically at max_open_zones
-	 * limit. Also they did not support max_active_zones limit. Then there
-	 * was no need to finish zones to avoid errors caused by max_open_zones
-	 * or max_active_zones. For those old versions, just do nothing.
-	 */
-	return 0;
-#endif
 }
