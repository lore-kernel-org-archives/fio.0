Return-Path: <axboe@kernel.dk>
Subject: Re: [three fio patches 3/3] smalloc: allocate pool-> members from
 shared memory
References: <20190828174842.25423-1-vincentfu@gmail.com>
 <20190828174842.25423-4-vincentfu@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <bb5acdc6-d2f6-99e6-2e9e-01fef4650b74@kernel.dk>
Date: Wed, 28 Aug 2019 13:12:56 -0600
MIME-Version: 1.0
In-Reply-To: <20190828174842.25423-4-vincentfu@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: vincentfu@gmail.com, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

On 8/28/19 11:48 AM, vincentfu@gmail.com wrote:
> From: Vincent Fu <vincent.fu@wdc.com>
> 
> If one process is making smalloc calls and another process is making
> sfree calls, pool->free_blocks and pool->next_non_full will not be
> synchronized because the two processes each have independent, local
> copies of the variables.
> 
> This patch allocates space for the two variables from shared storage so
> that separate processes will be modifying quantities stored at the same
> locations.
> 
> This issue was discovered on the server side running a client/server job
> with --status-interval=1. Such a job encountered an OOM error when only
> ~50 objects were allocated from the smalloc pool.
> 
> Also change the calculation of free_blocks in add_pool() to use
> SMALLOC_BPI instead of SMALLOC_BPB. These two constants are
> coincidentally the same on Linux and Windows but SMALLOC_BPI is the
> correct one to use. free_blocks is the number of available blocks of
> size SMALLOC_BPB. It is the product of the number of unsigned integers
> in the bitmap (bitmap_blocks) and the number of bits per unsigned
> integer (SMALLOC_BPI).

Would it make more sense to just have the pool[] come out of shared
memory?

-- 
Jens Axboe


