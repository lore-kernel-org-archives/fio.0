Return-Path: <prvs=625017359=shinichiro.kawasaki@wdc.com>
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH v2 33/36] t/zbd: add test #54 to exercise ZBD verification
Date: Tue, 29 Dec 2020 05:42:36 +0000
Message-ID: <20201229054235.t5cytdxhx3hpk3r3@shindev.dhcp.fujisawa.hgst.com>
References: <20201224021219.189727-1-dmitry.fomichev@wdc.com>
 <20201224021219.189727-34-dmitry.fomichev@wdc.com>
In-Reply-To: <20201224021219.189727-34-dmitry.fomichev@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CFCD110C4BF49347A982AF930037943D@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Aravind Ramesh <Aravind.Ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <Naohiro.Aota@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>, Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On Dec 24, 2020 / 11:12, Dmitry Fomichev wrote:
> Add a new test case to perform 75/25 read/write workload with varying
> i/o size and verification on. It is very important to use a good random
> generator for this test. Setting experimental_verify=3D1 is required for
> this test to operate correctly.
>=20
> Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
> ---
>  t/zbd/test-zbd-support | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>=20
> diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
> index 0b8015df..94c92e26 100755
> --- a/t/zbd/test-zbd-support
> +++ b/t/zbd/test-zbd-support
> @@ -1135,6 +1135,24 @@ test53() {
>  	return 1
>  }
> =20
> +# Test read/write mix with verify.
> +test54() {
> +	require_zbd || return $SKIP_TESTCASE
> +	require_seq_zones 8 || return $SKIP_TESTCASE
> +
> +	run_fio --name=3Djob --filename=3D${dev} --ioengine=3Dlibaio \

I think --ioengine=3Dlibaio should be $(ioengine "libaio"), or test-zbd-sup=
port
script run with -l option with sg node will fail.

--=20
Best Regards,
Shin'ichiro Kawasaki

> +		--time_based=3D1 --runtime=3D30s --continue_on_error=3D0 \
> +		--offset=3D$((first_sequential_zone_sector * 512)) \
> +		--size=3D$((8*zone_size)) --direct=3D1 --iodepth=3D1 \
> +		--rw=3Drandrw:2 --rwmixwrite=3D25 --bsrange=3D4k-${zone_size} \
> +		--zonemode=3Dzbd --zonesize=3D${zone_size} \
> +		--verify=3Dcrc32c --do_verify=3D1 --verify_backlog=3D2 \
> +		--experimental_verify=3D1 \
> +		--alloc-size=3D65536 --random_generator=3Dtausworthe64 \
> +		${job_var_opts[@]} --debug=3Dzbd \
> +		>> "${logfile}.${test_number}" 2>&1 || return $?
> +}
> +
>  tests=3D()
>  dynamic_analyzer=3D()
>  reset_all_zones=3D
> --=20
> 2.28.0
> =

