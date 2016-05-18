Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:37937 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbcERMAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 18 May 2016 08:00:06 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1b308z-00055h-0L
	for fio@vger.kernel.org; Wed, 18 May 2016 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160518120002.5B1732C00C5@kernel.dk>
Date: Wed, 18 May 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 15a0c8ee4e1a5434075ebc2c9f48e96e5e892196:

  Windows crash in ctime_r() (2016-05-16 19:25:48 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 8c4693e2e578613f517dc42b38e204bf77fdab1d:

  add -A option for better stats (2016-05-17 18:48:30 -0400)

----------------------------------------------------------------
Ben England (1):
      add -A option for better stats

Jens Axboe (1):
      init: cleanup random inits

 init.c                | 35 +++++++++++++++-------------
 options.c             |  4 ++--
 tools/fiologparser.py | 64 +++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 85 insertions(+), 18 deletions(-)

---

Diff of recent changes:

diff --git a/init.c b/init.c
index e8c8afb..7166ea7 100644
--- a/init.c
+++ b/init.c
@@ -919,6 +919,23 @@ static int exists_and_not_file(const char *filename)
 	return 1;
 }
 
+static void init_rand_file_service(struct thread_data *td)
+{
+	unsigned long nranges = td->o.nr_files << FIO_FSERVICE_SHIFT;
+	const unsigned int seed = td->rand_seeds[FIO_RAND_FILE_OFF];
+
+	if (td->o.file_service_type == FIO_FSERVICE_ZIPF) {
+		zipf_init(&td->next_file_zipf, nranges, td->zipf_theta, seed);
+		zipf_disable_hash(&td->next_file_zipf);
+	} else if (td->o.file_service_type == FIO_FSERVICE_PARETO) {
+		pareto_init(&td->next_file_zipf, nranges, td->pareto_h, seed);
+		zipf_disable_hash(&td->next_file_zipf);
+	} else if (td->o.file_service_type == FIO_FSERVICE_GAUSS) {
+		gauss_init(&td->next_file_gauss, nranges, td->gauss_dev, seed);
+		gauss_disable_hash(&td->next_file_gauss);
+	}
+}
+
 static void td_fill_rand_seeds_internal(struct thread_data *td, bool use64)
 {
 	int i;
@@ -929,22 +946,8 @@ static void td_fill_rand_seeds_internal(struct thread_data *td, bool use64)
 
 	if (td->o.file_service_type == FIO_FSERVICE_RANDOM)
 		init_rand_seed(&td->next_file_state, td->rand_seeds[FIO_RAND_FILE_OFF], use64);
-	else if (td->o.file_service_type & __FIO_FSERVICE_NONUNIFORM) {
-		unsigned long nranges;
-
-		nranges = td->o.nr_files << FIO_FSERVICE_SHIFT;
-
-		if (td->o.file_service_type == FIO_FSERVICE_ZIPF) {
-			zipf_init(&td->next_file_zipf, nranges, td->zipf_theta, td->rand_seeds[FIO_RAND_FILE_OFF]);
-			zipf_disable_hash(&td->next_file_zipf);
-		} else if (td->o.file_service_type == FIO_FSERVICE_PARETO) {
-			pareto_init(&td->next_file_zipf, nranges, td->pareto_h, td->rand_seeds[FIO_RAND_FILE_OFF]);
-			zipf_disable_hash(&td->next_file_zipf);
-		} else if (td->o.file_service_type == FIO_FSERVICE_GAUSS) {
-			gauss_init(&td->next_file_gauss, nranges, td->gauss_dev, td->rand_seeds[FIO_RAND_FILE_OFF]);
-			gauss_disable_hash(&td->next_file_gauss);
-		}
-	}
+	else if (td->o.file_service_type & __FIO_FSERVICE_NONUNIFORM)
+		init_rand_file_service(td);
 
 	init_rand_seed(&td->file_size_state, td->rand_seeds[FIO_RAND_FILE_SIZE_OFF], use64);
 	init_rand_seed(&td->trim_state, td->rand_seeds[FIO_RAND_TRIM_OFF], use64);
diff --git a/options.c b/options.c
index a925663..07589c4 100644
--- a/options.c
+++ b/options.c
@@ -788,7 +788,7 @@ static int str_fst_cb(void *data, const char *str)
 		break;
 	case FIO_FSERVICE_GAUSS:
 		if (val < 0.00 || val >= 100.00) {
-                          log_err("fio: normal deviation out of range (0 < input < 100.0  )\n");
+                          log_err("fio: normal deviation out of range (0 <= input < 100.0)\n");
                           return 1;
 		}
 		if (parse_dryrun())
@@ -1048,7 +1048,7 @@ static int str_random_distribution_cb(void *data, const char *str)
 		td->o.pareto_h.u.f = val;
 	} else {
 		if (val < 0.00 || val >= 100.0) {
-			log_err("fio: normal deviation out of range (0 < input < 100.0)\n");
+			log_err("fio: normal deviation out of range (0 <= input < 100.0)\n");
 			return 1;
 		}
 		if (parse_dryrun())
diff --git a/tools/fiologparser.py b/tools/fiologparser.py
index 0574099..00e4d30 100755
--- a/tools/fiologparser.py
+++ b/tools/fiologparser.py
@@ -14,12 +14,16 @@
 # to see per-interval average completion latency.
 
 import argparse
+import numpy
+import scipy
 
 def parse_args():
     parser = argparse.ArgumentParser()
     parser.add_argument('-i', '--interval', required=False, type=int, default=1000, help='interval of time in seconds.')
     parser.add_argument('-d', '--divisor', required=False, type=int, default=1, help='divide the results by this value.')
     parser.add_argument('-f', '--full', dest='full', action='store_true', default=False, help='print full output.')
+    parser.add_argument('-A', '--all', dest='allstats', action='store_true', default=False, 
+                        help='print all stats for each interval.')
     parser.add_argument('-a', '--average', dest='average', action='store_true', default=False, help='print the average for each interval.')
     parser.add_argument('-s', '--sum', dest='sum', action='store_true', default=False, help='print the sum for each interval.')
     parser.add_argument("FILE", help="collectl log output files to parse", nargs="+")
@@ -70,6 +74,57 @@ def print_averages(ctx, series):
         start += ctx.interval
         end += ctx.interval
 
+# FIXME: this routine is computationally inefficient
+# and has O(N^2) behavior
+# it would be better to make one pass through samples
+# to segment them into a series of time intervals, and
+# then compute stats on each time interval instead.
+# to debug this routine, use
+#   # sort -n -t ',' -k 2 small.log
+# on your input.
+# Sometimes scipy interpolates between two values to get a percentile
+
+def my_extend( vlist, val ):
+    vlist.extend(val)
+    return vlist
+
+array_collapser = lambda vlist, val:  my_extend(vlist, val) 
+
+def print_all_stats(ctx, series):
+    ftime = get_ftime(series)
+    start = 0 
+    end = ctx.interval
+    print('start-time, samples, min, avg, median, 90%, 95%, 99%, max')
+    while (start < ftime):  # for each time interval
+        end = ftime if ftime < end else end
+        sample_arrays = [ s.get_samples(start, end) for s in series ]
+        samplevalue_arrays = []
+        for sample_array in sample_arrays:
+            samplevalue_arrays.append( 
+                [ sample.value for sample in sample_array ] )
+        #print('samplevalue_arrays len: %d' % len(samplevalue_arrays))
+        #print('samplevalue_arrays elements len: ' + \
+               #str(map( lambda l: len(l), samplevalue_arrays)))
+        # collapse list of lists of sample values into list of sample values
+        samplevalues = reduce( array_collapser, samplevalue_arrays, [] )
+        #print('samplevalues: ' + str(sorted(samplevalues)))
+        # compute all stats and print them
+        myarray = scipy.fromiter(samplevalues, float)
+        mymin = scipy.amin(myarray)
+        myavg = scipy.average(myarray)
+        mymedian = scipy.median(myarray)
+        my90th = scipy.percentile(myarray, 90)
+        my95th = scipy.percentile(myarray, 95)
+        my99th = scipy.percentile(myarray, 99)
+        mymax = scipy.amax(myarray)
+        print( '%f, %d, %f, %f, %f, %f, %f, %f, %f' % (
+            start, len(samplevalues), 
+            mymin, myavg, mymedian, my90th, my95th, my99th, mymax))
+
+        # advance to next interval
+        start += ctx.interval
+        end += ctx.interval
+
 
 def print_default(ctx, series):
     ftime = get_ftime(series)
@@ -112,6 +167,13 @@ class TimeSeries():
             self.last = sample
         self.samples.append(sample)
 
+    def get_samples(self, start, end):
+        sample_list = []
+        for s in self.samples:
+            if s.start >= start and s.end <= end:
+                sample_list.append(s)
+        return sample_list
+
     def get_value(self, start, end):
         value = 0
         for sample in self.samples:
@@ -147,6 +209,8 @@ if __name__ == '__main__':
         print_averages(ctx, series)
     elif ctx.full:
         print_full(ctx, series)
+    elif ctx.allstats:
+        print_all_stats(ctx, series)
     else:
         print_default(ctx, series)
 
