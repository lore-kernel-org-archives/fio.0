Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
References: <cover.1610876646.git.glqinhongwei@gmail.com> <d1a6de3435104ed9092c1520b5c5c6fe59b52239.1610876646.git.glqinhongwei@gmail.com>
 <CAKvRR0ShEVPV=YdC_kiFtoDEyJ9AG_QYZ2GShQjQH6k4aocT9A@mail.gmail.com>
In-Reply-To: <CAKvRR0ShEVPV=YdC_kiFtoDEyJ9AG_QYZ2GShQjQH6k4aocT9A@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sun, 17 Jan 2021 16:37:31 +0000
Message-ID: <CALjAwxj1Fzf+vWyiu_ddhsAnPVxij1QVqqL4WN+kwSpHZ=SyfQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] Fix thinktime_blocks
Content-Type: text/plain; charset="UTF-8"
To: Hongwei Qin <glqinhongwei@gmail.com>
Cc: fio <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Hi Hongwei,

On Sun, 17 Jan 2021 at 12:48, Hongwei Qin <glqinhongwei@gmail.com> wrote:
>
> Hi Sitsofe,
>
> >
> > At this point wouldn't it be better to update the help to reflect the
> > code rather than the other way around?
> >
>
> Consider this configuration:
> [global]
> thread
> kb_base=1000
> direct=1
> size=28GiB
> group_reporting
> io_size=64KiB
> ioengine=libaio
> iodepth=32
> bs=4096
> filename=/dev/qblkdev
>
> [fio_randwrite]
> rw=randwrite
> thinktime_blocks=4
> thinktime=1s
>
> I write this job file to simulate a data server that periodically
> writes back a certain amount of data (In this case,16KiB per second).
> Note that we cannot use the rate_iops here because it will send 1 request
> per 250ms.
> If we keep the code as it is, the job will finish immediately after
> the test starts.
> And this is usually not what the user wants.
>
> Or, should we introduce a new parameter to distinguish between
> "think after finish" and "think after issue"?

I like the idea of a new parameter! Maybe it would act as a toggle
because it doesn't make sense to set both together...

-- 
Sitsofe

