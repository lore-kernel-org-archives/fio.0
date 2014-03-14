Return-Path: <axboe@kernel.dk>
Message-ID: <53236D0B.5040507@kernel.dk>
Date: Fri, 14 Mar 2014 14:56:43 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Possible bug when setting compression
References: <CAF+0mvm1bjy99fbM_jkr9Sp7bbgnQSpr3WkeZ7Zgju9hFdNaSA@mail.gmail.com>	<532349BF.4010307@kernel.dk>	<CAF+0mv=crXGQfof7jrRSnKnmGJ3k4AW7CdaLtgJEdpFzsXENng@mail.gmail.com>	<532361FE.10901@kernel.dk>	<53236538.2040903@kernel.dk> <CAF+0mv=q-nEGkeQdJgwH78_3n6novRHAWfRwp=QHa8dFinYd3Q@mail.gmail.com>
In-Reply-To: <CAF+0mv=q-nEGkeQdJgwH78_3n6novRHAWfRwp=QHa8dFinYd3Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Matthew Eaton <m.eaton82@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 03/14/2014 02:53 PM, Matthew Eaton wrote:
>> So that wont work as-is, since the parser will bypass the store when the
>> callback is specified. It needs a one-liner, please try this updated one
>> instead.
>>
>> --
>> Jens Axboe
>>
>
> Ok, so it looks like everything works now except for zero_buffers.
>
> fio-2.1.6.1-11-g0574 + patch
>
> buffer_compress_percentage=100
> iops=83457
>
> buffer_compress_percentage=50
> iops=78836
>
> buffer_compress_percentage=1
> iops=52785
>
> buffer_compress_percentage=0
> iops=51013
>
> zero_buffers
> iops=69465
>
> scramble_buffers=0
> zero_buffers
> iops=83451

zero_buffers and buffer_compres_percentage=100 are essentially the same 
thing, for both cases it writes buffers just fill of zeroes. So I'm not 
sure what you were expecting here since you don't think it works as it 
should?

If you have both zero_buffers and scramble set, then the result will be 
a bit less compressible. The goal of scramble_buffers is to defeat basic 
dedupe attempts. So even if you don't fully refill your buffers every 
time, the blocks will be a bit different.

-- 
Jens Axboe



