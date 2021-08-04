Return-Path: <prvs=84353bb0d=shinichiro.kawasaki@wdc.com>
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH 1/2] Add missing documentation for job_max_open_zones.
Date: Wed, 4 Aug 2021 05:52:35 +0000
Message-ID: <20210804055234.2ybmcqastjeseghy@shindev>
References: <1627986516-4814-1-git-send-email-ankit.kumar@samsung.com>
 <CGME20210803111237epcas5p3793e7b1dbb19ccad4841e5ba69ee1bb8@epcas5p3.samsung.com>
 <1627986516-4814-2-git-send-email-ankit.kumar@samsung.com>
In-Reply-To: <1627986516-4814-2-git-send-email-ankit.kumar@samsung.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5F5FAEFA230B8642A075FF8CFFA50C59@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Ankit Kumar <ankit.kumar@samsung.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, "krish.reddy@samsung.com" <krish.reddy@samsung.com>, "prakash.v@samsung.com" <prakash.v@samsung.com>
List-ID: <fio@vger.kernel.org>

Hello Ankit,

On Aug 03, 2021 / 15:58, Ankit Kumar wrote:
> ---
>  HOWTO | 5 +++++
>  1 file changed, 5 insertions(+)
>=20
> diff --git a/HOWTO b/HOWTO
> index 59c7f1f..d4e620d 100644
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

This change looks good to me, but I think the commit message title can be
improved. "HOWTO: " prefix will help to identify the change target file. Al=
so,
I suggest to remove the period in the title. As far as I know, all fio comm=
its
do not have period in their commit message titles.

>  .. option:: zone_reset_threshold=3Dfloat
> =20
>  	A number between zero and one that indicates the ratio of logical
> --=20
> 1.8.3.1
>=20

--=20
Best Regards,
Shin'ichiro Kawasaki

