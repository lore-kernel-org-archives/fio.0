Return-Path: <ntolia@maginatics.com>
MIME-Version: 1.0
In-Reply-To: <50EC7B02.7040901@kernel.dk>
References: <CA+6NFoBAhy8jR8jg8_MqDH8WP_e+Y2BVFxCysKo2Nqhkj8cmZw@mail.gmail.com>
 <50EC7B02.7040901@kernel.dk>
From: Niraj Tolia <ntolia@maginatics.com>
Date: Tue, 8 Jan 2013 21:32:22 -0800
Message-ID: <CA+6NFoDJfD10ZtEVCkDpETVOWJZYpD_SwmiEHH-F0p5tndKYJw@mail.gmail.com>
Subject: Re: Segfault on OS X
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Tue, Jan 8, 2013 at 12:01 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On Tue, Jan 08 2013, Niraj Tolia wrote:
>> I am running fio (HEAD:a28b019) on OS X (10.8.2) and just ran into a
>> segfault after more than an hour of running the benchmark. Will dig
>> into this more but wanted to check if someone else had run into this.
>> I did manage to get a core though. There were three threads running
>> with two sitting in __semwait_signal () (via usleep) and the third
>> was:
>>
>> [Switching to thread 3 (core thread 2)]
>> 0x000000010fcf7910 in thread_main (data=0x1105fe000) at backend.c:510
>> 510            if (break_on_this_error(td, io_u->ddir, &ret))
>> (gdb) where
>> #0  0x000000010fcf7910 in thread_main (data=0x1105fe000) at backend.c:510
>> #1  0x00007fff885d1742 in _pthread_start ()
>> #2  0x00007fff885be181 in thread_start ()
>>
>> It seems like io_u is null here.
>
> My first thought was "impossible", but looking at the code, we do
> clear io_u on requeue events. So that dereference below the
> main switch is a bug. The below should fix it, I've committed it.
>

Thanks for the really quick turn-around. I picked up the patch and ran
it for a while without any failures. Will definitely report back if
something else comes up.

Cheers,
Niraj

