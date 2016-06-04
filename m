Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:52848 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbcFDMAE (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 4 Jun 2016 08:00:04 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1b9AFH-0002Hz-EM
	for fio@vger.kernel.org; Sat, 04 Jun 2016 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160604120001.A740A2C00A3@kernel.dk>
Date: Sat,  4 Jun 2016 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 385e1da6468bc951a0bf7ae60d890bb4d4a55ded:

  Documentation update (2016-06-02 16:57:20 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 82e65aecd90a35171eb9930ba7b08d27fee95640:

  Documentation: fix psyncv2 typo (2016-06-03 09:00:49 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Documentation: fix psyncv2 typo

Vincent Fu (1):
      tools/fio_latency2csv.py: add tool that converts json+ to CSV

 HOWTO                    |   2 +-
 Makefile                 |   2 +-
 fio.1                    |   2 +-
 tools/fio_latency2csv.py | 101 +++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 104 insertions(+), 3 deletions(-)
 create mode 100755 tools/fio_latency2csv.py

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 1d4e46c..67fd833 100644
--- a/HOWTO
+++ b/HOWTO
@@ -708,7 +708,7 @@ ioengine=str	Defines how the job issues io to the file. The following
 
 			pvsync	Basic preadv(2) or pwritev(2) IO.
 
-			psync2	Basic preadv2(2) or pwritev2(2) IO.
+			pvsync2	Basic preadv2(2) or pwritev2(2) IO.
 
 			libaio	Linux native asynchronous io. Note that Linux
 				may only support queued behaviour with
diff --git a/Makefile b/Makefile
index 108e6ee..c617d6f 100644
--- a/Makefile
+++ b/Makefile
@@ -26,7 +26,7 @@ OPTFLAGS= -g -ffast-math
 CFLAGS	= -std=gnu99 -Wwrite-strings -Wall -Wdeclaration-after-statement $(OPTFLAGS) $(EXTFLAGS) $(BUILD_CFLAGS) -I. -I$(SRCDIR)
 LIBS	+= -lm $(EXTLIBS)
 PROGS	= fio
-SCRIPTS = $(addprefix $(SRCDIR)/,tools/fio_generate_plots tools/plot/fio2gnuplot tools/genfio tools/fiologparser.py)
+SCRIPTS = $(addprefix $(SRCDIR)/,tools/fio_generate_plots tools/plot/fio2gnuplot tools/genfio tools/fiologparser.py tools/fio_latency2csv.py)
 
 ifndef CONFIG_FIO_NO_OPT
   CFLAGS += -O3
diff --git a/fio.1 b/fio.1
index 7f053d4..353f8ff 100644
--- a/fio.1
+++ b/fio.1
@@ -1709,7 +1709,7 @@ from user-space to reap events. The reaping mode is only
 enabled when polling for a minimum of 0 events (eg when
 iodepth_batch_complete=0).
 .TP
-.BI (psyncv2)hipri
+.BI (pvsync2)hipri
 Set RWF_HIPRI on IO, indicating to the kernel that it's of
 higher priority than normal.
 .TP
diff --git a/tools/fio_latency2csv.py b/tools/fio_latency2csv.py
new file mode 100755
index 0000000..93586d2
--- /dev/null
+++ b/tools/fio_latency2csv.py
@@ -0,0 +1,101 @@
+#!/usr/bin/python
+#
+# fio_latency2csv.py
+#
+# This tool converts fio's json+ completion latency data to CSV format.
+# For example:
+#
+# fio_latency2csv.py fio-jsonplus.output fio-latency.csv
+#
+
+import os
+import json
+import argparse
+
+
+def parse_args():
+    parser = argparse.ArgumentParser()
+    parser.add_argument('source',
+                        help='fio json+ output file containing completion '
+                             'latency data')
+    parser.add_argument('dest',
+                        help='destination file stub for latency data in CSV '
+                             'format. job number will be appended to filename')
+    args = parser.parse_args()
+
+    return args
+
+
+# from stat.c
+def plat_idx_to_val(idx, FIO_IO_U_PLAT_BITS=6, FIO_IO_U_PLAT_VAL=64):
+    # MSB <= (FIO_IO_U_PLAT_BITS-1), cannot be rounded off. Use
+    # all bits of the sample as index
+    if (idx < (FIO_IO_U_PLAT_VAL << 1)):
+        return idx
+
+    # Find the group and compute the minimum value of that group
+    error_bits = (idx >> FIO_IO_U_PLAT_BITS) - 1
+    base = 1 << (error_bits + FIO_IO_U_PLAT_BITS)
+
+    # Find its bucket number of the group
+    k = idx % FIO_IO_U_PLAT_VAL
+
+    # Return the mean of the range of the bucket
+    return (base + ((k + 0.5) * (1 << error_bits)))
+
+
+def percentile(idx, run_total):
+    total = run_total[len(run_total)-1]
+    if total == 0:
+        return 0
+
+    return float(run_total[x]) / total
+
+
+if __name__ == '__main__':
+    args = parse_args()
+
+    with open(args.source, 'r') as source:
+        jsondata = json.loads(source.read())
+
+    bins = {}
+    bin_const = {}
+    run_total = {}
+    ddir_list = ['read', 'write', 'trim']
+    const_list = ['FIO_IO_U_PLAT_NR', 'FIO_IO_U_PLAT_BITS',
+                  'FIO_IO_U_PLAT_VAL']
+
+    for jobnum in range(0,len(jsondata['jobs'])):
+        prev_ddir = None
+        for ddir in ddir_list:
+            bins[ddir] = jsondata['jobs'][jobnum][ddir]['clat']['bins']
+
+            bin_const[ddir] = {}
+            for const in const_list:
+                bin_const[ddir][const] = bins[ddir].pop(const)
+                if prev_ddir:
+                    assert bin_const[ddir][const] == bin_const[prev_ddir][const]
+            prev_ddir = ddir
+
+            run_total[ddir] = [0 for x in
+                               range(bin_const[ddir]['FIO_IO_U_PLAT_NR'])]
+            run_total[ddir][0] = bins[ddir]['0']
+            for x in range(1, bin_const[ddir]['FIO_IO_U_PLAT_NR']):
+                run_total[ddir][x] = run_total[ddir][x-1] + bins[ddir][str(x)]
+        
+        stub, ext = os.path.splitext(args.dest)
+        outfile = stub + '_job' + str(jobnum) + ext
+
+        with open(outfile, 'w') as output:
+            output.write("clat (usec),")
+            for ddir in ddir_list:
+                output.write("{0},".format(ddir))
+            output.write("\n")
+
+            for x in range(bin_const['read']['FIO_IO_U_PLAT_NR']):
+                output.write("{0},".format(plat_idx_to_val(x,
+                                          bin_const['read']['FIO_IO_U_PLAT_BITS'],
+                                          bin_const['read']['FIO_IO_U_PLAT_VAL'])))
+                for ddir in ddir_list:
+                    output.write("{0},".format(percentile(x, run_total[ddir])))
+                output.write("\n")
