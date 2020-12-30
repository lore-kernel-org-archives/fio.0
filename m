Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726625AbgL3NAr (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 30 Dec 2020 08:00:47 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1895C061799
        for <fio@vger.kernel.org>; Wed, 30 Dec 2020 05:00:06 -0800 (PST)
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kub59-0007qf-L7
        for fio@vger.kernel.org; Wed, 30 Dec 2020 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20201230130002.296521BC0124@kernel.dk>
Date: Wed, 30 Dec 2020 06:00:02 -0700 (MST)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit b0340c5c7de38b3f4632366247489da7c52d5cfb:

  Merge branch 'terse_units' of https://github.com/sitsofe/fio (2020-12-24 07:38:18 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a64b7d6e9b3e5174e034f7c147de71e4b51b2a01:

  Merge branch 'fix-get-next-file' of https://github.com/aclamk/fio (2020-12-29 16:36:32 -0700)

----------------------------------------------------------------
Adam Kupczyk (1):
      io_u: Fix bad interaction with --openfiles and non-sequential file selection policy

Jens Axboe (1):
      Merge branch 'fix-get-next-file' of https://github.com/aclamk/fio

 io_u.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/io_u.c b/io_u.c
index f30fc037..00a219c2 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1326,8 +1326,10 @@ static struct fio_file *__get_next_file(struct thread_data *td)
 	if (f && fio_file_open(f) && !fio_file_closing(f)) {
 		if (td->o.file_service_type == FIO_FSERVICE_SEQ)
 			goto out;
-		if (td->file_service_left--)
-			goto out;
+		if (td->file_service_left) {
+		  td->file_service_left--;
+		  goto out;
+		}
 	}
 
 	if (td->o.file_service_type == FIO_FSERVICE_RR ||

