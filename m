Return-Path: <axboe@kernel.dk>
Message-ID: <5547EC73.5030001@kernel.dk>
Date: Mon, 04 May 2015 16:02:27 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [Bug report] Runtime, IOPS, bandwidth recorded incorrectly if
 small size with time_based
References: <CAFFT=UmoooCznxAkUREsC5rGN-hxD++PYbL94s-m11jdycDM0w@mail.gmail.com>	<5547D99E.4080103@kernel.dk> <CANff2=M1nm3GhJ-3RWVyzMHx9WE-SdO=eUUdwOKmC39HT9HQ-A@mail.gmail.com>
In-Reply-To: <CANff2=M1nm3GhJ-3RWVyzMHx9WE-SdO=eUUdwOKmC39HT9HQ-A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Brian Fulton <bfulton@google.com>
Cc: Akash Verma <akashv@google.com>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 05/04/2015 03:25 PM, Brian Fulton wrote:
> Hi Jens,
>
> I've been actively looking at this bug.  It was introduced with change
> e5437a073e658e8154b9e87bab5c7b3b06ed4255
> (https://github.com/axboe/fio/commit/e5437a073e658e8154b9e87bab5c7b3b06ed4255).
>
> In this change, the time granularity was changed from microseconds to
> milliseconds.  This change assumes that all loops take at least 1ms to
> complete.  This is not always true and tests where the loop gets
> processed, regularly, in sub-millisecond time result in many zeroes
> being summed which, ultimately, causes a completely inaccurate
> runtime.
>
> I have a fix for this, but I want to verify that it doesn't break
> anything as it is changing the way the runtime is being calculated.
>
> We are using fio version 2.2.6, though this issue should still be
> present in the latest version (2.2.7).
>
>
> Below is a patch fix based of the latest version of fio 2.2.7:

Thanks, that makes more sense. Akash, can you confirm that this fixes it 
for you?

-- 
Jens Axboe


