Return-Path: <prvs=802d7391b=Niklas.Cassel@wdc.com>
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 0/3] fix max open zones handling when using multiple jobs
Date: Thu, 24 Jun 2021 17:23:06 +0000
Message-ID: <20210624172256.37177-1-Niklas.Cassel@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, "adobriyan@gmail.com" <adobriyan@gmail.com>, Niklas Cassel <Niklas.Cassel@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Niklas Cassel <niklas.cassel@wdc.com>

Currently, the fio handling of max open zones is very fragile.

zbd_open_zone() uses zbd_info->max_open_zones when checking
the max open zones limit, while zbd_convert_to_open_zone()
uses td->o.max_open_zones when performing the same limit check.

It is simply wrong to use td->o.max_open_zones after zbd_setup_files().

Change zbd_convert_to_open_zone() to use zbd_info->max_open_zones.
This way, the global max open zones limit (which is per device) will be
respected for all jobs.

This series also adds a patch that reintroduces the ability to
run write workloads with no limit on the maximum number of open zones.
In this case, tracking of open zones in the zbd_info->open_zones array
is disabled to reduce overhead.


Niklas Cassel (3):
  zbd: create a local zbdi variable for f->zbd_info
  zbd: allow an unlimited global max open zones limit
  zbd: ensure that global max open zones limit is respected

 zbd.c | 111 +++++++++++++++++++++++++++++++++++++---------------------
 zbd.h |   3 +-
 2 files changed, 73 insertions(+), 41 deletions(-)

--=20
2.25.1

