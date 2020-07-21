Return-Path: <prvs=464b1537e=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v3 6/6] t/zbd: Add test case to check zonecapacity option
Date: Tue, 21 Jul 2020 09:59:32 +0000
Message-ID: 
 <CY4PR04MB3751E2D748344A90396E50C8E7780@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200717093637.139565-1-shinichiro.kawasaki@wdc.com>
 <20200717093637.139565-7-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: Hans Holmberg <Hans.Holmberg@wdc.com>, Aravind Ramesh <Aravind.Ramesh@wdc.com>
List-ID: <fio@vger.kernel.org>

On 2020/07/17 18:36, Shin'ichiro Kawasaki wrote:=0A=
> From: Hans Holmberg <hans.holmberg@wdc.com>=0A=
> =0A=
> Add test case #49 which confirms the newly introduced zonecapacity=0A=
> option is working as expected with regular block devices.=0A=
> =0A=
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>=0A=
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>=0A=
> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
> ---=0A=
>  t/zbd/test-zbd-support | 20 ++++++++++++++++++++=0A=
>  1 file changed, 20 insertions(+)=0A=
> =0A=
> diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support=0A=
> index 31718c95..e53a20c5 100755=0A=
> --- a/t/zbd/test-zbd-support=0A=
> +++ b/t/zbd/test-zbd-support=0A=
> @@ -839,6 +839,26 @@ test48() {=0A=
>  	    >> "${logfile}.${test_number}" 2>&1 || return $?=0A=
>  }=0A=
>  =0A=
> +# Check if fio handles --zonecapacity on a normal block device correctly=
=0A=
> +test49() {=0A=
> +=0A=
> +    if [ -n "$is_zbd" ]; then=0A=
> +	echo "$dev is not a regular block device" \=0A=
> +	     >>"${logfile}.${test_number}"=0A=
> +	return 0=0A=
> +    fi=0A=
> +=0A=
> +    size=3D$((2 * zone_size))=0A=
> +    capacity=3D$((zone_size * 3 / 4))=0A=
> +=0A=
> +    run_one_fio_job "$(ioengine "psync")" --rw=3Dwrite \=0A=
> +		    --zonemode=3Dzbd --zonesize=3D"${zone_size}" \=0A=
> +		    --zonecapacity=3D${capacity} \=0A=
> +		    --verify=3Dmd5  --size=3D${size} >>"${logfile}.${test_number}" 2>&=
1 ||=0A=
> +	return $?=0A=
> +    check_read $((capacity * 2)) || return $?=0A=
=0A=
The workload is rw=3Dwrite, but this is calling check_read. Is this intende=
d ?=0A=
=0A=
> +}=0A=
> +=0A=
>  tests=3D()=0A=
>  dynamic_analyzer=3D()=0A=
>  reset_all_zones=3D=0A=
> =0A=
=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

