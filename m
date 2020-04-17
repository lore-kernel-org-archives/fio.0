Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v2] zbd: Fix I/O direction adjustment step for random
 read/write
References: <20200416113036.28296-1-shinichiro.kawasaki@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <8acaca2e-d5dc-e091-6579-ebb5e6a55c3b@kernel.dk>
Date: Fri, 17 Apr 2020 08:32:05 -0600
MIME-Version: 1.0
In-Reply-To: <20200416113036.28296-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On 4/16/20 5:30 AM, Shin'ichiro Kawasaki wrote:
> Commit fb0259fb ("zbd: Ensure first I/O is write for random read/write to
> sequential zones") introduced a step to change direction of io_u from
> read to write when that is the first I/O of the random read/write
> workload to zoned block devices. However, such direction adjustment
> results in inconsistent I/O length when read block size and write block
> size are different.
> 
> To avoid the inconsistency between I/O direction and I/O length,
> adjust the I/O direction before the I/O length is set. Move the step
> from zbd_adjust_block() to set_rw_ddir(). To minimize changes in
> set_rw_ddir(), introduce zbd_adjust_ddir() helper function.

I'm not a huge fan of this zbd sprinkling everywhere, but that's not the
fault of your fix. But I would really prefer if zbd got disentangled
from the core/hot paths completely, maybe by adding a io engine fn for
whatever it needs to do. At least that reduces the hot path overhead to
check a pointer and calling that function instead of having various
checks here and there.

Really not great to have a somewhat esoteric feature like zbd support
add _any_ overhead to the hot path at all.

-- 
Jens Axboe


