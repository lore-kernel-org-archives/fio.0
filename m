Return-Path: <prvs=649de9d05=shinichiro.kawasaki@wdc.com>
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH v3 38/38] t/zbd: avoid looping on invalid command line
 options
Date: Fri, 22 Jan 2021 09:14:18 +0000
Message-ID: <20210122091417.ibdbodvhysdratw6@shindev.dhcp.fujisawa.hgst.com>
References: <20210106215739.264524-1-dmitry.fomichev@wdc.com>
 <20210106215739.264524-39-dmitry.fomichev@wdc.com>
In-Reply-To: <20210106215739.264524-39-dmitry.fomichev@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <060B13A13D478E49B2A31BBD3E53F636@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Aravind Ramesh <Aravind.Ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <Naohiro.Aota@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>, Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On Jan 07, 2021 / 06:57, Dmitry Fomichev wrote:
> t/zbd/test-zbd-support loops indefinitely if an unrecognized option
> is specified in the command line. Add a switch case to display usage
> and exit the script.
>=20
> Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>

Looks good to me.

Reviewed-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

--=20
Best Regards,
Shin'ichiro Kawasaki=

