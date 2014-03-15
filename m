Return-Path: <axboe@kernel.dk>
Message-ID: <5323AF67.4090906@kernel.dk>
Date: Fri, 14 Mar 2014 19:39:51 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Possible bug when setting compression
References: <CAF+0mvm1bjy99fbM_jkr9Sp7bbgnQSpr3WkeZ7Zgju9hFdNaSA@mail.gmail.com>	<532349BF.4010307@kernel.dk>	<CAF+0mv=crXGQfof7jrRSnKnmGJ3k4AW7CdaLtgJEdpFzsXENng@mail.gmail.com>	<532361FE.10901@kernel.dk>	<53236538.2040903@kernel.dk>	<CAF+0mv=q-nEGkeQdJgwH78_3n6novRHAWfRwp=QHa8dFinYd3Q@mail.gmail.com>	<53236D0B.5040507@kernel.dk>	<CAF+0mvmV4DYyGvG_ccENE5NqhB-wuQsqUVQD8LY0mvM-hTeXoA@mail.gmail.com>	<532375B6.1060208@kernel.dk> <CAF+0mvmL6hmFkm2Tf__EYz=PUceEX=H4NURb9bm1_hY_XTmXVQ@mail.gmail.com>
In-Reply-To: <CAF+0mvmL6hmFkm2Tf__EYz=PUceEX=H4NURb9bm1_hY_XTmXVQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Matthew Eaton <m.eaton82@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 2014-03-14 16:26, Matthew Eaton wrote:
>> scramble_buffers tells fio to randomly insert some data in the buffer. It's
>> not a full overwrite or anything like that, just some basic garbage for each
>> 512b to prevent naive compression/dedupe.
>>
>> --
>> Jens Axboe
>>
>>
>
> Thanks, that makes sense.  I guess my only concern is one might expect
> that setting zero_buffers alone would provide fully compressible data,
> not realizing that scramble_buffers is still adding some random data
> unless explicitly turned off.
>
> Maybe something that could be added to the man page / how to under
> zero_buffers?  Something like...
>
> "If you want a fully compressible workload, also set scramble_buffers=0."

Sure, we can add that to make it completely clear.

-- 
Jens Axboe


