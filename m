Return-Path: <prvs=744a56f51=Niklas.Cassel@wdc.com>
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH] ioengines: don't call zbd_put_io_u() for engines not
 implementing commit
Date: Tue, 27 Apr 2021 17:41:14 +0000
Message-ID: <20210427174052.206372-1-Niklas.Cassel@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Niklas Cassel <niklas.cassel@wdc.com>

Commit d9ed3e63e528 ("zbd: Fix zone locking for async I/O engines") added
a call to zbd_put_io_u() in the case where td->io_ops->commit callback
is not implemented on an ioengine.

The commit in question fails to mention why this zbd_put_io_u() call was
added for ioengines not implementing the commit callback.

The code in td_io_queue() looks like this:

ret =3D td->io_ops->queue(td, io_u);
zbd_queue_io_u(td, io_u, ret);

if (!td->io_ops->commit) {
	io_u_mark_submit(td, 1);
	io_u_mark_complete(td, 1);
	zbd_put_io_u(td, io_u);
}

SYNC I/O engine case (e.g. psync):
The zone will be locked by zbd_adjust_block(), td->io_ops->queue(td, io_u),
which for a sync I/O engine will return FIO_Q_COMPLETED.

This return value will be send in to zbd_queue_io_u(), which at the end
of the function, unlocks the zone if the return value from ->queue()
differs from FIO_Q_QUEUED. For a sync I/O engine, the zone will be
unlocked here, and io_u->zbd_put_io function pointer will be set to NULL.

psync does not implement the ->commit() callback, so it will call
zbd_put_io_u(), which will do nothing, because the io_u->zbd_put_io
pointer is NULL.

ASYNC I/O engine case (e.g. io_uring):
The zone will be locked by zbd_adjust_block(), td->io_ops->queue(td, io_u),
which for an async I/O engine will return FIO_Q_QUEUED.

This return value will be send in to zbd_queue_io_u(), which at the end
of the function, unlocks the zone if the return value from ->queue()
differs from FIO_Q_QUEUED. For an async I/O engine, the zone will not be
unlocked here, so the io_u->zbd_put_io function pointer will still be set.

io_uring does implement the ->commit() callback, so it will not call
zbd_put_io_u() here at all.

Instead zbd_put_io_u() will be called by do_io() -> wait_for_completions()
-> io_u_queued_complete() -> ios_completed() -> put_io_u() -> zbd_put_io_u(=
),
which will unlock the zone and will set the io_u->zbd_put_io function point=
er
to NULL.

In conclusion, the zbd_put_io_u() should never had been added in the case
where the ->commit() callback wasn't implemented in the first place,
and removing it shouldn't affect ioengines psync or io_uring.

Commit d9ed3e63e528 ("zbd: Fix zone locking for async I/O engines")
probably made the assumption that an async I/O engine =3D=3D the ->commit()
callback is implemented, however, this is not true, there are async
I/O engines in tree (and out of tree), that does not implement the
->commit() callback. Instead, an async I/O engine is recognized by
the ->queue() callback returning FIO_Q_QUEUED.

Removing the invalid zbd_put_io_u() call will ensure that a zone is not
prematurely unlocked for async I/O engines that do not implement the
->commit() callback. Unlocking a zone prematurely leads to I/O errors.

Fixes: d9ed3e63e528 ("zbd: Fix zone locking for async I/O engines")
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 ioengines.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/ioengines.c b/ioengines.c
index f88b0537..3561bb4e 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -414,7 +414,6 @@ enum fio_q_status td_io_queue(struct thread_data *td, s=
truct io_u *io_u)
 	if (!td->io_ops->commit) {
 		io_u_mark_submit(td, 1);
 		io_u_mark_complete(td, 1);
-		zbd_put_io_u(td, io_u);
 	}
=20
 	if (ret =3D=3D FIO_Q_COMPLETED) {
--=20
2.30.2

