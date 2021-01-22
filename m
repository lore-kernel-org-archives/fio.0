Return-Path: <prvs=649de9d05=shinichiro.kawasaki@wdc.com>
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH v3 14/38] zbd: initialize sectors with data at start time
Date: Fri, 22 Jan 2021 04:19:55 +0000
Message-ID: <20210122041953.st67la6kse74s2zw@shindev.dhcp.fujisawa.hgst.com>
References: <20210106215739.264524-1-dmitry.fomichev@wdc.com>
 <20210106215739.264524-15-dmitry.fomichev@wdc.com>
In-Reply-To: <20210106215739.264524-15-dmitry.fomichev@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <13E1C88F190E354895D7982F04E6DF6F@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Aravind Ramesh <Aravind.Ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <Naohiro.Aota@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>, Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On Jan 07, 2021 / 06:57, Dmitry Fomichev wrote:
> From: Aravind Ramesh <aravind.ramesh@wdc.com>
>=20
> Based on the flag enable_check_swd, which is false by default, fio
> does not initialize the swd value at startup, initializing the swd
> value to be zero, even if some zones have sectors with data. This can
> result in fio reflecting less than actual swd after a few writes are
> completed. In workloads where verify is enabled, fio resets all the
> zones and while resetting, it decrements the swd counter with the
> actual number of swds in that zone(swd-count - swd-in-zone),
> since swd-count is initialized to 0, it results in overflow of the
> variable causing unpredictable issues.
>=20
> So, initialize the swd to the correct value.
>=20
> Fixes: 409a4f291e7f ("zbd: avoid initializing swd when unnecessary")
> Signed-off-by: Aravind Ramesh <aravind.ramesh@wdc.com>
> Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>

Looks good to me.

Reviewed-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

--=20
Best Regards,
Shin'ichiro Kawasaki=

