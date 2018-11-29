Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH] gettime: use nsec in get_cycles_per_msec division
Date: Thu, 29 Nov 2018 13:14:18 -0500
Message-Id: <20181129181418.24788-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

Since we now have ntime_since() we can use nsec in the division for
get_cycles_per_msec(). This makes the cycles_per_msec value that fio
ultimately uses more stable since fio will no longer be using values
truncated to usec.

While we're here also modify some debug prints to make it explicit that
fio ultimately uses a trimmed mean in its time calculations.

On platforms where only gettimeofday() is available this will be no
worse than the original code since we will revert back to using times
truncated to usec.

With the patch, the last three digits of the trimmed mean have a tight
range from 784-786. Without the patch, the corresponding value (labeled
avg) has a much wider range from 821-958. Notice also that the standard
error S is an order of magnitude smaller with the patch.

*** WITH PATCH ***
$ ./fio --debug=time --cpuclock-test | grep mean
time     315   min=3466785, max=3466796, mean=3466789.120000, S=0.057234, N=50
time     315   trimmed mean=3466789, N=29
$ ./fio --debug=time --cpuclock-test | grep mean
time     329   min=3466784, max=3466795, mean=3466789.480000, S=0.053641, N=50
time     329   trimmed mean=3466788, N=36
$ ./fio --debug=time --cpuclock-test | grep mean
time     343   min=3466786, max=3466794, mean=3466789.220000, S=0.036654, N=50
time     343   trimmed mean=3466788, N=42
$ ./fio --debug=time --cpuclock-test | grep mean
time     357   min=3466785, max=3466794, mean=3466789.080000, S=0.053580, N=50
time     357   trimmed mean=3466788, N=33
$ ./fio --debug=time --cpuclock-test | grep mean
time     371   min=3466785, max=3466794, mean=3466789.600000, S=0.043519, N=50
time     371   trimmed mean=3466789, N=36
$ ./fio --debug=time --cpuclock-test | grep mean
time     385   min=3466785, max=3466794, mean=3466789.280000, S=0.052534, N=50
time     385   trimmed mean=3466789, N=32
$ ./fio --debug=time --cpuclock-test | grep mean
time     407   min=3466786, max=3466796, mean=3466789.520000, S=0.042616, N=50
time     407   trimmed mean=3466789, N=41
$ ./fio --debug=time --cpuclock-test | grep mean
time     513   min=3466785, max=3466796, mean=3466789.220000, S=0.051316, N=50
time     513   trimmed mean=3466789, N=35

*** WIHTOUT PATCH ***
$ ./fio-3.11 --debug=time --cpuclock-test | grep 'mean\|avg'
time     439   avg: 3466821
time     439   min=3466790, max=3467006, mean=3466838.060000, S=0.959748
$ ./fio-3.11 --debug=time --cpuclock-test | grep 'mean\|avg'
time     455   avg: 3466958
time     455   min=3466796, max=3466996, mean=3466945.880000, S=0.789178
$ ./fio-3.11 --debug=time --cpuclock-test | grep 'mean\|avg'
time     469   avg: 3466887
time     469   min=3466790, max=3466984, mean=3466887.500000, S=0.825069
$ ./fio-3.11 --debug=time --cpuclock-test | grep 'mean\|avg'
time     485   avg: 3466951
time     485   min=3466818, max=3466996, mean=3466939.420000, S=0.873334
$ ./fio-3.11 --debug=time --cpuclock-test | grep 'mean\|avg'
time     499   avg: 3466957
time     499   min=3466793, max=3467009, mean=3466950.140000, S=0.764626
$ ./fio-3.11 --debug=time --cpuclock-test | grep 'mean\|avg'
time     608   avg: 3466954
time     608   min=3466818, max=3466981, mean=3466937.040000, S=0.862232
---
 gettime.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/gettime.c b/gettime.c
index 7702193d..272a3e62 100644
--- a/gettime.c
+++ b/gettime.c
@@ -239,13 +239,13 @@ static unsigned long get_cycles_per_msec(void)
 		__fio_gettime(&e);
 		c_e = get_cpu_clock();
 
-		elapsed = utime_since(&s, &e);
-		if (elapsed >= 1280)
+		elapsed = ntime_since(&s, &e);
+		if (elapsed >= 1280000)
 			break;
 	} while (1);
 
 	fio_clock_source = old_cs;
-	return (c_e - c_s) * 1000 / elapsed;
+	return (c_e - c_s) * 1000000 / elapsed;
 }
 
 #define NR_TIME_ITERS	50
@@ -298,10 +298,10 @@ static int calibrate_cpu_clock(void)
 
 	avg /= samples;
 	cycles_per_msec = avg;
-	dprint(FD_TIME, "avg: %llu\n", (unsigned long long) avg);
-	dprint(FD_TIME, "min=%llu, max=%llu, mean=%f, S=%f\n",
+	dprint(FD_TIME, "min=%llu, max=%llu, mean=%f, S=%f, N=%d\n",
 			(unsigned long long) minc,
-			(unsigned long long) maxc, mean, S);
+			(unsigned long long) maxc, mean, S, NR_TIME_ITERS);
+	dprint(FD_TIME, "trimmed mean=%llu, N=%d\n", (unsigned long long) avg, samples);
 
 	max_ticks = MAX_CLOCK_SEC * cycles_per_msec * 1000ULL;
 	max_mult = ULLONG_MAX / max_ticks;
-- 
2.17.1


