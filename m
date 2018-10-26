Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 0/7] unittests: add CUnit based unittests
References: <1540571746-12885-1-git-send-email-kusumi.tomohiro@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <908aad84-63d1-c2fa-6472-46ffdbde612f@kernel.dk>
Date: Fri, 26 Oct 2018 10:27:45 -0600
MIME-Version: 1.0
In-Reply-To: <1540571746-12885-1-git-send-email-kusumi.tomohiro@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 10/26/18 10:35 AM, Tomohiro Kusumi wrote:
> This series of patches introduce CUnit based unittests,
> plus fix bugs found in the test cases.
> 
> CUnit is C version of *unit framework to help write test cases.
> https://sourceforge.net/projects/cunit/
> 
> Having builtin unittest functionality for newly added code
> as well as exsiting code if possible helps prevent regression.
> 
> Most of the code under lib/ and oslib/ (and os/) work as stand
> alone *.o files or inline functions with no dependencies on fio
> itself, so these are relatively easy to write unittests.
> 
> Summary of patches
> 1/7: Add basic CUnit framework
> 2/7: Add unittest suite for lib/memalign.c as an example
> 3/7: Add unittest suite for lib/strntol.c as an example
> 4/7: Add unittest suite for oslib/strlcat.c as an example
> 5/7: Add unittest suite for oslib/strndup.c as an example
> 6/7: Fix lib/strntol.c which caused test failure in patch 3/7
> 7/7: Fix oslib/strlcat.c which caused test failure in patch 4/7
> 
> Tomohiro Kusumi (7):
>   unittests: add CUnit based unittest framework
>   unittests: add unittest suite for lib/memalign.c
>   unittests: add unittest suite for lib/strntol.c
>   unittests: add unittest suite for oslib/strlcat.c
>   unittests: add unittest suite for oslib/strndup.c
>   lib: fix strntol's end pointer when str has leading spaces
>   oslib: fix strlcat's incorrect copying

This is great! I've always wanted to get unit tests going, but
just never got around to it. This looks like a good start, and
simple enough to add more tests.

Applied, thanks!

-- 
Jens Axboe


