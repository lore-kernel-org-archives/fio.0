Return-Path: <prvs=4391c0654=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 4/4] t/zbd: Add support to verify Zone Append command with
 libaio, io_uring IO engine tests
Date: Fri, 26 Jun 2020 05:45:49 +0000
Message-ID: 
 <CY4PR04MB375109E8E368191896248011E7930@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <1593106733-19596-1-git-send-email-krish.reddy@samsung.com>
 <CGME20200625174133epcas5p1eace8f03319bee805b93c50fe6c690c7@epcas5p1.samsung.com>
 <1593106733-19596-5-git-send-email-krish.reddy@samsung.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Krishna Kanth Reddy <krish.reddy@samsung.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Ankit Kumar <ankit.kumar@samsung.com>
List-ID: <fio@vger.kernel.org>

On 2020/06/26 2:41, Krishna Kanth Reddy wrote:=0A=
> Modify the test-zbd-support script to verify the Zone Append command=0A=
> for NVMe Zoned Namespaces (ZNS) defined in NVM Express TP4053.=0A=
> Added a new FIO option zone_append.=0A=
> When zone_append option is enabled, the existing write path will=0A=
> send Zone Append command with LBA offset as start of the Zone.=0A=
> =0A=
> Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>=0A=
> ---=0A=
>  t/zbd/test-zbd-support | 48 ++++++++++++++++++++++++++++++++++++++++++++=
++++=0A=
>  1 file changed, 48 insertions(+)=0A=
> =0A=
> diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support=0A=
> index 4001be3..ddade22 100755=0A=
> --- a/t/zbd/test-zbd-support=0A=
> +++ b/t/zbd/test-zbd-support=0A=
> @@ -801,6 +801,54 @@ test48() {=0A=
>  	    >> "${logfile}.${test_number}" 2>&1 || return $?=0A=
>  }=0A=
>  =0A=
> +# Zone append to sequential zones, libaio, 1 job, queue depth 1=0A=
> +test49() {=0A=
> +    local i size=0A=
> +=0A=
> +    size=3D$((4 * zone_size))=0A=
> +    run_fio_on_seq --ioengine=3Dlibaio --iodepth=3D1 --rw=3Dwrite --zone=
_append=3D1 \=0A=
> +                   --bs=3D"$(max $((zone_size / 64)) "$logical_block_siz=
e")"\=0A=
> +                   --do_verify=3D1 --verify=3Dmd5                       =
    \=0A=
> +                   >>"${logfile}.${test_number}" 2>&1 || return $?=0A=
> +    check_written $size || return $?=0A=
> +    check_read $size || return $?=0A=
> +}=0A=
> +=0A=
> +# Random zone append to sequential zones, libaio, 8 jobs, queue depth 64=
 per job=0A=
> +test50() {=0A=
> +    local size=0A=
> +=0A=
> +    size=3D$((4 * zone_size))=0A=
> +    run_fio_on_seq --ioengine=3Dlibaio --iodepth=3D64 --rw=3Drandwrite -=
-bs=3D4K \=0A=
> +                   --group_reporting=3D1 --numjobs=3D8 --zone_append=3D1=
 \=0A=
> +                   >> "${logfile}.${test_number}" 2>&1 || return $?=0A=
> +    check_written $((size * 8)) || return $?=0A=
> +}=0A=
> +=0A=
> +# Zone append to sequential zones, io_uring, 1 job, queue depth 1=0A=
> +test51() {=0A=
> +    local i size=0A=
> +=0A=
> +    size=3D$((4 * zone_size))=0A=
> +    run_fio_on_seq --ioengine=3Dio_uring --iodepth=3D1 --rw=3Dwrite --zo=
ne_append=3D1 \=0A=
> +                   --bs=3D"$(max $((zone_size / 64)) "$logical_block_siz=
e")"\=0A=
> +                   --do_verify=3D1 --verify=3Dmd5                       =
    \=0A=
> +                   >>"${logfile}.${test_number}" 2>&1 || return $?=0A=
> +    check_written $size || return $?=0A=
> +    check_read $size || return $?=0A=
> +}=0A=
> +=0A=
> +# Random zone append to sequential zones, io_uring, 8 jobs, queue depth =
64 per job=0A=
> +test52() {=0A=
> +    local size=0A=
> +=0A=
> +    size=3D$((4 * zone_size))=0A=
> +    run_fio_on_seq --ioengine=3Dio_uring --iodepth=3D64 --rw=3Drandwrite=
 --bs=3D4K \=0A=
> +                   --group_reporting=3D1 --numjobs=3D8 --zone_append=3D1=
 \=0A=
> +                   >> "${logfile}.${test_number}" 2>&1 || return $?=0A=
> +    check_written $((size * 8)) || return $?=0A=
> +}=0A=
> +=0A=
>  tests=3D()=0A=
>  dynamic_analyzer=3D()=0A=
>  reset_all_zones=3D=0A=
> =0A=
=0A=
If the test script was called using an SG node with -l option for libzbc te=
sts,=0A=
these tests will fail. Please add conditions to not run them when they cann=
ot.=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

