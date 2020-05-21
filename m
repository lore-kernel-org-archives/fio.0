Return-Path: <prvs=403332257=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 6/9] zbd: consolidate zone mutex initialisation
Date: Thu, 21 May 2020 22:02:09 +0000
Message-ID: 
 <BY5PR04MB6900A600016652B356128850E7B70@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200505175634.2517-1-adobriyan@gmail.com>
 <20200505175634.2517-6-adobriyan@gmail.com>
 <BY5PR04MB690046CB592B1B01E93B18B5E7A10@BY5PR04MB6900.namprd04.prod.outlook.com>
 <20200521214438.GA5980@avx2>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2020/05/22 6:44, Alexey Dobriyan wrote:=0A=
> On Mon, May 11, 2020 at 01:16:04AM +0000, Damien Le Moal wrote:=0A=
>> On 2020/05/06 2:56, Alexey Dobriyan wrote:=0A=
>>> Initialise everything that is not write pointers coming from device or=
=0A=
>>> faked separatedly.=0A=
>>=0A=
>> s/Initialise/Initialize=0A=
>> s/separatedly/separately=0A=
> =0A=
>>  	assert(td->o.zone_mode =3D=3D ZONE_MODE_ZBD);=0A=
>>> @@ -546,11 +533,25 @@ static int zbd_create_zone_info(struct thread_dat=
a *td, struct fio_file *f)=0A=
>>>  		return -EINVAL;=0A=
>>>  	}=0A=
>>>  =0A=
>>> -	if (ret =3D=3D 0) {=0A=
>>> -		f->zbd_info->model =3D zbd_model;=0A=
>>> -		f->zbd_info->max_open_zones =3D td->o.max_open_zones;=0A=
>>> +	if (ret)=0A=
>>> +		return ret;=0A=
>>> +=0A=
>>> +	zbd =3D f->zbd_info;=0A=
>>> +	zbd->model =3D zbd_model;=0A=
>>> +	zbd->max_open_zones =3D td->o.max_open_zones;=0A=
>>> +=0A=
>>> +	pthread_mutexattr_init(&attr);=0A=
>>> +	pthread_mutexattr_setpshared(&attr, true);=0A=
>>> +	pthread_mutex_init(&zbd->mutex, &attr);=0A=
>>> +	pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);=0A=
>>> +	for (uint32_t z =3D 0; z < zbd->nr_zones; z++) {=0A=
>>> +		struct fio_zone_info *zi =3D &zbd->zone_info[z];=0A=
>>> +=0A=
>>> +		pthread_mutex_init(&zi->mutex, &attr);=0A=
>>>  	}=0A=
>>> -	return ret;=0A=
>>> +	pthread_mutexattr_destroy(&attr);=0A=
>>> +=0A=
>>> +	return 0;=0A=
>>>  }=0A=
>>>  =0A=
>>>  void zbd_free_zone_info(struct fio_file *f)=0A=
>>>=0A=
>>=0A=
>> On a very large drive (e.g. 20TB SMR), we have in excess of 70000 zones.=
 Having=0A=
>> to loop over all of them again will start to be painful and likely slow =
down (a=0A=
>> little) startup. And going forward with ever increasing disk capacity, t=
his will=0A=
>> get even worse. So not sure if this patch makes much sense.=0A=
> =0A=
> It separates hw-specific code (reading write pointers) from fio-specific=
=0A=
> code.=0A=
=0A=
I appreciate the cleanup the patch does, but that does not address my conce=
rn=0A=
about startup time.=0A=
=0A=
> Iterating can be made faster by going over zone in [->min_zone, ->max_zon=
e)=0A=
> only, but I didn't look at it.=0A=
=0A=
That would make things very complicated as the zbd_info zone array would en=
d=0A=
being sparse or not all zones initialized in it...=0A=
=0A=
What about replacing the mutex initialization helper doing the entire loop =
again=0A=
over all zones with one doing a single zone mutex initialization:=0A=
=0A=
init_zone_mutex(zone, &attr)=0A=
=0A=
That would cleanup nicely init_zone_info() & parse_zone_info() too.=0A=
=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

