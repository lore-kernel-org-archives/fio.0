Return-Path: <axboe@kernel.dk>
Message-ID: <55920381.6060906@kernel.dk>
Date: Mon, 29 Jun 2015 20:48:33 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: FreeBSD build broken following _Static_assert commit
References: <5591C7F0.1090004@cran.org.uk>
In-Reply-To: <5591C7F0.1090004@cran.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Bruce Cran <bruce@cran.org.uk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 06/29/2015 04:34 PM, Bruce Cran wrote:
> On FreeBSD 10.1 with clang 3.4.1, a standard "gmake" build now fails with:
>
> libfio.c:309:21: error: static_assert expression is not an integral
> constant expression
>          compiletime_assert((offsetof(struct thread_stat,
> percentile_list) % 8) == 0, "stat percentile_list");

Thanks for reporting this, Bruce. No idea why clang complains about 
that, it's definitely a constant expression. Anyway, committed this:

http://git.kernel.dk/cgit/fio/commit/?id=94815a5c8366a9290167e8539f29994c2d43d15c

which adds this sort of check to the configure _Static_assert() check.

-- 
Jens Axboe


