Return-Path: <prvs=7792dbf0f=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 1/3] t/zbd: Use max_open_zones that fio fetched from
 device
Date: Tue, 1 Jun 2021 07:01:18 +0000
Message-ID: 
 <DM6PR04MB7081B85BD9106F0824A9F8C5E73E9@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210601064753.734892-1-shinichiro.kawasaki@wdc.com>
 <20210601064753.734892-2-shinichiro.kawasaki@wdc.com>
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
=0A=
s/max_open_zoned/max_open_zones=0A=
=0A=
> value and max_open_zones reported by the device. The device limit is=0A=
> fetched through sysfs or through an ioengine specific implementation.=0A=
> =0A=
> The test script currently try to fetch the max open zones limit using=0A=
> libzbc tools or sg_inq. If either of these fail, default value 128 is=0A=
> supplied. This default value can be too high when the test script is=0A=
> run for certain zoned block devices, and can therefore result in fio=0A=
> error and test case failure.=0A=
=0A=
If sysfs has the max_open_zones attribute file present, that value should b=
e=0A=
retrieved first. libzbc and sg_inq should be used only if the sysfs attribu=
te is=0A=
not present, that is, when running on older kernels.=0A=
=0A=
> =0A=
> To avoid the failure, modify the default value used in the test script=0A=
> from 128 to 0. With this, --max_open_zoned=3D0 is passed to fio, and it=
=0A=
> makes fio use the max_open_zones reported by the device.=0A=
=0A=
Why pass anything at all since now fio will use the device reported limit b=
y=0A=
default if the user does not specify anything ?=0A=
=0A=
> =0A=
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>=0A=
> ---=0A=
>  t/zbd/functions | 4 ++--=0A=
>  1 file changed, 2 insertions(+), 2 deletions(-)=0A=
> =0A=
> diff --git a/t/zbd/functions b/t/zbd/functions=0A=
> index 40ffe1de..1a7ea970 100644=0A=
> --- a/t/zbd/functions=0A=
> +++ b/t/zbd/functions=0A=
> @@ -180,8 +180,8 @@ max_open_zones() {=0A=
>  	if ! ${sg_inq} -e --page=3D0xB6 --len=3D20 --hex "$dev" \=0A=
>  		 > /dev/null 2>&1; then=0A=
>  	    # Non scsi device such as null_blk can not return max open zones.=
=0A=
=0A=
This comment is a little outdated since even nullblk now has a limit expose=
d=0A=
through sysfs (the limit may be 0 =3D=3D no limit). See above comment. sysf=
s should=0A=
be the first thing to look at.=0A=
=0A=
> -	    # Use default value.=0A=
> -	    echo 128=0A=
> +	    # Specify 0 to indicate fio to get max open zones from the device.=
=0A=
> +	    echo 0=0A=
>  	else=0A=
>  	    ${sg_inq} -e --page=3D0xB6 --len=3D20 --hex "$dev" | tail -1 |=0A=
>  		{=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

