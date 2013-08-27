Return-Path: <jcasse@google.com>
MIME-Version: 1.0
In-Reply-To: <CANEJEGvXJBaE8PU47-ZgHwmyKs8eUo9-Bg7yDPL8iZH-SoxfCw@mail.gmail.com>
References: <1377552162-31741-1-git-send-email-jcasse@chromium.org>
	<521CDBC2.8050705@kernel.dk>
	<CANEJEGvXJBaE8PU47-ZgHwmyKs8eUo9-Bg7yDPL8iZH-SoxfCw@mail.gmail.com>
Date: Tue, 27 Aug 2013 10:50:29 -0700
Message-ID: <CAPet_22fniTug7ET_DqsqBj0jxGSK8qT6VOFs0Qk6ROuBfNLzQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] Adds check for numberio during verify phase.
From: Juan Casse <jcasse@google.com>
Content-Type: text/plain; charset=ISO-8859-1
To: Grant Grundler <grundler@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>, Juan Casse <jcasse@chromium.org>, FIO_list <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Jens,

sync IO:
You're right, this should work. The code change simply adds the check
for numberio to the existing fio infrastructure. I think my first
attempt had some problems and I did not test asynchronous io on my
finished code. I will run some tests to make sure that it works with
asynchronous io.

equal size read/writes:
I just realized after running a quick test that there is a problem.
With different read/write sizes, fio exited with an error:
fio: verify.c:960: populate_hdr: Assertion '0' failed.
I think this has to do with the offsets of the read and write blocks
being different when they're of different sizes. I need to figure out
what is going on. Any ideas Jens?

Here is the job used:
readwrite=randrw
randrepeat=1
size=1m
bs=4k,8k
ioengine=libaio
direct=1
buffered=0
rwmixread=30
rwmixwrite=70
norandommap
loops=2
verify=meta
verify_pattern=0xffffffffffffffff
verify_dump=1
continue_on_error=verify

On Tue, Aug 27, 2013 at 10:22 AM, Grant Grundler <grundler@chromium.org> wrote:
> On Tue, Aug 27, 2013 at 10:02 AM, Jens Axboe <axboe@kernel.dk> wrote:
> ...
>>> +data_integrity_check
>>> +             If this option is given, fio will check the i/o number of
>>> +             each block read back during the verification phase. Fio
>>> +             checks numberio to detect stale blocks. Currently, this
>>> +             option requires synchronous i/o, and equal-sized read and
>>> +             write blocks. This option requires workloads that write data.
>>
>> I think this use case is just too narrow.
>
> Jens.
> This behavior should be standard behavior for the data integrity
> checking. To debug data corruption problems we need to know if it's
> stale data or corrupted data. Huge difference in how to track it down
> and potential causes. I'm arguing it shouldn't even be an option.
>
>> Why does it require sync IO and equal read/write sizes?
>> Can't you just replay and re-generate and compare?
>
> I think it's just limitations of this implementation and testing. In
> principle I think you are right. Perhaps Juan can explain in more
> detail.
>
> cheers,
> grant

