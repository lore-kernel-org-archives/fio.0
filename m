Return-Path: <prvs=46505346c=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH] t/zbd: Improve pass condition of test case #49
Date: Wed, 22 Jul 2020 09:38:31 +0000
Message-ID: 
 <CY4PR04MB37516E34B9611326EA07F6F0E7790@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200722092633.350291-1-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: Hans Holmberg <Hans.Holmberg@wdc.com>
List-ID: <fio@vger.kernel.org>

On 2020/07/22 18:26, Shin'ichiro Kawasaki wrote:=0A=
> The test case #49 runs write workloads with verify option. It checks read=
=0A=
> bytes for verify, but it does not check written bytes. To make test pass=
=0A=
> condition more accurate, add check of the written bytes.=0A=
> =0A=
> Fixes: 4844bb4716ab ("t/zbd: Add test case to check zonecapacity option")=
=0A=
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>=0A=
> ---=0A=
>  t/zbd/test-zbd-support | 1 +=0A=
>  1 file changed, 1 insertion(+)=0A=
> =0A=
> diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support=0A=
> index e53a20c5..471a3487 100755=0A=
> --- a/t/zbd/test-zbd-support=0A=
> +++ b/t/zbd/test-zbd-support=0A=
> @@ -856,6 +856,7 @@ test49() {=0A=
>  		    --zonecapacity=3D${capacity} \=0A=
>  		    --verify=3Dmd5  --size=3D${size} >>"${logfile}.${test_number}" 2>&=
1 ||=0A=
>  	return $?=0A=
> +    check_written $((capacity * 2)) || return $?=0A=
>      check_read $((capacity * 2)) || return $?=0A=
>  }=0A=
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

