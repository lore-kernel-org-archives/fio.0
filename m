Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:49854 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753225AbdESMAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 19 May 2017 08:00:09 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dBgZk-0003iB-Os
        for fio@vger.kernel.org; Fri, 19 May 2017 12:00:08 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170519120002.7943B2C246B@kernel.dk>
Date: Fri, 19 May 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c78997bf625ffcca49c18e11ab0f5448b26d7452:

  man page: include reference to version 4 of the terse format (2017-05-09 21:08:12 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to dd3805d49995e59fdf61e2560c3fec5b7f5c71b6:

  Remove leftover warnings (2017-05-18 12:53:38 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      Fix wrap issue with 64-bit pwritev2/preadv2
      Remove leftover warnings

 os/os-linux.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/os/os-linux.h b/os/os-linux.h
index 911f7e7..ba53590 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -314,9 +314,13 @@ static inline int fio_set_sched_idle(void)
 static inline void make_pos_h_l(unsigned long *pos_h, unsigned long *pos_l,
 				off_t offset)
 {
+#if BITS_PER_LONG == 64
+	*pos_l = offset;
+	*pos_h = 0;
+#else
 	*pos_l = offset & 0xffffffff;
 	*pos_h = ((uint64_t) offset) >> 32;
-
+#endif
 }
 static inline ssize_t preadv2(int fd, const struct iovec *iov, int iovcnt,
 			      off_t offset, unsigned int flags)
