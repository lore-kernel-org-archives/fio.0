Return-Path: <prvs=709f52920=Dmitry.Fomichev@wdc.com>
From: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: RE: [PATCH 0/2] zbd: fix zone reset during asynchronous IOs
Date: Tue, 23 Mar 2021 17:17:42 +0000
Message-ID: 
 <MN2PR04MB59510DF17D1FAAE4C9577BD5E1649@MN2PR04MB5951.namprd04.prod.outlook.com>
References: <20210323011324.1365343-1-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20210323011324.1365343-1-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

I was able to reproduce the failure by running the new test #57 against
a zoned SAS drive and I can confirm that applying the first patch in the
series fixes the problem. Looks good to me.

Reviewed-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>

> -----Original Message-----
> From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Sent: Monday, March 22, 2021 9:13 PM
> To: fio@vger.kernel.org; Jens Axboe <axboe@kernel.dk>
> Cc: Damien Le Moal <Damien.LeMoal@wdc.com>; Dmitry Fomichev
> <Dmitry.Fomichev@wdc.com>; Shinichiro Kawasaki
> <shinichiro.kawasaki@wdc.com>
> Subject: [PATCH 0/2] zbd: fix zone reset during asynchronous IOs
>=20
> Repeated random write jobs to zones with libaio engine trigger unaligned
> command
> errors because of zone resets for file reset during asynchronous writes i=
n-
> flight. The first patch of this series addresses the problem by waiting t=
he
> asynchronous IOs to complete before zone reset. The second patch adds a
> new test
> case to confirm the problem fix and to prevent future regression.
>=20
> Shin'ichiro Kawasaki (2):
>   zbd: avoid zone reset for file reset during asynchronous IOs in-flight
>   t/zbd: test repeated async write to sequential write required zones
>=20
>  t/zbd/functions        | 12 ++++++++++++
>  t/zbd/test-zbd-support | 18 ++++++++++++++++++
>  zbd.c                  |  7 +++++++
>  3 files changed, 37 insertions(+)
>=20
> --
> 2.29.2


