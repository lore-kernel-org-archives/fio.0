Return-Path: <bruce@cran.org.uk>
Subject: Re: FreeBSD build broken following _Static_assert commit
References: <5591C7F0.1090004@cran.org.uk> <55920381.6060906@kernel.dk>
From: Bruce Cran <bruce@cran.org.uk>
Message-ID: <55920FE0.60901@cran.org.uk>
Date: Mon, 29 Jun 2015 21:41:20 -0600
MIME-Version: 1.0
In-Reply-To: <55920381.6060906@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 6/29/2015 8:48 PM, Jens Axboe wrote:
> Thanks for reporting this, Bruce. No idea why clang complains about 
> that, it's definitely a constant expression. Anyway, committed this:
>
> http://git.kernel.dk/cgit/fio/commit/?id=94815a5c8366a9290167e8539f29994c2d43d15c 
>
>
> which adds this sort of check to the configure _Static_assert() check. 

It seems the relevant text is:

note: cast that performs the conversions of a reinterpret_cast is not 
allowed in a constant expression

Is there something about our use of offsetof that means we can't depend 
on the version from <stddef.h>?

-- 
Bruce


