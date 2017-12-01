Return-Path: <axboe@kernel.dk>
Subject: Re: memcpy test
References: <0aa59e33-54d4-cd80-350a-0f13bfa74a98@kernel.dk>
 <D2BFED30-2140-4453-9B7A-9D9EBA8C63E8@bluestop.org>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <bd913f2d-43af-d5bb-2673-4c7b27ee79c5@kernel.dk>
Date: Fri, 1 Dec 2017 12:56:27 -0700
MIME-Version: 1.0
In-Reply-To: <D2BFED30-2140-4453-9B7A-9D9EBA8C63E8@bluestop.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Rebecca Cran <rebecca@bluestop.org>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Sitsofe Wheeler <sitsofe@gmail.com>, Robert Elliott <elliott@hpe.com>
List-ID: <fio@vger.kernel.org>

On 12/01/2017 11:56 AM, Rebecca Cran wrote:
> 
>> On Dec 1, 2017, at 11:20 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> which is kind of depressing, since the fastest for larger sizes is the
>> very dumb and basic implementation that you'll find in any text book
>> under the section of "my first memcpy".
>>
>> Anyway, for evaluating implementations, we need a way to test them,
>> and now we have. I'll be happy to take input/patches on the test
>> itself.
> 
> Thanks - I meant to reply a few days ago and tell you I will work on a
> patch for this. 
> 
> For the simple case, does the compiler do anything interesting? For
> example, auto-vectorization should be simple for it to do if it knows
> the capabilities of the target machine.

Doesn't look like it - it just unrolls it a bit, and then uses movzbl.
So nothing exciting at all.

-- 
Jens Axboe


