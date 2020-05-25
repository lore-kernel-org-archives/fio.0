Return-Path: <prvs=407291984=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 4/4] t/zbd: make the test script easier to terminate
Date: Mon, 25 May 2020 23:24:13 +0000
Message-ID: 
 <CY4PR04MB3751D0F49FCC35754A1C20D2E7B30@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200525213256.7476-1-dmitry.fomichev@wdc.com>
 <20200525213256.7476-5-dmitry.fomichev@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2020/05/26 6:33, Dmitry Fomichev wrote:=0A=
> Very often, it takes more than one ^C to terminate test-zbd-support=0A=
> script. Just a single ^C does end the test that is currently being=0A=
> executed, but then the script proceeds to the next test. This commit=0A=
> adds a simple signal handler to exit the test loop after receiving=0A=
> a Ctrl-C.=0A=
> =0A=
> Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>=0A=
> ---=0A=
>  t/zbd/test-zbd-support | 4 ++++=0A=
>  1 file changed, 4 insertions(+)=0A=
> =0A=
> diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support=0A=
> index 51b05dfd..4001be3b 100755=0A=
> --- a/t/zbd/test-zbd-support=0A=
> +++ b/t/zbd/test-zbd-support=0A=
> @@ -940,6 +940,9 @@ else=0A=
>  fi=0A=
>  rc=3D0=0A=
>  =0A=
> +intr=3D0=0A=
> +trap 'intr=3D1' SIGINT=0A=
> +=0A=
>  for test_number in "${tests[@]}"; do=0A=
>      rm -f "${logfile}.${test_number}"=0A=
>      echo -n "Running test $(printf "%02d" $test_number) ... "=0A=
> @@ -955,6 +958,7 @@ for test_number in "${tests[@]}"; do=0A=
>      fi=0A=
>      echo -e "$cc_status"=0A=
>      echo "$status" >> "${logfile}.${test_number}"=0A=
> +    [ $intr -ne 0 ] && exit 1=0A=
>  done=0A=
>  =0A=
>  echo "$passed tests passed"=0A=
> =0A=
=0A=
Looks good to me.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

