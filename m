Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B193EC433FE
	for <fio@archiver.kernel.org>; Wed,  8 Sep 2021 04:10:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DB3861108
	for <fio@archiver.kernel.org>; Wed,  8 Sep 2021 04:10:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbhIHEMF (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 8 Sep 2021 00:12:05 -0400
Received: from mga17.intel.com ([192.55.52.151]:40658 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229472AbhIHEME (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 8 Sep 2021 00:12:04 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10100"; a="200580710"
X-IronPort-AV: E=Sophos;i="5.85,276,1624345200"; 
   d="scan'208";a="200580710"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2021 21:10:57 -0700
X-IronPort-AV: E=Sophos;i="5.85,276,1624345200"; 
   d="scan'208";a="605600618"
Received: from fm42an009.fm.intel.com ([10.132.70.54])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2021 21:10:57 -0700
From:   Andrzej Jakowski <andrzej.jakowski@intel.com>
To:     fio@vger.kernel.org, axboe@kernel.dk
Cc:     Andrzej Jakowski <andrzej.jakowski@intel.com>
Subject: [PATCH 1/2] t/io_uring: fixes in output
Date:   Tue,  7 Sep 2021 21:10:44 -0700
Message-Id: <1631074245-16080-1-git-send-email-andrzej.jakowski@intel.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Provide description of available options in usage command
and fix alignment so they look pretty.

Also remove debug output.

Signed-off-by: Andrzej Jakowski <andrzej.jakowski@intel.com>
---
 t/io_uring.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/t/io_uring.c b/t/io_uring.c
index 3130e46..28c76b0 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -539,12 +539,16 @@ static void file_depths(char *buf)
 static void usage(char *argv)
 {
 	printf("%s [options] -- [filenames]\n"
-		" -d <int> : IO Depth, default %d\n"
-		" -s <int> : Batch submit, default %d\n"
-		" -c <int> : Batch complete, default %d\n"
-		" -b <int> : Block size, default %d\n"
-		" -p <bool> : Polled IO, default %d\n",
-		argv, DEPTH, BATCH_SUBMIT, BATCH_COMPLETE, BS, polled);
+		" -d <int>  : IO Depth, default %d\n"
+		" -s <int>  : Batch submit, default %d\n"
+		" -c <int>  : Batch complete, default %d\n"
+		" -b <int>  : Block size, default %d\n"
+		" -p <bool> : Polled IO, default %d\n"
+		" -B <bool> : Fixed buffers, default %d\n"
+		" -F <bool> : Register files, default %d\n"
+		" -n <int>  : Number of threads, default %d\n",
+		argv, DEPTH, BATCH_SUBMIT, BATCH_COMPLETE, BS, polled,
+		fixedbufs, register_files, nthreads);
 	exit(0);
 }
 
@@ -609,7 +613,6 @@ int main(int argc, char *argv[])
 
 	j = 0;
 	i = optind;
-	printf("i %d, argc %d\n", i, argc);
 	while (!do_nop && i < argc) {
 		struct file *f;
 
-- 
1.8.3.1

