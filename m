Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 834D51ADFE4
	for <fio@vger.kernel.org>; Thu, 29 Jan 2026 18:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769712198; cv=none; b=aR4db1aXXEIrIP/gUaUwhUf/utlDEuxEITfClqRme24mkXxfUsM59JAEWv4PthYr5c1jBj1uFPxdxDpQ+MRxrd0b/rIVNesk1KvKa5i6IVqRMwy0GY0XkY+MqmjC3T9V4Y95JGsyrh+wym2lPeE4hsYHvaENafoCY7XMtXXs5/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769712198; c=relaxed/simple;
	bh=u3AhWwK8l2yrba7uEJCrOB+1OsOptQQ+r0gQ62CZghI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t893LTk42E0IY3G1nJt4xnF4ThIjXODodhYa0Eb2cE6oG76+51nzb5El44iz70h+GoJ7t017OSFiuYH9sGSY7ULwJNewyeosATPufx0WvaClzr9q9siptspRLrZ19Qh6IgIt3EY7lxyYzc0LSsM/iRdAwlxqfpb+8j8rAQ88Bfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RmavaXoz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RmavaXoz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769712196;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZAhKRSxyIAjkAI3KnePqeZmyDOpkP8/d66S+7zQ7+TU=;
	b=RmavaXozzc2l6/vShgOT5GePeOq3O3xCjkSrQinb3pTeqGMp095sQoOXAEF0ujessqAShr
	LBqCaO4g8wM8ECFCGPChsASNILurU4al+OwfbPw34qs3cUzOW21ddAcV0s5EHVY2MaQzeg
	UpSKypk6wqeH4AQidP/ifvHGVSWp/Rc=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-161-sQimmCeqOquoBXjkZlJDoQ-1; Thu,
 29 Jan 2026 13:43:11 -0500
X-MC-Unique: sQimmCeqOquoBXjkZlJDoQ-1
X-Mimecast-MFC-AGG-ID: sQimmCeqOquoBXjkZlJDoQ_1769712190
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EE5F919560A5;
	Thu, 29 Jan 2026 18:43:09 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.89.167])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B5C543000218;
	Thu, 29 Jan 2026 18:43:08 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: fio@vger.kernel.org
Cc: axboe@kernel.dk,
	vincentfu@gmail.com,
	npache@redhat.com,
	david@kernel.org,
	willy@infradead.org
Subject: [RFC 2/2] page_fault: add hugepage_delay option for delayed MADV_HUGEPAGE
Date: Thu, 29 Jan 2026 11:43:01 -0700
Message-ID: <20260129184302.34887-3-npache@redhat.com>
In-Reply-To: <20260129184302.34887-1-npache@redhat.com>
References: <20260129184302.34887-1-npache@redhat.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Introduce hugepage_delay to map with MADV_NOHUGEPAGE first, then
madvise MADV_HUGEPAGE after a configurable delay via a helper thread.
This makes khugepaged candidates reproducible for page_fault tests.

Signed-off-by: Nico Pache <npache@redhat.com>
---
 cconv.c              |  3 ++
 engines/page_fault.c | 94 ++++++++++++++++++++++++++++++++++++++++----
 options.c            | 10 +++++
 thread_options.h     |  3 ++
 4 files changed, 103 insertions(+), 7 deletions(-)

diff --git a/cconv.c b/cconv.c
index 0c4a3f2d..4fafbf83 100644
--- a/cconv.c
+++ b/cconv.c
@@ -242,6 +242,7 @@ int convert_thread_options_to_cpu(struct thread_options *o,
 	o->random_center.u.f = fio_uint64_to_double(le64_to_cpu(top->random_center.u.i));
 	o->random_generator = le32_to_cpu(top->random_generator);
 	o->hugepage_size = le32_to_cpu(top->hugepage_size);
+	o->hugepage_delay = le32_to_cpu(top->hugepage_delay);
 	o->rw_min_bs = le64_to_cpu(top->rw_min_bs);
 	o->thinkcycles = le32_to_cpu(top->thinkcycles);
 	o->thinktime = le32_to_cpu(top->thinktime);
@@ -494,6 +495,8 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->random_center.u.i = __cpu_to_le64(fio_double_to_uint64(o->random_center.u.f));
 	top->random_generator = cpu_to_le32(o->random_generator);
 	top->hugepage_size = cpu_to_le32(o->hugepage_size);
+	top->hugepage_delay = cpu_to_le32(o->hugepage_delay);
+	top->hugepage_delay_pad = 0;
 	top->rw_min_bs = __cpu_to_le64(o->rw_min_bs);
 	top->thinkcycles = cpu_to_le32(o->thinkcycles);
 	top->thinktime = cpu_to_le32(o->thinktime);
diff --git a/engines/page_fault.c b/engines/page_fault.c
index e0a3c9e5..1724d553 100644
--- a/engines/page_fault.c
+++ b/engines/page_fault.c
@@ -1,20 +1,65 @@
 #include "ioengines.h"
 #include "fio.h"
+#include <errno.h>
+#include <pthread.h>
 #include <sys/mman.h>
+#include <time.h>
 
 struct fio_page_fault_data {
     void *mmap_ptr;
     size_t mmap_sz;
     off_t mmap_off;
+#ifdef CONFIG_HAVE_THP
+    pthread_t mmap_thread;
+    pthread_mutex_t mmap_lock;
+    pthread_cond_t mmap_cond;
+    int mmap_thread_exit;
+    int mmap_thread_started;
+    unsigned int hugepage_delay;
+#endif
 };
 
+#ifdef CONFIG_HAVE_THP
+static void *mmap_delay_thread(void *data)
+{
+    struct fio_page_fault_data *fpd = data;
+    struct timespec req;
+    int ret;
+
+    clock_gettime(CLOCK_REALTIME, &req);
+    req.tv_sec += fpd->hugepage_delay / 1000;
+    req.tv_nsec += (fpd->hugepage_delay % 1000) * 1000000;
+    if (req.tv_nsec >= 1000000000) {
+        req.tv_sec++;
+        req.tv_nsec -= 1000000000;
+    }
+
+    pthread_mutex_lock(&fpd->mmap_lock);
+    while (!fpd->mmap_thread_exit) {
+        ret = pthread_cond_timedwait(&fpd->mmap_cond, &fpd->mmap_lock, &req);
+        if (ret == ETIMEDOUT)
+            break;
+    }
+
+    if (!fpd->mmap_thread_exit) {
+        dprint(FD_MEM, "fio: madvising hugepage\n");
+        ret = madvise(fpd->mmap_ptr, fpd->mmap_sz, MADV_HUGEPAGE);
+        if (ret < 0)
+            log_err("fio: madvise hugepage failed: %d\n", errno);
+    }
+    pthread_mutex_unlock(&fpd->mmap_lock);
+
+    return NULL;
+}
+#endif
+
 static int fio_page_fault_init(struct thread_data *td)
 {
     size_t total_io_size;
     struct fio_page_fault_data *fpd = calloc(1, sizeof(*fpd));
     if (!fpd)
         return 1;
-    
+
     total_io_size = td->o.size;
     fpd->mmap_sz = total_io_size;
     fpd->mmap_off = 0;
@@ -25,6 +70,26 @@ static int fio_page_fault_init(struct thread_data *td)
         return 1;
     }
 
+    if (td->o.hugepage_delay) {
+#ifdef CONFIG_HAVE_THP
+        fpd->hugepage_delay = td->o.hugepage_delay;
+        madvise(fpd->mmap_ptr, fpd->mmap_sz, MADV_NOHUGEPAGE);
+
+        pthread_mutex_init(&fpd->mmap_lock, NULL);
+        pthread_cond_init(&fpd->mmap_cond, NULL);
+        fpd->mmap_thread_exit = 0;
+        if (pthread_create(&fpd->mmap_thread, NULL, mmap_delay_thread, fpd)) {
+            log_err("fio: failed to create mmap delay thread\n");
+            pthread_cond_destroy(&fpd->mmap_cond);
+            pthread_mutex_destroy(&fpd->mmap_lock);
+            fpd->hugepage_delay = 0;
+            fpd->mmap_thread_started = 0;
+        } else {
+            fpd->mmap_thread_started = 1;
+        }
+#endif
+    }
+
     FILE_SET_ENG_DATA(td->files[0], fpd);
 	return 0;
 }
@@ -73,12 +138,27 @@ static int fio_page_fault_open_file(struct thread_data *td, struct fio_file *f)
 
 static int fio_page_fault_close_file(struct thread_data *td, struct fio_file *f)
 {
-	struct fio_page_fault_data *fpd = FILE_ENG_DATA(f);
-	if (!fpd)
-		return 1;
-    if (fpd->mmap_ptr && fpd->mmap_sz)
-        munmap(fpd->mmap_ptr, fpd->mmap_sz);
-	free(fpd);
+    struct fio_page_fault_data *fpd = FILE_ENG_DATA(f);
+
+    if (fpd) {
+#ifdef CONFIG_HAVE_THP
+        if (fpd->mmap_thread_started) {
+            pthread_mutex_lock(&fpd->mmap_lock);
+            fpd->mmap_thread_exit = 1;
+            pthread_cond_signal(&fpd->mmap_cond);
+            pthread_mutex_unlock(&fpd->mmap_lock);
+            pthread_join(fpd->mmap_thread, NULL);
+            pthread_cond_destroy(&fpd->mmap_cond);
+            pthread_mutex_destroy(&fpd->mmap_lock);
+            fpd->mmap_thread_started = 0;
+        }
+#endif
+
+        if (fpd->mmap_ptr && fpd->mmap_sz)
+            munmap(fpd->mmap_ptr, fpd->mmap_sz);
+        free(fpd);
+    }
+
 	return 0;
 }
 
diff --git a/options.c b/options.c
index f526f5eb..5f8c53cd 100644
--- a/options.c
+++ b/options.c
@@ -5490,6 +5490,16 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_INVALID,
 	},
+	{
+		.name	= "hugepage_delay",
+		.lname	= "Hugepage delay",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct thread_options, hugepage_delay),
+		.help	= "For mmap, map with MADV_NOHUGEPAGE then MADV_HUGEPAGE after delay (in ms)",
+		.def	= "0",
+		.category = FIO_OPT_C_GENERAL,
+		.group	= FIO_OPT_G_INVALID,
+	},
 	{
 		.name	= "flow_id",
 		.lname	= "I/O flow ID",
diff --git a/thread_options.h b/thread_options.h
index b4dd8d7a..f288664f 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -203,6 +203,7 @@ struct thread_options {
 	unsigned int perc_rand[DDIR_RWDIR_CNT];
 
 	unsigned int hugepage_size;
+	unsigned int hugepage_delay;
 	unsigned long long rw_min_bs;
 	unsigned int fsync_blocks;
 	unsigned int fdatasync_blocks;
@@ -539,6 +540,8 @@ struct thread_options_pack {
 	uint32_t perc_rand[DDIR_RWDIR_CNT];
 
 	uint32_t hugepage_size;
+	uint32_t hugepage_delay;
+	uint32_t hugepage_delay_pad;
 	uint64_t rw_min_bs;
 	uint32_t fsync_blocks;
 	uint32_t fdatasync_blocks;
-- 
2.52.0

