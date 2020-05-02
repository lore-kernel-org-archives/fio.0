Return-Path: <prvs=38445ce10=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 5/7] zbd: consolidate zone mutex initialisation
Date: Sat, 2 May 2020 04:39:24 +0000
Message-ID: 
 <BY5PR04MB69005BF5B2D6789D3132288CE7A80@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200430124050.20146-1-adobriyan@gmail.com>
 <20200430124050.20146-5-adobriyan@gmail.com>
 <BY5PR04MB69009FD94999AC765AA1E25AE7AB0@BY5PR04MB6900.namprd04.prod.outlook.com>
 <20200501183734.GA32674@avx2>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2020/05/02 3:37, Alexey Dobriyan wrote:=0A=
> On Fri, May 01, 2020 at 01:44:26AM +0000, Damien Le Moal wrote:=0A=
>> On 2020/04/30 21:41, Alexey Dobriyan wrote:=0A=
>>> Another mutex is coming!=0A=
>>=0A=
>> That is not very descriptive at all.=0A=
>> What the patch does is to make the per zone mutex initialization code co=
mmon=0A=
>> between init_zone_info() and parse_zone_info(), moving it to create_zone=
_info().=0A=
> =0A=
>>> @@ -546,11 +532,27 @@ static int zbd_create_zone_info(struct thread_dat=
a *td, struct fio_file *f)=0A=
>>>  		return -EINVAL;=0A=
>>>  	}=0A=
>>>  =0A=
>>> -	if (ret =3D=3D 0) {=0A=
>>> -		f->zbd_info->model =3D zbd_model;=0A=
>>> -		f->zbd_info->max_open_zones =3D td->o.global_max_open_zones;=0A=
>>> +	if (ret)=0A=
>>> +		return ret;=0A=
>>> +=0A=
>>> +	zbd =3D f->zbd_info;=0A=
>>> +	zbd->model =3D zbd_model;=0A=
>>> +	zbd->max_open_zones =3D td->o.global_max_open_zones;=0A=
>>> +	{=0A=
>>> +		pthread_mutexattr_t attr;=0A=
>>=0A=
>> If you move this declaration to the beginning of zbd_create_zone_info(),=
 you can=0A=
>> avoid this block code, which does not look pretty.=0A=
> =0A=
> It is done on purpose, to move declaration closer to usage.=0A=
=0A=
I understood that. But it is visually not pleasing in my opinion and does n=
ot=0A=
match the general coding style used in fio.=0A=
Just make that mutex initialization code block an inline function. That wil=
l=0A=
cleanup things nicely.=0A=
=0A=
> fio is built with -std=3Dgnu99 _and_ -Wdeclaration-after-statement which=
=0A=
> prevents=0A=
> =0A=
> 	a =3D b;=0A=
> 	int c;=0A=
> 	c =3D d;=0A=
> =0A=
> modern style of declaration.=0A=
> =0A=
>>> +		pthread_mutexattr_init(&attr);=0A=
>>> +		pthread_mutexattr_setpshared(&attr, true);=0A=
>>> +		pthread_mutex_init(&zbd->mutex, &attr);=0A=
>>> +		pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);=0A=
>>> +		for (uint32_t z =3D 0; z < zbd->nr_zones; z++) {=0A=
>>> +			struct fio_zone_info *zi =3D &zbd->zone_info[z];=0A=
>>> +=0A=
>>> +			pthread_mutex_init(&zi->mutex, &attr);=0A=
>>> +		}=0A=
>>> +		pthread_mutexattr_destroy(&attr);=0A=
>>>  	}=0A=
>>> -	return ret;=0A=
>>> +	return 0;=0A=
>>>  }=0A=
>>>  =0A=
>>>  void zbd_free_zone_info(struct fio_file *f)=0A=
>>>=0A=
>>=0A=
>> With the nits above fixed, Looks good to me.=0A=
>>=0A=
>> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

