Return-Path: <prvs=4936ee857=shinichiro.kawasaki@wdc.com>
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH 4/6] t/zbd: Add -o option to t/zbd/test-zoned-support
Date: Wed, 19 Aug 2020 13:13:38 +0000
Message-ID: <20200819131336.yljxyzdxlb2fmfy6@shindev.dhcp.fujisawa.hgst.com>
References: <20200813045724.47475-1-shinichiro.kawasaki@wdc.com>
 <20200813045724.47475-5-shinichiro.kawasaki@wdc.com>
 <092a1a95867ef3598a4cbadb808bec9e527a8113.camel@wdc.com>
In-Reply-To: <092a1a95867ef3598a4cbadb808bec9e527a8113.camel@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2AC114DF20290845B128344A6D3D46E4@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>, Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On Aug 15, 2020 / 00:07, Dmitry Fomichev wrote:
> On Thu, 2020-08-13 at 13:57 +0900, Shin'ichiro Kawasaki wrote:
> > To specify maximum open zones of the test target device, add -o option
> > to t/zbd/test-zoned-support. When this option is specified, add
> > max_open_zones option to all fio commands in the test script. The optio=
n
> > ensures the number of zones opened by fio is within the limit. This is
> > useful when the test target device has maximum open zones limit.
> >=20
> > When the fio command does not have multiple jobs and the test case does
> > not specify max_open_zones, add single max_open_zones option to the fio
> > command line.
> >=20
> > When the fio command takes multiple jobs, add max_open_zones option to
> > each job. Introduce job_var_opts variable to keep options to be added t=
o
> > each job. To distinguish it from global options for all jobs, rename
> > var_opts variable to global_var_opts. When a test case with multiple jo=
bs
> > always specifies max_open_zones option, exclude the max_open_zones opti=
on
> > from job_var_opts, using job_var_opts_exclude() helper function.
> >=20
> > Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > ---
>  t/zbd/test-zbd-support | 70 ++++++++++++++++++++++++++++++++++--------
> >  1 file changed, 57 insertions(+), 13 deletions(-)
> >=20
> > diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
> > index 9e398cab..c21d6aad 100755
> > --- a/t/zbd/test-zbd-support
> > +++ b/t/zbd/test-zbd-support
> > @@ -12,6 +12,7 @@ usage() {
> >  	echo -e "\t-v Run fio with valgrind --read-var-info option"
> >  	echo -e "\t-l Test with libzbc ioengine"
> >  	echo -e "\t-r Reset all zones before test start"
> > +	echo -e "\t-o <max_open_zones> Run fio with max_open_zones limit"
> >  	echo -e "\t-t <test #> Run only a single test case with specified num=
ber"
> >  	echo -e "\t-z Run fio with debug=3Dzbd option"
> >  }
> > @@ -103,14 +104,41 @@ is_scsi_device() {
> >      return 1
> >  }
> > =20
> > +job_var_opts_exclude() {
> > +	local o
> > +	local ex_key=3D"${1}"
> > +
> > +	for o in "${job_var_opts[@]}"; do
> > +		if [[ ${o} =3D~ "${ex_key}" ]]; then
> > +			continue
> > +		fi
> > +		echo -n "${o}"
> > +	done
> > +}
> > +
> > +has_max_open_zones() {
> > +	while (($# > 1)); do
> > +		if [[ ${1} =3D~ "--max_open_zones" ]]; then
> > +			return 0
> > +		fi
> > +		shift
> > +	done
> > +	return 1
> > +}
> > +
> >  run_fio() {
> >      local fio opts
> > =20
> >      fio=3D$(dirname "$0")/../../fio
> > =20
> > -    opts=3D("--max-jobs=3D16" "--aux-path=3D/tmp" "--allow_file_create=
=3D0" \
> > -	  "--significant_figures=3D10" "$@")
> > -    opts+=3D(${var_opts[@]})
> > +    opts=3D(${global_var_opts[@]})
> > +    opts+=3D("--max-jobs=3D16" "--aux-path=3D/tmp" "--allow_file_creat=
e=3D0" \
> > +			   "--significant_figures=3D10" "$@")
> > +    # When max_open_zones option is specified to this test script, add
> > +    # max_open_zones option to fio command unless the test case alread=
y add it.
> > +    if [[ -n ${max_open_zones_opt} ]] && ! has_max_open_zones "${opts[=
@]}"; then
> > +	    opts+=3D("--max_open_zones=3D${max_open_zones_opt}")
> > +    fi
> >      { echo; echo "fio ${opts[*]}"; echo; } >>"${logfile}.${test_number=
}"
> > =20
> >      "${dynamic_analyzer[@]}" "$fio" "${opts[@]}"
> > @@ -128,13 +156,16 @@ write_and_run_one_fio_job() {
> >      local r
> >      local write_offset=3D"${1}"
> >      local write_size=3D"${2}"
> > +    local -a write_opts
> > =20
> >      shift 2
> >      r=3D$(((RANDOM << 16) | RANDOM))
> > -    run_fio --filename=3D"$dev" --randseed=3D"$r"  --name=3D"write_job=
" --rw=3Dwrite \
> > -	    "$(ioengine "psync")" --bs=3D"${logical_block_size}" \
> > -	    --zonemode=3Dzbd --zonesize=3D"${zone_size}" --thread=3D1 --direc=
t=3D1 \
> > -	    --offset=3D"${write_offset}" --size=3D"${write_size}" \
> > +    write_opts=3D(--name=3D"write_job" --rw=3Dwrite "$(ioengine "psync=
")" \
> > +		      --bs=3D"${logical_block_size}" --zonemode=3Dzbd \
> > +		      --zonesize=3D"${zone_size}" --thread=3D1 --direct=3D1 \
> > +		      --offset=3D"${write_offset}" --size=3D"${write_size}")
> > +    write_opts+=3D("${job_var_opts[@]}")
> > +    run_fio --filename=3D"$dev" --randseed=3D"$r" "${write_opts[@]}" \
> >  	    --name=3D"$dev" --wait_for=3D"write_job" "$@" --thread=3D1 --dire=
ct=3D1
> >  }
> > =20
> > @@ -512,7 +543,7 @@ test25() {
> >  	opts+=3D("--offset=3D$((first_sequential_zone_sector*512 + zone_size*=
i))")
> >  	opts+=3D("--size=3D$zone_size" "$(ioengine "psync")" "--rw=3Dwrite" "=
--bs=3D16K")
> >  	opts+=3D("--zonemode=3Dzbd" "--zonesize=3D${zone_size}" "--group_repo=
rting=3D1")
> > -	opts+=3D(${var_opts[@]})
> > +	opts+=3D(${job_var_opts[@]})
> >      done
> >      run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return=
 $?
> >  }
> > @@ -557,7 +588,7 @@ test28() {
> >  	opts+=3D("--size=3D$zone_size" "--io_size=3D$capacity" "$(ioengine "p=
sync")" "--rw=3Drandwrite")
> >  	opts+=3D("--thread=3D1" "--direct=3D1" "--zonemode=3Dzbd")
> >  	opts+=3D("--zonesize=3D${zone_size}" "--group_reporting=3D1")
> > -	opts+=3D(${var_opts[@]})
> > +	opts+=3D(${job_var_opts[@]})
> >      done
> >      run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return=
 $?
> >      check_written $((jobs * $capacity)) || return $?
> > @@ -581,7 +612,8 @@ test29() {
> >  	opts+=3D("$(ioengine "psync")" "--rw=3Drandwrite" "--direct=3D1")
> >  	opts+=3D("--max_open_zones=3D4" "--group_reporting=3D1")
> >  	opts+=3D("--zonemode=3Dzbd" "--zonesize=3D${zone_size}")
> > -	opts+=3D(${var_opts[@]})
> > +	# max_open_zones is already specified
> > +	opts+=3D($(job_var_opts_exclude "--max_open_zones"))
> >      done
> >      run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return=
 $?
> >      check_written $((jobs * zone_size)) || return $?
> > @@ -617,7 +649,7 @@ test31() {
> >  	opts+=3D("--bs=3D$bs" "--size=3D$zone_size" "$(ioengine "libaio")")
> >  	opts+=3D("--rw=3Dwrite" "--direct=3D1" "--thread=3D1" "--stats=3D0")
> >  	opts+=3D("--zonemode=3Dzbd" "--zonesize=3D${zone_size}")
> > -	opts+=3D(${var_opts[@]})
> > +	opts+=3D(${job_var_opts[@]})
> >      done
> >      "$(dirname "$0")/../../fio" "${opts[@]}" >> "${logfile}.${test_num=
ber}" 2>&1
> >      # Next, run the test.
> > @@ -627,6 +659,7 @@ test31() {
> >      opts+=3D("--bs=3D$bs" "$(ioengine "psync")" "--rw=3Drandread" "--d=
irect=3D1")
> >      opts+=3D("--thread=3D1" "--time_based" "--runtime=3D30" "--zonemod=
e=3Dzbd")
> >      opts+=3D("--zonesize=3D${zone_size}")
> > +    opts+=3D(${job_var_opts[@]})
> >      run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return=
 $?
> >  }
> > =20
> > @@ -843,6 +876,8 @@ test48() {
> >  	opts+=3D("--name=3Djob$i" "--filename=3D$dev" "--offset=3D$off" "--bs=
=3D16K")
> >  	opts+=3D("--io_size=3D$zone_size" "--iodepth=3D256" "--thread=3D1")
> >  	opts+=3D("--group_reporting=3D1")
> > +	# max_open_zones is already specified
> > +	opts+=3D($(job_var_opts_exclude "--max_open_zones"))
> >      done
> > =20
> >      fio=3D$(dirname "$0")/../../fio
> > @@ -880,6 +915,7 @@ dynamic_analyzer=3D()
> >  reset_all_zones=3D
> >  use_libzbc=3D
> >  zbd_debug=3D
> > +max_open_zones_opt=3D
> > =20
> >  while [ "${1#-}" !=3D "$1" ]; do
> >    case "$1" in
> > @@ -891,6 +927,7 @@ while [ "${1#-}" !=3D "$1" ]; do
> >      -l) use_libzbc=3D1; shift;;
> >      -r) reset_all_zones=3D1; shift;;
> >      -t) tests+=3D("$2"); shift; shift;;
> > +    -o) max_open_zones_opt=3D"${2}"; shift; shift;;
> >      -v) dynamic_analyzer=3D(valgrind "--read-var-info=3Dyes");
> >  	shift;;
> >      -z) zbd_debug=3D1; shift;;
> > @@ -906,9 +943,10 @@ fi
> >  # shellcheck source=3Dfunctions
> >  source "$(dirname "$0")/functions" || exit $?
> > =20
> > -var_opts=3D()
> > +global_var_opts=3D()
> > +job_var_opts=3D()
> >  if [ -n "$zbd_debug" ]; then
> > -    var_opts+=3D("--debug=3Dzbd")
> > +    global_var_opts+=3D("--debug=3Dzbd")
> >  fi
> >  dev=3D$1
> >  realdev=3D$(readlink -f "$dev")
> > @@ -994,6 +1032,12 @@ elif [[ -c "$realdev" ]]; then
> >  	fi
> >  fi
> > =20
> > +if [[ -n ${max_open_zones_opt} ]]; then
> > +	# Override max_open_zones with the script option value
> > +	max_open_zones=3D"${max_open_zones_opt}"
> > +	job_var_opts+=3D("--max_open_zones=3D${max_open_zones_opt}")
> > +fi
> > +
> >  echo -n "First sequential zone starts at sector $first_sequential_zone=
_sector;"
> >  echo " zone size: $((zone_size >> 20)) MB"
> > =20
>=20
> The script changes look good. The only nit is... I tried to run
>=20
> t/zbd/test-zbd-support with -o 512 <device>
>=20
> which is larger than 128 max open zones supported by the drive expecting
> the test to fail, but it didn't. It seems, the script defaults to the max=
imum
> number of open zones in this case, but it is not very obvious. Maybe log
> a message saying that the script has capped the value specified by the us=
er
> because it was too large?

Do you use SMR drives with limit 128 for testing? The SMR drives conformant=
 to
ZBC/ZAC spec implicitly close zones when the number of open zones exceeds t=
he
limit 128. So the script reports no failure, but actually fio opens zones b=
eyond
the limit.

ZNS devices which has "max active resources" limit do not close zones when
the number of zones exceeds that limit. The test script reports failures fo=
r
these devices and the -o option is useful to avoid the failures.

--=20
Best Regards,
Shin'ichiro Kawasaki=

