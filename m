Return-Path: <sbates@raithlin.com>
From: sbates@raithlin.com
Subject: [PATCH v2] pvsync2: Add hipri_probability option
Date: Thu, 27 Jul 2017 10:44:07 -0600
Message-Id: <1501173847-9433-1-git-send-email-sbates@raithlin.com>
MIME-Version: 1.0
Content-Type: text/plain
Return-Path: sbates@raithlin.com
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Stephen Bates <sbates@raithlin.com>
List-ID: <fio@vger.kernel.org>

From: Stephen Bates <sbates@raithlin.com>

Allow the user to set the probability of a pvsync2 IO being high
priority. Add a new option for the pvsync2 engine called
--hipri_probability will takes values in the range (0, 100) and use
that as a probability for setting RWF_HIPRI. The default for this
option is 100 so exisiting users of --hirpi are unaffected by
default.

Changes since v1:
  Use --hipri_probability rather than impacting --hipri
  Correct the random number generator call

Signed-off-by: Stephen Bates <sbates@raithlin.com>
---
 HOWTO          |  5 +++++
 engines/sync.c | 28 +++++++++++++++++++++++++++-
 fio.1          |  4 ++++
 3 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/HOWTO b/HOWTO
index 2fa8fc2..458e263 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1819,6 +1819,11 @@ caveat that when used on the command line, they must come after the
 	Set RWF_HIPRI on I/O, indicating to the kernel that it's of higher priority
 	than normal.
 
+.. option:: hipri_probability : [pvsync2]
+
+	This is a value is in the range (0, 100) and it is probabilistically applied
+	to each IO when hirpi is set.
+
 .. option:: cpuload=int : [cpuio]
 
 	Attempt to use the specified percentage of CPU cycles. This is a mandatory
diff --git a/engines/sync.c b/engines/sync.c
index e76bbbb..1aba395 100644
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
@@ -30,12 +33,18 @@ struct syncio_data {
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
 struct psyncv2_options {
 	void *pad;
 	unsigned int hipri;
+	unsigned int hipri_probability;
 };
 
 static struct fio_option options[] = {
@@ -49,6 +58,18 @@ static struct fio_option options[] = {
 		.group	= FIO_OPT_G_INVALID,
 	},
 	{
+		.name	= "hipri_probability",
+		.lname	= "RWF_HIPRI_PROBABILITY",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct psyncv2_options, hipri_probability),
+		.minval	= 0,
+		.maxval	= 100,
+		.def    = "100",
+		.help	= "Probabilistically set RWF_HIPRI for pwritev2/preadv2",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_INVALID,
+	},
+	{
 		.name	= NULL,
 	},
 };
@@ -132,7 +153,8 @@ static int fio_pvsyncio2_queue(struct thread_data *td, struct io_u *io_u)
 
 	fio_ro_check(td, io_u);
 
-	if (o->hipri)
+	if (o->hipri &&
+	    (rand32_between(&sd->rand_state, 1, 100) <= o->hipri_probability))
 		flags |= RWF_HIPRI;
 
 	iov->iov_base = io_u->xfer_buf;
@@ -364,6 +386,10 @@ static int fio_vsyncio_init(struct thread_data *td)
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
index 768b209..5b622ca 100644
--- a/fio.1
+++ b/fio.1
@@ -2017,6 +2017,10 @@ iodepth_batch_complete=0).
 Set RWF_HIPRI on IO, indicating to the kernel that it's of
 higher priority than normal.
 .TP
+.BI (pvsync2)hipri_probability
+This is a value is in the range (0, 100) and it is probabilistically
+applied to each IO when hipri is set.
+.TP
 .BI (net,netsplice)hostname \fR=\fPstr
 The host name or IP address to use for TCP or UDP based IO.
 If the job is a TCP listener or UDP reader, the hostname is not
-- 
1.9.1


