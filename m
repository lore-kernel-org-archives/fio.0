Return-Path: <axboe@kernel.dk>
Subject: Re: Segfault in fio_libaio_getevents
References: <CALjAwxhbN5aOz+MeVg8wSatS55eGYg7vqDVzguGP6Hsowjt9JA@mail.gmail.com>
 <4c2dc64e-5b4e-872d-1e09-d3191c87d5ca@kernel.dk>
 <CALjAwxhJWrAyraQsGYm0D+_Nw8kg6LLaoeW3KCHsNxz2=8_8=Q@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <19fdc2cb-2adf-05a6-7a4d-4c7f37080050@kernel.dk>
Date: Tue, 16 Aug 2016 08:44:30 -0600
MIME-Version: 1.0
In-Reply-To: <CALjAwxhJWrAyraQsGYm0D+_Nw8kg6LLaoeW3KCHsNxz2=8_8=Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>



On 08/15/2016 11:53 PM, Sitsofe Wheeler wrote:
> On 16 August 2016 at 03:12, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 08/13/2016 04:26 AM, Sitsofe Wheeler wrote:
>>>
>>> With fio-2.12-3-g8a09 I've seen the occasional segfault while running
>>> a job like this:
>>>
>>> ./fio --allow_file_create=0 --randseed=1 --rw=randread --direct=1
>>> --iodepth=16  --ioengine=libaio --bs=64k --time_based=1 --runtime=12h
>>> --random_distribution=zipf:0.8 --name=go --filename  /dev/sde
>>>
>>> Here's a backtrace:
>>> Thread 1 (Thread 0x7f8518911740 (LWP 4078)):
>>> #0  fio_libaio_getevents (td=0x7f850076fa80, min=15, max=15,
>>> t=<optimized out>) at engines/libaio.c:161
>>> #1  0x000000000041a493 in td_io_getevents (td=td@entry=0x7f850076fa80,
>>> min=15, max=<optimized out>, t=0x0) at ioengines.c:241
> [...]
>>
>> Huh, weird. Is this a new regression?
>
> I don't think it's new. I've seen this with Fedora's older
> fio-2.6-1.fc24.x86_64 RPM:
> Stack trace of thread 8294:
> #0  0x000000000046b458 fio_libaio_getevents (fio)
> #1  0x000000000041b9a3 td_io_getevents (fio)
> #2  0x0000000000440509 io_u_queued_complete (fio)
> #3  0x000000000040cec4 cleanup_pending_aio (fio)
> #4  0x000000000045f658 thread_main (fio)
> #5  0x00000000004609ce run_threads (fio)
> #6  0x0000000000460e4d fio_backend (fio)
> #7  0x000000000040ddea main (fio)
> #8  0x00007fa7f1013731 __libc_start_main (libc.so.6)
> #9  0x000000000040de39 _start (fio)
>
> I don't think it happens in the normal course of operation but only
> when a device mapper device is somehow removed while fio is still
> using it? So far I've been unable to identify the steps that lead up
> to it.
>

It makes very little sense. td->eo is NULL, which would only happen
after the process has exited and called close_ioengine(), yet your trace
is off the main IO path (so the thread definitely hasn't exited). Are
you positive that your core dump and fio executable/symbols match up?

-- 
Jens Axboe

