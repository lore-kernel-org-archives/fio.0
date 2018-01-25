Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 2/3] memcpytest: add more memcpy tests
References: <20180118235347.30370-1-elliott@hpe.com>
 <20180118235347.30370-3-elliott@hpe.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <0d3c29f6-fae6-c43d-71bf-160e62d8c4ce@kernel.dk>
Date: Thu, 25 Jan 2018 14:22:29 -0700
MIME-Version: 1.0
In-Reply-To: <20180118235347.30370-3-elliott@hpe.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Robert Elliott <elliott@hpe.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 1/18/18 4:53 PM, Robert Elliott wrote:
> From: Robert Elliott <elliott@hpe.com>
> 
> Add more memcpy tests:
>     memcpy = copy with libc memcpy() (d = s)(one read, one write)
>     memcsum = read memory to registers (one read)
>     memset = write memory from registers with libc memset() (one write)
>     wmemset = write memory from registers with libc wmemset() (one write)
>     streamcopy = STREAM copy (d = s)(one read, one write)
>     streamadd = STREAM add (d = s1 + s2)(two reads, add, one write)
>     streamscale = STREAM scale (d = 3 * s1)(one read, multiply, one write)
>     streamtriad = STREAM triad (d = s1 + 3 * s2)(two reads, add and multiply, one write)

The engine changes in here don't seem related?

> +static void flush_caches(struct memcpy_type *t, struct memcpy_test *test)
> +{
> +	__builtin___clear_cache(test->src, test->src + BUF_SIZE);
> +	__builtin___clear_cache(test->src2, test->src2 + BUF_SIZE);
> +	__builtin___clear_cache(test->dst, test->dst + BUF_SIZE);
> +}

Is this going to work on all platforms? I'm fine with adding it, but
we'll probably need a configure test to ensure we don't break various
builds.

-- 
Jens Axboe


