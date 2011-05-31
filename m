Return-Path: <fio-owner@vger.kernel.org>
Received: from nm28-vm1.bullet.mail.ne1.yahoo.com ([98.138.91.35]:39377 "HELO
	nm28-vm1.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932850Ab1EaWxQ convert rfc822-to-8bit
	(ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 31 May 2011 18:53:16 -0400
Message-ID: <357474.29413.qm@web120602.mail.ne1.yahoo.com>
Date: Tue, 31 May 2011 15:53:15 -0700 (PDT)
From: Gordon Bookless <ghhb@yahoo.com>
Subject: fio does not seem to work correctly when specifying buffered I/O
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I cannot seem to get fio to use cached I/O. I have tried using libaio, posixaio and sync I/O but when I switch from direct=1 to direct=0 I get either the same or worse numbers. When I use iozone in a similar setup my numbers are, as expected, much higher when specifying cached I/O.
I have used both version 1.41 and 1.55 with the same results.

Uname –a
Linux morrison 2.6.32-71.el6.x86_64 #1 SMP Wed Sep 1 01:33:01 EDT 2010 x86_64 x86_64 x86_64 GNU/Linux

It does look like the page cache is being used...
[root@morrison disk]# head /proc/meminfo
MemTotal:        24545172 kB
MemFree:        19167944 kB
Buffers:                  28040 kB
Cached:          4   406440 kB
SwapCached:                0 kB

fio test using direct=1

[root@morrison disk]# fio --name=1file --ioengine=libaio --direct=0 --size=4g --numjobs=1 --directory=/disk --iodepth=8 --rw=randrw --bs=4k 
1file: (g=0): rw=randrw, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=8
Starting 1 process
1file: Laying out IO file(s) (1 file(s) / 4096MB)
Jobs: 1 (f=1): [m] [100.0% done] [45M/46M /s] [11K/11K iops] [eta 00m:00s]
1file: (groupid=0, jobs=1): err= 0: pid=8084
  read : io=2,049MB, bw=45,305KB/s, iops=11,326, runt= 46311msec
    slat (usec): min=67, max=1,335, avg=76.71, stdev=20.35
    clat (usec): min=38, max=2,625, avg=310.30, stdev=114.25
    bw (KB/s) : min=44720, max=46992, per=100.13%, avg=45364.84, stdev=515.30
  write: io=2,047MB, bw=45,263KB/s, iops=11,315, runt= 46311msec
    slat (usec): min=3, max=591, avg= 6.54, stdev= 2.07
    clat (usec): min=36, max=2,675, avg=309.65, stdev=119.88
    bw (KB/s) : min=42816, max=48024, per=100.12%, avg=45315.30, stdev=886.71
  cpu          : usr=5.34%, sys=19.78%, ctx=525848, majf=0, minf=88
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=100.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.1%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w: total=524527/524049, short=0/0
     lat (usec): 50=0.13%, 100=0.66%, 250=21.96%, 500=75.73%, 750=1.03%
     lat (usec): 1000=0.17%
     lat (msec): 2=0.30%, 4=0.02%

Run status group 0 (all jobs):
   READ: io=2,049MB, aggrb=45,304KB/s, minb=46,392KB/s, maxb=46,392KB/s, mint=46311msec, maxt=46311msec
  WRITE: io=2,047MB, aggrb=45,263KB/s, minb=46,349KB/s, maxb=46,349KB/s, mint=46311msec, maxt=46311msec

Disk stats (read/write):
  rssda: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%

 fio test using direct=0
[root@morrison disk]# fio --name=1file --ioengine=libaio --direct=0 --size=4g --numjobs=1 --directory=/disk --iodepth=8 --rw=randrw --bs=4k 
1file: (g=0): rw=randrw, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=8
Starting 1 process
Jobs: 1 (f=1): [m] [100.0% done] [45M/45M /s] [11K/11K iops] [eta 00m:00s]
1file: (groupid=0, jobs=1): err= 0: pid=8089
  read : io=2,050MB, bw=43,952KB/s, iops=10,988, runt= 47751msec
    slat (usec): min=67, max=1,078, avg=76.88, stdev=21.11
    clat (usec): min=39, max=2,989, avg=311.50, stdev=116.29
    bw (KB/s) : min=    3, max=46152, per=101.75%, avg=44721.67, stdev=4710.82
  write: io=2,046MB, bw=43,885KB/s, iops=10,971, runt= 47751msec
    slat (usec): min=3, max=648, avg= 6.66, stdev= 2.04
    clat (usec): min=36, max=2,786, avg=310.84, stdev=121.66
    bw (KB/s) : min=    3, max=47088, per=101.75%, avg=44653.02, stdev=4759.19
  cpu          : usr=5.31%, sys=21.87%, ctx=526068, majf=0, minf=89
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=100.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.1%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w: total=524691/523885, short=0/0
     lat (usec): 50=0.12%, 100=0.65%, 250=21.87%, 500=75.84%, 750=1.03%
     lat (usec): 1000=0.15%
     lat (msec): 2=0.32%, 4=0.02%

Run status group 0 (all jobs):
   READ: io=2,050MB, aggrb=43,952KB/s, minb=45,007KB/s, maxb=45,007KB/s, mint=47751msec, maxt=47751msec
  WRITE: io=2,046MB, aggrb=43,884KB/s, minb=44,937KB/s, maxb=44,937KB/s, mint=47751msec, maxt=47751msec

Disk stats (read/write):
  rssda: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%

 iozone test using direct I/O
[root@morrison disk]# iozone -i8 -r4k -s4g -k8 -w -t1 -O -I
        Iozone: Performance Test of File I/O
                Version $Revision: 3.321 $
                Compiled for 64 bit mode.
                Build: linux-AMD64 

        Contributors:William Norcott, Don Capps, Isom Crawford, Kirby Collins
                     Al Slater, Scott Rhine, Mike Wisner, Ken Goss
                     Steve Landherr, Brad Smith, Mark Kelly, Dr. Alain CYR,
                     Randy Dunlap, Mark Montague, Dan Million, Gavin Brebner,
                     Jean-Marc Zucconi, Jeff Blomberg, Benny Halevy,
                     Erik Habbinga, Kris Strecker, Walter Wong, Joshua Root.

        Run began: Tue May 31 15:34:52 2011

        Record Size 4 KB
        File size set to 4194304 KB
        POSIX Async I/O (no bcopy). Depth 8 
        Setting no_unlink
        OPS Mode. Output is in operations per second.
        O_DIRECT feature enabled
        Command line used: iozone -i8 -r4k -s4g -k8 -w -t1 -O -I
        Time Resolution = 0.000001 seconds.
        Processor cache size set to 1024 Kbytes.
        Processor cache line size set to 32 bytes.
        File stride size set to 17 * record size.
        Throughput test with 1 process
        Each process writes a 4194304 Kbyte file in 4 Kbyte records

        Children see throughput for 1 mixed workload    =   11788.53 ops/sec
        Parent sees throughput for 1 mixed workload     =   11788.47 ops/sec
        Min throughput per process                      =   11788.53 ops/sec 
        Max throughput per process                      =   11788.53 ops/sec
        Avg throughput per process                      =   11788.53 ops/sec
        Min xfer                                        = 1048576.00 ops

iozone test complete.

iozone test using cache I/O
[root@morrison disk]# iozone -i8 -r4k -s4g -k8 -w -t1 -O 
        Iozone: Performance Test of File I/O
                Version $Revision: 3.321 $
                Compiled for 64 bit mode.
                Build: linux-AMD64 

        Contributors:William Norcott, Don Capps, Isom Crawford, Kirby Collins
                     Al Slater, Scott Rhine, Mike Wisner, Ken Goss
                     Steve Landherr, Brad Smith, Mark Kelly, Dr. Alain CYR,
                     Randy Dunlap, Mark Montague, Dan Million, Gavin Brebner,
                     Jean-Marc Zucconi, Jeff Blomberg, Benny Halevy,
                     Erik Habbinga, Kris Strecker, Walter Wong, Joshua Root.

        Run began: Tue May 31 15:37:35 2011

        Record Size 4 KB
        File size set to 4194304 KB
        POSIX Async I/O (no bcopy). Depth 8 
        Setting no_unlink
        OPS Mode. Output is in operations per second.
        Command line used: iozone -i8 -r4k -s4g -k8 -w -t1 -O
        Time Resolution = 0.000001 seconds.
        Processor cache size set to 1024 Kbytes.
        Processor cache line size set to 32 bytes.
        File stride size set to 17 * record size.
        Throughput test with 1 process
        Each process writes a 4194304 Kbyte file in 4 Kbyte records

        Children see throughput for 1 mixed workload    =   90633.90 ops/sec
        Parent sees throughput for 1 mixed workload     =   90629.44 ops/sec
        Min throughput per process                      =   90633.90 ops/sec 
        Max throughput per process                      =   90633.90 ops/sec
        Avg throughput per process                      =   90633.90 ops/sec
        Min xfer                                        = 1048576.00 ops

iozone test complete.


Any help would be appreciated since I much prefer fio to iozone.


Gordon Bookless
