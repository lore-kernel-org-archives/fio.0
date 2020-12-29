Return-Path: <prvs=625017359=shinichiro.kawasaki@wdc.com>
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH v2 32/36] t/zbd: add checks for offline zone condition
Date: Tue, 29 Dec 2020 05:38:02 +0000
Message-ID: <20201229053801.cz3lhbwgks2u5myh@shindev.dhcp.fujisawa.hgst.com>
References: <20201224021219.189727-1-dmitry.fomichev@wdc.com>
 <20201224021219.189727-33-dmitry.fomichev@wdc.com>
In-Reply-To: <20201224021219.189727-33-dmitry.fomichev@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5A0ED619FF2F444D9628275E74E12DF1@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Aravind Ramesh <Aravind.Ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <Naohiro.Aota@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>, Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

Hi Dmitry, thank you for posting the series.

On Dec 24, 2020 / 11:12, Dmitry Fomichev wrote:
> Some tests, e.g. #39 an #40, try to read the first zone of the drive.
> It is assumed that the first zone is readable. However, if the first
> zone is offline, the read fails along with the entire test.
>=20
> This commit adds two functions to perform zone report and find the
> first and the last zones that are not offline. Several test cases
> now call these functions to avoid test failures described above.
>=20
> Fixes for two more test failures are included in this commit -
>=20
> Test #14 tries to write to conventional zones if they are found at
> the beginning of the LBA range of the drive, but it assumes that
> these zones are online. This may not always be the case. Add "offset"
> to avoid the i/o to be attempted to run against any preceding offline
> zones.
>=20
> Similarly, in test #17, the script tries to find the last zone.
> Check for the case when the last zone is offline. The test doesn't
> set the i/o file size, but it works OK in most of the cases because
> typically this test operates on the last physical zone. With the
> online lookup in place, this may not always be the case and if there
> are any offline zones that trail the last non-offline zone,
> then the i/o will try to access that zone and fail. Add the "size"
> to avoid the i/o to be attempted to run against any trailing offline
> zones.
>=20
> Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
> ---
>  t/zbd/functions        | 56 ++++++++++++++++++++++++++++++++++++++++--
>  t/zbd/test-zbd-support | 31 +++++++++++++++++++----
>  2 files changed, 80 insertions(+), 7 deletions(-)
>=20
> diff --git a/t/zbd/functions b/t/zbd/functions
> index 1a64a215..cc26c2ab 100644
> --- a/t/zbd/functions
> +++ b/t/zbd/functions
> @@ -71,7 +71,7 @@ first_sequential_zone() {
> =20
>      if [ -n "${blkzone}" ] && [ ! -n "${use_libzbc}" ]; then
>  	${blkzone} report "$dev" |
> -	    sed -n 's/^[[:blank:]]*start:[[:blank:]]\([0-9a-zA-Z]*\),[[:blank:]=
]len[[:blank:]]\([0-9a-zA-Z]*\),.*type:[[:blank:]]2(.*/\1 \2/p' |
> +	    sed -n 's/^[[:blank:]]*start:[[:blank:]]\([0-9a-zA-Z]*\),[[:blank:]=
]len[[:blank:]]\([0-9a-zA-Z]*\),.*zcond:\(14\|[[:blank:]][0-4]\)(.*type:[[:=
blank:]]\([2]\)(.*/\1 \2/p' |
>  	    {
>  		read -r starting_sector length &&
>  		    # Convert from hex to decimal
> @@ -79,7 +79,7 @@ first_sequential_zone() {
>  	    }
>      else
>  	${zbc_report_zones} "$dev" |
> -	    sed -n 's/^Zone [0-9]*: type 0x2 .*, sector \([0-9]*\), \([0-9]*\) =
sectors,.*$/\1 \2/p' |
> +	    sed -n 's/^Zone [0-9]*: type 0x2 .*,.*,[[:blank:]]cond[[:blank:]]0x=
[0-4e][[:blank:]], sector \([0-9]*\), \([0-9]*\) sectors.*$/\1 \2/p' |

In my environment, the hunk above resulted in no output from the sed comman=
d.
The zbc_report_zones command output is as follows:

    Zone 00746: type 0x2 (Sequential-write-required), cond 0x2 (Implicit-op=
en), reset recommended 0, non_seq 0, sector 391118848, 524288 sectors, wp 3=
91120048

Then I think the sed command should be like this:

    sed -n 's/^Zone [0-9]*: type 0x2 .*,[[:blank:]]cond[[:blank:]]0x[0-4e][=
[:blank:]].*, sector \([0-9]*\), \([0-9]*\) sectors.*$/\1 \2/p' |

--=20
Best Regards,
Shin'ichiro Kawasaki


>  	    head -n1
>      fi
>  }
> @@ -121,6 +121,58 @@ total_zone_capacity() {
>  	echo $((capacity * 512))
>  }
> =20
> +# Reports the starting sector and length of the first zone of device $1
> +# that is not in offline (or similar) condition.
> +first_online_zone() {
> +    local dev=3D$1
> +
> +    if [ -z "$is_zbd" ]; then
> +	echo 0
> +	return
> +    fi
> +
> +    if [ -n "${blkzone}" ] && [ ! -n "${use_libzbc}" ]; then
> +	${blkzone} report "$dev" |
> +	    sed -n 's/^[[:blank:]]*start:[[:blank:]]\([0-9a-zA-Z]*\),[[:blank:]=
]len[[:blank:]]\([0-9a-zA-Z]*\),.*zcond:\(14\|[[:blank:]][0-4]\)(.*type:[[:=
blank:]][12](.*/\1/p' |
> +	    head -n1 |
> +	    {
> +		read -r starting_sector &&
> +		    # Convert from hex to decimal
> +		    echo $((starting_sector))
> +	    }
> +    else
> +	${zbc_report_zones} "$dev" |
> +	    sed -n 's/^Zone[[:blank:]][0-9]*:[[:blank:]]type[[:blank:]]0x[12][[=
:blank:]].*,[[:blank:]]cond[[:blank:]]0x[0-4e][[:blank:]].*,[[:blank:]]sect=
or[[:blank:]]\([0-9]*\),.*$/\1/p' |
> +	    head -n1
> +    fi
> +}
> +
> +# Reports the starting sector and length of the last zone of device $1
> +# that is not in offline (or similar) condition.
> +last_online_zone() {
> +    local dev=3D$1
> +
> +    if [ -z "$is_zbd" ]; then
> +	echo 0
> +	return
> +    fi
> +
> +    if [ -n "${blkzone}" ] && [ ! -n "${use_libzbc}" ]; then
> +	${blkzone} report "$dev" |
> +	    sed -n 's/^[[:blank:]]*start:[[:blank:]]\([0-9a-zA-Z]*\),[[:blank:]=
]len[[:blank:]]\([0-9a-zA-Z]*\),.*zcond:\(14\|[[:blank:]][0-4]\)(.*type:[[:=
blank:]][12](.*/\1/p' |
> +	    tail -1 |
> +	    {
> +		read -r starting_sector &&
> +		    # Convert from hex to decimal
> +		    echo $((starting_sector))
> +	    }
> +    else
> +	${zbc_report_zones} "$dev" |
> +	    sed -n 's/^Zone[[:blank:]][0-9]*:[[:blank:]]type[[:blank:]]0x[12][[=
:blank:]].*,[[:blank:]]cond[[:blank:]]0x[0-4e][[:blank:]].*,[[:blank:]]sect=
or[[:blank:]]\([0-9]*\),.*$/\1/p' |
> +	    tail -1
> +    fi
> +}
> +
>  max_open_zones() {
>      local dev=3D$1
> =20
> diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
> index 033c2ebc..0b8015df 100755
> --- a/t/zbd/test-zbd-support
> +++ b/t/zbd/test-zbd-support
> @@ -464,15 +464,20 @@ test13() {
> =20
>  # Random write to conventional zones.
>  test14() {
> -    local size
> +    local off size
> =20
> +    if ! result=3D($(first_online_zone "$dev")); then
> +	echo "Failed to determine first online zone"
> +	exit 1
> +    fi
> +    off=3D${result[0]}
>      prep_write
>      size=3D$((16 * 2**20)) # 20 MB
>      require_conv_zone_bytes "${size}" || return $SKIP_TESTCASE
> =20
>      run_one_fio_job "$(ioengine "libaio")" --iodepth=3D64 --rw=3Drandwri=
te --bs=3D16K \
>  		    --zonemode=3Dzbd --zonesize=3D"${zone_size}" --do_verify=3D1 \
> -		    --verify=3Dmd5 --size=3D$size				   \
> +		    --verify=3Dmd5 --offset=3D$off --size=3D$size\
>  		    >>"${logfile}.${test_number}" 2>&1 || return $?
>      check_written $((size)) || return $?
>      check_read $((size)) || return $?
> @@ -529,17 +534,26 @@ test16() {
> =20
>  # Random reads and writes in the last zone.
>  test17() {
> -    local io off read size written
> +    local io off last read size written
> =20
>      off=3D$(((disk_size / zone_size - 1) * zone_size))
>      size=3D$((disk_size - off))
> +    if ! last=3D($(last_online_zone "$dev")); then
> +	echo "Failed to determine last online zone"
> +	exit 1
> +    fi
> +    if [[ "$((last * 512))" -lt "$off" ]]; then
> +	off=3D$((last * 512))
> +	size=3D$zone_size
> +    fi
>      if [ -n "$is_zbd" ]; then
>  	reset_zone "$dev" $((off / 512)) || return $?
>      fi
>      prep_write
>      run_one_fio_job "$(ioengine "libaio")" --iodepth=3D8 --rw=3Drandrw -=
-bs=3D4K \
>  		    --zonemode=3Dzbd --zonesize=3D"${zone_size}"		\
> -		    --offset=3D$off --loops=3D2 --norandommap=3D1\
> +		    --offset=3D$off --loops=3D2 --norandommap=3D1 \
> +		    --size=3D"$size"\
>  		    >>"${logfile}.${test_number}" 2>&1 || return $?
>      written=3D$(fio_written <"${logfile}.${test_number}")
>      read=3D$(fio_read <"${logfile}.${test_number}")
> @@ -867,10 +881,17 @@ test38() {
> =20
>  # Read one block from a block device.
>  read_one_block() {
> +    local off
>      local bs
> =20
> +    if ! result=3D($(first_online_zone "$dev")); then
> +	echo "Failed to determine first online zone"
> +	exit 1
> +    fi
> +    off=3D${result[0]}
>      bs=3D$((logical_block_size))
> -    run_one_fio_job --rw=3Dread "$(ioengine "psync")" --bs=3D$bs --size=
=3D$bs "$@" 2>&1 |
> +    run_one_fio_job --rw=3Dread "$(ioengine "psync")" --offset=3D$off --=
bs=3D$bs \
> +		    --size=3D$bs "$@" 2>&1 |
>  	tee -a "${logfile}.${test_number}"
>  }
> =20
> --=20
> 2.28.0
> =

