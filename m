Return-Path: <prvs=49599655b=shinichiro.kawasaki@wdc.com>
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH 5/6] t/zbd: Reset all zones before test when max open
 zones is specified
Date: Fri, 21 Aug 2020 06:06:51 +0000
Message-ID: <20200821060650.sy3y4ohxdvntbc2t@shindev.dhcp.fujisawa.hgst.com>
References: <20200813045724.47475-1-shinichiro.kawasaki@wdc.com>
 <20200813045724.47475-6-shinichiro.kawasaki@wdc.com>
 <5da58515b771e47ef64f146c2ca6adc4995b910f.camel@wdc.com>
In-Reply-To: <5da58515b771e47ef64f146c2ca6adc4995b910f.camel@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D9D5C856386BA24480E3C427C9761C61@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>, Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On Aug 15, 2020 / 00:07, Dmitry Fomichev wrote:
> On Thu, 2020-08-13 at 13:57 +0900, Shin'ichiro Kawasaki wrote:
> > When the test target device has maximum open zones limit, the zones in
> > test target region may not be opened up to the limit, because the zones
> > out of the test target region may have open zones. To ensure that the
> > test target zones can be opened up to the limit, reset all zones of the
> > test target device before the test cases with write work load starts.
> >=20
> > Introduce the helper function prep_write() to check if all zone reset i=
s
> > required and do the reset. For test cases which reset all zones
> > regardless of the maximum open zones option., the helper function takes
> > "reset_all" argument.
> >=20
> > Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
>=20
> The patch looks ok, but I wonder if some of the reset-all cases can be
> unnecessary if you reset excessive open zones in zbd_setup_files() as
> I suggested in the comment to the previous patch. Anyway,

That's right. With you suggestion on zbd_setup_files(), I confirmed that
reset-all is no longer required. Will remove in the v2. Thank you.

>=20
> Reviewed-by: Dmitry Fomichev: <dmitry.fomichev@wdc.com>
>=20
> > ---
> >  t/zbd/test-zbd-support | 44 +++++++++++++++++++++++++++++++++++++++---
> >  1 file changed, 41 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
> > index c21d6aad..9ec406c3 100755
> > --- a/t/zbd/test-zbd-support
> > +++ b/t/zbd/test-zbd-support
> > @@ -181,6 +181,16 @@ run_fio_on_seq() {
> >      run_one_fio_job "${opts[@]}" "$@"
> >  }
> > =20
> > +# Prepare for write test by resetting zones. When "reset_all" is speci=
fied,
> > +# reset all sequential write required zones. When max_open_zones optio=
n is
> > +# specified, reset all zones of the test target to ensure that zones o=
ut of the
> > +# test target range do not have open zones. This allows the write test=
 to the
> > +# target range to be able to open zones up to max_open_zones.
> > +prep_write() {
> > +	[[ ${1} =3D=3D "reset_all" || -n "${max_open_zones_opt}" ]] &&
> > +		[[ -n "${is_zbd}" ]] && reset_zone "${dev}" -1
> > +}
> > +
> >  # Check whether buffered writes are refused.
> >  test1() {
> >      run_fio --name=3Djob1 --filename=3D"$dev" --rw=3Dwrite --direct=3D=
0 --bs=3D4K	\
> > @@ -252,6 +262,7 @@ test4() {
> >  test5() {
> >      local size off capacity
> > =20
> > +    prep_write
> >      off=3D$((first_sequential_zone_sector * 512))
> >      capacity=3D$(total_zone_capacity 4 $off $dev)
> >      size=3D$((4 * zone_size))
> > @@ -267,6 +278,7 @@ test5() {
> >  test6() {
> >      local size off capacity
> > =20
> > +    prep_write
> >      off=3D$((first_sequential_zone_sector * 512))
> >      capacity=3D$(total_zone_capacity 4 $off $dev)
> >      size=3D$((4 * zone_size))
> > @@ -285,6 +297,7 @@ test7() {
> >      local size=3D$((zone_size))
> >      local off capacity
> > =20
> > +    prep_write
> >      off=3D$((first_sequential_zone_sector * 512))
> >      capacity=3D$(total_zone_capacity 1 $off $dev)
> >      run_fio_on_seq "$(ioengine "libaio")" --iodepth=3D1 --rw=3Drandwri=
te	\
> > @@ -299,6 +312,7 @@ test7() {
> >  test8() {
> >      local size off capacity
> > =20
> > +    prep_write
> >      size=3D$((4 * zone_size))
> >      off=3D$((first_sequential_zone_sector * 512))
> >      capacity=3D$(total_zone_capacity 4 $off $dev)
> > @@ -319,6 +333,7 @@ test9() {
> >  	return 0
> >      fi
> > =20
> > +    prep_write
> >      size=3D$((4 * zone_size))
> >      run_fio_on_seq --ioengine=3Dsg					\
> >  		   --iodepth=3D1 --rw=3Drandwrite --bs=3D16K			\
> > @@ -337,6 +352,7 @@ test10() {
> >  	return 0
> >      fi
> > =20
> > +    prep_write
> >      size=3D$((4 * zone_size))
> >      run_fio_on_seq --ioengine=3Dsg 					\
> >  		   --iodepth=3D64 --rw=3Drandwrite --bs=3D16K			\
> > @@ -350,6 +366,7 @@ test10() {
> >  test11() {
> >      local size off capacity
> > =20
> > +    prep_write
> >      size=3D$((4 * zone_size))
> >      off=3D$((first_sequential_zone_sector * 512))
> >      capacity=3D$(total_zone_capacity 4 $off $dev)
> > @@ -364,6 +381,7 @@ test11() {
> >  test12() {
> >      local size off capacity
> > =20
> > +    prep_write
> >      size=3D$((8 * zone_size))
> >      off=3D$((first_sequential_zone_sector * 512))
> >      capacity=3D$(total_zone_capacity 8 $off $dev)
> > @@ -378,6 +396,7 @@ test12() {
> >  test13() {
> >      local size off capacity
> > =20
> > +    prep_write
> >      size=3D$((8 * zone_size))
> >      off=3D$((first_sequential_zone_sector * 512))
> >      capacity=3D$(total_zone_capacity 8 $off $dev)
> > @@ -393,6 +412,7 @@ test13() {
> >  test14() {
> >      local size
> > =20
> > +    prep_write
> >      size=3D$((16 * 2**20)) # 20 MB
> >      if [ $size -gt $((first_sequential_zone_sector * 512)) ]; then
> >  	echo "$dev does not have enough sequential zones" \
> > @@ -417,6 +437,7 @@ test15() {
> >  	    reset_zone "$dev" $((first_sequential_zone_sector +
> >  				 i*sectors_per_zone))
> >      done
> > +    prep_write
> >      w_off=3D$(((first_sequential_zone_sector + 2 * sectors_per_zone) *=
 512))
> >      w_size=3D$((2 * zone_size))
> >      w_capacity=3D$(total_zone_capacity 2 $w_off $dev)
> > @@ -441,6 +462,7 @@ test16() {
> >  	    reset_zone "$dev" $((first_sequential_zone_sector +
> >  				 i*sectors_per_zone))
> >      done
> > +    prep_write
> >      w_off=3D$(((first_sequential_zone_sector + 2 * sectors_per_zone) *=
 512))
> >      w_size=3D$((2 * zone_size))
> >      w_capacity=3D$(total_zone_capacity 2 $w_off $dev)
> > @@ -463,6 +485,7 @@ test17() {
> >      if [ -n "$is_zbd" ]; then
> >  	reset_zone "$dev" $((off / 512)) || return $?
> >      fi
> > +    prep_write
> >      run_one_fio_job "$(ioengine "libaio")" --iodepth=3D8 --rw=3Drandrw=
 --bs=3D4K \
> >  		    --zonemode=3Dzbd --zonesize=3D"${zone_size}"		\
> >  		    --offset=3D$off --loops=3D2 --norandommap=3D1\
> > @@ -516,6 +539,7 @@ test24() {
> >      local bs loops=3D9 size=3D$((zone_size))
> >      local off capacity
> > =20
> > +    prep_write
> >      off=3D$((first_sequential_zone_sector * 512))
> >      capacity=3D$(total_zone_capacity 1 $off $dev)
> > =20
> > @@ -538,6 +562,7 @@ test25() {
> >          [ -n "$is_zbd" ] &&
> >  	    reset_zone "$dev" $((first_sequential_zone_sector + i*sectors_per=
_zone))
> >      done
> > +    prep_write
> >      for ((i=3D0;i<16;i++)); do
> >  	opts+=3D("--name=3Djob$i" "--filename=3D$dev" "--thread=3D1" "--direc=
t=3D1")
> >  	opts+=3D("--offset=3D$((first_sequential_zone_sector*512 + zone_size*=
i))")
> > @@ -552,6 +577,7 @@ write_to_first_seq_zone() {
> >      local loops=3D4 r
> >      local off capacity
> > =20
> > +    prep_write
> >      off=3D$((first_sequential_zone_sector * 512))
> >      capacity=3D$(total_zone_capacity 1 $off $dev)
> > =20
> > @@ -580,7 +606,7 @@ test28() {
> >      local i jobs=3D16 off opts
> > =20
> >      off=3D$((first_sequential_zone_sector * 512 + 64 * zone_size))
> > -    [ -n "$is_zbd" ] && reset_zone "$dev" $((off / 512))
> > +    prep_write reset_all
> >      opts=3D("--debug=3Dzbd")
> >      capacity=3D$(total_zone_capacity 1 $off $dev)
> >      for ((i=3D0;i<jobs;i++)); do
> > @@ -604,7 +630,7 @@ test29() {
> > =20
> >      off=3D$((first_sequential_zone_sector * 512 + 64 * zone_size))
> >      size=3D$((16*zone_size))
> > -    [ -n "$is_zbd" ] && reset_zone "$dev" $((off / 512))
> > +    prep_write reset_all
> >      opts=3D("--debug=3Dzbd")
> >      for ((i=3D0;i<jobs;i++)); do
> >  	opts+=3D("--name=3Djob$i" "--filename=3D$dev" "--offset=3D$off" "--bs=
=3D16K")
> > @@ -623,6 +649,7 @@ test29() {
> >  test30() {
> >      local off
> > =20
> > +    prep_write
> >      off=3D$((first_sequential_zone_sector * 512))
> >      run_one_fio_job "$(ioengine "libaio")" --iodepth=3D8 --rw=3Drandrw=
	\
> >  		    --bs=3D"$(max $((zone_size / 128)) "$logical_block_size")"\
> > @@ -636,6 +663,7 @@ test30() {
> >  test31() {
> >      local bs inc nz off opts size
> > =20
> > +    prep_write
> >      # Start with writing 128 KB to 128 sequential zones.
> >      bs=3D128K
> >      nz=3D128
> > @@ -668,6 +696,7 @@ test31() {
> >  test32() {
> >      local off opts=3D() size
> > =20
> > +    prep_write
> >      off=3D$((first_sequential_zone_sector * 512))
> >      size=3D$((disk_size - off))
> >      opts+=3D("--name=3D$dev" "--filename=3D$dev" "--offset=3D$off" "--=
size=3D$size")
> > @@ -684,6 +713,7 @@ test33() {
> >      local bs io_size size
> >      local off capacity=3D0;
> > =20
> > +    prep_write
> >      off=3D$((first_sequential_zone_sector * 512))
> >      capacity=3D$(total_zone_capacity 1 $off $dev)
> >      size=3D$((2 * zone_size))
> > @@ -700,6 +730,7 @@ test33() {
> >  test34() {
> >      local size
> > =20
> > +    prep_write
> >      size=3D$((2 * zone_size))
> >      run_fio_on_seq "$(ioengine "psync")" --iodepth=3D1 --rw=3Dwrite --=
size=3D$size \
> >  		   --do_verify=3D1 --verify=3Dmd5 --bs=3D$((3 * zone_size / 4)) \
> > @@ -711,6 +742,7 @@ test34() {
> >  test35() {
> >      local bs off io_size size
> > =20
> > +    prep_write
> >      off=3D$(((first_sequential_zone_sector + 1) * 512))
> >      size=3D$((zone_size - 2 * 512))
> >      bs=3D$((zone_size / 4))
> > @@ -725,6 +757,7 @@ test35() {
> >  test36() {
> >      local bs off io_size size
> > =20
> > +    prep_write
> >      off=3D$(((first_sequential_zone_sector) * 512))
> >      size=3D$((zone_size - 512))
> >      bs=3D$((zone_size / 4))
> > @@ -739,6 +772,7 @@ test36() {
> >  test37() {
> >      local bs off size capacity
> > =20
> > +    prep_write
> >      capacity=3D$(total_zone_capacity 1 $first_sequential_zone_sector $=
dev)
> >      if [ "$first_sequential_zone_sector" =3D 0 ]; then
> >  	off=3D0
> > @@ -758,6 +792,7 @@ test37() {
> >  test38() {
> >      local bs off size
> > =20
> > +    prep_write
> >      size=3D$((logical_block_size))
> >      off=3D$((disk_size - logical_block_size))
> >      bs=3D$((logical_block_size))
> > @@ -828,6 +863,7 @@ test45() {
> >      local bs i
> > =20
> >      [ -z "$is_zbd" ] && return 0
> > +    prep_write
> >      bs=3D$((logical_block_size))
> >      run_one_fio_job "$(ioengine "psync")" --iodepth=3D1 --rw=3Drandwri=
te --bs=3D$bs\
> >  		    --offset=3D$((first_sequential_zone_sector * 512)) \
> > @@ -840,6 +876,7 @@ test45() {
> >  test46() {
> >      local size
> > =20
> > +    prep_write
> >      size=3D$((4 * zone_size))
> >      run_fio_on_seq "$(ioengine "libaio")" --iodepth=3D64 --rw=3Drandwr=
ite --bs=3D4K \
> >  		   --group_reporting=3D1 --numjobs=3D8 \
> > @@ -851,6 +888,7 @@ test46() {
> >  test47() {
> >      local bs
> > =20
> > +    prep_write
> >      bs=3D$((logical_block_size))
> >      run_fio_on_seq "$(ioengine "psync")" --rw=3Dwrite --bs=3D$bs --zon=
eskip=3D1 \
> >  		    >> "${logfile}.${test_number}" 2>&1 && return 1
> > @@ -865,7 +903,7 @@ test48() {
> > =20
> >      off=3D$((first_sequential_zone_sector * 512 + 64 * zone_size))
> >      size=3D$((16*zone_size))
> > -    [ -n "$is_zbd" ] && reset_zone "$dev" $((off / 512))
> > +    prep_write reset_all
> >      opts=3D("--aux-path=3D/tmp" "--allow_file_create=3D0" "--significa=
nt_figures=3D10")
> >      opts+=3D("--debug=3Dzbd")
> >      opts+=3D("$(ioengine "libaio")" "--rw=3Drandwrite" "--direct=3D1")

--=20
Best Regards,
Shin'ichiro Kawasaki=

