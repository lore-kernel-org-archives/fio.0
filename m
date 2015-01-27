Return-Path: <fio-owner@vger.kernel.org>
Received: from mailout.micron.com ([137.201.242.129]:63162 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759308AbbA0Veo convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 27 Jan 2015 16:34:44 -0500
Received: from mail.micron.com (ntxboicas02.micron.com [137.201.20.138])
	by mailout.micron.com (8.14.4/8.14.6) with ESMTP id t0RLYghP020176
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=FAIL)
	for <fio@vger.kernel.org>; Tue, 27 Jan 2015 14:34:43 -0700
From: "Justin Eno (jeno)" <jeno@micron.com>
Subject: RE: last_block() vs. min_bs when > blockalign
Date: Tue, 27 Jan 2015 21:34:42 +0000
Message-ID: <5A8251503902B84E89CE171AD126BCFB2DE52B43@NTXBOIMBX01.micron.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Please disregard the patch - it incorrectly limits the target write range.  I will work on a proper fix.  Sorry for the noise.

-Justin

-----Original Message-----
From: Justin Eno (jeno) 
Sent: Tuesday, January 27, 2015 12:00 PM
To: 'fio@vger.kernel.org'
Subject: last_block() vs. min_bs when > blockalign

Hi Jens and all,

I have found that when performing mixed-sized random writes, fio ceases writing early due to last_block() not respecting min_bs.
The attached workload demonstrates the issue.  When run with io debugging enabled, "failed getting buflen" is reported, and the written data falls short of the total requested (in this case, 10M), e.g., ###############################################
[jeno@rhel fio-clean]$ ./fio --debug=io examples/random-fill.fio
fio: Any use of blockalign= turns off randommap
fio: set debug option io
io       25214 load ioengine sync
write-phase: (g=0): rw=randwrite, bs=1K-5K/1K-5K/1K-5K, ioengine=sync, iodepth=1 fio-2.2.5-3-g209e Starting 1 thread
write-phase: Laying out IO file(s) (1 file(s) / 5MB)
io       25214 invalidate cache datafile.tmp: 0/5242880
io       25214 invalidate cache datafile.tmp: 0/5242880
io       25214 fill_io_u: io_u 0x7fe49c003d40: off=315904/len=1024/ddir=1/datafile.tmp
io       25214 prep: io_u 0x7fe49c003d40: off=315904/len=1024/ddir=1/datafile.tmp
io       25214 ->prep(0x7fe49c003d40)=0
io       25214 queue: io_u 0x7fe49c003d40: off=315904/len=1024/ddir=1/datafile.tmp
io       25214 io complete: io_u 0x7fe49c003d40: off=315904/len=1024/ddir=1/datafile.tmp
...
io       25214 fill_io_u: io_u 0x7fe49c003d40: off=4930560/len=5120/ddir=1/datafile.tmp
io       25214 prep: io_u 0x7fe49c003d40: off=4930560/len=5120/ddir=1/datafile.tmp
io       25214 ->prep(0x7fe49c003d40)=0
io       25214 queue: io_u 0x7fe49c003d40: off=4930560/len=5120/ddir=1/datafile.tmp
io       25214 io complete: io_u 0x7fe49c003d40: off=4930560/len=5120/ddir=1/datafile.tmp
io       25214 io_u 0x7fe49c003d40, failed getting buflen
io       25214 io_u 0x7fe49c003d40, setting file failed
io       25214 get_io_u failed
io       25214 close ioengine sync
io       25214 free ioengine sync

write-phase: (groupid=0, jobs=1): err= 0: pid=25281: Tue Jan 27 10:33:50 2015
  write: io=4335.0KB, bw=585007B/s, iops=195, runt=  7588msec
    clat (usec): min=762, max=17788, avg=5100.38, stdev=2509.05
     lat (usec): min=764, max=17790, avg=5101.80, stdev=2509.06
    clat percentiles (usec):
     |  1.00th=[  868],  5.00th=[ 1240], 10.00th=[ 1704], 20.00th=[ 2544],
     | 30.00th=[ 3440], 40.00th=[ 4192], 50.00th=[ 5024], 60.00th=[ 5984],
     | 70.00th=[ 6752], 80.00th=[ 7648], 90.00th=[ 8384], 95.00th=[ 8896],
     | 99.00th=[ 9280], 99.50th=[10304], 99.90th=[17792], 99.95th=[17792],
     | 99.99th=[17792]
    bw (KB  /s): min=  520, max=  640, per=99.98%, avg=570.87, stdev=35.30
    lat (usec) : 1000=2.76%
    lat (msec) : 2=11.25%, 4=22.76%, 10=62.63%, 20=0.61%
  cpu          : usr=0.12%, sys=0.28%, ctx=1486, majf=0, minf=1
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=1485/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
  WRITE: io=4335KB, aggrb=571KB/s, minb=571KB/s, maxb=571KB/s, mint=7588msec, maxt=7588msec ...
###############################################

The attached patch changes last_block() to respect min_bs.

Thanks,
Justin

