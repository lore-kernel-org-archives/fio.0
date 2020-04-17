Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
Date: Fri, 17 Apr 2020 20:30:50 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH v2] zbd: Fix I/O direction adjustment step for random
 read/write
Message-ID: <20200417173050.GA26921@avx2>
References: <20200416113036.28296-1-shinichiro.kawasaki@wdc.com>
 <8acaca2e-d5dc-e091-6579-ebb5e6a55c3b@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8acaca2e-d5dc-e091-6579-ebb5e6a55c3b@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org, Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On Fri, Apr 17, 2020 at 08:32:05AM -0600, Jens Axboe wrote:
> I'm not a huge fan of this zbd sprinkling everywhere, but that's not the
> fault of your fix. But I would really prefer if zbd got disentangled
> from the core/hot paths completely, maybe by adding a io engine fn for
> whatever it needs to do.

I think it should be done at generator level. zonemode=strided/zbd is
really a specialized random generator. Such generator would issue first
write in ZBD mode and read/write in normal mode.

zbd_adjust_block() is strange. For example "norandommap" in ZBD mode
doesn't guarantee full LBA space coverage even with 1 thread but it
would guarantee it with 1 thread and generator which shuffles zone
numbers once and issues writes with any QD.

But the combinatorial explosion given the number of options scaries me.
And then things will become even more entertaining once QD > 1 zone appends
start to show up!

