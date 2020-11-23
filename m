Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387890AbgKWNAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 23 Nov 2020 08:00:07 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B12E1C0613CF
        for <fio@vger.kernel.org>; Mon, 23 Nov 2020 05:00:05 -0800 (PST)
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1khBRr-0003iQ-PW
        for fio@vger.kernel.org; Mon, 23 Nov 2020 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20201123130001.C774B1BC013B@kernel.dk>
Date: Mon, 23 Nov 2020 06:00:01 -0700 (MST)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 2ee239fb084355e115cf8c2bf8051e8807c4222a:

  Merge branch 'segmented-threads' (2020-11-13 10:06:26 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 9107a641e67f27003fa6cbe7b55b1ec6a0239197:

  error out if ENOSPC during file layout (2020-11-22 09:54:44 -0700)

----------------------------------------------------------------
Kushal Kumaran (1):
      error out if ENOSPC during file layout

 filesetup.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/filesetup.c b/filesetup.c
index f4360a6f..42c5f630 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -231,13 +231,12 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 						break;
 					log_info("fio: ENOSPC on laying out "
 						 "file, stopping\n");
-					break;
 				}
 				td_verror(td, errno, "write");
 			} else
 				td_verror(td, EIO, "write");
 
-			break;
+			goto err;
 		}
 	}
 

