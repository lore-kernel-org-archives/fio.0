Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50167 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbcGNMAE (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 14 Jul 2016 08:00:04 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1bNfJD-0005ff-Cv
	for fio@vger.kernel.org; Thu, 14 Jul 2016 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160714120001.CE13C2C23FF@kernel.dk>
Date: Thu, 14 Jul 2016 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit b86ad8f1c3845419742715e94526f60e1e2bf596:

  workqueue: rename private to priv for compiling as c++ (2016-07-11 16:52:34 -0400)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 883e4841d5466955ad464ee3a6b37e009cfa80ef:

  Merge branch 'fix_verify' of https://github.com/charles-jacobsen/fio (2016-07-13 09:13:46 -0700)

----------------------------------------------------------------
Charlie Jacobsen (1):
      verify: Reset verify_state before verification phase.

Jens Axboe (1):
      Merge branch 'fix_verify' of https://github.com/charles-jacobsen/fio

 backend.c |  9 +++++++++
 fio.h     |  1 +
 init.c    | 15 ++++++++++++++-
 3 files changed, 24 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index dc6f530..58c77cb 100644
--- a/backend.c
+++ b/backend.c
@@ -603,6 +603,15 @@ static void do_verify(struct thread_data *td, uint64_t verify_bytes)
 	if (td->error)
 		return;
 
+	/*
+	 * verify_state needs to be reset before verification
+	 * proceeds so that expected random seeds match actual
+	 * random seeds in headers. The main loop will reset
+	 * all random number generators if randrepeat is set.
+	 */
+	if (!td->o.rand_repeatable)
+		td_fill_verify_state_seed(td);
+
 	td_set_runstate(td, TD_VERIFYING);
 
 	io_u = NULL;
diff --git a/fio.h b/fio.h
index 7e6311c..8a0ebe3 100644
--- a/fio.h
+++ b/fio.h
@@ -502,6 +502,7 @@ extern void fio_options_dup_and_init(struct option *);
 extern void fio_options_mem_dupe(struct thread_data *);
 extern void options_mem_dupe(void *data, struct fio_option *options);
 extern void td_fill_rand_seeds(struct thread_data *);
+extern void td_fill_verify_state_seed(struct thread_data *);
 extern void add_job_opts(const char **, int);
 extern char *num2str(uint64_t, int, int, int, int);
 extern int ioengine_load(struct thread_data *);
diff --git a/init.c b/init.c
index 7166ea7..065a71a 100644
--- a/init.c
+++ b/init.c
@@ -936,12 +936,25 @@ static void init_rand_file_service(struct thread_data *td)
 	}
 }
 
+void td_fill_verify_state_seed(struct thread_data *td)
+{
+	bool use64;
+
+	if (td->o.random_generator == FIO_RAND_GEN_TAUSWORTHE64)
+		use64 = 1;
+	else
+		use64 = 0;
+
+	init_rand_seed(&td->verify_state, td->rand_seeds[FIO_RAND_VER_OFF],
+		use64);
+}
+
 static void td_fill_rand_seeds_internal(struct thread_data *td, bool use64)
 {
 	int i;
 
 	init_rand_seed(&td->bsrange_state, td->rand_seeds[FIO_RAND_BS_OFF], use64);
-	init_rand_seed(&td->verify_state, td->rand_seeds[FIO_RAND_VER_OFF], use64);
+	td_fill_verify_state_seed(td);
 	init_rand_seed(&td->rwmix_state, td->rand_seeds[FIO_RAND_MIX_OFF], false);
 
 	if (td->o.file_service_type == FIO_FSERVICE_RANDOM)
