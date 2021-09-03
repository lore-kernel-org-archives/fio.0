Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234910AbhICMBI (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 3 Sep 2021 08:01:08 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE7F3C061575
        for <fio@vger.kernel.org>; Fri,  3 Sep 2021 05:00:08 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mM7rZ-000La8-N4
        for fio@vger.kernel.org; Fri, 03 Sep 2021 12:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210903120002.4BBE91BC012A@kernel.dk>
Date: Fri,  3 Sep 2021 06:00:02 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 4f2152278e0b3c35ded02fb3e6fb550eab7bedcd:

  t/io_uring: further simplify inflight tracking (2021-08-28 15:37:25 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f3463241727215e228a60dc3b9a1ba2996f149a1:

  oslib: Fix blkzoned_get_max_open_zones() (2021-09-02 20:56:19 -0600)

----------------------------------------------------------------
Damien Le Moal (1):
      oslib: Fix blkzoned_get_max_open_zones()

 oslib/linux-blkzoned.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/oslib/linux-blkzoned.c b/oslib/linux-blkzoned.c
index 4e441d29..185bd501 100644
--- a/oslib/linux-blkzoned.c
+++ b/oslib/linux-blkzoned.c
@@ -169,8 +169,10 @@ int blkzoned_get_max_open_zones(struct thread_data *td, struct fio_file *f,
 		return -EIO;
 
 	max_open_str = blkzoned_get_sysfs_attr(f->file_name, "queue/max_open_zones");
-	if (!max_open_str)
+	if (!max_open_str) {
+		*max_open_zones = 0;
 		return 0;
+	}
 
 	dprint(FD_ZBD, "%s: max open zones supported by device: %s\n",
 	       f->file_name, max_open_str);

