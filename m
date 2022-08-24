Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00308C00140
	for <fio@archiver.kernel.org>; Wed, 24 Aug 2022 12:00:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236377AbiHXMAO (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 24 Aug 2022 08:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236579AbiHXMAL (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 24 Aug 2022 08:00:11 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B03615B
        for <fio@vger.kernel.org>; Wed, 24 Aug 2022 05:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=B3/sGEzNJZcesqe7LYtXPbT6vIRvmIeDBLScUlh2hEg=; b=e05yteZAYEnCE97iZjSti4F8Rm
        fTzPu3SvC8KOueeVwlzl8nJXBwrsje/JAaHeQZXa+XzUiDjUaaDeS3Y1Bm4EotM8Aui0Z1PJSIpKe
        xkHycJj97e83r/8SE1houNMhKXgjNAIoGqnvO90ElNDvmACMhbXZhwSAKBjxHnDuB2w38ZeZxM1Z2
        B3D61hyrsHF/fLZKjbEni9riSDDb32/qJ29/00XqUzM6Tlc08teLkI82JNufvw3nS3rKuV6lg6z3L
        z5RSQh4Nmb5KODje+AzFXRdOaPkFAgBkzgAljyS2ty1WtvU/YifgZzxdeqMm9r0HIrKt1PI/YjqxP
        oi0yVBkg==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oQp3H-00GIVo-1S
        for fio@vger.kernel.org; Wed, 24 Aug 2022 12:00:07 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 3CE231BC00FD; Wed, 24 Aug 2022 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220824120002.3CE231BC00FD@kernel.dk>
Date:   Wed, 24 Aug 2022 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit d33c7846cc5f175177e194a5489282780e2a04c4:

  Merge branch 'clarify-io-errors' of https://github.com/Hi-Angel/fio (2022-08-16 19:54:17 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 995c45c08c7a362ae0fb2e54e2de27b555a757ab:

  Merge branch 'sigbreak-wait' of github.com:bjpaupor/fio (2022-08-23 17:09:25 -0400)

----------------------------------------------------------------
Brandon Paupore (1):
      Add wait for handling SIGBREAK

Vincent Fu (3):
      Revert "Minor style fixups"
      Revert "Fix multithread issues when operating on a single shared file"
      Merge branch 'sigbreak-wait' of github.com:bjpaupor/fio

 backend.c   | 40 +++++++++++++++++++++-------------------
 file.h      |  1 -
 filesetup.c | 45 ++-------------------------------------------
 3 files changed, 23 insertions(+), 63 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 5159b60d..375a23e4 100644
--- a/backend.c
+++ b/backend.c
@@ -90,6 +90,25 @@ static void sig_int(int sig)
 	}
 }
 
+#ifdef WIN32
+static void sig_break(int sig)
+{
+	struct thread_data *td;
+	int i;
+
+	sig_int(sig);
+
+	/**
+	 * Windows terminates all job processes on SIGBREAK after the handler
+	 * returns, so give them time to wrap-up and give stats
+	 */
+	for_each_td(td, i) {
+		while (td->runstate < TD_EXITED)
+			sleep(1);
+	}
+}
+#endif
+
 void sig_show_status(int sig)
 {
 	show_running_run_stats();
@@ -112,7 +131,7 @@ static void set_sig_handlers(void)
 /* Windows uses SIGBREAK as a quit signal from other applications */
 #ifdef WIN32
 	memset(&act, 0, sizeof(act));
-	act.sa_handler = sig_int;
+	act.sa_handler = sig_break;
 	act.sa_flags = SA_RESTART;
 	sigaction(SIGBREAK, &act, NULL);
 #endif
@@ -2314,25 +2333,8 @@ static void run_threads(struct sk_out *sk_out)
 	for_each_td(td, i) {
 		print_status_init(td->thread_number - 1);
 
-		if (!td->o.create_serialize) {
-			/*
-			 *  When operating on a single rile in parallel,
-			 *  perform single-threaded early setup so that
-			 *  when setup_files() does not run into issues
-			 *  later.
-			*/
-			if (!i && td->o.nr_files == 1) {
-				if (setup_shared_file(td)) {
-					exit_value++;
-					if (td->error)
-						log_err("fio: pid=%d, err=%d/%s\n",
-							(int) td->pid, td->error, td->verror);
-					td_set_runstate(td, TD_REAPED);
-					todo--;
-				}
-			}
+		if (!td->o.create_serialize)
 			continue;
-		}
 
 		if (fio_verify_load_state(td))
 			goto reap;
diff --git a/file.h b/file.h
index e646cf22..da1b8947 100644
--- a/file.h
+++ b/file.h
@@ -201,7 +201,6 @@ struct thread_data;
 extern void close_files(struct thread_data *);
 extern void close_and_free_files(struct thread_data *);
 extern uint64_t get_start_offset(struct thread_data *, struct fio_file *);
-extern int __must_check setup_shared_file(struct thread_data *);
 extern int __must_check setup_files(struct thread_data *);
 extern int __must_check file_invalidate_cache(struct thread_data *, struct fio_file *);
 #ifdef __cplusplus
diff --git a/filesetup.c b/filesetup.c
index 3e2ccf9b..1d3cc5ad 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -143,7 +143,7 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 	if (unlink_file || new_layout) {
 		int ret;
 
-		dprint(FD_FILE, "layout %d unlink %d %s\n", new_layout, unlink_file, f->file_name);
+		dprint(FD_FILE, "layout unlink %s\n", f->file_name);
 
 		ret = td_io_unlink_file(td, f);
 		if (ret != 0 && ret != ENOENT) {
@@ -198,9 +198,6 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 		}
 	}
 
-
-	dprint(FD_FILE, "fill file %s, size %llu\n", f->file_name, (unsigned long long) f->real_file_size);
-
 	left = f->real_file_size;
 	bs = td->o.max_bs[DDIR_WRITE];
 	if (bs > left)
@@ -1081,44 +1078,6 @@ static bool create_work_dirs(struct thread_data *td, const char *fname)
 	return true;
 }
 
-int setup_shared_file(struct thread_data *td)
-{
-	struct fio_file *f;
-	uint64_t file_size;
-	int err = 0;
-
-	if (td->o.nr_files > 1) {
-		log_err("fio: shared file setup called for multiple files\n");
-		return -1;
-	}
-
-	get_file_sizes(td);
-
-	f = td->files[0];
-
-	if (f == NULL) {
-		log_err("fio: NULL shared file\n");
-		return -1;
-	}
-
-	file_size = thread_number * td->o.size;
-	dprint(FD_FILE, "shared setup %s real_file_size=%llu, desired=%llu\n", 
-			f->file_name, (unsigned long long)f->real_file_size, (unsigned long long)file_size);
-
-	if (f->real_file_size < file_size) {
-		dprint(FD_FILE, "fio: extending shared file\n");
-		f->real_file_size = file_size;
-		err = extend_file(td, f);
-		if (!err)
-			err = __file_invalidate_cache(td, f, 0, f->real_file_size);
-		get_file_sizes(td);
-		dprint(FD_FILE, "shared setup new real_file_size=%llu\n", 
-				(unsigned long long)f->real_file_size);
-	}
-
-	return err;
-}
-
 /*
  * Open the files and setup files sizes, creating files if necessary.
  */
@@ -1133,7 +1092,7 @@ int setup_files(struct thread_data *td)
 	const unsigned long long bs = td_min_bs(td);
 	uint64_t fs = 0;
 
-	dprint(FD_FILE, "setup files (thread_number=%d, subjob_number=%d)\n", td->thread_number, td->subjob_number);
+	dprint(FD_FILE, "setup files\n");
 
 	old_state = td_bump_runstate(td, TD_SETTING_UP);
 
