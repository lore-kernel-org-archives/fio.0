Return-Path: <prvs=497764fc3=Dmitry.Fomichev@wdc.com>
From: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: RE: [PATCH v2 0/7] Improve open zones accounting
Date: Sun, 23 Aug 2020 00:18:00 +0000
Message-ID: 
 <MN2PR04MB595122EAFC901FF9A297838BE1590@MN2PR04MB5951.namprd04.prod.outlook.com>
References: <20200821063739.390353-1-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20200821063739.390353-1-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

The small comment change suggestion in patch #3 could be addressed
if there is v3, but the patchset works for me in it's current form.=20
Therefore, for the series,
Reviewed-by: Dmitry Fomichev: <dmitry.fomichev@wdc.com>

> -----Original Message-----
> From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Sent: Friday, August 21, 2020 2:38 AM
> To: fio@vger.kernel.org; Jens Axboe <axboe@kernel.dk>
> Cc: Damien Le Moal <Damien.LeMoal@wdc.com>; Dmitry Fomichev
> <Dmitry.Fomichev@wdc.com>; Shinichiro Kawasaki
> <shinichiro.kawasaki@wdc.com>
> Subject: [PATCH v2 0/7] Improve open zones accounting
>=20
> The max_open_zones and job_max_open_zones option control number of
> write target
> open zones within the specified limit. Currently, this write target zone
> accounting is not accurate enough. Even with these options set, the limit=
s can
> exceed during write workloads.
>=20
> This patch series improves accuracy of the open zones accounting. The fir=
st
> patch moves the moment to decrement number of currently open zones
> from write
> command submit to write command completion. This avoids zone writes
> beyond the
> limit caused by concurrent write commands at queue depths approaching
> the max
> limits. The second and third patches fix the open zone status initializat=
ion
> issue. Other following patches improve t/zbd scripts to take maximum writ=
e
> target zone limit and allow to test devices with the limit.
>=20
> Changes from v1:
> * Improved open zones list initialization to reset zones beyond max open
> zones
> * Added the 2nd patch which is required for the open zones list initializ=
ation
> * Reflected various comments on the list
>=20
> Shin'ichiro Kawasaki (7):
>   zbd: Decrement open zones count at write command completion
>   oslib/linux-blkzoned: Allow reset zone before file set up
>   zbd: Initialize open zones list referring zone status at fio start
>   t/zbd: Improve usage message of test-zbd-support script
>   t/zbd: Add -o option to t/zbd/test-zoned-support
>   t/zbd: Reset all zones before test when max open zones is specified
>   t/zbd: Remove unnecessary option for zbc_reset_zone
>=20
>  io_u.c                 |   4 +-
>  io_u.h                 |   5 +-
>  ioengines.c            |   4 +-
>  oslib/linux-blkzoned.c |  18 +++++-
>  t/zbd/functions        |   2 +-
>  t/zbd/test-zbd-support | 122 +++++++++++++++++++++++++++++++++----
> --
>  zbd.c                  | 127 +++++++++++++++++++++++++++++++++--------
>  zbd.h                  |   9 +--
>  8 files changed, 236 insertions(+), 55 deletions(-)
>=20
> --
> 2.26.2


