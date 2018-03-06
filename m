Return-Path: <rebecca@bluestop.org>
Subject: Re: Windows: FIO randomly hangs using attached script
References: <e044afaa-22ad-c7e2-d041-e2658f49bac8@bluestop.org>
 <02704178-12f3-78c7-915c-f7ebf2a28106@kernel.dk>
From: Rebecca Cran <rebecca@bluestop.org>
Message-ID: <5273e682-6353-97f8-faeb-7221a2b1b18e@bluestop.org>
Date: Tue, 6 Mar 2018 15:35:58 -0700
MIME-Version: 1.0
In-Reply-To: <02704178-12f3-78c7-915c-f7ebf2a28106@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 3/6/2018 2:53 PM, Jens Axboe wrote:
> On 3/5/18 6:23 PM, Rebecca Cran wrote:
>> I've had a report that FIO on Windows (at least Server 2012 R2 and 2016)
>> hangs when the attached script is run. The point at which it hangs is
>> apparently random, and within the condvar (pthread-win32) calls.
>>
>> I've replicated the hang, but I don't have time to debug it so I was
>> hoping somebody on this mailing list might have time to dig into it and
>> figure out what's wrong.
>>
>> The people I was talking to thought it might be due to FIO linking to
>> msvcrt.dll, which is old and not supposed to be used by applications -
>> they should use the CRT distributed with Visual C++, such as
>> msvcr120.dll instead. However, it appears that fixing this would take
>> quite a lot of work since while FIO is relatively straightforward to
>> change, pthread-win32 hasn't had a full release since 2012 and doesn't
>> build under a current msys environment due to duplicated symbols etc.
> Do you at least know what mutex it's hanging on?

No, I didn't get around to checking that.

-- 
Rebecca

