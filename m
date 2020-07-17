Return-Path: <prvs=460a6953b=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v2 4/6] t/zbd: Support testing zone capacity smaller than
 zone size
Date: Fri, 17 Jul 2020 02:01:38 +0000
Message-ID: 
 <CY4PR04MB3751443B7CD688F5691C2280E77C0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200715064141.116415-1-shinichiro.kawasaki@wdc.com>
 <20200715064141.116415-5-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: Hans Holmberg <Hans.Holmberg@wdc.com>, Aravind Ramesh <Aravind.Ramesh@wdc.com>
List-ID: <fio@vger.kernel.org>

On 2020/07/15 15:41, Shin'ichiro Kawasaki wrote:=0A=
> From: Hans Holmberg <hans.holmberg@wdc.com>=0A=
> =0A=
> Add support for testing zoned block devices where zone capacity is less=
=0A=
> than zone size. If the test case runs sequential workloads or workloads=
=0A=
> with verify, use zone capacity instead of zone size to complete.=0A=
> =0A=
> To use zone capacity of the test target zones, introduce a helper=0A=
> function total_zone_capacity() which sums up zone capacity numbers of the=
=0A=
> test target zones.=0A=
> =0A=
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>=0A=
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>=0A=
> ---=0A=
>  t/zbd/functions        |  37 +++++++++++++++=0A=
>  t/zbd/test-zbd-support | 100 ++++++++++++++++++++++++++---------------=
=0A=
>  2 files changed, 102 insertions(+), 35 deletions(-)=0A=
> =0A=
> diff --git a/t/zbd/functions b/t/zbd/functions=0A=
> index 344836c8..82d64f5c 100644=0A=
> --- a/t/zbd/functions=0A=
> +++ b/t/zbd/functions=0A=
> @@ -84,6 +84,43 @@ first_sequential_zone() {=0A=
>      fi=0A=
>  }=0A=
>  =0A=
> +# Reports the summed zone capacity of $1 number of zones starting from o=
ffset $2=0A=
> +# on device $3.=0A=
> +total_zone_capacity() {=0A=
> +	local nr_zones=3D$1=0A=
> +	local sector=3D$(($2 / 512))=0A=
> +	local dev=3D$3=0A=
> +	local capacity=3D0 num=0A=
> +	local grep_str=0A=
> +=0A=
> +	if [ -z "$is_zbd" ]; then=0A=
> +		# For regular block devices, handle zone size as zone capacity.=0A=
> +		echo $((zone_size * nr_zones))=0A=
> +		return=0A=
> +	fi=0A=
> +=0A=
> +	if [ -n "${blkzone}" ] && [ ! -n "${use_libzbc}" ]; then=0A=
> +		if blkzone_reports_capacity "${dev}"; then=0A=
> +			grep_str=3D'cap \K[0-9a-zA-Z]*'=0A=
> +		else=0A=
> +			# If zone capacity is not reported, refer zone length.=0A=
> +			grep_str=3D'len \K[0-9a-zA-Z]*'=0A=
> +		fi=0A=
> +		while read num; do=0A=
> +			capacity=3D$((capacity + num))=0A=
> +		done < <(${blkzone} report -c "$nr_zones" -o "$sector" "$dev" |=0A=
> +				grep -Po "${grep_str}")=0A=
=0A=
Why the space in "< <" ? Why not "<<" ?=0A=
=0A=
> +	else=0A=
> +		# ZBC devices do not have zone capacity. Use zone size.=0A=
> +		while read num; do=0A=
> +			capacity=3D$((capacity + num))=0A=
> +		done < <(${zbc_report_zones} -nz "$nr_zones" -start "$sector" \=0A=
> +				"$dev" | grep -Po 'sector [0-9]*, \K[0-9]*')=0A=
=0A=
Same here.=0A=
=0A=
> +	fi=0A=
> +=0A=
> +	echo $((capacity * 512))=0A=
> +}=0A=
> +=0A=
>  max_open_zones() {=0A=
>      local dev=3D$1=0A=
>  =0A=
> diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support=0A=
> index f086bd10..31718c95 100755=0A=
> --- a/t/zbd/test-zbd-support=0A=
> +++ b/t/zbd/test-zbd-support=0A=
> @@ -204,55 +204,64 @@ test4() {=0A=
>  =0A=
>  # Sequential write to sequential zones.=0A=
>  test5() {=0A=
> -    local size=0A=
> +    local size off capacity=0A=
>  =0A=
> +    off=3D$((first_sequential_zone_sector * 512))=0A=
> +    capacity=3D$(total_zone_capacity 4 $off $dev)=0A=
>      size=3D$((4 * zone_size))=0A=
>      run_fio_on_seq "$(ioengine "psync")" --iodepth=3D1 --rw=3Dwrite	\=0A=
>  		   --bs=3D"$(max $((zone_size / 64)) "$logical_block_size")"\=0A=
>  		   --do_verify=3D1 --verify=3Dmd5				\=0A=
>  		   >>"${logfile}.${test_number}" 2>&1 || return $?=0A=
> -    check_written $size || return $?=0A=
> -    check_read $size || return $?=0A=
> +    check_written $capacity || return $?=0A=
> +    check_read $capacity || return $?=0A=
>  }=0A=
>  =0A=
>  # Sequential read from sequential zones.=0A=
>  test6() {=0A=
> -    local size=0A=
> +    local size off capacity=0A=
>  =0A=
> +    off=3D$((first_sequential_zone_sector * 512))=0A=
> +    capacity=3D$(total_zone_capacity 4 $off $dev)=0A=
>      size=3D$((4 * zone_size))=0A=
>      write_and_run_one_fio_job \=0A=
>  	    $((first_sequential_zone_sector * 512)) "${size}" \=0A=
> -	    --offset=3D$((first_sequential_zone_sector * 512)) \=0A=
> +	    --offset=3D"${off}" \=0A=
>  	    --size=3D"${size}" --zonemode=3Dzbd --zonesize=3D"${zone_size}" \=
=0A=
>  	    "$(ioengine "psync")" --iodepth=3D1 --rw=3Dread \=0A=
>  	    --bs=3D"$(max $((zone_size / 64)) "$logical_block_size")" \=0A=
>  	    >>"${logfile}.${test_number}" 2>&1 || return $?=0A=
> -    check_read $size || return $?=0A=
> +    check_read $capacity || return $?=0A=
>  }=0A=
>  =0A=
>  # Random write to sequential zones, libaio, queue depth 1.=0A=
>  test7() {=0A=
>      local size=3D$((zone_size))=0A=
> +    local off capacity=0A=
>  =0A=
> +    off=3D$((first_sequential_zone_sector * 512))=0A=
> +    capacity=3D$(total_zone_capacity 1 $off $dev)=0A=
>      run_fio_on_seq "$(ioengine "libaio")" --iodepth=3D1 --rw=3Drandwrite=
	\=0A=
>  		   --bs=3D"$(min 16384 "${zone_size}")"			\=0A=
>  		   --do_verify=3D1 --verify=3Dmd5 --size=3D"$size"		\=0A=
>  		   >>"${logfile}.${test_number}" 2>&1 || return $?=0A=
> -    check_written $size || return $?=0A=
> -    check_read $size || return $?=0A=
> +    check_written $capacity || return $?=0A=
> +    check_read $capacity || return $?=0A=
>  }=0A=
>  =0A=
>  # Random write to sequential zones, libaio, queue depth 64.=0A=
>  test8() {=0A=
> -    local size=0A=
> +    local size off capacity=0A=
>  =0A=
>      size=3D$((4 * zone_size))=0A=
> +    off=3D$((first_sequential_zone_sector * 512))=0A=
> +    capacity=3D$(total_zone_capacity 4 $off $dev)=0A=
>      run_fio_on_seq "$(ioengine "libaio")" --iodepth=3D64 --rw=3Drandwrit=
e	\=0A=
>  		   --bs=3D"$(min 16384 "${zone_size}")"			\=0A=
>  		   --do_verify=3D1 --verify=3Dmd5				\=0A=
>  		   >>"${logfile}.${test_number}" 2>&1 || return $?=0A=
> -    check_written $size || return $?=0A=
> -    check_read $size || return $?=0A=
> +    check_written $capacity || return $?=0A=
> +    check_read $capacity || return $?=0A=
>  }=0A=
>  =0A=
>  # Random write to sequential zones, sg, queue depth 1.=0A=
> @@ -293,39 +302,45 @@ test10() {=0A=
>  =0A=
>  # Random write to sequential zones, libaio, queue depth 64, random block=
 size.=0A=
>  test11() {=0A=
> -    local size=0A=
> +    local size off capacity=0A=
>  =0A=
>      size=3D$((4 * zone_size))=0A=
> +    off=3D$((first_sequential_zone_sector * 512))=0A=
> +    capacity=3D$(total_zone_capacity 4 $off $dev)=0A=
>      run_fio_on_seq "$(ioengine "libaio")" --iodepth=3D64 --rw=3Drandwrit=
e	\=0A=
>  		   --bsrange=3D4K-64K --do_verify=3D1 --verify=3Dmd5		\=0A=
>  		   --debug=3Dzbd >>"${logfile}.${test_number}" 2>&1 || return $?=0A=
> -    check_written $size || return $?=0A=
> -    check_read $size || return $?=0A=
> +    check_written $capacity || return $?=0A=
> +    check_read $capacity || return $?=0A=
>  }=0A=
>  =0A=
>  # Random write to sequential zones, libaio, queue depth 64, max 1 open z=
one.=0A=
>  test12() {=0A=
> -    local size=0A=
> +    local size off capacity=0A=
>  =0A=
>      size=3D$((8 * zone_size))=0A=
> +    off=3D$((first_sequential_zone_sector * 512))=0A=
> +    capacity=3D$(total_zone_capacity 8 $off $dev)=0A=
>      run_fio_on_seq "$(ioengine "libaio")" --iodepth=3D64 --rw=3Drandwrit=
e --bs=3D16K \=0A=
>  		   --max_open_zones=3D1 --size=3D$size --do_verify=3D1 --verify=3Dmd5 =
\=0A=
>  		   --debug=3Dzbd >>"${logfile}.${test_number}" 2>&1 || return $?=0A=
> -    check_written $size || return $?=0A=
> -    check_read $size || return $?=0A=
> +    check_written $capacity || return $?=0A=
> +    check_read $capacity || return $?=0A=
>  }=0A=
>  =0A=
>  # Random write to sequential zones, libaio, queue depth 64, max 4 open z=
ones.=0A=
>  test13() {=0A=
> -    local size=0A=
> +    local size off capacity=0A=
>  =0A=
>      size=3D$((8 * zone_size))=0A=
> +    off=3D$((first_sequential_zone_sector * 512))=0A=
> +    capacity=3D$(total_zone_capacity 8 $off $dev)=0A=
>      run_fio_on_seq "$(ioengine "libaio")" --iodepth=3D64 --rw=3Drandwrit=
e --bs=3D16K \=0A=
>  		   --max_open_zones=3D4 --size=3D$size --do_verify=3D1 --verify=3Dmd5 =
\=0A=
>  		   --debug=3Dzbd						      \=0A=
>  		   >>"${logfile}.${test_number}" 2>&1 || return $?=0A=
> -    check_written $size || return $?=0A=
> -    check_read $size || return $?=0A=
> +    check_written $capacity || return $?=0A=
> +    check_read $capacity || return $?=0A=
>  }=0A=
>  =0A=
>  # Random write to conventional zones.=0A=
> @@ -349,7 +364,7 @@ test14() {=0A=
>  # Sequential read on a mix of empty and full zones.=0A=
>  test15() {=0A=
>      local i off size=0A=
> -    local w_off w_size=0A=
> +    local w_off w_size w_capacity=0A=
>  =0A=
>      for ((i=3D0;i<4;i++)); do=0A=
>  	[ -n "$is_zbd" ] &&=0A=
> @@ -358,6 +373,7 @@ test15() {=0A=
>      done=0A=
>      w_off=3D$(((first_sequential_zone_sector + 2 * sectors_per_zone) * 5=
12))=0A=
>      w_size=3D$((2 * zone_size))=0A=
> +    w_capacity=3D$(total_zone_capacity 2 $w_off $dev)=0A=
>      off=3D$((first_sequential_zone_sector * 512))=0A=
>      size=3D$((4 * zone_size))=0A=
>      write_and_run_one_fio_job "${w_off}" "${w_size}" \=0A=
> @@ -365,14 +381,14 @@ test15() {=0A=
>  		    --zonemode=3Dzbd --zonesize=3D"${zone_size}" --offset=3D$off \=0A=
>  		    --size=3D$((size)) >>"${logfile}.${test_number}" 2>&1 ||=0A=
>  	return $?=0A=
> -    check_written $((w_size)) || return $?=0A=
> -    check_read $((size / 2))=0A=
> +    check_written $((w_capacity)) || return $?=0A=
> +    check_read $((w_capacity))=0A=
>  }=0A=
>  =0A=
>  # Random read on a mix of empty and full zones.=0A=
>  test16() {=0A=
>      local off size=0A=
> -    local i w_off w_size=0A=
> +    local i w_off w_size w_capacity=0A=
>  =0A=
>      for ((i=3D0;i<4;i++)); do=0A=
>  	[ -n "$is_zbd" ] &&=0A=
> @@ -381,13 +397,14 @@ test16() {=0A=
>      done=0A=
>      w_off=3D$(((first_sequential_zone_sector + 2 * sectors_per_zone) * 5=
12))=0A=
>      w_size=3D$((2 * zone_size))=0A=
> +    w_capacity=3D$(total_zone_capacity 2 $w_off $dev)=0A=
>      off=3D$((first_sequential_zone_sector * 512))=0A=
>      size=3D$((4 * zone_size))=0A=
>      write_and_run_one_fio_job "${w_off}" "${w_size}" \=0A=
>  		    "$(ioengine "libaio")" --iodepth=3D64 --rw=3Drandread --bs=3D16K \=
=0A=
>  		    --zonemode=3Dzbd --zonesize=3D"${zone_size}" --offset=3D$off \=0A=
>  		    --size=3D$size >>"${logfile}.${test_number}" 2>&1 || return $?=0A=
> -    check_written $w_size || return $?=0A=
> +    check_written $w_capacity || return $?=0A=
>      check_read $size || return $?=0A=
>  }=0A=
>  =0A=
> @@ -451,13 +468,17 @@ test23() {=0A=
>  =0A=
>  test24() {=0A=
>      local bs loops=3D9 size=3D$((zone_size))=0A=
> +    local off capacity=0A=
> +=0A=
> +    off=3D$((first_sequential_zone_sector * 512))=0A=
> +    capacity=3D$(total_zone_capacity 1 $off $dev)=0A=
>  =0A=
>      bs=3D$(min $((256*1024)) "$zone_size")=0A=
>      run_fio_on_seq "$(ioengine "psync")" --rw=3Dwrite --bs=3D"$bs"		\=0A=
>  		   --size=3D$size --loops=3D$loops				\=0A=
>  		   --zone_reset_frequency=3D.01 --zone_reset_threshold=3D.90 \=0A=
>  		   >> "${logfile}.${test_number}" 2>&1 || return $?=0A=
> -    check_written $((size * loops)) || return $?=0A=
> +    check_written $((capacity * loops)) || return $?=0A=
>      check_reset_count -eq 8 ||=0A=
>  	check_reset_count -eq 9 ||=0A=
>  	check_reset_count -eq 10 || return $?=0A=
> @@ -483,15 +504,19 @@ test25() {=0A=
>  =0A=
>  write_to_first_seq_zone() {=0A=
>      local loops=3D4 r=0A=
> +    local off capacity=0A=
> +=0A=
> +    off=3D$((first_sequential_zone_sector * 512))=0A=
> +    capacity=3D$(total_zone_capacity 1 $off $dev)=0A=
>  =0A=
>      r=3D$(((RANDOM << 16) | RANDOM))=0A=
>      run_fio --name=3D"$dev" --filename=3D"$dev" "$(ioengine "psync")" --=
rw=3D"$1" \=0A=
>  	    --thread=3D1 --do_verify=3D1 --verify=3Dmd5 --direct=3D1 --bs=3D4K	=
\=0A=
> -	    --offset=3D$((first_sequential_zone_sector * 512))		\=0A=
> -	    "--size=3D$zone_size" --loops=3D$loops --randseed=3D"$r"		\=0A=
> +	    --offset=3D$off						\=0A=
> +	    --size=3D$zone_size --loops=3D$loops --randseed=3D"$r"		\=0A=
>  	    --zonemode=3Dzbd --zonesize=3D"${zone_size}" --group_reporting=3D1	=
\=0A=
>  	    --gtod_reduce=3D1 >> "${logfile}.${test_number}" 2>&1 || return $?=
=0A=
> -    check_written $((loops * zone_size)) || return $?=0A=
> +    check_written $((loops * capacity)) || return $?=0A=
>  }=0A=
>  =0A=
>  # Overwrite the first sequential zone four times sequentially.=0A=
> @@ -511,15 +536,16 @@ test28() {=0A=
>      off=3D$((first_sequential_zone_sector * 512 + 64 * zone_size))=0A=
>      [ -n "$is_zbd" ] && reset_zone "$dev" $((off / 512))=0A=
>      opts=3D("--debug=3Dzbd")=0A=
> +    capacity=3D$(total_zone_capacity 1 $off $dev)=0A=
>      for ((i=3D0;i<jobs;i++)); do=0A=
>  	opts+=3D("--name=3Djob$i" "--filename=3D$dev" "--offset=3D$off" "--bs=
=3D16K")=0A=
> -	opts+=3D("--size=3D$zone_size" "$(ioengine "psync")" "--rw=3Drandwrite"=
)=0A=
> +	opts+=3D("--size=3D$zone_size" "--io_size=3D$capacity" "$(ioengine "psy=
nc")" "--rw=3Drandwrite")=0A=
>  	opts+=3D("--thread=3D1" "--direct=3D1" "--zonemode=3Dzbd")=0A=
>  	opts+=3D("--zonesize=3D${zone_size}" "--group_reporting=3D1")=0A=
>  	opts+=3D(${var_opts[@]})=0A=
>      done=0A=
>      run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $=
?=0A=
> -    check_written $((jobs * zone_size)) || return $?=0A=
> +    check_written $((jobs * $capacity)) || return $?=0A=
>      check_reset_count -eq $jobs ||=0A=
>  	check_reset_count -eq $((jobs - 1)) ||=0A=
>  	return $?=0A=
> @@ -608,10 +634,13 @@ test32() {=0A=
>  # zone size.=0A=
>  test33() {=0A=
>      local bs io_size size=0A=
> +    local off capacity=3D0;=0A=
>  =0A=
> +    off=3D$((first_sequential_zone_sector * 512))=0A=
> +    capacity=3D$(total_zone_capacity 1 $off $dev)=0A=
>      size=3D$((2 * zone_size))=0A=
> -    io_size=3D$((5 * zone_size))=0A=
> -    bs=3D$((3 * zone_size / 4))=0A=
> +    io_size=3D$((5 * capacity))=0A=
> +    bs=3D$((3 * capacity / 4))=0A=
>      run_fio_on_seq "$(ioengine "psync")" --iodepth=3D1 --rw=3Dwrite	\=0A=
>  		   --size=3D$size --io_size=3D$io_size --bs=3D$bs	\=0A=
>  		   >> "${logfile}.${test_number}" 2>&1 || return $?=0A=
> @@ -660,8 +689,9 @@ test36() {=0A=
>  =0A=
>  # Test 3/4 for the I/O boundary rounding code: $size > $zone_size.=0A=
>  test37() {=0A=
> -    local bs off size=0A=
> +    local bs off size capacity=0A=
>  =0A=
> +    capacity=3D$(total_zone_capacity 1 $first_sequential_zone_sector $de=
v)=0A=
>      if [ "$first_sequential_zone_sector" =3D 0 ]; then=0A=
>  	off=3D0=0A=
>      else=0A=
> @@ -673,7 +703,7 @@ test37() {=0A=
>  		    --iodepth=3D1 --rw=3Dwrite --do_verify=3D1 --verify=3Dmd5	\=0A=
>  		    --bs=3D$bs --zonemode=3Dzbd --zonesize=3D"${zone_size}"	\=0A=
>  		    >> "${logfile}.${test_number}" 2>&1=0A=
> -    check_written $((zone_size)) || return $?=0A=
> +    check_written $capacity || return $?=0A=
>  }=0A=
>  =0A=
>  # Test 4/4 for the I/O boundary rounding code: $offset > $disk_size - $z=
one_size=0A=
> =0A=
=0A=
Apart from the above comment, this looks OK to me.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

