Return-Path: <prvs=649de9d05=shinichiro.kawasaki@wdc.com>
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH v3 05/38] zbd: engines/libzbc: don't fail on assert for
 offline zones
Date: Fri, 22 Jan 2021 02:27:21 +0000
Message-ID: <20210122022721.4obweb5whfcmhj2c@shindev.dhcp.fujisawa.hgst.com>
References: <20210106215739.264524-1-dmitry.fomichev@wdc.com>
 <20210106215739.264524-6-dmitry.fomichev@wdc.com>
In-Reply-To: <20210106215739.264524-6-dmitry.fomichev@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <347849649B0DEB4885E7FDD215232019@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Aravind Ramesh <Aravind.Ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <Naohiro.Aota@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>, Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On Jan 07, 2021 / 06:57, Dmitry Fomichev wrote:
> If fio is run against a zoned device that has any zones in OFFLINE
> condition, the following assertion is raised -
>=20
> fio: zbd.c:473: parse_zone_info: Assertion `z->wp <=3D z->start + zone_si=
ze' failed.
>=20
> This happens because offline zones have no valid write pointer and
> it is reported by libzbc and blkzoned as (uint64_t)(-1). To avoid
> violating this assertion, set the write pointer in all offline zones
> to point at the start of the zone.
>=20
> Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>

Looks good to me.

Reviewed-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

--=20
Best Regards,
Shin'ichiro Kawasaki=

