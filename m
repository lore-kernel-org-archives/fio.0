Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2225C001DF
	for <fio@archiver.kernel.org>; Fri, 20 Oct 2023 12:00:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377302AbjJTMAP (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 20 Oct 2023 08:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377296AbjJTMAO (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 20 Oct 2023 08:00:14 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD7ACD41
        for <fio@vger.kernel.org>; Fri, 20 Oct 2023 05:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=RHHjy+Mw/RQfvWu8yGdBHfgIBLiufdARXuQEhQXQylA=; b=nliHgB7e4j5+KBI5p6/suVYJtK
        aHj70V7WrJuVbPfvmnPWZSsez0mD8ziNDfEn2nElCQ9MlVwSwHRMd+yCT8G0gqZuFTSjg6NEOvXJG
        EkZ/1tjQpt7EfCpmXmp9BECAhNS7ooS8g7TWH+UwGbzi/mcPxAQCDUgaiYf9e0Nq59NBitt2EufuP
        Byk9NDIUYvDglVTFnKLqtHr8QWoI2ENFIooHL1qBhGyU9oQYnjqn7gZjKSy835A7of8jpYNi1aqYZ
        c36dKddweNBeDEO4Kk1e3LPKNTXTmgcKwVHN5L6gdy/WEkyn1YuDXHjbHV74wMZW1gUh4ea4+p0IY
        CDSd9MTA==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qtoAk-00CxQP-Fv
        for fio@vger.kernel.org; Fri, 20 Oct 2023 12:00:10 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 8C1AB1BC0194; Fri, 20 Oct 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20231020120001.8C1AB1BC0194@kernel.dk>
Date:   Fri, 20 Oct 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit c5d8ce3fc736210ded83b126c71e3225c7ffd7c9:

  ci: explicitly install pygments and certifi on macos (2023-10-16 10:54:21 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f8735bf1fb208bc1b6b1ca818413c9e41944e813:

  Merge branch 'master' of https://github.com/michalbiesek/fio (2023-10-20 04:32:39 -0600)

----------------------------------------------------------------
Jens Axboe (3):
      Merge branch 'fix_issue_1642' of https://github.com/zqs-Oppenauer/fio
      Fio 3.36
      Merge branch 'master' of https://github.com/michalbiesek/fio

Michal Biesek (1):
      riscv64: add syscall helpers

Shai Levy (2):
      configure: improve pthread_sigmask detection.
      helper_thread: fix pthread_sigmask typo.

Vincent Fu (1):
      Merge branch 'master' of https://github.com/shailevi23/fio

zhuqingsong.0909 (1):
      fix assert failed when timeout during call rate_ddir.

 FIO-VERSION-GEN     |  2 +-
 arch/arch-riscv64.h | 86 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 configure           |  3 +-
 helper_thread.c     |  5 ++--
 io_ddir.h           |  1 +
 io_u.c              | 10 +++++--
 zbd.c               |  1 +
 7 files changed, 101 insertions(+), 7 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 4b0d56d0..cf8dbb0e 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-3.35
+DEF_VER=fio-3.36
 
 LF='
 '
diff --git a/arch/arch-riscv64.h b/arch/arch-riscv64.h
index a74b7d47..9b8fd001 100644
--- a/arch/arch-riscv64.h
+++ b/arch/arch-riscv64.h
@@ -29,4 +29,90 @@ static inline int arch_init(char *envp[])
 	return 0;
 }
 
+#define __do_syscallM(...) ({						\
+	__asm__ volatile (						\
+		"ecall"							\
+		: "=r"(a0)						\
+		: __VA_ARGS__						\
+		: "memory", "a1");					\
+	(long) a0;							\
+})
+
+#define __do_syscallN(...) ({						\
+	__asm__ volatile (						\
+		"ecall"							\
+		: "=r"(a0)						\
+		: __VA_ARGS__						\
+		: "memory");					\
+	(long) a0;							\
+})
+
+#define __do_syscall0(__n) ({						\
+	register long a7 __asm__("a7") = __n;				\
+	register long a0 __asm__("a0");					\
+									\
+	__do_syscallM("r" (a7));					\
+})
+
+#define __do_syscall1(__n, __a) ({					\
+	register long a7 __asm__("a7") = __n;				\
+	register __typeof__(__a) a0 __asm__("a0") = __a;		\
+									\
+	__do_syscallM("r" (a7), "0" (a0));				\
+})
+
+#define __do_syscall2(__n, __a, __b) ({					\
+	register long a7 __asm__("a7") = __n;				\
+	register __typeof__(__a) a0 __asm__("a0") = __a;		\
+	register __typeof__(__b) a1 __asm__("a1") = __b;		\
+									\
+	__do_syscallN("r" (a7), "0" (a0), "r" (a1));			\
+})
+
+#define __do_syscall3(__n, __a, __b, __c) ({				\
+	register long a7 __asm__("a7") = __n;				\
+	register __typeof__(__a) a0 __asm__("a0") = __a;		\
+	register __typeof__(__b) a1 __asm__("a1") = __b;		\
+	register __typeof__(__c) a2 __asm__("a2") = __c;		\
+									\
+	__do_syscallN("r" (a7), "0" (a0), "r" (a1), "r" (a2));		\
+})
+
+#define __do_syscall4(__n, __a, __b, __c, __d) ({			\
+	register long a7 __asm__("a7") = __n;				\
+	register __typeof__(__a) a0 __asm__("a0") = __a;		\
+	register __typeof__(__b) a1 __asm__("a1") = __b;		\
+	register __typeof__(__c) a2 __asm__("a2") = __c;		\
+	register __typeof__(__d) a3 __asm__("a3") = __d;		\
+									\
+	__do_syscallN("r" (a7), "0" (a0), "r" (a1), "r" (a2), "r" (a3));\
+})
+
+#define __do_syscall5(__n, __a, __b, __c, __d, __e) ({			\
+	register long a7 __asm__("a7") = __n;				\
+	register __typeof__(__a) a0 __asm__("a0") = __a;		\
+	register __typeof__(__b) a1 __asm__("a1") = __b;		\
+	register __typeof__(__c) a2 __asm__("a2") = __c;		\
+	register __typeof__(__d) a3 __asm__("a3") = __d;		\
+	register __typeof__(__e) a4 __asm__("a4") = __e;		\
+									\
+	__do_syscallN("r" (a7), "0" (a0), "r" (a1), "r" (a2), "r" (a3),	\
+			"r"(a4));					\
+})
+
+#define __do_syscall6(__n, __a, __b, __c, __d, __e, __f) ({		\
+	register long a7 __asm__("a7") = __n;				\
+	register __typeof__(__a) a0 __asm__("a0") = __a;		\
+	register __typeof__(__b) a1 __asm__("a1") = __b;		\
+	register __typeof__(__c) a2 __asm__("a2") = __c;		\
+	register __typeof__(__d) a3 __asm__("a3") = __d;		\
+	register __typeof__(__e) a4 __asm__("a4") = __e;		\
+	register __typeof__(__f) a5 __asm__("a5") = __f;		\
+									\
+	__do_syscallN("r" (a7), "0" (a0), "r" (a1), "r" (a2), "r" (a3),	\
+			"r" (a4), "r"(a5));				\
+})
+
+#define FIO_ARCH_HAS_SYSCALL
+
 #endif
diff --git a/configure b/configure
index 36184a58..742cb7c5 100755
--- a/configure
+++ b/configure
@@ -864,7 +864,8 @@ cat > $TMPC <<EOF
 #include <signal.h> /* pthread_sigmask() */
 int main(void)
 {
-  return pthread_sigmask(0, NULL, NULL);
+  sigset_t sigmask;
+  return pthread_sigmask(0, NULL, &sigmask);
 }
 EOF
 if compile_prog "" "$LIBS" "pthread_sigmask" ; then
diff --git a/helper_thread.c b/helper_thread.c
index 53dea44b..2a9dabf5 100644
--- a/helper_thread.c
+++ b/helper_thread.c
@@ -106,13 +106,14 @@ static int read_from_pipe(int fd, void *buf, size_t len)
 
 static void block_signals(void)
 {
-#ifdef HAVE_PTHREAD_SIGMASK
+#ifdef CONFIG_PTHREAD_SIGMASK
 	sigset_t sigmask;
 
+	int ret;
+
 	ret = pthread_sigmask(SIG_UNBLOCK, NULL, &sigmask);
 	assert(ret == 0);
 	ret = pthread_sigmask(SIG_BLOCK, &sigmask, NULL);
-	assert(ret == 0);
 #endif
 }
 
diff --git a/io_ddir.h b/io_ddir.h
index 217eb628..280c1e79 100644
--- a/io_ddir.h
+++ b/io_ddir.h
@@ -11,6 +11,7 @@ enum fio_ddir {
 	DDIR_WAIT,
 	DDIR_LAST,
 	DDIR_INVAL = -1,
+	DDIR_TIMEOUT = -2,
 
 	DDIR_RWDIR_CNT = 3,
 	DDIR_RWDIR_SYNC_CNT = 4,
diff --git a/io_u.c b/io_u.c
index 07e5bac5..13187882 100644
--- a/io_u.c
+++ b/io_u.c
@@ -717,7 +717,7 @@ static enum fio_ddir rate_ddir(struct thread_data *td, enum fio_ddir ddir)
 		 * check if the usec is capable of taking negative values
 		 */
 		if (now > td->o.timeout) {
-			ddir = DDIR_INVAL;
+			ddir = DDIR_TIMEOUT;
 			return ddir;
 		}
 		usec = td->o.timeout - now;
@@ -726,7 +726,7 @@ static enum fio_ddir rate_ddir(struct thread_data *td, enum fio_ddir ddir)
 
 	now = utime_since_now(&td->epoch);
 	if ((td->o.timeout && (now > td->o.timeout)) || td->terminate)
-		ddir = DDIR_INVAL;
+		ddir = DDIR_TIMEOUT;
 
 	return ddir;
 }
@@ -951,7 +951,7 @@ static int fill_io_u(struct thread_data *td, struct io_u *io_u)
 
 	set_rw_ddir(td, io_u);
 
-	if (io_u->ddir == DDIR_INVAL) {
+	if (io_u->ddir == DDIR_INVAL || io_u->ddir == DDIR_TIMEOUT) {
 		dprint(FD_IO, "invalid direction received ddir = %d", io_u->ddir);
 		return 1;
 	}
@@ -1419,6 +1419,10 @@ static long set_io_u_file(struct thread_data *td, struct io_u *io_u)
 		put_file_log(td, f);
 		td_io_close_file(td, f);
 		io_u->file = NULL;
+
+		if (io_u->ddir == DDIR_TIMEOUT)
+			return 1;
+
 		if (td->o.file_service_type & __FIO_FSERVICE_NONUNIFORM)
 			fio_file_reset(td, f);
 		else {
diff --git a/zbd.c b/zbd.c
index caac68bb..c4f7b12f 100644
--- a/zbd.c
+++ b/zbd.c
@@ -2171,6 +2171,7 @@ retry:
 	case DDIR_WAIT:
 	case DDIR_LAST:
 	case DDIR_INVAL:
+	case DDIR_TIMEOUT:
 		goto accept;
 	}
 
