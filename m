Return-Path: <prvs=803266c0b=shinichiro.kawasaki@wdc.com>
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH 3/3] zbd: ensure that global max open zones limit is
 respected
Date: Fri, 25 Jun 2021 07:48:37 +0000
Message-ID: <20210625074836.h5lbloofvfkap3yu@shindev>
References: <20210624172256.37177-1-Niklas.Cassel@wdc.com>
 <20210624172256.37177-4-Niklas.Cassel@wdc.com>
In-Reply-To: <20210624172256.37177-4-Niklas.Cassel@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0FC9EF0BB0205D44901F41BC46913327@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Niklas Cassel <Niklas.Cassel@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, "adobriyan@gmail.com" <adobriyan@gmail.com>
List-ID: <fio@vger.kernel.org>

On Jun 24, 2021 / 17:23, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
>=20
> Commit 219c662d3b12 ("zbd: introduce per job maximum open zones limit")
> Introduced a global max open zones limit stored in zbd_info->max_open_zon=
es.
>=20
> This commit also changed checks against td->o.max_open_zones in zbd_open_=
zone()
> with checks against zbd_info->max_open_zones.
>=20
> It is obvious that zbd_info->max_open_zones was intended to replace
> td->o.max_open_zones in all code that is executed after zbd_setup_files()=
.
>=20
> The commit itself was needed since zbd_info is shared over different jobs=
,
> so it is important that the global limit of max open zones is the same,
> for different jobs targeting the same device.
>=20
> The problem with this commit is that in zbd_convert_to_open_zone(),
> instead of replacing td->o.max_open_zones with zbd_info->max_open_zones,
> it incorrectly just removed the references to td->o.max_open_zones.
>=20
> This caused commit 00ca8df5468e ("zbd: Fix max_open_zones checks")
> (written by another author) to incorrectly re-add the removed
> td->o.max_open_zones checks in zbd_convert_to_open_zone().
> The proper fix here should have been to add checks against
> zbd_info->max_open_zones instead of td->o.max_open_zones,
> just like the original author did for zbd_open_zone().
>=20
> Replace all td->o.max_open_zones uses past zbd_setup_files() with
> zbd_info->max_open_zones, and force set td->o.max_open_zones to
> zbd_info->max_open_zones in zbd_setup_files(), so that even if checks are
> introduced against the wrong limit, fio will still respect the global lim=
it.
>=20
> Fixes: 00ca8df5468e ("zbd: Fix max_open_zones checks")
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> Cc: Alexey Dobriyan <adobriyan@gmail.com>
> Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

Thank you for the fix. Looks good to me.

Reviewed-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

--=20
Best Regards,
Shin'ichiro Kawasaki=

