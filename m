Return-Path: <axboe@kernel.dk>
Subject: Re: Optimizing mmap_queue on AVX/AVX2 CPUs
References: <a4e3f9d8-3e1b-5a50-63fe-a704e9bb0fdf@bluestop.org>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <c4080594-ec00-8cd7-2eb6-ba843c3219c9@kernel.dk>
Date: Tue, 29 Aug 2017 09:33:07 -0600
MIME-Version: 1.0
In-Reply-To: <a4e3f9d8-3e1b-5a50-63fe-a704e9bb0fdf@bluestop.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Rebecca Cran <rebecca@bluestop.org>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 08/25/2017 07:46 PM, Rebecca Cran wrote:
> I'm not sure how far we want to get into optimizing fio for specific CPUs?
> 
> I've done some testing and found that when running the mmap ioengine 
> against an NVDIMM-N on a modern Intel CPU I can gain a few hundred MB/s 
> by optimizing the memory copy using avx/avx2 versus the system's memcpy 
> implementation.
> 
> 
> Should I proceed with submitting a patch, or do we want to avoid getting 
> into these sort of optimizations?

If we can do it cleanly, that's fine. See for instance how we detect
presence of crc32c hw assist at init time.

For memcpy(), the libc functions should really be doing this, however.

That said, let's see a patch, it's easier to discuss concrete patches
than just ideas.

-- 
Jens Axboe


