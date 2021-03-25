Return-Path: <prvs=71193bae2=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v2 1/2] zbd: avoid zone reset during asynchronous IOs
 in-flight
Date: Thu, 25 Mar 2021 05:06:25 +0000
Message-ID: 
 <BL0PR04MB65145A0BE18E086D1916CB61E7629@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210325021535.1531333-1-shinichiro.kawasaki@wdc.com>
 <20210325021535.1531333-2-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

On 2021/03/25 11:15, Shin'ichiro Kawasaki wrote:=0A=
> When fio repeats same workload on zoned block devices, zbd_file_reset()=
=0A=
> is called for each repetition. This function resets target zones when=0A=
> one of two conditions are met: 1) the write pointer of the zone has=0A=
> offset from the device start unaligned to block size, or 2) the workload=
=0A=
> is verify and verification is not in process. When the workload runs=0A=
> with block size not a divisor of the zone size, the offsets of write=0A=
> pointers from device start (not from zone start) become unaligned to=0A=
> block size, then zbd_file_reset() resets target zones. This zone reset=0A=
> happens even when the asynchronous IOs are in-flight and causes=0A=
> unexpected IO results. Especially if write requests are in-flight, they=
=0A=
> fail with unaligned write command error. A single thread may do both the=
=0A=
> zone reset and the write request submit, recursive zone locks can not=0A=
> prevent the zone reset during the writes.=0A=
> =0A=
> The write pointer check for block size alignment is not working as=0A=
> intended. It should have checked offset not from device start but from=0A=
> zone start. Having said that, regardless of this write pointer check=0A=
> correctness, the zone reset is not required since the zones are reset in=
=0A=
> zbd_adjust_block() anyway when remainder of the zone between write=0A=
> pointer and zone end is smaller than block size.=0A=
> =0A=
> To avoid the zone reset during asynchronous IOs, do not reset zones in=0A=
> zbd_file_reset() when the write pointer offset from the device start is=
=0A=
> unaligned to block size. Modify zbd_file_reset() to call the helper=0A=
> function zbd_reset_zones() only when the workload is verify and=0A=
> verification is not in process. The function zbd_reset_zones() had an=0A=
> argument 'all_zones' to inform that the zones should be reset when its=0A=
> write pointer is unaligned to block size. This argument is not required.=
=0A=
> Remove it and simplify the function accordingly.=0A=
> =0A=
> The zone reset for verify workloads is still required. It does not=0A=
> conflict with asynchronous IOs, since fio waits for IO completion at=0A=
> verification end, then IOs are not in-flight when zbd_file_reset() is=0A=
> called for repetition after verification.=0A=
> =0A=
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>=0A=
> ---=0A=
>  zbd.c | 23 +++++++----------------=0A=
>  1 file changed, 7 insertions(+), 16 deletions(-)=0A=
> =0A=
> diff --git a/zbd.c b/zbd.c=0A=
> index d16b890f..eed796b3 100644=0A=
> --- a/zbd.c=0A=
> +++ b/zbd.c=0A=
> @@ -842,16 +842,13 @@ static void zbd_close_zone(struct thread_data *td, =
const struct fio_file *f,=0A=
>   * @f: fio file for which to reset zones=0A=
>   * @zb: first zone to reset.=0A=
>   * @ze: first zone not to reset.=0A=
> - * @all_zones: whether to reset all zones or only those zones for which =
the=0A=
> - *	write pointer is not a multiple of td->o.min_bs[DDIR_WRITE].=0A=
>   */=0A=
>  static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,=
=0A=
>  			   struct fio_zone_info *const zb,=0A=
> -			   struct fio_zone_info *const ze, bool all_zones)=0A=
> +			   struct fio_zone_info *const ze)=0A=
>  {=0A=
>  	struct fio_zone_info *z;=0A=
>  	const uint32_t min_bs =3D td->o.min_bs[DDIR_WRITE];=0A=
> -	bool reset_wp;=0A=
>  	int res =3D 0;=0A=
>  =0A=
>  	assert(min_bs);=0A=
> @@ -864,16 +861,10 @@ static int zbd_reset_zones(struct thread_data *td, =
struct fio_file *f,=0A=
>  		if (!z->has_wp)=0A=
>  			continue;=0A=
>  		zone_lock(td, f, z);=0A=
> -		if (all_zones) {=0A=
> -			pthread_mutex_lock(&f->zbd_info->mutex);=0A=
> -			zbd_close_zone(td, f, nz);=0A=
> -			pthread_mutex_unlock(&f->zbd_info->mutex);=0A=
> -=0A=
> -			reset_wp =3D z->wp !=3D z->start;=0A=
> -		} else {=0A=
> -			reset_wp =3D z->wp % min_bs !=3D 0;=0A=
> -		}=0A=
> -		if (reset_wp) {=0A=
> +		pthread_mutex_lock(&f->zbd_info->mutex);=0A=
> +		zbd_close_zone(td, f, nz);=0A=
> +		pthread_mutex_unlock(&f->zbd_info->mutex);> +		if (z->wp !=3D z->start=
) {=0A=
>  			dprint(FD_ZBD, "%s: resetting zone %u\n",=0A=
>  			       f->file_name, zbd_zone_nr(f, z));=0A=
>  			if (zbd_reset_zone(td, f, z) < 0)=0A=
> @@ -996,8 +987,8 @@ void zbd_file_reset(struct thread_data *td, struct fi=
o_file *f)=0A=
>  	 * writing any data to avoid that a zone reset has to be issued while=
=0A=
>  	 * writing data, which causes data loss.=0A=
>  	 */=0A=
> -	zbd_reset_zones(td, f, zb, ze, td->o.verify !=3D VERIFY_NONE &&=0A=
> -			td->runstate !=3D TD_VERIFYING);=0A=
> +	if (td->o.verify !=3D VERIFY_NONE && td->runstate !=3D TD_VERIFYING)=0A=
> +		zbd_reset_zones(td, f, zb, ze);=0A=
>  	zbd_reset_write_cnt(td, f);=0A=
>  }=0A=
>  =0A=
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

