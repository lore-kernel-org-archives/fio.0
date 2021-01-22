Return-Path: <prvs=649de9d05=shinichiro.kawasaki@wdc.com>
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH v3 33/38] t/zbd: prevent test #31 from looping
Date: Fri, 22 Jan 2021 08:56:40 +0000
Message-ID: <20210122085639.jt32liozb73xa4eu@shindev.dhcp.fujisawa.hgst.com>
References: <20210106215739.264524-1-dmitry.fomichev@wdc.com>
 <20210106215739.264524-34-dmitry.fomichev@wdc.com>
In-Reply-To: <20210106215739.264524-34-dmitry.fomichev@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3518395FEE7B34429D1C99BFEF48ED3C@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Aravind Ramesh <Aravind.Ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <Naohiro.Aota@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>, Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On Jan 07, 2021 / 06:57, Dmitry Fomichev wrote:
> The test 31 starts i/o to 128 zones in parallel.
> There are two corner cases that are not properly handled in the
> existing implementation -
> 1) If the total number of zones on the device is < 128, the test
> will loop indefinitely because the loop increment is calculated as
> zero by the script.
> 2) If the number of max_open_zones of the device is < 128, the
> test will fail due to exceeding max_open_zones limit as the code
> expects it to be >=3D 128.
>=20
> Limit the number of open zones to the reported maximum
> and skip the test if there is not enough zones on the device.
>=20
> Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>

Looks good to me.

Reviewed-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

--=20
Best Regards,
Shin'ichiro Kawasaki=

