Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:43805 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbcEYMAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 25 May 2016 08:00:05 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1b5XTo-0003si-9T
	for fio@vger.kernel.org; Wed, 25 May 2016 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160525120001.CC5D12C00EE@kernel.dk>
Date: Wed, 25 May 2016 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit bbcacb72ac5f81b77a96981e6d00d9134360e7c5:

  parse: warn if option is missing a long option variant (2016-05-23 10:39:16 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 97e1fe78db572a48a44c2a8511f8393a8643fc28:

  Fio 2.11 (2016-05-24 18:42:04 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      backend: regrow logs for sync IO engines as well
      Fio 2.11

Mark Nelson (1):
      remove numpy and scipy dependency

Martin Steigerwald (5):
      Spelling fix. Reported by Debian��s lintian.
      Spelling fix. Reported by Debian��s lintian.
      Spelling fix. Reported by Debian��s lintian.
      Spelling fix.
      Spelling fix. Reported by Debian��s lintian.

 FIO-VERSION-GEN        |  2 +-
 backend.c              |  3 +++
 fio.1                  |  2 +-
 gettime-thread.c       |  2 +-
 idletime.c             |  2 +-
 memory.c               |  2 +-
 options.c              |  2 +-
 os/windows/install.wxs |  2 +-
 tools/fiologparser.py  | 35 ++++++++++++++++++++---------------
 9 files changed, 30 insertions(+), 22 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index d1ba7ca..ea65ea8 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-2.10
+DEF_VER=fio-2.11
 
 LF='
 '
diff --git a/backend.c b/backend.c
index 6d50360..f132222 100644
--- a/backend.c
+++ b/backend.c
@@ -524,6 +524,9 @@ sync_done:
 				break;
 		}
 
+		if (td->flags & TD_F_REGROW_LOGS)
+			regrow_logs(td);
+
 		/*
 		 * when doing I/O (not when verifying),
 		 * check for any errors that are to be ignored
diff --git a/fio.1 b/fio.1
index 839a359..f521c9d 100644
--- a/fio.1
+++ b/fio.1
@@ -2087,7 +2087,7 @@ This format is not supported in Fio versions => 1.20-rc3.
 .B Trace file format v2
 .RS
 The second version of the trace file format was added in Fio version 1.17.
-It allows to access more then one file per trace and has a bigger set of
+It allows one to access more then one file per trace and has a bigger set of
 possible file actions.
 
 The first line of the trace file has to be:
diff --git a/gettime-thread.c b/gettime-thread.c
index 9bf85f0..6dc1486 100644
--- a/gettime-thread.c
+++ b/gettime-thread.c
@@ -81,7 +81,7 @@ int fio_start_gtod_thread(void)
 
 	ret = pthread_detach(gtod_thread);
 	if (ret) {
-		log_err("Can't detatch gtod thread: %s\n", strerror(ret));
+		log_err("Can't detach gtod thread: %s\n", strerror(ret));
 		goto err;
 	}
 
diff --git a/idletime.c b/idletime.c
index fab43c5..4c00d80 100644
--- a/idletime.c
+++ b/idletime.c
@@ -260,7 +260,7 @@ void fio_idle_prof_init(void)
 
 		if ((ret = pthread_detach(ipt->thread))) {
 			/* log error and let the thread spin */
-			log_err("fio: pthread_detatch %s\n", strerror(ret));
+			log_err("fio: pthread_detach %s\n", strerror(ret));
 		}
 	}
 
diff --git a/memory.c b/memory.c
index c04d7df..af4d5ef 100644
--- a/memory.c
+++ b/memory.c
@@ -89,7 +89,7 @@ static int alloc_mem_shm(struct thread_data *td, unsigned int total_mem)
 					" support huge pages.\n");
 			} else if (errno == ENOMEM) {
 				log_err("fio: no huge pages available, do you"
-					" need to alocate some? See HOWTO.\n");
+					" need to allocate some? See HOWTO.\n");
 			}
 		}
 
diff --git a/options.c b/options.c
index 7f0f2c0..3360784 100644
--- a/options.c
+++ b/options.c
@@ -2023,7 +2023,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			  },
 			  { .ival = "normal",
 			    .oval = FIO_RAND_DIST_GAUSS,
-			    .help = "Normal (gaussian) distribution",
+			    .help = "Normal (Gaussian) distribution",
 			  },
 			  { .ival = "zoned",
 			    .oval = FIO_RAND_DIST_ZONED,
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index 8ae1394..45084e6 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -10,7 +10,7 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.10">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.11">
 		<Package
 		  Description="Flexible IO Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
diff --git a/tools/fiologparser.py b/tools/fiologparser.py
index 00e4d30..685f419 100755
--- a/tools/fiologparser.py
+++ b/tools/fiologparser.py
@@ -14,8 +14,7 @@
 # to see per-interval average completion latency.
 
 import argparse
-import numpy
-import scipy
+import math
 
 def parse_args():
     parser = argparse.ArgumentParser()
@@ -82,7 +81,6 @@ def print_averages(ctx, series):
 # to debug this routine, use
 #   # sort -n -t ',' -k 2 small.log
 # on your input.
-# Sometimes scipy interpolates between two values to get a percentile
 
 def my_extend( vlist, val ):
     vlist.extend(val)
@@ -102,21 +100,16 @@ def print_all_stats(ctx, series):
         for sample_array in sample_arrays:
             samplevalue_arrays.append( 
                 [ sample.value for sample in sample_array ] )
-        #print('samplevalue_arrays len: %d' % len(samplevalue_arrays))
-        #print('samplevalue_arrays elements len: ' + \
-               #str(map( lambda l: len(l), samplevalue_arrays)))
         # collapse list of lists of sample values into list of sample values
         samplevalues = reduce( array_collapser, samplevalue_arrays, [] )
-        #print('samplevalues: ' + str(sorted(samplevalues)))
         # compute all stats and print them
-        myarray = scipy.fromiter(samplevalues, float)
-        mymin = scipy.amin(myarray)
-        myavg = scipy.average(myarray)
-        mymedian = scipy.median(myarray)
-        my90th = scipy.percentile(myarray, 90)
-        my95th = scipy.percentile(myarray, 95)
-        my99th = scipy.percentile(myarray, 99)
-        mymax = scipy.amax(myarray)
+        mymin = min(samplevalues)
+        myavg = sum(samplevalues) / float(len(samplevalues))
+        mymedian = median(samplevalues)
+        my90th = percentile(samplevalues, 0.90) 
+        my95th = percentile(samplevalues, 0.95)
+        my99th = percentile(samplevalues, 0.99)
+        mymax = max(samplevalues)
         print( '%f, %d, %f, %f, %f, %f, %f, %f, %f' % (
             start, len(samplevalues), 
             mymin, myavg, mymedian, my90th, my95th, my99th, mymax))
@@ -125,6 +118,18 @@ def print_all_stats(ctx, series):
         start += ctx.interval
         end += ctx.interval
 
+def median(values):
+    s=sorted(values)
+    return float(s[(len(s)-1)/2]+s[(len(s)/2)])/2
+
+def percentile(values, p):
+    s = sorted(values)
+    k = (len(s)-1) * p
+    f = math.floor(k)
+    c = math.ceil(k)
+    if f == c:
+        return s[int(k)]
+    return (s[int(f)] * (c-k)) + (s[int(c)] * (k-f))
 
 def print_default(ctx, series):
     ftime = get_ftime(series)
