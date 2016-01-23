Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51579 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbcAWNAE (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 23 Jan 2016 08:00:04 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1aMxnP-0001td-Cg
	for fio@vger.kernel.org; Sat, 23 Jan 2016 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160123130001.D5F842C00D9@kernel.dk>
Date: Sat, 23 Jan 2016 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 6a971db3b3375bf9d6b835c64cac12850edc7760:

  ioengine: remove duplicate queue handler check (2016-01-21 17:45:44 +0100)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ab917e33e8c0353e2e17b0340e7193e7df6591b0:

  Fix Windows build: define rand_r() (2016-01-22 15:24:58 -0700)

----------------------------------------------------------------
Bruce Cran (1):
      Fix Windows build: define rand_r()

Jens Axboe (2):
      server: use the wrapped MSG_DONTWAIT
      Makefile: fix duplicate strcasestr for windows

 Makefile        | 1 -
 os/os-windows.h | 5 +++++
 server.c        | 2 +-
 3 files changed, 6 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index b6ebf2f..9b15afe 100644
--- a/Makefile
+++ b/Makefile
@@ -239,7 +239,6 @@ ifneq (,$(findstring CYGWIN,$(CONFIG_TARGET_OS)))
     T_DEDUPE_OBJS += os/windows/posix.o lib/hweight.o
     T_SMALLOC_OBJS += os/windows/posix.o lib/hweight.o
     T_LFSR_TEST_OBJS += os/windows/posix.o lib/hweight.o
-    T_ZIPF_OBJS += oslib/strcasestr.o
 endif
 
 T_TEST_PROGS = $(T_SMALLOC_PROGS)
diff --git a/os/os-windows.h b/os/os-windows.h
index 159c086..d049531 100644
--- a/os/os-windows.h
+++ b/os/os-windows.h
@@ -20,6 +20,11 @@
 
 #include "windows/posix.h"
 
+/* Cygwin doesn't define rand_r if C99 or newer is being used */
+#if defined(WIN32) && !defined(rand_r)
+int rand_r(unsigned *);
+#endif
+
 #ifndef PTHREAD_STACK_MIN
 #define PTHREAD_STACK_MIN 65535
 #endif
diff --git a/server.c b/server.c
index f6f3441..ab4069c 100644
--- a/server.c
+++ b/server.c
@@ -269,7 +269,7 @@ static int fio_recv_data(int sk, void *p, unsigned int len, bool wait)
 	if (wait)
 		flags = MSG_WAITALL;
 	else
-		flags = MSG_DONTWAIT;
+		flags = OS_MSG_DONTWAIT;
 
 	do {
 		int ret = recv(sk, p, len, flags);
