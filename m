Return-Path: <grundler@google.com>
MIME-Version: 1.0
In-Reply-To: <20140128192359.GB15212@kernel.dk>
References: <CANEJEGu_qW7rBB75B-Xppy8X-_=+dy951H7DeJ+9phJ4L=LVWg@mail.gmail.com>
	<20140128192359.GB15212@kernel.dk>
Date: Tue, 28 Jan 2014 13:06:06 -0800
Message-ID: <CANEJEGv42d2LEX=XwcO22-4BF8Tw59NBL8R1MOUma+pLGL1ERQ@mail.gmail.com>
Subject: Re: rand_seed declarations not consistent...is that ok?
From: Grant Grundler <grundler@google.com>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: FIO_list <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Tue, Jan 28, 2014 at 11:24 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On Tue, Jan 28 2014, Grant Grundler wrote:
>> cscope tells me:
>> C symbol: rand_seed
>>
>>   File             Function                  Line
>> 0 ioengine.h       <global>                    59 unsigned long rand_seed;
>> 1 options.c        <global>                  1660 .off1 =
>>                                                   td_var_offset(rand_seed),
>> 2 thread_options.h <global>                   103 unsigned int rand_seed;
>> 3 thread_options.h <global>                   327 uint32_t rand_seed;
>> 4 verify.h         <global>                    34 uint64_t rand_seed;
>>
>> Any reason we have 4 different declarations of the same name?
>> Thoughts on if/how this should be fixed?
>>
>> Even if it's not wrong, it's definitely confusing.
>
> Heh no. But they are not all the same. Could be cleaned up, but the
> parser has some expectations and the thread_options.h one has the local
> and over-the-net client version (which is why they are different, one
> matches the parser and the other is independent).

I gathered there were some differences. :)

> I would suggest we make 0/3/4 a uint64_t to unify that part.

That's easy. Patch sent: [PATCH] fio: consolidate rand_seed to uint64_t
Did I interpret that correctly?

BTW, I've not tested that patch...will do that and reply to the patch
if there are any new issues.


> The option could be made
> unsigned long long and the type changed.

I think this needs a bit more research (but only very little). Anyone
else want a relatively quick/easy project?
I don't need all the glory. :)

cheers,
grant

