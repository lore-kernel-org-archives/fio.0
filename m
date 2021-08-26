Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 0/3] io_uring: ensure that entries don't contain old data
References: <20210826164449.45833-1-Niklas.Cassel@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <c4829f8e-ab54-3fed-771a-711078b9dd4a@kernel.dk>
Date: Thu, 26 Aug 2021 10:50:48 -0600
MIME-Version: 1.0
In-Reply-To: <20210826164449.45833-1-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Niklas Cassel <Niklas.Cassel@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On 8/26/21 10:45 AM, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> Hello,
> 
> I noticed a bug when testing cmdprio_percentage with io_uring.
> Turns out that this was because sqe->ioprio contained old data.
> 
> Fixed one additional field that could contain old data (sqe->flags),
> as well as one field that was always cleared _after_ the flags for
> this field had been set (sqe->rw_flags).
> 
> There might be additional fields that might contain old data, e.g.
> sqe->sync_range_flags and sqe->fsync_flags. However, I assume that
> io_uring ignores those flags for read and write commands, however,
> they might still be able to interfere with non-read/write commands.

Thanks, looks good, applied.

-- 
Jens Axboe


