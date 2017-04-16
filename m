Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: Vincent Fu <vincentfu@gmail.com>
Subject: [PATCH 2/6] Revert "tools/fio_latency2csv.py: add tool that converts json+ to CSV"
Date: Sun, 16 Apr 2017 15:04:24 -0400
Message-Id: <1492369468-29448-2-git-send-email-vincentfu@gmail.com>
In-Reply-To: <1492369468-29448-1-git-send-email-vincentfu@gmail.com>
References: <1492369468-29448-1-git-send-email-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <Vincent.Fu@sandisk.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <Vincent.Fu@sandisk.com>

This reverts commit 6cd4d583c75042bf1edd3d2d5c6626883755bfe4.
The script is no longer needed because the json+ output format now
automatically does the transformation carried out by the script.
---
 Makefile                 |   2 +-
 tools/fio_latency2csv.py | 101 -----------------------------------------------
 2 files changed, 1 insertion(+), 102 deletions(-)
 delete mode 100755 tools/fio_latency2csv.py

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
-- 
2.7.4


