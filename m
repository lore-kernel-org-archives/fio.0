Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:57180 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729135AbeKTX3V (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 20 Nov 2018 18:29:21 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gP5db-0007iY-Lz
        for fio@vger.kernel.org; Tue, 20 Nov 2018 13:00:19 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20181120130001.E123E2C01D6@kernel.dk>
Date: Tue, 20 Nov 2018 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit ee636f3fc5ddb9488c40aa2c6dd4168732e5b095:

  libaio: switch to newer libaio polled IO API (2018-11-15 20:31:35 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a1b006fe1cd3aa7e1b567f55e5a4c827d54f7c41:

  engines/libaio: fix new aio poll API (2018-11-19 19:41:53 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      engines/libaio: update to new io_setup2() system call
      engines/libaio: fix new aio poll API

 arch/arch-x86_64.h |  4 ++++
 engines/libaio.c   | 27 +++++++++++++++++++++++----
 2 files changed, 27 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/arch/arch-x86_64.h b/arch/arch-x86_64.h
index 484ea0c..ac670d0 100644
--- a/arch/arch-x86_64.h
+++ b/arch/arch-x86_64.h
@@ -1,6 +1,10 @@
 #ifndef ARCH_X86_64_H
 #define ARCH_X86_64_H
 
+#ifndef __NR_sys_io_setup2
+#define __NR_sys_io_setup2	335
+#endif
+
 static inline void do_cpuid(unsigned int *eax, unsigned int *ebx,
 			    unsigned int *ecx, unsigned int *edx)
 {
diff --git a/engines/libaio.c b/engines/libaio.c
index dc66462..2a4d653 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -16,6 +16,9 @@
 #ifndef IOCB_FLAG_HIPRI
 #define IOCB_FLAG_HIPRI	(1 << 2)
 #endif
+#ifndef IOCTX_FLAG_IOPOLL
+#define IOCTX_FLAG_IOPOLL	(1 << 0)
+#endif
 
 static int fio_libaio_commit(struct thread_data *td);
 
@@ -354,6 +357,25 @@ static void fio_libaio_cleanup(struct thread_data *td)
 	}
 }
 
+static int fio_libaio_queue_init(struct libaio_data *ld, unsigned int depth,
+				 bool hipri)
+{
+#ifdef __NR_sys_io_setup2
+	int flags = 0;
+
+	if (hipri)
+		flags = IOCTX_FLAG_IOPOLL;
+
+	return syscall(__NR_sys_io_setup2, depth, flags, &ld->aio_ctx);
+#else
+	if (hipri) {
+		log_err("fio: polled aio not available on your platform\n");
+		return 1;
+	}
+	return io_queue_init(depth, &ld->aio_ctx);
+#endif
+}
+
 static int fio_libaio_init(struct thread_data *td)
 {
 	struct libaio_options *o = td->eo;
@@ -367,10 +389,7 @@ static int fio_libaio_init(struct thread_data *td)
 	 * care about the user ring. If that fails, the kernel is too old
 	 * and we need the right depth.
 	 */
-	if (!o->userspace_reap)
-		err = io_queue_init(INT_MAX, &ld->aio_ctx);
-	if (o->userspace_reap || err == -EINVAL)
-		err = io_queue_init(td->o.iodepth, &ld->aio_ctx);
+	err = fio_libaio_queue_init(ld, td->o.iodepth, o->hipri);
 	if (err) {
 		td_verror(td, -err, "io_queue_init");
 		log_err("fio: check /proc/sys/fs/aio-max-nr\n");

