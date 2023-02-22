Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7461DC61DA4
	for <fio@archiver.kernel.org>; Wed, 22 Feb 2023 13:00:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbjBVNAR (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 22 Feb 2023 08:00:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231740AbjBVNAQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 22 Feb 2023 08:00:16 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0677D2BEC0
        for <fio@vger.kernel.org>; Wed, 22 Feb 2023 05:00:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=+ZrX4yEbcjvZMwPKhqaFo7N9zlVlm1CvLyZaT/M2Hfc=; b=pCyTdG8KcQ0F2VXzQMpo6C7vEI
        EU3mUs2C6Q8hBGHo5BJnf0ezCCMYUaZpXi1nB3zVsivx5olVS0Cse0BZXA72eSdlmB/hKhur1CANq
        uns1FfNCctX1CloG4We7QqeShUIZSnmoENjLasQC8apU39k3DeDS5K/FQvu6eibNc4WSbldDJnc4Q
        ExaLeW9DJHgqCnV4e3+/MR6tM7IlxE/eUQlsSWdYu3kKllEI4+nOPJyZWRczwdwCYb4/0CVLVwVLI
        uVdvx0EhRrYb5kZqtiqOnjpSDBMnssgE9zGfdJrsM0FOwrz8OVxBe4uRUL7m5WXOixb3V/g1JGj3y
        e5aCAjmw==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pUoj8-00CXbY-2C
        for fio@vger.kernel.org;
        Wed, 22 Feb 2023 13:00:07 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id BA8A61BC012D; Wed, 22 Feb 2023 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230222130001.BA8A61BC012D@kernel.dk>
Date:   Wed, 22 Feb 2023 06:00:01 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 7a3a166c6c43e45de1c8085254fbdd011c572f05:

  configure: restore dev-dax and libpmem (2023-02-20 08:53:23 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6946ad5940565d573d85e210b8ea4da5884f0323:

  Merge branch 'Verify_Bad_Hdr_Rand_Seed_Mult_Workload_Iterations_Non_Repeating_Seed' of https://github.com/horshack-dpreview/fio (2023-02-21 09:37:09 -0700)

----------------------------------------------------------------
Horshack (1):
      Bad header rand_seed with time_based or loops with randrepeat=0 verify

Jens Axboe (1):
      Merge branch 'Verify_Bad_Hdr_Rand_Seed_Mult_Workload_Iterations_Non_Repeating_Seed' of https://github.com/horshack-dpreview/fio

 backend.c | 15 +++++----------
 fio.h     |  1 +
 2 files changed, 6 insertions(+), 10 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index cb1fbf42..f494c831 100644
--- a/backend.c
+++ b/backend.c
@@ -637,15 +637,6 @@ static void do_verify(struct thread_data *td, uint64_t verify_bytes)
 	if (td->error)
 		return;
 
-	/*
-	 * verify_state needs to be reset before verification
-	 * proceeds so that expected random seeds match actual
-	 * random seeds in headers. The main loop will reset
-	 * all random number generators if randrepeat is set.
-	 */
-	if (!td->o.rand_repeatable)
-		td_fill_verify_state_seed(td);
-
 	td_set_runstate(td, TD_VERIFYING);
 
 	io_u = NULL;
@@ -1894,8 +1885,12 @@ static void *thread_main(void *data)
 		if (td->o.verify_only && td_write(td))
 			verify_bytes = do_dry_run(td);
 		else {
+			if (!td->o.rand_repeatable)
+				/* save verify rand state to replay hdr seeds later at verify */
+				frand_copy(&td->verify_state_last_do_io, &td->verify_state);
 			do_io(td, bytes_done);
-
+			if (!td->o.rand_repeatable)
+				frand_copy(&td->verify_state, &td->verify_state_last_do_io);
 			if (!ddir_rw_sum(bytes_done)) {
 				fio_mark_td_terminate(td);
 				verify_bytes = 0;
diff --git a/fio.h b/fio.h
index 8da77640..09c44149 100644
--- a/fio.h
+++ b/fio.h
@@ -258,6 +258,7 @@ struct thread_data {
 
 	struct frand_state bsrange_state[DDIR_RWDIR_CNT];
 	struct frand_state verify_state;
+	struct frand_state verify_state_last_do_io;
 	struct frand_state trim_state;
 	struct frand_state delay_state;
 
