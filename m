Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:45358 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab2LUVag (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 21 Dec 2012 16:30:36 -0500
Message-ID: <50D4D4F9.5070606@kernel.dk>
Date: Fri, 21 Dec 2012 22:30:33 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] gettime: minimize integer division
References: <50D26157.5020802@micron.com> <50D2C8FD.2070901@kernel.dk> <50D3487E.7000402@micron.com> <50D352D7.2090901@kernel.dk> <50D365AA.9080202@micron.com> <50D48139.30601@kernel.dk> <80B89753B40C5141A3E2D53FE7A2A8A93003BD3F@NTXBOIMBX02.micron.com>
In-Reply-To: <80B89753B40C5141A3E2D53FE7A2A8A93003BD3F@NTXBOIMBX02.micron.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2012-12-21 22:28, Sam Bradshaw (sbradshaw) wrote:
> 
>> -----Original Message-----
>> From: Jens Axboe [mailto:axboe@kernel.dk]
>> Sent: Friday, December 21, 2012 7:33 AM
>> To: Sam Bradshaw (sbradshaw)
>> Cc: fio@vger.kernel.org
>> Subject: Re: [PATCH] gettime: minimize integer division
>>
>> On 2012-12-20 20:23, Sam Bradshaw wrote:
>>>
>>>
>>> Something like this might work, though that amount of logic may
>>> be equivalent in terms of cycles to the divide.
>>
>> So I took a look at it. The costly bit is the division by
>> cycles_per_usec, which the compiler has no other option than turn into a
>> divq. The modulo and divide by 1M can be turned into something more
>> clever, basically shifts and imull.
>>
>> So how about the below? It turns the divq into multiplication and
>> division by 10M, which should be considerably less expensive. Can you
>> test and see how that works for you?
> 
> That works much better.  Several % lower execution time in fio_gettime().

Goodie

> IOPs look the same in my synthetic test but I'm not sure that's relevant;
> (it probably just needs some more tweaking).

It'd probably need 3-4M IOPS from a single thread to have a big impact.
But reduced CPU is leftover CPU for doing actual IO, so always a good
thing.

And just as important, did the timing look correct?

> I'll keep hunting for other hot spots.

Thanks!

-- 
Jens Axboe

