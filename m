Return-Path: <prvs=407291984=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 3/4] t/zbd: beautify test script output
Date: Mon, 25 May 2020 23:23:17 +0000
Message-ID: 
 <CY4PR04MB3751F5D9E452FCA8830A866BE7B30@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200525213256.7476-1-dmitry.fomichev@wdc.com>
 <20200525213256.7476-4-dmitry.fomichev@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2020/05/26 6:33, Dmitry Fomichev wrote:=0A=
> The test printout columns are better aligned now. Also, the test=0A=
> result, PASS/FAIL, is now color-coded and that makes it easier=0A=
> to spot failures.=0A=
> =0A=
> Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>=0A=
> ---=0A=
>  t/zbd/test-zbd-support | 16 ++++++++++++++--=0A=
>  1 file changed, 14 insertions(+), 2 deletions(-)=0A=
> =0A=
> diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support=0A=
> index de05f438..51b05dfd 100755=0A=
> --- a/t/zbd/test-zbd-support=0A=
> +++ b/t/zbd/test-zbd-support=0A=
> @@ -929,19 +929,31 @@ logfile=3D$0.log=0A=
>  =0A=
>  passed=3D0=0A=
>  failed=3D0=0A=
> +if [ -t 1 ]; then=0A=
> +    red=3D"\e[1;31m"=0A=
> +    green=3D"\e[1;32m"=0A=
> +    end=3D"\e[m"=0A=
> +else=0A=
> +    red=3D""=0A=
> +    green=3D""=0A=
> +    end=3D""=0A=
> +fi=0A=
>  rc=3D0=0A=
> +=0A=
>  for test_number in "${tests[@]}"; do=0A=
>      rm -f "${logfile}.${test_number}"=0A=
> -    echo -n "Running test $test_number ... "=0A=
> +    echo -n "Running test $(printf "%02d" $test_number) ... "=0A=
>      if eval "test$test_number"; then=0A=
>  	status=3D"PASS"=0A=
> +	cc_status=3D"${green}${status}${end}"=0A=
>  	((passed++))=0A=
>      else=0A=
>  	status=3D"FAIL"=0A=
> +	cc_status=3D"${red}${status}${end}"=0A=
>  	((failed++))=0A=
>  	rc=3D1=0A=
>      fi=0A=
> -    echo "$status"=0A=
> +    echo -e "$cc_status"=0A=
>      echo "$status" >> "${logfile}.${test_number}"=0A=
>  done=0A=
>  =0A=
> =0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

