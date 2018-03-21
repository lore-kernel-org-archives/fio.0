Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:59076 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751502AbeCUMAU (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 21 Mar 2018 08:00:20 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1eycPj-0001JG-Sd
        for fio@vger.kernel.org; Wed, 21 Mar 2018 12:00:20 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180321120001.CB9852C0119@kernel.dk>
Date: Wed, 21 Mar 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 96344ff00349422172de6fa57899c66dc3c00391:

  optgroup: add check for optgroup bit numbers being within range (2018-03-19 15:56:20 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 69c594d81d4067fadd70fa4909e19d615efa5f1c:

  optgroup: move debug code into function (2018-03-20 11:19:19 -0600)

----------------------------------------------------------------
Jens Axboe (3):
      Merge branch 'expand_fiohistparser' of https://github.com/shimrot/fio
      Fix whitespace issues in previous commit
      optgroup: move debug code into function

krisd (1):
      Expand fiologparser_hist operations with new options

 optgroup.c                        |   5 +-
 tools/hist/fiologparser_hist.py   | 385 ++++++++++++++++++++++++++++++--------
 tools/hist/fiologparser_hist.py.1 |  23 ++-
 3 files changed, 328 insertions(+), 85 deletions(-)

---

Diff of recent changes:

diff --git a/optgroup.c b/optgroup.c
index 1c418f5..04ceec7 100644
--- a/optgroup.c
+++ b/optgroup.c
@@ -202,7 +202,8 @@ const struct opt_group *opt_group_from_mask(uint64_t *mask)
 
 const struct opt_group *opt_group_cat_from_mask(uint64_t *mask)
 {
+	compiletime_assert(__FIO_OPT_G_NR <= 8 * sizeof(uint64_t),
+				"__FIO_OPT_G_NR");
+
 	return group_from_mask(fio_opt_cat_groups, mask, FIO_OPT_G_INVALID);
 }
-
-compiletime_assert(__FIO_OPT_G_NR <= 8 * sizeof(uint64_t), "__FIO_OPT_G_NR");
diff --git a/tools/hist/fiologparser_hist.py b/tools/hist/fiologparser_hist.py
index 62a4eb4..8910d5f 100755
--- a/tools/hist/fiologparser_hist.py
+++ b/tools/hist/fiologparser_hist.py
@@ -16,10 +16,57 @@
 import os
 import sys
 import pandas
+import re
 import numpy as np
 
+runascmd = False
+
 err = sys.stderr.write
 
+class HistFileRdr():
+    """ Class to read a hist file line by line, buffering
+        a value array for the latest line, and allowing a preview
+        of the next timestamp in next line
+        Note: this does not follow a generator pattern, but must explicitly
+        get next bin array.
+    """
+    def __init__(self, file):
+        self.fp = open(file, 'r')
+        self.data = self.nextData()
+
+    def close(self):
+        self.fp.close()
+        self.fp = None
+
+    def nextData(self):
+        self.data = None
+        if self.fp:
+            line = self.fp.readline()
+            if line == "":
+                self.close()
+            else:
+                self.data = [int(x) for x in line.replace(' ', '').rstrip().split(',')]
+
+        return self.data
+
+    @property
+    def curTS(self):
+        ts = None
+        if self.data:
+            ts = self.data[0]
+        return ts
+
+    @property
+    def curDir(self):
+        d = None
+        if self.data:
+            d = self.data[1]
+        return d
+
+    @property
+    def curBins(self):
+        return self.data[3:]
+
 def weighted_percentile(percs, vs, ws):
     """ Use linear interpolation to calculate the weighted percentile.
         
@@ -42,7 +89,7 @@ def weights(start_ts, end_ts, start, end):
     """ Calculate weights based on fraction of sample falling in the
         given interval [start,end]. Weights computed using vector / array
         computation instead of for-loops.
-    
+
         Note that samples with zero time length are effectively ignored
         (we set their weight to zero).
 
@@ -64,8 +111,21 @@ def weights(start_ts, end_ts, start, end):
 def weighted_average(vs, ws):
     return np.sum(vs * ws) / np.sum(ws)
 
-columns = ["end-time", "samples", "min", "avg", "median", "90%", "95%", "99%", "max"]
-percs   = [50, 90, 95, 99]
+
+percs = None
+columns = None
+
+def gen_output_columns(ctx):
+    global percs,columns
+    strpercs = re.split('[,:]', ctx.percentiles)
+    percs = [50.0]  # always print 50% in 'median' column
+    percs.extend(list(map(float,strpercs)))
+    if ctx.directions:
+        columns = ["end-time", "dir", "samples", "min", "avg", "median"]
+    else:
+        columns = ["end-time", "samples", "min", "avg", "median"]
+    columns.extend(list(map(lambda x: x+'%', strpercs)))
+    columns.append("max")
 
 def fmt_float_list(ctx, num=1):
   """ Return a comma separated list of float formatters to the required number
@@ -80,7 +140,7 @@ def fmt_float_list(ctx, num=1):
 __HIST_COLUMNS = 1216
 __NON_HIST_COLUMNS = 3
 __TOTAL_COLUMNS = __HIST_COLUMNS + __NON_HIST_COLUMNS
-    
+
 def read_chunk(rdr, sz):
     """ Read the next chunk of size sz from the given reader. """
     try:
@@ -88,15 +148,18 @@ def read_chunk(rdr, sz):
             occurs if rdr is None due to the file being empty. """
         new_arr = rdr.read().values
     except (StopIteration, AttributeError):
-        return None    
+        return None
 
-    """ Extract array of just the times, and histograms matrix without times column. """
-    times, rws, szs = new_arr[:,0], new_arr[:,1], new_arr[:,2]
-    hists = new_arr[:,__NON_HIST_COLUMNS:]
-    times = times.reshape((len(times),1))
-    arr = np.append(times, hists, axis=1)
+    # Let's leave the array as is, and let later code ignore the block size
+    return new_arr
 
-    return arr
+    #""" Extract array of the times, directions wo times, and histograms matrix without times column. """
+    #times, rws, szs = new_arr[:,0], new_arr[:,1], new_arr[:,2]
+    #hists = new_arr[:,__NON_HIST_COLUMNS:]
+    #times = times.reshape((len(times),1))
+    #dirs  = rws.reshape((len(rws),1))
+    #arr = np.append(times, hists, axis=1)
+    #return arr
 
 def get_min(fps, arrs):
     """ Find the file with the current first row with the smallest start time """
@@ -126,7 +189,8 @@ def histogram_generator(ctx, fps, sz):
         except ValueError:
             return
         arr = arrs[fp]
-        yield np.insert(arr[0], 1, fps.index(fp))
+        arri = np.insert(arr[0], 1, fps.index(fp))
+        yield arri
         arrs[fp] = arr[1:]
 
         if arrs[fp].shape[0] == 0:
@@ -172,13 +236,24 @@ def plat_idx_to_val_coarse(idx, coarseness, edge=0.5):
     upper = _plat_idx_to_val(idx + stride, edge=1.0)
     return lower + (upper - lower) * edge
 
-def print_all_stats(ctx, end, mn, ss_cnt, vs, ws, mx):
+def print_all_stats(ctx, end, mn, ss_cnt, vs, ws, mx, dir=dir):
     ps = weighted_percentile(percs, vs, ws)
 
     avg = weighted_average(vs, ws)
     values = [mn, avg] + list(ps) + [mx]
-    row = [end, ss_cnt] + [float(x) / ctx.divisor for x in values]
-    fmt = "%d, %d, %d, " + fmt_float_list(ctx, 5) + ", %d"
+    if ctx.directions:
+        row = [end, dir, ss_cnt]
+        fmt = "%d, %s, %d, "
+    else:
+        row = [end, ss_cnt]
+        fmt = "%d, %d, "
+    row = row + [float(x) / ctx.divisor for x in values]
+    if ctx.divisor > 1:
+        fmt = fmt + fmt_float_list(ctx, len(percs)+3)
+    else:
+        # max and min are decimal values if no divisor
+        fmt = fmt + "%d, " + fmt_float_list(ctx, len(percs)+1) + ", %d"
+
     print (fmt % tuple(row))
 
 def update_extreme(val, fncn, new_val):
@@ -191,40 +266,69 @@ bin_vals = []
 lower_bin_vals = [] # lower edge of each bin
 upper_bin_vals = [] # upper edge of each bin 
 
-def process_interval(ctx, samples, iStart, iEnd):
+def process_interval(ctx, iHist, iEnd, dir):
+    """ print estimated percentages for the given merged sample
+    """
+    ss_cnt = 0 # number of samples affecting this interval
+    mn_bin_val, mx_bin_val = None, None
+
+    # Update total number of samples affecting current interval histogram:
+    ss_cnt += np.sum(iHist)
+
+    # Update min and max bin values
+    idxs = np.nonzero(iHist != 0)[0]
+    if idxs.size > 0:
+        mn_bin_val = bin_vals[idxs[0]]
+        mx_bin_val = bin_vals[idxs[-1]]
+
+    if ss_cnt > 0: print_all_stats(ctx, iEnd, mn_bin_val, ss_cnt, bin_vals, iHist, mx_bin_val, dir=dir)
+
+
+dir_map = ['r', 'w', 't']  # map of directional value in log to textual representation
+def process_weighted_interval(ctx, samples, iStart, iEnd, printdirs):
     """ Construct the weighted histogram for the given interval by scanning
         through all the histograms and figuring out which of their bins have
         samples with latencies which overlap with the given interval
         [iStart,iEnd].
     """
-    
-    times, files, hists = samples[:,0], samples[:,1], samples[:,2:]
-    iHist = np.zeros(__HIST_COLUMNS)
-    ss_cnt = 0 # number of samples affecting this interval
-    mn_bin_val, mx_bin_val = None, None
 
-    for end_time,file,hist in zip(times,files,hists):
-            
+    times, files, dirs, sizes, hists = samples[:,0], samples[:,1], samples[:,2], samples[:,3], samples[:,4:]
+    iHist={}; ss_cnt = {}; mn_bin_val={}; mx_bin_val={}
+    for dir in printdirs:
+        iHist[dir] = np.zeros(__HIST_COLUMNS, dtype=float)
+        ss_cnt[dir] = 0 # number of samples affecting this interval
+        mn_bin_val[dir] = None
+        mx_bin_val[dir] = None
+
+    for end_time,file,dir,hist in zip(times,files,dirs,hists):
+
         # Only look at bins of the current histogram sample which
         # started before the end of the current time interval [start,end]
-        start_times = (end_time - 0.5 * ctx.interval) - bin_vals / 1000.0
+        start_times = (end_time - 0.5 * ctx.interval) - bin_vals / ctx.time_divisor
         idx = np.where(start_times < iEnd)
         s_ts, l_bvs, u_bvs, hs = start_times[idx], lower_bin_vals[idx], upper_bin_vals[idx], hist[idx]
 
-        # Increment current interval histogram by weighted values of future histogram:
+        # Increment current interval histogram by weighted values of future histogram
+        # total number of samples
+        # and min and max values as necessary
+        textdir = dir_map[dir]
         ws = hs * weights(s_ts, end_time, iStart, iEnd)
-        iHist[idx] += ws
-    
-        # Update total number of samples affecting current interval histogram:
-        ss_cnt += np.sum(hs)
-        
-        # Update min and max bin values seen if necessary:
-        idx = np.where(hs != 0)[0]
-        if idx.size > 0:
-            mn_bin_val = update_extreme(mn_bin_val, min, l_bvs[max(0,           idx[0]  - 1)])
-            mx_bin_val = update_extreme(mx_bin_val, max, u_bvs[min(len(hs) - 1, idx[-1] + 1)])
-
-    if ss_cnt > 0: print_all_stats(ctx, iEnd, mn_bin_val, ss_cnt, bin_vals, iHist, mx_bin_val)
+        mmidx = np.where(hs != 0)[0]
+        if 'm' in printdirs:
+            iHist['m'][idx] += ws
+            ss_cnt['m'] += np.sum(hs)
+            if mmidx.size > 0:
+                mn_bin_val['m'] = update_extreme(mn_bin_val['m'], min, l_bvs[max(0,           mmidx[0]  - 1)])
+                mx_bin_val['m'] = update_extreme(mx_bin_val['m'], max, u_bvs[min(len(hs) - 1, mmidx[-1] + 1)])
+        if textdir in printdirs:
+            iHist[textdir][idx] += ws
+            ss_cnt[textdir] += np.sum(hs)  # Update total number of samples affecting current interval histogram:
+            if mmidx.size > 0:
+                mn_bin_val[textdir] = update_extreme(mn_bin_val[textdir], min, l_bvs[max(0,           mmidx[0]  - 1)])
+                mx_bin_val[textdir] = update_extreme(mx_bin_val[textdir], max, u_bvs[min(len(hs) - 1, mmidx[-1] + 1)])
+
+    for textdir in sorted(printdirs):
+        if ss_cnt[textdir] > 0: print_all_stats(ctx, iEnd, mn_bin_val[textdir], ss_cnt[textdir], bin_vals, iHist[textdir], mx_bin_val[textdir], dir=textdir)
 
 def guess_max_from_bins(ctx, hist_cols):
     """ Try to guess the GROUP_NR from given # of histogram
@@ -241,7 +345,7 @@ def guess_max_from_bins(ctx, hist_cols):
     idx = np.where(arr == hist_cols)
     if len(idx[1]) == 0:
         table = repr(arr.astype(int)).replace('-10', 'N/A').replace('array','     ')
-        err("Unable to determine bin values from input clat_hist files. Namely \n"
+        errmsg = ("Unable to determine bin values from input clat_hist files. Namely \n"
             "the first line of file '%s' " % ctx.FILE[0] + "has %d \n" % (__TOTAL_COLUMNS,) +
             "columns of which we assume %d " % (hist_cols,) + "correspond to histogram bins. \n"
             "This number needs to be equal to one of the following numbers:\n\n"
@@ -250,9 +354,119 @@ def guess_max_from_bins(ctx, hist_cols):
             "  - Input file(s) does not contain histograms.\n"
             "  - You recompiled fio with a different GROUP_NR. If so please specify this\n"
             "    new GROUP_NR on the command line with --group_nr\n")
-        exit(1)
+        if runascmd:
+            err(errmsg)
+            exit(1)
+        else:
+            raise RuntimeError(errmsg) 
+
     return bins[idx[1][0]]
 
+def output_weighted_interval_data(ctx,printdirs):
+
+    fps = [open(f, 'r') for f in ctx.FILE]
+    gen = histogram_generator(ctx, fps, ctx.buff_size)
+
+    print(', '.join(columns))
+
+    try:
+        start, end = 0, ctx.interval
+        arr = np.empty(shape=(0,__TOTAL_COLUMNS + 1),dtype=int)
+        more_data = True
+        while more_data or len(arr) > 0:
+
+            # Read up to ctx.max_latency (default 20 seconds) of data from end of current interval.
+            while len(arr) == 0 or arr[-1][0] < ctx.max_latency * 1000 + end:
+                try:
+                    new_arr = next(gen)
+                except StopIteration:
+                    more_data = False
+                    break
+                nashape  = new_arr.reshape((1,__TOTAL_COLUMNS + 1))
+                arr = np.append(arr, nashape, axis=0)
+            #arr = arr.astype(int)
+            
+            if arr.size > 0:
+                # Jump immediately to the start of the input, rounding
+                # down to the nearest multiple of the interval (useful when --log_unix_epoch
+                # was used to create these histograms):
+                if start == 0 and arr[0][0] - ctx.max_latency > end:
+                    start = arr[0][0] - ctx.max_latency
+                    start = start - (start % ctx.interval)
+                    end = start + ctx.interval
+
+                process_weighted_interval(ctx, arr, start, end, printdirs)
+                
+                # Update arr to throw away samples we no longer need - samples which
+                # end before the start of the next interval, i.e. the end of the
+                # current interval:
+                idx = np.where(arr[:,0] > end)
+                arr = arr[idx]
+            
+            start += ctx.interval
+            end = start + ctx.interval
+    finally:
+        for fp in fps:
+            fp.close()
+
+def output_interval_data(ctx,directions):
+    fps = [HistFileRdr(f) for f in ctx.FILE]
+
+    print(', '.join(columns))
+
+    start = 0
+    end = ctx.interval
+    while True:
+
+        more_data = False
+
+        # add bins from all files in target intervals
+        arr = None
+        numSamples = 0
+        while True:
+            foundSamples = False
+            for fp in fps:
+                ts = fp.curTS
+                if ts and ts+10 < end:  # shift sample time when very close to an end time
+                    curdirect = fp.curDir
+                    numSamples += 1
+                    foundSamples = True
+                    if arr is None:
+                        arr = {}
+                        for d in directions:
+                            arr[d] = np.zeros(shape=(__HIST_COLUMNS), dtype=int)
+                    if 'm' in arr:
+                        arr['m'] = np.add(arr['m'], fp.curBins)
+                    if 'r' in arr and curdirect == 0:
+                        arr['r'] = np.add(arr['r'], fp.curBins)
+                    if 'w' in arr and curdirect == 1:
+                        arr['w'] = np.add(arr['w'], fp.curBins)
+                    if 't' in arr and curdirect == 2:
+                        arr['t'] = np.add(arr['t'], fp.curBins)
+
+                    more_data = True
+                    fp.nextData()
+                elif ts:
+                    more_data = True
+
+            # reached end of all files
+            # or gone through all files without finding sample in interval
+            if not more_data or not foundSamples:
+                break
+
+        if arr is not None:
+            #print("{} size({}) samples({}) nonzero({}):".format(end, arr.size, numSamples, np.count_nonzero(arr)), str(arr), )
+            for d in sorted(arr.keys()):
+                aval = arr[d]
+                process_interval(ctx, aval, end, d)
+
+        # reach end of all files
+        if not more_data:
+            break
+
+        start += ctx.interval
+        end = start + ctx.interval
+
 def main(ctx):
 
     if ctx.job_file:
@@ -275,9 +489,23 @@ def main(ctx):
                 except NoOptionError:
                     pass
 
+    if not hasattr(ctx, 'percentiles'):
+        ctx.percentiles = "90,95,99"
+
+    if ctx.directions:
+        ctx.directions = ctx.directions.lower()
+
     if ctx.interval is None:
         ctx.interval = 1000
 
+    if ctx.usbin:
+        ctx.time_divisor = 1000.0        # bins are in us
+    else:
+        ctx.time_divisor = 1000000.0     # bins are in ns
+
+    gen_output_columns(ctx)
+
+
     # Automatically detect how many columns are in the input files,
     # calculate the corresponding 'coarseness' parameter used to generate
     # those files, and calculate the appropriate bin latency values:
@@ -292,53 +520,22 @@ def main(ctx):
         lower_bin_vals = np.array([plat_idx_to_val_coarse(x, coarseness, 0.0) for x in np.arange(__HIST_COLUMNS)], dtype=float)
         upper_bin_vals = np.array([plat_idx_to_val_coarse(x, coarseness, 1.0) for x in np.arange(__HIST_COLUMNS)], dtype=float)
 
-    fps = [open(f, 'r') for f in ctx.FILE]
-    gen = histogram_generator(ctx, fps, ctx.buff_size)
-
-    print(', '.join(columns))
+    # indicate which directions to output (read(0), write(1), trim(2), mixed(3))
+    directions = set()
+    if not ctx.directions or 'm' in ctx.directions: directions.add('m')
+    if ctx.directions and 'r' in ctx.directions:    directions.add('r')
+    if ctx.directions and 'w' in ctx.directions:    directions.add('w')
+    if ctx.directions and 't' in ctx.directions:    directions.add('t')
 
-    try:
-        start, end = 0, ctx.interval
-        arr = np.empty(shape=(0,__TOTAL_COLUMNS - 1))
-        more_data = True
-        while more_data or len(arr) > 0:
-            
-            # Read up to ctx.max_latency (default 20 seconds) of data from end of current interval.
-            while len(arr) == 0 or arr[-1][0] < ctx.max_latency * 1000 + end:
-                try:
-                    new_arr = next(gen)
-                except StopIteration:
-                    more_data = False
-                    break
-                arr = np.append(arr, new_arr.reshape((1,__TOTAL_COLUMNS - 1)), axis=0)
-            arr = arr.astype(int)
-            
-            if arr.size > 0:
-                # Jump immediately to the start of the input, rounding
-                # down to the nearest multiple of the interval (useful when --log_unix_epoch
-                # was used to create these histograms):
-                if start == 0 and arr[0][0] - ctx.max_latency > end:
-                    start = arr[0][0] - ctx.max_latency
-                    start = start - (start % ctx.interval)
-                    end = start + ctx.interval
-
-                process_interval(ctx, arr, start, end)
-                
-                # Update arr to throw away samples we no longer need - samples which
-                # end before the start of the next interval, i.e. the end of the
-                # current interval:
-                idx = np.where(arr[:,0] > end)
-                arr = arr[idx]
-            
-            start += ctx.interval
-            end = start + ctx.interval
-    finally:
-        for fp in fps:
-            fp.close()
+    if ctx.noweight:
+        output_interval_data(ctx, directions)
+    else:
+        output_weighted_interval_data(ctx, directions)
 
 
 if __name__ == '__main__':
     import argparse
+    runascmd = True
     p = argparse.ArgumentParser()
     arg = p.add_argument
     arg("FILE", help='space separated list of latency log filenames', nargs='+')
@@ -356,6 +553,11 @@ if __name__ == '__main__':
         type=int,
         help='interval width (ms), default 1000 ms')
 
+    arg('--noweight',
+        action='store_true',
+        default=False,
+        help='do not perform weighting of samples between output intervals')
+
     arg('-d', '--divisor',
         required=False,
         type=int,
@@ -385,5 +587,26 @@ if __name__ == '__main__':
              'given histogram files. Useful for auto-detecting --log_hist_msec and '
              '--log_unix_epoch (in fio) values.')
 
+    arg('--percentiles',
+        default="90:95:99",
+        type=str,
+        help='Optional argument of comma or colon separated percentiles to print. '
+             'The default is "90.0:95.0:99.0".  min, median(50%%) and max percentiles are always printed')
+
+    arg('--usbin',
+        default=False,
+        action='store_true',
+        help='histogram bin latencies are in us (fio versions < 2.99. fio uses ns for version >= 2.99')
+
+    arg('--directions',
+        default=None,
+        type=str,
+        help='Optionally split results output by reads, writes, trims or mixed. '
+             'Value may be any combination of "rwtm" characters. '
+             'By default, only "mixed" results are output without a "dir" field. '
+             'But, specifying the --directions option '
+             'adds a "dir" field to the output content, and separate rows for each of the indicated '
+             'directions.')
+
     main(p.parse_args())
 
diff --git a/tools/hist/fiologparser_hist.py.1 b/tools/hist/fiologparser_hist.py.1
index 5dfacfe..449f248 100644
--- a/tools/hist/fiologparser_hist.py.1
+++ b/tools/hist/fiologparser_hist.py.1
@@ -8,7 +8,7 @@ fiologparser_hist.py \- Calculate statistics from fio histograms
 .B fiologparser_hist.py
 is a utility for converting *_clat_hist* files
 generated by fio into a CSV of latency statistics including minimum,
-average, maximum latency, and 50th, 95th, and 99th percentiles.
+average, maximum latency, and selectable percentiles.
 .SH EXAMPLES
 .PP
 .nf
@@ -42,6 +42,9 @@ Interval at which statistics are reported. Defaults to 1000 ms. This
 should be set a minimum of the value for \fBlog_hist_msec\fR as given
 to fio.
 .TP
+.BR \-\-noweight
+Do not perform weighting of samples between output intervals. Default is False.
+.TP
 .BR \-d ", " \-\-divisor \fR=\fPint
 Divide statistics by this value. Defaults to 1. Useful if you want to
 convert latencies from milliseconds to seconds (\fBdivisor\fR=\fP1000\fR).
@@ -53,6 +56,21 @@ Enables warning messages printed to stderr, useful for debugging.
 Set this to the value of \fIFIO_IO_U_PLAT_GROUP_NR\fR as defined in
 \fPstat.h\fR if fio has been recompiled. Defaults to 19, the
 current value used in fio. See NOTES for more details.
+.TP
+.BR \-\-percentiles \fR=\fPstr
+Pass desired list of comma or colon separated percentiles to print.
+The default is "90.0:95.0:99.0", but min, median(50%) and max percentiles are always printed
+.TP
+.BR \-\-usbin
+Use to indicate to parser that histogram bin latencies values are in microseconds.
+The default is to use nanoseconds, but histogram logs from fio versions <= 2.99 are in microseconds.
+.TP
+.BR \-\-directions \fR=\fPstr
+By default, all directions (e.g read and write) histogram bins are combined
+producing one 'mixed' result.
+To produce independent directional results, pass some combination of
+\'rwtm\' characters with the \-\-directions\fR=\fPrwtm option.
+A \'dir\' column is added indicating the result direction for a row.
 
 .SH NOTES
 end-times are calculated to be uniform increments of the \fB\-\-interval\fR value given,
@@ -87,7 +105,8 @@ min / max seen by fio (and reported in *_clat.* with averaging turned off).
 .PP
 Average statistics use a standard weighted arithmetic mean.
 
-Percentile statistics are computed using the weighted percentile method as
+When --noweights option is false (the default)
+percentile statistics are computed using the weighted percentile method as
 described here: \fIhttps://en.wikipedia.org/wiki/Percentile#Weighted_percentile\fR.
 See weights() method for details on how weights are computed for individual
 samples. In process_interval() we further multiply by the height of each bin
