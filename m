Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:42200 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753605AbeCWMAS (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 23 Mar 2018 08:00:18 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1ezLMn-0003df-DL
        for fio@vger.kernel.org; Fri, 23 Mar 2018 12:00:17 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180323120002.165182C0119@kernel.dk>
Date: Fri, 23 Mar 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 7ad2ddffe2bdc5e47fb86cab276db1db9e350f1b:

  sg: fix sign extension (2018-03-21 20:09:36 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 87c6f22bf24da4679849ccf778451b8432c2b368:

  server: use scalloc() for sk_out allocation (2018-03-22 11:29:25 -0600)

----------------------------------------------------------------
Jens Axboe (3):
      smalloc: oom cleanups
      Merge branch 'gcc' of https://github.com/sitsofe/fio
      server: use scalloc() for sk_out allocation

Sitsofe Wheeler (1):
      compiler: set minimum compiler version to GCC 4.1.0

 backend.c                |  9 ++++++---
 cgroup.c                 |  3 +++
 compiler/compiler-gcc3.h | 10 ----------
 compiler/compiler.h      |  6 ++----
 filesetup.c              |  9 +++++----
 gettime-thread.c         |  2 --
 server.c                 |  2 +-
 7 files changed, 17 insertions(+), 24 deletions(-)
 delete mode 100644 compiler/compiler-gcc3.h

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index a92b1e3..fc83ed1 100644
--- a/backend.c
+++ b/backend.c
@@ -2477,7 +2477,8 @@ int fio_backend(struct sk_out *sk_out)
 	helper_thread_create(startup_sem, sk_out);
 
 	cgroup_list = smalloc(sizeof(*cgroup_list));
-	INIT_FLIST_HEAD(cgroup_list);
+	if (cgroup_list)
+		INIT_FLIST_HEAD(cgroup_list);
 
 	run_threads(sk_out);
 
@@ -2507,8 +2508,10 @@ int fio_backend(struct sk_out *sk_out)
 	}
 
 	free_disk_util();
-	cgroup_kill(cgroup_list);
-	sfree(cgroup_list);
+	if (cgroup_list) {
+		cgroup_kill(cgroup_list);
+		sfree(cgroup_list);
+	}
 	sfree(cgroup_mnt);
 
 	fio_sem_remove(startup_sem);
diff --git a/cgroup.c b/cgroup.c
index 380e37e..629047b 100644
--- a/cgroup.c
+++ b/cgroup.c
@@ -147,6 +147,9 @@ int cgroup_setup(struct thread_data *td, struct flist_head *clist, char **mnt)
 {
 	char *root;
 
+	if (!clist)
+		return 1;
+
 	if (!*mnt) {
 		*mnt = find_cgroup_mnt(td);
 		if (!*mnt)
diff --git a/compiler/compiler-gcc3.h b/compiler/compiler-gcc3.h
deleted file mode 100644
index 566987a..0000000
--- a/compiler/compiler-gcc3.h
+++ /dev/null
@@ -1,10 +0,0 @@
-#ifndef FIO_COMPILER_GCC3_H
-#define FIO_COMPILER_GCC3_H
-
-#if __GNUC_MINOR__ >= 4
-#ifndef __must_check
-#define __must_check		__attribute__((warn_unused_result))
-#endif
-#endif
-
-#endif
diff --git a/compiler/compiler.h b/compiler/compiler.h
index 4d92ac4..dacb737 100644
--- a/compiler/compiler.h
+++ b/compiler/compiler.h
@@ -2,12 +2,10 @@
 #define FIO_COMPILER_H
 
 /* IWYU pragma: begin_exports */
-#if __GNUC__ >= 4
+#if __GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 1)
 #include "compiler-gcc4.h"
-#elif __GNUC__ == 3
-#include "compiler-gcc3.h"
 #else
-#error Compiler too old, need gcc at least gcc 3.x
+#error Compiler too old, need at least gcc 4.1.0
 #endif
 /* IWYU pragma: end_exports */
 
diff --git a/filesetup.c b/filesetup.c
index c115f7b..b246e0f 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1608,8 +1608,9 @@ int add_file(struct thread_data *td, const char *fname, int numjob, int inc)
 		f->file_name = strdup(file_name);
 	else
 		f->file_name = smalloc_strdup(file_name);
-	if (!f->file_name)
-		assert(0);
+
+	/* can't handle smalloc failure from here */
+	assert(f->file_name);
 
 	get_file_type(f);
 
@@ -1814,9 +1815,9 @@ void dup_files(struct thread_data *td, struct thread_data *org)
 				__f->file_name = strdup(f->file_name);
 			else
 				__f->file_name = smalloc_strdup(f->file_name);
-			if (!__f->file_name)
-				assert(0);
 
+			/* can't handle smalloc failure from here */
+			assert(__f->file_name);
 			__f->filetype = f->filetype;
 		}
 
diff --git a/gettime-thread.c b/gettime-thread.c
index eb535a0..0a2cc6c 100644
--- a/gettime-thread.c
+++ b/gettime-thread.c
@@ -15,8 +15,6 @@ void fio_gtod_init(void)
 		return;
 
 	fio_ts = smalloc(sizeof(*fio_ts));
-	if (!fio_ts)
-		log_err("fio: smalloc pool exhausted\n");
 }
 
 static void fio_gtod_update(void)
diff --git a/server.c b/server.c
index 15dc2c4..d3f6977 100644
--- a/server.c
+++ b/server.c
@@ -1359,7 +1359,7 @@ static int accept_loop(int listen_sk)
 
 		dprint(FD_NET, "server: connect from %s\n", from);
 
-		sk_out = smalloc(sizeof(*sk_out));
+		sk_out = scalloc(1, sizeof(*sk_out));
 		if (!sk_out) {
 			close(sk);
 			return -1;
