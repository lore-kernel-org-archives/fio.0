Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730825AbgJOMAK (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 15 Oct 2020 08:00:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB1AC0613DC
        for <fio@vger.kernel.org>; Thu, 15 Oct 2020 05:00:06 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kT1vQ-0005IU-K3
        for fio@vger.kernel.org; Thu, 15 Oct 2020 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20201015120002.1233F1BC0147@kernel.dk>
Date: Thu, 15 Oct 2020 06:00:02 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 8cf503ce5956e4c287e13d5c7761a03fbb4b54cc:

  Merge branch 'patch-1' of https://github.com/chengli-rutgers/fio into master (2020-10-13 13:07:37 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 8bfe330eb42739d503d35d0b7d96f98c5c544204:

  Disallow offload IO mode for engines marked with FIO_NO_OFFLOAD (2020-10-14 20:11:56 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Disallow offload IO mode for engines marked with FIO_NO_OFFLOAD

 engines/io_uring.c | 2 +-
 ioengines.c        | 2 +-
 ioengines.h        | 3 ++-
 3 files changed, 4 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 69f48859..b997c8d8 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -806,7 +806,7 @@ static int fio_ioring_close_file(struct thread_data *td, struct fio_file *f)
 static struct ioengine_ops ioengine = {
 	.name			= "io_uring",
 	.version		= FIO_IOOPS_VERSION,
-	.flags			= FIO_ASYNCIO_SYNC_TRIM,
+	.flags			= FIO_ASYNCIO_SYNC_TRIM | FIO_NO_OFFLOAD,
 	.init			= fio_ioring_init,
 	.post_init		= fio_ioring_post_init,
 	.io_u_init		= fio_ioring_io_u_init,
diff --git a/ioengines.c b/ioengines.c
index d3be8026..3e43ef2f 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -45,7 +45,7 @@ static bool check_engine_ops(struct thread_data *td, struct ioengine_ops *ops)
 	 * async engines aren't reliable with offload
 	 */
 	if ((td->o.io_submit_mode == IO_MODE_OFFLOAD) &&
-	    !(ops->flags & FIO_FAKEIO)) {
+	    (ops->flags & FIO_NO_OFFLOAD)) {
 		log_err("%s: can't be used with offloaded submit. Use a sync "
 			"engine\n", ops->name);
 		return true;
diff --git a/ioengines.h b/ioengines.h
index 54dadba2..fbe52fa4 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -77,7 +77,8 @@ enum fio_ioengine_flags {
 	FIO_NOSTATS	= 1 << 12,	/* don't do IO stats */
 	FIO_NOFILEHASH	= 1 << 13,	/* doesn't hash the files for lookup later. */
 	FIO_ASYNCIO_SYNC_TRIM
-			= 1 << 14	/* io engine has async ->queue except for trim */
+			= 1 << 14,	/* io engine has async ->queue except for trim */
+	FIO_NO_OFFLOAD	= 1 << 15,	/* no async offload */
 };
 
 /*

