Return-Path: <prvs=4091ec2cb=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH] zbd: Fix max_open_zones checks
Date: Wed, 27 May 2020 08:40:09 +0000
Message-ID: 
 <CY4PR04MB37516C5CB562AFA06D2F208FE7B10@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200527012013.87661-1-shinichiro.kawasaki@wdc.com>
 <20200527083420.GA3077@localhost.localdomain>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On 2020/05/27 17:34, Alexey Dobriyan wrote:=0A=
> On Wed, May 27, 2020 at 10:20:13AM +0900, Shin'ichiro Kawasaki wrote:=0A=
>> Commit 219c662d3b12 ("zbd: introduce per job maximum open zones limit")=
=0A=
>> introduced job_max_open_zones option which limits the number of open=0A=
>> zones per job. It has similar role as max_open_zones option which limits=
=0A=
>> the number of open zones for all jobs. It was intended that these two=0A=
>> options both work, but the commit replaced some checks for max_open_zone=
s=0A=
>> simply with checks for job_max_open_zones. Because of this, when=0A=
>> max_open_zones is set and job_max_open_zones is not set, fio fails to=0A=
>> limit the number of open zones. This resulted in test case #29 failure=
=0A=
>> of t/zbd/test-zbd-support script for regular null_blk devices.=0A=
> =0A=
> Isn't this test broken for the rationale behind "job_max_open_zones=3D"?=
=0A=
> =0A=
>  opts+=3D("--zonemode=3Dzbd"...=0A=
>  opts+=3D("--ioengine=3Dpsync" "--rw=3Drandwrite" "--direct=3D1")=0A=
>  opts+=3D("--max_open_zones=3D4" "--group_reporting=3D1")=0A=
>  check_written $((jobs * zone_size)) || return $?=0A=
> =0A=
> Strict equality check but one thread can open all 4 zones and make=0A=
> others quit.=0A=
=0A=
That is the legacy behavior that your patch allows changing with the new=0A=
job_max_open_zones option. Adding this option should not break existing scr=
ipts,=0A=
even though they are not "optimal".=0A=
=0A=
Could you add some test cases to t/zbd/test-zbd-support for the=0A=
job_max_open_zones option and combinations of job_max_open_zones and=0A=
max_open_zones options ? That will facilitate regression testing going forw=
ard.=0A=
=0A=
=0A=
> =0A=
>> To fix the failure, modify the checks to target both job_max_open_zones=
=0A=
>> and max_open_zones.=0A=
> =0A=
>> --- a/zbd.c=0A=
>> +++ b/zbd.c=0A=
>> @@ -997,7 +997,7 @@ static struct fio_zone_info *zbd_convert_to_open_zon=
e(struct thread_data *td,=0A=
>>  =0A=
>>  	assert(is_valid_offset(f, io_u->offset));=0A=
>>  =0A=
>> -	if (td->o.job_max_open_zones) {=0A=
>> +	if (td->o.max_open_zones || td->o.job_max_open_zones) {=0A=
>>  		/*=0A=
>>  		 * This statement accesses f->zbd_info->open_zones[] on purpose=0A=
>>  		 * without locking.=0A=
>> @@ -1026,7 +1026,7 @@ static struct fio_zone_info *zbd_convert_to_open_z=
one(struct thread_data *td,=0A=
>>  =0A=
>>  		zone_lock(td, f, z);=0A=
>>  		pthread_mutex_lock(&f->zbd_info->mutex);=0A=
>> -		if (td->o.job_max_open_zones =3D=3D 0)=0A=
>> +		if (td->o.max_open_zones =3D=3D 0 && td->o.job_max_open_zones =3D=3D =
0)=0A=
>>  			goto examine_zone;=0A=
>>  		if (f->zbd_info->num_open_zones =3D=3D 0) {=0A=
>>  			pthread_mutex_unlock(&f->zbd_info->mutex);=0A=
>> @@ -1082,7 +1082,7 @@ examine_zone:=0A=
>>  	}=0A=
>>  	dprint(FD_ZBD, "%s(%s): closing zone %d\n", __func__, f->file_name,=0A=
>>  	       zone_idx);=0A=
>> -	if (td->o.job_max_open_zones)=0A=
>> +	if (td->o.max_open_zones || td->o.job_max_open_zones)=0A=
>>  		zbd_close_zone(td, f, open_zone_idx);=0A=
>>  	pthread_mutex_unlock(&f->zbd_info->mutex);=0A=
>>  =0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

