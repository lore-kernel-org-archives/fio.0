Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48816 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbbAENAE (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 5 Jan 2015 08:00:04 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Y87GO-0001pH-2o
	for fio@vger.kernel.org; Mon, 05 Jan 2015 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150105130003.2095640181@lyth.info>
Date: Mon,  5 Jan 2015 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit fde90aadbbf223d4d9b553c8cda3b65b0b1140e2:

  Fio 2.2.4 (2015-01-03 19:46:55 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 17a2be5945b12959ad3066b7d75432577d29ae82:

  Avoid potential buffer overflow in make_filename() (2015-01-04 13:33:37 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      cleanup: add defines for default pareto or zipf values
      Avoid potential buffer overflow in make_filename()

 fio.h     |    3 +++
 init.c    |   30 ++++++++++++++++++++++++------
 options.c |    4 ++--
 3 files changed, 29 insertions(+), 8 deletions(-)

---

Diff of recent changes:

diff --git a/fio.h b/fio.h
index 5e352c6..be2f23a 100644
--- a/fio.h
+++ b/fio.h
@@ -642,6 +642,9 @@ enum {
 	FIO_RAND_DIST_PARETO,
 };
 
+#define FIO_DEF_ZIPF		1.1
+#define FIO_DEF_PARETO		0.2
+
 enum {
 	FIO_RAND_GEN_TAUSWORTHE = 0,
 	FIO_RAND_GEN_LFSR,
diff --git a/init.c b/init.c
index dc563fd..a0d4f8c 100644
--- a/init.c
+++ b/init.c
@@ -1036,8 +1036,14 @@ static char *make_filename(char *buf, size_t buf_size,struct thread_options *o,
 				ret = snprintf(dst, dst_left, "%s", jobname);
 				if (ret < 0)
 					break;
-				dst += ret;
-				dst_left -= ret;
+				else if (ret > dst_left) {
+					log_err("fio: truncated filename\n");
+					dst += dst_left;
+					dst_left = 0;
+				} else {
+					dst += ret;
+					dst_left -= ret;
+				}
 				break;
 				}
 			case FPRE_JOBNUM: {
@@ -1046,8 +1052,14 @@ static char *make_filename(char *buf, size_t buf_size,struct thread_options *o,
 				ret = snprintf(dst, dst_left, "%d", jobnum);
 				if (ret < 0)
 					break;
-				dst += ret;
-				dst_left -= ret;
+				else if (ret > dst_left) {
+					log_err("fio: truncated filename\n");
+					dst += dst_left;
+					dst_left = 0;
+				} else {
+					dst += ret;
+					dst_left -= ret;
+				}
 				break;
 				}
 			case FPRE_FILENUM: {
@@ -1056,8 +1068,14 @@ static char *make_filename(char *buf, size_t buf_size,struct thread_options *o,
 				ret = snprintf(dst, dst_left, "%d", filenum);
 				if (ret < 0)
 					break;
-				dst += ret;
-				dst_left -= ret;
+				else if (ret > dst_left) {
+					log_err("fio: truncated filename\n");
+					dst += dst_left;
+					dst_left = 0;
+				} else {
+					dst += ret;
+					dst_left -= ret;
+				}
 				break;
 				}
 			default:
diff --git a/options.c b/options.c
index 12ff621..ab6e399 100644
--- a/options.c
+++ b/options.c
@@ -715,9 +715,9 @@ static int str_random_distribution_cb(void *data, const char *str)
 		return 0;
 
 	if (td->o.random_distribution == FIO_RAND_DIST_ZIPF)
-		val = 1.1;
+		val = FIO_DEF_ZIPF;
 	else if (td->o.random_distribution == FIO_RAND_DIST_PARETO)
-		val = 0.2;
+		val = FIO_DEF_PARETO;
 	else
 		return 0;
 
