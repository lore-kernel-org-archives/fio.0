Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:48052 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752393AbdFOMAM (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 15 Jun 2017 08:00:12 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dLTRb-0006l9-J7
        for fio@vger.kernel.org; Thu, 15 Jun 2017 12:00:11 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170615120001.F1F762C0120@kernel.dk>
Date: Thu, 15 Jun 2017 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 052046a1e92bff19ecae277670a59fb726a66b86:

  binject: don't use void* for pointer arithmetic (gcc) (2017-06-12 14:51:01 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 72cd4146e538450b8789095b910ffce2b397a06c:

  sync: add support for write life time hint (2017-06-14 09:55:40 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      sync: add support for write life time hint

 engines/sync.c | 26 ++++++++++++++++++++++++++
 os/os-linux.h  |  8 ++++++++
 2 files changed, 34 insertions(+)

---

Diff of recent changes:

diff --git a/engines/sync.c b/engines/sync.c
index e76bbbb..69d5e21 100644
--- a/engines/sync.c
+++ b/engines/sync.c
@@ -36,6 +36,7 @@ struct syncio_data {
 struct psyncv2_options {
 	void *pad;
 	unsigned int hipri;
+	unsigned int stream;
 };
 
 static struct fio_option options[] = {
@@ -49,6 +50,29 @@ static struct fio_option options[] = {
 		.group	= FIO_OPT_G_INVALID,
 	},
 	{
+		.name	= "stream",
+		.lname	= "Stream ID",
+		.type	= FIO_OPT_STR,
+		.off1	= offsetof(struct psyncv2_options, stream),
+		.help	= "Set expected write life time",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_INVALID,
+		.posval = {
+			  { .ival = "short",
+			    .oval = RWF_WRITE_LIFE_SHORT,
+			  },
+			  { .ival = "medium",
+			    .oval = RWF_WRITE_LIFE_MEDIUM,
+			  },
+			  { .ival = "long",
+			    .oval = RWF_WRITE_LIFE_LONG,
+			  },
+			  { .ival = "extreme",
+			    .oval = RWF_WRITE_LIFE_EXTREME,
+			  },
+		},
+	},
+	{
 		.name	= NULL,
 	},
 };
@@ -134,6 +158,8 @@ static int fio_pvsyncio2_queue(struct thread_data *td, struct io_u *io_u)
 
 	if (o->hipri)
 		flags |= RWF_HIPRI;
+	if (o->stream)
+		flags |= o->stream;
 
 	iov->iov_base = io_u->xfer_buf;
 	iov->iov_len = io_u->xfer_buflen;
diff --git a/os/os-linux.h b/os/os-linux.h
index 008ce2d..09e7413 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -319,6 +319,14 @@ static inline int fio_set_sched_idle(void)
 #define RWF_SYNC	0x00000004
 #endif
 
+#ifndef RWF_WRITE_LIFE_SHIFT
+#define RWF_WRITE_LIFE_SHIFT		4
+#define RWF_WRITE_LIFE_SHORT		(1 << RWF_WRITE_LIFE_SHIFT)
+#define RWF_WRITE_LIFE_MEDIUM		(2 << RWF_WRITE_LIFE_SHIFT)
+#define RWF_WRITE_LIFE_LONG		(3 << RWF_WRITE_LIFE_SHIFT)
+#define RWF_WRITE_LIFE_EXTREME		(4 << RWF_WRITE_LIFE_SHIFT)
+#endif
+
 #ifndef CONFIG_PWRITEV2
 #ifdef __NR_preadv2
 static inline void make_pos_h_l(unsigned long *pos_h, unsigned long *pos_l,
