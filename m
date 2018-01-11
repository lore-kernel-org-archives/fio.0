Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v2] ioengines: don't call munmap unless size boundary is
 exceeded
References: <20180110005517.14708-1-elliott@hpe.com>
 <20180110155001.16037-1-elliott@hpe.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <5a1c714d-8ec6-bf1f-6dc7-24046086896d@kernel.dk>
Date: Thu, 11 Jan 2018 12:14:42 -0700
MIME-Version: 1.0
In-Reply-To: <20180110155001.16037-1-elliott@hpe.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Robert Elliott <elliott@hpe.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 1/10/18 8:50 AM, Robert Elliott wrote:
> From: Robert Elliott <elliott@hpe.com>
> 
> In ioengines using mmap() and munmap(), don't call munmap() when doing an
> IO that accesses the last byte of a file. This affects the dev-dax,
> libpmem, and mmap ioengines.
> 
> Example:
> io       12987 DEBUG fio_libpmem_prep
> io       12987  io_u->offset 7516061696 : fdd->libpmem_off 0 : io_u->buflen 131072 : fdd->libpmem_sz 7516192768
> io       12987 munmap addr=0x7f5600000000 size=0x1c0000000
> 
> That accesses the last 128 KiB of a 7 GiB file, triggering an munmap
> because the comparison to 7 GiB fails:
> 	7516061696 + 131072 < 7516192768
> 
> Change < to <= so that doesn't occur unless an overflow really
> happens.
> 
> In one test in linux, this increases performance from 5 GB/s to 20 GB/s
> as fio stops spending time in mmap() page table mapping spinlocks and
> instead spends its time in memmove().  The perf top results improve from:
>   36.81%  [kernel]             [k] queued_spin_lock_slowpath
>   24.26%  libc-2.26.so         [.] __memmove_avx_unaligned_erms
>    4.09%  [kernel]             [k] __radix_tree_lookup
>    3.85%  [kernel]             [k] find_next_iomem_res
>    3.70%  [kernel]             [k] _raw_spin_lock_irq
>    3.48%  [kernel]             [k] down_read
> 
> to:
>   79.76%  libc-2.26.so         [.] __memmove_avx_unaligned_erms
>    3.23%  libc-2.26.so         [.] vfprintf

Good catch, thanks Rob! Applied.

-- 
Jens Axboe


