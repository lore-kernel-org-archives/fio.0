Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CABtFm2Vmn_u39=pXTKKv9AsDBu=BM9gmSpUmtQpqFGm5Uy00yA@mail.gmail.com>
References: <CABtFm2Vmn_u39=pXTKKv9AsDBu=BM9gmSpUmtQpqFGm5Uy00yA@mail.gmail.com>
Date: Mon, 4 May 2015 13:38:23 +0100
Message-ID: <CALjAwxhARkXBLf3_FBbcpBJg+ayPsveKRPt00nA+Prxm618Nug@mail.gmail.com>
Subject: Re: Unexpected runtime when running FIO in time based
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: Srinivasa Chamarthy <chamarthy.raju@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Hi,

When you report these issues could you cut the fio job file down to
the smallest possible file that still reproduces the problem (i.e.
removing any line in the job file should make the problem disappear)?

On 3 May 2015 at 13:00, Srinivasa Chamarthy <chamarthy.raju@gmail.com> wrote:

<snip>

> # cat test1.fio
> [global]
> ioengine=libaio
> size=1m
> blocksize=1024k,1024k
> iodepth=8
> iodepth_batch=4
> iodepth_low=2
> ;runtime=60
> ;time_based
> filename=testfile_test1
> numjobs=1
>
> [pattern_one_seq_write]
> buffer_pattern=0xff
> readwrite=write

So the file size is 1024KBytes, the block size is 1024KBytes and you
would like to queue 8 x 1024KByte (i.e. 8192KBytes) blocks in parallel
at any one time? Is that correct and your intent?

One immediate issue is that you aren't likely to achieve your I/O
depth of 8 because OS restrictions on buffered I/O (see
https://github.com/axboe/fio/blob/fio-2.2.7/HOWTO#L785 for warning
about libaio and buffered I/O case).

-- 
Sitsofe | http://sucs.org/~sits/

