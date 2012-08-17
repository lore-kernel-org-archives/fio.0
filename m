Return-Path: <greg.sullivan@sullivang.net>
MIME-Version: 1.0
In-Reply-To: <502DE47C.8050802@kernel.dk>
References: <CAHaS=QxT7Prz4jw8b5rZ-D3gTmejFp3D6ZA6DxcigHpEcVAJbw@mail.gmail.com>
	<502DE47C.8050802@kernel.dk>
Date: Fri, 17 Aug 2012 21:24:54 +1000
Message-ID: <CAHaS=Qw0OK9CTP=xfNJanA0MqJF6yYx==BcWu3QJYy9=047Lnw@mail.gmail.com>
Subject: Re: Test files being created twice as large as requested (Win7)
From: Greg Sullivan <greg.sullivan@sullivang.net>
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 17 August 2012 16:28, Jens Axboe <axboe@kernel.dk> wrote:
> On 08/16/2012 05:34 AM, Greg Sullivan wrote:
>> fio seems to be creating test files that are twice as large as
>> requested. The following config creates a file that is 209,715,200
>> bytes in size:
>>
>> [read]
>> size=100M
>> rw=read
>>
>> Environment: Windows 7 32-bit, fio 2.0.8
>
> Can you post the output of running that job? Ensure that the read.1.0 is
> deleted before running it.
>
> --
> Jens Axboe

Here is the log:
===BEGIN===
C:\test>dir
 Volume in drive C has no label.
 Volume Serial Number is 08F2-7A32

 Directory of C:\test

17/08/2012  09:23 PM    <DIR>          .
17/08/2012  09:23 PM    <DIR>          ..
17/08/2012  09:16 PM                26 test.ini
               1 File(s)             26 bytes
               2 Dir(s)  130,065,698,816 bytes free

C:\test>fio test.ini
fio: this platform does not support process shared mutexes, forcing use of threa
ds. Use the 'thread' option to get rid of this warning.
read: (g=0): rw=read, bs=4K-4K/4K-4K, ioengine=windowsaio, iodepth=1
fio-2.0.8-18-g525f
Starting 1 process
read: Laying out IO file(s) (1 file(s) / 100MB)
Jobs: 1 (f=1)
read: (groupid=0, jobs=1): err= 0: pid=7568: Fri Aug 17 21:23:34 2012
  read : io=102400KB, bw=71309KB/s, iops=17827 , runt=  1436msec
    slat (usec): min=11 , max=10187 , avg=20.98, stdev=72.27
    clat (usec): min=1 , max=5422 , avg=28.49, stdev=57.96
     lat (usec): min=13 , max=11875 , avg=49.47, stdev=110.30
    clat percentiles (usec):
     |  1.00th=[    2],  5.00th=[    4], 10.00th=[    7], 20.00th=[   22],
     | 30.00th=[   24], 40.00th=[   24], 50.00th=[   25], 60.00th=[   29],
     | 70.00th=[   30], 80.00th=[   41], 90.00th=[   42], 95.00th=[   42],
     | 99.00th=[   49], 99.50th=[  112], 99.90th=[  378], 99.95th=[  876],
     | 99.99th=[ 2576]
    bw (KB/s)  : min=46816, max=78288, per=87.72%, avg=62552.00, stdev=22254.06
    lat (usec) : 2=0.05%, 4=4.83%, 10=6.11%, 20=7.66%, 50=80.36%
    lat (usec) : 100=0.41%, 250=0.41%, 500=0.11%, 750=0.01%, 1000=0.02%
    lat (msec) : 2=0.02%, 4=0.01%, 10=0.01%
  cpu          : usr=0.00%, sys=69.69%, ctx=0, majf=0, minf=0
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=25600/w=0/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=102400KB, aggrb=71309KB/s, minb=71309KB/s, maxb=71309KB/s, mint=1436
msec, maxt=1436msec

C:\test>dir
 Volume in drive C has no label.
 Volume Serial Number is 08F2-7A32

 Directory of C:\test

17/08/2012  09:23 PM    <DIR>          .
17/08/2012  09:23 PM    <DIR>          ..
17/08/2012  09:23 PM       209,715,200 read.1.0
17/08/2012  09:16 PM                26 test.ini
               2 File(s)    209,715,226 bytes
               2 Dir(s)  129,855,209,472 bytes free

C:\test>
===END===

Regards
Greg.

