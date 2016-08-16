Return-Path: <axboe@kernel.dk>
Subject: Re: Segfault in fio_libaio_getevents
References: <CALjAwxhbN5aOz+MeVg8wSatS55eGYg7vqDVzguGP6Hsowjt9JA@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <4c2dc64e-5b4e-872d-1e09-d3191c87d5ca@kernel.dk>
Date: Mon, 15 Aug 2016 20:12:32 -0600
MIME-Version: 1.0
In-Reply-To: <CALjAwxhbN5aOz+MeVg8wSatS55eGYg7vqDVzguGP6Hsowjt9JA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Sitsofe Wheeler <sitsofe@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>



On 08/13/2016 04:26 AM, Sitsofe Wheeler wrote:
> With fio-2.12-3-g8a09 I've seen the occasional segfault while running
> a job like this:
>
> ./fio --allow_file_create=0 --randseed=1 --rw=randread --direct=1
> --iodepth=16  --ioengine=libaio --bs=64k --time_based=1 --runtime=12h
> --random_distribution=zipf:0.8 --name=go --filename  /dev/sde
>
> Here's a backtrace:
> Thread 1 (Thread 0x7f8518911740 (LWP 4078)):
> #0  fio_libaio_getevents (td=0x7f850076fa80, min=15, max=15,
> t=<optimized out>) at engines/libaio.c:161
> #1  0x000000000041a493 in td_io_getevents (td=td@entry=0x7f850076fa80,
> min=15, max=<optimized out>, t=0x0) at ioengines.c:241
> #2  0x000000000043ead6 in io_u_queued_complete
> (td=td@entry=0x7f850076fa80, min_evts=<optimized out>) at io_u.c:1958
> #3  0x000000000045db9e in do_io (bytes_done=<synthetic pointer>,
> td=0x7f850076fa80) at backend.c:1048
> #4  thread_main (data=<optimized out>) at backend.c:1667
> #5  0x000000000045f3f7 in fork_main (offset=1, shmid=<optimized out>,
> sk_out=0x0) at backend.c:1830
> #6  run_threads (sk_out=sk_out@entry=0x0) at backend.c:2248
> #7  0x000000000045f76d in fio_backend (sk_out=sk_out@entry=0x0) at
> backend.c:2381
> #8  0x000000000040cf28 in main (argc=17, argv=0x7ffd99aef418,
> envp=<optimized out>) at fio.c:63
>
> Looking close to line 161 shows the following:
> 160 if (o->userspace_reap == 1
> 161    && actual_min == 0
> 162    && ((struct aio_ring *)(ld->aio_ctx))->magic
> 163 == AIO_RING_MAGIC) {
>
> (gdb) p o
> $1 = (struct libaio_options *) 0x0
> (gdb) p actual_min
> $2 = <optimized out>
> (gdb) p ((struct aio_ring *)(ld->aio_ctx))->magic
> Cannot access memory at address 0x7f8518903010

Huh, weird. Is this a new regression?

-- 
Jens Axboe

