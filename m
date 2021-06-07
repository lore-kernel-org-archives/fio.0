Return-Path: <prvs=78597c1d9=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 3/4] zbd: remove zbd_zoned_model ZBD_IGNORE
Date: Mon, 7 Jun 2021 09:18:45 +0000
Message-ID: 
 <DM6PR04MB7081AB40404F657C7F827C6FE7389@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210604121843.6047-1-Niklas.Cassel@wdc.com>
 <20210604121843.6047-4-Niklas.Cassel@wdc.com>
 <DM6PR04MB7081011B97A6223675F4EFE7E73A9@DM6PR04MB7081.namprd04.prod.outlook.com>
 <YL3iF4mMpbLstc9k@x1-carbon>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Niklas Cassel <Niklas.Cassel@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2021/06/07 18:08, Niklas Cassel wrote:=0A=
> On Sat, Jun 05, 2021 at 12:48:31AM +0000, Damien Le Moal wrote:=0A=
>> On 2021/06/04 21:18, Niklas Cassel wrote:=0A=
>>> From: Niklas Cassel <niklas.cassel@wdc.com>=0A=
>>>=0A=
>>> For a job with zonemode=3Dzbd, we do not want any file to be ignored.=
=0A=
>>> Each file's file type in that job should be supported by either zbd.c=
=0A=
>>> or the ioengine. If not, we should return an error.=0A=
>>> This way, ZBD_IGNORE becomes redundant and can be removed.=0A=
>>>=0A=
>>> By removing ZBD_IGNORE, we know that all files belonging to a job that=
=0A=
>>> has zonemode=3Dzbd set, will either be a zoned block device, or emulate=
=0A=
>>> a zoned block device.=0A=
>>>=0A=
>>> This means that for jobs that have zonemode=3Dzbd, f->zbd_info will alw=
ays=0A=
>>> be non-NULL. This will make the zbd code slightly easier to reason abou=
t=0A=
>>> and to maintain.=0A=
>>>=0A=
>>> When removing zbd_zoned_model ZBD_IGNORE, define the new first enum val=
ue=0A=
>>> as 0x1, so that we avoid potential ABI problems with existing binaries.=
=0A=
>>>=0A=
>>> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>=0A=
>>> ---=0A=
>>>  engines/libzbc.c            | 3 +--=0A=
>>>  engines/skeleton_external.c | 1 -=0A=
>>>  oslib/linux-blkzoned.c      | 3 +--=0A=
>>>  zbd.c                       | 3 +--=0A=
>>>  zbd_types.h                 | 7 +++----=0A=
>>>  5 files changed, 6 insertions(+), 11 deletions(-)=0A=
>>>=0A=
>>> diff --git a/engines/libzbc.c b/engines/libzbc.c=0A=
>>> index 3dde93db..c3551bec 100644=0A=
>>> --- a/engines/libzbc.c=0A=
>>> +++ b/engines/libzbc.c=0A=
>>> @@ -181,8 +181,7 @@ static int libzbc_get_zoned_model(struct thread_dat=
a *td, struct fio_file *f,=0A=
>>>  	int ret;=0A=
>>>  =0A=
>>>  	if (f->filetype !=3D FIO_TYPE_BLOCK && f->filetype !=3D FIO_TYPE_CHAR=
) {=0A=
>>> -		*model =3D ZBD_IGNORE;=0A=
>>> -		return 0;=0A=
>>> +		return -EINVAL;=0A=
>>>  	}=0A=
>>=0A=
>> Please drop the curly brackets.=0A=
>>=0A=
>>>  =0A=
>>>  	ret =3D libzbc_open_dev(td, f, &ld);=0A=
>>> diff --git a/engines/skeleton_external.c b/engines/skeleton_external.c=
=0A=
>>> index c79b6f11..cff83a10 100644=0A=
>>> --- a/engines/skeleton_external.c=0A=
>>> +++ b/engines/skeleton_external.c=0A=
>>> @@ -156,7 +156,6 @@ static int fio_skeleton_close(struct thread_data *t=
d, struct fio_file *f)=0A=
>>>  /*=0A=
>>>   * Hook for getting the zoned model of a zoned block device for zonemo=
de=3Dzbd.=0A=
>>>   * The zoned model can be one of (see zbd_types.h):=0A=
>>> - * - ZBD_IGNORE: skip regular files=0A=
>>>   * - ZBD_NONE: regular block device (zone emulation will be used)=0A=
>>>   * - ZBD_HOST_AWARE: host aware zoned block device=0A=
>>>   * - ZBD_HOST_MANAGED: host managed zoned block device=0A=
>>> diff --git a/oslib/linux-blkzoned.c b/oslib/linux-blkzoned.c=0A=
>>> index 6f89ec6f..8cb9c53a 100644=0A=
>>> --- a/oslib/linux-blkzoned.c=0A=
>>> +++ b/oslib/linux-blkzoned.c=0A=
>>> @@ -141,8 +141,7 @@ int blkzoned_get_zoned_model(struct thread_data *td=
, struct fio_file *f,=0A=
>>>  	char *model_str =3D NULL;=0A=
>>>  =0A=
>>>  	if (f->filetype !=3D FIO_TYPE_BLOCK) {=0A=
>>> -		*model =3D ZBD_IGNORE;=0A=
>>> -		return 0;=0A=
>>> +		return -EINVAL;=0A=
>>>  	}=0A=
>>=0A=
>> Please drop the curly brackets.=0A=
>>=0A=
>> Also, missing in this patch: zbd_verify_sizes() has a "if (!f->zbd_info)=
" check=0A=
>> which I think should be changed into an assert.=0A=
> =0A=
> Hello Damien,=0A=
> =0A=
> zbd_verify_sizes()=0A=
> does a:=0A=
> =0A=
> 	for_each_td() {=0A=
> 		for_each_file() {=0A=
> 			if (!f->zbd_info)=0A=
> 				continue;		=0A=
> 		}=0A=
> 	}=0A=
> =0A=
> Considering that this is a for_each_td(), which will iterate over all=0A=
> threads in the job file, I disagree with this comment.=0A=
> =0A=
> A job file can have one job with=0A=
> zonemode=3Dzbd=0A=
> =0A=
> and in the same job file, another job without zonemode=3Dzbd, which targe=
ts=0A=
> a completely different device, so I do think that we need to keep the=0A=
> continue here.=0A=
=0A=
Indeed. You are right.=0A=
=0A=
> =0A=
> =0A=
> Kind regards,=0A=
> Niklas=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

