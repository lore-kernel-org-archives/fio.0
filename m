Return-Path: <prvs=782a7b7b5=Niklas.Cassel@wdc.com>
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 0/4] improve zbd initialization
Date: Fri, 4 Jun 2021 12:18:51 +0000
Message-ID: <20210604121843.6047-1-Niklas.Cassel@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Niklas Cassel <niklas.cassel@wdc.com>

Hello there,

This series improves zbd initialization, by making it more robust.
Previously, zbd_create_zone_info() could return success at the same
time as f->zbd_info was never uninitialized.. Remove ZBD_IGNORE to
avoid this combination from being possible.

Also, zonemode=3Dzbd can now be used with regular files by emulating
zones inside the file. (Just like how we already support emulating
zones inside a regular block device).


Kind regards,
Niklas

Niklas Cassel (4):
  zbd: disallow pipes for zonemode=3Dzbd
  zbd: allow zonemode=3Dzbd with regular files by emulating zones
  zbd: remove zbd_zoned_model ZBD_IGNORE
  zbd: change some f->zbd_info conditionals to asserts

 engines/libzbc.c            |  3 +--
 engines/skeleton_external.c |  1 -
 oslib/linux-blkzoned.c      |  3 +--
 zbd.c                       | 37 +++++++++++++++++++++++++------------
 zbd_types.h                 |  7 +++----
 5 files changed, 30 insertions(+), 21 deletions(-)

--=20
2.31.1

