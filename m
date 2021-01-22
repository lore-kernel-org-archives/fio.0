Return-Path: <prvs=649de9d05=shinichiro.kawasaki@wdc.com>
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH v3 04/38] zbd: introduce zone_unlock()
Date: Fri, 22 Jan 2021 02:23:59 +0000
Message-ID: <20210122022358.y5ubzcf46jtsl54v@shindev.dhcp.fujisawa.hgst.com>
References: <20210106215739.264524-1-dmitry.fomichev@wdc.com>
 <20210106215739.264524-5-dmitry.fomichev@wdc.com>
In-Reply-To: <20210106215739.264524-5-dmitry.fomichev@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6DA5125AB3FBBC4B846389380972772C@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Aravind Ramesh <Aravind.Ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <Naohiro.Aota@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>, Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On Jan 07, 2021 / 06:57, Dmitry Fomichev wrote:
> ZBD code already defines a helper function to lock a device zone,
> zone_lock(). There is no zone_unlock() function though.
>=20
> Wrap zone mutex unlock to zone_unlock() helper along with an assert
> to make sure that the unlock is successful, i.e. that the function
> is being called with the pointer to a locked zone.
>=20
> Suggested-by: Niklas Cassel <niklas.cassel@wdc.com>
> Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>

Looks good to me.

Reviewed-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

--=20
Best Regards,
Shin'ichiro Kawasaki=

