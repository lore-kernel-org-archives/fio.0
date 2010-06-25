Return-Path: <fio-owner@vger.kernel.org>
Received: from g1t0026.austin.hp.com ([15.216.28.33]:21886 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab0FYPYU (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 25 Jun 2010 11:24:20 -0400
Received: from g1t0038.austin.hp.com (g1t0038.austin.hp.com [16.236.32.44])
	by g1t0026.austin.hp.com (Postfix) with ESMTP id 6E9CBC405
	for <fio@vger.kernel.org>; Fri, 25 Jun 2010 15:24:20 +0000 (UTC)
Received: from blh01server01.usa.hp.com (blh01server01.usa.hp.com [16.125.125.3])
	by g1t0038.austin.hp.com (Postfix) with ESMTP id 54B623025C
	for <fio@vger.kernel.org>; Fri, 25 Jun 2010 15:24:20 +0000 (UTC)
Received: from w-gedwards.lhn.com (unknown [16.125.125.5])
	by blh01server01.usa.hp.com (Postfix) with ESMTP id 1E72AF59D6
	for <fio@vger.kernel.org>; Fri, 25 Jun 2010 09:24:20 -0600 (MDT)
Date: Fri, 25 Jun 2010 09:24:19 -0600
From: Greg Edwards <greg.edwards@hp.com>
Subject: [PATCH] gracefully handle full /tmp file system
Message-ID: <20100625152419.GA29790@w-gedwards.lhn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

If /tmp happens to be full, fio gives you a very unhelpful error:

# ./fio rand-write-256k-q256.job
Bus error

Use posix_fallocate() to gracefully handle this condition.

Signed-off-by: Greg Edwards <greg.edwards@hp.com>
---
 mutex.c   |    8 ++++++++
 smalloc.c |   12 +++++++++++-
 2 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/mutex.c b/mutex.c
index abe073f..88044f3 100644
--- a/mutex.c
+++ b/mutex.c
@@ -33,6 +33,14 @@ struct fio_mutex *fio_mutex_init(int value)
 		return NULL;
 	}
 
+#ifdef FIO_HAVE_FALLOCATE
+	ret = posix_fallocate(fd, 0, sizeof(struct fio_mutex));
+	if (ret > 0) {
+		fprintf(stderr, "posix_fallocate mutex failed: %s\n", strerror(ret));
+		goto err;
+	}
+#endif
+
 	if (ftruncate(fd, sizeof(struct fio_mutex)) < 0) {
 		perror("ftruncate mutex");
 		goto err;
diff --git a/smalloc.c b/smalloc.c
index 409998a..4cd8298 100644
--- a/smalloc.c
+++ b/smalloc.c
@@ -10,9 +10,11 @@
 #include <unistd.h>
 #include <sys/types.h>
 #include <limits.h>
+#include <fcntl.h>
 
 #include "mutex.h"
 #include "arch/arch.h"
+#include "os/os.h"
 
 #define SMALLOC_REDZONE		/* define to detect memory corruption */
 
@@ -176,7 +178,7 @@ static int find_next_zero(int word, int start)
 
 static int add_pool(struct pool *pool, unsigned int alloc_size)
 {
-	int fd, bitmap_blocks;
+	int fd, bitmap_blocks, ret;
 	char file[] = "/tmp/.fio_smalloc.XXXXXX";
 	void *ptr;
 
@@ -200,6 +202,14 @@ static int add_pool(struct pool *pool, unsigned int alloc_size)
 	pool->nr_blocks = bitmap_blocks;
 	pool->free_blocks = bitmap_blocks * SMALLOC_BPB;
 
+#ifdef FIO_HAVE_FALLOCATE
+	ret = posix_fallocate(fd, 0, alloc_size);
+	if (ret > 0) {
+		fprintf(stderr, "posix_fallocate pool file failed: %s\n", strerror(ret));
+		goto out_unlink;
+	}
+#endif
+
 	if (ftruncate(fd, alloc_size) < 0)
 		goto out_unlink;
 
-- 
1.7.0.5

