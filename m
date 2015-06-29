Return-Path: <axboe@kernel.dk>
Message-ID: <55916C87.1030408@kernel.dk>
Date: Mon, 29 Jun 2015 10:04:23 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: competime_assert failure without -O3 optimization flag expected
 ?
References: <CAB-428=biE+PMVOA8qg_VcH9bf0ZVZO1dimXVh3KC3Z7j=QrmQ@mail.gmail.com> <5591687D.6040803@kernel.dk> <CAB-428=EKjcxK6J9OvKU1nM34Q998fN=LFQKgNgofeMb_cuY1g@mail.gmail.com> <55916A66.5080303@kernel.dk>
In-Reply-To: <55916A66.5080303@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Alireza Haghdoost <haghdoost@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 06/29/2015 09:55 AM, Jens Axboe wrote:
> On 06/29/2015 09:53 AM, Alireza Haghdoost wrote:
>> Sure, I will investigate it. Just want to confirm the issue is in the
>> compiletime_assert() code as you mentioned and it is not in that line
>> of code that I cite in my last email. I managed to remedy this issue a
>> little bit by using -O1 instead of -O3 but still the optimized program
>> order is not exactly similar to the default source code order.
>
> It bothers me too, I'll turn off optimizations for debugging things too,
> and just end up uncommenting the lines to make that work. Apparently it
> hasn't bothered me enough to fix it up yet, but I would love to see it
> fixed.

BTW, the issue is basically that without optimizations, gcc doesn't 
realize that the declared extern function doesn't get called. So asserts 
fail, doesn't matter if they are true or false.

-- 
Jens Axboe


