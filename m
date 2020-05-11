Return-Path: <prvs=393ca294f=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 6/9] zbd: consolidate zone mutex initialisation
Date: Mon, 11 May 2020 01:16:04 +0000
Message-ID: 
 <BY5PR04MB690046CB592B1B01E93B18B5E7A10@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200505175634.2517-1-adobriyan@gmail.com>
 <20200505175634.2517-6-adobriyan@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2020/05/06 2:56, Alexey Dobriyan wrote:=0A=
> Initialise everything that is not write pointers coming from device or=0A=
> faked separatedly.=0A=
=0A=
s/Initialise/Initialize=0A=
s/separatedly/separately=0A=
=0A=
> =0A=
> More stuff (verification in ZBD mode and ->write_mutex) will be added.=0A=
> =0A=
> Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>=0A=
> ---=0A=
>  zbd.c | 39 ++++++++++++++++++++-------------------=0A=
>  1 file changed, 20 insertions(+), 19 deletions(-)=0A=
> =0A=
> diff --git a/zbd.c b/zbd.c=0A=
> index 2926bae9..df46da42 100644=0A=
> --- a/zbd.c=0A=
> +++ b/zbd.c=0A=
> @@ -351,7 +351,6 @@ static int init_zone_info(struct thread_data *td, str=
uct fio_file *f)=0A=
>  	struct fio_zone_info *p;=0A=
>  	uint64_t zone_size =3D td->o.zone_size;=0A=
>  	struct zoned_block_device_info *zbd_info =3D NULL;=0A=
> -	pthread_mutexattr_t attr;=0A=
>  	int i;=0A=
>  =0A=
>  	if (zone_size =3D=3D 0) {=0A=
> @@ -372,14 +371,9 @@ static int init_zone_info(struct thread_data *td, st=
ruct fio_file *f)=0A=
>  	if (!zbd_info)=0A=
>  		return -ENOMEM;=0A=
>  =0A=
> -	pthread_mutexattr_init(&attr);=0A=
> -	pthread_mutexattr_setpshared(&attr, true);=0A=
> -	pthread_mutex_init(&zbd_info->mutex, &attr);=0A=
> -	pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);=0A=
>  	zbd_info->refcount =3D 1;=0A=
>  	p =3D &zbd_info->zone_info[0];=0A=
>  	for (i =3D 0; i < nr_zones; i++, p++) {=0A=
> -		pthread_mutex_init(&p->mutex, &attr);=0A=
>  		p->start =3D i * zone_size;=0A=
>  		p->wp =3D p->start + zone_size;=0A=
>  		p->type =3D ZBD_ZONE_TYPE_SWR;=0A=
> @@ -393,7 +387,6 @@ static int init_zone_info(struct thread_data *td, str=
uct fio_file *f)=0A=
>  	f->zbd_info->zone_size_log2 =3D is_power_of_2(zone_size) ?=0A=
>  		ilog2(zone_size) : 0;=0A=
>  	f->zbd_info->nr_zones =3D nr_zones;=0A=
> -	pthread_mutexattr_destroy(&attr);=0A=
>  	return 0;=0A=
>  }=0A=
>  =0A=
> @@ -413,12 +406,8 @@ static int parse_zone_info(struct thread_data *td, s=
truct fio_file *f)=0A=
>  	struct fio_zone_info *p;=0A=
>  	uint64_t zone_size, offset;=0A=
>  	struct zoned_block_device_info *zbd_info =3D NULL;=0A=
> -	pthread_mutexattr_t attr;=0A=
>  	int i, j, ret =3D 0;=0A=
>  =0A=
> -	pthread_mutexattr_init(&attr);=0A=
> -	pthread_mutexattr_setpshared(&attr, true);=0A=
> -=0A=
>  	zones =3D calloc(ZBD_REPORT_MAX_ZONES, sizeof(struct zbd_zone));=0A=
>  	if (!zones)=0A=
>  		goto out;=0A=
> @@ -452,14 +441,11 @@ static int parse_zone_info(struct thread_data *td, =
struct fio_file *f)=0A=
>  	ret =3D -ENOMEM;=0A=
>  	if (!zbd_info)=0A=
>  		goto out;=0A=
> -	pthread_mutex_init(&zbd_info->mutex, &attr);=0A=
> -	pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);=0A=
>  	zbd_info->refcount =3D 1;=0A=
>  	p =3D &zbd_info->zone_info[0];=0A=
>  	for (offset =3D 0, j =3D 0; j < nr_zones;) {=0A=
>  		z =3D &zones[0];=0A=
>  		for (i =3D 0; i < nrz; i++, j++, z++, p++) {=0A=
> -			pthread_mutex_init(&p->mutex, &attr);=0A=
>  			p->start =3D z->start;=0A=
>  			switch (z->cond) {=0A=
>  			case ZBD_ZONE_COND_NOT_WP:=0A=
> @@ -510,7 +496,6 @@ static int parse_zone_info(struct thread_data *td, st=
ruct fio_file *f)=0A=
>  out:=0A=
>  	sfree(zbd_info);=0A=
>  	free(zones);=0A=
> -	pthread_mutexattr_destroy(&attr);=0A=
>  	return ret;=0A=
>  }=0A=
>  =0A=
> @@ -521,7 +506,9 @@ out:=0A=
>   */=0A=
>  static int zbd_create_zone_info(struct thread_data *td, struct fio_file =
*f)=0A=
>  {=0A=
> +	struct zoned_block_device_info *zbd;=0A=
>  	enum zbd_zoned_model zbd_model;=0A=
> +	pthread_mutexattr_t attr;=0A=
>  	int ret;=0A=
>  =0A=
>  	assert(td->o.zone_mode =3D=3D ZONE_MODE_ZBD);=0A=
> @@ -546,11 +533,25 @@ static int zbd_create_zone_info(struct thread_data =
*td, struct fio_file *f)=0A=
>  		return -EINVAL;=0A=
>  	}=0A=
>  =0A=
> -	if (ret =3D=3D 0) {=0A=
> -		f->zbd_info->model =3D zbd_model;=0A=
> -		f->zbd_info->max_open_zones =3D td->o.max_open_zones;=0A=
> +	if (ret)=0A=
> +		return ret;=0A=
> +=0A=
> +	zbd =3D f->zbd_info;=0A=
> +	zbd->model =3D zbd_model;=0A=
> +	zbd->max_open_zones =3D td->o.max_open_zones;=0A=
> +=0A=
> +	pthread_mutexattr_init(&attr);=0A=
> +	pthread_mutexattr_setpshared(&attr, true);=0A=
> +	pthread_mutex_init(&zbd->mutex, &attr);=0A=
> +	pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);=0A=
> +	for (uint32_t z =3D 0; z < zbd->nr_zones; z++) {=0A=
> +		struct fio_zone_info *zi =3D &zbd->zone_info[z];=0A=
> +=0A=
> +		pthread_mutex_init(&zi->mutex, &attr);=0A=
>  	}=0A=
> -	return ret;=0A=
> +	pthread_mutexattr_destroy(&attr);=0A=
> +=0A=
> +	return 0;=0A=
>  }=0A=
>  =0A=
>  void zbd_free_zone_info(struct fio_file *f)=0A=
> =0A=
=0A=
On a very large drive (e.g. 20TB SMR), we have in excess of 70000 zones. Ha=
ving=0A=
to loop over all of them again will start to be painful and likely slow dow=
n (a=0A=
little) startup. And going forward with ever increasing disk capacity, this=
 will=0A=
get even worse. So not sure if this patch makes much sense.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

