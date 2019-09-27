Return-Path: <tom.leiming@gmail.com>
MIME-Version: 1.0
References: <20190927080249.GA19514@ming.t460p> <0bc98379-408b-310a-31e4-0b3fbf85f1c9@kernel.dk>
In-Reply-To: <0bc98379-408b-310a-31e4-0b3fbf85f1c9@kernel.dk>
From: Ming Lei <tom.leiming@gmail.com>
Date: Fri, 27 Sep 2019 18:05:08 +0800
Message-ID: <CACVXFVMb0=4XTMzRb7m5hk4KFzgyF1iZcryumRXMXQ-Nqp76kQ@mail.gmail.com>
Subject: Re: fio: iodepth_batch_submit is broken on libaio
Content-Type: text/plain; charset="UTF-8"
To: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Fri, Sep 27, 2019 at 5:59 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 9/27/19 10:02 AM, Ming Lei wrote:
> > Hi Jens,
> >
> > Looks fio's 'iodepth_batch_submit' is broken.
> >
> > When running the attached fio script[1], I observed that 'nr' passed to
> > io_submit() is 1, except that 64 is only passed to the 1st io_submit().
> >
> > Then plug merging can't work at all.
> >
> > [root@ktest-08 tools]# cat bpf
> > #include <uapi/linux/aio_abi.h>
> > tracepoint:syscalls:sys_enter_io_submit { @nr = hist(args->nr); }
> > [root@ktest-08 tools]# bpftrace ./bpf
> > Attaching 1 probe...
> > ^C
> >
> > @nr:
> > [1]               902349 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
> > [2, 4)                 0 |                                                    |
> > [4, 8)                 0 |                                                    |
> > [8, 16)                0 |                                                    |
> > [16, 32)               0 |                                                    |
> > [32, 64)               0 |                                                    |
> > [64, 128)              1 |                                                    |
> >
> > [1] fio script:
> > fio --readwrite=write --filesize=4g --filename=/dev/sda \
> >       --runtime=10s --time_based \
> >       --ioengine=libaio --direct=1 --bs=4k --iodepth=64 \
> >       --iodepth_batch_submit=64 \
> >       --numjobs=64 \
> >       --name=foo
>
> Try adding iodepth_batch_complete as well.

Yeah, it works, thanks!


-- 
Ming Lei

