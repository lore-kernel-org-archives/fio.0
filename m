Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <19fdc2cb-2adf-05a6-7a4d-4c7f37080050@kernel.dk>
References: <CALjAwxhbN5aOz+MeVg8wSatS55eGYg7vqDVzguGP6Hsowjt9JA@mail.gmail.com>
 <4c2dc64e-5b4e-872d-1e09-d3191c87d5ca@kernel.dk> <CALjAwxhJWrAyraQsGYm0D+_Nw8kg6LLaoeW3KCHsNxz2=8_8=Q@mail.gmail.com>
 <19fdc2cb-2adf-05a6-7a4d-4c7f37080050@kernel.dk>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 21 Oct 2016 11:00:53 +0100
Message-ID: <CALjAwxjKrHJQWc16Ca=D=5nvfV6_ykRqm27jaa=oV8aa=afSwA@mail.gmail.com>
Subject: Re: Segfault in fio_libaio_getevents
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 16 August 2016 at 15:44, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 08/15/2016 11:53 PM, Sitsofe Wheeler wrote:
>>
>> On 16 August 2016 at 03:12, Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> On 08/13/2016 04:26 AM, Sitsofe Wheeler wrote:
>>>>
>>>> With fio-2.12-3-g8a09 I've seen the occasional segfault while running
>>>> a job like this:
>>>>
>>>> ./fio --allow_file_create=0 --randseed=1 --rw=randread --direct=1
>>>> --iodepth=16  --ioengine=libaio --bs=64k --time_based=1 --runtime=12h
>>>> --random_distribution=zipf:0.8 --name=go --filename  /dev/sde
>>>>
>>>> Here's a backtrace:
>>>> Thread 1 (Thread 0x7f8518911740 (LWP 4078)):
>>>> #0  fio_libaio_getevents (td=0x7f850076fa80, min=15, max=15,
>>>> t=<optimized out>) at engines/libaio.c:161
>>>> #1  0x000000000041a493 in td_io_getevents (td=td@entry=0x7f850076fa80,
>>>> min=15, max=<optimized out>, t=0x0) at ioengines.c:241
>>
>> [...]
>>>
>>> Huh, weird. Is this a new regression?
>>
>> I don't think it's new. I've seen this with Fedora's older
>> fio-2.6-1.fc24.x86_64 RPM:
>> Stack trace of thread 8294:
>> #0  0x000000000046b458 fio_libaio_getevents (fio)
>> #1  0x000000000041b9a3 td_io_getevents (fio)
>> #2  0x0000000000440509 io_u_queued_complete (fio)
>> #3  0x000000000040cec4 cleanup_pending_aio (fio)
>> #4  0x000000000045f658 thread_main (fio)
>> #5  0x00000000004609ce run_threads (fio)
>> #6  0x0000000000460e4d fio_backend (fio)
>> #7  0x000000000040ddea main (fio)
>> #8  0x00007fa7f1013731 __libc_start_main (libc.so.6)
>> #9  0x000000000040de39 _start (fio)
>>
>> I don't think it happens in the normal course of operation but only
>> when a device mapper device is somehow removed while fio is still
>> using it? So far I've been unable to identify the steps that lead up
>> to it.
>
> It makes very little sense. td->eo is NULL, which would only happen
> after the process has exited and called close_ioengine(), yet your trace
> is off the main IO path (so the thread definitely hasn't exited). Are
> you positive that your core dump and fio executable/symbols match up?

This is happening more regularly with fio-2.14-40-ge291c which was
statically built with the symbols inside. The key seems to be doing
I/O to an iSCSI connection where the target locks up (causing the I/O
to stall), then perhaps a minute after the hang has happened I try and
Ctrl-C fio. A bit after that fio says this:

fio: terminating on signal 2
fio: job 'go' (state=5) hasn't exited in 60 seconds, it appears to be
stuck. Doing forceful exit of this job.
fio: job 'go2' (state=5) hasn't exited in 60 seconds, it appears to be
stuck. Doing forceful exit of this job.
fio: job 'go3' (state=5) hasn't exited in 60 seconds, it appears to be
stuck. Doing forceful exit of this job.

the usual summary output is produced

Disk stats (read/write):
  sde: ios=519174/0, merge=0/0, ticks=3647890/0, in_queue=7226900, util=99.44%
  sdj: ios=449838/0, merge=0/0, ticks=3626910/0, in_queue=7205840, util=99.29%
  sdh: ios=481590/0, merge=0/0, ticks=3629520/0, in_queue=7208730, util=99.39%
fio: file hash not empty on exit
# fio: io_u error on file /dev/sde: Input/output error: read
offset=204995584, buflen=67584
fio: io_u error on file /dev/sdh: Input/output error: read
offset=9959732736, buflen=75776
fio: io_u error on file /dev/sdj: Input/output error: read
offset=803390594048, buflen=84480

but the cores are also made.

Backtrace says this:
Program terminated with signal SIGSEGV, Segmentation fault.
#0  fio_libaio_getevents (td=0x7fb0711e0ad0, min=0, max=1,
t=<optimized out>) at engines/libaio.c:160
#1  0x000000000040f405 in td_io_getevents (td=td@entry=0x7fb0711e0ad0,
min=<optimized out>, max=<optimized out>, t=<optimized out>) at
ioengines.c:237
#2  0x0000000000431bf7 in io_u_queued_complete
(td=td@entry=0x7fb0711e0ad0, min_evts=<optimized out>,
min_evts@entry=0) at io_u.c:1969
#3  0x000000000040086b in cleanup_pending_aio
(td=td@entry=0x7fb0711e0ad0) at backend.c:256
#4  0x0000000000451afb in do_io (bytes_done=<synthetic pointer>,
td=0x7fb0711e0ad0) at backend.c:1096
#5  thread_main (data=data@entry=0x1af7230) at backend.c:1714
#6  0x0000000000452c4c in run_threads (sk_out=sk_out@entry=0x0) at
backend.c:2268
#7  0x0000000000452f2d in fio_backend (sk_out=sk_out@entry=0x0) at
backend.c:2400
#8  0x00000000004030dc in main (argc=20, argv=0x7fff55c57788,
envp=<optimized out>) at fio.c:65

-- 
Sitsofe | http://sucs.org/~sits/

