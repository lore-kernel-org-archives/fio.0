Return-Path: <prvs=649de9d05=shinichiro.kawasaki@wdc.com>
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH v3 22/38] zbd: set thread errors in zbd_adjust_block()
Date: Fri, 22 Jan 2021 05:12:22 +0000
Message-ID: <20210122051221.5rt7b3fjmh64ams6@shindev.dhcp.fujisawa.hgst.com>
References: <20210106215739.264524-1-dmitry.fomichev@wdc.com>
 <20210106215739.264524-23-dmitry.fomichev@wdc.com>
In-Reply-To: <20210106215739.264524-23-dmitry.fomichev@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B4914EB64973534E937116FD791A98F4@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Aravind Ramesh <Aravind.Ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <Naohiro.Aota@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>, Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On Jan 07, 2021 / 06:57, Dmitry Fomichev wrote:
> Several error conditions that are encountered during zone processing
> in zbd_adjust_block() function cause it to return io_u_eof value.
> This stops the i/o to the given file, but there is no error raised or
> reported if this code is returned. For a few particular conditions,
> just stopping the i/o is reasonable, but others are serious errors
> that should be reported.
>=20
> Add td_verror() calls to raise thread errors for a few abnormal
> conditions during adjusting the i/o. The only test that needs to be
> modified because of this changes is test #2.
>=20
> Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>

Looks good to me.

Reviewed-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

--=20
Best Regards,
Shin'ichiro Kawasaki=

