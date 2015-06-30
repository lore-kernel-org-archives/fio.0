Return-Path: <axboe@kernel.dk>
Message-ID: <559210FF.6030900@kernel.dk>
Date: Mon, 29 Jun 2015 21:46:07 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: FreeBSD build broken following _Static_assert commit
References: <5591C7F0.1090004@cran.org.uk> <55920381.6060906@kernel.dk> <55920FE0.60901@cran.org.uk>
In-Reply-To: <55920FE0.60901@cran.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Bruce Cran <bruce@cran.org.uk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 06/29/2015 09:41 PM, Bruce Cran wrote:
> On 6/29/2015 8:48 PM, Jens Axboe wrote:
>> Thanks for reporting this, Bruce. No idea why clang complains about
>> that, it's definitely a constant expression. Anyway, committed this:
>>
>> http://git.kernel.dk/cgit/fio/commit/?id=94815a5c8366a9290167e8539f29994c2d43d15c
>>
>>
>> which adds this sort of check to the configure _Static_assert() check.
>
> It seems the relevant text is:
>
> note: cast that performs the conversions of a reinterpret_cast is not
> allowed in a constant expression

But it's bogus, it's nothing but static pointer math.

> Is there something about our use of offsetof that means we can't depend
> on the version from <stddef.h>?

No other reason than having a generic solution is superior to depending 
on whatever might be supplied with the given system.

-- 
Jens Axboe


