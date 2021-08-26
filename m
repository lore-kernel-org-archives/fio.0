Return-Path: <prvs=86529e675=Niklas.Cassel@wdc.com>
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 2/3] io_uring: don't clear recently set sqe->rw_flags
Date: Thu, 26 Aug 2021 16:45:05 +0000
Message-ID: <20210826164449.45833-3-Niklas.Cassel@wdc.com>
References: <20210826164449.45833-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20210826164449.45833-1-Niklas.Cassel@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Niklas Cassel <niklas.cassel@wdc.com>

Commit 7c70f506e438 ("engines/io_uring: move sqe clear out of hot path")
removed the memset of sqe from fio_ioring_prep().

This commit did add a clear of the sqe->rw_flags, however, it did so
after both RWF_UNCACHED and RWF_NOWAIT flags might have been set,
effectively clearing these flags if they got set.

This doesn't make any sense. Make sure that we clear sqe->rw_flags
before, not after, setting the flags.

Fixes: 7c70f506e438 ("engines/io_uring: move sqe clear out of hot path")
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 engines/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 269e501f..2b65572d 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -262,8 +262,9 @@ static int fio_ioring_prep(struct thread_data *td, stru=
ct io_u *io_u)
 				sqe->len =3D 1;
 			}
 		}
+		sqe->rw_flags =3D 0;
 		if (!td->o.odirect && o->uncached)
-			sqe->rw_flags =3D RWF_UNCACHED;
+			sqe->rw_flags |=3D RWF_UNCACHED;
 		if (o->nowait)
 			sqe->rw_flags |=3D RWF_NOWAIT;
 		if (ld->ioprio_class_set)
@@ -271,7 +272,6 @@ static int fio_ioring_prep(struct thread_data *td, stru=
ct io_u *io_u)
 		if (ld->ioprio_set)
 			sqe->ioprio |=3D td->o.ioprio;
 		sqe->off =3D io_u->offset;
-		sqe->rw_flags =3D 0;
 	} else if (ddir_sync(io_u->ddir)) {
 		sqe->ioprio =3D 0;
 		if (io_u->ddir =3D=3D DDIR_SYNC_FILE_RANGE) {
--=20
2.31.1

