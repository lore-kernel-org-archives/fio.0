Return-Path: <bruce@cran.org.uk>
Subject: Re: FreeBSD build broken following _Static_assert commit
References: <5591C7F0.1090004@cran.org.uk> <55920381.6060906@kernel.dk>
 <55920FE0.60901@cran.org.uk> <559210FF.6030900@kernel.dk>
From: Bruce Cran <bruce@cran.org.uk>
Message-ID: <55929806.7070002@cran.org.uk>
Date: Tue, 30 Jun 2015 07:22:14 -0600
MIME-Version: 1.0
In-Reply-To: <559210FF.6030900@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 6/29/2015 9:46 PM, Jens Axboe wrote:
> But it's bogus, it's nothing but static pointer math.

Apparently it's a known bug: https://llvm.org/bugs/show_bug.cgi?id=17410 .
It looks like on FreeBSD there's no __compiler_offsetof (which on Linux 
ends up being defined as __builtin_offsetof) but clang _does_ provide 
__builtin_offsetof.

-- 
Bruce

