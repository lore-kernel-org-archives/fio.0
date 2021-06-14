Return-Path: <prvs=79210697c=Niklas.Cassel@wdc.com>
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v3 0/5] improve zbd initialization
Date: Mon, 14 Jun 2021 13:49:02 +0000
Message-ID: <20210614134851.158700-1-Niklas.Cassel@wdc.com>
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


Changes since v2:
-Picked up Damien's Reviewed-by tags on patch 2 and 3.
-Added patch 5/5 that fixes a test failure related to this series.

Niklas Cassel (5):
  zbd: disallow pipes for zonemode=3Dzbd
  zbd: allow zonemode=3Dzbd with regular files by emulating zones
  zbd: remove zbd_zoned_model ZBD_IGNORE
  zbd: change some f->zbd_info conditionals to asserts
  t/zbd: update test case 42

 engines/libzbc.c            |  6 ++----
 engines/skeleton_external.c |  1 -
 oslib/linux-blkzoned.c      |  6 ++----
 t/zbd/test-zbd-support      |  2 +-
 zbd.c                       | 37 +++++++++++++++++++++++++------------
 zbd_types.h                 |  7 +++----
 6 files changed, 33 insertions(+), 26 deletions(-)

--=20
2.25.1

