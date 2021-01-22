Return-Path: <prvs=649de9d05=shinichiro.kawasaki@wdc.com>
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH v3 09/38] zbd: don't unlock zone mutex after verify replay
Date: Fri, 22 Jan 2021 04:13:40 +0000
Message-ID: <20210122041339.a72fpozvhmn7oha3@shindev.dhcp.fujisawa.hgst.com>
References: <20210106215739.264524-1-dmitry.fomichev@wdc.com>
 <20210106215739.264524-10-dmitry.fomichev@wdc.com>
In-Reply-To: <20210106215739.264524-10-dmitry.fomichev@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F83036F395ABAB479EF77B8910BC2F72@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Aravind Ramesh <Aravind.Ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <Naohiro.Aota@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>, Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On Jan 07, 2021 / 06:57, Dmitry Fomichev wrote:
> zbd_adjust_block() always returns with the zone locked if the i/o is
> accepted. The corresponding unlock happens in zbd_put_io(). The
> function description says -
>=20
>  * Locking strategy: returns with z->mutex locked if and only if z refers
>  * to a sequential zone and if io_u_accept is returned. z is the zone tha=
t
>  * corresponds to io_u->offset at the end of this function.
>=20
> Remove the recently added unlock after zbd_replay_write_order() call.
> Add a Coverity annotation to mark the absence of unlock as intentional.
>=20
> Fixes: b2726d53bb5d ("zbd: Add a missing pthread_mutex_unlock() call")
> Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>

Looks good to me.

Reviewed-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

--=20
Best Regards,
Shin'ichiro Kawasaki=

