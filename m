Return-Path: <axboe@kernel.dk>
Subject: Re: memcpy test: results from adding sse and avx tests
References: <04b051c0-85a6-d6c5-e20e-c9a765a8e22d@bluestop.org>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <a1e84eb8-5b0c-efa2-6234-555150a740cf@kernel.dk>
Date: Thu, 18 Jan 2018 10:47:08 -0700
MIME-Version: 1.0
In-Reply-To: <04b051c0-85a6-d6c5-e20e-c9a765a8e22d@bluestop.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Rebecca Cran <rebecca@bluestop.org>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 1/18/18 10:38 AM, Rebecca Cran wrote:
> I added code to lib/memcpy.c to test sse and avx performance, and found 
> that on modern systems memcpy outperforms both by quite some margin 
> (GB/s) on the larger block sizes: the only place sse/avx is an 
> improvement was on an older SandyBridge EP system - I've copied the 
> output below.
> 
> Should I work on a patch to commit the changes, or just abandon them 
> since it seems the current memcpy implementation used in the mmap engine 
> is the best solution on modern machines?

The upside would be having an implementation that is independent of
the OS, the downside is the (significant) extra maintenance burden
and the differing results on different machines.

The synthetic test case is a bit misleading, I think. avx/sse might
yield great results for small sizes, but in actual workloads, having
to save/restore state across context switches will add overhead. The
simple throughput test case doesn't include that.

Adding the memcpy for avx/sse to the test case might be interesting
though, just to be able to compare performances with builtin
memcpy/memmove on a given system.

-- 
Jens Axboe


