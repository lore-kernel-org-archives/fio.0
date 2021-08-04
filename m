Return-Path: <prvs=84353bb0d=shinichiro.kawasaki@wdc.com>
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH 2/2] zbd: Improve random zone index generation logic.
Date: Wed, 4 Aug 2021 05:59:18 +0000
Message-ID: <20210804055918.ngmj2u6wotztmctd@shindev>
References: <1627986516-4814-1-git-send-email-ankit.kumar@samsung.com>
 <CGME20210803111246epcas5p196f2a90009a00f639bbe5054570ac5a2@epcas5p1.samsung.com>
 <1627986516-4814-3-git-send-email-ankit.kumar@samsung.com>
In-Reply-To: <1627986516-4814-3-git-send-email-ankit.kumar@samsung.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8D12AF0130422446846C8AA2B8F3C923@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Ankit Kumar <ankit.kumar@samsung.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, "krish.reddy@samsung.com" <krish.reddy@samsung.com>, "prakash.v@samsung.com" <prakash.v@samsung.com>
List-ID: <fio@vger.kernel.org>

On Aug 03, 2021 / 15:58, Ankit Kumar wrote:
> Existing random zone index generation logic is dependent on the file size=
.
> For smaller I/O sizes the random zone index always return a particular
> section of open zones. As this index is used to return one of the open zo=
nes,
> it was observed that after one of the max_open_zones / job_max_open_zones=
 limit
> is reached all further I/O's are redirected to only a few open zones till=
 they
> are full.
>=20
> This patch modifies the random zone index genration logic so that it is u=
niform
> across all the open zones.
> ---
>  zbd.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/zbd.c b/zbd.c
> index 04c68de..43f12b4 100644
> --- a/zbd.c
> +++ b/zbd.c
> @@ -1184,11 +1184,12 @@ out:
>  	return res;
>  }
> =20
> -/* Anything goes as long as it is not a constant. */
> +/* Return random zone index for one of the open zones. */
>  static uint32_t pick_random_zone_idx(const struct fio_file *f,
>  				     const struct io_u *io_u)
>  {
> -	return io_u->offset * f->zbd_info->num_open_zones / f->real_file_size;
> +	return (io_u->offset - f->file_offset) * f->zbd_info->num_open_zones /
> +		f->io_size;
>  }

One nit I suggest is to remove the period in the commit message title. Othe=
r
than that, I confirmed the change is good. I confirmed that it improves the
randomness of the open zone choice. It reverts the part of the commit 6463d=
b6c1
('fio: fix interaction between offset/size limited threads and
"max_open_zones"'), but I confirmed that still the intent of the commit
6463db6c1 is kept after applying this change.

Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

--=20
Best Regards,
Shin'ichiro Kawasaki=

