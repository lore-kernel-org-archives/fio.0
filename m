Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57684 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932357AbcLTNAE (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 20 Dec 2016 08:00:04 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1cJK1T-0007bB-IV
        for fio@vger.kernel.org; Tue, 20 Dec 2016 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20161220130001.7E1962C0098@kernel.dk>
Date: Tue, 20 Dec 2016 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 104ee4dea7246d51d053076c55b917548dd0e7e2:

  fio: add additional support for dev-dax ioengine (2016-12-16 16:05:05 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 4fc8c5adec635f3a0d7e6c666328e96f14a9f015:

  Fio 2.16 (2016-12-19 23:12:56 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      options: full control of fadvise hinting
      Fio 2.16

 FIO-VERSION-GEN        |  2 +-
 HOWTO                  | 13 +++++++++++--
 fio.1                  | 22 ++++++++++++++++++++--
 fio.h                  |  7 +++++++
 ioengines.c            | 16 +++++++++++++---
 options.c              | 20 +++++++++++++++++++-
 os/windows/install.wxs |  2 +-
 7 files changed, 72 insertions(+), 10 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index eac0e00..b324859 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-2.15
+DEF_VER=fio-2.16
 
 LF='
 '
diff --git a/HOWTO b/HOWTO
index 6893c86..7274c0e 100644
--- a/HOWTO
+++ b/HOWTO
@@ -476,8 +476,17 @@ fadvise_hint=bool By default, fio will use fadvise() to advise the kernel
 		on what IO patterns it is likely to issue. Sometimes you
 		want to test specific IO patterns without telling the
 		kernel about it, in which case you can disable this option.
-		If set, fio will use POSIX_FADV_SEQUENTIAL for sequential
-		IO and POSIX_FADV_RANDOM for random IO.
+		The following options are supported:
+
+			sequential	Use FADV_SEQUENTIAL
+			random		Use FADV_RANDOM
+			1		Backwards-compatible hint for basing
+					the hint on the fio workload. Will use
+					FADV_SEQUENTIAL for a sequential
+					workload, and FADV_RANDOM for a random
+					workload.
+			0		Backwards-compatible setting for not
+					issing a fadvise hint.
 
 fadvise_stream=int Notify the kernel what write stream ID to place these
 		writes under. Only supported on Linux. Note, this option
diff --git a/fio.1 b/fio.1
index e8a327c..6161760 100644
--- a/fio.1
+++ b/fio.1
@@ -396,9 +396,27 @@ available on Linux. If using ZFS on Solaris this must be set to 'none'
 because ZFS doesn't support it. Default: 'posix'.
 .RE
 .TP
-.BI fadvise_hint \fR=\fPbool
+.BI fadvise_hint \fR=\fPstr
 Use \fBposix_fadvise\fR\|(2) to advise the kernel what I/O patterns
-are likely to be issued. Default: true.
+are likely to be issued. Accepted values are:
+.RS
+.RS
+.TP
+.B 0
+Backwards compatible hint for "no hint".
+.TP
+.B 1
+Backwards compatible hint for "advise with fio workload type". This
+uses \fBFADV_RANDOM\fR for a random workload, and \fBFADV_SEQUENTIAL\fR
+for a sequential workload.
+.TP
+.B sequential
+Advise using \fBFADV_SEQUENTIAL\fR
+.TP
+.B random
+Advise using \fBFADV_RANDOM\fR
+.RE
+.RE
 .TP
 .BI fadvise_stream \fR=\fPint
 Use \fBposix_fadvise\fR\|(2) to advise the kernel what stream ID the
diff --git a/fio.h b/fio.h
index 5726bef..df17074 100644
--- a/fio.h
+++ b/fio.h
@@ -110,6 +110,13 @@ enum {
 	RATE_PROCESS_POISSON = 1,
 };
 
+enum {
+	F_ADV_NONE = 0,
+	F_ADV_TYPE,
+	F_ADV_RANDOM,
+	F_ADV_SEQUENTIAL,
+};
+
 /*
  * Per-thread/process specific data. Only used for the network client
  * for now.
diff --git a/ioengines.c b/ioengines.c
index 1b58168..a1f8756 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -448,14 +448,24 @@ int td_io_open_file(struct thread_data *td, struct fio_file *f)
 	if (td->o.invalidate_cache && file_invalidate_cache(td, f))
 		goto err;
 
-	if (td->o.fadvise_hint &&
+	if (td->o.fadvise_hint != F_ADV_NONE &&
 	    (f->filetype == FIO_TYPE_BD || f->filetype == FIO_TYPE_FILE)) {
 		int flags;
 
-		if (td_random(td))
+		if (td->o.fadvise_hint == F_ADV_TYPE) {
+			if (td_random(td))
+				flags = POSIX_FADV_RANDOM;
+			else
+				flags = POSIX_FADV_SEQUENTIAL;
+		} else if (td->o.fadvise_hint == F_ADV_RANDOM)
 			flags = POSIX_FADV_RANDOM;
-		else
+		else if (td->o.fadvise_hint == F_ADV_SEQUENTIAL)
 			flags = POSIX_FADV_SEQUENTIAL;
+		else {
+			log_err("fio: unknown fadvise type %d\n",
+							td->o.fadvise_hint);
+			flags = POSIX_FADV_NORMAL;
+		}
 
 		if (posix_fadvise(f->fd, f->file_offset, f->io_size, flags) < 0) {
 			td_verror(td, errno, "fadvise");
diff --git a/options.c b/options.c
index 7638afc..b81db23 100644
--- a/options.c
+++ b/options.c
@@ -2295,8 +2295,26 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	{
 		.name	= "fadvise_hint",
 		.lname	= "Fadvise hint",
-		.type	= FIO_OPT_BOOL,
+		.type	= FIO_OPT_STR,
 		.off1	= offsetof(struct thread_options, fadvise_hint),
+		.posval	= {
+			  { .ival = "0",
+			    .oval = F_ADV_NONE,
+			    .help = "Don't issue fadvise",
+			  },
+			  { .ival = "1",
+			    .oval = F_ADV_TYPE,
+			    .help = "Advise using fio IO pattern",
+			  },
+			  { .ival = "random",
+			    .oval = F_ADV_RANDOM,
+			    .help = "Advise using FADV_RANDOM",
+			  },
+			  { .ival = "sequential",
+			    .oval = F_ADV_SEQUENTIAL,
+			    .help = "Advise using FADV_SEQUENTIAL",
+			  },
+		},
 		.help	= "Use fadvise() to advise the kernel on IO pattern",
 		.def	= "1",
 		.category = FIO_OPT_C_FILE,
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index 25cb269..b660fc6 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -10,7 +10,7 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.15">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.16">
 		<Package
 		  Description="Flexible IO Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
