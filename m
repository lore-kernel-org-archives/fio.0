Return-Path: <prvs=649de9d05=shinichiro.kawasaki@wdc.com>
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH v3 24/38] t/zbd: add run-tests-against-nullb script
Date: Fri, 22 Jan 2021 08:47:21 +0000
Message-ID: <20210122084719.cjkch2yqckmywntq@shindev.dhcp.fujisawa.hgst.com>
References: <20210106215739.264524-1-dmitry.fomichev@wdc.com>
 <20210106215739.264524-25-dmitry.fomichev@wdc.com>
In-Reply-To: <20210106215739.264524-25-dmitry.fomichev@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <080933D4CD4F9146AA8F6095CC204C2F@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Aravind Ramesh <Aravind.Ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <Naohiro.Aota@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>, Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On Jan 07, 2021 / 06:57, Dmitry Fomichev wrote:
> This script combines the t/zbd/run-tests-against-zoned-nullb script
> functionality with t/zbd/run-tests-against-regular-nullb and adds
> more zoned device configurations to test. This considerably improves
> ZBD test coverage.
>=20
> The added script makes the two old scripts named above obsolete,
> remove them. Modify t/run-fio-tests.py and Makefile to refer to the
> new script instead of the old one. Since the full test now runs
> significantly longer than the two old ones combined due to many more
> zoned configurations, only execute a few individual sections as a
> part of testing n "make fulltest" and run-fio-tests.py. One extra test
> section with 10% conventional zones is executed from the Makefile.
> The Python tests only exercise all-conventional and all-sequential
> configurations, exactly as before.
>=20
> The script returns a non-zero return code if at least one of the
> executed sections had a failed test.
>=20
> Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
> ---
>  Makefile                              |   5 +-
>  t/run-fio-tests.py                    |   8 +-
>  t/zbd/run-tests-against-nullb         | 338 ++++++++++++++++++++++++++
>  t/zbd/run-tests-against-regular-nullb |  27 --
>  t/zbd/run-tests-against-zoned-nullb   |  53 ----
>  5 files changed, 345 insertions(+), 86 deletions(-)
>  create mode 100755 t/zbd/run-tests-against-nullb
>  delete mode 100755 t/zbd/run-tests-against-regular-nullb
>  delete mode 100755 t/zbd/run-tests-against-zoned-nullb
>=20
> diff --git a/Makefile b/Makefile
> index a838af9a..19bfb996 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -600,9 +600,10 @@ fulltest:
>  	   make -j &&						 	\
>  	   sudo make install)						\
>  	fi &&					 			\
> -	sudo t/zbd/run-tests-against-regular-nullb &&		 	\
> +	sudo t/zbd/run-tests-against-nullb -s 1 &&		 	\
>  	if [ -e /sys/module/null_blk/parameters/zoned ]; then		\
> -		sudo t/zbd/run-tests-against-zoned-nullb;	 	\
> +		sudo t/zbd/run-tests-against-nullb -s 2;	 	\
> +		sudo t/zbd/run-tests-against-nullb -s 4;	 	\
>  	fi
> =20
>  install: $(PROGS) $(SCRIPTS) $(ENGS_OBJS) tools/plot/fio2gnuplot.1 FORCE
> diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
> index e5c2f17c..a59cdfe0 100755
> --- a/t/run-fio-tests.py
> +++ b/t/run-fio-tests.py
> @@ -879,8 +879,8 @@ TEST_LIST =3D [
>      {
>          'test_id':          1007,
>          'test_class':       FioExeTest,
> -        'exe':              't/zbd/run-tests-against-regular-nullb',
> -        'parameters':       None,
> +        'exe':              't/zbd/run-tests-against-nullb',
> +        'parameters':       ['-s', '1'],
>          'success':          SUCCESS_DEFAULT,
>          'requirements':     [Requirements.linux, Requirements.zbd,
>                               Requirements.root],
> @@ -888,8 +888,8 @@ TEST_LIST =3D [
>      {
>          'test_id':          1008,
>          'test_class':       FioExeTest,
> -        'exe':              't/zbd/run-tests-against-zoned-nullb',
> -        'parameters':       None,
> +        'exe':              't/zbd/run-tests-against-nullb',
> +        'parameters':       ['-s', '2'],
>          'success':          SUCCESS_DEFAULT,
>          'requirements':     [Requirements.linux, Requirements.zbd,
>                               Requirements.root, Requirements.zoned_nullb=
],
> diff --git a/t/zbd/run-tests-against-nullb b/t/zbd/run-tests-against-null=
b
> new file mode 100755
> index 00000000..8d1eb005
> --- /dev/null
> +++ b/t/zbd/run-tests-against-nullb
> @@ -0,0 +1,338 @@
> +#!/bin/bash
> +#
> +# Copyright (C) 2020 Western Digital Corporation or its affiliates.
> +#
> +# This file is released under the GPL.
> +#
> +# Run t/zbd/test-zbd-support script against a variety of conventional,
> +# zoned and mixed zone configurations.
> +#
> +
> +function usage()

I would think bash function form "XXX()" is rather newer and better than
"function XXX()", for POSIX conformance and commonality with other scripts
in fio bash scripts.

> +{
> +	echo "This script runs the tests from t/zbd/test-zbd-support script"
> +        echo "against a nullb device in a variety of conventional and zo=
ned"

A nit, spaces are used in place of a tab.

> +	echo "configurations."
> +	echo "Usage: ${0} [OPTIONS]"
> +	echo "Options:"
> +	echo -e "\t-h Show this message."
> +	echo -e "\t-L List the device layouts for every section without running=
"
> +	echo -e "\t   tests."
> +	echo -e "\t-s <#section> Only run the section with the given number."
> +	echo -e "\t-l Use libzbc ioengine to run the tests."
> +	echo -e "\t-o <max_open_zones> Specify MaxOpen value, (${set_max_open} =
by default)."
> +	echo -e "\t-n <#number of runs> Set the number of times to run the enti=
re suite "
> +	echo -e "\t   or an individual section/test."
> +	echo -e "\t-r Remove the /dev/nullb0 device that may still exist after"
> +	echo -e "\t   running this script."
> +	exit 1
> +}
> +
> +function cleanup_nullb()
> +{
> +	for d in /sys/kernel/config/nullb/*; do [ -d "$d" ] && rmdir "$d"; done
> +	modprobe -r null_blk
> +	modprobe null_blk nr_devices=3D0 || exit $?
> +	for d in /sys/kernel/config/nullb/*; do
> +		[ -d "$d" ] && rmdir "$d"
> +	done
> +	modprobe -r null_blk
> +	[ -e /sys/module/null_blk ] && exit $?
> +}
> +
> +function create_nullb()
> +{
> +	modprobe null_blk nr_devices=3D0 &&
> +	cd /sys/kernel/config/nullb &&
> +	mkdir nullb0 &&
> +	cd nullb0 || return $?
> +}
> +
> +function configure_nullb()
> +{
> +	echo 0 > completion_nsec &&
> +		echo ${dev_blocksize} > blocksize &&
> +		echo ${dev_size} > size &&
> +		echo 1 > memory_backed || return $?
> +
> +	if ((conv_pcnt < 100)); then
> +		echo 1 > zoned &&
> +			echo "${zone_size}" > zone_size || return $?
> +
> +		if ((zone_capacity < zone_size)); then
> +			if ((!zcap_supported)); then
> +				echo "null_blk does not support zone capacity"
> +				return 2
> +			fi
> +			echo "${zone_capacity}" > zone_capacity
> +		fi
> +		if ((conv_pcnt)); then
> +			if ((!conv_supported)); then
> +				echo "null_blk does not support conventional zones"
> +				return 2
> +			fi
> +			nr_conv=3D$((dev_size/zone_size*conv_pcnt/100))
> +			echo "${nr_conv}" > zone_nr_conv
> +		fi
> +	fi
> +
> +	echo 1 > power || return $?
> +	return 0
> +}
> +
> +function show_nullb_config()
> +{
> +	if ((conv_pcnt < 100)); then
> +		echo "    $(printf "Zoned Device, %d%% Conventional Zones (%d)" \
> +			  ${conv_pcnt} ${nr_conv})"
> +		echo "    $(printf "Zone Size: %d MB" ${zone_size})"
> +		echo "    $(printf "Zone Capacity: %d MB" ${zone_capacity})"
> +		if ((max_open)); then
> +			echo "    $(printf "Max Open: %d Zones" ${max_open})"
> +		else
> +			echo "    Max Open: Unlimited Zones"
> +		fi
> +	else
> +		echo "    Non-zoned Device"
> +	fi
> +}
> +
> +#
> +# Test sections.
> +#
> +# Fully conventional device.
> +function section1

It is not mandatory, but I would like to see parentheses () for the
sectionX function definitions.

> +{
> +	conv_pcnt=3D100
> +	max_open=3D0
> +}
> +
> +# Zoned device with no conventional zones, ZCAP =3D=3D ZSIZE, unlimited =
MaxOpen.
> +function section2
> +{
> +	conv_pcnt=3D0
> +	zone_size=3D1
> +	zone_capacity=3D1
> +	max_open=3D0
> +}
> +
> +# Zoned device with no conventional zones, ZCAP < ZSIZE, unlimited MaxOp=
en.
> +function section3
> +{
> +	conv_pcnt=3D0
> +	zone_size=3D4
> +	zone_capacity=3D3
> +	max_open=3D0
> +}
> +
> +# Zoned device with mostly sequential zones, ZCAP =3D=3D ZSIZE, unlimite=
d MaxOpen.
> +function section4
> +{
> +	conv_pcnt=3D10
> +	zone_size=3D1
> +	zone_capacity=3D1
> +	max_open=3D0
> +}
> +
> +# Zoned device with mostly sequential zones, ZCAP < ZSIZE, unlimited Max=
Open.
> +function section5
> +{
> +	conv_pcnt=3D10
> +	zone_size=3D4
> +	zone_capacity=3D3
> +	max_open=3D0
> +}
> +
> +# Zoned device with mostly conventional zones, ZCAP =3D=3D ZSIZE, unlimi=
ted MaxOpen.
> +function section6
> +{
> +	conv_pcnt=3D66
> +	zone_size=3D1
> +	zone_capacity=3D1
> +	max_open=3D0
> +}
> +
> +# Zoned device with mostly conventional zones, ZCAP < ZSIZE, unlimited M=
axOpen.
> +function section7
> +{
> +	dev_size=3D2048
> +	conv_pcnt=3D66
> +	zone_size=3D4
> +	zone_capacity=3D3
> +	max_open=3D0
> +}
> +
> +# Zoned device with no conventional zones, ZCAP =3D=3D ZSIZE, limited Ma=
xOpen.
> +function section8
> +{
> +	dev_size=3D1024
> +	conv_pcnt=3D0
> +	zone_size=3D1
> +	zone_capacity=3D1
> +	max_open=3D${set_max_open}
> +	zbd_test_opts+=3D("-o ${max_open}")
> +}
> +
> +# Zoned device with no conventional zones, ZCAP < ZSIZE, limited MaxOpen=
.
> +function section8

I think you meant section9, not 8.

Other than this, this patch looks good to me.

--=20
Best Regards,
Shin'ichiro Kawasaki=

