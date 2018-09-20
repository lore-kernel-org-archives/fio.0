Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:60658 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731100AbeITRnT (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 20 Sep 2018 13:43:19 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g2xcv-0001Zu-7I
        for fio@vger.kernel.org; Thu, 20 Sep 2018 12:00:09 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180920120001.9118E2C0168@kernel.dk>
Date: Thu, 20 Sep 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit ed06087e5f4f5dcb6660d1095005c777bcd661cb:

  filesetup: use 64-bit type for file size generation (2018-09-17 13:46:51 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5fa4aff59e4eec471b2c534702f0162006845c4b:

  Merge branch 'epoch-time-hist-logs' of https://github.com/parallel-fs-utils/fio (2018-09-19 09:42:47 -0600)

----------------------------------------------------------------
Ben England (2):
      handle log_unix_epoch=1
      raise exception if test start time can't be estimated

Jens Axboe (1):
      Merge branch 'epoch-time-hist-logs' of https://github.com/parallel-fs-utils/fio

 tools/hist/fio-histo-log-pctiles.py | 207 +++++++++++++++++++++++++-----------
 1 file changed, 144 insertions(+), 63 deletions(-)

---

Diff of recent changes:

diff --git a/tools/hist/fio-histo-log-pctiles.py b/tools/hist/fio-histo-log-pctiles.py
index 1e7b631..7f08f6e 100755
--- a/tools/hist/fio-histo-log-pctiles.py
+++ b/tools/hist/fio-histo-log-pctiles.py
@@ -21,7 +21,7 @@
 # if you do this, don't pass normal CLI parameters to it
 # otherwise it runs the CLI
 
-import sys, os, math, copy
+import sys, os, math, copy, time
 from copy import deepcopy
 import argparse
 
@@ -33,6 +33,8 @@ except ImportError:
 
 msec_per_sec = 1000
 nsec_per_usec = 1000
+direction_read = 0
+direction_write = 1
 
 class FioHistoLogExc(Exception):
     pass
@@ -57,10 +59,15 @@ def exception_suffix( record_num, pathname ):
 
 # log file parser raises FioHistoLogExc exceptions
 # it returns histogram buckets in whatever unit fio uses
-
-def parse_hist_file(logfn, buckets_per_interval):
-    max_timestamp_ms = 0.0
-    
+# inputs:
+#  logfn: pathname to histogram log file
+#  buckets_per_interval - how many histogram buckets to expect
+#  log_hist_msec - if not None, expected time interval between histogram records
+
+def parse_hist_file(logfn, buckets_per_interval, log_hist_msec):
+    previous_ts_ms_read = -1
+    previous_ts_ms_write = -1
+ 
     with open(logfn, 'r') as f:
         records = [ l.strip() for l in f.readlines() ]
     intervals = []
@@ -82,14 +89,20 @@ def parse_hist_file(logfn, buckets_per_interval):
         if len(int_tokens) < 3:
             raise FioHistoLogExc('too few numbers %s' % exception_suffix(k+1, logfn))
 
-        time_ms = int_tokens[0]
-        if time_ms > max_timestamp_ms:
-            max_timestamp_ms = time_ms
-
         direction = int_tokens[1]
-        if direction != 0 and direction != 1:
+        if direction != direction_read and direction != direction_write:
             raise FioHistoLogExc('invalid I/O direction %s' % exception_suffix(k+1, logfn))
 
+        time_ms = int_tokens[0]
+        if direction == direction_read:
+            if time_ms < previous_ts_ms_read:
+                raise FioHistoLogExc('read timestamp in column 1 decreased %s' % exception_suffix(k+1, logfn))
+            previous_ts_ms_read = time_ms
+        elif direction == direction_write:
+            if time_ms < previous_ts_ms_write:
+                raise FioHistoLogExc('write timestamp in column 1 decreased %s' % exception_suffix(k+1, logfn))
+            previous_ts_ms_write = time_ms
+
         bsz = int_tokens[2]
         if bsz > (1 << 24):
             raise FioHistoLogExc('block size too large %s' % exception_suffix(k+1, logfn))
@@ -110,7 +123,19 @@ def parse_hist_file(logfn, buckets_per_interval):
         intervals.append((time_ms, direction, bsz, buckets))
     if len(intervals) == 0:
         raise FioHistoLogExc('no records in %s' % logfn)
-    return (intervals, max_timestamp_ms)
+    (first_timestamp, _, _, _) = intervals[0]
+    if first_timestamp < 1000000:
+        start_time = 0    # assume log_unix_epoch = 0
+    elif log_hist_msec != None:
+        start_time = first_timestamp - log_hist_msec
+    elif len(intervals) > 1:
+        (second_timestamp, _, _, _) = intervals[1]
+        start_time = first_timestamp - (second_timestamp - first_timestamp)
+    else:
+        raise FioHistoLogExc('no way to estimate test start time')
+    (end_timestamp, _, _, _) = intervals[-1]
+
+    return (intervals, start_time, end_timestamp)
 
 
 # compute time range for each bucket index in histogram record
@@ -139,12 +164,13 @@ def time_ranges(groups, counters_per_group, fio_version=3):
 
 # compute number of time quantum intervals in the test
 
-def get_time_intervals(time_quantum, max_timestamp_ms):
+def get_time_intervals(time_quantum, min_timestamp_ms, max_timestamp_ms):
     # round down to nearest second
     max_timestamp = max_timestamp_ms // msec_per_sec
+    min_timestamp = min_timestamp_ms // msec_per_sec
     # round up to nearest whole multiple of time_quantum
-    time_interval_count = (max_timestamp + time_quantum) // time_quantum
-    end_time = time_interval_count * time_quantum
+    time_interval_count = ((max_timestamp - min_timestamp) + time_quantum) // time_quantum
+    end_time = min_timestamp + (time_interval_count * time_quantum)
     return (end_time, time_interval_count)
 
 # align raw histogram log data to time quantum so 
@@ -162,17 +188,17 @@ def get_time_intervals(time_quantum, max_timestamp_ms):
 # so the contribution of this bucket to this time quantum is
 # 515 x 0.99 = 509.85
 
-def align_histo_log(raw_histogram_log, time_quantum, bucket_count, max_timestamp_ms):
+def align_histo_log(raw_histogram_log, time_quantum, bucket_count, min_timestamp_ms, max_timestamp_ms):
 
     # slice up test time int intervals of time_quantum seconds
 
-    (end_time, time_interval_count) = get_time_intervals(time_quantum, max_timestamp_ms)
+    (end_time, time_interval_count) = get_time_intervals(time_quantum, min_timestamp_ms, max_timestamp_ms)
     time_qtm_ms = time_quantum * msec_per_sec
     end_time_ms = end_time * msec_per_sec
     aligned_intervals = []
     for j in range(0, time_interval_count):
         aligned_intervals.append((
-            j * time_qtm_ms,
+            min_timestamp_ms + (j * time_qtm_ms),
             [ 0.0 for j in range(0, bucket_count) ] ))
 
     log_record_count = len(raw_histogram_log)
@@ -205,14 +231,20 @@ def align_histo_log(raw_histogram_log, time_quantum, bucket_count, max_timestamp
 
         # calculate first quantum that overlaps this histogram record 
 
-        qtm_start_ms = (time_msec // time_qtm_ms) * time_qtm_ms
-        qtm_end_ms = ((time_msec + time_qtm_ms) // time_qtm_ms) * time_qtm_ms
-        qtm_index = qtm_start_ms // time_qtm_ms
+        offset_from_min_ts = time_msec - min_timestamp_ms
+        qtm_start_ms = min_timestamp_ms + (offset_from_min_ts // time_qtm_ms) * time_qtm_ms
+        qtm_end_ms = min_timestamp_ms + ((offset_from_min_ts + time_qtm_ms) // time_qtm_ms) * time_qtm_ms
+        qtm_index = offset_from_min_ts // time_qtm_ms
 
         # for each quantum that overlaps this histogram record's time interval
 
         while qtm_start_ms < time_msec_end:  # while quantum overlaps record
 
+            # some histogram logs may be longer than others
+
+            if len(aligned_intervals) <= qtm_index:
+                break
+
             # calculate fraction of time that this quantum 
             # overlaps histogram record's time interval
             
@@ -332,6 +364,9 @@ def compute_percentiles_from_logs():
     parser.add_argument("--time-quantum", dest="time_quantum", 
         default="1", type=int,
         help="time quantum in seconds (default=1)")
+    parser.add_argument("--log-hist-msec", dest="log_hist_msec", 
+        type=int, default=None,
+        help="log_hist_msec value in fio job file")
     parser.add_argument("--output-unit", dest="output_unit", 
         default="usec", type=str,
         help="Latency percentile output unit: msec|usec|nsec (default usec)")
@@ -355,30 +390,24 @@ def compute_percentiles_from_logs():
     buckets_per_interval = buckets_per_group * args.bucket_groups
     print('buckets per interval = %d ' % buckets_per_interval)
     bucket_index_range = range(0, buckets_per_interval)
+    if args.log_hist_msec != None:
+        print('log_hist_msec = %d' % args.log_hist_msec)
     if args.time_quantum == 0:
         print('ERROR: time-quantum must be a positive number of seconds')
     print('output unit = ' + args.output_unit)
     if args.output_unit == 'msec':
-        time_divisor = 1000.0
+        time_divisor = float(msec_per_sec)
     elif args.output_unit == 'usec':
         time_divisor = 1.0
 
-    # calculate response time interval associated with each histogram bucket
-
-    bucket_times = time_ranges(args.bucket_groups, buckets_per_group, fio_version=args.fio_version)
-
     # construct template for each histogram bucket array with buckets all zeroes
     # we just copy this for each new histogram
 
     zeroed_buckets = [ 0.0 for r in bucket_index_range ]
 
-    # print CSV header just like fiologparser_hist does
+    # calculate response time interval associated with each histogram bucket
 
-    header = 'msec, '
-    for p in args.pctiles_wanted:
-        header += '%3.1f, ' % p
-    print('time (millisec), percentiles in increasing order with values in ' + args.output_unit)
-    print(header)
+    bucket_times = time_ranges(args.bucket_groups, buckets_per_group, fio_version=args.fio_version)
 
     # parse the histogram logs
     # assumption: each bucket has a monotonically increasing time
@@ -386,33 +415,52 @@ def compute_percentiles_from_logs():
     # (exception: if randrw workload, then there is a read and a write 
     # record for the same time interval)
 
-    max_timestamp_all_logs = 0
+    test_start_time = 0
+    test_end_time = 1.0e18
     hist_files = {}
     for fn in args.file_list:
         try:
-            (hist_files[fn], max_timestamp_ms)  = parse_hist_file(fn, buckets_per_interval)
+            (hist_files[fn], log_start_time, log_end_time)  = parse_hist_file(fn, buckets_per_interval, args.log_hist_msec)
         except FioHistoLogExc as e:
             myabort(str(e))
-        max_timestamp_all_logs = max(max_timestamp_all_logs, max_timestamp_ms)
-
-    (end_time, time_interval_count) = get_time_intervals(args.time_quantum, max_timestamp_all_logs)
+        # we consider the test started when all threads have started logging
+        test_start_time = max(test_start_time, log_start_time)
+        # we consider the test over when one of the logs has ended
+        test_end_time = min(test_end_time, log_end_time)
+
+    if test_start_time >= test_end_time:
+        raise FioHistoLogExc('no time interval when all threads logs overlapped')
+    if test_start_time > 0:
+        print('all threads running as of unix epoch time %d = %s' % (
+               test_start_time/float(msec_per_sec), 
+               time.ctime(test_start_time/1000.0)))
+
+    (end_time, time_interval_count) = get_time_intervals(args.time_quantum, test_start_time, test_end_time)
     all_threads_histograms = [ ((j*args.time_quantum*msec_per_sec), deepcopy(zeroed_buckets))
-                                for j in range(0, time_interval_count) ]
+                               for j in range(0, time_interval_count) ]
 
     for logfn in hist_files.keys():
         aligned_per_thread = align_histo_log(hist_files[logfn], 
                                              args.time_quantum, 
                                              buckets_per_interval, 
-                                             max_timestamp_all_logs)
+                                             test_start_time,
+                                             test_end_time)
         for t in range(0, time_interval_count):
             (_, all_threads_histo_t) = all_threads_histograms[t]
             (_, log_histo_t) = aligned_per_thread[t]
             add_to_histo_from( all_threads_histo_t, log_histo_t )
 
     # calculate percentiles across aggregate histogram for all threads
+    # print CSV header just like fiologparser_hist does
+
+    header = 'msec-since-start, '
+    for p in args.pctiles_wanted:
+        header += '%3.1f, ' % p
+    print('time (millisec), percentiles in increasing order with values in ' + args.output_unit)
+    print(header)
 
     for (t_msec, all_threads_histo_t) in all_threads_histograms:
-        record = '%d, ' % t_msec
+        record = '%8d, ' % t_msec
         pct = get_pctiles(all_threads_histo_t, args.pctiles_wanted, bucket_times)
         if not pct:
             for w in args.pctiles_wanted:
@@ -471,8 +519,9 @@ if unittest2_imported:
         with open(self.fn, 'w') as f:
             f.write('1234, 0, 4096, 1, 2, 3, 4\n')
             f.write('5678,1,16384,5,6,7,8 \n')
-        (raw_histo_log, max_timestamp) = parse_hist_file(self.fn, 4) # 4 buckets per interval
-        self.A(len(raw_histo_log) == 2 and max_timestamp == 5678)
+        (raw_histo_log, min_timestamp, max_timestamp) = parse_hist_file(self.fn, 4, None) # 4 buckets per interval
+        # if not log_unix_epoch=1, then min_timestamp will always be set to zero
+        self.A(len(raw_histo_log) == 2 and min_timestamp == 0 and max_timestamp == 5678)
         (time_ms, direction, bsz, histo) = raw_histo_log[0]
         self.A(time_ms == 1234 and direction == 0 and bsz == 4096 and histo == [ 1, 2, 3, 4 ])
         (time_ms, direction, bsz, histo) = raw_histo_log[1]
@@ -482,7 +531,7 @@ if unittest2_imported:
         with open(self.fn, 'w') as f:
             pass
         try:
-            (raw_histo_log, max_timestamp_ms) = parse_hist_file(self.fn, 4)
+            (raw_histo_log, _, _) = parse_hist_file(self.fn, 4, None)
             self.A(should_not_get_here)
         except FioHistoLogExc as e:
             self.A(str(e).startswith('no records'))
@@ -493,7 +542,7 @@ if unittest2_imported:
             f.write('1234, 0, 4096, 1, 2, 3, 4\n')
             f.write('5678,1,16384,5,6,7,8 \n')
             f.write('\n')
-        (raw_histo_log, max_timestamp_ms) = parse_hist_file(self.fn, 4)
+        (raw_histo_log, _, max_timestamp_ms) = parse_hist_file(self.fn, 4, None)
         self.A(len(raw_histo_log) == 2 and max_timestamp_ms == 5678)
         (time_ms, direction, bsz, histo) = raw_histo_log[0]
         self.A(time_ms == 1234 and direction == 0 and bsz == 4096 and histo == [ 1, 2, 3, 4 ])
@@ -504,7 +553,7 @@ if unittest2_imported:
         with open(self.fn, 'w') as f:
             f.write('12, 0, 4096, 1a, 2, 3, 4\n')
         try:
-            (raw_histo_log, _) = parse_hist_file(self.fn, 4)
+            (raw_histo_log, _, _) = parse_hist_file(self.fn, 4, None)
             self.A(False)
         except FioHistoLogExc as e:
             self.A(str(e).startswith('non-integer'))
@@ -513,7 +562,7 @@ if unittest2_imported:
         with open(self.fn, 'w') as f:
             f.write('-12, 0, 4096, 1, 2, 3, 4\n')
         try:
-            (raw_histo_log, _) = parse_hist_file(self.fn, 4)
+            (raw_histo_log, _, _) = parse_hist_file(self.fn, 4, None)
             self.A(False)
         except FioHistoLogExc as e:
             self.A(str(e).startswith('negative integer'))
@@ -522,7 +571,7 @@ if unittest2_imported:
         with open(self.fn, 'w') as f:
             f.write('0, 0\n')
         try:
-            (raw_histo_log, _) = parse_hist_file(self.fn, 4)
+            (raw_histo_log, _, _) = parse_hist_file(self.fn, 4, None)
             self.A(False)
         except FioHistoLogExc as e:
             self.A(str(e).startswith('too few numbers'))
@@ -531,7 +580,7 @@ if unittest2_imported:
         with open(self.fn, 'w') as f:
             f.write('100, 2, 4096, 1, 2, 3, 4\n')
         try:
-            (raw_histo_log, _) = parse_hist_file(self.fn, 4)
+            (raw_histo_log, _, _) = parse_hist_file(self.fn, 4, None)
             self.A(False)
         except FioHistoLogExc as e:
             self.A(str(e).startswith('invalid I/O direction'))
@@ -539,11 +588,11 @@ if unittest2_imported:
     def test_b8_parse_bsz_too_big(self):
         with open(self.fn+'_good', 'w') as f:
             f.write('100, 1, %d, 1, 2, 3, 4\n' % (1<<24))
-        (raw_histo_log, max_timestamp_ms) = parse_hist_file(self.fn+'_good', 4)
+        (raw_histo_log, _, _) = parse_hist_file(self.fn+'_good', 4, None)
         with open(self.fn+'_bad', 'w') as f:
             f.write('100, 1, 20000000, 1, 2, 3, 4\n')
         try:
-            (raw_histo_log, _) = parse_hist_file(self.fn+'_bad', 4)
+            (raw_histo_log, _, _) = parse_hist_file(self.fn+'_bad', 4, None)
             self.A(False)
         except FioHistoLogExc as e:
             self.A(str(e).startswith('block size too large'))
@@ -552,7 +601,7 @@ if unittest2_imported:
         with open(self.fn, 'w') as f:
             f.write('100, 1, %d, 1, 2, 3, 4, 5\n' % (1<<24))
         try:
-            (raw_histo_log, _) = parse_hist_file(self.fn, 4)
+            (raw_histo_log, _, _) = parse_hist_file(self.fn, 4, None)
             self.A(False)
         except FioHistoLogExc as e:
             self.A(str(e).__contains__('buckets per interval'))
@@ -581,12 +630,44 @@ if unittest2_imported:
     def test_d1_align_histo_log_1_quantum(self):
         with open(self.fn, 'w') as f:
             f.write('100, 1, 4096, 1, 2, 3, 4')
-        (raw_histo_log, max_timestamp_ms) = parse_hist_file(self.fn, 4)
-        self.A(max_timestamp_ms == 100)
-        aligned_log = align_histo_log(raw_histo_log, 5, 4, max_timestamp_ms)
+        (raw_histo_log, min_timestamp_ms, max_timestamp_ms) = parse_hist_file(self.fn, 4, None)
+        self.A(min_timestamp_ms == 0 and max_timestamp_ms == 100)
+        aligned_log = align_histo_log(raw_histo_log, 5, 4, min_timestamp_ms, max_timestamp_ms)
+        self.A(len(aligned_log) == 1)
+        (time_ms0, h) = aligned_log[0]
+        self.A(time_ms0 == 0 and h == [1., 2., 3., 4.])
+
+    # handle case with log_unix_epoch=1 timestamps, 1-second time quantum
+    # here both records will be separated into 2 aligned intervals
+
+    def test_d1a_align_2rec_histo_log_epoch_1_quantum_1sec(self):
+        with open(self.fn, 'w') as f:
+            f.write('1536504002123, 1, 4096, 1, 2, 3, 4\n')
+            f.write('1536504003123, 1, 4096, 4, 3, 2, 1\n')
+        (raw_histo_log, min_timestamp_ms, max_timestamp_ms) = parse_hist_file(self.fn, 4, None)
+        self.A(min_timestamp_ms == 1536504001123 and max_timestamp_ms == 1536504003123)
+        aligned_log = align_histo_log(raw_histo_log, 1, 4, min_timestamp_ms, max_timestamp_ms)
+        self.A(len(aligned_log) == 3)
+        (time_ms0, h) = aligned_log[0]
+        self.A(time_ms0 == 1536504001123 and h == [0., 0., 0., 0.])
+        (time_ms1, h) = aligned_log[1]
+        self.A(time_ms1 == 1536504002123 and h == [1., 2., 3., 4.])
+        (time_ms2, h) = aligned_log[2]
+        self.A(time_ms2 == 1536504003123 and h == [4., 3., 2., 1.])
+
+    # handle case with log_unix_epoch=1 timestamps, 5-second time quantum
+    # here both records will be merged into a single aligned time interval
+
+    def test_d1b_align_2rec_histo_log_epoch_1_quantum_5sec(self):
+        with open(self.fn, 'w') as f:
+            f.write('1536504002123, 1, 4096, 1, 2, 3, 4\n')
+            f.write('1536504003123, 1, 4096, 4, 3, 2, 1\n')
+        (raw_histo_log, min_timestamp_ms, max_timestamp_ms) = parse_hist_file(self.fn, 4, None)
+        self.A(min_timestamp_ms == 1536504001123 and max_timestamp_ms == 1536504003123)
+        aligned_log = align_histo_log(raw_histo_log, 5, 4, min_timestamp_ms, max_timestamp_ms)
         self.A(len(aligned_log) == 1)
         (time_ms0, h) = aligned_log[0]
-        self.A(time_ms0 == 0 and h == [1.0, 2.0, 3.0, 4.0])
+        self.A(time_ms0 == 1536504001123 and h == [5., 5., 5., 5.])
 
     # we need this to compare 2 lists of floating point numbers for equality
     # because of floating-point imprecision
@@ -608,11 +689,11 @@ if unittest2_imported:
         with open(self.fn, 'w') as f:
             f.write('2000, 1, 4096, 1, 2, 3, 4\n')
             f.write('7000, 1, 4096, 1, 2, 3, 4\n')
-        (raw_histo_log, max_timestamp_ms) = parse_hist_file(self.fn, 4)
-        self.A(max_timestamp_ms == 7000)
+        (raw_histo_log, min_timestamp_ms, max_timestamp_ms) = parse_hist_file(self.fn, 4, None)
+        self.A(min_timestamp_ms == 0 and max_timestamp_ms == 7000)
         (_, _, _, raw_buckets1) = raw_histo_log[0]
         (_, _, _, raw_buckets2) = raw_histo_log[1]
-        aligned_log = align_histo_log(raw_histo_log, 5, 4, max_timestamp_ms)
+        aligned_log = align_histo_log(raw_histo_log, 5, 4, min_timestamp_ms, max_timestamp_ms)
         self.A(len(aligned_log) == 2)
         (time_ms1, h1) = aligned_log[0]
         (time_ms2, h2) = aligned_log[1]
@@ -630,9 +711,9 @@ if unittest2_imported:
         with open(self.fn, 'w') as f:
             buckets = [ 100 for j in range(0, 128) ]
             f.write('9000, 1, 4096, %s\n' % ', '.join([str(b) for b in buckets]))
-        (raw_histo_log, max_timestamp_ms) = parse_hist_file(self.fn, 128)
-        self.A(max_timestamp_ms == 9000)
-        aligned_log = align_histo_log(raw_histo_log, 5, 128, max_timestamp_ms)
+        (raw_histo_log, min_timestamp_ms, max_timestamp_ms) = parse_hist_file(self.fn, 128, None)
+        self.A(min_timestamp_ms == 0 and max_timestamp_ms == 9000)
+        aligned_log = align_histo_log(raw_histo_log, 5, 128, min_timestamp_ms, max_timestamp_ms)
         time_intervals = time_ranges(4, 32)
         # since buckets are all equal, then median is halfway through time_intervals
         # and max latency interval is at end of time_intervals
@@ -654,9 +735,9 @@ if unittest2_imported:
             # add one I/O request to last bucket
             buckets[-1] = 1
             f.write('9000, 1, 4096, %s\n' % ', '.join([str(b) for b in buckets]))
-        (raw_histo_log, max_timestamp_ms) = parse_hist_file(self.fn, fio_v3_bucket_count)
-        self.A(max_timestamp_ms == 9000)
-        aligned_log = align_histo_log(raw_histo_log, 5, fio_v3_bucket_count, max_timestamp_ms)
+        (raw_histo_log, min_timestamp_ms, max_timestamp_ms) = parse_hist_file(self.fn, fio_v3_bucket_count, None)
+        self.A(min_timestamp_ms == 0 and max_timestamp_ms == 9000)
+        aligned_log = align_histo_log(raw_histo_log, 5, fio_v3_bucket_count, min_timestamp_ms, max_timestamp_ms)
         (time_ms, histo) = aligned_log[1]
         time_intervals = time_ranges(29, 64)
         expected_pctiles = { 100.0:(64*(1<<28))/1000.0 }

