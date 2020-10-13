Return-Path: <prvs=5487bf209=Dmitry.Fomichev@wdc.com>
From: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: RE: [PATCH 0/2] zbd: Fix test case #48 failure
Date: Tue, 13 Oct 2020 16:18:02 +0000
Message-ID: 
 <MN2PR04MB59515B6F0888C7557089C062E1040@MN2PR04MB5951.namprd04.prod.outlook.com>
References: <20201013064926.901831-1-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20201013064926.901831-1-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Naohiro Aota <Naohiro.Aota@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

These patches look good to me. For the series -

Reviewed-by: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Tested-by: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>

Best regards,
Dmitry

> -----Original Message-----
> From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Sent: Tuesday, October 13, 2020 2:49 AM
> To: fio@vger.kernel.org; Jens Axboe <axboe@kernel.dk>
> Cc: Damien Le Moal <Damien.LeMoal@wdc.com>; Dmitry Fomichev
> <Dmitry.Fomichev@wdc.com>; Naohiro Aota <Naohiro.Aota@wdc.com>;
> Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Subject: [PATCH 0/2] zbd: Fix test case #48 failure
>=20
> When t/zbd/test-zoned-support is run for zoned block devices with slow
> zone
> reset command operation, test case #48 fails. This series addresses the
> failure
> with two fixes. First patch avoids excessive and repeated zone resets whi=
ch
> resulted in too long runtime and test timeout. Second patch fixes wrong t=
est
> target range of the test case which triggered unnecessary zone resets.
>=20
> Shin'ichiro Kawasaki (2):
>   zbd: Avoid excessive zone resets
>   t/zbd: Fix test target size of test case #48
>=20
>  t/zbd/test-zbd-support | 2 +-
>  zbd.c                  | 3 +++
>  2 files changed, 4 insertions(+), 1 deletion(-)
>=20
> --
> 2.26.2


