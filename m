Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:46721 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751900AbdHAMAP (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 1 Aug 2017 08:00:15 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dcVqQ-0001De-Uv
        for fio@vger.kernel.org; Tue, 01 Aug 2017 12:00:15 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170801120002.730172C1196@kernel.dk>
Date: Tue,  1 Aug 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit f271a3f2d598b9dd8036543071cad573295d8e8e:

  don't print native_fallocate() error if ENOSYS (2017-07-27 14:44:23 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2e2b80c58afa2da6cf2e6c792db16757b2244847:

  Merge branch 'master' of https://github.com/dublio/fio (2017-07-31 08:15:17 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'master' of https://github.com/dublio/fio

weiping zhang (1):
      filesetup: keep OS_O_DIRECT flag when pre-allocating file

 filesetup.c | 2 ++
 1 file changed, 2 insertions(+)

---

Diff of recent changes:

diff --git a/filesetup.c b/filesetup.c
index 839aefc..0e5599a 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -146,6 +146,8 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 		flags |= O_CREAT;
 	if (new_layout)
 		flags |= O_TRUNC;
+	if (td->o.odirect)
+		flags |= OS_O_DIRECT;
 
 #ifdef WIN32
 	flags |= _O_BINARY;
