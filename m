Return-Path: <prvs=460a6953b=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v2 3/6] t/zbd: Mandate blkzone capacity report for devices
 with zone capacity
Date: Fri, 17 Jul 2020 01:58:17 +0000
Message-ID: 
 <CY4PR04MB3751E745448FA7021018F7ECE77C0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200715064141.116415-1-shinichiro.kawasaki@wdc.com>
 <20200715064141.116415-4-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: Hans Holmberg <Hans.Holmberg@wdc.com>, Aravind Ramesh <Aravind.Ramesh@wdc.com>
List-ID: <fio@vger.kernel.org>

On 2020/07/15 15:41, Shin'ichiro Kawasaki wrote:=0A=
> For NVMe ZNS and null_blk zoned drives, the zone capacity can be smaller=
=0A=
> than the zone size. To test zone capacity handling by fio for these=0A=
> devices, need to know each zone's zone capacity. If the blkzone tool is=
=0A=
> old and does not report zone capacity, t/zbd/test-zbd-support script run=
=0A=
> will fail for the devices.=0A=
=0A=
For NVMe ZNS and null_blk zoned drives, a zone capacity can be smaller=0A=
than its size. To test zone capacity handling by fio for these=0A=
devices, t/zbd/test-zbd-support must be able to discover zone capacities to=
=0A=
avoid test failures.=0A=
=0A=
> =0A=
> To avoid the failures, make zone capacity report by blkzone mandatory if=
=0A=
> the test target device is a ZNS device or a null_blk device.=0A=
> =0A=
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>=0A=
> ---=0A=
>  t/zbd/functions        | 45 ++++++++++++++++++++++++++++++++++++++++++=
=0A=
>  t/zbd/test-zbd-support |  3 +++=0A=
>  2 files changed, 48 insertions(+)=0A=
> =0A=
> diff --git a/t/zbd/functions b/t/zbd/functions=0A=
> index 1bd22ec4..344836c8 100644=0A=
> --- a/t/zbd/functions=0A=
> +++ b/t/zbd/functions=0A=
> @@ -19,6 +19,51 @@ if [ -n "${use_libzbc}" ] &&=0A=
>      exit 1=0A=
>  fi=0A=
>  =0A=
> +blkzone_reports_capacity() {=0A=
> +	local dev=3D"${1}"=0A=
> +=0A=
> +	[[ -n "${blkzone}" ]] &&=0A=
> +		"${blkzone}" report -c 1 -o 0 "${dev}" | grep -q 'cap '=0A=
> +}=0A=
> +=0A=
> +# Whether or not $1 (/dev/...) is a NVME ZNS device.=0A=
> +is_nvme_zns() {=0A=
> +	local s=0A=
> +=0A=
> +	s=3D/sys/block/$(basename "${1}")/device/subsystem=0A=
> +=0A=
> +	if [[ ! -h "${s}" || $(realpath "${s}") !=3D /sys/class/nvme ]]; then=
=0A=
> +		return 1=0A=
> +	fi=0A=
> +=0A=
> +	[[ $(</sys/block/$(basename "${1}")/queue/zoned) =3D=3D host-managed ]]=
=0A=
> +}=0A=
> +=0A=
> +# Whether or not $1 (/dev/...) is a null_blk device with zone capacity s=
maller=0A=
> +# than zone size.=0A=
> +is_nullb_with_zone_cap() {=0A=
> +	local f=0A=
> +=0A=
> +	f=3D/sys/kernel/config/nullb/$(basename "${1}")=0A=
> +	[[ -r "${f}/zone_capacity" &&=0A=
> +		   $(<"${f}/zone_capacity") -lt $(<"${f}/zone_size") ]]=0A=
> +}=0A=
> +=0A=
> +# Check if blkzone is available and suitable for the test target device.=
 If not=0A=
> +# available, print error message and return 1. Otherwise return 0.=0A=
> +check_blkzone() {=0A=
> +	local dev=3D"${1}"=0A=
> +=0A=
> +	# If the devices supports zone capacity, mandate zone capacity report b=
y=0A=
> +	# blkzone.=0A=
> +	if is_nvme_zns "${dev}" || is_nullb_with_zone_cap "${dev}" &&=0A=
> +				! blkzone_reports_capacity "${dev}"; then=0A=
=0A=
You need brackets around the or condition here since the AND operation must=
=0A=
consider the value of is_nvme_zns || is_nullb_with_zone_cap.=0A=
=0A=
> +		echo "Error: blkzone does not report zone capacity"=0A=
> +		echo "Error: install latest util-linux with blkzone"=0A=
> +		return 1=0A=
> +	fi=0A=
> +}=0A=
> +=0A=
>  # Reports the starting sector and length of the first sequential zone of=
 device=0A=
>  # $1.=0A=
>  first_sequential_zone() {=0A=
> diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support=0A=
> index 80dc3f30..f086bd10 100755=0A=
> --- a/t/zbd/test-zbd-support=0A=
> +++ b/t/zbd/test-zbd-support=0A=
> @@ -863,6 +863,9 @@ if [[ -b "$realdev" ]]; then=0A=
>  	case "$(<"/sys/class/block/$basename/queue/zoned")" in=0A=
>  	host-managed|host-aware)=0A=
>  		is_zbd=3Dtrue=0A=
> +		if ! check_blkzone "${dev}"; then=0A=
> +			exit 1=0A=
> +		fi=0A=
>  		if ! result=3D($(first_sequential_zone "$dev")); then=0A=
>  			echo "Failed to determine first sequential zone"=0A=
>  			exit 1=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

