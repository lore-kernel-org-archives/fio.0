Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qe0-f46.google.com ([209.85.128.46]:53963 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab3GVXP5 (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 22 Jul 2013 19:15:57 -0400
Received: by mail-qe0-f46.google.com with SMTP id nd7so4119969qeb.33
        for <fio@vger.kernel.org>; Mon, 22 Jul 2013 16:15:56 -0700 (PDT)
From: Yufei Ren <yufei.ren@stonybrook.edu>
Subject: [PATCH] Update for RDMA io engine's compatibility
Date: Mon, 22 Jul 2013 19:14:55 -0400
Message-Id: <1374534895-3218-1-git-send-email-yufei.ren@stonybrook.edu>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Yufei Ren <yufei.ren@stonybrook.edu>

Since the RDMA engine is not able to be successfully compiled, this
patch accommodates it to the upstream version of fio.
---
 configure      |  2 +-
 engines/rdma.c | 10 ++++------
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/configure b/configure
index 98af5ff..c00a3a4 100755
--- a/configure
+++ b/configure
@@ -1127,7 +1127,7 @@ fi
 if test "$sfaa" = "yes" ; then
   output_sym "CONFIG_SFAA"
 fi
-if test "$libverbs" = "yes" -a "rdmacm" = "yes" ; then
+if test "$libverbs" = "yes" -a "$rdmacm" = "yes" ; then
   output_sym "CONFIG_RDMA"
 fi
 if test "$clock_gettime" = "yes" ; then
diff --git a/engines/rdma.c b/engines/rdma.c
index ea1af2b..81f1673 100644
--- a/engines/rdma.c
+++ b/engines/rdma.c
@@ -528,10 +528,10 @@ static int fio_rdmaio_getevents(struct thread_data *td, unsigned int min,
 {
 	struct rdmaio_data *rd = td->io_ops->data;
 	enum ibv_wc_opcode comp_opcode;
-	comp_opcode = IBV_WC_RDMA_WRITE;
 	struct ibv_cq *ev_cq;
 	void *ev_ctx;
 	int ret, r = 0;
+	comp_opcode = IBV_WC_RDMA_WRITE;
 
 	switch (rd->rdma_protocol) {
 	case FIO_RDMA_MEM_WRITE:
@@ -1049,12 +1049,11 @@ static int check_set_rlimits(struct thread_data *td)
 static int fio_rdmaio_init(struct thread_data *td)
 {
 	struct rdmaio_data *rd = td->io_ops->data;
-	struct flist_head *entry;
 	unsigned int max_bs;
 	unsigned int port;
 	char host[64], buf[128];
 	char *sep, *portp, *modep;
-	int ret, i = 0;
+	int ret, i;
 
 	if (td_rw(td)) {
 		log_err("fio: rdma connections must be read OR write\n");
@@ -1153,8 +1152,8 @@ static int fio_rdmaio_init(struct thread_data *td)
 
 	max_bs = max(td->o.max_bs[DDIR_READ], td->o.max_bs[DDIR_WRITE]);
 	/* register each io_u in the free list */
-	flist_for_each(entry, &td->io_u_freelist) {
-		struct io_u *io_u = flist_entry(entry, struct io_u, list);
+	for (i = 0; i < td->io_u_freelist.nr; i++) {
+		struct io_u *io_u = td->io_u_freelist.io_us[i];
 
 		io_u->engine_data = malloc(sizeof(struct rdma_io_u_data));
 		memset(io_u->engine_data, 0, sizeof(struct rdma_io_u_data));
@@ -1177,7 +1176,6 @@ static int fio_rdmaio_init(struct thread_data *td)
 #if 0
 		log_info("fio: Send rkey %x addr %" PRIx64 " len %d to client\n", io_u->mr->rkey, io_u->buf, max_bs); */
 #endif
-		i++;
 	}
 
 	rd->send_buf.nr = htonl(i);
-- 
1.8.1.4

