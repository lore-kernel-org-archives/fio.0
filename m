Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <MWHPR11MB204527783F0D03DE6DE3556D875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
References: <MWHPR11MB2045B4FFEB905261E1FAFD1E875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
 <863271c2-eeb4-b770-bdfa-89746d4d9c70@kernel.dk> <MWHPR11MB2045DFA579DB2BDC5B1EA466875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
 <2feebb78-c436-3187-f28d-588f18b9dfc4@kernel.dk> <CALjAwxiwWDghXZpsN9vzR7AjwTgHU-g+iYeogbWvO5p6itMd6A@mail.gmail.com>
 <ddbb5d83-cc30-db5f-5c98-0b5809a15d76@kernel.dk> <MWHPR11MB2045095AA21ED4BF8BA38021875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
 <CALjAwxhx45=uTivppp3A1ACdGmon-oaH9S4b41MJQ6TfQCP7ZA@mail.gmail.com> <MWHPR11MB204527783F0D03DE6DE3556D875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 31 Oct 2017 20:29:46 +0000
Message-ID: <CALjAwxjO0i34McDkRRoeYCxW=CD4WG_=2Aohh=UA34tLL8w3AQ@mail.gmail.com>
Subject: Re: FIO windows
Content-Type: text/plain; charset="UTF-8"
To: David Hare <david.hare@primarydata.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Hi,

Can you keep keep the problem size line but keep cutting the job down
until it's as small as possible but still shows the issue? e.g. can
you reduce the number of files (e.g. to F-I) and still see the
problem? Then all the way down to F? How about when group_reporting is
commented out? etc.

Also did you know that thread doesn't control the number of thread -
it just enables the feature (see
http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-thread
)?

On 31 October 2017 at 20:21, David Hare <david.hare@primarydata.com> wrote:
> I cut the file down and start building it back up. The issue seems to be
> with "size=1g" if I remove the size it runs.
>
> [global]
>
> ioengine=windowsaio
> blocksize=64k
> direct=1
> iodepth=64
> group_reporting
>
> rw=read
> ;size=1g
> numjobs=8
>
> thread=8
> time_based
> runtime=10
>
> ;cpus_allowed=1-43
> ;cpus_allowed_policy=shared
> ;verify_async_cpus=shared
>
> [asdf]
> filename=F\:\\testfile:G\:\\testfile:H\:\\testfile:I\:\\testfile:J\:\\testfile:K\:\\testfile:L\:\\testfile:M\:\\testfile:P\:\\testfile:
> ;N\:\\testfile:
>
> ;O\:\\testfile:P\:\\testfile:Q\:\\testfile
>
>
>
>
> Here the output:
>
> asdf: (g=0): rw=read, bs=(R) 64.0KiB-64.0KiB, (W) 64.0KiB-64.0KiB, (T)
> 64.0KiB-64.0KiB, ioengine=windowsaio, iodepth=64
> ...
> fio-3.1
> Starting 8 threads
>
> asdf: (groupid=0, jobs=8): err= 0: pid=6112: Tue Oct 31 20:17:43 2017
> read: IOPS=164k, BW=10.0GiB/s (10.8GB/s)(100GiB/10012msec)
> slat (usec): min=8, max=2192, avg=18.69, stdev=16.56
> clat (nsec): min=1407, max=43278k, avg=3069841.35, stdev=5194977.44
> lat (usec): min=132, max=43586, avg=3088.53, stdev=5195.51
> clat percentiles (usec):
> | 1.00th=[ 190], 5.00th=[ 231], 10.00th=[ 255], 20.00th=[ 289],
> | 30.00th=[ 318], 40.00th=[ 347], 50.00th=[ 379], 60.00th=[ 429],
> | 70.00th=[ 603], 80.00th=[ 6194], 90.00th=[10290], 95.00th=[17695],
> | 99.00th=[18482], 99.50th=[19792], 99.90th=[20841], 99.95th=[21103],
> | 99.99th=[24511]
> bw ( MiB/s): min= 903, max= 1718, per=12.28%, avg=1260.89, stdev=280.99,
> samples=160
> iops : min=14457, max=27496, avg=20173.74, stdev=4495.88, samples=160
> lat (usec) : 2=0.01%, 4=0.01%, 100=0.01%, 250=8.89%, 500=58.05%
> lat (usec) : 750=4.82%, 1000=0.92%
> lat (msec) : 2=0.66%, 4=0.42%, 10=14.28%, 20=11.51%, 50=0.45%
> cpu : usr=0.00%, sys=29.97%, ctx=0, majf=0, minf=0
> IO depths : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=38.1%, >=64=61.8%
> submit : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
> complete : 0=0.0%, 4=98.2%, 8=1.6%, 16=0.2%, 32=0.1%, 64=0.1%, >=64=0.0%
> issued rwt: total=1644736,0,0, short=0,0,0, dropped=0,0,0
> latency : target=0, window=0, percentile=100.00%, depth=64
>
> Run status group 0 (all jobs):
> READ: bw=10.0GiB/s (10.8GB/s), 4096MiB/s-10.0GiB/s (4295MB/s-10.8GB/s),
> io=100GiB (108GB), run=10012-10012msec
>
> -Dave
>
>
>
>
> -----Original Message-----
> From: Sitsofe Wheeler [mailto:sitsofe@gmail.com]
> Sent: Tuesday, October 31, 2017 12:59 PM
> To: David Hare <david.hare@primarydata.com>
> Cc: Jens Axboe <axboe@kernel.dk>; fio@vger.kernel.org
> Subject: Re: FIO windows
>
> Hi,
>
> Any chance you could cut your job file down to the smallest number of
> options that still show the problem?
>
> On 31 October 2017 at 19:55, David Hare <david.hare@primarydata.com> wrote:
>> Jens,
>>
>> Still getting the error below when I add a 9th drive:
>>
>> fio: pid=6040, err=22/file:ioengines.c:333, func=td_io_queue,
>> error=Invalid argument
>> fio: pid=5880, err=22/file:ioengines.c:333, func=td_io_queue,
>> error=Invalid argument
>>
>> I will follow you direction from this morning and submit a bug report.
>>
>> -Dave
>>
>>
>> FIO file:
>>
>> [global]
>> ioengine=windowsaio
>> blocksize=64k
>> direct=1
>> iodepth=256
>> group_reporting
>>
>> rw=read
>> size=1g
>> numjobs=2
>>
>> thread=8
>> time_based
>> runtime=10
>>
>> ;cpus_allowed=1-43
>> ;cpus_allowed_policy=shared
>> ;verify_async_cpus=shared
>>
>> [asdf]
>>
>> filename=F\:\\testfile:G\:\\testfile:H\:\\testfile:I\:\\testfile:J\:\\testfile:K\:\\testfile:L\:\\testfile:M\:\\testfile:P\:\\testfile:
>
> For example - should you have a trailing : in this line?
>
> --
> Sitsofe | http://sucs.org/~sits/
>
>
> Disclaimer
>
> The information contained in this communication from the sender is
> confidential. It is intended solely for use by the recipient and others
> authorized to receive it. If you are not the recipient, you are hereby
> notified that any disclosure, copying, distribution or taking action in
> relation of the contents of this information is strictly prohibited and may
> be unlawful.



-- 
Sitsofe | http://sucs.org/~sits/

