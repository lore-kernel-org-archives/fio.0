Return-Path: <prvs=7792dbf0f=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 3/3] t/zbd: Fix write target zones counting in test case
 #31
Date: Tue, 1 Jun 2021 07:07:50 +0000
Message-ID: 
 <DM6PR04MB70810E1AC76F674CA8644421E73E9@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210601064753.734892-1-shinichiro.kawasaki@wdc.com>
 <20210601064753.734892-4-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>
List-ID: <fio@vger.kernel.org>

On 2021/06/01 15:48, Shin'ichiro Kawasaki wrote:=0A=
> The test case #31 in t/zbd/test-zbd-support writes 128KB data to=0A=
> sequential write required zones as the preparation for the following=0A=
> random read test. The data write leaves the target zones in open status.=
=0A=
> The test case refers the variable 'nz', which has max_open_zones value,=
=0A=
> to decide how many zones to write the data. However, the end condition=0A=
> of the write target zone loop has a bug. The disk end offset is used as=
=0A=
> the loop end condition, which does not match the last target zone when=0A=
> number of sequential write required zones divided by nz has remainder.=0A=
> This results in write to more zones than nz=3Dmax_open_zones limit and th=
e=0A=
> test case failure. To fix the bug and to simplify the script, avoid the=
=0A=
> loop and utilize zonemode strided to achieve the same data write=0A=
> pattern. Also specify size and io_size using nz to reliably count the=0A=
> write target zones.=0A=
> =0A=
> Even with the fix above, still the number of open zones may exceed=0A=
> max_open_zones since other test cases executed before the test case 31=0A=
> may leave open zones on the test target device. To avoid this failure,=0A=
> reset all zones before the data write.=0A=
> =0A=
> The failures were observed with libzbc I/O engine after the commit=0A=
> e8267436fd7a ("engines/libzbc: add support for the get_max_open_zones io=
=0A=
> op"), which changed the max_open_zones value fio refers.=0A=
> =0A=
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>=0A=
> ---=0A=
>  t/zbd/test-zbd-support | 36 ++++++++++++++++--------------------=0A=
>  1 file changed, 16 insertions(+), 20 deletions(-)=0A=
> =0A=
> diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support=0A=
> index 015fa1dc..a684f988 100755=0A=
> --- a/t/zbd/test-zbd-support=0A=
> +++ b/t/zbd/test-zbd-support=0A=
> @@ -731,32 +731,28 @@ test30() {=0A=
>  test31() {=0A=
>      local bs inc nz off opts size=0A=
>  =0A=
> -    prep_write=0A=
> -    # Start with writing 128 KB to max_open_zones sequential zones.=0A=
> -    bs=3D128K=0A=
> +    [ -n "$is_zbd" ] && reset_zone "$dev" -1=0A=
> +=0A=
> +    # As preparation, write 128 KB to sequential write required zones. L=
imit=0A=
> +    # write target zones up to max_open_zones to keep test time reasonab=
le.=0A=
> +    # To distribute the write target zones evenly, skip certain zones fo=
r every=0A=
> +    # write. Utilize zonemode strided for such write patterns.=0A=
> +    bs=3D$((128 * 1024))=0A=
>      nz=3D$((max_open_zones))=0A=
>      if [[ $nz -eq 0 ]]; then=0A=
>  	nz=3D128=0A=
>      fi=0A=
> -    # shellcheck disable=3DSC2017=0A=
> -    inc=3D$(((disk_size - (first_sequential_zone_sector * 512)) / (nz * =
zone_size)=0A=
> -	   * zone_size))=0A=
> -    if [ "$inc" -eq 0 ]; then=0A=
> -	require_seq_zones $nz || return $SKIP_TESTCASE=0A=
> -    fi=0A=
> -    opts=3D()=0A=
> -    for ((off =3D first_sequential_zone_sector * 512; off < disk_size;=
=0A=
> -	  off +=3D inc)); do=0A=
> -	opts+=3D("--name=3D$dev" "--filename=3D$dev" "--offset=3D$off" "--io_si=
ze=3D$bs")=0A=
> -	opts+=3D("--bs=3D$bs" "--size=3D$zone_size" "$(ioengine "libaio")")=0A=
> -	opts+=3D("--rw=3Dwrite" "--direct=3D1" "--thread=3D1" "--stats=3D0")=0A=
> -	opts+=3D("--zonemode=3Dzbd" "--zonesize=3D${zone_size}")=0A=
> -	opts+=3D(${job_var_opts[@]})=0A=
> -    done=0A=
> -    "$(dirname "$0")/../../fio" "${opts[@]}" >> "${logfile}.${test_numbe=
r}" 2>&1=0A=
> -    # Next, run the test.=0A=
>      off=3D$((first_sequential_zone_sector * 512))=0A=
>      size=3D$((disk_size - off))=0A=
> +    inc=3D$(((size / nz / zone_size) * zone_size))=0A=
> +    opts=3D("--name=3D$dev" "--filename=3D$dev" "--rw=3Dwrite" "--bs=3D$=
{bs}")=0A=
> +    opts+=3D("--offset=3D$off" "--size=3D$((inc * nz))" "--io_size=3D$((=
bs * nz))")=0A=
> +    opts+=3D("--zonemode=3Dstrided" "--zonesize=3D${bs}" "--zonerange=3D=
${inc}")=0A=
> +    opts+=3D("--direct=3D1")=0A=
> +    echo "fio ${opts[@]}" >> "${logfile}.${test_number}"=0A=
> +    "$(dirname "$0")/../../fio" "${opts[@]}" >> "${logfile}.${test_numbe=
r}" 2>&1=0A=
> +=0A=
> +    # Next, run the test.=0A=
>      opts=3D("--name=3D$dev" "--filename=3D$dev" "--offset=3D$off" "--siz=
e=3D$size")=0A=
>      opts+=3D("--bs=3D$bs" "$(ioengine "psync")" "--rw=3Drandread" "--dir=
ect=3D1")=0A=
>      opts+=3D("--thread=3D1" "--time_based" "--runtime=3D30" "--zonemode=
=3Dzbd")=0A=
> =0A=
=0A=
Looks OK to me.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

