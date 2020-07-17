Return-Path: <prvs=460a6953b=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v2 4/6] t/zbd: Support testing zone capacity smaller than
 zone size
Date: Fri, 17 Jul 2020 07:01:45 +0000
Message-ID: 
 <CY4PR04MB37512EA5DC06813C7D91E2B5E77C0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200715064141.116415-1-shinichiro.kawasaki@wdc.com>
 <20200715064141.116415-5-shinichiro.kawasaki@wdc.com>
 <CY4PR04MB3751443B7CD688F5691C2280E77C0@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200717065948.lycsnwsvu6rtlfaj@shindev.dhcp.fujisawa.hgst.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Hans Holmberg <Hans.Holmberg@wdc.com>, Aravind Ramesh <Aravind.Ramesh@wdc.com>
List-ID: <fio@vger.kernel.org>

On 2020/07/17 15:59, Shinichiro Kawasaki wrote:=0A=
> On Jul 17, 2020 / 02:01, Damien Le Moal wrote:=0A=
>> On 2020/07/15 15:41, Shin'ichiro Kawasaki wrote:=0A=
>>> From: Hans Holmberg <hans.holmberg@wdc.com>=0A=
>>>=0A=
>>> Add support for testing zoned block devices where zone capacity is less=
=0A=
>>> than zone size. If the test case runs sequential workloads or workloads=
=0A=
>>> with verify, use zone capacity instead of zone size to complete.=0A=
>>>=0A=
>>> To use zone capacity of the test target zones, introduce a helper=0A=
>>> function total_zone_capacity() which sums up zone capacity numbers of t=
he=0A=
>>> test target zones.=0A=
>>>=0A=
>>> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>=0A=
>>> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>=0A=
>>> ---=0A=
>>>  t/zbd/functions        |  37 +++++++++++++++=0A=
>>>  t/zbd/test-zbd-support | 100 ++++++++++++++++++++++++++---------------=
=0A=
>>>  2 files changed, 102 insertions(+), 35 deletions(-)=0A=
>>>=0A=
>>> diff --git a/t/zbd/functions b/t/zbd/functions=0A=
>>> index 344836c8..82d64f5c 100644=0A=
>>> --- a/t/zbd/functions=0A=
>>> +++ b/t/zbd/functions=0A=
>>> @@ -84,6 +84,43 @@ first_sequential_zone() {=0A=
>>>      fi=0A=
>>>  }=0A=
>>>  =0A=
>>> +# Reports the summed zone capacity of $1 number of zones starting from=
 offset $2=0A=
>>> +# on device $3.=0A=
>>> +total_zone_capacity() {=0A=
>>> +	local nr_zones=3D$1=0A=
>>> +	local sector=3D$(($2 / 512))=0A=
>>> +	local dev=3D$3=0A=
>>> +	local capacity=3D0 num=0A=
>>> +	local grep_str=0A=
>>> +=0A=
>>> +	if [ -z "$is_zbd" ]; then=0A=
>>> +		# For regular block devices, handle zone size as zone capacity.=0A=
>>> +		echo $((zone_size * nr_zones))=0A=
>>> +		return=0A=
>>> +	fi=0A=
>>> +=0A=
>>> +	if [ -n "${blkzone}" ] && [ ! -n "${use_libzbc}" ]; then=0A=
>>> +		if blkzone_reports_capacity "${dev}"; then=0A=
>>> +			grep_str=3D'cap \K[0-9a-zA-Z]*'=0A=
>>> +		else=0A=
>>> +			# If zone capacity is not reported, refer zone length.=0A=
>>> +			grep_str=3D'len \K[0-9a-zA-Z]*'=0A=
>>> +		fi=0A=
>>> +		while read num; do=0A=
>>> +			capacity=3D$((capacity + num))=0A=
>>> +		done < <(${blkzone} report -c "$nr_zones" -o "$sector" "$dev" |=0A=
>>> +				grep -Po "${grep_str}")=0A=
>>=0A=
>> Why the space in "< <" ? Why not "<<" ?=0A=
> =0A=
> "<()" is the bash syntax "process substitution". To separate it from redi=
rect, a=0A=
> space is required between "<" and "<()".=0A=
=0A=
Ah. Yes. I missed that... For some reason, I assumed that the loop input ne=
eded=0A=
"<<" :)=0A=
=0A=
=0A=
> =0A=
> Other than this, I will reflect all of your comments to v3. Thank you for=
 the=0A=
> valuable comments.=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

