Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42406 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbcFCMAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 3 Jun 2016 08:00:05 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1b8nlj-00033V-O8
	for fio@vger.kernel.org; Fri, 03 Jun 2016 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160603120002.237112C00A3@kernel.dk>
Date: Fri,  3 Jun 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit aa7d2ef092d5a8e417fcddaf8808fb0d48f1064b:

  Added millisecond-accurate timestamp to JSON output (2016-05-27 14:26:16 -0400)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 385e1da6468bc951a0bf7ae60d890bb4d4a55ded:

  Documentation update (2016-06-02 16:57:20 -0600)

----------------------------------------------------------------
Jens Axboe (3):
      Enable preadv2/pwritev2 engines by default on Linux
      arch: wire up preadv2/pwritev2 for more architectures
      Documentation update

Omar Sandoval (1):
      Fix iodepth_batch=0

 HOWTO               | 11 +++++------
 arch/arch-arm.h     |  7 +++++++
 arch/arch-ia64.h    |  7 +++++++
 arch/arch-s390.h    |  7 +++++++
 arch/arch-sparc.h   |  7 +++++++
 arch/arch-sparc64.h |  7 +++++++
 arch/arch-x86.h     |  7 +++++++
 arch/arch-x86_64.h  |  8 ++++++++
 engines/sync.c      | 10 +++++-----
 fio.1               |  3 ---
 options.c           |  3 +--
 os/os-linux.h       | 52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 12 files changed, 113 insertions(+), 16 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index cec4e42..1d4e46c 100644
--- a/HOWTO
+++ b/HOWTO
@@ -53,8 +53,8 @@ bottom, it contains the following basic parameters:
 
 	IO engine	How do we issue io? We could be memory mapping the
 			file, we could be using regular read/write, we
-			could be using splice, async io, syslet, or even
-			SG (SCSI generic sg).
+			could be using splice, async io, or even SG
+			(SCSI generic sg).
 
 	IO depth	If the io engine is async, how large a queuing
 			depth do we want to maintain?
@@ -706,7 +706,9 @@ ioengine=str	Defines how the job issues io to the file. The following
 
 			vsync	Basic readv(2) or writev(2) IO.
 
-			psyncv	Basic preadv(2) or pwritev(2) IO.
+			pvsync	Basic preadv(2) or pwritev(2) IO.
+
+			psync2	Basic preadv2(2) or pwritev2(2) IO.
 
 			libaio	Linux native asynchronous io. Note that Linux
 				may only support queued behaviour with
@@ -726,9 +728,6 @@ ioengine=str	Defines how the job issues io to the file. The following
 				vmsplice(2) to transfer data from user
 				space to the kernel.
 
-			syslet-rw Use the syslet system calls to make
-				regular read/write async.
-
 			sg	SCSI generic sg v3 io. May either be
 				synchronous using the SG_IO ioctl, or if
 				the target is an sg character device
diff --git a/arch/arch-arm.h b/arch/arch-arm.h
index 93268d2..57d9488 100644
--- a/arch/arch-arm.h
+++ b/arch/arch-arm.h
@@ -18,6 +18,13 @@
 #define __NR_sys_vmsplice	343
 #endif
 
+#ifndef __NR_preadv2
+#define __NR_preadv2		392
+#endif
+#ifndef __NR_pwritev2
+#define __NR_pwritev2		393
+#endif
+
 #if defined (__ARM_ARCH_4__) || defined (__ARM_ARCH_4T__) \
 	|| defined (__ARM_ARCH_5__) || defined (__ARM_ARCH_5T__) || defined (__ARM_ARCH_5E__)\
 	|| defined (__ARM_ARCH_5TE__) || defined (__ARM_ARCH_5TEJ__) \
diff --git a/arch/arch-ia64.h b/arch/arch-ia64.h
index 8e8dd7f..7cdeefc 100644
--- a/arch/arch-ia64.h
+++ b/arch/arch-ia64.h
@@ -18,6 +18,13 @@
 #define __NR_sys_vmsplice	1302
 #endif
 
+#ifndef __NR_preadv2
+#define __NR_preadv2		1348
+#endif
+#ifndef __NR_pwritev2
+#define __NR_pwritev2		1349
+#endif
+
 #define nop		asm volatile ("hint @pause" ::: "memory");
 #define read_barrier()	asm volatile ("mf" ::: "memory")
 #define write_barrier()	asm volatile ("mf" ::: "memory")
diff --git a/arch/arch-s390.h b/arch/arch-s390.h
index cc7a1d1..71beb7d 100644
--- a/arch/arch-s390.h
+++ b/arch/arch-s390.h
@@ -18,6 +18,13 @@
 #define __NR_sys_vmsplice	309
 #endif
 
+#ifndef __NR_preadv2
+#define __NR_preadv2		376
+#endif
+#ifndef __NR_pwritev2
+#define __NR_pwritev2		377
+#endif
+
 #define nop		asm volatile("nop" : : : "memory")
 #define read_barrier()	asm volatile("bcr 15,0" : : : "memory")
 #define write_barrier()	asm volatile("bcr 15,0" : : : "memory")
diff --git a/arch/arch-sparc.h b/arch/arch-sparc.h
index fe47b80..d0df883 100644
--- a/arch/arch-sparc.h
+++ b/arch/arch-sparc.h
@@ -18,6 +18,13 @@
 #define __NR_sys_vmsplice	25
 #endif
 
+#ifndef __NR_preadv2
+#define __NR_preadv2		358
+#endif
+#ifndef __NR_pwritev2
+#define __NR_pwritev2		359
+#endif
+
 #define nop	do { } while (0)
 
 #define read_barrier()	__asm__ __volatile__ ("" : : : "memory")
diff --git a/arch/arch-sparc64.h b/arch/arch-sparc64.h
index e793ae5..5c4e649 100644
--- a/arch/arch-sparc64.h
+++ b/arch/arch-sparc64.h
@@ -18,6 +18,13 @@
 #define __NR_sys_vmsplice	25
 #endif
 
+#ifndef __NR_preadv2
+#define __NR_preadv2		358
+#endif
+#ifndef __NR_pwritev2
+#define __NR_pwritev2		359
+#endif
+
 #define nop	do { } while (0)
 
 #define membar_safe(type) \
diff --git a/arch/arch-x86.h b/arch/arch-x86.h
index 385a912..9471a89 100644
--- a/arch/arch-x86.h
+++ b/arch/arch-x86.h
@@ -29,6 +29,13 @@ static inline void do_cpuid(unsigned int *eax, unsigned int *ebx,
 #define __NR_sys_vmsplice	316
 #endif
 
+#ifndef __NR_preadv2
+#define __NR_preadv2		378
+#endif
+#ifndef __NR_pwritev2
+#define __NR_pwritev2		379
+#endif
+
 #define	FIO_HUGE_PAGE		4194304
 
 #define nop		__asm__ __volatile__("rep;nop": : :"memory")
diff --git a/arch/arch-x86_64.h b/arch/arch-x86_64.h
index 8f33fc5..21da412 100644
--- a/arch/arch-x86_64.h
+++ b/arch/arch-x86_64.h
@@ -36,6 +36,14 @@ static inline void do_cpuid(unsigned int *eax, unsigned int *ebx,
 #define __NR_shmdt		 67
 #endif
 
+#ifndef __NR_preadv2
+#define __NR_preadv2		327
+#endif
+#ifndef __NR_pwritev2
+#define __NR_pwritev2		328
+#endif
+
+
 #define	FIO_HUGE_PAGE		2097152
 
 #define nop		__asm__ __volatile__("rep;nop": : :"memory")
diff --git a/engines/sync.c b/engines/sync.c
index 260ef66..433e4fa 100644
--- a/engines/sync.c
+++ b/engines/sync.c
@@ -32,7 +32,7 @@ struct syncio_data {
 	enum fio_ddir last_ddir;
 };
 
-#ifdef CONFIG_PWRITEV2
+#ifdef FIO_HAVE_PWRITEV2
 struct psyncv2_options {
 	void *pad;
 	unsigned int hipri;
@@ -121,7 +121,7 @@ static int fio_pvsyncio_queue(struct thread_data *td, struct io_u *io_u)
 }
 #endif
 
-#ifdef CONFIG_PWRITEV2
+#ifdef FIO_HAVE_PWRITEV2
 static int fio_pvsyncio2_queue(struct thread_data *td, struct io_u *io_u)
 {
 	struct syncio_data *sd = td->io_ops->data;
@@ -429,7 +429,7 @@ static struct ioengine_ops ioengine_pvrw = {
 };
 #endif
 
-#ifdef CONFIG_PWRITEV2
+#ifdef FIO_HAVE_PWRITEV2
 static struct ioengine_ops ioengine_pvrw2 = {
 	.name		= "pvsync2",
 	.version	= FIO_IOOPS_VERSION,
@@ -453,7 +453,7 @@ static void fio_init fio_syncio_register(void)
 #ifdef CONFIG_PWRITEV
 	register_ioengine(&ioengine_pvrw);
 #endif
-#ifdef CONFIG_PWRITEV2
+#ifdef FIO_HAVE_PWRITEV2
 	register_ioengine(&ioengine_pvrw2);
 #endif
 }
@@ -466,7 +466,7 @@ static void fio_exit fio_syncio_unregister(void)
 #ifdef CONFIG_PWRITEV
 	unregister_ioengine(&ioengine_pvrw);
 #endif
-#ifdef CONFIG_PWRITEV2
+#ifdef FIO_HAVE_PWRITEV2
 	unregister_ioengine(&ioengine_pvrw2);
 #endif
 }
diff --git a/fio.1 b/fio.1
index f521c9d..7f053d4 100644
--- a/fio.1
+++ b/fio.1
@@ -633,9 +633,6 @@ File is memory mapped with \fBmmap\fR\|(2) and data copied using
 \fBsplice\fR\|(2) is used to transfer the data and \fBvmsplice\fR\|(2) to
 transfer data from user-space to the kernel.
 .TP
-.B syslet-rw
-Use the syslet system calls to make regular read/write asynchronous.
-.TP
 .B sg
 SCSI generic sg v3 I/O. May be either synchronous using the SG_IO ioctl, or if
 the target is an sg character device, we use \fBread\fR\|(2) and
diff --git a/options.c b/options.c
index 3360784..7a22fe4 100644
--- a/options.c
+++ b/options.c
@@ -1548,7 +1548,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .help = "Use preadv/pwritev",
 			  },
 #endif
-#ifdef CONFIG_PWRITEV2
+#ifdef FIO_HAVE_PWRITEV2
 			  { .ival = "pvsync2",
 			    .help = "Use preadv2/pwritev2",
 			  },
@@ -1678,7 +1678,6 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.help	= "Number of IO buffers to submit in one go",
 		.parent	= "iodepth",
 		.hide	= 1,
-		.minval	= 1,
 		.interval = 1,
 		.def	= "1",
 		.category = FIO_OPT_C_IO,
diff --git a/os/os-linux.h b/os/os-linux.h
index 23c16b6..b36d33c 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -38,6 +38,7 @@
 #define FIO_HAVE_BINJECT
 #define FIO_HAVE_GETTID
 #define FIO_USE_GENERIC_INIT_RANDOM_STATE
+#define FIO_HAVE_PWRITEV2
 
 #ifdef MAP_HUGETLB
 #define FIO_HAVE_MMAP_HUGE
@@ -289,4 +290,55 @@ static inline int fio_set_sched_idle(void)
 
 #define FIO_HAVE_STREAMID
 
+#ifndef RWF_HIPRI
+#define RWF_HIPRI	0x00000001
+#endif
+#ifndef RWF_DSYNC
+#define RWF_DSYNC	0x00000002
+#endif
+#ifndef RWF_SYNC
+#define RWF_SYNC	0x00000004
+#endif
+
+#ifndef CONFIG_PWRITEV2
+#ifdef __NR_preadv2
+static inline void make_pos_h_l(unsigned long *pos_h, unsigned long *pos_l,
+				off_t offset)
+{
+	*pos_l = offset & 0xffffffff;
+	*pos_h = ((uint64_t) offset) >> 32;
+
+}
+static inline ssize_t preadv2(int fd, const struct iovec *iov, int iovcnt,
+			      off_t offset, unsigned int flags)
+{
+	unsigned long pos_l, pos_h;
+
+	make_pos_h_l(&pos_h, &pos_l, offset);
+	return syscall(__NR_preadv2, fd, iov, iovcnt, pos_l, pos_h, flags);
+}
+static inline ssize_t pwritev2(int fd, const struct iovec *iov, int iovcnt,
+			       off_t offset, unsigned int flags)
+{
+	unsigned long pos_l, pos_h;
+
+	make_pos_h_l(&pos_h, &pos_l, offset);
+	return syscall(__NR_pwritev2, fd, iov, iovcnt, pos_l, pos_h, flags);
+}
+#else
+static inline ssize_t preadv2(int fd, const struct iovec *iov, int iovcnt,
+			      off_t offset, unsigned int flags)
+{
+	errno = ENOSYS;
+	return -1;
+}
+static inline ssize_t pwritev2(int fd, const struct iovec *iov, int iovcnt,
+			       off_t offset, unsigned int flags)
+{
+	errno = ENOSYS;
+	return -1;
+}
+#endif /* __NR_preadv2 */
+#endif /* CONFIG_PWRITEV2 */
+
 #endif
