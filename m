Return-Path: <prvs=4705a5bd9=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 3/3] t/zbd: check log file for failed assertions
Date: Mon, 27 Jul 2020 05:07:56 +0000
Message-ID: 
 <CY4PR04MB37510877B1580A92BE67C43BE7720@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200727031638.28264-1-dmitry.fomichev@wdc.com>
 <20200727031638.28264-4-dmitry.fomichev@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

On 2020/07/27 12:16, Dmitry Fomichev wrote:=0A=
> Currently, a ZBD test can succeed even if an fio assertion is raised=0A=
> during its run. Search every ZBD test log file for failed assertions=0A=
> and fail the test if any were found.=0A=
> =0A=
> Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>=0A=
> ---=0A=
>  t/zbd/test-zbd-support | 9 ++++++++-=0A=
>  1 file changed, 8 insertions(+), 1 deletion(-)=0A=
> =0A=
> diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support=0A=
> index 471a3487..139495d3 100755=0A=
> --- a/t/zbd/test-zbd-support=0A=
> +++ b/t/zbd/test-zbd-support=0A=
> @@ -77,6 +77,13 @@ check_reset_count() {=0A=
>      eval "[ '$reset_count' '$1' '$2' ]"=0A=
>  }=0A=
>  =0A=
> +# Check log for failed assertions and crashes. Without these checks,=0A=
> +# a test can succeed even when these events happen, but it must fail.=0A=
> +check_log() {=0A=
> +     [ ! -f "${logfile}.${1}" ] && return 0=0A=
> +     ! grep -q -e "Assertion " -e "Aborted " "${logfile}.${1}"=0A=
> +}=0A=
> +=0A=
>  # Whether or not $1 (/dev/...) is a SCSI device.=0A=
>  is_scsi_device() {=0A=
>      local d f=0A=
> @@ -1008,7 +1015,7 @@ trap 'intr=3D1' SIGINT=0A=
>  for test_number in "${tests[@]}"; do=0A=
>      rm -f "${logfile}.${test_number}"=0A=
>      echo -n "Running test $(printf "%02d" $test_number) ... "=0A=
> -    if eval "test$test_number"; then=0A=
> +    if eval "test$test_number" && check_log $test_number; then=0A=
>  	status=3D"PASS"=0A=
>  	cc_status=3D"${green}${status}${end}"=0A=
>  	((passed++))=0A=
> =0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

