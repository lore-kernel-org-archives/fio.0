Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46EC7C4332F
	for <fio@archiver.kernel.org>; Tue, 14 Sep 2021 12:00:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27898610A2
	for <fio@archiver.kernel.org>; Tue, 14 Sep 2021 12:00:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232493AbhINMBZ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 14 Sep 2021 08:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232486AbhINMBZ (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 14 Sep 2021 08:01:25 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FAD3C061574
        for <fio@vger.kernel.org>; Tue, 14 Sep 2021 05:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=qRhghhCc+eqtbtSFhBuBgNPflNNSRr6aXoJe9daFKus=; b=X7/yUqtjkLPB/WMH/9d/Xxw2rN
        99II3fziUKbUJwYDObXPgmeXddEs6mthTORkAWD/wzvCI6UxLI90EkaQOrl2qVd5Ech+iyrF0pFR7
        0LqhC1gJXK6x4LdhZ9EFwISorEQtQaY2Bj1bOKpHR5oYkVg7eH6qLq5oii7sIC5fYROxuBcC9STyG
        DlJtARqMQoeM6/CRAL3aJ3L2MGthXWeKKQ6iyoeKqeRvP1/pThc4ldlbyaByAeMUokVgJjaAEkiw6
        4+hKCtnan666v6aT35vk6drp4slwGZAU0cqQR1owhEWaUUi1rTtASIAHIKc5GrzGbz78+Geq1FFL3
        qv/IFx4w==;
Received: from [65.144.74.35] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mQ76c-0038Fo-7z
        for fio@vger.kernel.org; Tue, 14 Sep 2021 12:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 4C5241BC0168; Tue, 14 Sep 2021 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20210914120002.4C5241BC0168@kernel.dk>
Date:   Tue, 14 Sep 2021 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 25425cb4a5531b1b3f26eba4e49866d944e0f1fb:

  Merge branch 'ft' of https://github.com/ErwanAliasr1/fio (2021-09-08 15:40:47 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d5c3be105af97c71bc2095ffd19343e4217abcd7:

  zbd: remove dead zone retrieval call (2021-09-13 14:09:01 -0600)

----------------------------------------------------------------
Jens Axboe (3):
      t/io_uring: don't require a file for do_nop runs
      t/io_uring: add -N option for do_nop
      zbd: remove dead zone retrieval call

 t/io_uring.c | 38 +++++++++++++++++++++-----------------
 zbd.c        |  1 -
 2 files changed, 21 insertions(+), 18 deletions(-)

---

Diff of recent changes:

diff --git a/t/io_uring.c b/t/io_uring.c
index c9ca3e9d..aed6fdbd 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -553,9 +553,10 @@ static void usage(char *argv, int status)
 		" -p <bool> : Polled IO, default %d\n"
 		" -B <bool> : Fixed buffers, default %d\n"
 		" -F <bool> : Register files, default %d\n"
-		" -n <int>  : Number of threads, default %d\n",
+		" -n <int>  : Number of threads, default %d\n"
+		" -N <bool> : Perform just no-op requests, default %d\n",
 		argv, DEPTH, BATCH_SUBMIT, BATCH_COMPLETE, BS, polled,
-		fixedbufs, register_files, nthreads);
+		fixedbufs, register_files, nthreads, do_nop);
 	exit(status);
 }
 
@@ -568,12 +569,10 @@ int main(int argc, char *argv[])
 	char *fdepths;
 	void *ret;
 
-	if (!do_nop && argc < 2) {
-		printf("%s: filename [options]\n", argv[0]);
-		return 1;
-	}
+	if (!do_nop && argc < 2)
+		usage(argv[0], 1);
 
-	while ((opt = getopt(argc, argv, "d:s:c:b:p:B:F:n:h?")) != -1) {
+	while ((opt = getopt(argc, argv, "d:s:c:b:p:B:F:n:N:h?")) != -1) {
 		switch (opt) {
 		case 'd':
 			depth = atoi(optarg);
@@ -603,6 +602,9 @@ int main(int argc, char *argv[])
 				usage(argv[0], 1);
 			}
 			break;
+		case 'N':
+			do_nop = !!atoi(optarg);
+			break;
 		case 'h':
 		case '?':
 		default:
@@ -626,16 +628,18 @@ int main(int argc, char *argv[])
 	j = 0;
 	i = optind;
 	nfiles = argc - i;
-	if (!nfiles) {
-		printf("No files specified\n");
-		usage(argv[0], 1);
-	}
-	threads_per_f = nthreads / nfiles;
-	/* make sure each thread gets assigned files */
-	if (threads_per_f == 0) {
-		threads_per_f = 1;
-	} else {
-		threads_rem = nthreads - threads_per_f * nfiles;
+	if (!do_nop) {
+		if (!nfiles) {
+			printf("No files specified\n");
+			usage(argv[0], 1);
+		}
+		threads_per_f = nthreads / nfiles;
+		/* make sure each thread gets assigned files */
+		if (threads_per_f == 0) {
+			threads_per_f = 1;
+		} else {
+			threads_rem = nthreads - threads_per_f * nfiles;
+		}
 	}
 	while (!do_nop && i < argc) {
 		int k, limit;
diff --git a/zbd.c b/zbd.c
index dd1abc58..64415d2b 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1857,7 +1857,6 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 				       f->file_name);
 				goto eof;
 			}
-			zbd_zone_nr(f, zb);
 		}
 		/* Check whether the zone reset threshold has been exceeded */
 		if (td->o.zrf.u.f) {
