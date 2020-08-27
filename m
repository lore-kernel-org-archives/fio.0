Return-Path: <fio-owner@vger.kernel.org>
Received: from de-smtp-delivery-102.mimecast.com ([51.163.158.102]:60132 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729004AbgH0MJW (ORCPT
        <rfc822;fio@vger.kernel.org>); Thu, 27 Aug 2020 08:09:22 -0400
Date: Thu, 27 Aug 2020 14:08:50 +0200
From: Andreas Herrmann <aherrmann@suse.com>
Subject: [PATCH 1/3] cgroup: Fix typo
Message-ID: <20200827120850.GD6041@suselix>
References: <20200827120722.GC6041@suselix>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200827120722.GC6041@suselix>
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: fio@vger.kernel.org


Signed-off-by: Andreas Herrmann <aherrmann@suse.com>
---
 cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cgroup.c b/cgroup.c
index 77e31a4d..9ee1b8c8 100644
--- a/cgroup.c
+++ b/cgroup.c
@@ -191,7 +191,7 @@ int cgroup_setup(struct thread_data *td, struct flist_head *clist, struct cgroup
 
 	if (td->o.cgroup_weight) {
 		if ((*mnt)->cgroup2) {
-			log_err("fio: cgroup weit doesn't work with cgroup2\n");
+			log_err("fio: cgroup weight doesn't work with cgroup2\n");
 			goto err;
 		}
 		if (write_int_to_file(td, root, "blkio.weight",
-- 
2.28.0


