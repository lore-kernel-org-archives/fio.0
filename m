Return-Path: <prvs=649de9d05=shinichiro.kawasaki@wdc.com>
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH v3 15/38] zbd: use zone_lock() in zbd_process_swd()
Date: Fri, 22 Jan 2021 04:28:25 +0000
Message-ID: <20210122042823.dzqtc4o73vz3aegk@shindev.dhcp.fujisawa.hgst.com>
References: <20210106215739.264524-1-dmitry.fomichev@wdc.com>
 <20210106215739.264524-16-dmitry.fomichev@wdc.com>
In-Reply-To: <20210106215739.264524-16-dmitry.fomichev@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3D6DE589EFA6D04BA20127D5DC0F9514@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Aravind Ramesh <Aravind.Ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <Naohiro.Aota@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>, Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On Jan 07, 2021 / 06:57, Dmitry Fomichev wrote:
> Most of ZBD code in fio uses zone_lock() to lock write pointer zones.
> This wrapper, besides doing the obvious pthread mutex lock, quiesce
> the outstanding i/o when running via asynchronous ioengines. This is
> necessary to avoid deadlocks. The function zbd_process_swd(), however,
> still uses the naked pthread mutex to lock zones and this leads to a
> deadlock when running ZBD test #48 against regular nullb devices.
>=20
> The fix added in the same patch series that introduced test #48 was to
> NOT initialize SWD at all, but this solution is found to create
> problems with verify. As the proper fix, modify zbd_process_swd()
> to use zone_lock(). This makes the test #48 pass even when SWD counter
> is initialized.
>=20
> Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>

Looks good to me.

Reviewed-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

--=20
Best Regards,
Shin'ichiro Kawasaki=

