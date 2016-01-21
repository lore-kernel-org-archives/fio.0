Return-Path: <bruce@cran.org.uk>
Subject: Re: fio newer than 2.2.12 segfaults on examples/tiobench-example.fio
References: <569B9F48.3010808@cran.org.uk> <569D5FB4.6050602@kernel.dk>
 <56A05EDC.4030309@cran.org.uk>
From: Bruce Cran <bruce@cran.org.uk>
Message-ID: <56A060BA.2060300@cran.org.uk>
Date: Wed, 20 Jan 2016 21:38:18 -0700
MIME-Version: 1.0
In-Reply-To: <56A05EDC.4030309@cran.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 01/20/2016 09:30 PM, Bruce Cran wrote:
> I'm wondering if this is a microcode bug, since I have one of the new 
> Skylake CPUs (Intel(R) Core(TM) i7-6700K CPU @ 4.00GHz; stepping: 3; 
> microcode: 0x6a) and others have mentioned crashes in 
> __lll_unlock_elision related to broken CPUs/BIOSes, though for older 
> generations.

For anyone who wants to see what the problems around elision lock is all 
about, see https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=800574 
(libc6: lock elision hazard on Intel Broadwell and Skylake).

-- 
Bruce

