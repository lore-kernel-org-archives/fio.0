Return-Path: <prvs=7598eea54=Niklas.Cassel@wdc.com>
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 0/4] Improve fio max open zones handling
Date: Wed, 12 May 2021 22:36:32 +0000
Message-ID: <20210512223615.17239-1-Niklas.Cassel@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Niklas Cassel <niklas.cassel@wdc.com>

Improve max open zones handling by introducing a new IO engine operation,
which can be implemented by ioengines.

Also provide a default implementation for Linux, which parses sysfs for
the max open zones value.

Update libzbc ioengine to utilize the new callback.

Having this callback has the two following advantages:

1) If the user forgets to specify a --max_open_zones value, we will
automatically use the maximum the drive supports.
(Instead of getting errors because fio tries to open too many zones.)

2) If the user specifies a --max_open_zones value that is too big,
we will return an error and fio will exit with a proper error message.
(Instead of getting errors because fio tries to open too many zones.)


Kind regards,
Niklas

Niklas Cassel (4):
  zbd: only put an upper limit on max open zones once
  oslib/linux-blkzoned: move sysfs reading into its own function
  ioengines: add get_max_open_zones zoned block device operation
  engines/libzbc: add support for the get_max_open_zones io op

 engines/libzbc.c            | 21 +++++++++
 engines/skeleton_external.c | 13 ++++++
 ioengines.h                 |  4 +-
 oslib/blkzoned.h            |  7 +++
 oslib/linux-blkzoned.c      | 82 ++++++++++++++++++++++++----------
 zbd.c                       | 88 ++++++++++++++++++++++++++++++++++---
 6 files changed, 186 insertions(+), 29 deletions(-)

--=20
2.25.1

