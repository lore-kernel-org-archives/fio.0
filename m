Return-Path: <fio-owner@vger.kernel.org>
Received: from [207.46.163.210] ([207.46.163.210]:22784 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751845AbaBZOYF convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 26 Feb 2014 09:24:05 -0500
From: "Lamkin, Eric" <Eric.Lamkin@lsi.com>
Subject: RE: fio replay
Date: Wed, 26 Feb 2014 14:23:27 +0000
Message-ID: <934f861a97f2443aa35296c2d6d8c848@BN1PR07MB437.namprd07.prod.outlook.com>
References: <651fd21aaf304da0b24902febae3c345@BN1PR07MB437.namprd07.prod.outlook.com>
 <76F46F78-8F5A-45CF-BBCE-3ADC63AFF541@nellans.org>
In-Reply-To: <76F46F78-8F5A-45CF-BBCE-3ADC63AFF541@nellans.org>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: David Nellans <david@nellans.org>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

David,

Thanks for responding.
I sent the below out last week but didn't get a reply so thought I'd try a simpler 'what works' tactic this morning.
As seen in the below I'm using 2.0.10.

Eric
--------------

Deleted formatting.

From: Lamkin, Eric
Sent: Thursday, February 20, 2014 9:36 AM
To: 'fio@vger.kernel.org'
Subject: fio replay

I'm evaluating fio for replay of Linux blktrace workloads.

So far the whole workload is not being replayed.

I'm wondering if I can get some pointers on what I may be doing wrong.

Here are some details:

Methodology:
. Capture the IO workload with blktrace
- Mount the debug file system on the host with the IO workload to capture . mount -t debugfs debugfs /sys/kernel/debug
- Start blktrace for all devices of interest . blktrace -d /dev/sdb /dev/sdca
- Stop blktrace once the IO workload of interest is complete . Ctrl-C
- Convert the blktrace file set to a single binary with blkparse . blkparse sdb sdca -O -d blkparseall.bin
- Create a blkparse .bin per device (may be required for device mapping) . blkparse /dev/sdb -O -d blkparsesdb.bin . blkparse /dev/sdca -O -d blkparsesdca.bin . . . .
- Capture the partition file from the same host . cat /proc/partitions > partitions.txt


Observation:
. Something is preventing the entire blktrace from replaying.
. During replay a time remaining counter begins decrementing from 2+ minutes.
. At some point the replay comes to a conclusion with time remaining on the clock.
. Do not know if the following message from fio is a clue to why the full replay does not occur. fio: file hash not empty on exit 


The blktrace was captured on the source host for /dev/sdc and /dev/sdd.
Replay occurs on the replay host to /dev/sdc and /dev/sdd.

Partitions on source host.
[root@x3650M4 Profiler]# cat /home/Documents/TraceFiles/MR15couchbase/partitions1MR15.txt 
major minor  #blocks  name
   8       32 1999699968 sdc
   8       48 1142685696 sdd
   8       16  488386584 sdb
   8        0  488386584 sda
   8        1     512000 sda1
   8        2  487873536 sda2
253        0   52428800 dm-0
253        1   16482304 dm-1
253        2  418959360 dm-2

Blktrace on the source host.
[root@Megaraid15 tracefiles]# blktrace -d /dev/sdc /dev/sdd
^C=== sdc ===
  CPU  0:              4755036 events,   222893 KiB data
  CPU  1:              4597591 events,   215513 KiB data
  CPU  2:               742267 events,    34794 KiB data
  CPU  3:               821213 events,    38495 KiB data
  CPU  4:               398054 events,    18659 KiB data
  CPU  5:               468293 events,    21952 KiB data
  CPU  6:               211068 events,     9894 KiB data
  CPU  7:               259636 events,    12171 KiB data
  CPU  8:               118142 events,     5538 KiB data
  CPU  9:               152712 events,     7159 KiB data
  CPU 10:                43662 events,     2047 KiB data
  CPU 11:                60687 events,     2845 KiB data
  CPU 12:                34881 events,     1636 KiB data
  CPU 13:                46452 events,     2178 KiB data
  CPU 14:                23514 events,     1103 KiB data
  CPU 15:                26782 events,     1256 KiB data
  CPU 16:              2978005 events,   139594 KiB data
  CPU 17:              3138535 events,   147119 KiB data
  CPU 18:                70275 events,     3295 KiB data
  CPU 19:               105291 events,     4936 KiB data
  CPU 20:                54002 events,     2532 KiB data
  CPU 21:                50163 events,     2352 KiB data
  CPU 22:                38882 events,     1823 KiB data
  CPU 23:                31927 events,     1497 KiB data
  CPU 24:                19594 events,      919 KiB data
  CPU 25:                23753 events,     1114 KiB data
  CPU 26:                10676 events,      501 KiB data
  CPU 27:                12503 events,      587 KiB data
  CPU 28:                 1632 events,       77 KiB data
  CPU 29:                 9099 events,      427 KiB data
  CPU 30:                 5472 events,      257 KiB data
  CPU 31:                 3983 events,      187 KiB data
  Total:              19313782 events (dropped 30207),   905335 KiB data
=== sdd ===
  CPU  0:                    1 events,        1 KiB data
  CPU  1:                    0 events,        0 KiB data
  CPU  2:                    0 events,        0 KiB data
  CPU  3:                    0 events,        0 KiB data
  CPU  4:                    0 events,        0 KiB data
  CPU  5:                    0 events,        0 KiB data
  CPU  6:                    0 events,        0 KiB data
  CPU  7:                    0 events,        0 KiB data
  CPU  8:                    0 events,        0 KiB data
  CPU  9:                    0 events,        0 KiB data
  CPU 10:                    0 events,        0 KiB data
  CPU 11:                    0 events,        0 KiB data
  CPU 12:                    0 events,        0 KiB data
  CPU 13:                    0 events,        0 KiB data
  CPU 14:                    0 events,        0 KiB data
  CPU 15:                    0 events,        0 KiB data
  CPU 16:                    0 events,        0 KiB data
  CPU 17:                    0 events,        0 KiB data
  CPU 18:                    0 events,        0 KiB data
  CPU 19:                    0 events,        0 KiB data
  CPU 20:                    0 events,        0 KiB data
 CPU 21:                    0 events,        0 KiB data
  CPU 22:                    0 events,        0 KiB data
  CPU 23:                    0 events,        0 KiB data
  CPU 24:                    0 events,        0 KiB data
  CPU 25:                    0 events,        0 KiB data
  CPU 26:                    0 events,        0 KiB data
  CPU 27:                    0 events,        0 KiB data
  CPU 28:                    0 events,        0 KiB data
  CPU 29:                    0 events,        0 KiB data
  CPU 30:                    0 events,        0 KiB data
  CPU 31:                    0 events,        0 KiB data
  Total:                     1 events (dropped 0),        1 KiB data
You have 30207 (  0.2%) dropped events
Consider using a larger buffer size (-b) and/or more buffers (-n)


Partitions on replay host.
[root@x3650M4 Profiler]# cat /proc/partitions 
major minor  #blocks  name
   8        0  291991552 sda
   8        1     204800 sda1
   8        2     512000 sda2
   8        3  291272704 sda3
253        0   52428800 dm-0
253        1    8175616 dm-1
253        2  230666240 dm-2
   8       16   47185920 sdb
   8       32 1999699968 sdc
   8       48 1142685696 sdd

Since the partitions match for the devices traced no replay_redirect is used.

Results w/o replay_no_stall.
[root@x3650M4 MR15couchbase]# fio --name=rp1 --ioengine=libaio --iodepth=16 --read_iolog=bprun1all.bin 
rp1: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=16
fio-2.0.10
Starting 1 process
got timestamp notify: 4000001, 0
got timestamp notify: 4000001, 0
Jobs: 1 (f=1): [W] [27.1% done] [0K/70636K/0K /s] [0 /17.7K/0  iops] [eta 01m:02s]
rp1: (groupid=0, jobs=1): err= 0: pid=14710: Fri Jan 31 15:36:29 2014
  write: io=1535.6MB, bw=73954KB/s, iops=18488 , runt= 21262msec
    slat (usec): min=4 , max=1156 , avg=13.89, stdev= 6.02
    clat (usec): min=4 , max=387196 , avg=520.86, stdev=2425.91
     lat (usec): min=49 , max=387211 , avg=535.31, stdev=2425.96
    clat percentiles (usec):
     |  1.00th=[   43],  5.00th=[   60], 10.00th=[   92], 20.00th=[  143],
     | 30.00th=[  183], 40.00th=[  278], 50.00th=[  322], 60.00th=[  588],
     | 70.00th=[  740], 80.00th=[  812], 90.00th=[  948], 95.00th=[ 1272],
     | 99.00th=[ 1800], 99.50th=[ 2096], 99.90th=[ 2800], 99.95th=[ 3664],
     | 99.99th=[21632]
    lat (usec) : 10=0.01%, 20=0.01%, 50=3.43%, 100=7.59%, 250=25.49%
    lat (usec) : 500=16.89%, 750=17.87%, 1000=19.45%
    lat (msec) : 2=8.63%, 4=0.60%, 10=0.03%, 20=0.01%, 50=0.01%
    lat (msec) : 500=0.01%
  cpu          : usr=6.21%, sys=27.22%, ctx=63452, majf=0, minf=18
  IO depths    : 1=6.1%, 2=12.0%, 4=24.0%, 8=19.2%, 16=38.6%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=86.6%, 8=2.6%, 16=10.8%, 32=0.0%, 64=0.0%, >=64=0.0%
    issued    : total=r=0/w=393102/d=0, short=r=0/w=0/d=0
Run status group 0 (all jobs):
  WRITE: io=1535.6MB, aggrb=73953KB/s, minb=73953KB/s, maxb=73953KB/s, mint=21262msec, maxt=21262msec
fio: file hash not empty on exit

Blktrace of replay.
[root@x3650M4 cbreplay1]# blktrace /dev/sdc /dev/sdd
^C=== sdc ===
  CPU  0:              5952393 events,   279019 KiB data
  CPU  1:                11609 events,      545 KiB data
  CPU  2:                10868 events,      510 KiB data
  CPU  3:                 4514 events,      212 KiB data
  CPU  4:                10245 events,      481 KiB data
  CPU  5:                  220 events,       11 KiB data
  CPU  6:               129295 events,     6061 KiB data
  CPU  7:                 5353 events,      251 KiB data
  CPU  8:                 6251 events,      294 KiB data
  CPU  9:                  680 events,       32 KiB data
  CPU 10:                   22 events,        2 KiB data
  CPU 11:                    0 events,        0 KiB data
  Total:               6131450 events (dropped 0),   287412 KiB data
=== sdd ===
  CPU  0:                    0 events,        0 KiB data
  CPU  1:                    0 events,        0 KiB data
  CPU  2:                    1 events,        1 KiB data
  CPU  3:                    0 events,        0 KiB data
  CPU  4:                    0 events,        0 KiB data
  CPU  5:                    0 events,        0 KiB data
  CPU  6:                    0 events,        0 KiB data
  CPU  7:                    0 events,        0 KiB data
  CPU  8:                    0 events,        0 KiB data
  CPU  9:                    0 events,        0 KiB data
  CPU 10:                    0 events,        0 KiB data
  CPU 11:                    0 events,        0 KiB data
  Total:                     1 events (dropped 0),        1 KiB data

Note, replay host has fewer processors than original host
sdc 19,313,782 original events, 6,131,450  replay events
sdc 905,335 KiB data, 287,412 KiB replay data 


Using replay_no_stall ran more quickly but still not completely.

[root@x3650M4 MR15couchbase]# fio --name=rp1 --ioengine=libaio --iodepth=16 --replay_no_stall=1 --read_iolog=bprun1all.bin 
rp1: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=16
fio-2.0.10
Starting 1 process
got timestamp notify: 4000001, 0
got timestamp notify: 4000001, 0
Jobs: 1 (f=1): [W] [41.2% done] [0K/277.2M/0K /s] [0 /70.1K/0  iops] [eta 00m:20s]        
rp1: (groupid=0, jobs=1): err= 0: pid=5680: Wed Feb  5 09:23:14 2014
  write: io=1535.6MB, bw=245459KB/s, iops=61364 , runt=  6406msec
    slat (usec): min=4 , max=4028 , avg= 9.47, stdev=11.76
    clat (usec): min=2 , max=4234 , avg=156.59, stdev=73.09
     lat (usec): min=41 , max=4338 , avg=166.32, stdev=74.21
    clat percentiles (usec):
     |  1.00th=[   59],  5.00th=[   79], 10.00th=[   93], 20.00th=[  112],
     | 30.00th=[  129], 40.00th=[  141], 50.00th=[  155], 60.00th=[  167],
     | 70.00th=[  175], 80.00th=[  187], 90.00th=[  219], 95.00th=[  249],
     | 99.00th=[  302], 99.50th=[  338], 99.90th=[  836], 99.95th=[ 1688],
     | 99.99th=[ 1992]
    lat (usec) : 4=0.01%, 10=0.01%, 50=0.21%, 100=12.80%, 250=82.10%
    lat (usec) : 500=4.69%, 750=0.08%, 1000=0.02%
    lat (msec) : 2=0.08%, 4=0.01%, 10=0.01%
  cpu          : usr=11.25%, sys=63.68%, ctx=87243, majf=1, minf=19
  IO depths    : 1=6.1%, 2=12.0%, 4=24.0%, 8=19.2%, 16=38.6%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=86.6%, 8=2.6%, 16=10.8%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=393102/d=0, short=r=0/w=0/d=0
Run status group 0 (all jobs):
  WRITE: io=1535.6MB, aggrb=245458KB/s, minb=245458KB/s, maxb=245458KB/s, mint=6406msec, maxt=6406msec
fio: file hash not empty on exit

Blktrace of replay with replay_no_stall.
[root@x3650M4 cbreplay2]# blktrace -d /dev/sdc /dev/sdd
^C=== sdc ===
  CPU  0:              5639178 events,   264337 KiB data
  CPU  1:               131297 events,     6155 KiB data
  CPU  2:                37969 events,     1780 KiB data
  CPU  3:                17794 events,      835 KiB data
  CPU  4:                    0 events,        0 KiB data
  CPU  5:                 3364 events,      158 KiB data
  CPU  6:               151797 events,     7116 KiB data
  CPU  7:                 9839 events,      462 KiB data
  CPU  8:                 8902 events,      418 KiB data
  CPU  9:                11832 events,      555 KiB data
  CPU 10:                 9135 events,      429 KiB data
  CPU 11:                    0 events,        0 KiB data
  Total:               6021107 events (dropped 0),   282240 KiB data
=== sdd ===
  CPU  0:                    0 events,        0 KiB data
  CPU  1:                    0 events,        0 KiB data
  CPU  2:                    0 events,        0 KiB data
  CPU  3:                    0 events,        0 KiB data
  CPU  4:                    0 events,        0 KiB data
  CPU  5:                    0 events,        0 KiB data
  CPU  6:                    0 events,        0 KiB data
  CPU  7:                    0 events,        0 KiB data
  CPU  8:                    0 events,        0 KiB data
  CPU  9:                    1 events,        1 KiB data
  CPU 10:                    0 events,        0 KiB data
  CPU 11:                    0 events,        0 KiB data
  Total:                     1 events (dropped 0),        1 KiB data

Original to replay blktrace analysis comparison (based on completion operations)
Original                  Replay w/o no_stall       Replay w/no_stall
132.5 seconds             23.2 seconds              6.66 seconds
2 CPUs (0,1)              1 CPU (0)                 1 CPU (0)
100% write                99.98% write              99.98% write
3,842,340,968 blk range    3,999,399,928 blk range    3,999,399,928 blk range
817,103 IOs               393,185 IOs               393,185 IOs
11,863,200 blocks         3,145,480 blocks           3,145,480 blocks
248,142 seq runs           78,502 seq runs           78,511 seq runs
10,661,656 seq blocks      2,972,672 seq blocks      2,972,312 seq blocks
83.2% seq IOs             94.5% seq IOs             94.5% seq IOs
89.9% seq bytes           94.5% seq bytes           94.5% seq bytes

Note, fio replay uses blktrace queue vs completion operations
The blktrace file filtered for queue operations had to be split to analyze in Excel 

Original to replay blktrace analysis comparison (based on queue operations)
Original                  Replay w/o no_stall       Replay w/no_stall
132.5 seconds             23.2 seconds              6.66 seconds
32 CPUs (0-31)            11 CPUs (0-10)            10 CPUs (0-3,5-10)
100% write                99.98% write              99.98% write
3,842,340,968 blk range    3,999,399,928 blk range    3,999,399,928 blk range
1,482,813 operations      393,185 operations        393,185 operations
11,862,504 blocks         3,145,480 blocks           3,145,480 blocks
254,458 seq runs           78,508 seq runs           78,508 seq runs
10,818,640 seq blocks      2,972,816 seq blocks      2,972,816 seq blocks
91.2% seq IOs             94.5% seq IOs             94.5% seq IOs
91.2% seq bytes           94.5% seq bytes           94.5% seq bytes

Changing iodepth to 12 to match # cores on replay host.  Did not resolve issue.
[root@x3650M4 MR15couchbase]# fio --name=rp1 --ioengine=libaio --iodepth=12 --read_iolog=bprun1all.bin
rp1: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=12
fio-2.0.10
Starting 1 process
got timestamp notify: 4000001, 0
got timestamp notify: 4000001, 0
Jobs: 1 (f=1): [W] [31.0% done] [0K/85676K/0K /s] [0 /21.5K/0  iops] [eta 01m:09s]        
rp1: (groupid=0, jobs=1): err= 0: pid=27491: Tue Feb 11 09:19:56 2014
  write: io=1535.6MB, bw=67315KB/s, iops=16828 , runt= 23359msec
    slat (usec): min=5 , max=4580 , avg=19.69, stdev=18.13
    clat (usec): min=4 , max=18051 , avg=477.41, stdev=429.40
     lat (usec): min=43 , max=18063 , avg=497.81, stdev=430.40
    clat percentiles (usec):
     |  1.00th=[   45],  5.00th=[   50], 10.00th=[   92], 20.00th=[  151],
     | 30.00th=[  195], 40.00th=[  278], 50.00th=[  294], 60.00th=[  510],
     | 70.00th=[  668], 80.00th=[  796], 90.00th=[  932], 95.00th=[ 1288],
     | 99.00th=[ 1768], 99.50th=[ 2096], 99.90th=[ 2832], 99.95th=[ 3472],
     | 99.99th=[ 7456]
    lat (usec) : 10=0.01%, 20=0.01%, 50=4.72%, 100=7.40%, 250=25.11%
    lat (usec) : 500=22.40%, 750=15.50%, 1000=15.72%
    lat (msec) : 2=8.53%, 4=0.57%, 10=0.03%, 20=0.01%
  cpu          : usr=5.68%, sys=35.42%, ctx=60638, majf=1, minf=19
  IO depths    : 1=6.1%, 2=12.0%, 4=24.0%, 8=57.9%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=88.1%, 8=2.3%, 16=9.6%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=393102/d=0, short=r=0/w=0/d=0
Run status group 0 (all jobs):
  WRITE: io=1535.6MB, aggrb=67314KB/s, minb=67314KB/s, maxb=67314KB/s, mint=23359msec, maxt=23359msec
fio: file hash not empty on exit

Eric
--
To unsubscribe from this list: send the line "unsubscribe fio" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


-----Original Message-----
From: David Nellans [mailto:david@nellans.org] 
Sent: Wednesday, February 26, 2014 8:13 AM
To: Lamkin, Eric
Cc: fio@vger.kernel.org
Subject: Re: fio replay



> On Feb 26, 2014, at 7:44 AM, "Lamkin, Eric" <Eric.Lamkin@lsi.com> wrote:
> 
> Is there a version of fio where replay works with a Linux blktrace?
> 
anything within the last few years should play them back just fine, is it broken in a specific version you're trying?
