Return-Path: <prvs=649de9d05=shinichiro.kawasaki@wdc.com>
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH v3 06/38] zbd: remove dependency on zone type during i/o
Date: Fri, 22 Jan 2021 03:56:23 +0000
Message-ID: <20210122035622.y6annwvvev7hmidl@shindev.dhcp.fujisawa.hgst.com>
References: <20210106215739.264524-1-dmitry.fomichev@wdc.com>
 <20210106215739.264524-7-dmitry.fomichev@wdc.com>
In-Reply-To: <20210106215739.264524-7-dmitry.fomichev@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5D5CAED85613BD46A50BD3209B96920A@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Aravind Ramesh <Aravind.Ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <Naohiro.Aota@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>, Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On Jan 07, 2021 / 06:57, Dmitry Fomichev wrote:
> Two different type of zones have a write pointer: Sequential Write
> Required (SWR) and Sequential Write Preferred (SWP). Introduce the
> zone flag "has_wp" in struct zbd_zone_info and set it to 1 for these
> zone types upon initialization, thus avoiding the necessity to check
> multiple zone types in core zbd code. This flag replaces zbd_zone_swr()
> function and lays the groundwork for supporting additional write
> pointer zone types in the future.
>=20
> The overall functionality stays the same after this commit.
>=20
> Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>

Looks good to me.

Reviewed-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

--=20
Best Regards,
Shin'ichiro Kawasaki=

