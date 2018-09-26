Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:46738 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727993AbeIZSNC (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 26 Sep 2018 14:13:02 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g58UH-0007bA-3E
        for fio@vger.kernel.org; Wed, 26 Sep 2018 12:00:22 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180926120002.51A4E2C031B@kernel.dk>
Date: Wed, 26 Sep 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 9f2cd5e0ccbce6b65276c1401cdcf2cb8b77b9ff:

  stat: print the right percentile variant for json output (2018-09-22 15:02:04 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 7676a1c25fcdacfe27d84a0f86fe68077b7de79a:

  parse: fix negative FIO_OPT_INT too-large check (2018-09-25 20:15:05 -0600)

----------------------------------------------------------------
Jens Axboe (5):
      parse: print option name for out-of-range settings
      parse: fix min/max val checking for FIO_OPT_INT
      Add regression test for flow/negative option parser breakage
      parse: fix minval checking
      parse: fix negative FIO_OPT_INT too-large check

 parse.c                   | 39 +++++++++++++++++++++++++++++++++------
 t/jobs/t0011-5d2788d5.fio | 18 ++++++++++++++++++
 2 files changed, 51 insertions(+), 6 deletions(-)
 create mode 100644 t/jobs/t0011-5d2788d5.fio

---

Diff of recent changes:

diff --git a/parse.c b/parse.c
index 5d88d91..a7d4516 100644
--- a/parse.c
+++ b/parse.c
@@ -506,6 +506,33 @@ static const char *opt_type_name(const struct fio_option *o)
 	return "OPT_UNKNOWN?";
 }
 
+static bool val_too_large(const struct fio_option *o, unsigned long long val,
+			  bool is_uint)
+{
+	if (!o->maxval)
+		return false;
+
+	if (is_uint) {
+		if ((int) val < 0)
+			return (int) val > (int) o->maxval;
+		return (unsigned int) val > o->maxval;
+	}
+
+	return val > o->maxval;
+}
+
+static bool val_too_small(const struct fio_option *o, unsigned long long val,
+			  bool is_uint)
+{
+	if (!o->minval)
+		return false;
+
+	if (is_uint)
+		return (int) val < o->minval;
+
+	return val < o->minval;
+}
+
 static int __handle_option(const struct fio_option *o, const char *ptr,
 			   void *data, int first, int more, int curr)
 {
@@ -595,14 +622,14 @@ static int __handle_option(const struct fio_option *o, const char *ptr,
 			return 1;
 		}
 
-		if (o->maxval && ull > o->maxval) {
-			log_err("max value out of range: %llu"
-					" (%llu max)\n", ull, o->maxval);
+		if (val_too_large(o, ull, o->type == FIO_OPT_INT)) {
+			log_err("%s: max value out of range: %llu"
+				" (%llu max)\n", o->name, ull, o->maxval);
 			return 1;
 		}
-		if (o->minval && ull < o->minval) {
-			log_err("min value out of range: %lld"
-					" (%d min)\n", ull, o->minval);
+		if (val_too_small(o, ull, o->type == FIO_OPT_INT)) {
+			log_err("%s: min value out of range: %lld"
+				" (%d min)\n", o->name, ull, o->minval);
 			return 1;
 		}
 		if (o->posval[0].ival) {
diff --git a/t/jobs/t0011-5d2788d5.fio b/t/jobs/t0011-5d2788d5.fio
new file mode 100644
index 0000000..09861f7
--- /dev/null
+++ b/t/jobs/t0011-5d2788d5.fio
@@ -0,0 +1,18 @@
+# Expected results: no parse warnings, runs and with roughly 1/8 iops between
+#			the two jobs.
+# Buggy result: parse warning on flow value overflow, no 1/8 division between
+			jobs.
+#
+[global]
+bs=4k
+ioengine=null
+size=100g
+runtime=3
+flow_id=1
+
+[flow1]
+flow=-8
+rate_iops=1000
+
+[flow2]
+flow=1

