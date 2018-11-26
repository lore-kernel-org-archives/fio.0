Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH] workqueue: update IO counters promptly after handling IO
Date: Mon, 26 Nov 2018 11:15:02 -0500
Message-Id: <20181126161502.19992-1-vincentfu@gmail.com>
To: fio@vger.kernel.org, axboe@kernel.dk
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

Currently, IO submit worker threads only update parent IO counters when
the threads are idle or when the threads exit. When offload fio jobs are
assigned a restrictive CPU mask, this results in reporting and logging
problems. This patch updates parent IO counters more promptly upon
completing each IO which resolves the reporting and logging problems.

In the output below, notice the missing read data direction output in
the first, simple job and how it appropriately appears after the patch
is applied. In the second job with logging, notice the missing log
entries (unequal file sizes) in the first log and how entries are no
longer missing for the run with the patch applied.

*********************
*** WITHOUT PATCH ***
*********************
$ ./fio --name=test --io_submit_mode=offload --cpus_allowed=1 --filename=/dev/sda --size=10M
test: (g=0): rw=read, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=psync, iodepth=1
fio-3.12-19-g41dd
Starting 1 process

test: (groupid=0, jobs=1): err= 0: pid=19746: Mon Nov 26 10:37:42 2018
  lat (nsec)   : 750=13.44%, 1000=42.42%
  lat (usec)   : 2=39.88%, 4=1.56%, 10=0.23%, 20=0.20%, 50=1.02%
  lat (usec)   : 100=0.55%, 250=0.27%, 500=0.35%, 750=0.04%
  lat (msec)   : 10=0.04%
  cpu          : usr=30.30%, sys=0.00%, ctx=5126, majf=0, minf=3
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=2560,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):

Disk stats (read/write):
  sda: ios=45/0, merge=0/0, ticks=44/0, in_queue=44, util=20.51%

*********************
***** WITH PATCH ****
*********************
$ ./fio --name=test --io_submit_mode=offload --cpus_allowed=1 --filename=/dev/sda --size=10M
test: (g=0): rw=read, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=psync, iodepth=1
fio-3.12-8-gee63-dirty
Starting 1 process

test: (groupid=0, jobs=1): err= 0: pid=19754: Mon Nov 26 10:37:56 2018
  read: IOPS=77.6k, BW=303MiB/s (318MB/s)(10.0MiB/33msec)
    clat (nsec): min=588, max=5941.5k, avg=5705.48, stdev=120112.09
     lat (nsec): min=1745, max=5950.7k, avg=7302.87, stdev=120311.09
    clat percentiles (nsec):
     |  1.00th=[    628],  5.00th=[    668], 10.00th=[    700],
     | 20.00th=[    740], 30.00th=[    772], 40.00th=[    812],
     | 50.00th=[    852], 60.00th=[    908], 70.00th=[    972],
     | 80.00th=[   1064], 90.00th=[   1256], 95.00th=[   1592],
     | 99.00th=[  48896], 99.50th=[ 158720], 99.90th=[ 544768],
     | 99.95th=[ 651264], 99.99th=[5931008]
  lat (nsec)   : 750=23.28%, 1000=49.92%
  lat (usec)   : 2=22.77%, 4=1.05%, 10=0.16%, 20=0.51%, 50=1.33%
  lat (usec)   : 100=0.27%, 250=0.31%, 500=0.27%, 750=0.08%
  lat (msec)   : 10=0.04%
  cpu          : usr=6.25%, sys=25.00%, ctx=5127, majf=0, minf=3
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=2560,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   READ: bw=303MiB/s (318MB/s), 303MiB/s-303MiB/s (318MB/s-318MB/s), io=10.0MiB (10.5MB), run=33-33msec

Disk stats (read/write):
  sda: ios=45/0, merge=0/0, ticks=36/0, in_queue=36, util=20.92%

*********************
*** WITHOUT PATCH ***
*********************
$ ./fio-canonical/fio --name=test --direct=1 --filename=/dev/fioa --numjobs=4 --log_avg_msec=1000 --write_iops_log=test --time_based --runtime=10s --rw=read --bs=4k --cpus_allowed=1,3,2,7 --io_submit_mode=offload --group_reporting
test: (g=0): rw=read, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=psync, iodepth=1
...
fio-3.12-19-g41dd
Starting 4 processes
Jobs: 4 (f=4): [R(4)][100.0%][r=385MiB/s][r=98.7k IOPS][eta 00m:00s]
test: (groupid=0, jobs=4): err= 0: pid=22661: Mon Nov 26 08:51:19 2018
  read: IOPS=134k, BW=503MiB/s (527MB/s)(5029MiB/10001msec)
    clat (nsec): min=12481, max=73112, avg=20088.92, stdev=2744.19
     lat (nsec): min=15113, max=74716, avg=23846.94, stdev=3356.56
    clat percentiles (nsec):
     |  1.00th=[14016],  5.00th=[16320], 10.00th=[17024], 20.00th=[17792],
     | 30.00th=[18304], 40.00th=[19072], 50.00th=[20096], 60.00th=[20608],
     | 70.00th=[21376], 80.00th=[21888], 90.00th=[23424], 95.00th=[24704],
     | 99.00th=[28544], 99.50th=[29824], 99.90th=[33024], 99.95th=[34560],
     | 99.99th=[43264]
   bw (  KiB/s): min=126840, max=1711256, per=32.05%, avg=165065.08, stdev=210793.01, samples=60
   iops        : min=17773, max=213907, avg=39624.97, stdev=33794.49, samples=30
  lat (usec)   : 20=48.64%, 50=51.36%, 100=0.01%
  cpu          : usr=5.38%, sys=10.06%, ctx=1795113, majf=0, minf=63
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=1341011,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   READ: bw=503MiB/s (527MB/s), 503MiB/s-503MiB/s (527MB/s-527MB/s), io=5029MiB (5274MB), run=10001-10001msec

Disk stats (read/write):
  fioa: ios=1341011/0, merge=0/0, ticks=16916/0, in_queue=18236, util=91.46%

$ ls -l test_iops.?.log
-rw-r--r-- 1 root root  55 Nov 26 08:51 test_iops.1.log
-rw-r--r-- 1 root root 162 Nov 26 08:51 test_iops.2.log
-rw-r--r-- 1 root root 162 Nov 26 08:51 test_iops.3.log
-rw-r--r-- 1 root root 162 Nov 26 08:51 test_iops.4.log

$ cat test_iops.1.log
1000, 17773, 0, 0
3000, 71404, 0, 0
9000, 213907, 0, 0

*********************
***** WITH PATCH ****
*********************
$ ./fio/fio --name=test --direct=1 --filename=/dev/fioa --numjobs=4 --log_avg_msec=1000 --write_iops_log=test --time_based --runtime=10s --rw=read --bs=4k --cpus_allowed=1,3,2,7 --io_submit_mode=offload --group_reporting
test: (g=0): rw=read, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=psync, iodepth=1
...
fio-3.12-19-g41dd-dirty
Starting 4 processes
Jobs: 4 (f=4): [R(4)][100.0%][r=528MiB/s][r=135k IOPS][eta 00m:00s]
test: (groupid=0, jobs=4): err= 0: pid=22685: Mon Nov 26 08:51:56 2018
  read: IOPS=131k, BW=514MiB/s (539MB/s)(5137MiB/10001msec)
    clat (usec): min=12, max=184, avg=20.55, stdev= 4.05
     lat (usec): min=15, max=187, avg=24.61, stdev= 4.80
    clat percentiles (nsec):
     |  1.00th=[14016],  5.00th=[16512], 10.00th=[17280], 20.00th=[17792],
     | 30.00th=[18560], 40.00th=[19072], 50.00th=[20096], 60.00th=[20608],
     | 70.00th=[21120], 80.00th=[22144], 90.00th=[24448], 95.00th=[27008],
     | 99.00th=[38144], 99.50th=[39680], 99.90th=[52480], 99.95th=[54528],
     | 99.99th=[56576]
   bw (  KiB/s): min=94640, max=145392, per=24.96%, avg=131304.57, stdev=11668.56, samples=76
   iops        : min=23691, max=36200, avg=32774.75, stdev=2963.63, samples=36
  lat (usec)   : 20=49.59%, 50=50.24%, 100=0.17%, 250=0.01%
  cpu          : usr=5.20%, sys=9.76%, ctx=1794339, majf=0, minf=63
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=1315098,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   READ: bw=514MiB/s (539MB/s), 514MiB/s-514MiB/s (539MB/s-539MB/s), io=5137MiB (5387MB), run=10001-10001msec

Disk stats (read/write):
  fioa: ios=1315098/0, merge=0/0, ticks=17156/0, in_queue=20496, util=96.36%

$ ls -l test_iops.?.log
-rw-r--r-- 1 root root 162 Nov 26 08:51 test_iops.1.log
-rw-r--r-- 1 root root 162 Nov 26 08:51 test_iops.2.log
-rw-r--r-- 1 root root 162 Nov 26 08:51 test_iops.3.log
-rw-r--r-- 1 root root 162 Nov 26 08:51 test_iops.4.log

$ cat test_iops.1.log
1000, 27173, 0, 0
2000, 27186, 0, 0
3000, 34395, 0, 0
4000, 36200, 0, 0
5000, 36047, 0, 0
6000, 36043, 0, 0
7000, 36100, 0, 0
8000, 36121, 0, 0
9000, 36124, 0, 0

Fixes: https://www.spinics.net/lists/fio/msg07628.html
---
 workqueue.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/workqueue.c b/workqueue.c
index faed2452..b5959512 100644
--- a/workqueue.c
+++ b/workqueue.c
@@ -190,8 +190,6 @@ static void *worker_thread(void *data)
 				if (wq->wake_idle)
 					pthread_cond_signal(&wq->flush_cond);
 			}
-			if (wq->ops.update_acct_fn)
-				wq->ops.update_acct_fn(sw);
 
 			pthread_cond_wait(&sw->cond, &sw->lock);
 		} else {
@@ -200,11 +198,10 @@ handle_work:
 		}
 		pthread_mutex_unlock(&sw->lock);
 		handle_list(sw, &local_list);
+		if (wq->ops.update_acct_fn)
+			wq->ops.update_acct_fn(sw);
 	}
 
-	if (wq->ops.update_acct_fn)
-		wq->ops.update_acct_fn(sw);
-
 done:
 	sk_out_drop();
 	return NULL;
-- 
2.17.1


