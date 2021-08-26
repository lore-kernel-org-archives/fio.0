Return-Path: <prvs=86529e675=Niklas.Cassel@wdc.com>
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 1/3] io_uring: always initialize sqe->flags
Date: Thu, 26 Aug 2021 16:45:04 +0000
Message-ID: <20210826164449.45833-2-Niklas.Cassel@wdc.com>
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

Later, force_async was added in commit 5a59a81d2923 ("engines/io_uring:
allow setting of IOSQE_ASYNC").

The force_async commit sets sqe->flags every N requests, however,
since we no longer do a memset, this commit should have made sure that
flags is always initialized, such that we don't have sqe->flags set on
reused sqes where we didn't intend to.

Fixes: 5a59a81d2923 ("engines/io_uring: allow setting of IOSQE_ASYNC")
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 engines/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 9c091e37..269e501f 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -234,6 +234,7 @@ static int fio_ioring_prep(struct thread_data *td, stru=
ct io_u *io_u)
 		sqe->flags =3D IOSQE_FIXED_FILE;
 	} else {
 		sqe->fd =3D f->fd;
+		sqe->flags =3D 0;
 	}
=20
 	if (io_u->ddir =3D=3D DDIR_READ || io_u->ddir =3D=3D DDIR_WRITE) {
--=20
2.31.1

