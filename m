Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:54001 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750907AbdGHMAM (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 8 Jul 2017 08:00:12 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dToPD-0004Pa-Nh
        for fio@vger.kernel.org; Sat, 08 Jul 2017 12:00:11 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170708120002.5C46D2C0098@kernel.dk>
Date: Sat,  8 Jul 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit f25f4ef6d123173d7669553ec712419f95c1a3ea:

  oslib/libmtd: kill dead code (2017-07-06 08:09:22 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6210cf66316e25498ab2e445731b3bb6b886c363:

  Fio 2.99 (2017-07-07 12:45:04 -0600)

----------------------------------------------------------------
Jens Axboe (3):
      io_u: sequence random buflen generation individually
      init: add comment as to how we seed read/write/trim generators
      Fio 2.99

 FIO-VERSION-GEN        |  2 +-
 fio.h                  |  4 +++-
 init.c                 | 17 ++++++++++++++++-
 io_u.c                 |  4 ++--
 os/windows/install.wxs |  2 +-
 5 files changed, 23 insertions(+), 6 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 3b4f206..f82aeee 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-2.21
+DEF_VER=fio-2.99
 
 LF='
 '
diff --git a/fio.h b/fio.h
index d5d6bfe..39d775c 100644
--- a/fio.h
+++ b/fio.h
@@ -91,6 +91,8 @@ enum {
 
 enum {
 	FIO_RAND_BS_OFF		= 0,
+	FIO_RAND_BS1_OFF,
+	FIO_RAND_BS2_OFF,
 	FIO_RAND_VER_OFF,
 	FIO_RAND_MIX_OFF,
 	FIO_RAND_FILE_OFF,
@@ -214,7 +216,7 @@ struct thread_data {
 
 	unsigned long rand_seeds[FIO_RAND_NR_OFFS];
 
-	struct frand_state bsrange_state;
+	struct frand_state bsrange_state[DDIR_RWDIR_CNT];
 	struct frand_state verify_state;
 	struct frand_state trim_state;
 	struct frand_state delay_state;
diff --git a/init.c b/init.c
index a4b5adb..9b2b63d 100644
--- a/init.c
+++ b/init.c
@@ -921,7 +921,22 @@ static void td_fill_rand_seeds_internal(struct thread_data *td, bool use64)
 {
 	int i;
 
-	init_rand_seed(&td->bsrange_state, td->rand_seeds[FIO_RAND_BS_OFF], use64);
+	/*
+	 * trimwrite is special in that we need to generate the same
+	 * offsets to get the "write after trim" effect. If we are
+	 * using bssplit to set buffer length distributions, ensure that
+	 * we seed the trim and write generators identically.
+	 */
+	if (td_trimwrite(td)) {
+		init_rand_seed(&td->bsrange_state[DDIR_READ], td->rand_seeds[FIO_RAND_BS_OFF], use64);
+		init_rand_seed(&td->bsrange_state[DDIR_WRITE], td->rand_seeds[FIO_RAND_BS1_OFF], use64);
+		init_rand_seed(&td->bsrange_state[DDIR_TRIM], td->rand_seeds[FIO_RAND_BS1_OFF], use64);
+	} else {
+		init_rand_seed(&td->bsrange_state[DDIR_READ], td->rand_seeds[FIO_RAND_BS_OFF], use64);
+		init_rand_seed(&td->bsrange_state[DDIR_WRITE], td->rand_seeds[FIO_RAND_BS1_OFF], use64);
+		init_rand_seed(&td->bsrange_state[DDIR_TRIM], td->rand_seeds[FIO_RAND_BS2_OFF], use64);
+	}
+
 	td_fill_verify_state_seed(td);
 	init_rand_seed(&td->rwmix_state, td->rand_seeds[FIO_RAND_MIX_OFF], false);
 
diff --git a/io_u.c b/io_u.c
index 8d42d65..ed8e84a 100644
--- a/io_u.c
+++ b/io_u.c
@@ -552,9 +552,9 @@ static unsigned int __get_next_buflen(struct thread_data *td, struct io_u *io_u,
 	if (!io_u_fits(td, io_u, minbs))
 		return 0;
 
-	frand_max = rand_max(&td->bsrange_state);
+	frand_max = rand_max(&td->bsrange_state[ddir]);
 	do {
-		r = __rand(&td->bsrange_state);
+		r = __rand(&td->bsrange_state[ddir]);
 
 		if (!td->o.bssplit_nr[ddir]) {
 			buflen = 1 + (unsigned int) ((double) maxbs *
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index 860570a..500d64c 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -10,7 +10,7 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.21">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.99">
 		<Package
 		  Description="Flexible IO Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
