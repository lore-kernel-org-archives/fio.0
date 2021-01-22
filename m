Return-Path: <prvs=649de9d05=shinichiro.kawasaki@wdc.com>
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH v3 18/38] zbd: handle conventional start zone in
 zbd_convert_to_open_zone()
Date: Fri, 22 Jan 2021 04:36:40 +0000
Message-ID: <20210122043639.2eek4ghpycmeyaoq@shindev.dhcp.fujisawa.hgst.com>
References: <20210106215739.264524-1-dmitry.fomichev@wdc.com>
 <20210106215739.264524-19-dmitry.fomichev@wdc.com>
In-Reply-To: <20210106215739.264524-19-dmitry.fomichev@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8D96FFAFB437224AB2C28A6968BAA3E4@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Aravind Ramesh <Aravind.Ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <Naohiro.Aota@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>, Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On Jan 07, 2021 / 06:57, Dmitry Fomichev wrote:
> At the beginning of zbd_convert_to_open_zone() function, a zone
> is picked in semi-random manner to become a candidate zone for
> redirecting the incoming write. In some circumstances, such as
> unlimited MaxOpen or i/o range that spans the boundary between
> conventional and sequential zones, a conventional zone may be
> selected.
>=20
> This may create problems in the subsequent for (;;) loop in the
> same function. Failed assertions were observed during the execution
> of newly introduced test #51 that showed that the code in that loop
> was trying to lock and unlock conventional zones.
>=20
> Check if the zone which has been initially picked is conventional.
> If yes, force the zone selection to be re-tried until a sequential
> zone is selected for further processing.
>=20
> Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>

Looks good to me.

Reviewed-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

--=20
Best Regards,
Shin'ichiro Kawasaki=

