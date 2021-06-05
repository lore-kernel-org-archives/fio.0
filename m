Return-Path: <prvs=78323391c=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 3/4] zbd: remove zbd_zoned_model ZBD_IGNORE
Date: Sat, 5 Jun 2021 00:47:35 +0000
Message-ID: 
 <DM6PR04MB708155BAFB076A8F798A74FBE73A9@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210604121843.6047-1-Niklas.Cassel@wdc.com>
 <20210604121843.6047-4-Niklas.Cassel@wdc.com>
 <DM6PR04MB7081E83D0364D14F5326D3B4E73A9@DM6PR04MB7081.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Niklas Cassel <Niklas.Cassel@wdc.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2021/06/05 9:42, Damien Le Moal wrote:=0A=
> On 2021/06/04 21:18, Niklas Cassel wrote:=0A=
>> From: Niklas Cassel <niklas.cassel@wdc.com>=0A=
>>=0A=
>> For a job with zonemode=3Dzbd, we do not want any file to be ignored.=0A=
>> Each file's file type in that job should be supported by either zbd.c=0A=
>> or the ioengine. If not, we should return an error.=0A=
>> This way, ZBD_IGNORE becomes redundant and can be removed.=0A=
>>=0A=
>> By removing ZBD_IGNORE, we know that all files belonging to a job that=
=0A=
>> has zonemode=3Dzbd set, will either be a zoned block device, or emulate=
=0A=
>> a zoned block device.=0A=
>>=0A=
>> This means that for jobs that have zonemode=3Dzbd, f->zbd_info will alwa=
ys=0A=
>> be non-NULL. This will make the zbd code slightly easier to reason about=
=0A=
>> and to maintain.=0A=
>>=0A=
>> When removing zbd_zoned_model ZBD_IGNORE, define the new first enum valu=
e=0A=
>> as 0x1, so that we avoid potential ABI problems with existing binaries.=
=0A=
>>=0A=
>> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>=0A=
>> ---=0A=
>>  engines/libzbc.c            | 3 +--=0A=
>>  engines/skeleton_external.c | 1 -=0A=
>>  oslib/linux-blkzoned.c      | 3 +--=0A=
>>  zbd.c                       | 3 +--=0A=
>>  zbd_types.h                 | 7 +++----=0A=
>>  5 files changed, 6 insertions(+), 11 deletions(-)=0A=
>>=0A=
>> diff --git a/engines/libzbc.c b/engines/libzbc.c=0A=
>> index 3dde93db..c3551bec 100644=0A=
>> --- a/engines/libzbc.c=0A=
>> +++ b/engines/libzbc.c=0A=
>> @@ -181,8 +181,7 @@ static int libzbc_get_zoned_model(struct thread_data=
 *td, struct fio_file *f,=0A=
>>  	int ret;=0A=
>>  =0A=
>>  	if (f->filetype !=3D FIO_TYPE_BLOCK && f->filetype !=3D FIO_TYPE_CHAR)=
 {=0A=
>> -		*model =3D ZBD_IGNORE;=0A=
>> -		return 0;=0A=
>> +		return -EINVAL;=0A=
>>  	}=0A=
>>  =0A=
>>  	ret =3D libzbc_open_dev(td, f, &ld);=0A=
>> diff --git a/engines/skeleton_external.c b/engines/skeleton_external.c=
=0A=
>> index c79b6f11..cff83a10 100644=0A=
>> --- a/engines/skeleton_external.c=0A=
>> +++ b/engines/skeleton_external.c=0A=
>> @@ -156,7 +156,6 @@ static int fio_skeleton_close(struct thread_data *td=
, struct fio_file *f)=0A=
>>  /*=0A=
>>   * Hook for getting the zoned model of a zoned block device for zonemod=
e=3Dzbd.=0A=
>>   * The zoned model can be one of (see zbd_types.h):=0A=
>> - * - ZBD_IGNORE: skip regular files=0A=
>>   * - ZBD_NONE: regular block device (zone emulation will be used)=0A=
>>   * - ZBD_HOST_AWARE: host aware zoned block device=0A=
>>   * - ZBD_HOST_MANAGED: host managed zoned block device=0A=
>> diff --git a/oslib/linux-blkzoned.c b/oslib/linux-blkzoned.c=0A=
>> index 6f89ec6f..8cb9c53a 100644=0A=
>> --- a/oslib/linux-blkzoned.c=0A=
>> +++ b/oslib/linux-blkzoned.c=0A=
>> @@ -141,8 +141,7 @@ int blkzoned_get_zoned_model(struct thread_data *td,=
 struct fio_file *f,=0A=
>>  	char *model_str =3D NULL;=0A=
>>  =0A=
>>  	if (f->filetype !=3D FIO_TYPE_BLOCK) {=0A=
>> -		*model =3D ZBD_IGNORE;=0A=
>> -		return 0;=0A=
>> +		return -EINVAL;=0A=
>>  	}=0A=
>>  =0A=
>>  	*model =3D ZBD_NONE;=0A=
>> diff --git a/zbd.c b/zbd.c=0A=
>> index fb20f6cc..7012cb93 100644=0A=
>> --- a/zbd.c=0A=
>> +++ b/zbd.c=0A=
>> @@ -661,8 +661,6 @@ static int zbd_create_zone_info(struct thread_data *=
td, struct fio_file *f)=0A=
>>  		return ret;=0A=
>>  =0A=
>>  	switch (zbd_model) {=0A=
>> -	case ZBD_IGNORE:=0A=
>> -		return 0;=0A=
>>  	case ZBD_HOST_AWARE:=0A=
>>  	case ZBD_HOST_MANAGED:=0A=
>>  		ret =3D parse_zone_info(td, f);=0A=
>> @@ -680,6 +678,7 @@ static int zbd_create_zone_info(struct thread_data *=
td, struct fio_file *f)=0A=
>>  		return -EINVAL;=0A=
>>  	}=0A=
>>  =0A=
>> +	assert(f->zbd_info);=0A=
>>  	f->zbd_info->model =3D zbd_model;=0A=
>>  =0A=
>>  	ret =3D zbd_set_max_open_zones(td, f);=0A=
>> diff --git a/zbd_types.h b/zbd_types.h=0A=
>> index d0f4c44e..0a8630cb 100644=0A=
>> --- a/zbd_types.h=0A=
>> +++ b/zbd_types.h=0A=
>> @@ -14,10 +14,9 @@=0A=
>>   * Zoned block device models.=0A=
>>   */=0A=
>>  enum zbd_zoned_model {=0A=
>> -	ZBD_IGNORE,		/* Ignore file */=0A=
>> -	ZBD_NONE,		/* No zone support. Emulate zones. */=0A=
>> -	ZBD_HOST_AWARE,		/* Host-aware zoned block device */=0A=
>> -	ZBD_HOST_MANAGED,	/* Host-managed zoned block device */=0A=
>> +	ZBD_NONE		=3D 0x1,	/* No zone support. Emulate zones. */=0A=
>> +	ZBD_HOST_AWARE		=3D 0x2,	/* Host-aware zoned block device */=0A=
>> +	ZBD_HOST_MANAGED	=3D 0x3,	/* Host-managed zoned block device */=0A=
>>  };=0A=
>>  =0A=
>>  /*=0A=
>>=0A=
> =0A=
> Looks good.=0A=
> =0A=
> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
Scrap this. Rereading the patch and code, I have comments.=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

