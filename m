Return-Path: <prvs=649de9d05=shinichiro.kawasaki@wdc.com>
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH v3 21/38] zbd: avoid failing assertion in
 zbd_convert_to_open_zone()
Date: Fri, 22 Jan 2021 05:05:24 +0000
Message-ID: <20210122050524.tdbbs3glncwmued7@shindev.dhcp.fujisawa.hgst.com>
References: <20210106215739.264524-1-dmitry.fomichev@wdc.com>
 <20210106215739.264524-22-dmitry.fomichev@wdc.com>
In-Reply-To: <20210106215739.264524-22-dmitry.fomichev@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DD80098A1A4EF04BA6965F84CA8CC99D@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Aravind Ramesh <Aravind.Ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <Naohiro.Aota@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>, Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On Jan 07, 2021 / 06:57, Dmitry Fomichev wrote:
> The test run against null_blk with the following command line -
>=20
> t/zbd/run-tests-against-nullb -l -q -s 12 -t 51 -n 100
>=20
> stops with a failure and the message below can be seen in the test log:
>=20
> fio: zbd.c:1110: zbd_convert_to_open_zone: Assertion `open_zone_idx < f->=
zbd_info->num_open_zones' failed.
>=20
> This assertion fails because pick_random_zone_idx() function returns
> index 0 if no zones are currently open. In this case, open_zone_idx and
> f->zbd_info->num_open_zones are both zero. Since this situation is
> normal, simply modify the assert statement to avoid failing.
>=20
> Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>

Looks good to me.

Reviewed-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

--=20
Best Regards,
Shin'ichiro Kawasaki=

