Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: Vincent Fu <vincentfu@gmail.com>
Subject: [PATCH 1/3] stat: change indentation of the lat (nsec/usec/msec) section in the normal output
Date: Mon, 14 Aug 2017 14:59:42 -0400
Message-Id: <1502737184-25885-2-git-send-email-vincentfu@gmail.com>
In-Reply-To: <1502737184-25885-1-git-send-email-vincentfu@gmail.com>
References: <1502737184-25885-1-git-send-email-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: vincentfu@gmail.com, Vincent Fu <vincent.fu@sandisk.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@sandisk.com>

With mixed IO the normal output looks like:

$ ./fio --name=test --ioengine=null --time_based --runtime=5s --size=1G --rw=randrw

test: (g=0): rw=randrw, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=null, iodepth=1
fio-2.21-14-ge22fd-dirty
Starting 1 process
Jobs: 1 (f=1): [m(1)][100.0%][r=5749MiB/s,w=5748MiB/s][r=1472k,w=1472k IOPS][eta 00m:00s]
test: (groupid=0, jobs=1): err= 0: pid=16555: Tue Jun 20 16:08:00 2017
   read: IOPS=1488k, BW=5814MiB/s (6096MB/s)(28.4GiB/5001msec)
...
  write: IOPS=1488k, BW=5812MiB/s (6094MB/s)(28.4GiB/5001msec)
...
    lat (nsec) : 20=15.47%, 50=83.90%, 100=0.49%, 250=0.11%, 500=0.02%
    lat (nsec) : 750=0.01%, 1000=0.01%
    lat (usec) : 2=0.01%, 4=0.01%, 10=0.01%, 20=0.01%, 50=0.01%
    lat (usec) : 100=0.01%, 250=0.01%, 500=0.01%
  cpu          : usr=99.84%, sys=0.00%, ctx=181, majf=0, minf=7
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwt: total=7443094,7440426,0, short=0,0,0, dropped=0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1
...

The 'lat (nsec) : 20=15.47%...' section is indented inside the 'write' block,
giving the impression that these describe only write latencies when they are
actually latencies for all of the IOs in the job.

With this patch the normal output looks like:

$ ./fio --name=test --ioengine=null --time_based --runtime=5s --size=1G --rw=randrw

test: (g=0): rw=randrw, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=null, iodepth=1
fio-2.21-14-g4ed22a-dirty
Starting 1 process
Jobs: 1 (f=1): [m(1)][100.0%][r=5879MiB/s,w=5880MiB/s][r=1505k,w=1505k IOPS][eta 00m:00s]
test: (groupid=0, jobs=1): err= 0: pid=16686: Tue Jun 20 16:12:43 2017
   read: IOPS=1523k, BW=5950MiB/s (6239MB/s)(29.1GiB/5001msec)
    clat (nsec): min=15, max=114599, avg=25.38, stdev=139.48
     lat (nsec): min=47, max=257952, avg=58.18, stdev=269.48
    clat percentiles (nsec):
     |  1.00th=[   18],  5.00th=[   19], 10.00th=[   20], 20.00th=[   21],
     | 30.00th=[   22], 40.00th=[   23], 50.00th=[   23], 60.00th=[   24],
     | 70.00th=[   26], 80.00th=[   27], 90.00th=[   27], 95.00th=[   28],
     | 99.00th=[   42], 99.50th=[   45], 99.90th=[  101], 99.95th=[  165],
     | 99.99th=[ 6368]
   bw (  MiB/s): min= 5722, max= 6081, per=0.10%, avg=5950.14, stdev=126.61
  write: IOPS=1523k, BW=5948MiB/s (6236MB/s)(29.0GiB/5001msec)
    clat (nsec): min=15, max=127752, avg=25.56, stdev=158.32
     lat (nsec): min=63, max=230121, avg=79.84, stdev=317.00
    clat percentiles (nsec):
     |  1.00th=[   18],  5.00th=[   19], 10.00th=[   20], 20.00th=[   21],
     | 30.00th=[   22], 40.00th=[   23], 50.00th=[   23], 60.00th=[   25],
     | 70.00th=[   26], 80.00th=[   27], 90.00th=[   27], 95.00th=[   28],
     | 99.00th=[   42], 99.50th=[   46], 99.90th=[  105], 99.95th=[  175],
     | 99.99th=[ 6624]
   bw (  MiB/s): min= 5727, max= 6079, per=0.10%, avg=5947.07, stdev=125.05
  lat (nsec)   : 20=9.40%, 50=90.27%, 100=0.22%, 250=0.08%, 500=0.01%
  lat (nsec)   : 750=0.01%, 1000=0.01%
  lat (usec)   : 2=0.01%, 4=0.01%, 10=0.01%, 20=0.01%, 50=0.01%
  lat (usec)   : 100=0.01%, 250=0.01%
  cpu          : usr=99.84%, sys=0.00%, ctx=150, majf=0, minf=7
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwt: total=7617184,7614394,0, short=0,0,0, dropped=0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   READ: bw=5950MiB/s (6239MB/s), 5950MiB/s-5950MiB/s (6239MB/s-6239MB/s), io=29.1GiB (31.2GB), run=5001-5001msec
  WRITE: bw=5948MiB/s (6236MB/s), 5948MiB/s-5948MiB/s (6236MB/s-6236MB/s), io=29.0GiB (31.2GB), run=5001-5001msec
---
 stat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/stat.c b/stat.c
index aebd107..4aa9cb8 100644
--- a/stat.c
+++ b/stat.c
@@ -520,7 +520,7 @@ static int show_lat(double *io_u_lat, int nr, const char **ranges,
 		if (new_line) {
 			if (line)
 				log_buf(out, "\n");
-			log_buf(out, "    lat (%s) : ", msg);
+			log_buf(out, "  lat (%s)   : ", msg);
 			new_line = 0;
 			line = 0;
 		}
-- 
2.7.4


