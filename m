Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B01B3C433EF
	for <fio@archiver.kernel.org>; Wed,  8 Sep 2021 15:07:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8692A611C6
	for <fio@archiver.kernel.org>; Wed,  8 Sep 2021 15:07:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349384AbhIHPJB (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 8 Sep 2021 11:09:01 -0400
Received: from mga07.intel.com ([134.134.136.100]:56444 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349279AbhIHPJA (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 8 Sep 2021 11:09:00 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10101"; a="284211808"
X-IronPort-AV: E=Sophos;i="5.85,278,1624345200"; 
   d="scan'208";a="284211808"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2021 08:07:46 -0700
X-IronPort-AV: E=Sophos;i="5.85,278,1624345200"; 
   d="scan'208";a="524867526"
Received: from fm42an009.fm.intel.com ([10.132.70.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2021 08:07:46 -0700
From:   Andrzej Jakowski <andrzej.jakowski@intel.com>
To:     fio@vger.kernel.org, axboe@kernel.dk
Cc:     Andrzej Jakowski <andrzej.jakowski@intel.com>
Subject: [PATCH v2] t/io_uring: allow flexible IO threads assignment
Date:   Wed,  8 Sep 2021 08:07:32 -0700
Message-Id: <1631113652-25526-1-git-send-email-andrzej.jakowski@intel.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

This patch allows to flexibly assign IO threads to fileset. When
you specify:

t/io_uring -n 5 /dev/dev1 dev/dev2

First file/device will get 3 IO threads and second file/device
remaining 2 IO threads. When there is more files then IO threads,
IO thread may get assigned multiple files/devices.

Signed-off-by: Andrzej Jakowski <andrzej.jakowski@intel.com>
---
Changes from v1:
 * Handling crashing case when no files are specified
---
 t/io_uring.c | 55 ++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 38 insertions(+), 17 deletions(-)

diff --git a/t/io_uring.c b/t/io_uring.c
index 77d2785..e7ff142 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -563,7 +563,8 @@ int main(int argc, char *argv[])
 {
 	struct submitter *s;
 	unsigned long done, calls, reap;
-	int err, i, j, flags, fd, opt;
+	int err, i, j, flags, fd, opt, threads_per_f, threads_rem = 0, nfiles;
+	struct file f;
 	char *fdepths;
 	void *ret;
 
@@ -620,37 +621,57 @@ int main(int argc, char *argv[])
 
 	j = 0;
 	i = optind;
+	nfiles = argc - i;
+	if (!nfiles) {
+		printf("no files specified\n");
+		return 1;
+	}
+	threads_per_f = nthreads / nfiles;
+	/* make sure each thread gets assigned files */
+	if (threads_per_f == 0) {
+		threads_per_f = 1;
+	} else {
+		threads_rem = nthreads - threads_per_f * nfiles;
+	}
 	while (!do_nop && i < argc) {
-		struct file *f;
+		int k, limit;
+
+		memset(&f, 0, sizeof(f));
 
-		s = get_submitter(j);
-		if (s->nr_files == MAX_FDS) {
-			printf("Max number of files (%d) reached\n", MAX_FDS);
-			break;
-		}
 		fd = open(argv[i], flags);
 		if (fd < 0) {
 			perror("open");
 			return 1;
 		}
-
-		f = &s->files[s->nr_files];
-		f->real_fd = fd;
-		if (get_file_size(f)) {
+		f.real_fd = fd;
+		if (get_file_size(&f)) {
 			printf("failed getting size of device/file\n");
 			return 1;
 		}
-		if (f->max_blocks <= 1) {
+		if (f.max_blocks <= 1) {
 			printf("Zero file/device size?\n");
 			return 1;
 		}
-		f->max_blocks--;
+		f.max_blocks--;
+
+		limit = threads_per_f;
+		limit += threads_rem > 0 ? 1 : 0;
+		for (k = 0; k < limit; k++) {
+			s = get_submitter((j + k) % nthreads);
+
+			if (s->nr_files == MAX_FDS) {
+				printf("Max number of files (%d) reached\n", MAX_FDS);
+				break;
+			}
 
-		printf("Added file %s (submitter %d)\n", argv[i], s->index);
-		s->nr_files++;
+			memcpy(&s->files[s->nr_files], &f, sizeof(f));
+
+			printf("Added file %s (submitter %d)\n", argv[i], s->index);
+			s->nr_files++;
+		}
+		threads_rem--;
 		i++;
-		if (++j >= nthreads)
-			j = 0;
+		j += limit;
 	}
 
 	arm_sig_int();
-- 
1.8.3.1

