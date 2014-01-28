Return-Path: <grundler@google.com>
MIME-Version: 1.0
Sender: grundler@google.com
In-Reply-To: <20140127233116.GO2782@kernel.dk>
References: <CAOpYm_W685AkEuFnNZX-m0Jfq+B+crzQv5oEF_Hbvq3XbABhaQ@mail.gmail.com>
	<20140127192215.GF2782@kernel.dk>
	<CAOpYm_WNfhkyFRofHg6aUfm_nxL7oX8gCc++wNFMproqP1rVeA@mail.gmail.com>
	<20140127224603.GM2782@kernel.dk>
	<20140127230339.GN2782@kernel.dk>
	<CANEJEGspxdmAAhRCS7hiQeeFAOmSg9+ZwnZ_wcROji-9zE9tAg@mail.gmail.com>
	<20140127233116.GO2782@kernel.dk>
Date: Mon, 27 Jan 2014 16:00:07 -0800
Message-ID: <CANEJEGsfPUTzV4iwkYCDY1xwagW8uW+nimBzLOLDt2uzZHPGYg@mail.gmail.com>
Subject: Re: A bug in combining fsrange and verify
From: Grant Grundler <grundler@chromium.org>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: Grant Grundler <grundler@chromium.org>, Wallence Lu <wallencelu@gmail.com>, FIO_list <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Mon, Jan 27, 2014 at 3:31 PM, Jens Axboe <axboe@kernel.dk> wrote:
...
>> > Works for me with the 2.1.4 release. It's actually broken in current
>> > -git, due to the numberio patches..
>>
>> You mean all of the "verify_only" support patches or specifically this patch:
>>
>> commit da0a7bd224bb9331f27bb4b20394dd5c8fa3acb0
>> Author: Juan Casse <jcasse@chromium.org>
>> Date:   Tue Sep 17 14:06:12 2013 -0700
>>
>>     Adds check for numberio during verify phase.
>>
>> I can take a look at this tomorrow... let me see if I have the job
>> file in another email.
>
> It looks like it's actually catching the issue, when I take a closer
> look.

OH. Got it. :)  Good. Had me worried for a moment.


BTW, it looks like there is also a bug in "random_pattern_fill"
support. When specifying verify_pattern the problem went away.  See
this bug:
    https://code.google.com/p/chromium/issues/detail?id=337651

my workaround is here:
    https://chromium-review.googlesource.com/#/c/183813/

(should probably start a new thread for that)

> I'm afraid there might be overlapping ranges for bsrange=.

I can reproduce with fio-2.1.2 + verify_only patches (output below).
It's always a 512 byte long corruption which in fact would suggest
"off-by-one" overlapping ranges.

> You can
> use the job file that was posted earlier in this thread. I reproduced
> with that one, just changing the min bs to be 4k instead (to avoid btrfs
> slowness...).

Got job file and didn't change anything - just ran it on a raw partition.

localhost autotest # rootdev -s
/dev/mmcblk0p3
[ don't use that one :) ]

localhost autotest #
/usr/local/autotest/tests/hardware_StorageFio/src/fio --filename
/dev/mmcblk0p5 /var/rand-write.fio

rand-write: (g=0): rw=randwrite, bs=512-32K/512-32K/512-32K,
ioengine=libaio, iodepth=1280
fio-2.1.2
Starting 1 thread
rand-write: Laying out IO file(s) (1 file(s) / 256MB)
Jobs: 1 (f=1): [V] [50.2% done] [0KB/12938KB/0KB /s] [0/1555/0 iops]
[eta 02m:12meta: verify failed at file rand-write.1.0 offset 9629184,
length 512
meta: verify failed at file rand-write.1.0 offset 9629696, length 512
meta: verify failed at file rand-write.1.0 offset 9630208, length 512
meta: verify failed at file rand-write.1.0 offset 9630720, length 512
meta: verify failed at file rand-write.1.0 offset 14421504, length 512
meta: verify failed at file rand-write.1.0 offset 14422016, length 512
meta: verify failed at file rand-write.1.0 offset 14422528, length 512
meta: verify failed at file rand-write.1.0 offset 14423040, length 512
meta: verify failed at file rand-write.1.0 offset 14423552, length 512
meta: verify failed at file rand-write.1.0 offset 14424064, length 512
meta: verify failed at file rand-write.1.0 offset 14424576, length 512
meta: verify failed at file rand-write.1.0 offset 16189952, length 512
meta: verify failed at file rand-write.1.0 offset 16190464, length 512
meta: verify failed at file rand-write.1.0 offset 16190976, length 512
meta: verify failed at file rand-write.1.0 offset 16191488, length 512
...
meta: verify failed at file rand-write.1.0 offset 261610496, length 512
meta: verify failed at file rand-write.1.0 offset 261611008, length 512
meta: verify failed at file rand-write.1.0 offset 261611520, length 512
meta: verify failed at file rand-write.1.0 offset 261612032, length 512
meta: verify failed at file rand-write.1.0 offset 261612544, length 512
meta: verify failed at file rand-write.1.0 offset 261613056, length 512
meta: verify failed at file rand-write.1.0 offset 14872064, length 512
meta: verify failed at file rand-write.1.0 offset 14872576, length 512
meta: verify failed at file rand-write.1.0 offset 14873088, length 512
meta: verify failed at file rand-write.1.0 offset 14873600, length 512
meta: verify failed at file rand-write.1.0 offset 15228928, length 512
....
meta: verify failed at file rand-write.1.0 offset 204399104, length 512
meta: verify failed at file rand-write.1.0 offset 204399616, length 512
meta: verify failed at file rand-write.1.0 offset 204400128, length 512
meta: verify failed at file rand-write.1.0 offset 213577216, length 512
meta: verify failed at file rand-write.1.0 offset 213577728, length 512
meta: verify failed at file rand-write.1.0 offset 213578240, length 512
meta: verify failed at file rand-write.1.0 offset 213578752, length 512
fio: pid=25546, err=84/file:io_u.c:1611, func=io_u_queued_complete,
error=Invalid or incomplete multibyte or wide character

rand-write: (groupid=0, jobs=1): err=84 (file:io_u.c:1611,
func=io_u_queued_complete, error=Invalid or incomplete multibyte or
wide character): pid=25546: Mon Jan 27 15:54:13 2014
  read : io=19841KB, bw=25835KB/s, iops=1678, runt=   768msec
    slat (msec): min=7, max=3518, avg=1770.08, stdev=1039.54
    clat (msec): min=68, max=686, avg=415.11, stdev=193.77
     lat (msec): min=624, max=3589, avg=2185.20, stdev=854.33
    clat percentiles (msec):
     |  1.00th=[   71],  5.00th=[  106], 10.00th=[  141], 20.00th=[  212],
     | 30.00th=[  289], 40.00th=[  359], 50.00th=[  429], 60.00th=[  498],
     | 70.00th=[  570], 80.00th=[  619], 90.00th=[  685], 95.00th=[  685],
     | 99.00th=[  685], 99.50th=[  685], 99.90th=[  685], 99.95th=[  685],
     | 99.99th=[  685]
  write: io=262145KB, bw=1978.5KB/s, iops=176, runt=132500msec
    slat (usec): min=22, max=296729, avg=5650.94, stdev=14766.22
    clat (msec): min=4, max=14882, avg=7131.79, stdev=3155.74
     lat (msec): min=6, max=14909, avg=7137.44, stdev=3157.46
    clat percentiles (msec):
     |  1.00th=[  408],  5.00th=[ 2671], 10.00th=[ 3687], 20.00th=[ 4146],
     | 30.00th=[ 5276], 40.00th=[ 5866], 50.00th=[ 6456], 60.00th=[ 7701],
     | 70.00th=[ 8979], 80.00th=[10159], 90.00th=[11600], 95.00th=[12911],
     | 99.00th=[14615], 99.50th=[14746], 99.90th=[14877], 99.95th=[14877],
     | 99.99th=[14877]
    bw (KB  /s): min=    1, max= 5342, per=100.00%, avg=1985.61, stdev=1531.77
    lat (msec) : 10=0.02%, 20=0.02%, 50=0.08%, 100=0.33%, 250=1.55%
    lat (msec) : 500=2.15%, 750=2.13%, 1000=0.48%, 2000=1.93%, >=2000=91.30%
  cpu          : usr=0.46%, sys=1.41%, ctx=22154, majf=0, minf=376
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.3%, >=64=99.5%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.1%
     issued    : total=r=1289/w=23365/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=19841KB, aggrb=25834KB/s, minb=25834KB/s, maxb=25834KB/s,
mint=768msec, maxt=768msec
  WRITE: io=262144KB, aggrb=1978KB/s, minb=1978KB/s, maxb=1978KB/s,
mint=132500msec, maxt=132500msec

Disk stats (read/write):
  mmcblk0: ios=1276/23348, merge=13/8383, ticks=92635/174755,
in_queue=267360, util=98.53%
localhost autotest #

