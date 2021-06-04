Return-Path: <prvs=782a7b7b5=Niklas.Cassel@wdc.com>
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: Re: [PATCH v2 2/3] t/zbd: Add ignore_zone_limit option to test with
 special max_open_zones
Date: Fri, 4 Jun 2021 07:35:53 +0000
Message-ID: <YLnX2BSmOTwJuO4q@x1-carbon>
References: <20210604053351.763028-1-shinichiro.kawasaki@wdc.com>
 <20210604053351.763028-3-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20210604053351.763028-3-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AAB662644C95494B9E5A3D9EF8EFD151@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

On Fri, Jun 04, 2021 at 02:33:50PM +0900, Shin'ichiro Kawasaki wrote:
> Recent commit d2f442bc0bd5 ("ioengines: add get_max_open_zones zoned
> block device operation") modified fio to compare --max_open_zones option
> value and max_open_zones reported by the device. When the option
> --max_open_zones is larger than the device limit, fio exits with an
> error. However, sometimes it is useful to run fio with --max_open_zones
> larger than the device limit to check performance impact of implicit
> zone open and close by the zoned block devices. The test script
> t/zbd/test-zbd-support has an option -o so that users can specify such
> larger max_open_zones value. After the commit, such test runs fail with
> the fio error.
>=20
> To avoid the failure, modify the test script to specify another option
> --ignore_zone_limits to fio command, which was added by the commit
> 575686bb85fa (zbd: add a new --ignore_zone_limits option). This option
> is added to fio command only when users specify -o option and special
> max_open_zones value to the test script. This change does not affect
> default test conditions.
>=20
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>  t/zbd/test-zbd-support | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
> index 26aff373..015fa1dc 100755
> --- a/t/zbd/test-zbd-support
> +++ b/t/zbd/test-zbd-support
> @@ -1348,6 +1348,7 @@ fi
>  if [[ -n ${max_open_zones_opt} ]]; then
>  	# Override max_open_zones with the script option value
>  	max_open_zones=3D"${max_open_zones_opt}"
> +	global_var_opts+=3D("--ignore_zone_limits=3D1")
>  	job_var_opts+=3D("--max_open_zones=3D${max_open_zones_opt}")
>  fi
> =20
> --=20
> 2.31.1
>=20

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=

