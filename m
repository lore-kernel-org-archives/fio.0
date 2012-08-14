Return-Path: <greg.sullivan@sullivang.net>
MIME-Version: 1.0
In-Reply-To: <CAHaS=Qz9b2UzcUegFBbFzdiy0j48JJ-DP_oFMqAWYhjYP3BQiA@mail.gmail.com>
References: <CAHaS=Qz8_g=0RqV53G_PuSM7Apvbbn3ksuF5MvkFUo7vme40Fw@mail.gmail.com>
	<502A4D22.3090200@kernel.dk>
	<CAHaS=Qz9b2UzcUegFBbFzdiy0j48JJ-DP_oFMqAWYhjYP3BQiA@mail.gmail.com>
Date: Tue, 14 Aug 2012 23:33:32 +1000
Message-ID: <CAHaS=QzG3mp=ZfC+yfd1pxDVcNp-HMsbh-f7Pef-xqGQpuomDg@mail.gmail.com>
Subject: Re: How to do strict synchronous i/o on Windows?
From: Greg Sullivan <greg.sullivan@sullivang.net>
Content-Type: text/plain; charset=ISO-8859-1
To: axboe@kernel.dk
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

How exactly does fio behave at the moment for round-robin file access,
when using synchronous io? I would have expected it to behave as I
wanted - the documentation says that the ios are farmed out to each
file in a round-robin fashion, so surely if the io is done
synchronously, it means that the thread issuing that io will wait
until that io has completed! And if it does that, the round-robin
allocator would not trigger the next "thread" to issue it's read until
the current io had completed, which is exactly what I want! :)

Greg.

On 14 August 2012 23:19, Greg Sullivan <greg.sullivan@sullivang.net> wrote:
> Thanks Jens. I do in fact have an application that reads in exactly the
> manner I described. I have monitored the queue depth - it does not rise
> above 1.  It is a real time musical sample streamer.
>
> Please consider this a new feature request for fio - thankyou.
>
> Greg.
>
>
> On Aug 14, 2012 11:06 PM, "Jens Axboe" <axboe@kernel.dk> wrote:
>>
>> On 08/14/2012 08:24 AM, Greg Sullivan wrote:
>> > I need to simulate strict synchronous, round robin i/o to a group of
>> > files. I am on Windows 7 32-bit.
>> > fio is very nearly working, except that even with a queue depth of 1,
>> > it is still resulting in a disk queue that is > 1, because the
>> > "iodepth" parameter is not global - it is per thread. (correct?)
>> >
>> > I've tried using the "sync" engine, however that doesn't work at all -
>> > just spews out errors.
>>
>> That'll be the case for ANY platform and IO engine. If you have more
>> than 1 thread or process going, you can have > 1 depth at the device
>> side. The definition of a sync IO call is that the call doesn't return
>> until the IO is done. If you have overlapped calls due to more than 1
>> thread, then that is no longer true.
>>
>> What you are looking for is outside the scope of an application. You
>> would have to limit the queue depth on the operating system side to
>> achieve that. Or artificially limit fio in some way, which would not
>> make a lot of sense imho.
>>
>> --
>> Jens Axboe
>>

