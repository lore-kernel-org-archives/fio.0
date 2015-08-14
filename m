Return-Path: <axboe@kernel.dk>
Message-ID: <55CE4693.5050503@kernel.dk>
Date: Fri, 14 Aug 2015 13:50:43 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: server mode and verify_dump
References: <CALjAwxh7sx3OHw9Gb=gBwet+YqpJNNDzZusNZK7X7bGK0Z06pQ@mail.gmail.com>	<55CE0DA9.6050204@kernel.dk>	<55CE1025.6080009@kernel.dk>	<CALjAwxjk6TG+UO6d3L_7Fq=Ucm5WBtkMLLQwSqx+F_J9f=gReg@mail.gmail.com>	<55CE3ED4.8020505@kernel.dk>	<CALjAwxhbjE4xTZ5jA_m-0spFTtvwJb_bNZz7m7cPRcCXLY1wNA@mail.gmail.com>	<55CE4001.8090705@kernel.dk> <CALjAwxg9c2Mgykc9tH7gm4qH_RRHQ=SkQyxWuYi2NdDP9Fo4HA@mail.gmail.com>
In-Reply-To: <CALjAwxg9c2Mgykc9tH7gm4qH_RRHQ=SkQyxWuYi2NdDP9Fo4HA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 08/14/2015 01:41 PM, Sitsofe Wheeler wrote:
> On 14 August 2015 at 20:22, Jens Axboe <axboe@kernel.dk> wrote:
>> On 08/14/2015 01:21 PM, Sitsofe Wheeler wrote:
>>>
>>> On 14 August 2015 at 20:17, Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> Right, I suspected that might have been the case. If the header isn't
>>>> valid,
>>>> then fio doesn't dump any contents. One could argue that it would be
>>>> cleaner
>>>
>>>
>>> What do you think it would take to dump a block's worth of data when
>>> encountering a header error during a verify?
>>
>>
>> Without a valid header, we can't re-generate the data. That's why it
>> currently doesn't dump the expected contents if the header verification
>> fails.
>
> I see. Even fixed patterns would be a pain unless they have an
> entirely separate code path. How about just dumping whatever you
> received even if it was just a header's worth?

It's not guaranteed that we could do it. We could always just fake up a 
new header, but we don't know the seed and other important things. It 
would be trivial to dump the received block of data, but that seems a 
bit pointless when we don't have the expected data. Since the 
offset+size is listed in the output, getting the same from 'dd' or a 
similar tool would be easy enough.

But I'm willing to be convinced. Dumping the received data is a quick 
change.

-- 
Jens Axboe


