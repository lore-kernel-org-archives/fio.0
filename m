Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 048BEC433F5
	for <fio@archiver.kernel.org>; Thu,  4 Nov 2021 07:40:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4726611C0
	for <fio@archiver.kernel.org>; Thu,  4 Nov 2021 07:40:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhKDHmq (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 4 Nov 2021 03:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbhKDHmq (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 4 Nov 2021 03:42:46 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2682DC061714
        for <fio@vger.kernel.org>; Thu,  4 Nov 2021 00:40:08 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id v23so8030791ljk.5
        for <fio@vger.kernel.org>; Thu, 04 Nov 2021 00:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wWBK9nbyiZvsXE8f/T4fkhsJfaB5DqwCVQ4FKO0ZXuc=;
        b=GaXdZWPYRqw1bLI1np23XOfsUl0E0eaTCsbqveaJ8hhHhtaFLQtkm9neNZa6NFqJUV
         ahka8yvrWxZGJDdkMINbMOGZVxEvoDXStknG8E4tgPndMGRzsmpyIDzn7Wn5maNO8Kfu
         nXx18j4eGslMzIyGOYRpJ8EJVCB+rcwC0rFgOAwpxqDUCBUmh4kygEBAaI411EpwgmwB
         kM3TZnrrIDxdesQp5BVBDOYmu9bPLCul/HsUS5+/178j3hotGJCTg4f3YZBQ6MtPmHSI
         iS6sRNaJkZ8h77JSnHKB4VEd58eWC/0P2s39LycYBm8hVVmEQdRdQjdumGx4EysTFy5y
         YynA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=wWBK9nbyiZvsXE8f/T4fkhsJfaB5DqwCVQ4FKO0ZXuc=;
        b=mOQu7tLg5KJE1HgyHOnsTOpsOWNP7UH2diw4FTw6YlgOHZtn7P1LlV9sNZTOjgsz7x
         cNb80fpcmaUVZxiRoNxSFfdH1rh1dnpwmC6TQ/oldrZ7EplBZaAhgYgynYaQzuxI9pwm
         NVhojc3WPyu4lRCWEihOgws2Fe8G2btQ96EX0ZH4vLW4MAzzbtaXKKpK40xAQDVfW6TF
         /h0m+kDaC8sBXYMlOzuWOlLnBKF2qzuEf3byLzHtSSWcFgMQXh3RX9SgeJmTdArtoecP
         o3PqqGu/TcF79T7+yr/UpWptkHuC4J8yU3Ddmeu6wqRWyHy4gY4DEb+v+wyk18PZnZ26
         vLLw==
X-Gm-Message-State: AOAM530yPoP+49bdxRXliYP1+MiVGyEi+GxgUyLiTw3MGyDzfZNHXoYJ
        Ol4ofMJKSuwOfJ9IVK2Hb0FGKiqp8BKG+w==
X-Google-Smtp-Source: ABdhPJxliM75ffzPalbLXG5OsOUwdD0iudqe3GXZC4Dq/gCMoNGWqNXx60nGtFpVDTtyVK2CwWg6ew==
X-Received: by 2002:a2e:879a:: with SMTP id n26mr7016093lji.426.1636011604877;
        Thu, 04 Nov 2021 00:40:04 -0700 (PDT)
Received: from localhost.localdomain (dyh1cxc773fwnls7mh3kt-4.rev.dnainternet.fi. [2001:14bb:1aa:298b:7bb9:24b4:bf6a:35d1])
        by smtp.gmail.com with ESMTPSA id h21sm388383lfu.91.2021.11.04.00.40.04
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 00:40:04 -0700 (PDT)
Sender: =?UTF-8?Q?Ville_Skytt=C3=A4?= <vskytta@gmail.com>
From:   "=?UTF-8?q?Ville=20Skytt=C3=A4?=" <ville.skytta@iki.fi>
X-Google-Original-From: =?UTF-8?q?Ville=20Skytt=C3=A4?= <ville.skytta@upcloud.com>
To:     fio@vger.kernel.org
Subject: [PATCH] Spelling and grammar fixes
Date:   Thu,  4 Nov 2021 09:40:03 +0200
Message-Id: <20211104074003.725915-1-ville.skytta@upcloud.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Signed-off-by: Ville Skyttä <ville.skytta@upcloud.com>
---
 engines/exec.c                      | 4 ++--
 engines/ime.c                       | 2 +-
 engines/libhdfs.c                   | 2 +-
 engines/nbd.c                       | 2 +-
 engines/rados.c                     | 2 +-
 engines/rbd.c                       | 4 ++--
 examples/enospc-pressure.fio        | 4 ++--
 examples/falloc.fio                 | 2 +-
 examples/librpma_apm-server.fio     | 2 +-
 examples/librpma_gpspm-server.fio   | 2 +-
 examples/rand-zones.fio             | 2 +-
 graph.c                             | 2 +-
 os/os-android.h                     | 2 +-
 os/os-netbsd.h                      | 2 +-
 stat.h                              | 2 +-
 t/one-core-peak.sh                  | 2 +-
 t/readonly.py                       | 2 +-
 t/sgunmap-test.py                   | 2 +-
 t/steadystate_tests.py              | 2 +-
 t/time-test.c                       | 2 +-
 tools/fio_jsonplus_clat2csv         | 4 ++--
 tools/fiograph/fiograph.py          | 2 +-
 tools/genfio                        | 2 +-
 tools/hist/fio-histo-log-pctiles.py | 2 +-
 tools/plot/fio2gnuplot.manpage      | 2 +-
 25 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/engines/exec.c b/engines/exec.c
index ab3639c5..20e50e00 100644
--- a/engines/exec.c
+++ b/engines/exec.c
@@ -67,8 +67,8 @@ char *str_replace(char *orig, const char *rep, const char *with)
 	/*
 	 * Replace a substring by another.
 	 *
-	 * Returns the new string if occurences were found
-	 * Returns orig if no occurence is found
+	 * Returns the new string if occurrences were found
+	 * Returns orig if no occurrence is found
 	 */
 	char *result, *insert, *tmp;
 	int len_rep, len_with, len_front, count;
diff --git a/engines/ime.c b/engines/ime.c
index 440cc29e..f6690cc1 100644
--- a/engines/ime.c
+++ b/engines/ime.c
@@ -83,7 +83,7 @@ struct ime_data {
 	};
 	struct iovec 	*iovecs;		/* array of queued iovecs */
 	struct io_u 	**io_us;		/* array of queued io_u pointers */
-	struct io_u 	**event_io_us;	/* array of the events retieved afer get_events*/
+	struct io_u 	**event_io_us;	/* array of the events retrieved after get_events*/
 	unsigned int 	queued;			/* iovecs/io_us in the queue */
 	unsigned int 	events;			/* number of committed iovecs/io_us */
 
diff --git a/engines/libhdfs.c b/engines/libhdfs.c
index eb55c3c5..f20e45ca 100644
--- a/engines/libhdfs.c
+++ b/engines/libhdfs.c
@@ -27,7 +27,7 @@ struct hdfsio_data {
 };
 
 struct hdfsio_options {
-	void *pad;			/* needed because offset can't be 0 for a option defined used offsetof */
+	void *pad;			/* needed because offset can't be 0 for an option defined used offsetof */
 	char *host;
 	char *directory;
 	unsigned int port;
diff --git a/engines/nbd.c b/engines/nbd.c
index b0ba75e6..7c2d5f4b 100644
--- a/engines/nbd.c
+++ b/engines/nbd.c
@@ -52,7 +52,7 @@ static struct fio_option options[] = {
 	},
 };
 
-/* Alocates nbd_data. */
+/* Allocates nbd_data. */
 static int nbd_setup(struct thread_data *td)
 {
 	struct nbd_data *nbd_data;
diff --git a/engines/rados.c b/engines/rados.c
index 23e62c4c..976f9229 100644
--- a/engines/rados.c
+++ b/engines/rados.c
@@ -151,7 +151,7 @@ static int _fio_rados_connect(struct thread_data *td)
 		char *client_name = NULL;
 
 		/*
-		* If we specify cluser name, the rados_create2
+		* If we specify cluster name, the rados_create2
 		* will not assume 'client.'. name is considered
 		* as a full type.id namestr
 		*/
diff --git a/engines/rbd.c b/engines/rbd.c
index c6203d4c..2f25889a 100644
--- a/engines/rbd.c
+++ b/engines/rbd.c
@@ -173,7 +173,7 @@ static int _fio_rbd_connect(struct thread_data *td)
 		char *client_name = NULL; 
 
 		/*
-		 * If we specify cluser name, the rados_create2
+		 * If we specify cluster name, the rados_create2
 		 * will not assume 'client.'. name is considered
 		 * as a full type.id namestr
 		 */
@@ -633,7 +633,7 @@ static int fio_rbd_setup(struct thread_data *td)
 
 	/* taken from "net" engine. Pretend we deal with files,
 	 * even if we do not have any ideas about files.
-	 * The size of the RBD is set instead of a artificial file.
+	 * The size of the RBD is set instead of an artificial file.
 	 */
 	if (!td->files_index) {
 		add_file(td, td->o.filename ? : "rbd", 0, 0);
diff --git a/examples/enospc-pressure.fio b/examples/enospc-pressure.fio
index ca9d8f7a..fa404fd5 100644
--- a/examples/enospc-pressure.fio
+++ b/examples/enospc-pressure.fio
@@ -35,8 +35,8 @@ bs=4k
 rw=randtrim
 filename=raicer
 
-# Verifier thread continiously write to newly allcated blocks
-# and veryfy written content
+# Verifier thread continuously writes to newly allcated blocks
+# and verifies written content
 [aio-dio-verifier]
 create_on_open=1
 verify=crc32c-intel
diff --git a/examples/falloc.fio b/examples/falloc.fio
index fadf1321..5a3e88b8 100644
--- a/examples/falloc.fio
+++ b/examples/falloc.fio
@@ -29,7 +29,7 @@ rw=randtrim
 numjobs=2
 filename=fragmented_file
 
-## Mesure IO performance on fragmented file
+## Measure IO performance on fragmented file
 [sequential aio-dio write]
 stonewall
 ioengine=libaio
diff --git a/examples/librpma_apm-server.fio b/examples/librpma_apm-server.fio
index 062b5215..dc1ddba2 100644
--- a/examples/librpma_apm-server.fio
+++ b/examples/librpma_apm-server.fio
@@ -20,7 +20,7 @@ thread
 # (https://pmem.io/rpma/documentation/basic-direct-write-to-pmem.html)
 direct_write_to_pmem=0
 
-numjobs=1 # number of expected incomming connections
+numjobs=1 # number of expected incoming connections
 size=100MiB # size of workspace for a single connection
 filename=malloc # device dax or an existing fsdax file or "malloc" for allocation from DRAM
 # filename=/dev/dax1.0
diff --git a/examples/librpma_gpspm-server.fio b/examples/librpma_gpspm-server.fio
index 67e92a28..4555314f 100644
--- a/examples/librpma_gpspm-server.fio
+++ b/examples/librpma_gpspm-server.fio
@@ -22,7 +22,7 @@ thread
 direct_write_to_pmem=0
 # set to 0 (false) to wait for completion instead of busy-wait polling completion.
 busy_wait_polling=1
-numjobs=1 # number of expected incomming connections
+numjobs=1 # number of expected incoming connections
 iodepth=2 # number of parallel GPSPM requests
 size=100MiB # size of workspace for a single connection
 filename=malloc # device dax or an existing fsdax file or "malloc" for allocation from DRAM
diff --git a/examples/rand-zones.fio b/examples/rand-zones.fio
index 169137d4..10e71727 100644
--- a/examples/rand-zones.fio
+++ b/examples/rand-zones.fio
@@ -21,6 +21,6 @@ random_distribution=zoned:50/5:30/15:20/
 # The above applies to all of reads/writes/trims. If we wanted to do
 # something differently for writes, let's say 50% for the first 10%
 # and 50% for the remaining 90%, we could do it by adding a new section
-# after a a comma.
+# after a comma.
 
 # random_distribution=zoned:50/5:30/15:20/,50/10:50/90
diff --git a/graph.c b/graph.c
index 7a174170..c49cdae1 100644
--- a/graph.c
+++ b/graph.c
@@ -999,7 +999,7 @@ const char *graph_find_tooltip(struct graph *g, int ix, int iy)
 				ydiff = fabs(yval - y);
 
 				/*
-				 * zero delta, or within or match critera, break
+				 * zero delta, or within or match criteria, break
 				 */
 				if (ydiff < best_delta) {
 					best_delta = ydiff;
diff --git a/os/os-android.h b/os/os-android.h
index 10c51b83..2f73d249 100644
--- a/os/os-android.h
+++ b/os/os-android.h
@@ -66,7 +66,7 @@
 
 #ifndef CONFIG_NO_SHM
 /*
- * Bionic doesn't support SysV shared memeory, so implement it using ashmem
+ * Bionic doesn't support SysV shared memory, so implement it using ashmem
  */
 #include <stdio.h>
 #include <linux/ashmem.h>
diff --git a/os/os-netbsd.h b/os/os-netbsd.h
index 624c7fa5..b553a430 100644
--- a/os/os-netbsd.h
+++ b/os/os-netbsd.h
@@ -13,7 +13,7 @@
 #include <sys/endian.h>
 #include <sys/sysctl.h>
 
-/* XXX hack to avoid confilcts between rbtree.h and <sys/rbtree.h> */
+/* XXX hack to avoid conflicts between rbtree.h and <sys/rbtree.h> */
 #undef rb_node
 #undef rb_left
 #undef rb_right
diff --git a/stat.h b/stat.h
index a06237e7..c7eca89a 100644
--- a/stat.h
+++ b/stat.h
@@ -68,7 +68,7 @@ struct group_run_stats {
  * than one. This method has low accuracy when the value is small. For
  * example, let the buckets be {[0,99],[100,199],...,[900,999]}, and
  * the represented value of each bucket be the mean of the range. Then
- * a value 0 has an round-off error of 49.5. To improve on this, we
+ * a value 0 has a round-off error of 49.5. To improve on this, we
  * use buckets with non-uniform ranges, while bounding the error of
  * each bucket within a ratio of the sample value. A simple example
  * would be when error_bound = 0.005, buckets are {
diff --git a/t/one-core-peak.sh b/t/one-core-peak.sh
index 9da8304e..63ca2093 100755
--- a/t/one-core-peak.sh
+++ b/t/one-core-peak.sh
@@ -34,7 +34,7 @@ check_binary() {
   for bin in "$@"; do
     if [ ! -x ${bin} ]; then
       which ${bin} >/dev/null
-      [ $? -eq 0 ] || fatal "${bin} doesn't exists or is not executable"
+      [ $? -eq 0 ] || fatal "${bin} doesn't exist or is not executable"
     fi
   done
 }
diff --git a/t/readonly.py b/t/readonly.py
index 464847c6..80fac639 100755
--- a/t/readonly.py
+++ b/t/readonly.py
@@ -6,7 +6,7 @@
 #
 # readonly.py
 #
-# Do some basic tests of the --readonly paramter
+# Do some basic tests of the --readonly parameter
 #
 # USAGE
 # python readonly.py [-f fio-executable]
diff --git a/t/sgunmap-test.py b/t/sgunmap-test.py
index 4960a040..6687494f 100755
--- a/t/sgunmap-test.py
+++ b/t/sgunmap-test.py
@@ -3,7 +3,7 @@
 #
 # sgunmap-test.py
 #
-# Limited functonality test for trim workloads using fio's sg ioengine
+# Limited functionality test for trim workloads using fio's sg ioengine
 # This checks only the three sets of reported iodepths
 #
 # !!!WARNING!!!
diff --git a/t/steadystate_tests.py b/t/steadystate_tests.py
index e8bd768c..d6ffd177 100755
--- a/t/steadystate_tests.py
+++ b/t/steadystate_tests.py
@@ -2,7 +2,7 @@
 #
 # steadystate_tests.py
 #
-# Test option parsing and functonality for fio's steady state detection feature.
+# Test option parsing and functionality for fio's steady state detection feature.
 #
 # steadystate_tests.py --read file-for-read-testing --write file-for-write-testing ./fio
 #
diff --git a/t/time-test.c b/t/time-test.c
index a74d9206..3c87d4d4 100644
--- a/t/time-test.c
+++ b/t/time-test.c
@@ -67,7 +67,7 @@
  *	accuracy because the (ticks * clock_mult) product used for final
  *	fractional chunk
  *
- *  iv) 64-bit arithmetic with the clock ticks to nsec conversion occuring in
+ *  iv) 64-bit arithmetic with the clock ticks to nsec conversion occurring in
  *	two stages. This is carried out using locks to update the number of
  *	large time chunks (MAX_CLOCK_SEC_2STAGE) that have elapsed.
  *
diff --git a/tools/fio_jsonplus_clat2csv b/tools/fio_jsonplus_clat2csv
index 7f310fcc..8fdd014d 100755
--- a/tools/fio_jsonplus_clat2csv
+++ b/tools/fio_jsonplus_clat2csv
@@ -135,7 +135,7 @@ def more_bins(indices, bins):
 
     Returns:
         True if the indices do not yet point to the end of each bin in bins.
-        False if the indices point beyond their repsective bins.
+        False if the indices point beyond their respective bins.
     """
 
     for key, value in six.iteritems(indices):
@@ -160,7 +160,7 @@ def debug_print(debug, *args):
 def get_csvfile(dest, jobnum):
     """Generate CSV filename from command-line arguments and job numbers.
 
-    Paramaters:
+    Parameters:
         dest        file specification for CSV filename.
         jobnum      job number.
 
diff --git a/tools/fiograph/fiograph.py b/tools/fiograph/fiograph.py
index b5669a2d..384decda 100755
--- a/tools/fiograph/fiograph.py
+++ b/tools/fiograph/fiograph.py
@@ -218,7 +218,7 @@ def fio_to_graphviz(filename, format):
     # The first job will be a new execution group
     new_execution_group = True
 
-    # Let's interate on all sections to create links between them
+    # Let's iterate on all sections to create links between them
     for section_name in fio_file.sections():
         # The current section
         section = fio_file[section_name]
diff --git a/tools/genfio b/tools/genfio
index 8518bbcc..8a2c73e8 100755
--- a/tools/genfio
+++ b/tools/genfio
@@ -48,7 +48,7 @@ show_help() {
 					one test after another then one disk after another
 					Disabled by default
 -p				: Run parallel test
-					one test after anoter but all disks at the same time
+					one test after another but all disks at the same time
 					Enabled by default
 -D iodepth			: Run with the specified iodepth
 					Default is $IODEPTH
diff --git a/tools/hist/fio-histo-log-pctiles.py b/tools/hist/fio-histo-log-pctiles.py
index 08e7722d..b5d167de 100755
--- a/tools/hist/fio-histo-log-pctiles.py
+++ b/tools/hist/fio-histo-log-pctiles.py
@@ -748,7 +748,7 @@ if unittest2_imported:
     def test_e2_get_pctiles_highest_pct(self):
         fio_v3_bucket_count = 29 * 64
         with open(self.fn, 'w') as f:
-            # make a empty fio v3 histogram
+            # make an empty fio v3 histogram
             buckets = [ 0 for j in range(0, fio_v3_bucket_count) ]
             # add one I/O request to last bucket
             buckets[-1] = 1
diff --git a/tools/plot/fio2gnuplot.manpage b/tools/plot/fio2gnuplot.manpage
index 6a12cf81..be3f13c2 100644
--- a/tools/plot/fio2gnuplot.manpage
+++ b/tools/plot/fio2gnuplot.manpage
@@ -20,7 +20,7 @@ DESCRIPTION
                     	The resulting graph helps at understanding trends.
 
  Grouped 2D graph   
-	All files are plotted in a single image to ease the comparaison. The same rendering options as per the individual 2D graph are used :
+	All files are plotted in a single image to ease the comparison. The same rendering options as per the individual 2D graph are used :
          - raw
          - smooth
          - trend
-- 
2.25.1

