Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C47BC04AA5
	for <fio@archiver.kernel.org>; Thu, 25 Aug 2022 12:00:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241345AbiHYMAU (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 25 Aug 2022 08:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240419AbiHYMAR (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 25 Aug 2022 08:00:17 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4105C7331F
        for <fio@vger.kernel.org>; Thu, 25 Aug 2022 05:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=FX3L/wb2mZoT1fN8uVUsFesmJTRrtRjlLG5VsgZ7gbc=; b=JfbDSUJoislH8RdsdRGwfgC2PA
        /7ssXNzvPhw0mEYym0zPM57FxW8vyLZzWwugcJWSDks92tqUuYhfR5nYx2QWRGX9V0/7Gn9ouh3l5
        b+np0OnocRqw/Ai7xqvO9T+XAgxCq0qK3P8ouEjgCoug0LcaxGawe1cPqy7iiJLt7tpM5yrBfo46Y
        xytYNpJj7/P555mAVfyv79lzikbcXNfIUI9fbhwby5lcQjGhr+bPbZDEqXg9DqI3PWq8Va1+uKneo
        eEa0Y9gK894NyDuqVzA5sM4+BlapK3yRcb9eRJBPlOR+52+J1jzeW99pgXYUPwl8xlgl8B4BL6KUL
        QRPDLFsw==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oRBWm-00HE5G-Mx
        for fio@vger.kernel.org; Thu, 25 Aug 2022 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 2112C1BC011F; Thu, 25 Aug 2022 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220825120002.2112C1BC011F@kernel.dk>
Date:   Thu, 25 Aug 2022 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 995c45c08c7a362ae0fb2e54e2de27b555a757ab:

  Merge branch 'sigbreak-wait' of github.com:bjpaupor/fio (2022-08-23 17:09:25 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 05ef0e4e822ffa81d6e92ed538d32cc37a907279:

  Merge branch 'master' of https://github.com/kraj/fio (2022-08-24 20:09:29 -0600)

----------------------------------------------------------------
Bart Van Assche (1):
      Enable CPU affinity support on Android

Jens Axboe (3):
      engines/io_uring: pass back correct error value when interrupted
      Merge branch 'master' of https://github.com/bvanassche/fio
      Merge branch 'master' of https://github.com/kraj/fio

Khem Raj (1):
      io_uring: Replace pthread_self with s->tid

 engines/io_uring.c |  8 ++++++++
 os/os-android.h    | 26 ++++++++++++++++++++++++++
 t/io_uring.c       |  5 ++---
 3 files changed, 36 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index cffc7371..89d64b06 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -445,12 +445,18 @@ static struct io_u *fio_ioring_event(struct thread_data *td, int event)
 	struct io_uring_cqe *cqe;
 	struct io_u *io_u;
 	unsigned index;
+	static int eio;
 
 	index = (event + ld->cq_ring_off) & ld->cq_ring_mask;
 
 	cqe = &ld->cq_ring.cqes[index];
 	io_u = (struct io_u *) (uintptr_t) cqe->user_data;
 
+	if (eio++ == 5) {
+		printf("mark EIO\n");
+		cqe->res = -EIO;
+	}
+
 	if (cqe->res != io_u->xfer_buflen) {
 		if (cqe->res > io_u->xfer_buflen)
 			io_u->error = -cqe->res;
@@ -532,6 +538,7 @@ static int fio_ioring_getevents(struct thread_data *td, unsigned int min,
 			if (r < 0) {
 				if (errno == EAGAIN || errno == EINTR)
 					continue;
+				r = -errno;
 				td_verror(td, errno, "io_uring_enter");
 				break;
 			}
@@ -665,6 +672,7 @@ static int fio_ioring_commit(struct thread_data *td)
 				usleep(1);
 				continue;
 			}
+			ret = -errno;
 			td_verror(td, errno, "io_uring_enter submit");
 			break;
 		}
diff --git a/os/os-android.h b/os/os-android.h
index 2f73d249..34534239 100644
--- a/os/os-android.h
+++ b/os/os-android.h
@@ -24,6 +24,7 @@
   #define __has_builtin(x) 0  // Compatibility with non-clang compilers.
 #endif
 
+#define FIO_HAVE_CPU_AFFINITY
 #define FIO_HAVE_DISK_UTIL
 #define FIO_HAVE_IOSCHED_SWITCH
 #define FIO_HAVE_IOPRIO
@@ -44,6 +45,13 @@
 
 #define OS_MAP_ANON		MAP_ANONYMOUS
 
+typedef cpu_set_t os_cpu_mask_t;
+
+#define fio_setaffinity(pid, cpumask)		\
+	sched_setaffinity((pid), sizeof(cpumask), &(cpumask))
+#define fio_getaffinity(pid, ptr)	\
+	sched_getaffinity((pid), sizeof(cpu_set_t), (ptr))
+
 #ifndef POSIX_MADV_DONTNEED
 #define posix_madvise   madvise
 #define POSIX_MADV_DONTNEED MADV_DONTNEED
@@ -64,6 +72,24 @@
 	pthread_getaffinity_np(pthread_self(), sizeof(mask), &(mask))
 #endif
 
+#define fio_cpu_clear(mask, cpu)	CPU_CLR((cpu), (mask))
+#define fio_cpu_set(mask, cpu)		CPU_SET((cpu), (mask))
+#define fio_cpu_isset(mask, cpu)	(CPU_ISSET((cpu), (mask)) != 0)
+#define fio_cpu_count(mask)		CPU_COUNT((mask))
+
+static inline int fio_cpuset_init(os_cpu_mask_t *mask)
+{
+	CPU_ZERO(mask);
+	return 0;
+}
+
+static inline int fio_cpuset_exit(os_cpu_mask_t *mask)
+{
+	return 0;
+}
+
+#define FIO_MAX_CPUS			CPU_SETSIZE
+
 #ifndef CONFIG_NO_SHM
 /*
  * Bionic doesn't support SysV shared memory, so implement it using ashmem
diff --git a/t/io_uring.c b/t/io_uring.c
index 35bf1956..f34a3554 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -799,15 +799,14 @@ static int submitter_init(struct submitter *s)
 	int i, nr_batch, err;
 	static int init_printed;
 	char buf[80];
-
 	s->tid = gettid();
 	printf("submitter=%d, tid=%d, file=%s, node=%d\n", s->index, s->tid,
 							s->filename, s->numa_node);
 
 	set_affinity(s);
 
-	__init_rand64(&s->rand_state, pthread_self());
-	srand48(pthread_self());
+	__init_rand64(&s->rand_state, s->tid);
+	srand48(s->tid);
 
 	for (i = 0; i < MAX_FDS; i++)
 		s->files[i].fileno = i;
