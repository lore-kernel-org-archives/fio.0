Return-Path: <axboe@kernel.dk>
Subject: Re: memcpy test: results from adding sse and avx tests
References: <04b051c0-85a6-d6c5-e20e-c9a765a8e22d@bluestop.org>
 <a1e84eb8-5b0c-efa2-6234-555150a740cf@kernel.dk>
 <68527aaf-203d-8a43-560c-f9135f348b18@bluestop.org>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <32928ce1-5980-31b5-0566-65e90796d164@kernel.dk>
Date: Mon, 5 Mar 2018 22:22:44 -0700
MIME-Version: 1.0
In-Reply-To: <68527aaf-203d-8a43-560c-f9135f348b18@bluestop.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Rebecca Cran <rebecca@bluestop.org>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 1/18/18 1:36 PM, Rebecca Cran wrote:
> On 01/18/2018 10:47 AM, Jens Axboe wrote:
>>
>> Adding the memcpy for avx/sse to the test case might be interesting
>> though, just to be able to compare performances with builtin
>> memcpy/memmove on a given system.
> 
> I've attached the patch. I think it should work on all Intel systems 
> newer than 2012. It causes a segfault on my Atom E3826 (Baytrail) 
> because it doesn't support AVX.
> 
> I've tested it using Clang 3.8, GCC 4.8 and 7.x on openSUSE, and Clang 
> 4.0 on FreeBSD 11.1.

I'm worried that this will break some platforms. A few comments that
might help rectify that:

1) Use fio_memalign() instead of relying on a c11 function
2) Add a configure check for the avx and sse, separately.
   This includes -msse for the compiler, includes for the
    xmm/imm intrinsics, etc.

I don't care if it segfaults if avx/sse isn't there, but I don't
want to risk failing a build on some rarely tested platform, just
to have this as part of the memcpy test. The risk/reward just
isn't there then.

-- 
Jens Axboe


