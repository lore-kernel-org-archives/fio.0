Return-Path: <prvs=649de9d05=shinichiro.kawasaki@wdc.com>
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH v3 17/38] zbd: don't log "zone nnnn is not open" message
Date: Fri, 22 Jan 2021 04:31:56 +0000
Message-ID: <20210122043155.l2x36tv3bux4ofeu@shindev.dhcp.fujisawa.hgst.com>
References: <20210106215739.264524-1-dmitry.fomichev@wdc.com>
 <20210106215739.264524-18-dmitry.fomichev@wdc.com>
In-Reply-To: <20210106215739.264524-18-dmitry.fomichev@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FF08A3C722D2C14488A45083F7B43ED5@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Aravind Ramesh <Aravind.Ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <Naohiro.Aota@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>, Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On Jan 07, 2021 / 06:57, Dmitry Fomichev wrote:
> This log message has been added recently (it could have been my idea
> to add it during internal review) and it turns out that the message
> tends to flood the log when any decent workload is run with
> --zonemode=3Dzbd. Remove logging of this debug message.
>=20
> Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>

Looks good to me.

Reviewed-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

--=20
Best Regards,
Shin'ichiro Kawasaki=

