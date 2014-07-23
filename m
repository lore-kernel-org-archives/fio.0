Return-Path: <scameron@beardog.cce.hp.com>
Date: Wed, 23 Jul 2014 09:22:04 -0500
From: scameron@beardog.cce.hp.com
Subject: Re: fio crash when using verify
Message-ID: <20140723142204.GK14599@beardog.cce.hp.com>
References: <20140722205947.GD14599@beardog.cce.hp.com> <53CF8A01.2090001@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53CF8A01.2090001@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, scameron@beardog.cce.hp.com
List-ID: <fio@vger.kernel.org>

On Wed, Jul 23, 2014 at 12:10:09PM +0200, Jens Axboe wrote:
> On 2014-07-22 22:59, scameron@beardog.cce.hp.com wrote:
> >
> >Hi Jens,
> >
> >I'm running into a crash with fio today, seems to be easily reproducible.
> >
> >[root@msablackburn saperf]# fio --version
> >fio-2.1.11-2-g90811
> >
> >(top of current git tree.)
> >
> >
> >[root@msablackburn saperf]# fio ./2drive_sdr_verify.fio
> >4_KiB_RR_drive_r: (g=0): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, 
> >ioengine=libaio, iodepth=170
> >4_KiB_RR_drive_s: (g=0): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, 
> >ioengine=libaio, iodepth=170
> >fio-2.1.11-2-g90811
> >Starting 2 threads
> >fio: io_u.c:1315: __get_io_u: Assertion `io_u->flags & IO_U_F_FREE' 
> >failed.a 58m:59s]
> >Aborted (core dumped)
> 
> Looks like there's a long standing race in the async verification. Does 
> this patch fix it for you?

So far so good.  Been running for about 30 minutes now when previously it
would crash within a minute or two.

Thanks,

-- steve


