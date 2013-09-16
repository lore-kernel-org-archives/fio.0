Return-Path: <brianclam@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAAAK+WW7zfF9wWF64WM0j_jEbRDjiZ-Ln5SGo-5rROgBuFePtg@mail.gmail.com>
References: <CAAAK+WVk9ch4PNrfUb8LHwp800T-qTXbH7tr_Tj9GvZh8a0J1A@mail.gmail.com>
 <5237593A.8050301@kernel.dk> <E8B80854-5126-4A4C-92D7-26222827F9E6@gmail.com>
 <52377489.9060605@kernel.dk> <CAAAK+WW7zfF9wWF64WM0j_jEbRDjiZ-Ln5SGo-5rROgBuFePtg@mail.gmail.com>
From: "Brian L." <brianclam@gmail.com>
Date: Mon, 16 Sep 2013 15:17:52 -0700
Message-ID: <CAAAK+WVMFj0pQPOVynuUYXwnVpF7n7cwSq7pUqj8YpXBB8v2eg@mail.gmail.com>
Subject: Re: output mutating on me
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Mon, Sep 16, 2013 at 2:35 PM, Brian L. <brianclam@gmail.com> wrote:
> On Mon, Sep 16, 2013 at 2:13 PM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 09/16/2013 02:19 PM, Brian L. wrote:
>>> it's running normal directly on the machine.
>>>
>>>  i thought maybe clat and lat might be the same as slat and that is why there is only slat being output but i  not sure.
>>
>> (please don't top post)
>>
>> I need the full invocations of what you are running. If you are not
>> running async IO, then you only get lat. If you are running async IO,
>> you get slat and clat as well. I can't completely tell, since you didn't
>> not push what each of them ran exactly and the full output.
>>
>> --
>> Jens Axboe
>>
>
> Sorry about the top post - this is all new to me.
>
> I will see if I can attach the output log to this email and hopefully
> it will go thru and not get rejected.
>
> If you look at the output, you will see that the following lines have
> missing 'clat' and 'lat':
> (you can grep for the min and max and you should get the line.)
>
>     slat (usec): min=78, max=165, avg=119.36, stdev= 8.30
>     clat percentiles (usec):
>
>
>   write: io=2520.0MB, bw=258928KB/s, iops=252, runt=  9966msec
>     slat (usec): min=186, max=478, avg=266.46, stdev=17.74
>     clat percentiles (usec):
>
> For this particular run, it looks like there is only 1 run w/ the
> different output so I can just re-run that particular the test to see
> if the result comes back correctly.
>
> This is my template file to generate the runs:
> (Hopefully, b/w this and the output, it has all of the needed info.)
>
> foundation-air:disk_benchmark blam$ cat template_general.fio
> [mytest]
> rw=${myrw}
> filename=${mydisk}
> size=5G
> iodepth=${myiodepth}
> bs=${myblocksize}
> ioengine=libaio
> ramp_time=10s
> # If value is true, use non-buffered io. This is usually
> #               O_DIRECT. Note that ZFS on Solaris doesn't support direct io.
> #               On Windows the synchronous ioengines don't support direct io.
> # (1 for non-buffered io)
> direct=1
> # If true, fsync file contents when a write stage has completed.
> end_fsync=0
> # Invalidate the buffer/page cache parts for this file prior to
> starting io. Defaults to true.
> invalidate=1

So I re-ran the test w/ the same parameters and got the correct reading:


===
 {mydisk}- {myrw}- {myiodepth}- {myblocksize}
/dev/sdf-randrw-32-1024K
===
mytest: (g=0): rw=randrw, bs=1M-1M/1M-1M/1M-1M, ioengine=libaio, iodepth=32
fio-2.1
Starting 1 process

mytest: (groupid=0, jobs=1): err= 0: pid=10351: Mon Sep 16 14:53:47 2013
  read : io=2618.0MB, bw=269079KB/s, iops=260, runt=  9963msec
    slat (usec): min=76, max=172, avg=119.17, stdev= 8.72
    clat (msec): min=6, max=213, avg=64.35, stdev=18.84
     lat (msec): min=6, max=213, avg=64.47, stdev=18.84
    clat percentiles (msec):
     |  1.00th=[   35],  5.00th=[   38], 10.00th=[   41], 20.00th=[   47],
     | 30.00th=[   53], 40.00th=[   58], 50.00th=[   64], 60.00th=[   70],
     | 70.00th=[   76], 80.00th=[   82], 90.00th=[   89], 95.00th=[   95],
     | 99.00th=[  105], 99.50th=[  112], 99.90th=[  188], 99.95th=[  200],
     | 99.99th=[  215]
    bw (KB  /s): min=238661, max=294912, per=99.94%, avg=268919.11,
stdev=19175.27
  write: io=2532.0MB, bw=260240KB/s, iops=252, runt=  9963msec
    slat (usec): min=185, max=356, avg=265.59, stdev=18.27
    clat (msec): min=7, max=206, avg=59.65, stdev=18.87
     lat (msec): min=7, max=207, avg=59.91, stdev=18.87
    clat percentiles (msec):
     |  1.00th=[   28],  5.00th=[   33], 10.00th=[   36], 20.00th=[   42],
     | 30.00th=[   48], 40.00th=[   53], 50.00th=[   59], 60.00th=[   65],
     | 70.00th=[   71], 80.00th=[   77], 90.00th=[   84], 95.00th=[   89],
     | 99.00th=[  101], 99.50th=[  108], 99.90th=[  186], 99.95th=[  198],
     | 99.99th=[  208]
    bw (KB  /s): min=233472, max=285577, per=99.07%, avg=257827.26,
stdev=18447.78
    lat (msec) : 10=0.10%, 20=0.18%, 50=29.73%, 100=68.36%, 250=1.64%
  cpu          : usr=8.99%, sys=13.14%, ctx=10069, majf=0, minf=27
  IO depths    : 1=0.1%, 2=0.1%, 4=0.2%, 8=0.3%, 16=0.6%, 32=198.8%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, >=64=0.0%
     issued    : total=r=2600/w=2520/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=2618.0MB, aggrb=269078KB/s, minb=269078KB/s,
maxb=269078KB/s, mint=9963msec, maxt=9963msec
  WRITE: io=2532.0MB, aggrb=260239KB/s, minb=260239KB/s,
maxb=260239KB/s, mint=9963msec, maxt=9963msec

Disk stats (read/write):
  sdf: ios=11017/10044, merge=0/0, ticks=658969/597288,
in_queue=1258991, util=99.62%

