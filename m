Return-Path: <prvs=785b62de8=Niklas.Cassel@wdc.com>
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 0/4] improve zbd initialization
Date: Mon, 7 Jun 2021 09:16:05 +0000
Message-ID: <20210607091558.21485-1-Niklas.Cassel@wdc.com>
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
time as f->zbd_info was never initialized. Remove ZBD_IGNORE to
avoid this combination from being possible.

Also, zonemode=3Dzbd can now be used with regular files by emulating
zones inside the file. (Just like how we already support emulating
zones inside a regular block device).


Kind regards,
Niklas


Changes since v1:
-Picked up Damien's Reviewed-by tags on patch 1 and 4.
-Addressed Damien's review comments on patch 2 and 3.

Niklas Cassel (4):
  zbd: disallow pipes for zonemode=3Dzbd
  zbd: allow zonemode=3Dzbd with regular files by emulating zones
  zbd: remove zbd_zoned_model ZBD_IGNORE
  zbd: change some f->zbd_info conditionals to asserts

 engines/libzbc.c            |  6 ++----
 engines/skeleton_external.c |  1 -
 oslib/linux-blkzoned.c      |  6 ++----
 zbd.c                       | 37 +++++++++++++++++++++++++------------
 zbd_types.h                 |  7 +++----
 5 files changed, 32 insertions(+), 25 deletions(-)

--=20
2.31.1

