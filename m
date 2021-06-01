Return-Path: <prvs=7792dbf0f=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 2/3] t/zbd: Add ignore_zone_limit option to test with
 special max_open_zones
Date: Tue, 1 Jun 2021 07:03:34 +0000
Message-ID: 
 <DM6PR04MB7081F9CA6C9CCD2552DEB999E73E9@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210601064753.734892-1-shinichiro.kawasaki@wdc.com>
 <20210601064753.734892-3-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>
List-ID: <fio@vger.kernel.org>

On 2021/06/01 15:48, Shin'ichiro Kawasaki wrote:=0A=
> Recent commit d2f442bc0bd5 ("ioengines: add get_max_open_zones zoned=0A=
> block device operation") modified fio to compare --max_open_zoned option=
=0A=
> value and max_open_zones reported by the device. When the option=0A=
> --max_open_zones is larger than the device limit, fio exits with an=0A=
> error. However, sometimes it is useful to run fio with --max_open_zones=
=0A=
> larger than the device limit to check performance impact of implicit=0A=
> zone open and close by the zoned block devices. The test script=0A=
> t/zbd/test-zbd-support has an option -o so that users can specify such=0A=
> larger max_open_zones value. After the commit, such test runs fail with=
=0A=
> the fio error.=0A=
> =0A=
> To avoid the failure, modify the test script to specify another option=0A=
> --ignore_zone_limits to fio command, which was added by the commit=0A=
> 575686bb85fa (zbd: add a new --ignore_zone_limits option). This option=0A=
> is added to fio command only when users specify -o option and special=0A=
> max_open_zones value to the test script. This change does not affect=0A=
> default test conditions.=0A=
> =0A=
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>=0A=
> ---=0A=
>  t/zbd/test-zbd-support | 1 +=0A=
>  1 file changed, 1 insertion(+)=0A=
> =0A=
> diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support=0A=
> index 26aff373..015fa1dc 100755=0A=
> --- a/t/zbd/test-zbd-support=0A=
> +++ b/t/zbd/test-zbd-support=0A=
> @@ -1348,6 +1348,7 @@ fi=0A=
>  if [[ -n ${max_open_zones_opt} ]]; then=0A=
>  	# Override max_open_zones with the script option value=0A=
>  	max_open_zones=3D"${max_open_zones_opt}"=0A=
> +	global_var_opts+=3D("--ignore_zone_limits=3D1")=0A=
>  	job_var_opts+=3D("--max_open_zones=3D${max_open_zones_opt}")=0A=
>  fi=0A=
>  =0A=
> =0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

