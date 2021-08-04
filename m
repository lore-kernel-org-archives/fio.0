Return-Path: <prvs=84353bb0d=shinichiro.kawasaki@wdc.com>
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH 1/2] HOWTO: Add missing documentation for
 job_max_open_zones
Date: Wed, 4 Aug 2021 12:01:32 +0000
Message-ID: <20210804120132.ucvogp44ox5ptmj3@shindev>
References: <20210804112308.28062-1-ankit.kumar@samsung.com>
 <CGME20210804112707epcas5p1b0bc0d3e4e85bcff47d4021359151a32@epcas5p1.samsung.com>
 <20210804112308.28062-2-ankit.kumar@samsung.com>
In-Reply-To: <20210804112308.28062-2-ankit.kumar@samsung.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FA29792CE0CE03469675F815D44A66E9@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Ankit Kumar <ankit.kumar@samsung.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, "krish.reddy@samsung.com" <krish.reddy@samsung.com>, "prakash.v@samsung.com" <prakash.v@samsung.com>
List-ID: <fio@vger.kernel.org>

On Aug 04, 2021 / 16:53, Ankit Kumar wrote:
> Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
> ---
>  HOWTO | 5 +++++
>  1 file changed, 5 insertions(+)
>=20
> diff --git a/HOWTO b/HOWTO
> index 59c7f1ff..d4e620de 100644
> --- a/HOWTO
> +++ b/HOWTO
> @@ -1055,6 +1055,11 @@ Target file/device
>  	number of open zones is defined as the number of zones to which write
>  	commands are issued.
> =20
> +.. option:: job_max_open_zones=3Dint
> +
> +	Limit on the number of simultaneously opened zones per single
> +	thread/process.
> +

Looks good to me.

Reviewed-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

--=20
Best Regards,
Shin'ichiro Kawasaki=

