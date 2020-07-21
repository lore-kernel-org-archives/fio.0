Return-Path: <prvs=464b1537e=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v3 5/6] t/zbd: Support testing zone capacity smaller than
 zone size with null_blk
Date: Tue, 21 Jul 2020 09:57:22 +0000
Message-ID: 
 <CY4PR04MB37518A4E826C21C93375D01FE7780@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200717093637.139565-1-shinichiro.kawasaki@wdc.com>
 <20200717093637.139565-6-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: Hans Holmberg <Hans.Holmberg@wdc.com>, Aravind Ramesh <Aravind.Ramesh@wdc.com>
List-ID: <fio@vger.kernel.org>

On 2020/07/17 18:36, Shin'ichiro Kawasaki wrote:=0A=
> To test zone capacity support by fio using null_blk, add -zone-cap option=
=0A=
> to run-tests-against-zoned-nullb. With this option, the script creates a=
=0A=
> null_blk device which has zone capacity smaller than zone size and run=0A=
> test-zbd-support script for the device.=0A=
> =0A=
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>=0A=
> ---=0A=
>  t/zbd/run-tests-against-zoned-nullb | 30 ++++++++++++++++++++++++++---=
=0A=
>  1 file changed, 27 insertions(+), 3 deletions(-)=0A=
> =0A=
> diff --git a/t/zbd/run-tests-against-zoned-nullb b/t/zbd/run-tests-agains=
t-zoned-nullb=0A=
> index 53aee3e8..f9c9530c 100755=0A=
> --- a/t/zbd/run-tests-against-zoned-nullb=0A=
> +++ b/t/zbd/run-tests-against-zoned-nullb=0A=
> @@ -6,6 +6,21 @@=0A=
>  =0A=
>  scriptdir=3D"$(cd "$(dirname "$0")" && pwd)"=0A=
>  =0A=
> +zone_size=3D1=0A=
> +zone_capacity=3D1=0A=
> +if [[ ${1} =3D=3D "-h" ]]; then=0A=
> +    echo "Usage: ${0} [OPTIONS]"=0A=
> +    echo "Options:"=0A=
> +    echo -e "\t-h Show this message."=0A=
> +    echo -e "\t-zone-cap Use null blk with zone capacity less than zone =
size."=0A=
> +    echo -e "\tany option supported by test-zbd-support script."=0A=
> +    exit 1=0A=
> +elif [[ ${1} =3D=3D "-zone-cap" ]]; then=0A=
> +    zone_size=3D4=0A=
> +    zone_capacity=3D3=0A=
> +    shift=0A=
> +fi=0A=
> +=0A=
>  for d in /sys/kernel/config/nullb/*; do [ -d "$d" ] && rmdir "$d"; done=
=0A=
>  modprobe -r null_blk=0A=
>  modprobe null_blk nr_devices=3D0 || exit $?=0A=
> @@ -17,9 +32,18 @@ modprobe -r null_blk=0A=
>  modprobe null_blk nr_devices=3D0 &&=0A=
>      cd /sys/kernel/config/nullb &&=0A=
>      mkdir nullb0 &&=0A=
> -    cd nullb0 &&=0A=
> -    echo 1 > zoned &&=0A=
> -    echo 1 > zone_size &&=0A=
> +    cd nullb0 || exit $?=0A=
> +=0A=
> +if ((zone_capacity < zone_size)); then=0A=
> +    if [[ ! -w zone_capacity ]]; then=0A=
> +        echo "null blk does not support zone capacity"=0A=
> +        exit 1=0A=
> +    fi=0A=
> +    echo "${zone_capacity}" > zone_capacity=0A=
> +fi=0A=
> +=0A=
> +echo 1 > zoned &&=0A=
> +    echo "${zone_size}" > zone_size &&=0A=
>      echo 0 > completion_nsec &&=0A=
>      echo 4096 > blocksize &&=0A=
>      echo 1024 > size &&=0A=
> =0A=
=0A=
Looks good to me.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

