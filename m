Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:38604 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726404AbfEGMAL (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 7 May 2019 08:00:11 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hNylW-0006nx-Qs
        for fio@vger.kernel.org; Tue, 07 May 2019 12:00:10 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190507120001.DF97C2C098E@kernel.dk>
Date: Tue,  7 May 2019 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 051382218cbe5101a5caa83eab55ed04608f8475:

  io_uring: remove cachehit information (2019-04-25 13:27:54 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f22dd97a5a1342c7dcb84f777a77bd30859cc35b:

  Update CFLAGS and LDFLAGS for FreeBSD builds (2019-05-06 22:18:55 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'fix-infinite-loop-of-io_uring' of https://github.com/satoru-takeuchi/fio

Rebecca Cran (1):
      Update CFLAGS and LDFLAGS for FreeBSD builds

Satoru Takeuchi (1):
      io_uring: fix possible infinite loop

 configure          | 4 ++++
 engines/io_uring.c | 2 ++
 2 files changed, 6 insertions(+)

---

Diff of recent changes:

diff --git a/configure b/configure
index c7a7c0ae..d71387c0 100755
--- a/configure
+++ b/configure
@@ -307,6 +307,10 @@ AIX|OpenBSD|NetBSD)
     force_no_lex_o="yes"
   fi
   ;;
+FreeBSD)
+  CFLAGS="$CFLAGS -I/usr/local/include"
+  LDFLAGS="$LDFLAGS -L/usr/local/lib"
+  ;;
 Darwin)
   # on Leopard most of the system is 32-bit, so we have to ask the kernel if
   # we can run 64-bit userspace code.
diff --git a/engines/io_uring.c b/engines/io_uring.c
index 5b3509a9..a5e77d8f 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -233,6 +233,8 @@ static int fio_ioring_getevents(struct thread_data *td, unsigned int min,
 		r = fio_ioring_cqring_reap(td, events, max);
 		if (r) {
 			events += r;
+			if (actual_min != 0)
+				actual_min -= r;
 			continue;
 		}
 

