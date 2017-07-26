Return-Path: <sbates@raithlin.com>
From: sbates@raithlin.com
Subject: [PATCH] pvsync2: Make hipri option probabilistic
Date: Wed, 26 Jul 2017 17:05:06 -0600
Message-Id: <1501110306-8531-1-git-send-email-sbates@raithlin.com>
MIME-Version: 1.0
Content-Type: text/plain
Return-Path: sbates@raithlin.com
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Stephen Bates <sbates@raithlin.com>
List-ID: <fio@vger.kernel.org>

From: Stephen Bates <sbates@raithlin.com>

Allow the user to set the probability of a pvsync2 IO being high
priority. This allows the user to investigate performance when there
is a mix of higher and lower priority IO.

Signed-off-by: Stephen Bates <sbates@raithlin.com>
---
 HOWTO          |  3 ++-
 engines/sync.c | 20 +++++++++++++++++---
 fio.1          |  3 ++-
 3 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/HOWTO b/HOWTO
index 2fa8fc2..808dea3 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1817,7 +1817,8 @@ caveat that when used on the command line, they must come after the
 .. option:: hipri : [pvsync2]
 
 	Set RWF_HIPRI on I/O, indicating to the kernel that it's of higher priority
-	than normal.
+	than normal. This is a value is in the range [0, 100] and it
+	is probabilitistically applied to each IO.
 
 .. option:: cpuload=int : [cpuio]
 
diff --git a/engines/sync.c b/engines/sync.c
index e76bbbb..33221ea 100644
--- a/engines/sync.c
+++ b/engines/sync.c
@@ -14,6 +14,9 @@
 
 #include "../fio.h"
 #include "../optgroup.h"
+#ifdef FIO_HAVE_PWRITEV2
+#include "../lib/rand.h"
+#endif
 
 /*
  * Sync engine uses engine_data to store last offset
@@ -30,6 +33,11 @@ struct syncio_data {
 	unsigned long long last_offset;
 	struct fio_file *last_file;
 	enum fio_ddir last_ddir;
+
+#ifdef FIO_HAVE_PWRITEV2
+	struct frand_state rand_state;
+#endif
+
 };
 
 #ifdef FIO_HAVE_PWRITEV2
@@ -42,9 +50,11 @@ static struct fio_option options[] = {
 	{
 		.name	= "hipri",
 		.lname	= "RWF_HIPRI",
-		.type	= FIO_OPT_STR_SET,
+		.type	= FIO_OPT_INT,
 		.off1	= offsetof(struct psyncv2_options, hipri),
-		.help	= "Set RWF_HIPRI for pwritev2/preadv2",
+		.minval	= 0,
+		.maxval	= 100,
+		.help	= "Probabilistically set RWF_HIPRI for pwritev2/preadv2",
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_INVALID,
 	},
@@ -132,7 +142,7 @@ static int fio_pvsyncio2_queue(struct thread_data *td, struct io_u *io_u)
 
 	fio_ro_check(td, io_u);
 
-	if (o->hipri)
+	if ((o->hipri == 100) || (rand32_between(&sd->rand_state, 0, 100) < o->hipri))
 		flags |= RWF_HIPRI;
 
 	iov->iov_base = io_u->xfer_buf;
@@ -364,6 +374,10 @@ static int fio_vsyncio_init(struct thread_data *td)
 	sd->iovecs = malloc(td->o.iodepth * sizeof(struct iovec));
 	sd->io_us = malloc(td->o.iodepth * sizeof(struct io_u *));
 
+#ifdef FIO_HAVE_PWRITEV2
+	init_rand(&sd->rand_state, 0);
+#endif
+
 	td->io_ops_data = sd;
 	return 0;
 }
diff --git a/fio.1 b/fio.1
index 768b209..a25f5e4 100644
--- a/fio.1
+++ b/fio.1
@@ -2015,7 +2015,8 @@ iodepth_batch_complete=0).
 .TP
 .BI (pvsync2)hipri
 Set RWF_HIPRI on IO, indicating to the kernel that it's of
-higher priority than normal.
+higher priority than normal. This is a value is in the range
+[0, 100] and it is probabilitistically applied to each IO.
 .TP
 .BI (net,netsplice)hostname \fR=\fPstr
 The host name or IP address to use for TCP or UDP based IO.
-- 
1.9.1


