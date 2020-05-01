Return-Path: <prvs=383ebf04e=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 4/7] zbd: make zbd_info->mutex non-recursive
Date: Fri, 1 May 2020 01:36:46 +0000
Message-ID: 
 <BY5PR04MB6900B1E9D494761E8ECE7B08E7AB0@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200430124050.20146-1-adobriyan@gmail.com>
 <20200430124050.20146-4-adobriyan@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2020/04/30 21:41, Alexey Dobriyan wrote:=0A=
> There is no reason for it to be recursive. Resursiveness leaked from=0A=
> zi->mutex.=0A=
> =0A=
> Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>=0A=
> ---=0A=
>  zbd.c | 18 ++++++++++++------=0A=
>  1 file changed, 12 insertions(+), 6 deletions(-)=0A=
> =0A=
> diff --git a/zbd.c b/zbd.c=0A=
> index a517349a..18cedfce 100644=0A=
> --- a/zbd.c=0A=
> +++ b/zbd.c=0A=
> @@ -373,9 +373,9 @@ static int init_zone_info(struct thread_data *td, str=
uct fio_file *f)=0A=
>  		return -ENOMEM;=0A=
>  =0A=
>  	pthread_mutexattr_init(&attr);=0A=
> -	pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);=0A=
>  	pthread_mutexattr_setpshared(&attr, true);=0A=
>  	pthread_mutex_init(&zbd_info->mutex, &attr);=0A=
> +	pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);=0A=
>  	zbd_info->refcount =3D 1;=0A=
>  	p =3D &zbd_info->zone_info[0];=0A=
>  	for (i =3D 0; i < nr_zones; i++, p++) {=0A=
> @@ -417,7 +417,6 @@ static int parse_zone_info(struct thread_data *td, st=
ruct fio_file *f)=0A=
>  	int i, j, ret =3D 0;=0A=
>  =0A=
>  	pthread_mutexattr_init(&attr);=0A=
> -	pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);=0A=
>  	pthread_mutexattr_setpshared(&attr, true);=0A=
>  =0A=
>  	zones =3D calloc(ZBD_REPORT_MAX_ZONES, sizeof(struct zbd_zone));=0A=
> @@ -454,6 +453,7 @@ static int parse_zone_info(struct thread_data *td, st=
ruct fio_file *f)=0A=
>  	if (!zbd_info)=0A=
>  		goto out;=0A=
>  	pthread_mutex_init(&zbd_info->mutex, &attr);=0A=
> +	pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);=0A=
>  	zbd_info->refcount =3D 1;=0A=
>  	p =3D &zbd_info->zone_info[0];=0A=
>  	for (offset =3D 0, j =3D 0; j < nr_zones;) {=0A=
> @@ -801,14 +801,20 @@ static int zbd_reset_zones(struct thread_data *td, =
struct fio_file *f,=0A=
>   * Reset zbd_info.write_cnt, the counter that counts down towards the ne=
xt=0A=
>   * zone reset.=0A=
>   */=0A=
> -static void zbd_reset_write_cnt(const struct thread_data *td,=0A=
> -				const struct fio_file *f)=0A=
> +static void _zbd_reset_write_cnt(const struct thread_data *td,=0A=
> +				 const struct fio_file *f)=0A=
>  {=0A=
>  	assert(0 <=3D td->o.zrf.u.f && td->o.zrf.u.f <=3D 1);=0A=
>  =0A=
> -	pthread_mutex_lock(&f->zbd_info->mutex);=0A=
>  	f->zbd_info->write_cnt =3D td->o.zrf.u.f ?=0A=
>  		min(1.0 / td->o.zrf.u.f, 0.0 + UINT_MAX) : UINT_MAX;=0A=
> +}=0A=
> +=0A=
> +static void zbd_reset_write_cnt(const struct thread_data *td,=0A=
> +				const struct fio_file *f)=0A=
> +{=0A=
> +	pthread_mutex_lock(&f->zbd_info->mutex);=0A=
> +	_zbd_reset_write_cnt(td, f);=0A=
>  	pthread_mutex_unlock(&f->zbd_info->mutex);=0A=
>  }=0A=
>  =0A=
> @@ -822,7 +828,7 @@ static bool zbd_dec_and_reset_write_cnt(const struct =
thread_data *td,=0A=
>  	if (f->zbd_info->write_cnt)=0A=
>  		write_cnt =3D --f->zbd_info->write_cnt;=0A=
>  	if (write_cnt =3D=3D 0)=0A=
> -		zbd_reset_write_cnt(td, f);=0A=
> +		_zbd_reset_write_cnt(td, f);=0A=
>  	pthread_mutex_unlock(&f->zbd_info->mutex);=0A=
>  =0A=
>  	return write_cnt =3D=3D 0;=0A=
> =0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

