Return-Path: <prvs=712138935=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v3 2/2] t/zbd: test repeated async write with block size
 unaligned to zone size
Date: Fri, 26 Mar 2021 07:48:40 +0000
Message-ID: 
 <CH2PR04MB652217410341C87F98FC89E8E7619@CH2PR04MB6522.namprd04.prod.outlook.com>
References: <20210326045905.1541264-1-shinichiro.kawasaki@wdc.com>
 <20210326045905.1541264-3-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

On 2021/03/26 13:59, Shin'ichiro Kawasaki wrote:=0A=
> A recently fixed bug was caused by zone reset during asynchronous IOs=0A=
> in-flight. The bug symptom was unaligned command error which was=0A=
> observed using random write workload with libaio engine and block size=0A=
> not a divisor of zone size. To confirm the bug fix and to prevent future=
=0A=
> regression, add a test case which runs the workload.=0A=
> =0A=
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>=0A=
> ---=0A=
>  t/zbd/test-zbd-support | 18 ++++++++++++++++++=0A=
>  1 file changed, 18 insertions(+)=0A=
> =0A=
> diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support=0A=
> index be129615..26aff373 100755=0A=
> --- a/t/zbd/test-zbd-support=0A=
> +++ b/t/zbd/test-zbd-support=0A=
> @@ -1201,6 +1201,24 @@ test56() {=0A=
>  		>> "${logfile}.${test_number}" 2>&1 || return $?=0A=
>  }=0A=
>  =0A=
> +# Test that repeated async write job does not cause zone reset during wr=
ites=0A=
> +# in-flight, when the block size is not a divisor of the zone size.=0A=
> +test57() {=0A=
> +	local bs off=0A=
> +=0A=
> +	require_zbd || return $SKIP_TESTCASE=0A=
> +=0A=
> +	bs=3D$((4096 * 7))=0A=
> +	off=3D$((first_sequential_zone_sector * 512))=0A=
> +=0A=
> +	run_fio --name=3Djob --filename=3D"${dev}" --rw=3Drandwrite --bs=3D"${b=
s}" \=0A=
> +		--offset=3D"${off}" --size=3D$((4 * zone_size)) --iodepth=3D256 \=0A=
> +		"$(ioengine "libaio")" --time_based=3D1 --runtime=3D30s \=0A=
> +		--zonemode=3Dzbd --direct=3D1 --zonesize=3D"${zone_size}" \=0A=
> +		${job_var_opts[@]} \=0A=
> +		>> "${logfile}.${test_number}" 2>&1 || return $?=0A=
> +}=0A=
> +=0A=
>  SECONDS=3D0=0A=
>  tests=3D()=0A=
>  dynamic_analyzer=3D()=0A=
> =0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

