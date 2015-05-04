Return-Path: <bfulton@google.com>
MIME-Version: 1.0
In-Reply-To: <5547EDD7.9000903@kernel.dk>
References: <CAFFT=UmoooCznxAkUREsC5rGN-hxD++PYbL94s-m11jdycDM0w@mail.gmail.com>
	<5547D99E.4080103@kernel.dk>
	<CANff2=M1nm3GhJ-3RWVyzMHx9WE-SdO=eUUdwOKmC39HT9HQ-A@mail.gmail.com>
	<5547EC73.5030001@kernel.dk>
	<5547EDD7.9000903@kernel.dk>
Date: Mon, 4 May 2015 16:17:27 -0700
Message-ID: <CANff2=NEJF6YJ-yzf5BcFjpLp_P83S3mRvk3baZdRj02mgqkMQ@mail.gmail.com>
Subject: Re: [Bug report] Runtime, IOPS, bandwidth recorded incorrectly if
 small size with time_based
From: Brian Fulton <bfulton@google.com>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: Akash Verma <akashv@google.com>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Hi Jens,

Akash and I both discovered this bug and work together.  He is
currently on holiday for the next two weeks or so.  I am currently
using the same tests that originally discovered the bug to verify it
is fixed.

Out of curiosity, why is the comma required after the zero in order to
initialize all elements to zero?  I used this initializer instead of
memset just as it was used here:
https://github.com/axboe/fio/blob/master/cgroup.c#L26.  Are there
certain compilers that require the comma?  I also checked the C99 spec
http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf, Section
6.7.8, page 125, sections 1 and 21.  I just want to make sure I'm not
loosing my mind.

Thanks,
Brian

On Mon, May 4, 2015 at 3:08 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 05/04/2015 04:02 PM, Jens Axboe wrote:
>>
>> On 05/04/2015 03:25 PM, Brian Fulton wrote:
>>>
>>> Hi Jens,
>>>
>>> I've been actively looking at this bug.  It was introduced with change
>>> e5437a073e658e8154b9e87bab5c7b3b06ed4255
>>>
>>> (https://github.com/axboe/fio/commit/e5437a073e658e8154b9e87bab5c7b3b06ed4255).
>>>
>>>
>>> In this change, the time granularity was changed from microseconds to
>>> milliseconds.  This change assumes that all loops take at least 1ms to
>>> complete.  This is not always true and tests where the loop gets
>>> processed, regularly, in sub-millisecond time result in many zeroes
>>> being summed which, ultimately, causes a completely inaccurate
>>> runtime.
>>>
>>> I have a fix for this, but I want to verify that it doesn't break
>>> anything as it is changing the way the runtime is being calculated.
>>>
>>> We are using fio version 2.2.6, though this issue should still be
>>> present in the latest version (2.2.7).
>>>
>>>
>>> Below is a patch fix based of the latest version of fio 2.2.7:
>>
>>
>> Thanks, that makes more sense. Akash, can you confirm that this fixes it
>> for you?
>
>
> Committed:
>
> http://git.kernel.dk/?p=fio.git;a=commit;h=95603b7470fac1917cb11bc686e60b4339f8a2fc
>
> Brian, I changed a few things:
>
> - DDIR_RWDIR_CNT exists for array sizing
> - You need a ',' after that zero to clear the array
> - Style
>
> --
> Jens Axboe
>

