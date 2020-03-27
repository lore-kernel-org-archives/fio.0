Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:46370 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgC0MAQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 27 Mar 2020 08:00:16 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jHnep-0008Vw-QE
        for fio@vger.kernel.org; Fri, 27 Mar 2020 12:00:15 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200327120001.CD4DD1BC0187@kernel.dk>
Date: Fri, 27 Mar 2020 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 3bd2078bdd1c173f9d02bc20e2d630302555a8a0:

  zbd: add test for stressing zone locking (2020-03-17 20:05:54 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 983319d02626347d178b34320ac5835ae7ecad02:

  Merge branch 'jsonplus2csv' of https://github.com/vincentkfu/fio (2020-03-26 09:03:40 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'jsonplus2csv' of https://github.com/vincentkfu/fio

Vincent Fu (3):
      tools/fio_jsonplus2csv: accommodate multiple lat measurements
      t/jsonplus2csv_test.py: test script for tools/fio_jsonplus_clat2csv
      .travis.yml: remove pip line from xcode11.2 config

 .appveyor.yml               |   2 +-
 .travis.yml                 |   3 +-
 t/jsonplus2csv_test.py      | 150 ++++++++++++++++++
 t/run-fio-tests.py          |   8 +
 tools/fio_jsonplus_clat2csv | 379 +++++++++++++++++++++++++++++++-------------
 5 files changed, 428 insertions(+), 114 deletions(-)
 create mode 100755 t/jsonplus2csv_test.py

---

Diff of recent changes:

diff --git a/.appveyor.yml b/.appveyor.yml
index bf0978ad..2f962c4b 100644
--- a/.appveyor.yml
+++ b/.appveyor.yml
@@ -15,7 +15,7 @@ environment:
 install:
   - '%CYG_ROOT%\setup-x86_64.exe --quiet-mode --no-shortcuts --only-site --site "%CYG_MIRROR%" --packages "mingw64-%PACKAGE_ARCH%-zlib,mingw64-%PACKAGE_ARCH%-CUnit" > NUL'
   - SET PATH=C:\Python38-x64;%CYG_ROOT%\bin;%PATH% # NB: Changed env variables persist to later sections
-  - python.exe -m pip install scipy
+  - python.exe -m pip install scipy six
 
 build_script:
   - 'bash.exe -lc "cd \"${APPVEYOR_BUILD_FOLDER}\" && ./configure --disable-native --extra-cflags=\"-Werror\" ${CONFIGURE_OPTIONS} && make.exe'
diff --git a/.travis.yml b/.travis.yml
index 77c31b77..6b710cc3 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -48,8 +48,9 @@ before_install:
         brew install cunit;
         if [[ "$TRAVIS_OSX_IMAGE" == "xcode11.2" ]]; then
             pip3 install scipy;
+        else
+            pip install scipy;
         fi;
-        pip install scipy;
     fi;
 script:
   - ./configure --extra-cflags="${EXTRA_CFLAGS}" && make
diff --git a/t/jsonplus2csv_test.py b/t/jsonplus2csv_test.py
new file mode 100755
index 00000000..2b34ef25
--- /dev/null
+++ b/t/jsonplus2csv_test.py
@@ -0,0 +1,150 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Copyright (c) 2020 Western Digital Corporation or its affiliates.
+#
+"""
+jsonplus2csv-test.py
+
+Do one basic test of tools/fio_jsonplus2csv
+
+USAGE
+python jsonplus2csv-test.py [-f fio-executable] [-s script-location]
+
+EXAMPLES
+python t/jsonplus2csv-test.py
+python t/jsonplus2csv-test.py -f ./fio -s tools
+
+REQUIREMENTS
+Python 3.5+
+"""
+
+import os
+import sys
+import platform
+import argparse
+import subprocess
+
+
+def parse_args():
+    """Parse command-line arguments."""
+
+    parser = argparse.ArgumentParser()
+    parser.add_argument('-f', '--fio',
+                        help='path to fio executable (e.g., ./fio)')
+    parser.add_argument('-s', '--script',
+                        help='directory containing fio_jsonplus2csv script')
+    return parser.parse_args()
+
+
+def run_fio(fio):
+    """Run fio to generate json+ data.
+
+    Parameters:
+        fio     path to fio executable.
+    """
+
+    if platform.system() == 'Linux':
+        aio = 'libaio'
+    elif platform.system() == 'Windows':
+        aio = 'windowsaio'
+    else:
+        aio = 'posixaio'
+
+    fio_args = [
+        "--output=fio-output.json",
+        "--output-format=json+",
+        "--filename=fio_jsonplus_clat2csv.test",
+        "--ioengine=" + aio,
+        "--time_based",
+        "--runtime=3s",
+        "--size=1G",
+        "--slat_percentiles=1",
+        "--clat_percentiles=1",
+        "--lat_percentiles=1",
+        "--thread=1",
+        "--name=test1",
+        "--rw=randrw",
+        "--name=test2",
+        "--rw=read",
+        "--name=test3",
+        "--rw=write",
+        ]
+
+    output = subprocess.run([fio] + fio_args, stdout=subprocess.PIPE,
+                            stderr=subprocess.PIPE)
+
+    return output
+
+
+def check_output(fio_output, script_path):
+    """Run t/fio_jsonplus_clat2csv and validate the generated CSV files
+    against the original json+ fio output.
+
+    Parameters:
+        fio_output      subprocess.run object describing fio run.
+        script_path     path to fio_jsonplus_clat2csv script.
+    """
+
+    if fio_output.returncode != 0:
+        return False
+
+    if platform.system() == 'Windows':
+        script = ['python.exe', script_path]
+    else:
+        script = [script_path]
+
+    script_args = ["fio-output.json", "fio-output.csv"]
+    script_args_validate = script_args + ["--validate"]
+
+    script_output = subprocess.run(script + script_args)
+    if script_output.returncode != 0:
+        return False
+
+    script_output = subprocess.run(script + script_args_validate)
+    if script_output.returncode != 0:
+        return False
+
+    return True
+
+
+def main():
+    """Entry point for this script."""
+
+    args = parse_args()
+
+    index = 1
+    passed = 0
+    failed = 0
+
+    if args.fio:
+        fio_path = args.fio
+    else:
+        fio_path = os.path.join(os.path.dirname(__file__), '../fio')
+        if not os.path.exists(fio_path):
+            fio_path = 'fio'
+    print("fio path is", fio_path)
+
+    if args.script:
+        script_path = args.script
+    else:
+        script_path = os.path.join(os.path.dirname(__file__), '../tools/fio_jsonplus_clat2csv')
+        if not os.path.exists(script_path):
+            script_path = 'fio_jsonplus_clat2csv'
+    print("script path is", script_path)
+
+    fio_output = run_fio(fio_path)
+    status = check_output(fio_output, script_path)
+    print("Test {0} {1}".format(index, ("PASSED" if status else "FAILED")))
+    if status:
+        passed = passed + 1
+    else:
+        failed = failed + 1
+    index = index + 1
+
+    print("{0} tests passed, {1} failed".format(passed, failed))
+
+    sys.exit(failed)
+
+if __name__ == '__main__':
+    main()
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index 36fcb2f4..ea5abc4e 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -757,6 +757,14 @@ TEST_LIST = [
         'success':          SUCCESS_DEFAULT,
         'requirements':     [],
     },
+    {
+        'test_id':          1011,
+        'test_class':       FioExeTest,
+        'exe':              't/jsonplus2csv_test.py',
+        'parameters':       ['-f', '{fio_path}'],
+        'success':          SUCCESS_DEFAULT,
+        'requirements':     [],
+    },
 ]
 
 
diff --git a/tools/fio_jsonplus_clat2csv b/tools/fio_jsonplus_clat2csv
index 78a007e5..9544ab74 100755
--- a/tools/fio_jsonplus_clat2csv
+++ b/tools/fio_jsonplus_clat2csv
@@ -1,76 +1,97 @@
 #!/usr/bin/python2.7
 # Note: this script is python2 and python3 compatible.
-#
-# fio_jsonplus_clat2csv
-#
-# This script converts fio's json+ completion latency data to CSV format.
-#
-# For example:
-#
-# Run the following fio jobs:
-# ../fio --output=fio-jsonplus.output --output-format=json+ --name=test1
-#  	--ioengine=null --time_based --runtime=5s --size=1G --rw=randrw
-# 	--name=test2 --ioengine=null --time_based --runtime=3s --size=1G
-# 	--rw=read --name=test3 --ioengine=null --time_based --runtime=4s
-# 	--size=8G --rw=write
-#
-# Then run:
-# fio_jsonplus_clat2csv fio-jsonplus.output fio-latency.csv
-#
-# You will end up with the following 3 files
-#
-# -rw-r--r-- 1 root root  6467 Jun 27 14:57 fio-latency_job0.csv
-# -rw-r--r-- 1 root root  3985 Jun 27 14:57 fio-latency_job1.csv
-# -rw-r--r-- 1 root root  4490 Jun 27 14:57 fio-latency_job2.csv
-#
-# fio-latency_job0.csv will look something like:
-#
-# clat_nsec, read_count, read_cumulative, read_percentile, write_count,
-# 	write_cumulative, write_percentile, trim_count, trim_cumulative,
-# 	trim_percentile,
-# 25, 1, 1, 1.50870705013e-07, , , , , , ,
-# 26, 12, 13, 1.96131916517e-06, 947, 947, 0.000142955890032, , , ,
-# 27, 843677, 843690, 0.127288105112, 838347, 839294, 0.126696959629, , , ,
-# 28, 1877982, 2721672, 0.410620573454, 1870189, 2709483, 0.409014312345, , , ,
-# 29, 4471, 2726143, 0.411295116376, 7718, 2717201, 0.410179395301, , , ,
-# 30, 2142885, 4869028, 0.734593687087, 2138164, 4855365, 0.732949340025, , , ,
-# ...
-# 2544, , , , 2, 6624404, 0.999997433738, , , ,
-# 2576, 3, 6628178, 0.99999788781, 4, 6624408, 0.999998037564, , , ,
-# 2608, 4, 6628182, 0.999998491293, 4, 6624412, 0.999998641391, , , ,
-# 2640, 3, 6628185, 0.999998943905, 2, 6624414, 0.999998943304, , , ,
-# 2672, 1, 6628186, 0.999999094776, 3, 6624417, 0.999999396174, , , ,
-# 2736, 1, 6628187, 0.999999245646, 1, 6624418, 0.99999954713, , , ,
-# 2768, 2, 6628189, 0.999999547388, 1, 6624419, 0.999999698087, , , ,
-# 2800, , , , 1, 6624420, 0.999999849043, , , ,
-# 2832, 1, 6628190, 0.999999698259, , , , , , ,
-# 4192, 1, 6628191, 0.999999849129, , , , , , ,
-# 5792, , , , 1, 6624421, 1.0, , , ,
-# 10304, 1, 6628192, 1.0, , , , , , ,
-#
-# The first line says that you had one read IO with 25ns clat,
-# the cumulative number of read IOs at or below 25ns is 1, and
-# 25ns is the 0.00001509th percentile for read latency
-#
-# The job had 2 write IOs complete in 2544ns,
-# 6624404 write IOs completed in 2544ns or less,
-# and this represents the 99.99974th percentile for write latency
-#
-# The last line says that one read IO had 10304ns clat,
-# 6628192 read IOs had 10304ns or shorter clat, and
-# 10304ns is the 100th percentile for read latency
-#
+
+"""
+fio_jsonplus_clat2csv
+
+This script converts fio's json+ latency data to CSV format.
+
+For example:
+
+Run the following fio jobs:
+$ fio --output=fio-jsonplus.output --output-format=json+ --ioengine=null \
+    --time_based --runtime=3s --size=1G --slat_percentiles=1 \
+    --clat_percentiles=1 --lat_percentiles=1 \
+    --name=test1 --rw=randrw \
+    --name=test2 --rw=read \
+    --name=test3 --rw=write
+
+Then run:
+$ fio_jsonplus_clat2csv fio-jsonplus.output fio-jsonplus.csv
+
+You will end up with the following 3 files:
+
+-rw-r--r-- 1 root root 77547 Mar 24 15:17 fio-jsonplus_job0.csv
+-rw-r--r-- 1 root root 65413 Mar 24 15:17 fio-jsonplus_job1.csv
+-rw-r--r-- 1 root root 63291 Mar 24 15:17 fio-jsonplus_job2.csv
+
+fio-jsonplus_job0.csv will look something like:
+
+nsec, read_slat_ns_count, read_slat_ns_cumulative, read_slat_ns_percentile, read_clat_ns_count, read_clat_ns_cumulative, read_clat_ns_percentile, read_lat_ns_count, read_lat_ns_cumulative, read_lat_ns_percentile, write_slat_ns_count, write_slat_ns_cumulative, write_slat_ns_percentile, write_clat_ns_count, write_clat_ns_cumulative, write_clat_ns_percentile, write_lat_ns_count, write_lat_ns_cumulative, write_lat_ns_percentile, trim_slat_ns_count, trim_slat_ns_cumulative, trim_slat_ns_percentile, trim_clat_ns_count, trim_clat_ns_cumulative, trim_clat_ns_percentile, trim_lat_ns_count, trim_lat_ns_cumulative, trim_lat_ns_percentile,
+12, , , , 3, 3, 6.11006798673e-07, , , , , , , 2, 2, 4.07580840603e-07, , , , , , , , , , , , ,
+13, , , , 1364, 1367, 0.000278415431262, , , , , , , 1776, 1778, 0.000362339367296, , , , , , , , , , , , ,
+14, , , , 181872, 183239, 0.037320091594, , , , , , , 207436, 209214, 0.0426358089929, , , , , , , , , , , , ,
+15, , , , 1574811, 1758050, 0.358060167469, , , , , , , 1661435, 1870649, 0.381220345946, , , , , , , , , , , , ,
+16, , , , 2198478, 3956528, 0.805821835713, , , , , , , 2154571, 4025220, 0.820301275606, , , , , , , , , , , , ,
+17, , , , 724335, 4680863, 0.953346372218, , , , , , , 645351, 4670571, 0.951817627138, , , , , , , , , , , , ,
+18, , , , 71837, 4752700, 0.96797733735, , , , , , , 61084, 4731655, 0.964265961171, , , , , , , , , , , , ,
+19, , , , 15915, 4768615, 0.971218728417, , , , , , , 18419, 4750074, 0.968019576923, , , , , , , , , , , , ,
+20, , , , 12651, 4781266, 0.973795344087, , , , , , , 14176, 4764250, 0.970908509921, , , , , , , , , , , , ,
+...
+168960, , , , , , , , , , , , , 1, 4906999, 0.999999388629, 1, 4906997, 0.999998981048, , , , , , , , , ,
+177152, , , , , , , , , , , , , 1, 4907000, 0.999999592419, 1, 4906998, 0.999999184838, , , , , , , , , ,
+183296, , , , , , , , , , , , , 1, 4907001, 0.99999979621, 1, 4906999, 0.999999388629, , , , , , , , , ,
+189440, , , , , , , 1, 4909925, 0.999999185324, , , , , , , , , , , , , , , , , , ,
+214016, , , , 1, 4909928, 0.999999796331, 2, 4909927, 0.999999592662, , , , , , , , , , , , , , , , , , ,
+246784, , , , , , , , , , , , , , , , 1, 4907000, 0.999999592419, , , , , , , , , ,
+272384, , , , 1, 4909929, 1.0, 1, 4909928, 0.999999796331, , , , , , , , , , , , , , , , , , ,
+329728, , , , , , , , , , , , , 1, 4907002, 1.0, 1, 4907001, 0.99999979621, , , , , , , , , ,
+1003520, , , , , , , , , , , , , , , , 1, 4907002, 1.0, , , , , , , , , ,
+1089536, , , , , , , 1, 4909929, 1.0, , , , , , , , , , , , , , , , , , ,
+
+The first line says that there were three read IOs with 12ns clat,
+the cumulative number of read IOs at or below 12ns was two, and
+12ns was the 0.0000611th percentile for read latency. There were
+two write IOs with 12ns clat, the cumulative number of write IOs
+at or below 12ns was two, and 12ns was the 0.0000408th percentile
+for write latency.
+
+The job had one write IO complete at 168960ns and 4906999 write IOs
+completed at or below this duration. Also this duration was the
+99.99994th percentile for write latency. There was one write IO
+with a total latency of 168960ns, this duration had a cumulative
+frequency of 4906997 write IOs and was the 99.9998981048th percentile
+for write total latency.
+
+The last line says that one read IO had 1089536ns total latency, this
+duration had a cumulative frequency of 4909929 and represented the 100th
+percentile for read total latency.
+
+Running the following:
+
+$ fio_jsonplus_clat2csv fio-jsonplus.output fio-jsonplus.csv --validate
+fio-jsonplus_job0.csv validated
+fio-jsonplus_job1.csv validated
+fio-jsonplus_job2.csv validated
+
+will check the CSV data against the json+ output to confirm that the CSV
+data matches.
+"""
 
 from __future__ import absolute_import
 from __future__ import print_function
 import os
 import json
 import argparse
+import itertools
 import six
-from six.moves import range
 
+DDIR_LIST = ['read', 'write', 'trim']
+LAT_LIST = ['slat_ns', 'clat_ns', 'lat_ns']
 
 def parse_args():
+    """Parse command-line arguments."""
+
     parser = argparse.ArgumentParser()
     parser.add_argument('source',
                         help='fio json+ output file containing completion '
@@ -78,12 +99,26 @@ def parse_args():
     parser.add_argument('dest',
                         help='destination file stub for latency data in CSV '
                              'format. job number will be appended to filename')
+    parser.add_argument('--debug', '-d', action='store_true',
+                        help='enable debug prints')
+    parser.add_argument('--validate', action='store_true',
+                        help='validate CSV against JSON output')
     args = parser.parse_args()
 
     return args
 
 
 def percentile(idx, run_total):
+    """Return a percentile for a specified index based on a running total.
+
+    Parameters:
+        idx         index for which to generate percentile.
+        run_total   list of cumulative sums.
+
+    Returns:
+        Percentile represented by the specified index.
+    """
+
     total = run_total[len(run_total)-1]
     if total == 0:
         return 0
@@ -91,7 +126,18 @@ def percentile(idx, run_total):
     return float(run_total[idx]) / total
 
 
-def more_lines(indices, bins):
+def more_bins(indices, bins):
+    """Determine whether we have more bins to process.
+
+    Parameters:
+        indices     a dict containing the last index processed in each bin.
+        bins        a dict contaiing a set of bins to process.
+
+    Returns:
+        True if the indices do not yet point to the end of each bin in bins.
+        False if the indices point beyond their repsective bins.
+    """
+
     for key, value in six.iteritems(indices):
         if value < len(bins[key]):
             return True
@@ -99,78 +145,187 @@ def more_lines(indices, bins):
     return False
 
 
+def debug_print(debug, *args):
+    """Print debug messages.
+
+    Parameters:
+        debug       emit messages if True.
+        *args       arguments for print().
+    """
+
+    if debug:
+        print(*args)
+
+
+def get_csvfile(dest, jobnum):
+    """Generate CSV filename from command-line arguments and job numbers.
+
+    Paramaters:
+        dest        file specification for CSV filename.
+        jobnum      job number.
+
+    Returns:
+        A string that is a new filename that incorporates the job number.
+    """
+
+    stub, ext = os.path.splitext(dest)
+    return stub + '_job' + str(jobnum) + ext
+
+
+def validate(args, jsondata, col_labels):
+    """Validate CSV data against json+ output.
+
+    This function checks the CSV data to make sure that it was correctly
+    generated from the original json+ output. json+ 'bins' objects are
+    constructed from the CSV data and then compared to the corresponding
+    objects in the json+ data. An AssertionError will appear if a mismatch
+    is found.
+
+    Percentiles and cumulative counts are not checked.
+
+    Parameters:
+        args        command-line arguments for this script.
+        jsondata    json+ output to compare against.
+        col_labels  column labels for CSV data.
+
+    Returns
+        0 if no mismatches found.
+    """
+
+    colnames = [c.strip() for c in col_labels.split(',')]
+
+    for jobnum in range(len(jsondata['jobs'])):
+        job_data = jsondata['jobs'][jobnum]
+        csvfile = get_csvfile(args.dest, jobnum)
+
+        with open(csvfile, 'r') as csvsource:
+            csvlines = csvsource.read().split('\n')
+
+        assert csvlines[0] == col_labels
+        debug_print(args.debug, 'col_labels match for', csvfile)
+
+        # create 'bins' objects from the CSV data
+        counts = {}
+        for ddir in DDIR_LIST:
+            counts[ddir] = {}
+            for lat in LAT_LIST:
+                counts[ddir][lat] = {}
+
+        csvlines.pop(0)
+        for line in csvlines:
+            if line.strip() == "":
+                continue
+            values = line.split(',')
+            nsec = values[0]
+            for col in colnames:
+                if 'count' in col:
+                    val = values[colnames.index(col)]
+                    if val.strip() != "":
+                        count = int(val)
+                        ddir, lat, _, _ = col.split('_')
+                        lat = lat + '_ns'
+                        counts[ddir][lat][nsec] = count
+                        try:
+                            assert count == job_data[ddir][lat]['bins'][nsec]
+                        except Exception:
+                            print("mismatch:", csvfile, ddir, lat, nsec, "ns")
+                            return 1
+
+        # compare 'bins' objects created from the CSV data
+        # with corresponding 'bins' objects in the json+ output
+        for ddir in DDIR_LIST:
+            for lat in LAT_LIST:
+                if lat in job_data[ddir] and 'bins' in job_data[ddir][lat]:
+                    assert job_data[ddir][lat]['bins'] == counts[ddir][lat]
+                    debug_print(args.debug, csvfile, ddir, lat, "bins match")
+                else:
+                    assert counts[ddir][lat] == {}
+                    debug_print(args.debug, csvfile, ddir, lat, "bins empty")
+
+        print(csvfile, "validated")
+
+    return 0
+
+
 def main():
+    """Starting point for this script.
+
+    In standard mode, this script will generate CSV data from fio json+ output.
+    In validation mode it will check to make sure that counts in CSV files
+    match the counts in the json+ data.
+    """
+
     args = parse_args()
 
     with open(args.source, 'r') as source:
         jsondata = json.loads(source.read())
 
+    ddir_lat_list = list(ddir + '_' + lat for ddir, lat in itertools.product(DDIR_LIST, LAT_LIST))
+    debug_print(args.debug, 'ddir_lat_list: ', ddir_lat_list)
+    col_labels = 'nsec, '
+    for ddir_lat in ddir_lat_list:
+        col_labels += "{0}_count, {0}_cumulative, {0}_percentile, ".format(ddir_lat)
+    debug_print(args.debug, 'col_labels: ', col_labels)
+
+    if args.validate:
+        return validate(args, jsondata, col_labels)
+
     for jobnum in range(0, len(jsondata['jobs'])):
         bins = {}
         run_total = {}
-        ddir_set = set(['read', 'write', 'trim'])
-
-        prev_ddir = None
-        for ddir in ddir_set:
-            if 'bins' in jsondata['jobs'][jobnum][ddir]['clat_ns']:
-                bins_loc = 'clat_ns'
-            elif 'bins' in jsondata['jobs'][jobnum][ddir]['lat_ns']:
-                bins_loc = 'lat_ns'
-            else:
-                raise RuntimeError("Latency bins not found. "
-                                   "Are you sure you are using json+ output?")
-
-            bins[ddir] = [[int(key), value] for key, value in
-                          six.iteritems(jsondata['jobs'][jobnum][ddir][bins_loc]
-                          ['bins'])]
-            bins[ddir] = sorted(bins[ddir], key=lambda bin: bin[0])
-
-            run_total[ddir] = [0 for x in range(0, len(bins[ddir]))]
-            if len(bins[ddir]) > 0:
-                run_total[ddir][0] = bins[ddir][0][1]
-                for x in range(1, len(bins[ddir])):
-                    run_total[ddir][x] = run_total[ddir][x-1] + \
-                        bins[ddir][x][1]
-
-        stub, ext = os.path.splitext(args.dest)
-        outfile = stub + '_job' + str(jobnum) + ext
-
-        with open(outfile, 'w') as output:
-            output.write("{0}ec, ".format(bins_loc))
-            ddir_list = list(ddir_set)
-            for ddir in ddir_list:
-                output.write("{0}_count, {0}_cumulative, {0}_percentile, ".
-                             format(ddir))
-            output.write("\n")
+
+        for ddir in DDIR_LIST:
+            ddir_data = jsondata['jobs'][jobnum][ddir]
+            for lat in LAT_LIST:
+                ddir_lat = ddir + '_' + lat
+                if lat not in ddir_data or 'bins' not in ddir_data[lat]:
+                    bins[ddir_lat] = []
+                    debug_print(args.debug, 'job', jobnum, ddir_lat, 'not found')
+                    continue
+
+                debug_print(args.debug, 'job', jobnum, ddir_lat, 'processing')
+                bins[ddir_lat] = [[int(key), value] for key, value in
+                                  six.iteritems(ddir_data[lat]['bins'])]
+                bins[ddir_lat] = sorted(bins[ddir_lat], key=lambda bin: bin[0])
+
+                run_total[ddir_lat] = [0 for x in range(0, len(bins[ddir_lat]))]
+                run_total[ddir_lat][0] = bins[ddir_lat][0][1]
+                for index in range(1, len(bins[ddir_lat])):
+                    run_total[ddir_lat][index] = run_total[ddir_lat][index-1] + \
+                        bins[ddir_lat][index][1]
+
+        csvfile = get_csvfile(args.dest, jobnum)
+        with open(csvfile, 'w') as output:
+            output.write(col_labels + "\n")
 
 #
-# Have a counter for each ddir
+# Have a counter for each ddir_lat pairing
 # In each round, pick the shortest remaining duration
 # and output a line with any values for that duration
 #
-            indices = {x: 0 for x in ddir_list}
-            while more_lines(indices, bins):
+            indices = {x: 0 for x in ddir_lat_list}
+            while more_bins(indices, bins):
+                debug_print(args.debug, 'indices: ', indices)
                 min_lat = 17112760320
-                for ddir in ddir_list:
-                    if indices[ddir] < len(bins[ddir]):
-                        min_lat = min(bins[ddir][indices[ddir]][0], min_lat)
+                for ddir_lat in ddir_lat_list:
+                    if indices[ddir_lat] < len(bins[ddir_lat]):
+                        min_lat = min(bins[ddir_lat][indices[ddir_lat]][0], min_lat)
 
                 output.write("{0}, ".format(min_lat))
 
-                for ddir in ddir_list:
-                    if indices[ddir] < len(bins[ddir]) and \
-                       min_lat == bins[ddir][indices[ddir]][0]:
-                        count = bins[ddir][indices[ddir]][1]
-                        cumulative = run_total[ddir][indices[ddir]]
-                        ptile = percentile(indices[ddir], run_total[ddir])
-                        output.write("{0}, {1}, {2}, ".format(count,
-                                     cumulative, ptile))
-                        indices[ddir] += 1
+                for ddir_lat in ddir_lat_list:
+                    if indices[ddir_lat] < len(bins[ddir_lat]) and \
+                       min_lat == bins[ddir_lat][indices[ddir_lat]][0]:
+                        count = bins[ddir_lat][indices[ddir_lat]][1]
+                        cumulative = run_total[ddir_lat][indices[ddir_lat]]
+                        ptile = percentile(indices[ddir_lat], run_total[ddir_lat])
+                        output.write("{0}, {1}, {2}, ".format(count, cumulative, ptile))
+                        indices[ddir_lat] += 1
                     else:
                         output.write(", , , ")
                 output.write("\n")
 
-            print("{0} generated".format(outfile))
+            print("{0} generated".format(csvfile))
 
 
 if __name__ == '__main__':

