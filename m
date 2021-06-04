Return-Path: <prvs=782a7b7b5=Niklas.Cassel@wdc.com>
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: Re: [PATCH v2 3/3] t/zbd: Fix write target zones counting in test
 case #31
Date: Fri, 4 Jun 2021 07:37:03 +0000
Message-ID: <YLnYHmv8TM26EgM1@x1-carbon>
References: <20210604053351.763028-1-shinichiro.kawasaki@wdc.com>
 <20210604053351.763028-4-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20210604053351.763028-4-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <133464901C146D49A1A24ABC064F3895@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

On Fri, Jun 04, 2021 at 02:33:51PM +0900, Shin'ichiro Kawasaki wrote:
> The test case #31 in t/zbd/test-zbd-support writes 128KB data to
> sequential write required zones as the preparation for the following
> random read test. The data write leaves the target zones in open status.
> The test case refers the variable 'nz', which has max_open_zones value,
> to decide how many zones to write the data. However, the end condition
> of the write target zone loop has a bug. The disk end offset is used as
> the loop end condition, which does not match the last target zone when
> number of sequential write required zones divided by nz has remainder.
> This results in write to more zones than nz=3Dmax_open_zones limit and th=
e
> test case failure. To fix the bug and to simplify the script, avoid the
> loop and utilize zonemode strided to achieve the same data write
> pattern. Also specify size and io_size using nz to reliably count the
> write target zones.
>=20
> Even with the fix above, still the number of open zones may exceed
> max_open_zones since other test cases executed before the test case 31
> may leave open zones on the test target device. To avoid this failure,
> reset all zones before the data write.
>=20
> The failures were observed with libzbc I/O engine after the commit
> e8267436fd7a ("engines/libzbc: add support for the get_max_open_zones io
> op"), which changed the max_open_zones value fio refers.
>=20
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>  t/zbd/test-zbd-support | 36 ++++++++++++++++--------------------
>  1 file changed, 16 insertions(+), 20 deletions(-)
>=20
> diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
> index 015fa1dc..a684f988 100755
> --- a/t/zbd/test-zbd-support
> +++ b/t/zbd/test-zbd-support
> @@ -731,32 +731,28 @@ test30() {
>  test31() {
>      local bs inc nz off opts size
> =20
> -    prep_write
> -    # Start with writing 128 KB to max_open_zones sequential zones.
> -    bs=3D128K
> +    [ -n "$is_zbd" ] && reset_zone "$dev" -1
> +
> +    # As preparation, write 128 KB to sequential write required zones. L=
imit
> +    # write target zones up to max_open_zones to keep test time reasonab=
le.
> +    # To distribute the write target zones evenly, skip certain zones fo=
r every
> +    # write. Utilize zonemode strided for such write patterns.
> +    bs=3D$((128 * 1024))
>      nz=3D$((max_open_zones))
>      if [[ $nz -eq 0 ]]; then
>  	nz=3D128
>      fi
> -    # shellcheck disable=3DSC2017
> -    inc=3D$(((disk_size - (first_sequential_zone_sector * 512)) / (nz * =
zone_size)
> -	   * zone_size))
> -    if [ "$inc" -eq 0 ]; then
> -	require_seq_zones $nz || return $SKIP_TESTCASE
> -    fi
> -    opts=3D()
> -    for ((off =3D first_sequential_zone_sector * 512; off < disk_size;
> -	  off +=3D inc)); do
> -	opts+=3D("--name=3D$dev" "--filename=3D$dev" "--offset=3D$off" "--io_si=
ze=3D$bs")
> -	opts+=3D("--bs=3D$bs" "--size=3D$zone_size" "$(ioengine "libaio")")
> -	opts+=3D("--rw=3Dwrite" "--direct=3D1" "--thread=3D1" "--stats=3D0")
> -	opts+=3D("--zonemode=3Dzbd" "--zonesize=3D${zone_size}")
> -	opts+=3D(${job_var_opts[@]})
> -    done
> -    "$(dirname "$0")/../../fio" "${opts[@]}" >> "${logfile}.${test_numbe=
r}" 2>&1
> -    # Next, run the test.
>      off=3D$((first_sequential_zone_sector * 512))
>      size=3D$((disk_size - off))
> +    inc=3D$(((size / nz / zone_size) * zone_size))
> +    opts=3D("--name=3D$dev" "--filename=3D$dev" "--rw=3Dwrite" "--bs=3D$=
{bs}")
> +    opts+=3D("--offset=3D$off" "--size=3D$((inc * nz))" "--io_size=3D$((=
bs * nz))")
> +    opts+=3D("--zonemode=3Dstrided" "--zonesize=3D${bs}" "--zonerange=3D=
${inc}")
> +    opts+=3D("--direct=3D1")
> +    echo "fio ${opts[@]}" >> "${logfile}.${test_number}"
> +    "$(dirname "$0")/../../fio" "${opts[@]}" >> "${logfile}.${test_numbe=
r}" 2>&1
> +
> +    # Next, run the test.
>      opts=3D("--name=3D$dev" "--filename=3D$dev" "--offset=3D$off" "--siz=
e=3D$size")
>      opts+=3D("--bs=3D$bs" "$(ioengine "psync")" "--rw=3Drandread" "--dir=
ect=3D1")
>      opts+=3D("--thread=3D1" "--time_based" "--runtime=3D30" "--zonemode=
=3Dzbd")
> --=20
> 2.31.1
>=20

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=

