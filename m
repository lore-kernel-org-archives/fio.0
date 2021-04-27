Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] ioengines: don't call zbd_put_io_u() for engines not
 implementing commit
References: <20210427174052.206372-1-Niklas.Cassel@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <a49572c9-1286-66b7-741d-418386552091@kernel.dk>
Date: Tue, 27 Apr 2021 11:57:09 -0600
MIME-Version: 1.0
In-Reply-To: <20210427174052.206372-1-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Niklas Cassel <Niklas.Cassel@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On 4/27/21 11:41 AM, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> Commit d9ed3e63e528 ("zbd: Fix zone locking for async I/O engines") added
> a call to zbd_put_io_u() in the case where td->io_ops->commit callback
> is not implemented on an ioengine.
> 
> The commit in question fails to mention why this zbd_put_io_u() call was
> added for ioengines not implementing the commit callback.
> 
> The code in td_io_queue() looks like this:
> 
> ret = td->io_ops->queue(td, io_u);
> zbd_queue_io_u(td, io_u, ret);
> 
> if (!td->io_ops->commit) {
> 	io_u_mark_submit(td, 1);
> 	io_u_mark_complete(td, 1);
> 	zbd_put_io_u(td, io_u);
> }
> 
> SYNC I/O engine case (e.g. psync):
> The zone will be locked by zbd_adjust_block(), td->io_ops->queue(td, io_u),
> which for a sync I/O engine will return FIO_Q_COMPLETED.
> 
> This return value will be send in to zbd_queue_io_u(), which at the end
> of the function, unlocks the zone if the return value from ->queue()
> differs from FIO_Q_QUEUED. For a sync I/O engine, the zone will be
> unlocked here, and io_u->zbd_put_io function pointer will be set to NULL.
> 
> psync does not implement the ->commit() callback, so it will call
> zbd_put_io_u(), which will do nothing, because the io_u->zbd_put_io
> pointer is NULL.
> 
> ASYNC I/O engine case (e.g. io_uring):
> The zone will be locked by zbd_adjust_block(), td->io_ops->queue(td, io_u),
> which for an async I/O engine will return FIO_Q_QUEUED.
> 
> This return value will be send in to zbd_queue_io_u(), which at the end
> of the function, unlocks the zone if the return value from ->queue()
> differs from FIO_Q_QUEUED. For an async I/O engine, the zone will not be
> unlocked here, so the io_u->zbd_put_io function pointer will still be set.
> 
> io_uring does implement the ->commit() callback, so it will not call
> zbd_put_io_u() here at all.
> 
> Instead zbd_put_io_u() will be called by do_io() -> wait_for_completions()
> -> io_u_queued_complete() -> ios_completed() -> put_io_u() -> zbd_put_io_u(),
> which will unlock the zone and will set the io_u->zbd_put_io function pointer
> to NULL.
> 
> In conclusion, the zbd_put_io_u() should never had been added in the case
> where the ->commit() callback wasn't implemented in the first place,
> and removing it shouldn't affect ioengines psync or io_uring.
> 
> Commit d9ed3e63e528 ("zbd: Fix zone locking for async I/O engines")
> probably made the assumption that an async I/O engine == the ->commit()
> callback is implemented, however, this is not true, there are async
> I/O engines in tree (and out of tree), that does not implement the
> ->commit() callback. Instead, an async I/O engine is recognized by
> the ->queue() callback returning FIO_Q_QUEUED.
> 
> Removing the invalid zbd_put_io_u() call will ensure that a zone is not
> prematurely unlocked for async I/O engines that do not implement the
> ->commit() callback. Unlocking a zone prematurely leads to I/O errors.

Applied, thanks.

-- 
Jens Axboe


