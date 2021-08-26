Return-Path: <prvs=86529e675=Niklas.Cassel@wdc.com>
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 3/3] io_uring: fix misbehaving cmdprio_percentage option
Date: Thu, 26 Aug 2021 16:45:05 +0000
Message-ID: <20210826164449.45833-4-Niklas.Cassel@wdc.com>
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

Before this commit, fio_ioring_prio_prep() behaved properly, because
sqe->ioprio was always cleared by the memset in fio_ioring_prep().

cmdprio_percentage=3D20 is supposed to set the highest priority class for
20% of the total I/Os, however, because sqes got reused without clearing
the ioprio field, this meant that the number of I/Os sent with the highest
priority became 95% already after 10 seconds. Quite far off from the
intended 20%.

Fix this by explicitly clearing the priority in fio_ioring_prio_prep().
Note that prio/prioclass cannot be used together with cmdprio_percentage,
so we do not need to do an additional clear in fio_ioring_prep().

engines/libaio.c doesn't explicitly clear the ioprio, nor does it memset
the descriptor entry, this is because io_prep_pread()/io_prep_pwrite() in
libaio itself performs a memset.

Fixes: 7c70f506e438 ("engines/io_uring: move sqe clear out of hot path")
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 engines/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 2b65572d..b8d4cf91 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -384,6 +384,8 @@ static void fio_ioring_prio_prep(struct thread_data *td=
, struct io_u *io_u)
 	if (rand_between(&td->prio_state, 0, 99) < o->cmdprio_percentage) {
 		ld->sqes[io_u->index].ioprio =3D IOPRIO_CLASS_RT << IOPRIO_CLASS_SHIFT;
 		io_u->flags |=3D IO_U_F_PRIORITY;
+	} else {
+		ld->sqes[io_u->index].ioprio =3D 0;
 	}
 	return;
 }
--=20
2.31.1

