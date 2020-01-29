Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55294 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbgA2NAD (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 29 Jan 2020 08:00:03 -0500
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwmwt-0005tx-Ek
        for fio@vger.kernel.org; Wed, 29 Jan 2020 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200129130001.C0F4A1BC0043@kernel.dk>
Date: Wed, 29 Jan 2020 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 8178434ccba8e2d06684ce0c730b0eda571c5280:

  Merge branch 'filestat1' of https://github.com/kusumi/fio (2020-01-23 11:35:23 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ab45cf076766ce1ed49d28380c059343305cde4a:

  Merge branch 'stat-averaging-interval-start-fix' of https://github.com/maciejsszmigiero/fio (2020-01-28 14:15:35 -0700)

----------------------------------------------------------------
Jens Axboe (3):
      Merge branch 'no_cpu_clock_no_tls_thread' of https://github.com/bsdkurt/fio
      Merge branch 'openbsd_swap' of https://github.com/bsdkurt/fio
      Merge branch 'stat-averaging-interval-start-fix' of https://github.com/maciejsszmigiero/fio

Kurt Miller (2):
      Fix build on architectures that don't have both cpu clock and __thread support.
      Use swap16/32/64 on OpenBSD.

Maciej S. Szmigiero (1):
      stat: fix calculation of bw and iops statistics based on samples

 gettime.c       | 4 ++--
 os/os-openbsd.h | 6 +++---
 stat.c          | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

---

Diff of recent changes:

diff --git a/gettime.c b/gettime.c
index 272a3e62..c3a4966b 100644
--- a/gettime.c
+++ b/gettime.c
@@ -371,7 +371,7 @@ static int calibrate_cpu_clock(void)
 }
 #endif // ARCH_HAVE_CPU_CLOCK
 
-#ifndef CONFIG_TLS_THREAD
+#if defined(ARCH_HAVE_CPU_CLOCK) && !defined(CONFIG_TLS_THREAD)
 void fio_local_clock_init(void)
 {
 	struct tv_valid *t;
@@ -398,7 +398,7 @@ void fio_clock_init(void)
 	if (fio_clock_source == fio_clock_source_inited)
 		return;
 
-#ifndef CONFIG_TLS_THREAD
+#if defined(ARCH_HAVE_CPU_CLOCK) && !defined(CONFIG_TLS_THREAD)
 	if (pthread_key_create(&tv_tls_key, kill_tv_tls_key))
 		log_err("fio: can't create TLS key\n");
 #endif
diff --git a/os/os-openbsd.h b/os/os-openbsd.h
index 085a6f2b..994bf078 100644
--- a/os/os-openbsd.h
+++ b/os/os-openbsd.h
@@ -31,9 +31,9 @@
 #define PTHREAD_STACK_MIN 4096
 #endif
 
-#define fio_swap16(x)	bswap16(x)
-#define fio_swap32(x)	bswap32(x)
-#define fio_swap64(x)	bswap64(x)
+#define fio_swap16(x)	swap16(x)
+#define fio_swap32(x)	swap32(x)
+#define fio_swap64(x)	swap64(x)
 
 static inline int blockdev_size(struct fio_file *f, unsigned long long *bytes)
 {
diff --git a/stat.c b/stat.c
index 9d93dcd1..cc1c360e 100644
--- a/stat.c
+++ b/stat.c
@@ -3106,7 +3106,7 @@ static int __add_samples(struct thread_data *td, struct timespec *parent_tv,
 		stat_io_bytes[ddir] = this_io_bytes[ddir];
 	}
 
-	timespec_add_msec(parent_tv, avg_time);
+	*parent_tv = *t;
 
 	if (needs_lock)
 		__td_io_u_unlock(td);

