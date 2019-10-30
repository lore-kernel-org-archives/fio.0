Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:50474 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726242AbfJ3MAF (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 30 Oct 2019 08:00:05 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iPmdv-000201-6Z
        for fio@vger.kernel.org; Wed, 30 Oct 2019 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20191030120001.C91F02C00F5@kernel.dk>
Date: Wed, 30 Oct 2019 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c656b9056e45f9acd1d374a85c5becf7cc6a00ca:

  Merge branch 'doc_fixes' of https://github.com/sitsofe/fio (2019-10-24 12:04:09 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 8c302eb9706963e07d6d79998e15bede77b94520:

  Merge branch 'patch-1' of https://github.com/hannesweisbach/fio (2019-10-29 13:39:14 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      Merge branch '1029_tet' of https://github.com/optimistyzy/fio
      Merge branch 'patch-1' of https://github.com/hannesweisbach/fio

Ziye Yang (1):
      backend: fix the memory leak if fio_memalign fails,

hannesweisbach (1):
      Fix output redirection of exec_prerun/_postrun

 backend.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index fe868271..1c339408 100644
--- a/backend.c
+++ b/backend.c
@@ -1236,7 +1236,7 @@ static int init_io_u(struct thread_data *td)
 		ptr = fio_memalign(cl_align, sizeof(*io_u), td_offload_overlap(td));
 		if (!ptr) {
 			log_err("fio: unable to allocate aligned memory\n");
-			break;
+			return 1;
 		}
 
 		io_u = ptr;
@@ -1469,12 +1469,12 @@ static bool keep_running(struct thread_data *td)
 
 static int exec_string(struct thread_options *o, const char *string, const char *mode)
 {
-	size_t newlen = strlen(string) + strlen(o->name) + strlen(mode) + 9 + 1;
+	size_t newlen = strlen(string) + strlen(o->name) + strlen(mode) + 13 + 1;
 	int ret;
 	char *str;
 
 	str = malloc(newlen);
-	sprintf(str, "%s &> %s.%s.txt", string, o->name, mode);
+	sprintf(str, "%s > %s.%s.txt 2>&1", string, o->name, mode);
 
 	log_info("%s : Saving output of %s in %s.%s.txt\n",o->name, mode, o->name, mode);
 	ret = system(str);

