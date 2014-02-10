Return-Path: <m.eaton82@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20140209205744.GB2750@kernel.dk>
References: <20140206192135.GB3950@kernel.dk>
	<CAF+0mvnBvLVqijP+Atbh9SEjt0p6-e3hy4Q3QRMtb+swp72bTQ@mail.gmail.com>
	<20140209205744.GB2750@kernel.dk>
Date: Sun, 9 Feb 2014 16:26:37 -0800
Message-ID: <CAF+0mvk+h3Hb5-KyQr7fqfmrUN6V4-HvKx4M0AYHC6mTUQu0+Q@mail.gmail.com>
Subject: Re: Fio 2.1.5 release upcoming
From: Matthew Eaton <m.eaton82@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Sun, Feb 9, 2014 at 12:57 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On Sat, Feb 08 2014, Matthew Eaton wrote:
>> On Thu, Feb 6, 2014 at 11:21 AM, Jens Axboe <axboe@kernel.dk> wrote:
>> > Hi,
>> >
>> > I've been late on this release, originally wanted it out around
>> > Christmas. But various issues here and there prevented that. However, I
>> > now think we are getting pretty close. It'd be great if folks running on
>> > non-linux systems could compile and ensure that everything is in working
>> > order, because otherwise I'm going to assume that it is...
>> >
>> > Similarly, if you know of bugs (particularly regressions from previous
>> > releases), speak up now so we can get them fixed before 2.1.5 is cut.
>> >
>> > I'll wait until Monday to tag the release.
>> >
>> > --
>> > Jens Axboe
>> >
>>
>> Hi Jens,
>>
>> I was messing around with the openfiles flag in one of my job files
>> last week but was unable to get it to work.  Fio would keep defaulting
>> to opening all files set by nrfiles, but I'm not sure if I was doing
>> something wrong.  This was with fio 2.1.4 on linux.  Can you check on
>> this?
>
> It'd be easier if you include your job file / command line!
>
> --
> Jens Axboe
>

Hi Jens,

Here's an example.  In fio output I get f=50 instead of f=10 which I
believe is the number of simultaneous opens?  Also strange to me is
that write io is 2000 MB instead of 1024 MB.

[job]
bs=1m
rw=write
size=1g
nrfiles=50
openfiles=10
directory=temp

job: (g=0): rw=write, bs=1M-1M/1M-1M/1M-1M, ioengine=sync, iodepth=1
fio-2.1.4
Starting 1 process
job: Laying out IO file(s) (50 file(s) / 1023MB)
Jobs: 1 (f=50): [W] [-.-% done] [0KB/539.0MB/0KB /s] [0/539/0 iops]
[eta 00m:00s]
job: (groupid=0, jobs=1): err= 0: pid=15131: Sun Feb  9 16:18:55 2014
  write: io=2000.0MB, bw=697785KB/s, iops=681, runt=  2935msec
    clat (usec): min=167, max=145348, avg=1399.89, stdev=6030.76
     lat (usec): min=175, max=145359, avg=1413.43, stdev=6031.10
    clat percentiles (usec):
     |  1.00th=[  175],  5.00th=[  207], 10.00th=[  253], 20.00th=[  262],
     | 30.00th=[  274], 40.00th=[  290], 50.00th=[  302], 60.00th=[  358],
     | 70.00th=[  516], 80.00th=[  572], 90.00th=[ 5984], 95.00th=[ 6624],
     | 99.00th=[ 7328], 99.50th=[10816], 99.90th=[115200], 99.95th=[140288],
     | 99.99th=[144384]
    bw (KB  /s): min=81160, max=1503620, per=100.00%, avg=778889.75,
stdev=604179.56
    lat (usec) : 250=7.50%, 500=61.95%, 750=18.25%
    lat (msec) : 10=11.70%, 20=0.20%, 50=0.15%, 100=0.10%, 250=0.15%
  cpu          : usr=2.97%, sys=25.70%, ctx=504, majf=0, minf=33
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=2000/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
  WRITE: io=2000.0MB, aggrb=697785KB/s, minb=697785KB/s,
maxb=697785KB/s, mint=2935msec, maxt=2935msec

Disk stats (read/write):
  sdb: ios=0/2740, merge=0/2, ticks=0/360280, in_queue=376924, util=90.05%

