Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:51941 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753011AbdEDMAO (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 4 May 2017 08:00:14 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1d6FQb-0005K3-Ki
        for fio@vger.kernel.org; Thu, 04 May 2017 12:00:13 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170504120001.CCB4C2C170E@kernel.dk>
Date: Thu,  4 May 2017 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit d418fa90f6daf75bb9336182f79c0b25aa6feecd:

  configure: Add missing $val != "yes" test to override compile_prog() result (2017-05-01 14:47:16 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f52e919826839eaba90903b67fe02042159a0023:

  gettime: make utime_since_now and mtime_since_now consistent in how they record the caller and put this all behind FIO_DEBUG_TIME (2017-05-03 08:49:37 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'wip-remove-disconnect' of https://github.com/liupan1111/fio

Pan Liu (2):
      remove out-of-date comment
      remove redundant _fio_rbd_disconnect, which is already called in     fio_rbd_cleaup

Vincent Fu (5):
      stat: change json+ output format so that instead of printing the raw clat data structure, use actual durations instead of array indices and print only bins with nonzero counts
      Revert "tools/fio_latency2csv.py: add tool that converts json+ to CSV"
      stat: reset_io_stats: fix a problem, rearrange some code
      client/server: make sure that all elements in io_u_lat_m[] are transferred and received
      gettime: make utime_since_now and mtime_since_now consistent in how they record the caller and put this all behind FIO_DEBUG_TIME

 Makefile                 |   2 +-
 client.c                 |   4 +-
 engines/rbd.c            |   9 +----
 gettime.c                |  11 ++++++
 server.c                 |   4 +-
 stat.c                   |  28 ++++++-------
 tools/fio_latency2csv.py | 101 -----------------------------------------------
 7 files changed, 32 insertions(+), 127 deletions(-)
 delete mode 100755 tools/fio_latency2csv.py

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 66083ff..1f0f5d0 100644
--- a/Makefile
+++ b/Makefile
@@ -26,7 +26,7 @@ OPTFLAGS= -g -ffast-math
 CFLAGS	= -std=gnu99 -Wwrite-strings -Wall -Wdeclaration-after-statement $(OPTFLAGS) $(EXTFLAGS) $(BUILD_CFLAGS) -I. -I$(SRCDIR)
 LIBS	+= -lm $(EXTLIBS)
 PROGS	= fio
-SCRIPTS = $(addprefix $(SRCDIR)/,tools/fio_generate_plots tools/plot/fio2gnuplot tools/genfio tools/fiologparser.py tools/fio_latency2csv.py tools/hist/fiologparser_hist.py)
+SCRIPTS = $(addprefix $(SRCDIR)/,tools/fio_generate_plots tools/plot/fio2gnuplot tools/genfio tools/fiologparser.py tools/hist/fiologparser_hist.py)
 
 ifndef CONFIG_FIO_NO_OPT
   CFLAGS += -O3 -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2
diff --git a/client.c b/client.c
index 7934661..80096bf 100644
--- a/client.c
+++ b/client.c
@@ -908,10 +908,10 @@ static void convert_ts(struct thread_stat *dst, struct thread_stat *src)
 		dst->io_u_complete[i]	= le32_to_cpu(src->io_u_complete[i]);
 	}
 
-	for (i = 0; i < FIO_IO_U_LAT_U_NR; i++) {
+	for (i = 0; i < FIO_IO_U_LAT_U_NR; i++)
 		dst->io_u_lat_u[i]	= le32_to_cpu(src->io_u_lat_u[i]);
+	for (i = 0; i < FIO_IO_U_LAT_M_NR; i++)
 		dst->io_u_lat_m[i]	= le32_to_cpu(src->io_u_lat_m[i]);
-	}
 
 	for (i = 0; i < DDIR_RWDIR_CNT; i++)
 		for (j = 0; j < FIO_IO_U_PLAT_NR; j++)
diff --git a/engines/rbd.c b/engines/rbd.c
index 7433879..4bae425 100644
--- a/engines/rbd.c
+++ b/engines/rbd.c
@@ -597,11 +597,11 @@ static int fio_rbd_setup(struct thread_data *td)
 	r = rbd_stat(rbd->image, &info, sizeof(info));
 	if (r < 0) {
 		log_err("rbd_status failed.\n");
-		goto disconnect;
+		goto cleanup;
 	} else if (info.size == 0) {
 		log_err("image size should be larger than zero.\n");
 		r = -EINVAL;
-		goto disconnect;
+		goto cleanup;
 	}
 
 	dprint(FD_IO, "rbd-engine: image size: %lu\n", info.size);
@@ -618,13 +618,8 @@ static int fio_rbd_setup(struct thread_data *td)
 	f = td->files[0];
 	f->real_file_size = info.size;
 
-	/* disconnect, then we were only connected to determine
-	 * the size of the RBD.
-	 */
 	return 0;
 
-disconnect:
-	_fio_rbd_disconnect(rbd);
 cleanup:
 	fio_rbd_cleanup(td);
 	return r;
diff --git a/gettime.c b/gettime.c
index 85ba7cb..628aad6 100644
--- a/gettime.c
+++ b/gettime.c
@@ -402,8 +402,14 @@ uint64_t utime_since(const struct timeval *s, const struct timeval *e)
 uint64_t utime_since_now(const struct timeval *s)
 {
 	struct timeval t;
+#ifdef FIO_DEBUG_TIME
+	void *p = __builtin_return_address(0);
 
+	fio_gettime(&t, p);
+#else
 	fio_gettime(&t, NULL);
+#endif
+
 	return utime_since(s, &t);
 }
 
@@ -429,9 +435,14 @@ uint64_t mtime_since(const struct timeval *s, const struct timeval *e)
 uint64_t mtime_since_now(const struct timeval *s)
 {
 	struct timeval t;
+#ifdef FIO_DEBUG_TIME
 	void *p = __builtin_return_address(0);
 
 	fio_gettime(&t, p);
+#else
+	fio_gettime(&t, NULL);
+#endif
+
 	return mtime_since(s, &t);
 }
 
diff --git a/server.c b/server.c
index 1b3bc30..1e269c2 100644
--- a/server.c
+++ b/server.c
@@ -1497,10 +1497,10 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
 		p.ts.io_u_complete[i]	= cpu_to_le32(ts->io_u_complete[i]);
 	}
 
-	for (i = 0; i < FIO_IO_U_LAT_U_NR; i++) {
+	for (i = 0; i < FIO_IO_U_LAT_U_NR; i++)
 		p.ts.io_u_lat_u[i]	= cpu_to_le32(ts->io_u_lat_u[i]);
+	for (i = 0; i < FIO_IO_U_LAT_M_NR; i++)
 		p.ts.io_u_lat_m[i]	= cpu_to_le32(ts->io_u_lat_m[i]);
-	}
 
 	for (i = 0; i < DDIR_RWDIR_CNT; i++)
 		for (j = 0; j < FIO_IO_U_PLAT_NR; j++)
diff --git a/stat.c b/stat.c
index f3b82cf..6e47c34 100644
--- a/stat.c
+++ b/stat.c
@@ -98,7 +98,7 @@ static unsigned int plat_val_to_idx(unsigned int val)
  * Convert the given index of the bucket array to the value
  * represented by the bucket
  */
-static unsigned int plat_idx_to_val(unsigned int idx)
+static unsigned long long plat_idx_to_val(unsigned int idx)
 {
 	unsigned int error_bits, k, base;
 
@@ -972,12 +972,11 @@ static void add_ddir_status_json(struct thread_stat *ts,
 		clat_bins_object = json_create_object();
 		json_object_add_value_object(tmp_object, "bins", clat_bins_object);
 		for(i = 0; i < FIO_IO_U_PLAT_NR; i++) {
-			snprintf(buf, sizeof(buf), "%d", i);
-			json_object_add_value_int(clat_bins_object, (const char *)buf, ts->io_u_plat[ddir][i]);
+			if (ts->io_u_plat[ddir][i]) {
+				snprintf(buf, sizeof(buf), "%llu", plat_idx_to_val(i));
+				json_object_add_value_int(clat_bins_object, (const char *)buf, ts->io_u_plat[ddir][i]);
+			}
 		}
-		json_object_add_value_int(clat_bins_object, "FIO_IO_U_PLAT_BITS", FIO_IO_U_PLAT_BITS);
-		json_object_add_value_int(clat_bins_object, "FIO_IO_U_PLAT_VAL", FIO_IO_U_PLAT_VAL);
-		json_object_add_value_int(clat_bins_object, "FIO_IO_U_PLAT_NR", FIO_IO_U_PLAT_NR);
 	}
 
 	if (!calc_lat(&ts->lat_stat[ddir], &min, &max, &mean, &dev)) {
@@ -2172,6 +2171,9 @@ void reset_io_stats(struct thread_data *td)
 
 		ts->io_bytes[i] = 0;
 		ts->runtime[i] = 0;
+		ts->total_io_u[i] = 0;
+		ts->short_io_u[i] = 0;
+		ts->drop_io_u[i] = 0;
 
 		for (j = 0; j < FIO_IO_U_PLAT_NR; j++)
 			ts->io_u_plat[i][j] = 0;
@@ -2181,17 +2183,15 @@ void reset_io_stats(struct thread_data *td)
 		ts->io_u_map[i] = 0;
 		ts->io_u_submit[i] = 0;
 		ts->io_u_complete[i] = 0;
+	}
+
+	for (i = 0; i < FIO_IO_U_LAT_U_NR; i++)
 		ts->io_u_lat_u[i] = 0;
+	for (i = 0; i < FIO_IO_U_LAT_M_NR; i++)
 		ts->io_u_lat_m[i] = 0;
-		ts->total_submit = 0;
-		ts->total_complete = 0;
-	}
 
-	for (i = 0; i < 3; i++) {
-		ts->total_io_u[i] = 0;
-		ts->short_io_u[i] = 0;
-		ts->drop_io_u[i] = 0;
-	}
+	ts->total_submit = 0;
+	ts->total_complete = 0;
 }
 
 static void __add_stat_to_log(struct io_log *iolog, enum fio_ddir ddir,
diff --git a/tools/fio_latency2csv.py b/tools/fio_latency2csv.py
deleted file mode 100755
index 93586d2..0000000
--- a/tools/fio_latency2csv.py
+++ /dev/null
@@ -1,101 +0,0 @@
-#!/usr/bin/python
-#
-# fio_latency2csv.py
-#
-# This tool converts fio's json+ completion latency data to CSV format.
-# For example:
-#
-# fio_latency2csv.py fio-jsonplus.output fio-latency.csv
-#
-
-import os
-import json
-import argparse
-
-
-def parse_args():
-    parser = argparse.ArgumentParser()
-    parser.add_argument('source',
-                        help='fio json+ output file containing completion '
-                             'latency data')
-    parser.add_argument('dest',
-                        help='destination file stub for latency data in CSV '
-                             'format. job number will be appended to filename')
-    args = parser.parse_args()
-
-    return args
-
-
-# from stat.c
-def plat_idx_to_val(idx, FIO_IO_U_PLAT_BITS=6, FIO_IO_U_PLAT_VAL=64):
-    # MSB <= (FIO_IO_U_PLAT_BITS-1), cannot be rounded off. Use
-    # all bits of the sample as index
-    if (idx < (FIO_IO_U_PLAT_VAL << 1)):
-        return idx
-
-    # Find the group and compute the minimum value of that group
-    error_bits = (idx >> FIO_IO_U_PLAT_BITS) - 1
-    base = 1 << (error_bits + FIO_IO_U_PLAT_BITS)
-
-    # Find its bucket number of the group
-    k = idx % FIO_IO_U_PLAT_VAL
-
-    # Return the mean of the range of the bucket
-    return (base + ((k + 0.5) * (1 << error_bits)))
-
-
-def percentile(idx, run_total):
-    total = run_total[len(run_total)-1]
-    if total == 0:
-        return 0
-
-    return float(run_total[x]) / total
-
-
-if __name__ == '__main__':
-    args = parse_args()
-
-    with open(args.source, 'r') as source:
-        jsondata = json.loads(source.read())
-
-    bins = {}
-    bin_const = {}
-    run_total = {}
-    ddir_list = ['read', 'write', 'trim']
-    const_list = ['FIO_IO_U_PLAT_NR', 'FIO_IO_U_PLAT_BITS',
-                  'FIO_IO_U_PLAT_VAL']
-
-    for jobnum in range(0,len(jsondata['jobs'])):
-        prev_ddir = None
-        for ddir in ddir_list:
-            bins[ddir] = jsondata['jobs'][jobnum][ddir]['clat']['bins']
-
-            bin_const[ddir] = {}
-            for const in const_list:
-                bin_const[ddir][const] = bins[ddir].pop(const)
-                if prev_ddir:
-                    assert bin_const[ddir][const] == bin_const[prev_ddir][const]
-            prev_ddir = ddir
-
-            run_total[ddir] = [0 for x in
-                               range(bin_const[ddir]['FIO_IO_U_PLAT_NR'])]
-            run_total[ddir][0] = bins[ddir]['0']
-            for x in range(1, bin_const[ddir]['FIO_IO_U_PLAT_NR']):
-                run_total[ddir][x] = run_total[ddir][x-1] + bins[ddir][str(x)]
-        
-        stub, ext = os.path.splitext(args.dest)
-        outfile = stub + '_job' + str(jobnum) + ext
-
-        with open(outfile, 'w') as output:
-            output.write("clat (usec),")
-            for ddir in ddir_list:
-                output.write("{0},".format(ddir))
-            output.write("\n")
-
-            for x in range(bin_const['read']['FIO_IO_U_PLAT_NR']):
-                output.write("{0},".format(plat_idx_to_val(x,
-                                          bin_const['read']['FIO_IO_U_PLAT_BITS'],
-                                          bin_const['read']['FIO_IO_U_PLAT_VAL'])))
-                for ddir in ddir_list:
-                    output.write("{0},".format(percentile(x, run_total[ddir])))
-                output.write("\n")
