Return-Path: <worleys@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20090805190249.GD12579@kernel.dk>
References: <f3177b9e0908051110t21d989a1rb68d519c25231ba4@mail.gmail.com>
	 <20090805185527.GB12579@kernel.dk> <20090805190249.GD12579@kernel.dk>
Date: Wed, 5 Aug 2009 13:18:58 -0600
Message-ID: <f3177b9e0908051218i30f4389aw562201e306bd3276@mail.gmail.com>
Subject: Re: Solaris issues in 1.3.1
From: Chris Worley <worleys@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <jens.axboe@oracle.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Wed, Aug 5, 2009 at 1:02 PM, Jens Axboe<jens.axboe@oracle.com> wrote:
> On Wed, Aug 05 2009, Jens Axboe wrote:
>> On Wed, Aug 05 2009, Chris Worley wrote:
>> > I'm running fio 1.3.1 in Solaris.=A0 I'm seeing two issues:
>> >
>> > 1) Direct I/O throws an error.
>> > 2) Performance is way too high.
>> >
>> > W/o Direct I/O my size is set to 2.5x memory capacity to assure no
>> > caching... yet performance for read/write is up to >7x the theoretical
>> > speed of the storage device (i.e. it's reporting 7GB/s, when
>> > theoretical for the device is 1GB/s).
>> >
>> > I'm not seeing the reporting issue in 1.2.1.
>>
<snip>
>
> Oh, and if you are not, just wait and I'll double check things here. But
> please send me your job file(s) so I can reproduce more easily, thanks.

Sequential Reads and Writes seem most effected.  Random and random
mixes seem mostly unaffected, but I've seen them also go wild.  Here's
an example incantation:

fio --rw=3Dwrite --bs=3D1m --numjobs=3D64 --iodepth=3D64 --sync=3D0
--randrepeat=3D0 --norandommap \
     --ioengine=3Dsync --filename=3D/dev/<your device here> --name=3Dtest
--loops=3D1000 --size=3D128849018880 \
     --runtime=3D600 --group_reporting

Here's some example output (not from the above command, but a similar
command w/ 512KB blocks):

test: (g=3D0): rw=3Dwrite, bs=3D512K-512K/512K-512K, ioengine=3Dsync, iodep=
th=3D64
...
test: (g=3D0): rw=3Dwrite, bs=3D512K-512K/512K-512K, ioengine=3Dsync, iodep=
th=3D64
Starting 64 processes
Jobs: 1 (f=3D1): [_____________________________________________________W___=
_______]
[1.6% done] [0K/0K /s] [0/0 iops] [eta 10h:29m:52s]     s]
test: (groupid=3D0, jobs=3D64): err=3D 0: pid=3D1222
  write: io=3D787299MiB, bw=3D1312MiB/s, iops=3D2623, runt=3D600153msec
    clat (usec): min=3D173, max=3D1107K, avg=3D24145.42, stdev=3D6786.14
    bw (KiB/s) : min=3D    0, max=3D347101, per=3D1.59%, avg=3D21306.67, st=
dev=3D4105.00
  cpu          : usr=3D0.04%, sys=3D3.31%, ctx=3D6406332, majf=3D0, minf=3D=
0
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued r/w: total=3D0/1574598, short=3D0/0
     lat (usec): 250=3D1.07%, 500=3D17.56%, 750=3D28.71%, 1000=3D4.53%
     lat (msec): 2=3D8.75%, 4=3D5.22%, 10=3D6.40%, 20=3D7.98%, 50=3D6.54%
     lat (msec): 100=3D2.02%, 250=3D10.58%, 500=3D0.64%, 750=3D0.01%, 1000=
=3D0.01%
     lat (msec): 2000=3D0.01%

Run status group 0 (all jobs):
  WRITE: io=3D787299MiB, aggrb=3D1312MiB/s, minb=3D1312MiB/s,
maxb=3D1312MiB/s, mint=3D600153msec, maxt=3D600153msec
test: (g=3D0): rw=3Dread, bs=3D512K-512K/512K-512K, ioengine=3Dsync, iodept=
h=3D64
...
test: (g=3D0): rw=3Dread, bs=3D512K-512K/512K-512K, ioengine=3Dsync, iodept=
h=3D64
Starting 64 processes
Jobs: 1 (f=3D1): [_________________________________________________________=
______R]
[1.6% done] [2153M/0K /s] [4205/0 iops] [eta 10h:29m:59s]
test: (groupid=3D0, jobs=3D64): err=3D 0: pid=3D1290
  read : io=3D145295MiB, bw=3D7233MiB/s, iops=3D148, runt=3D600009msec
    clat (usec): min=3D381, max=3D1251K, avg=3D4390.26, stdev=3D2714.96
    bw (KiB/s) : min=3D  538, max=3D451584, per=3D1.55%, avg=3D114760.43, s=
tdev=3D6304.82
  cpu          : usr=3D0.15%, sys=3D24.90%, ctx=3D4695895, majf=3D1, minf=
=3D0
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued r/w: total=3D8679198/0, short=3D0/0
     lat (usec): 500=3D0.01%, 750=3D0.02%, 1000=3D1.05%
     lat (msec): 2=3D89.40%, 4=3D3.57%, 10=3D1.86%, 20=3D0.86%, 50=3D1.29%
     lat (msec): 100=3D0.90%, 250=3D0.89%, 500=3D0.16%, 750=3D0.01%, 1000=
=3D0.01%
     lat (msec): 2000=3D0.01%

Run status group 0 (all jobs):
   READ: io=3D145295MiB, aggrb=3D7233MiB/s, minb=3D7233MiB/s,
maxb=3D7233MiB/s, mint=3D600009msec, maxt=3D600009msec

Maybe if the "B" in "minb=3D7233MiB/s" meant "bits" it would be
correct... but then the "write" case (above) would be 5x too slow.

Thanks,

Chris
>
> --
> Jens Axboe
>
>

