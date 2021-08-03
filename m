Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235533AbhHCMAR (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 3 Aug 2021 08:00:17 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DCE4C061757
        for <fio@vger.kernel.org>; Tue,  3 Aug 2021 05:00:06 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mAt5Y-005PO8-7H
        for fio@vger.kernel.org; Tue, 03 Aug 2021 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210803120001.B23211BC0173@kernel.dk>
Date: Tue,  3 Aug 2021 06:00:01 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 572782274da6f7223627f734c6e1818a03c71a6d:

  Merge branch 'master' of https://github.com/anson-lo/fio (2021-08-01 08:36:01 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b61fdc8a555f844ba838c80781972df1239b5959:

  iolog: don't attempt read chunking with blktrace format (2021-08-02 08:23:24 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      iolog: don't attempt read chunking with blktrace format

 fio.h   |  1 +
 iolog.c | 10 +++++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/fio.h b/fio.h
index 51686fd0..6f6b211b 100644
--- a/fio.h
+++ b/fio.h
@@ -420,6 +420,7 @@ struct thread_data {
 	 */
 	struct flist_head io_log_list;
 	FILE *io_log_rfile;
+	unsigned int io_log_blktrace;
 	unsigned int io_log_current;
 	unsigned int io_log_checkmark;
 	unsigned int io_log_highmark;
diff --git a/iolog.c b/iolog.c
index cf264916..26501b4a 100644
--- a/iolog.c
+++ b/iolog.c
@@ -151,7 +151,8 @@ int read_iolog_get(struct thread_data *td, struct io_u *io_u)
 
 	while (!flist_empty(&td->io_log_list)) {
 		int ret;
-		if (td->o.read_iolog_chunked) {
+
+		if (!td->io_log_blktrace && td->o.read_iolog_chunked) {
 			if (td->io_log_checkmark == td->io_log_current) {
 				if (!read_iolog2(td))
 					return 1;
@@ -706,10 +707,13 @@ bool init_iolog(struct thread_data *td)
 		 * Check if it's a blktrace file and load that if possible.
 		 * Otherwise assume it's a normal log file and load that.
 		 */
-		if (is_blktrace(fname, &need_swap))
+		if (is_blktrace(fname, &need_swap)) {
+			td->io_log_blktrace = 1;
 			ret = load_blktrace(td, fname, need_swap);
-		else
+		} else {
+			td->io_log_blktrace = 0;
 			ret = init_iolog_read(td, fname);
+		}
 	} else if (td->o.write_iolog_file)
 		ret = init_iolog_write(td);
 	else

