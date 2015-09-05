Return-Path: <axboe@kernel.dk>
Subject: Re: [RFC 0/6] Add support of formats for the pattern input
References: <1439980391-2311-1-git-send-email-r.peniaev@gmail.com>
 <55E9F22A.6050008@kernel.dk>
 <CACZ9PQU0FenB7sOfFyGns1EfkW9DJmimxxYsy4w+8nVgt2wUog@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <55EB1FD8.3000507@kernel.dk>
Date: Sat, 5 Sep 2015 11:01:12 -0600
MIME-Version: 1.0
In-Reply-To: <CACZ9PQU0FenB7sOfFyGns1EfkW9DJmimxxYsy4w+8nVgt2wUog@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Roman Peniaev <r.peniaev@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 09/05/2015 10:57 AM, Roman Peniaev wrote:
> On Fri, Sep 4, 2015 at 9:34 PM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 08/19/2015 04:33 AM, Roman Pen wrote:
>>>
>>> Hello, all.
>>>
>>> The intention of this patchset is to support dynamic formats for pattern
>>> input which is used for writing and verifying data, e.g. in the latest
>>> patch
>>> I added '%o' format, which means that current block offset will be written
>>> to
>>> the buffer and then verified back, i.e. this option can be used as the
>>> following:
>>>
>>>    verify_pattern=%o
>>>
>>> and the hexdump of generated file in my case is (few last lines):
>>>
>>>     ...
>>>     000f5c00  00 5c 0f 00 00 00 00 00  00 5c 0f 00 00 00 00 00
>>> |.\.......\......|
>>>     *
>>>     000fdc00  00 dc 0f 00 00 00 00 00  00 dc 0f 00 00 00 00 00
>>> |................|
>>>     *
>>>     000ffc00  00 fc 0f 00 00 00 00 00  00 fc 0f 00 00 00 00 00
>>> |................|
>>>     *
>>>     00100000
>>>
>>> So, each block is filled in with block offset in little endian order and 8
>>> bytes
>>> long.
>>>
>>> Unfortunately, 'buffer_pattern' option does not support formats, because
>>> it
>>> turned out to be a lot of changes which should be made to pass correct
>>> io_u->offset through the whole stack of calls. I left this task for
>>> future.
>>>
>>> Additionally, I moved all 'pattern' parsing/substituting logic to separate
>>> library file 'lib/pattern.[ch]'. Also, now 'verify_pattern' and
>>> 'buffer_pattern'
>>> support combined input which can consist of strings, numbers and formats
>>> (as was said formats are supported only by 'verify_pattern' option), e.g.
>>> let's
>>> consider the following example, where 'in' is a 'verify_pattern' or
>>> 'buffer_pattern' and 'out' is an output buffer filled in with bytes
>>> regarding
>>> specified pattern:
>>>
>>>     #1                 #2                 #3        #4
>>>       in="abcd"          in=-1024           in=66     in=0xFF0X1
>>>      out=61 62 63 64    out=00 fc ff ff    out=42    out=ff 01
>>>
>>>     #5                               #6
>>>       in=%o                            in="123"0xFFeeCC
>>>      out=00 00 00 00 00 00 00 00      out=31 32 33 ff ec cc
>>>
>>>     #7
>>>       in=-100xab"1"%o"2"
>>>       out=f6 ff ff ff ab 31 00 00 00 00 00 00 00 00 32
>>>
>>>     #8
>>>       in=%o0xdeadbeef%o
>>>      out=00 00 00 00 00 00 00 00 de ad be ef 00 00 00 00 00 00 00 00
>>>
>>>     #9
>>>        in=0xfefefefefefefefefefefefefefefefefefefefefe
>>>       out=fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe
>>>
>>> For %o format 8 bytes reserved in pattern, and when buffer is ready
>>> substitution occurs.
>>>
>>> The old behaviour is preserved: strings are in quotes, decimals are in the
>>> range [INT_MIN, INT_MAX], hexidecimals start from 0[Xx] and can be of any
>>> size (the limit is the maximum size of the pattern, which is 512).
>>>
>>> New behaviour: now you can combine everything together and additionally
>>> use formats (now %o is supported).
>>
>>
>> Sorry for the late response. This looks good, I have applied it. Care to
>> send updates for the HOWTO/man page as well?
>
> For sure. Frankly, I missed the man, I did update only HOWTO.

Ah you did, I missed the HOWTO update. If you could do the man page as 
well, I'd appreciate it.

> Jens, did you forget to review my patch related to moving meta header
> to generic verify_header? I also will resend it with man updates and rebased
> on latest changes.

I did, I've fallen a bit behind on review of fio patches. If you resend 
on the new base, I'll take a look at it. Thanks!

-- 
Jens Axboe


