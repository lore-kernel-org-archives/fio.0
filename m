Return-Path: <fio-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:20817 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbaJPSNr convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 16 Oct 2014 14:13:47 -0400
From: "Gruher, Joseph R" <joseph.r.gruher@intel.com>
Subject: client/server and minimal output
Date: Thu, 16 Oct 2014 18:13:46 +0000
Message-ID: <DE927C68B458BE418D582EC97927A92851867513@ORSMSX113.amr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: "Gruher, Joseph R" <joseph.r.gruher@intel.com>

Hi folks-

I'm trying to use the client/server features of FIO.  I have version 2.1.3.  The client/server works great for running the specified job file.  The problem I am having is with the reporting.  I have 96 clients running against a single target and I need to aggregate the results.  So I need to either:
1)	Get minimal output back, then I can load it up in Excel or whatever and add/average the numbers easily
2)	Get a version of group reporting, where the client aggregates all the results for me and just shows totals/averages

I don't think #2 is a feature of FIO client/server so I'm trying to do #1.  However, I can't seem to get minimal output back when using client/server (I get it all the time when running locally).  See example below.  Only the very last part ("disk stats") is in minimal format.  Am I doing something wrong?  Is this a bug?  Is minimal output just not supported for client/server?  Thanks!

ceph@bfclab:~$ sudo fio --minimal --client=10.0.0.101 test.ini --client=10.0.0.102 test.ini --client=10.0.0.103 test.ini
hostname=ubuntuavnbfc, be=0, 64-bit, os=Linux, arch=x86-64, fio=fio-2.1.3, flags=1
hostname=ubuntuavnbfc, be=0, 64-bit, os=Linux, arch=x86-64, fio=fio-2.1.3, flags=1
hostname=ubuntuavnbfc, be=0, 64-bit, os=Linux, arch=x86-64, fio=fio-2.1.3, flags=1
<ubuntuavnbfc> job01: (g=0): rw=randread, <ubuntuavnbfc> job01: (g=0): rw=randread, <ubuntuavnbfc> job01: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, bs=4K-4K/4K-4K/4K-4K, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=32
ioengine=libaio, iodepth=32
ioengine=libaio, iodepth=32
<ubuntuavnbfc> Starting <ubuntuavnbfc> Starting <ubuntuavnbfc> Starting 1 thread
1 thread
1 thread
<ubuntuavnbfc> [] [100.0% done] [38986K/0K/0K /s] [9745/0/0 iops] [eta 00m:00s]
job01: (groupid=0, jobs=1): err= 0: pid=2312: Thu Oct 16 10:38:23 2014
  read : io=133636KB, bw=13336KB/s, iops=3330, runt= 10021msec
    slat (usec): min=18, max=188, avg=39.01, stdev=11.42
    clat (usec): min=513, max=47101, avg=9563.16, stdev=13293.87
     lat (usec): min=557, max=47148, avg=9602.88, stdev=13292.07
    clat percentiles (usec):
     |  1th=[  620],  5th=[  676], 10th=[  724], 20th=[  804], 30th=[  900],
     | 40th=[ 1032], 50th=[ 1336], 60th=[ 2352], 70th=[ 8768], 80th=[24704],
     | 90th=[34560], 95th=[37120], 99th=[39680], 100th=[40192], 100th=[41728],
     | 100th=[42240], 100th=[44288]
    bw (KB  /s): min=    0, max=14392, per=95.57%, avg=12744.25, stdev=3032.04
    lat (usec) : 750=13.48%, 1000=24.70%
    lat (msec) : 2=19.67%, 4=6.41%, 10=6.74%, 20=6.21%, 50=22.88%
  cpu          : usr=5.54%, sys=21.09%, ctx=90216, majf=0, minf=47
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=198.8%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, >=64=0.0%
     issued    : total=r=33378/w=0/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=133636KB, aggrb=13335KB/s, minb=13335KB/s, maxb=13335KB/s, mint=10021msec, maxt=10021msec

Disk stats (read/write):
;rbd1;66084;0;0;0;632904;0;633656;99.60%<ubuntuavnbfc>
job01: (groupid=0, jobs=1): err= 0: pid=2275: Thu Oct 16 10:38:23 2014
  read : io=136736KB, bw=13630KB/s, iops=3404, runt= 10032msec
    slat (usec): min=18, max=187, avg=37.43, stdev=11.83
    clat (usec): min=533, max=67897, avg=9356.39, stdev=13610.40
     lat (usec): min=588, max=67937, avg=9394.26, stdev=13608.85
    clat percentiles (usec):
     |  1th=[  628],  5th=[  684], 10th=[  732], 20th=[  812], 30th=[  916],
     | 40th=[ 1032], 50th=[ 1288], 60th=[ 2024], 70th=[ 6368], 80th=[26752],
     | 90th=[35584], 95th=[37632], 99th=[39680], 100th=[40192], 100th=[42240],
     | 100th=[47872], 100th=[64256]
    bw (KB  /s): min=    0, max=14416, per=95.64%, avg=13034.45, stdev=3093.38
    lat (usec) : 750=12.37%, 1000=25.01%
    lat (msec) : 2=22.48%, 4=6.85%, 10=7.00%, 20=4.11%, 50=22.25%
    lat (msec) : 100=0.03%
  cpu          : usr=5.72%, sys=21.65%, ctx=85461, majf=0, minf=47
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=201.3%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, >=64=0.0%
     issued    : total=r=34153/w=0/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=136736KB, aggrb=13629KB/s, minb=13629KB/s, maxb=13629KB/s, mint=10032msec, maxt=10032msec

Disk stats (read/write):
;rbd1;68465;0;0;0;633116;0;633292;99.57%<ubuntuavnbfc>
job01: (groupid=0, jobs=1): err= 0: pid=2518: Thu Oct 16 10:38:23 2014
  read : io=131932KB, bw=13145KB/s, iops=3283, runt= 10037msec
    slat (usec): min=17, max=161, avg=36.24, stdev= 9.24
    clat (usec): min=498, max=74571, avg=9707.53, stdev=13526.88
     lat (usec): min=546, max=74604, avg=9744.54, stdev=13525.06
    clat percentiles (usec):
     |  1th=[  612],  5th=[  668], 10th=[  716], 20th=[  796], 30th=[  900],
     | 40th=[ 1032], 50th=[ 1336], 60th=[ 2416], 70th=[ 8640], 80th=[26240],
     | 90th=[35072], 95th=[37632], 99th=[39680], 100th=[40192], 100th=[41728],
     | 100th=[60672], 100th=[72192]
    bw (KB  /s): min=    0, max=13872, per=95.10%, avg=12499.60, stdev=2976.39
    lat (usec) : 500=0.01%, 750=14.85%, 1000=22.91%
    lat (msec) : 2=19.75%, 4=6.54%, 10=7.12%, 20=5.68%, 50=23.19%
    lat (msec) : 100=0.05%
  cpu          : usr=5.30%, sys=20.14%, ctx=92803, majf=0, minf=47
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=201.5%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, >=64=0.0%
     issued    : total=r=32952/w=0/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=131932KB, aggrb=13144KB/s, minb=13144KB/s, maxb=13144KB/s, mint=10037msec, maxt=10037msec

Disk stats (read/write):
;rbd1;66052;0;0;0;632940;0;633496;99.57%

ceph@bfclab:~$ fio --version
fio-2.1.3
