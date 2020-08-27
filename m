Return-Path: <fio-owner@vger.kernel.org>
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:54041 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728991AbgH0MYH (ORCPT
        <rfc822;fio@vger.kernel.org>); Thu, 27 Aug 2020 08:24:07 -0400
Date: Thu, 27 Aug 2020 14:15:33 +0200
From: Andreas Herrmann <aherrmann@suse.com>
Subject: [PATCH 3/3] cgroup: Try to use blkio.bfq.weight if blkio.weight is
 not available
Message-ID: <20200827121533.GF6041@suselix>
References: <20200827120722.GC6041@suselix>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200827120722.GC6041@suselix>
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: fio@vger.kernel.org

Newer kernels just provide blkio.bfq.weight for blkio contoller. Try
to use this attribute when legacy file is not available.

Signed-off-by: Andreas Herrmann <aherrmann@suse.com>
---
 cgroup.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/cgroup.c b/cgroup.c
index 43513733..6edb5b14 100644
--- a/cgroup.c
+++ b/cgroup.c
@@ -218,8 +218,14 @@ int cgroup_setup(struct thread_data *td, struct flist_head *clist, struct cgroup
 		}
 		if (write_int_to_file(td, root, "blkio.weight",
 					td->o.cgroup_weight,
-					"cgroup open weight"))
-			goto err;
+					"cgroup open blkio.weight")) {
+			td_clear_error(td);
+			log_err("Trying to use blkio.bfq.weight\n");
+			if (write_int_to_file(td, root, "blkio.bfq.weight",
+						td->o.cgroup_weight,
+						"cgroup open blkio.bfq.weight"))
+				goto err;
+		}
 	}
 
 	if (!cgroup_write_pid(td, root, (*mnt)->cgroup2)) {
-- 
2.28.0


