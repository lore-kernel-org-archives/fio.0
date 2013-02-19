Return-Path: <haghdoost@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20130218080453.GB6003@kernel.dk>
References: <CAB-428nhEKv83KVm03NMGgSEbHGTjGAgv8Prkt7xFRmznzJfGA@mail.gmail.com>
 <20130218080453.GB6003@kernel.dk>
From: Alireza Haghdoost <haghdoost@gmail.com>
Date: Mon, 18 Feb 2013 20:49:30 -0600
Message-ID: <CAB-428mXmSmJ41fWVUd_t16-tyiY7n05mirp=9-Oxg0Du=HQWA@mail.gmail.com>
Subject: Re: Workload Request Size issue
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Mon, Feb 18, 2013 at 2:04 AM, Jens Axboe <axboe@kernel.dk> wrote:
>
> On Sat, Feb 16 2013, Alireza Haghdoost wrote:
> > Hello,
> >
> > I am using fio to generate a simple sequential workload with request
> > size of 128K with following job file but I can observe the generated
> > IO request size is 4K, I was wondering who is responsible in block
> > layer to shrink the fio requests granularity from 128K to 4K ? :
> >
> >
> >       1 ; -- start job file --
> >       2 [global]
> >       3 rw=write
> >       4 size=128M
> >       5
> >       6 [job1]
> >       7 ioengine=libaio
> >       8 iodepth=512
> >       9 bs=128k
> >      10 direct=1
> >      11 numjobs=1
> >      12 filename=/dev/sde
> >      13 ; -- end job file --
> >
> >
> > The blktrace shows that the request sizes are all 4KB (8 sector), here
> > is a peace of output trace that collected while fio is running.
> >
> >      21   8,64   5       21     0.000031322 29848  I   W 32 + 8 [fio]
> >      22   8,64   5       22     0.000031868 29848  Q  WS 40 + 8 [fio]
> >      23   8,64   5       23     0.000032181 29848  G  WS 40 + 8 [fio]
> >      24   8,64   5       24     0.000032352 29848  I   W 40 + 8 [fio]
> >      25   8,64   5       25     0.000032826 29848  Q  WS 48 + 8 [fio]
> >      26   8,64   5       26     0.000033145 29848  G  WS 48 + 8 [fio]
> >      27   8,64   5       27     0.000033310 29848  I   W 48 + 8 [fio]
> >      28   8,64   5       28     0.000033781 29848  Q  WS 56 + 8 [fio]
> >      29   8,64   5       29     0.000034045 29848  G  WS 56 + 8 [fio]
> >      30   8,64   5       30     0.000034227 29848  I   W 56 + 8 [fio]
> >      31   8,64   5       31     0.000034498 29848  D   W 32 + 8 [fio]
> >      32   8,64   5       32     0.000036314 29848  D   W 40 + 8 [fio]
> >      33   8,64   5       33     0.000038032 29848  D   W 48 + 8 [fio]
>
> What kernel are you using? For a proper setup, the above fio job should
> go down to the hardware as 128KB sized requests. Depending on the kernel
> and driver, there might be timing issues that cause it to not get
> properly coalesced in the scheduler, however.
>
> --
> Jens Axboe
>

Jens,

Thanks for your replay. I am using Ubuntu server 10.10 kernel version
2.6.35-22-server. /dev/sde is a NAS drive. NIC card adapter is QLogic
Fiber Channel and we are using qla2xxx driver. I believe somewhere in
block layer interface 128KB request converts to 8KB requests. I am
using noop IO scheduler with queue size (nr_request) of 2048 and
nomerge value 2.

I really appreciate your further input.

Thanks
Alireza

