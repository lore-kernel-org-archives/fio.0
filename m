Return-Path: <prvs=485daf1e4=Dmitry.Fomichev@wdc.com>
From: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: RE: [PATCH v3 0/4] miscellaneous ZBD improvements
Date: Tue, 11 Aug 2020 15:58:54 +0000
Message-ID: 
 <MN2PR04MB5951E73D48E903B0F368A6ECE1450@MN2PR04MB5951.namprd04.prod.outlook.com>
References: <20200804013828.1569-1-dmitry.fomichev@wdc.com>
In-Reply-To: <20200804013828.1569-1-dmitry.fomichev@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, Sitsofe Wheeler <sitsofe@gmail.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

Jens,

A gentle ping... Please consider this patchset for merging.

Very best,
Dmitry

> -----Original Message-----
> From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
> Sent: Monday, August 3, 2020 9:38 PM
> To: Jens Axboe <axboe@kernel.dk>
> Cc: fio@vger.kernel.org; Damien Le Moal <Damien.LeMoal@wdc.com>;
> Sitsofe Wheeler <sitsofe@gmail.com>; Shinichiro Kawasaki
> <shinichiro.kawasaki@wdc.com>; Dmitry Fomichev
> <Dmitry.Fomichev@wdc.com>
> Subject: [PATCH v3 0/4] miscellaneous ZBD improvements
>=20
> This series contains four patches related to zoned block devices.
>=20
> v2 -> v3:
>   - initialized libzbc ioengine feature flag in configure
>   - improved error output in check_min_lib_version()
>=20
> v1 -> v2:
>   - removed recursive zone locking in zbd_reset_zone()
>   - added --disable-libzbc configure option
>   - moved pkg-config version check to a separate function
>   - added a patch to verify that pkg-config is available to check
>     the minimum supported version in all libraries that need that
>=20
> Dmitry Fomichev (4):
>   configure: improve libzbc version check
>   configure: check if pkg-config is installed
>   zbd: simplify zone reset code
>   t/zbd: check log file for failed assertions
>=20
>  configure              | 62 +++++++++++++++++++---------------
>  t/zbd/test-zbd-support |  9 ++++-
>  zbd.c                  | 76 +++++++++++++++---------------------------
>  3 files changed, 70 insertions(+), 77 deletions(-)
>=20
> --
> 2.21.0


