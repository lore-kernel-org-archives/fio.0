Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231573AbhCLNAO (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 12 Mar 2021 08:00:14 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9FBDC061574
        for <fio@vger.kernel.org>; Fri, 12 Mar 2021 05:00:13 -0800 (PST)
Received: from [65.144.74.35] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lKhOg-00BUAK-JC
        for fio@vger.kernel.org; Fri, 12 Mar 2021 13:00:09 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210312130002.1FD2E1BC0132@kernel.dk>
Date: Fri, 12 Mar 2021 06:00:02 -0700 (MST)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 9697503cacf01c2b83f09973a6c8f9439156ce63:

  Merge branch 'fallock-blkdev' of https://github.com/dmonakhov/fio (2021-03-10 13:30:23 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 014ab48afcbcf442464acc7427fcd0f194f64bf4:

  Merge branch 'dev_luye_github' of https://github.com/louisluSCU/fio (2021-03-11 11:50:49 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'dev_luye_github' of https://github.com/louisluSCU/fio

luye (1):
      Fix reading multiple blktrace replay files

 iolog.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

---

Diff of recent changes:

diff --git a/iolog.c b/iolog.c
index fa40c857..cf264916 100644
--- a/iolog.c
+++ b/iolog.c
@@ -607,12 +607,11 @@ static int open_socket(const char *path)
 /*
  * open iolog, check version, and call appropriate parser
  */
-static bool init_iolog_read(struct thread_data *td)
+static bool init_iolog_read(struct thread_data *td, char *fname)
 {
-	char buffer[256], *p, *fname;
+	char buffer[256], *p;
 	FILE *f = NULL;
 
-	fname = get_name_by_idx(td->o.read_iolog_file, td->subjob_number);
 	dprint(FD_IO, "iolog: name=%s\n", fname);
 
 	if (is_socket(fname)) {
@@ -701,15 +700,16 @@ bool init_iolog(struct thread_data *td)
 
 	if (td->o.read_iolog_file) {
 		int need_swap;
+		char * fname = get_name_by_idx(td->o.read_iolog_file, td->subjob_number);
 
 		/*
 		 * Check if it's a blktrace file and load that if possible.
 		 * Otherwise assume it's a normal log file and load that.
 		 */
-		if (is_blktrace(td->o.read_iolog_file, &need_swap))
-			ret = load_blktrace(td, td->o.read_iolog_file, need_swap);
+		if (is_blktrace(fname, &need_swap))
+			ret = load_blktrace(td, fname, need_swap);
 		else
-			ret = init_iolog_read(td);
+			ret = init_iolog_read(td, fname);
 	} else if (td->o.write_iolog_file)
 		ret = init_iolog_write(td);
 	else

