Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:51024 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbaCENAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 5 Mar 2014 08:00:05 -0500
Received: from kernel.dk ([54.225.238.116] helo=strynoevaenget.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WLBQb-0000XX-8Q
	for fio@vger.kernel.org; Wed, 05 Mar 2014 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140305130003.4221140062@strynoevaenget.dk>
Date: Wed,  5 Mar 2014 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit fad69e155f10094611154e76c6babc1fdd1d40c1:

  Fio 2.1.6 (2014-03-03 15:49:00 -0800)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d004a209eee0a8db603c2d7ca6dc5fb6c367aa5a:

  Fix typo in fio_cpu_count() (2014-03-04 09:02:10 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Fix typo in fio_cpu_count()

 os/os-freebsd.h |    2 +-
 os/os-linux.h   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/os/os-freebsd.h b/os/os-freebsd.h
index e35c835..22765ce 100644
--- a/os/os-freebsd.h
+++ b/os/os-freebsd.h
@@ -33,7 +33,7 @@ typedef cpuset_t os_cpu_mask_t;
 #define fio_cpu_clear(mask, cpu)        (void) CPU_CLR((cpu), (mask))
 #define fio_cpu_set(mask, cpu)          (void) CPU_SET((cpu), (mask))
 #define fio_cpu_isset(mask, cpu)	CPU_ISSET((cpu), (mask))
-#define fio_cpu_count(maks)		CPU_COUNT((mask))
+#define fio_cpu_count(mask)		CPU_COUNT((mask))
 
 static inline int fio_cpuset_init(os_cpu_mask_t *mask)
 {
diff --git a/os/os-linux.h b/os/os-linux.h
index ef80ce2..81d0402 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -62,7 +62,7 @@ typedef struct drand48_data os_random_state_t;
 #define fio_cpu_clear(mask, cpu)	(void) CPU_CLR((cpu), (mask))
 #define fio_cpu_set(mask, cpu)		(void) CPU_SET((cpu), (mask))
 #define fio_cpu_isset(mask, cpu)	CPU_ISSET((cpu), (mask))
-#define fio_cpu_count(maks)		CPU_COUNT((mask))
+#define fio_cpu_count(mask)		CPU_COUNT((mask))
 
 static inline int fio_cpuset_init(os_cpu_mask_t *mask)
 {
