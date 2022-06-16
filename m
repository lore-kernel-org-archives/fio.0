Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40152C43334
	for <fio@archiver.kernel.org>; Thu, 16 Jun 2022 12:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376264AbiFPMAK (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 16 Jun 2022 08:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbiFPMAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 16 Jun 2022 08:00:09 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73CCE5EBDC
        for <fio@vger.kernel.org>; Thu, 16 Jun 2022 05:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=ILQOA/fB1wdvqLKY026tB+a2jsysP+5/VV6pfUZlwUU=; b=LiIIclnDlFCl20HxgapiNblkbt
        JJakQSMlYPSyxkQ/eOw2x2VGIsl4tkBWdryy2e4NFmJv6jF0sMpharDRz2ExndcJLYHZZaTi4+JPU
        mfa2ZnNstANmsGOtbfHuUzxGlxow2VZuCgkvx/VOIET97ex9MSs8FGPICP6NjOpM6fKZkgp3Em7QC
        6or4pPwv5jOFgZlhPHXQ4Gk0+sgqghUj/qiEt4fu/OyQjGlqqYEqbNh8qto6FS978q24uRUJzwVhZ
        1l7SW5rm2D52CSGCtNyDYE/9hr3xcCsxTsHC7Jnj8/hpTBV3qJdd9kRlPwEkdpq8u11VayMp6vKaM
        N5BYxAAQ==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o1oAP-008PPE-E9
        for fio@vger.kernel.org; Thu, 16 Jun 2022 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 18FBC1BC0124; Thu, 16 Jun 2022 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220616120002.18FBC1BC0124@kernel.dk>
Date:   Thu, 16 Jun 2022 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit b5f3adf9e1e40c7bdb76a9e433aa580f7eead740:

  Merge branch 'master' of https://github.com/bvanassche/fio (2022-06-13 18:14:26 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e4d384755e4831cf5bbaa97e0c5b79a3598efbc4:

  Merge branch 'master' of https://github.com/useche/fio (2022-06-15 18:38:41 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'master' of https://github.com/useche/fio

Luis Useche (1):
      Init file_cache to invalid (maj, min)

Vincent Fu (5):
      ioengines: add helper for trims with async ioengines
      ioengines: don't record issue_time if ioengines already do it
      HOWTO: improve description of latency measures
      ioengines: update last_issue if we set issue_time
      ioengines: clean up latency accounting for 3 ioengines

 HOWTO.rst               | 29 ++++++++++++++++++-----------
 blktrace.c              |  5 ++++-
 engines/io_uring.c      | 13 +++++++++++--
 engines/libaio.c        |  9 ++++++++-
 engines/librpma_apm.c   |  2 +-
 engines/librpma_fio.c   |  9 ++++++++-
 engines/librpma_gpspm.c |  2 +-
 engines/rdma.c          |  9 ++++++++-
 ioengines.c             | 44 ++++++++++++++++++++++++++------------------
 ioengines.h             |  2 ++
 10 files changed, 87 insertions(+), 37 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 28ac2b7c..470777e2 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -4165,24 +4165,31 @@ writes in the example above).  In the order listed, they denote:
 **slat**
 		Submission latency (**min** being the minimum, **max** being the
 		maximum, **avg** being the average, **stdev** being the standard
-		deviation).  This is the time it took to submit the I/O.  For
-		sync I/O this row is not displayed as the slat is really the
-		completion latency (since queue/complete is one operation there).
-		This value can be in nanoseconds, microseconds or milliseconds ---
-		fio will choose the most appropriate base and print that (in the
-		example above nanoseconds was the best scale).  Note: in :option:`--minimal` mode
-		latencies are always expressed in microseconds.
+                deviation).  This is the time from when fio initialized the I/O
+                to submission.  For synchronous ioengines this includes the time
+                up until just before the ioengine's queue function is called.
+                For asynchronous ioengines this includes the time up through the
+                completion of the ioengine's queue function (and commit function
+                if it is defined). For sync I/O this row is not displayed as the
+                slat is negligible.  This value can be in nanoseconds,
+                microseconds or milliseconds --- fio will choose the most
+                appropriate base and print that (in the example above
+                nanoseconds was the best scale).  Note: in :option:`--minimal`
+                mode latencies are always expressed in microseconds.
 
 **clat**
 		Completion latency. Same names as slat, this denotes the time from
-		submission to completion of the I/O pieces. For sync I/O, clat will
-		usually be equal (or very close) to 0, as the time from submit to
-		complete is basically just CPU time (I/O has already been done, see slat
-		explanation).
+                submission to completion of the I/O pieces. For sync I/O, this
+                represents the time from when the I/O was submitted to the
+                operating system to when it was completed. For asynchronous
+                ioengines this is the time from when the ioengine's queue (and
+                commit if available) functions were completed to when the I/O's
+                completion was reaped by fio.
 
 **lat**
 		Total latency. Same names as slat and clat, this denotes the time from
 		when fio created the I/O unit to completion of the I/O operation.
+                It is the sum of submission and completion latency.
 
 **bw**
 		Bandwidth statistics based on samples. Same names as the xlat stats,
diff --git a/blktrace.c b/blktrace.c
index 619121c7..00e5f9a9 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -442,7 +442,10 @@ err:
 bool read_blktrace(struct thread_data* td)
 {
 	struct blk_io_trace t;
-	struct file_cache cache = { };
+	struct file_cache cache = {
+		.maj = ~0U,
+		.min = ~0U,
+	};
 	unsigned long ios[DDIR_RWDIR_SYNC_CNT] = { };
 	unsigned long long rw_bs[DDIR_RWDIR_CNT] = { };
 	unsigned long skipped_writes;
diff --git a/engines/io_uring.c b/engines/io_uring.c
index cceafe69..cffc7371 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -608,6 +608,12 @@ static void fio_ioring_queued(struct thread_data *td, int start, int nr)
 
 		start++;
 	}
+
+	/*
+	 * only used for iolog
+	 */
+	if (td->o.read_iolog_file)
+		memcpy(&td->last_issue, &now, sizeof(now));
 }
 
 static int fio_ioring_commit(struct thread_data *td)
@@ -1191,7 +1197,8 @@ static int fio_ioring_cmd_get_max_open_zones(struct thread_data *td,
 static struct ioengine_ops ioengine_uring = {
 	.name			= "io_uring",
 	.version		= FIO_IOOPS_VERSION,
-	.flags			= FIO_ASYNCIO_SYNC_TRIM | FIO_NO_OFFLOAD,
+	.flags			= FIO_ASYNCIO_SYNC_TRIM | FIO_NO_OFFLOAD |
+					FIO_ASYNCIO_SETS_ISSUE_TIME,
 	.init			= fio_ioring_init,
 	.post_init		= fio_ioring_post_init,
 	.io_u_init		= fio_ioring_io_u_init,
@@ -1211,7 +1218,9 @@ static struct ioengine_ops ioengine_uring = {
 static struct ioengine_ops ioengine_uring_cmd = {
 	.name			= "io_uring_cmd",
 	.version		= FIO_IOOPS_VERSION,
-	.flags			= FIO_ASYNCIO_SYNC_TRIM | FIO_NO_OFFLOAD | FIO_MEMALIGN | FIO_RAWIO,
+	.flags			= FIO_ASYNCIO_SYNC_TRIM | FIO_NO_OFFLOAD |
+					FIO_MEMALIGN | FIO_RAWIO |
+					FIO_ASYNCIO_SETS_ISSUE_TIME,
 	.init			= fio_ioring_init,
 	.post_init		= fio_ioring_cmd_post_init,
 	.io_u_init		= fio_ioring_io_u_init,
diff --git a/engines/libaio.c b/engines/libaio.c
index 9c278d06..33b8c12f 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -368,6 +368,12 @@ static void fio_libaio_queued(struct thread_data *td, struct io_u **io_us,
 		memcpy(&io_u->issue_time, &now, sizeof(now));
 		io_u_queued(td, io_u);
 	}
+
+	/*
+	 * only used for iolog
+	 */
+	if (td->o.read_iolog_file)
+		memcpy(&td->last_issue, &now, sizeof(now));
 }
 
 static int fio_libaio_commit(struct thread_data *td)
@@ -511,7 +517,8 @@ static int fio_libaio_init(struct thread_data *td)
 FIO_STATIC struct ioengine_ops ioengine = {
 	.name			= "libaio",
 	.version		= FIO_IOOPS_VERSION,
-	.flags			= FIO_ASYNCIO_SYNC_TRIM,
+	.flags			= FIO_ASYNCIO_SYNC_TRIM |
+					FIO_ASYNCIO_SETS_ISSUE_TIME,
 	.init			= fio_libaio_init,
 	.post_init		= fio_libaio_post_init,
 	.prep			= fio_libaio_prep,
diff --git a/engines/librpma_apm.c b/engines/librpma_apm.c
index d1166ad8..896240dd 100644
--- a/engines/librpma_apm.c
+++ b/engines/librpma_apm.c
@@ -208,7 +208,7 @@ FIO_STATIC struct ioengine_ops ioengine_client = {
 	.errdetails		= librpma_fio_client_errdetails,
 	.close_file		= librpma_fio_file_nop,
 	.cleanup		= client_cleanup,
-	.flags			= FIO_DISKLESSIO,
+	.flags			= FIO_DISKLESSIO | FIO_ASYNCIO_SETS_ISSUE_TIME,
 	.options		= librpma_fio_options,
 	.option_struct_size	= sizeof(struct librpma_fio_options_values),
 };
diff --git a/engines/librpma_fio.c b/engines/librpma_fio.c
index 34818904..a78a1e57 100644
--- a/engines/librpma_fio.c
+++ b/engines/librpma_fio.c
@@ -621,9 +621,16 @@ int librpma_fio_client_commit(struct thread_data *td)
 		}
 	}
 
-	if ((fill_time = fio_fill_issue_time(td)))
+	if ((fill_time = fio_fill_issue_time(td))) {
 		fio_gettime(&now, NULL);
 
+		/*
+		 * only used for iolog
+		 */
+		if (td->o.read_iolog_file)
+			memcpy(&td->last_issue, &now, sizeof(now));
+
+	}
 	/* move executed io_us from queued[] to flight[] */
 	for (i = 0; i < ccd->io_u_queued_nr; i++) {
 		struct io_u *io_u = ccd->io_us_queued[i];
diff --git a/engines/librpma_gpspm.c b/engines/librpma_gpspm.c
index 5cf97472..f00717a7 100644
--- a/engines/librpma_gpspm.c
+++ b/engines/librpma_gpspm.c
@@ -352,7 +352,7 @@ FIO_STATIC struct ioengine_ops ioengine_client = {
 	.errdetails		= librpma_fio_client_errdetails,
 	.close_file		= librpma_fio_file_nop,
 	.cleanup		= client_cleanup,
-	.flags			= FIO_DISKLESSIO,
+	.flags			= FIO_DISKLESSIO | FIO_ASYNCIO_SETS_ISSUE_TIME,
 	.options		= librpma_fio_options,
 	.option_struct_size	= sizeof(struct librpma_fio_options_values),
 };
diff --git a/engines/rdma.c b/engines/rdma.c
index 4eb86652..e3bb2567 100644
--- a/engines/rdma.c
+++ b/engines/rdma.c
@@ -832,6 +832,12 @@ static void fio_rdmaio_queued(struct thread_data *td, struct io_u **io_us,
 		memcpy(&io_u->issue_time, &now, sizeof(now));
 		io_u_queued(td, io_u);
 	}
+
+	/*
+	 * only used for iolog
+	 */
+	if (td->o.read_iolog_file)
+		memcpy(&td->last_issue, &now, sizeof(now));
 }
 
 static int fio_rdmaio_commit(struct thread_data *td)
@@ -1404,7 +1410,8 @@ FIO_STATIC struct ioengine_ops ioengine = {
 	.cleanup		= fio_rdmaio_cleanup,
 	.open_file		= fio_rdmaio_open_file,
 	.close_file		= fio_rdmaio_close_file,
-	.flags			= FIO_DISKLESSIO | FIO_UNIDIR | FIO_PIPEIO,
+	.flags			= FIO_DISKLESSIO | FIO_UNIDIR | FIO_PIPEIO |
+					FIO_ASYNCIO_SETS_ISSUE_TIME,
 	.options		= options,
 	.option_struct_size	= sizeof(struct rdmaio_options),
 };
diff --git a/ioengines.c b/ioengines.c
index 68f307e5..e2316ee4 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -24,6 +24,13 @@
 
 static FLIST_HEAD(engine_list);
 
+static inline bool async_ioengine_sync_trim(struct thread_data *td,
+					    struct io_u	*io_u)
+{
+	return td_ioengine_flagged(td, FIO_ASYNCIO_SYNC_TRIM) &&
+		io_u->ddir == DDIR_TRIM;
+}
+
 static bool check_engine_ops(struct thread_data *td, struct ioengine_ops *ops)
 {
 	if (ops->version != FIO_IOOPS_VERSION) {
@@ -350,17 +357,17 @@ enum fio_q_status td_io_queue(struct thread_data *td, struct io_u *io_u)
 	io_u->resid = 0;
 
 	if (td_ioengine_flagged(td, FIO_SYNCIO) ||
-		(td_ioengine_flagged(td, FIO_ASYNCIO_SYNC_TRIM) && 
-		io_u->ddir == DDIR_TRIM)) {
-		if (fio_fill_issue_time(td))
+		async_ioengine_sync_trim(td, io_u)) {
+		if (fio_fill_issue_time(td)) {
 			fio_gettime(&io_u->issue_time, NULL);
 
-		/*
-		 * only used for iolog
-		 */
-		if (td->o.read_iolog_file)
-			memcpy(&td->last_issue, &io_u->issue_time,
-					sizeof(io_u->issue_time));
+			/*
+			 * only used for iolog
+			 */
+			if (td->o.read_iolog_file)
+				memcpy(&td->last_issue, &io_u->issue_time,
+						sizeof(io_u->issue_time));
+		}
 	}
 
 
@@ -435,17 +442,18 @@ enum fio_q_status td_io_queue(struct thread_data *td, struct io_u *io_u)
 	}
 
 	if (!td_ioengine_flagged(td, FIO_SYNCIO) &&
-		(!td_ioengine_flagged(td, FIO_ASYNCIO_SYNC_TRIM) ||
-		 io_u->ddir != DDIR_TRIM)) {
-		if (fio_fill_issue_time(td))
+		!async_ioengine_sync_trim(td, io_u)) {
+		if (fio_fill_issue_time(td) &&
+			!td_ioengine_flagged(td, FIO_ASYNCIO_SETS_ISSUE_TIME)) {
 			fio_gettime(&io_u->issue_time, NULL);
 
-		/*
-		 * only used for iolog
-		 */
-		if (td->o.read_iolog_file)
-			memcpy(&td->last_issue, &io_u->issue_time,
-					sizeof(io_u->issue_time));
+			/*
+			 * only used for iolog
+			 */
+			if (td->o.read_iolog_file)
+				memcpy(&td->last_issue, &io_u->issue_time,
+						sizeof(io_u->issue_time));
+		}
 	}
 
 	return ret;
diff --git a/ioengines.h b/ioengines.h
index acdb0071..fafa1e48 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -83,6 +83,8 @@ enum fio_ioengine_flags {
 	FIO_ASYNCIO_SYNC_TRIM
 			= 1 << 14,	/* io engine has async ->queue except for trim */
 	FIO_NO_OFFLOAD	= 1 << 15,	/* no async offload */
+	FIO_ASYNCIO_SETS_ISSUE_TIME
+			= 1 << 16,	/* async ioengine with commit function that sets issue_time */
 };
 
 /*
