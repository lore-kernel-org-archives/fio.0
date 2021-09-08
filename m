Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA82BC433F5
	for <fio@archiver.kernel.org>; Wed,  8 Sep 2021 18:35:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4E746113E
	for <fio@archiver.kernel.org>; Wed,  8 Sep 2021 18:35:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349035AbhIHSgR (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 8 Sep 2021 14:36:17 -0400
Received: from mga03.intel.com ([134.134.136.65]:21827 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235730AbhIHSgR (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 8 Sep 2021 14:36:17 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10101"; a="220618705"
X-IronPort-AV: E=Sophos;i="5.85,278,1624345200"; 
   d="scan'208";a="220618705"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2021 11:35:07 -0700
X-IronPort-AV: E=Sophos;i="5.85,278,1624345200"; 
   d="scan'208";a="430744837"
Received: from fm42an009.fm.intel.com ([10.132.70.54])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2021 11:35:06 -0700
From:   Andrzej Jakowski <andrzej.jakowski@intel.com>
To:     fio@vger.kernel.org, axboe@kernel.dk
Cc:     Andrzej Jakowski <andrzej.jakowski@intel.com>
Subject: [PATCH v3] t/io_uring: allow flexible IO threads assignment
Date:   Wed,  8 Sep 2021 11:35:00 -0700
Message-Id: <1631126100-28184-1-git-send-email-andrzej.jakowski@intel.com>
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

Changes from v2:
 * Printing error and usage when no files are specified
---
 t/io_uring.c | 61 ++++++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 41 insertions(+), 20 deletions(-)

diff --git a/t/io_uring.c b/t/io_uring.c
index 77d2785..23c9d60 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -543,7 +543,7 @@ static void file_depths(char *buf)
 	}
 }
 
-static void usage(char *argv)
+static void usage(char *argv, int status)
 {
 	printf("%s [options] -- [filenames]\n"
 		" -d <int>  : IO Depth, default %d\n"
@@ -556,14 +556,15 @@ static void usage(char *argv)
 		" -n <int>  : Number of threads, default %d\n",
 		argv, DEPTH, BATCH_SUBMIT, BATCH_COMPLETE, BS, polled,
 		fixedbufs, register_files, nthreads);
-	exit(0);
+	exit(status);
 }
 
 int main(int argc, char *argv[])
 {
 	struct submitter *s;
 	unsigned long done, calls, reap;
-	int err, i, j, flags, fd, opt;
+	int err, i, j, flags, fd, opt, threads_per_f, threads_rem = 0, nfiles;
+	struct file f;
 	char *fdepths;
 	void *ret;
 
@@ -601,7 +602,7 @@ int main(int argc, char *argv[])
 		case 'h':
 		case '?':
 		default:
-			usage(argv[0]);
+			usage(argv[0], 0);
 			break;
 		}
 	}
@@ -620,37 +621,57 @@ int main(int argc, char *argv[])
 
 	j = 0;
 	i = optind;
+	nfiles = argc - i;
+	if (!nfiles) {
+		printf("no files specified\n");
+		usage(argv[0], 1);
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
 
-		printf("Added file %s (submitter %d)\n", argv[i], s->index);
-		s->nr_files++;
+			if (s->nr_files == MAX_FDS) {
+				printf("Max number of files (%d) reached\n", MAX_FDS);
+				break;
+			}
+
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

