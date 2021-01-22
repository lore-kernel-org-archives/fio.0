Return-Path: <prvs=649de9d05=shinichiro.kawasaki@wdc.com>
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH v3 20/38] engines/libzbc: enable block backend
Date: Fri, 22 Jan 2021 04:49:14 +0000
Message-ID: <20210122044914.sa7ebfdijxc63h4x@shindev.dhcp.fujisawa.hgst.com>
References: <20210106215739.264524-1-dmitry.fomichev@wdc.com>
 <20210106215739.264524-21-dmitry.fomichev@wdc.com>
In-Reply-To: <20210106215739.264524-21-dmitry.fomichev@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AEBAC16F09BE22408420DACC2F4452CD@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Aravind Ramesh <Aravind.Ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <Naohiro.Aota@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>, Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On Jan 07, 2021 / 06:57, Dmitry Fomichev wrote:
> When opening a device, the current version of libzbc ioengine instructs
> libzbc to only try SCSI and ATA backends for scanning the drive. This
> prevents opening null_blk devices that fail to be accepted by the both
> above mentioned backends and require the block backend to be enabled.
>=20
> Set the appropriate flag to enable the block backend in zbc_open()
> libzbc call.
>=20
> Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>

Looks good to me.

Reviewed-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

--=20
Best Regards,
Shin'ichiro Kawasaki=

