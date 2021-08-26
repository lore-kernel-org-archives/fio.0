Return-Path: <prvs=86529e675=Niklas.Cassel@wdc.com>
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 0/3] io_uring: ensure that entries don't contain old data
Date: Thu, 26 Aug 2021 16:45:03 +0000
Message-ID: <20210826164449.45833-1-Niklas.Cassel@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Niklas Cassel <niklas.cassel@wdc.com>

Hello,

I noticed a bug when testing cmdprio_percentage with io_uring.
Turns out that this was because sqe->ioprio contained old data.

Fixed one additional field that could contain old data (sqe->flags),
as well as one field that was always cleared _after_ the flags for
this field had been set (sqe->rw_flags).

There might be additional fields that might contain old data, e.g.
sqe->sync_range_flags and sqe->fsync_flags. However, I assume that
io_uring ignores those flags for read and write commands, however,
they might still be able to interfere with non-read/write commands.


Kind regards,
Niklas

Niklas Cassel (3):
  io_uring: always initialize sqe->flags
  io_uring: don't clear recently set sqe->rw_flags
  io_uring: fix misbehaving cmdprio_percentage option

 engines/io_uring.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--=20
2.31.1

