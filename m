Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:60174 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752686AbeDQMAX (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 17 Apr 2018 08:00:23 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1f8PHY-0006cp-GO
        for fio@vger.kernel.org; Tue, 17 Apr 2018 12:00:20 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180417120002.1A2622C00EE@kernel.dk>
Date: Tue, 17 Apr 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit dd39e2d406b6be11aa5432311034761aff5d6ba8:

  cconv: add conversion for 'replay_time_scale' (2018-04-14 16:26:17 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c7d32225c3efe61c79470bc31bb369b33d3e3a88:

  Merge branch 'nvml-to-pmdk' of https://github.com/sscargal/fio (2018-04-16 19:40:46 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      Fio 3.6
      Merge branch 'nvml-to-pmdk' of https://github.com/sscargal/fio

sscargal (1):
      NVML references renamed to PMDK

 FIO-VERSION-GEN   | 2 +-
 HOWTO             | 6 +++---
 configure         | 6 +++---
 engines/libpmem.c | 2 +-
 engines/pmemblk.c | 2 +-
 fio.1             | 6 +++---
 options.c         | 4 ++--
 7 files changed, 14 insertions(+), 14 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 7abd8ce..d2d095b 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-3.5
+DEF_VER=fio-3.6
 
 LF='
 '
diff --git a/HOWTO b/HOWTO
index 68b6b82..c34fdf3 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1854,12 +1854,12 @@ I/O engine
 
 		**pmemblk**
 			Read and write using filesystem DAX to a file on a filesystem
-			mounted with DAX on a persistent memory device through the NVML
+			mounted with DAX on a persistent memory device through the PMDK
 			libpmemblk library.
 
 		**dev-dax**
 			Read and write using device DAX to a persistent memory device (e.g.,
-			/dev/dax0.0) through the NVML libpmem library.
+			/dev/dax0.0) through the PMDK libpmem library.
 
 		**external**
 			Prefix to specify loading an external I/O engine object file. Append
@@ -1875,7 +1875,7 @@ I/O engine
 
 		**libpmem**
 			Read and write using mmap I/O to a file on a filesystem
-			mounted with DAX on a persistent memory device through the NVML
+			mounted with DAX on a persistent memory device through the PMDK
 			libpmem library.
 
 I/O engine specific parameters
diff --git a/configure b/configure
index 32baec6..70cb006 100755
--- a/configure
+++ b/configure
@@ -1894,15 +1894,15 @@ fi
 
 ##########################################
 # Report whether pmemblk engine is enabled
-print_config "NVML pmemblk engine" "$pmemblk"
+print_config "PMDK pmemblk engine" "$pmemblk"
 
 ##########################################
 # Report whether dev-dax engine is enabled
-print_config "NVML dev-dax engine" "$devdax"
+print_config "PMDK dev-dax engine" "$devdax"
 
 ##########################################
 # Report whether libpmem engine is enabled
-print_config "NVML libpmem engine" "$pmem"
+print_config "PMDK libpmem engine" "$pmem"
 
 ##########################################
 # Check if we have lex/yacc available
diff --git a/engines/libpmem.c b/engines/libpmem.c
index 3038784..dbb3f5c 100644
--- a/engines/libpmem.c
+++ b/engines/libpmem.c
@@ -1,5 +1,5 @@
 /*
- * libpmem: IO engine that uses NVML libpmem to read and write data
+ * libpmem: IO engine that uses PMDK libpmem to read and write data
  *
  * Copyright (C) 2017 Nippon Telegraph and Telephone Corporation.
  *
diff --git a/engines/pmemblk.c b/engines/pmemblk.c
index 5d21915..264eb71 100644
--- a/engines/pmemblk.c
+++ b/engines/pmemblk.c
@@ -1,5 +1,5 @@
 /*
- * pmemblk: IO engine that uses NVML libpmemblk to read and write data
+ * pmemblk: IO engine that uses PMDK libpmemblk to read and write data
  *
  * Copyright (C) 2016 Hewlett Packard Enterprise Development LP
  *
diff --git a/fio.1 b/fio.1
index 3b5522f..9264855 100644
--- a/fio.1
+++ b/fio.1
@@ -1628,12 +1628,12 @@ constraint.
 .TP
 .B pmemblk
 Read and write using filesystem DAX to a file on a filesystem
-mounted with DAX on a persistent memory device through the NVML
+mounted with DAX on a persistent memory device through the PMDK
 libpmemblk library.
 .TP
 .B dev\-dax
 Read and write using device DAX to a persistent memory device (e.g.,
-/dev/dax0.0) through the NVML libpmem library.
+/dev/dax0.0) through the PMDK libpmem library.
 .TP
 .B external
 Prefix to specify loading an external I/O engine object file. Append
@@ -1649,7 +1649,7 @@ done other than creating the file.
 .TP
 .B libpmem
 Read and write using mmap I/O to a file on a filesystem
-mounted with DAX on a persistent memory device through the NVML
+mounted with DAX on a persistent memory device through the PMDK
 libpmem library.
 .SS "I/O engine specific parameters"
 In addition, there are some parameters which are only valid when a specific
diff --git a/options.c b/options.c
index 045c62b..fb28511 100644
--- a/options.c
+++ b/options.c
@@ -1851,7 +1851,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 #endif
 #ifdef CONFIG_PMEMBLK
 			  { .ival = "pmemblk",
-			    .help = "NVML libpmemblk based IO engine",
+			    .help = "PMDK libpmemblk based IO engine",
 			  },
 
 #endif
@@ -1870,7 +1870,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			  },
 #ifdef CONFIG_LIBPMEM
 			  { .ival = "libpmem",
-			    .help = "NVML libpmem based IO engine",
+			    .help = "PMDK libpmem based IO engine",
 			  },
 #endif
 		},
