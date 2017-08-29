Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-yw0-f180.google.com ([209.85.161.180]:33443 "EHLO
        mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751218AbdH2EVN (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 29 Aug 2017 00:21:13 -0400
Received: by mail-yw0-f180.google.com with SMTP id s143so11753413ywg.0
        for <fio@vger.kernel.org>; Mon, 28 Aug 2017 21:21:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALjAwxjJKsgaUA7+LsvAmG4dG6iRgKL_g5aFhj_=oELzBTjc=Q@mail.gmail.com>
References: <CAAEM5qL7Ze0fwDrohz7Mn-kjWzV3G3BKST0BvYFRpW+2bB38Ag@mail.gmail.com>
 <CALjAwxjJKsgaUA7+LsvAmG4dG6iRgKL_g5aFhj_=oELzBTjc=Q@mail.gmail.com>
From: siha lawrence <sihaj33@gmail.com>
Date: Tue, 29 Aug 2017 12:21:12 +0800
Message-ID: <CAAEM5qKmvP5ZR9hYVFa=JxjrnTLwiEp4gy+0aJ-r1eaLJnLAnQ@mail.gmail.com>
Subject: Re: exitall_on_error option with stats
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

Thank you for this.
The job command I'm using is:

sudo fio --ioengine=libaio --size=100% --ramp_time=10 --runtime=40
--time_based=1 --verify_backlog=1 --verify_dump=1 --verify_fatal=1
--norandommap --numjobs=1 --direct=1 --rw=write --bs=1K --iodepth=8
--exitall_on_error --buffer_pattern=0x10000000000000000L --minimal
--random_generator=tausworthe64 --name=/dev/sda  --name=/dev/sdcd
--name=/dev/sdce  --name=/dev/sdcb

On Sat, Aug 26, 2017 at 12:29 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> Hi,
>
> On 21 August 2017 at 03:32, siha lawrence <sihaj33@gmail.com> wrote:
>> I'm using fio version 2.20 with the option exitall_on_error. On error,
>> it exits and reports all stats as zero.
>> How can this be modified so that we can get partial stats and not zeros?
>
> I'm afraid I can't reproduce the problem with a post 3.0 fio build:
>
> sudo -s
> echo -e "0 511 zero\n511 1 error" | dmsetup create errorend
> fio --exitall_on_error --direct=1 --bs=512 --rate=64k --name=null
> --ioengine=null --size=512k --name=errorjob
> --filename=/dev/mapper/errorend
> null: (g=0): rw=read, bs=(R) 512B-512B, (W) 512B-512B, (T) 512B-512B,
> ioengine=null, iodepth=1
> errorjob: (g=0): rw=read, bs=(R) 512B-512B, (W) 512B-512B, (T)
> 512B-512B, ioengine=psync, iodepth=1
> fio-3.0-5-g168b
> Starting 2 processes
> fio: io_u error on file /dev/mapper/errorend: Input/output error: read
> offset=261632, buflen=512
> fio: pid=26078, err=5/file:io_u.c:1756, func=io_u error,
> error=Input/output error
>
> null: (groupid=0, jobs=1): err= 0: pid=26077: Sat Aug 26 05:24:23 2017
>    read: IOPS=128, BW=64.1KiB/s (65.6kB/s)(257KiB/4001msec)
>     clat (nsec): min=800, max=1500, avg=1066.08, stdev=57.11
>      lat (nsec): min=1100, max=12600, avg=3247.56, stdev=443.88
>     clat percentiles (nsec):
>      |  1.00th=[ 1004],  5.00th=[ 1004], 10.00th=[ 1004], 20.00th=[ 1004],
>      | 30.00th=[ 1004], 40.00th=[ 1096], 50.00th=[ 1096], 60.00th=[ 1096],
>      | 70.00th=[ 1096], 80.00th=[ 1096], 90.00th=[ 1096], 95.00th=[ 1096],
>      | 99.00th=[ 1208], 99.50th=[ 1304], 99.90th=[ 1496], 99.95th=[ 1496],
>      | 99.99th=[ 1496]
>    bw (  KiB/s): min=   63, max=   65, per=50.39%, avg=64.00, stdev=
> 0.58, samples=7
>    iops        : min=  127, max=  130, avg=128.14, stdev= 0.90, samples=7
>   lat (nsec)   : 1000=0.39%
>   lat (usec)   : 2=99.61%
>   cpu          : usr=0.40%, sys=0.00%, ctx=511, majf=0, minf=7
>   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued rwt: total=513,0,0, short=0,0,0, dropped=0,0,0
>      latency   : target=0, window=0, percentile=100.00%, depth=1
> errorjob: (groupid=0, jobs=1): err= 5 (file:io_u.c:1756, func=io_u
> error, error=Input/output error): pid=26078: Sat Aug 26 05:24:23 2017
>    read: IOPS=128, BW=63.0KiB/s (65.5kB/s)(256KiB/3993msec)
>     clat (nsec): min=4300, max=39500, avg=19138.94, stdev=1729.73
>      lat (nsec): min=4600, max=41000, avg=20628.57, stdev=1758.02
>     clat percentiles (nsec):
>      |  1.00th=[18304],  5.00th=[18560], 10.00th=[18560], 20.00th=[18560],
>      | 30.00th=[18816], 40.00th=[18816], 50.00th=[18816], 60.00th=[19072],
>      | 70.00th=[19328], 80.00th=[19328], 90.00th=[19584], 95.00th=[20096],
>      | 99.00th=[22912], 99.50th=[36096], 99.90th=[39680], 99.95th=[39680],
>      | 99.99th=[39680]
>    bw (  KiB/s): min=   63, max=   65, per=50.39%, avg=64.00, stdev=
> 0.58, samples=7
>    iops        : min=  127, max=  130, avg=128.14, stdev= 0.90, samples=7
>   lat (usec)   : 10=0.20%, 20=93.75%, 50=5.86%
>   cpu          : usr=0.40%, sys=0.20%, ctx=510, majf=0, minf=15
>   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.2%, 4=99.8%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued rwt: total=512,0,0, short=0,0,0, dropped=0,0,0
>      latency   : target=0, window=0, percentile=100.00%, depth=1
>
> Run status group 0 (all jobs):
>    READ: bw=128KiB/s (131kB/s), 63.0KiB/s-64.1KiB/s
> (65.5kB/s-65.6kB/s), io=512KiB (524kB), run=3993-4001msec
>
> But I can't tell if there's more to your issue because you didn't
> include the exact job file/command line you were running with. Can you
> update your fio to at least 3.0 (or git master), reproduce the problem
> and include at least the information in
> https://github.com/axboe/fio/blob/master/REPORTING-BUGS ? Thanks!
>
> --
> Sitsofe | http://sucs.org/~sits/
