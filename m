Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB0B2C433F5
	for <fio@archiver.kernel.org>; Tue, 22 Feb 2022 13:00:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbiBVNAd (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 22 Feb 2022 08:00:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbiBVNAc (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 22 Feb 2022 08:00:32 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E2AEB0A6D
        for <fio@vger.kernel.org>; Tue, 22 Feb 2022 05:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=jwEDBgf7mRQSny7nbtY5ydVi+Tpx7QZtHqmVtxl/UOM=; b=b+m4w9quX1J0K8NKciYyANjGRY
        99TWujKpmMA4OzUjoHBj2i21BHyUAChswOL8wMB16a6CbAs0/AVj4SIyCESxDZ9mL1xb8GDQJEgzJ
        3DMUo3uLXJ2SeBB8UCu0jY+mGp4zIi8xNeeMDHK5T/9LCaIWq7knzqK2VrwSiffDmvimygpaPPdfZ
        wZhDshMV8hspX6kejEdNVrOLx2pUyoJxjwzR6dgVxhMOClP3NwlV/WgWpQ4s7gvT8YaqIVe9PcHmi
        okcKbiYWW0/YqO8en15hmYVjWagMcOAO9rwvnGJaYcv6nYyDweUU2BvguDvd4V3uCyHzDEroBxS++
        WX+5gmpw==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nMUlw-002loQ-K7
        for fio@vger.kernel.org; Tue, 22 Feb 2022 13:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id B70401BC0120; Tue, 22 Feb 2022 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220222130001.B70401BC0120@kernel.dk>
Date:   Tue, 22 Feb 2022 06:00:01 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 3f43022d4021850905886e391ec68c02c99aec5a:

  Merge branch 'genfio-tempfile' of https://github.com/scop/fio (2022-02-20 12:39:11 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c377f4f85943e5b155b3daaab1ce5213077531d8:

  io_uring: use syscall helpers for the hot path (2022-02-21 09:43:48 -0700)

----------------------------------------------------------------
Jens Axboe (3):
      aarch64: add system call definitions
      x86-64: add system call definitions
      io_uring: use syscall helpers for the hot path

 arch/arch-aarch64.h |  77 +++++++++++++++++++++++++++++++++++
 arch/arch-x86_64.h  | 113 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 engines/io_uring.c  |   5 +++
 t/io_uring.c        |   5 +++
 4 files changed, 200 insertions(+)

---

Diff of recent changes:

diff --git a/arch/arch-aarch64.h b/arch/arch-aarch64.h
index 94571709..951d1718 100644
--- a/arch/arch-aarch64.h
+++ b/arch/arch-aarch64.h
@@ -44,4 +44,81 @@ static inline int arch_init(char *envp[])
 	return 0;
 }
 
+#define __do_syscallN(...) ({						\
+	__asm__ volatile (						\
+		"svc 0"							\
+		: "=r"(x0)						\
+		: __VA_ARGS__						\
+		: "memory", "cc");					\
+	(long) x0;							\
+})
+
+#define __do_syscall0(__n) ({						\
+	register long x8 __asm__("x8") = __n;				\
+	register long x0 __asm__("x0");					\
+									\
+	__do_syscallN("r" (x8));					\
+})
+
+#define __do_syscall1(__n, __a) ({					\
+	register long x8 __asm__("x8") = __n;				\
+	register __typeof__(__a) x0 __asm__("x0") = __a;		\
+									\
+	__do_syscallN("r" (x8), "0" (x0));				\
+})
+
+#define __do_syscall2(__n, __a, __b) ({					\
+	register long x8 __asm__("x8") = __n;				\
+	register __typeof__(__a) x0 __asm__("x0") = __a;		\
+	register __typeof__(__b) x1 __asm__("x1") = __b;		\
+									\
+	__do_syscallN("r" (x8), "0" (x0), "r" (x1));			\
+})
+
+#define __do_syscall3(__n, __a, __b, __c) ({				\
+	register long x8 __asm__("x8") = __n;				\
+	register __typeof__(__a) x0 __asm__("x0") = __a;		\
+	register __typeof__(__b) x1 __asm__("x1") = __b;		\
+	register __typeof__(__c) x2 __asm__("x2") = __c;		\
+									\
+	__do_syscallN("r" (x8), "0" (x0), "r" (x1), "r" (x2));		\
+})
+
+#define __do_syscall4(__n, __a, __b, __c, __d) ({			\
+	register long x8 __asm__("x8") = __n;				\
+	register __typeof__(__a) x0 __asm__("x0") = __a;		\
+	register __typeof__(__b) x1 __asm__("x1") = __b;		\
+	register __typeof__(__c) x2 __asm__("x2") = __c;		\
+	register __typeof__(__d) x3 __asm__("x3") = __d;		\
+									\
+	__do_syscallN("r" (x8), "0" (x0), "r" (x1), "r" (x2), "r" (x3));\
+})
+
+#define __do_syscall5(__n, __a, __b, __c, __d, __e) ({			\
+	register long x8 __asm__("x8") = __n;				\
+	register __typeof__(__a) x0 __asm__("x0") = __a;		\
+	register __typeof__(__b) x1 __asm__("x1") = __b;		\
+	register __typeof__(__c) x2 __asm__("x2") = __c;		\
+	register __typeof__(__d) x3 __asm__("x3") = __d;		\
+	register __typeof__(__e) x4 __asm__("x4") = __e;		\
+									\
+	__do_syscallN("r" (x8), "0" (x0), "r" (x1), "r" (x2), "r" (x3),	\
+			"r"(x4));					\
+})
+
+#define __do_syscall6(__n, __a, __b, __c, __d, __e, __f) ({		\
+	register long x8 __asm__("x8") = __n;				\
+	register __typeof__(__a) x0 __asm__("x0") = __a;		\
+	register __typeof__(__b) x1 __asm__("x1") = __b;		\
+	register __typeof__(__c) x2 __asm__("x2") = __c;		\
+	register __typeof__(__d) x3 __asm__("x3") = __d;		\
+	register __typeof__(__e) x4 __asm__("x4") = __e;		\
+	register __typeof__(__f) x5 __asm__("x5") = __f;		\
+									\
+	__do_syscallN("r" (x8), "0" (x0), "r" (x1), "r" (x2), "r" (x3),	\
+			"r" (x4), "r"(x5));				\
+})
+
+#define FIO_ARCH_HAS_SYSCALL
+
 #endif
diff --git a/arch/arch-x86_64.h b/arch/arch-x86_64.h
index 25850f90..86ce1b7e 100644
--- a/arch/arch-x86_64.h
+++ b/arch/arch-x86_64.h
@@ -68,4 +68,117 @@ static inline int arch_rand_seed(unsigned long *seed)
 	return 0;
 }
 
+#define __do_syscall0(NUM) ({			\
+	intptr_t rax;				\
+						\
+	__asm__ volatile(			\
+		"syscall"			\
+		: "=a"(rax)	/* %rax */	\
+		: "a"(NUM)	/* %rax */	\
+		: "rcx", "r11", "memory"	\
+	);					\
+	rax;					\
+})
+
+#define __do_syscall1(NUM, ARG1) ({		\
+	intptr_t rax;				\
+						\
+	__asm__ volatile(			\
+		"syscall"			\
+		: "=a"(rax)	/* %rax */	\
+		: "a"((NUM)),	/* %rax */	\
+		  "D"((ARG1))	/* %rdi */	\
+		: "rcx", "r11", "memory"	\
+	);					\
+	rax;					\
+})
+
+#define __do_syscall2(NUM, ARG1, ARG2) ({	\
+	intptr_t rax;				\
+						\
+	__asm__ volatile(			\
+		"syscall"			\
+		: "=a"(rax)	/* %rax */	\
+		: "a"((NUM)),	/* %rax */	\
+		  "D"((ARG1)),	/* %rdi */	\
+		  "S"((ARG2))	/* %rsi */	\
+		: "rcx", "r11", "memory"	\
+	);					\
+	rax;					\
+})
+
+#define __do_syscall3(NUM, ARG1, ARG2, ARG3) ({	\
+	intptr_t rax;				\
+						\
+	__asm__ volatile(			\
+		"syscall"			\
+		: "=a"(rax)	/* %rax */	\
+		: "a"((NUM)),	/* %rax */	\
+		  "D"((ARG1)),	/* %rdi */	\
+		  "S"((ARG2)),	/* %rsi */	\
+		  "d"((ARG3))	/* %rdx */	\
+		: "rcx", "r11", "memory"	\
+	);					\
+	rax;					\
+})
+
+#define __do_syscall4(NUM, ARG1, ARG2, ARG3, ARG4) ({			\
+	intptr_t rax;							\
+	register __typeof__(ARG4) __r10 __asm__("r10") = (ARG4);	\
+									\
+	__asm__ volatile(						\
+		"syscall"						\
+		: "=a"(rax)	/* %rax */				\
+		: "a"((NUM)),	/* %rax */				\
+		  "D"((ARG1)),	/* %rdi */				\
+		  "S"((ARG2)),	/* %rsi */				\
+		  "d"((ARG3)),	/* %rdx */				\
+		  "r"(__r10)	/* %r10 */				\
+		: "rcx", "r11", "memory"				\
+	);								\
+	rax;								\
+})
+
+#define __do_syscall5(NUM, ARG1, ARG2, ARG3, ARG4, ARG5) ({		\
+	intptr_t rax;							\
+	register __typeof__(ARG4) __r10 __asm__("r10") = (ARG4);	\
+	register __typeof__(ARG5) __r8 __asm__("r8") = (ARG5);		\
+									\
+	__asm__ volatile(						\
+		"syscall"						\
+		: "=a"(rax)	/* %rax */				\
+		: "a"((NUM)),	/* %rax */				\
+		  "D"((ARG1)),	/* %rdi */				\
+		  "S"((ARG2)),	/* %rsi */				\
+		  "d"((ARG3)),	/* %rdx */				\
+		  "r"(__r10),	/* %r10 */				\
+		  "r"(__r8)	/* %r8 */				\
+		: "rcx", "r11", "memory"				\
+	);								\
+	rax;								\
+})
+
+#define __do_syscall6(NUM, ARG1, ARG2, ARG3, ARG4, ARG5, ARG6) ({	\
+	intptr_t rax;							\
+	register __typeof__(ARG4) __r10 __asm__("r10") = (ARG4);	\
+	register __typeof__(ARG5) __r8 __asm__("r8") = (ARG5);		\
+	register __typeof__(ARG6) __r9 __asm__("r9") = (ARG6);		\
+									\
+	__asm__ volatile(						\
+		"syscall"						\
+		: "=a"(rax)	/* %rax */				\
+		: "a"((NUM)),	/* %rax */				\
+		  "D"((ARG1)),	/* %rdi */				\
+		  "S"((ARG2)),	/* %rsi */				\
+		  "d"((ARG3)),	/* %rdx */				\
+		  "r"(__r10),	/* %r10 */				\
+		  "r"(__r8),	/* %r8 */				\
+		  "r"(__r9)	/* %r9 */				\
+		: "rcx", "r11", "memory"				\
+	);								\
+	rax;								\
+})
+
+#define FIO_ARCH_HAS_SYSCALL
+
 #endif
diff --git a/engines/io_uring.c b/engines/io_uring.c
index a2533c88..1e15647e 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -278,8 +278,13 @@ static struct fio_option options[] = {
 static int io_uring_enter(struct ioring_data *ld, unsigned int to_submit,
 			 unsigned int min_complete, unsigned int flags)
 {
+#ifdef FIO_ARCH_HAS_SYSCALL
+	return __do_syscall6(__NR_io_uring_enter, ld->ring_fd, to_submit,
+				min_complete, flags, NULL, 0);
+#else
 	return syscall(__NR_io_uring_enter, ld->ring_fd, to_submit,
 			min_complete, flags, NULL, 0);
+#endif
 }
 
 static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
diff --git a/t/io_uring.c b/t/io_uring.c
index f513d7dc..b8fcffe8 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -422,8 +422,13 @@ out:
 static int io_uring_enter(struct submitter *s, unsigned int to_submit,
 			  unsigned int min_complete, unsigned int flags)
 {
+#ifdef FIO_ARCH_HAS_SYSCALL
+	return __do_syscall6(__NR_io_uring_enter, s->ring_fd, to_submit,
+				min_complete, flags, NULL, 0);
+#else
 	return syscall(__NR_io_uring_enter, s->ring_fd, to_submit, min_complete,
 			flags, NULL, 0);
+#endif
 }
 
 #ifndef CONFIG_HAVE_GETTID
