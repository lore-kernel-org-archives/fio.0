Return-Path: <axboe@kernel.dk>
Message-ID: <55929EED.9060509@kernel.dk>
Date: Tue, 30 Jun 2015 07:51:41 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: FreeBSD build broken following _Static_assert commit
References: <5591C7F0.1090004@cran.org.uk> <55920381.6060906@kernel.dk> <55920FE0.60901@cran.org.uk> <559210FF.6030900@kernel.dk> <55929806.7070002@cran.org.uk>
In-Reply-To: <55929806.7070002@cran.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Bruce Cran <bruce@cran.org.uk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 06/30/2015 07:22 AM, Bruce Cran wrote:
> On 6/29/2015 9:46 PM, Jens Axboe wrote:
>> But it's bogus, it's nothing but static pointer math.
>
> Apparently it's a known bug: https://llvm.org/bugs/show_bug.cgi?id=17410 .
> It looks like on FreeBSD there's no __compiler_offsetof (which on Linux
> ends up being defined as __builtin_offsetof) but clang _does_ provide
> __builtin_offsetof.

I used clang 3.6.0 to reproduce it, so apparently still not fixed. If 
you want to do a cleanup around what I committed, feel free, but as far 
as I'm concerned, it's resolved.

-- 
Jens Axboe


