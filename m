Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71EA9C04A68
	for <fio@archiver.kernel.org>; Thu, 28 Jul 2022 12:00:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235732AbiG1MAL (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 28 Jul 2022 08:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236779AbiG1MAK (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 28 Jul 2022 08:00:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70DDA1BF
        for <fio@vger.kernel.org>; Thu, 28 Jul 2022 05:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=DBUTXDERMldgTPMpMo4hK0hujpNJhcA8lCiEj55rYpE=; b=fdb02u3SU3mIdakPGks2AVz2VA
        Wpe6tGZ3j9j0QazqF9Ut8Hed6eunzXdzK83Om81KqwcR/Lc0gNGyoiaxrj37QzhBo/ygdg6M9kmKX
        UIiezjLoc+tAxbjqu5iDrhlPqqBA9VTSK9hvpntgAQgpC+xAJY0TaOtbgAEHBc0rH3po43UnM0n5o
        Ggfly8PFQHrIm33yWVy+XcVRFQbDQiHaLdJvMAJ/tWsWAYSMNg7JwQZgKs8U9G4G38NhNfNxbirg7
        enLF34nLbMByaAL7vMmgsHMIRpD4Rb8Cg1UtskiAu3zoP4fOLxVRn88qkcUpuMZ/J3rZPp1wA9WB3
        6p1Gl8pA==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oH2BQ-003oAJ-Av
        for fio@vger.kernel.org; Thu, 28 Jul 2022 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 1A7091BC0124; Thu, 28 Jul 2022 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220728120002.1A7091BC0124@kernel.dk>
Date:   Thu, 28 Jul 2022 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit dff32ddb97f2257975b6047474d665a5de7f7bbc:

  ci: install libnfs for linux and macos builds (2022-07-22 15:57:27 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5b99196735a245224ec9321f796a9da30654ae6c:

  README: add maintainer section (2022-07-27 21:04:31 -0600)

----------------------------------------------------------------
Chris Weber (1):
      Fix multithread issues when operating on a single shared file

Jens Axboe (3):
      Merge branch 'proposed_fix' of https://github.com/weberc-ntap/fio
      Minor style fixups
      README: add maintainer section

 README.rst  | 11 +++++++++++
 backend.c   | 19 ++++++++++++++++++-
 file.h      |  1 +
 filesetup.c | 45 +++++++++++++++++++++++++++++++++++++++++++--
 4 files changed, 73 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/README.rst b/README.rst
index 4d736eaf..67420903 100644
--- a/README.rst
+++ b/README.rst
@@ -81,6 +81,17 @@ benchmark/test tools out there weren't flexible enough to do what he wanted.
 Jens Axboe <axboe@kernel.dk> 20060905
 
 
+Maintainers
+-----------
+
+Fio is maintained by Jens Axboe <axboe@kernel.dk and
+Vincent Fu <vincentfu@gmail.com> - however, for reporting bugs please use
+the fio reflector or the GitHub page rather than email any of them
+directly. By using the public resources, others will be able to learn from
+the responses too. Chances are also good that other members will be able to
+help with your inquiry as well.
+
+
 Binary packages
 ---------------
 
diff --git a/backend.c b/backend.c
index e5bb4e25..5159b60d 100644
--- a/backend.c
+++ b/backend.c
@@ -2314,8 +2314,25 @@ static void run_threads(struct sk_out *sk_out)
 	for_each_td(td, i) {
 		print_status_init(td->thread_number - 1);
 
-		if (!td->o.create_serialize)
+		if (!td->o.create_serialize) {
+			/*
+			 *  When operating on a single rile in parallel,
+			 *  perform single-threaded early setup so that
+			 *  when setup_files() does not run into issues
+			 *  later.
+			*/
+			if (!i && td->o.nr_files == 1) {
+				if (setup_shared_file(td)) {
+					exit_value++;
+					if (td->error)
+						log_err("fio: pid=%d, err=%d/%s\n",
+							(int) td->pid, td->error, td->verror);
+					td_set_runstate(td, TD_REAPED);
+					todo--;
+				}
+			}
 			continue;
+		}
 
 		if (fio_verify_load_state(td))
 			goto reap;
diff --git a/file.h b/file.h
index da1b8947..e646cf22 100644
--- a/file.h
+++ b/file.h
@@ -201,6 +201,7 @@ struct thread_data;
 extern void close_files(struct thread_data *);
 extern void close_and_free_files(struct thread_data *);
 extern uint64_t get_start_offset(struct thread_data *, struct fio_file *);
+extern int __must_check setup_shared_file(struct thread_data *);
 extern int __must_check setup_files(struct thread_data *);
 extern int __must_check file_invalidate_cache(struct thread_data *, struct fio_file *);
 #ifdef __cplusplus
diff --git a/filesetup.c b/filesetup.c
index ab6c488b..e0592209 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -143,7 +143,7 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 	if (unlink_file || new_layout) {
 		int ret;
 
-		dprint(FD_FILE, "layout unlink %s\n", f->file_name);
+		dprint(FD_FILE, "layout %d unlink %d %s\n", new_layout, unlink_file, f->file_name);
 
 		ret = td_io_unlink_file(td, f);
 		if (ret != 0 && ret != ENOENT) {
@@ -198,6 +198,9 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 		}
 	}
 
+
+	dprint(FD_FILE, "fill file %s, size %llu\n", f->file_name, (unsigned long long) f->real_file_size);
+
 	left = f->real_file_size;
 	bs = td->o.max_bs[DDIR_WRITE];
 	if (bs > left)
@@ -1078,6 +1081,44 @@ static bool create_work_dirs(struct thread_data *td, const char *fname)
 	return true;
 }
 
+int setup_shared_file(struct thread_data *td)
+{
+	struct fio_file *f;
+	uint64_t file_size;
+	int err = 0;
+
+	if (td->o.nr_files > 1) {
+		log_err("fio: shared file setup called for multiple files\n");
+		return -1;
+	}
+
+	get_file_sizes(td);
+
+	f = td->files[0];
+
+	if (f == NULL) {
+		log_err("fio: NULL shared file\n");
+		return -1;
+	}
+
+	file_size = thread_number * td->o.size;
+	dprint(FD_FILE, "shared setup %s real_file_size=%llu, desired=%llu\n", 
+			f->file_name, (unsigned long long)f->real_file_size, (unsigned long long)file_size);
+
+	if (f->real_file_size < file_size) {
+		dprint(FD_FILE, "fio: extending shared file\n");
+		f->real_file_size = file_size;
+		err = extend_file(td, f);
+		if (!err)
+			err = __file_invalidate_cache(td, f, 0, f->real_file_size);
+		get_file_sizes(td);
+		dprint(FD_FILE, "shared setup new real_file_size=%llu\n", 
+				(unsigned long long)f->real_file_size);
+	}
+
+	return err;
+}
+
 /*
  * Open the files and setup files sizes, creating files if necessary.
  */
@@ -1092,7 +1133,7 @@ int setup_files(struct thread_data *td)
 	const unsigned long long bs = td_min_bs(td);
 	uint64_t fs = 0;
 
-	dprint(FD_FILE, "setup files\n");
+	dprint(FD_FILE, "setup files (thread_number=%d, subjob_number=%d)\n", td->thread_number, td->subjob_number);
 
 	old_state = td_bump_runstate(td, TD_SETTING_UP);
 
