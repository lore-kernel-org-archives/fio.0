Return-Path: <prvs=649de9d05=shinichiro.kawasaki@wdc.com>
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH v3 37/38] t/zbd: increase timeout in test #48
Date: Fri, 22 Jan 2021 09:12:57 +0000
Message-ID: <20210122091256.greqkdihfdp4vvzf@shindev.dhcp.fujisawa.hgst.com>
References: <20210106215739.264524-1-dmitry.fomichev@wdc.com>
 <20210106215739.264524-38-dmitry.fomichev@wdc.com>
In-Reply-To: <20210106215739.264524-38-dmitry.fomichev@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9531540C9FB7054CACB9B79001EA4891@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Aravind Ramesh <Aravind.Ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <Naohiro.Aota@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>, Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On Jan 07, 2021 / 06:57, Dmitry Fomichev wrote:
> Test #48 runs some i/o to the test device for 30 seconds and then waits
> 45 seconds for fio to finish. If this wait times out, the test assumes
> that fio is hung because of a zone locking issue and fails. It is
> observed that 45s may not be enough for some HDDs, especially the ones
> running specialized firmware.
>=20
> Increase the timeout to 180 seconds to avoid any false positives.
> There is no change in test duration for the most common devices.
> The test will wait for the full 180 seconds only if it fails, otherwise
> it will finish very soon after the 30 second i/o period ends.
>=20
> Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>

Looks good to me.

Reviewed-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

--=20
Best Regards,
Shin'ichiro Kawasaki=

