Return-Path: <prvs=7792dbf0f=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 1/3] t/zbd: Use max_open_zones that fio fetched from
 device
Date: Tue, 1 Jun 2021 07:19:50 +0000
Message-ID: 
 <DM6PR04MB7081ADF2BC1F043F1A74B988E73E9@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210601064753.734892-1-shinichiro.kawasaki@wdc.com>
 <20210601064753.734892-2-shinichiro.kawasaki@wdc.com>
 <DM6PR04MB7081B85BD9106F0824A9F8C5E73E9@DM6PR04MB7081.namprd04.prod.outlook.com>
 <YLXeeGfTOGa1xN/A@x1-carbon>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Niklas Cassel <Niklas.Cassel@wdc.com>
Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

On 2021/06/01 16:15, Niklas Cassel wrote:=0A=
> On Tue, Jun 01, 2021 at 07:01:18AM +0000, Damien Le Moal wrote:=0A=
>> On 2021/06/01 15:48, Shin'ichiro Kawasaki wrote:=0A=
>>> Recent commit d2f442bc0bd5 ("ioengines: add get_max_open_zones zoned=0A=
>>> block device operation") modified fio to compare --max_open_zoned optio=
n=0A=
>>=0A=
>> s/max_open_zoned/max_open_zones=0A=
>>=0A=
>>> value and max_open_zones reported by the device. The device limit is=0A=
>>> fetched through sysfs or through an ioengine specific implementation.=
=0A=
>>>=0A=
>>> The test script currently try to fetch the max open zones limit using=
=0A=
>>> libzbc tools or sg_inq. If either of these fail, default value 128 is=
=0A=
>>> supplied. This default value can be too high when the test script is=0A=
>>> run for certain zoned block devices, and can therefore result in fio=0A=
>>> error and test case failure.=0A=
>>=0A=
>> If sysfs has the max_open_zones attribute file present, that value shoul=
d be=0A=
>> retrieved first. libzbc and sg_inq should be used only if the sysfs attr=
ibute is=0A=
>> not present, that is, when running on older kernels.=0A=
> =0A=
> Since we can assume that the test script and fio versions are updated in =
sync,=0A=
> I don't see any point of duplicating the sysfs parsing in the test script=
.=0A=
> =0A=
> If the test script either specifies --max_open_zones=3D0 or omits the par=
ameter,=0A=
> fio itself will either parse sysfs, or use libzbc to fetch the max limit.=
=0A=
=0A=
True. Unless the user is running the tests with some special max_open_zones=
, we=0A=
should not try to grab any value then.=0A=
=0A=
> =0A=
> So I think that the test script should only use those "methods" that fio=
=0A=
> itself can't do.=0A=
> Right now fio can parse sysfs and use libzbc.=0A=
> The only remaining method is sg_inq. This only I assume that we want to=
=0A=
> keep in the test. (I guess the alternative is to implement the=0A=
> .get_max_open_zones() fio ioengine callback in engines/sg.c, that does=0A=
> the same. But we probably don't want to do that, right?)=0A=
=0A=
No, we certainly do not. That would need a lot more code than that, e.g. to=
 also=0A=
detect zone model. That would mean basically re-implementing what libzbc do=
es=0A=
inside the sg engine. And since we now have the libzbc engine, I do not see=
 the=0A=
point.=0A=
=0A=
> =0A=
>>=0A=
>>>=0A=
>>> To avoid the failure, modify the default value used in the test script=
=0A=
>>> from 128 to 0. With this, --max_open_zoned=3D0 is passed to fio, and it=
=0A=
>>> makes fio use the max_open_zones reported by the device.=0A=
>>=0A=
>> Why pass anything at all since now fio will use the device reported limi=
t by=0A=
>> default if the user does not specify anything ?=0A=
> =0A=
> Sure, we can just omit the --max_open_zones parameter completely.=0A=
> That might be more clear.=0A=
> =0A=
>>=0A=
>>>=0A=
>>> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>=0A=
>>> ---=0A=
>>>  t/zbd/functions | 4 ++--=0A=
>>>  1 file changed, 2 insertions(+), 2 deletions(-)=0A=
>>>=0A=
>>> diff --git a/t/zbd/functions b/t/zbd/functions=0A=
>>> index 40ffe1de..1a7ea970 100644=0A=
>>> --- a/t/zbd/functions=0A=
>>> +++ b/t/zbd/functions=0A=
>>> @@ -180,8 +180,8 @@ max_open_zones() {=0A=
>>>  	if ! ${sg_inq} -e --page=3D0xB6 --len=3D20 --hex "$dev" \=0A=
>>>  		 > /dev/null 2>&1; then=0A=
>>>  	    # Non scsi device such as null_blk can not return max open zones.=
=0A=
>>=0A=
>> This comment is a little outdated since even nullblk now has a limit exp=
osed=0A=
>> through sysfs (the limit may be 0 =3D=3D no limit). See above comment. s=
ysfs should=0A=
>> be the first thing to look at.=0A=
>>=0A=
>>> -	    # Use default value.=0A=
>>> -	    echo 128=0A=
>>> +	    # Specify 0 to indicate fio to get max open zones from the device=
.=0A=
>>> +	    echo 0=0A=
>>>  	else=0A=
>>>  	    ${sg_inq} -e --page=3D0xB6 --len=3D20 --hex "$dev" | tail -1 |=0A=
>>>  		{=0A=
>>>=0A=
>>=0A=
>>=0A=
>> -- =0A=
>> Damien Le Moal=0A=
>> Western Digital Research=0A=
>>=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

