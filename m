Return-Path: <prvs=471ca4633=Dmitry.Fomichev@wdc.com>
From: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: RE: [PATCH 2/3] zbd: simplify zone reset code
Date: Tue, 28 Jul 2020 23:01:53 +0000
Message-ID: 
 <MN2PR04MB5951A8D8EB4EAFA03D277664E1730@MN2PR04MB5951.namprd04.prod.outlook.com>
References: <20200727031638.28264-1-dmitry.fomichev@wdc.com>
 <20200727031638.28264-3-dmitry.fomichev@wdc.com>
 <CY4PR04MB37516FEB528EA3FEA138055AE7720@CY4PR04MB3751.namprd04.prod.outlook.com>
In-Reply-To: 
 <CY4PR04MB37516FEB528EA3FEA138055AE7720@CY4PR04MB3751.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Damien Le Moal <Damien.LeMoal@wdc.com>, Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>


> -----Original Message-----
> From: Damien Le Moal <Damien.LeMoal@wdc.com>
> Sent: Monday, July 27, 2020 1:07 AM
> To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>; Jens Axboe
> <axboe@kernel.dk>
> Cc: fio@vger.kernel.org; Shinichiro Kawasaki
> <shinichiro.kawasaki@wdc.com>
> Subject: Re: [PATCH 2/3] zbd: simplify zone reset code
>=20
> On 2020/07/27 12:16, Dmitry Fomichev wrote:
> > zbd_reset_range() function is only called once from zbd_reset_zone()
> > and it is always called for an individual zone, not a range.
> >
> > Make zone reset flow simpler by moving all the code needed
> > to reset a single zone from zbd_reset_range() to zbd_reset_zone().
> > Therefore, zbd_reset_range() is now dropped.
> >
> > No functional change.
> >
> > Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
> > ---
> >  zbd.c | 76 +++++++++++++++++++++--------------------------------------
> >  1 file changed, 27 insertions(+), 49 deletions(-)
> >
> > diff --git a/zbd.c b/zbd.c
> > index 3eac5df3..f6ccf299 100644
> > --- a/zbd.c
> > +++ b/zbd.c
> > @@ -670,54 +670,6 @@ int zbd_setup_files(struct thread_data *td)
> >  	return 0;
> >  }
> >
> > -/**
> > - * zbd_reset_range - reset zones for a range of sectors
> > - * @td: FIO thread data.
> > - * @f: Fio file for which to reset zones
> > - * @sector: Starting sector in units of 512 bytes
> > - * @nr_sectors: Number of sectors in units of 512 bytes
> > - *
> > - * Returns 0 upon success and a negative error code upon failure.
> > - */
> > -static int zbd_reset_range(struct thread_data *td, struct fio_file *f,
> > -			   uint64_t offset, uint64_t length)
> > -{
> > -	uint32_t zone_idx_b, zone_idx_e;
> > -	struct fio_zone_info *zb, *ze, *z;
> > -	int ret =3D 0;
> > -
> > -	assert(is_valid_offset(f, offset + length - 1));
> > -
> > -	switch (f->zbd_info->model) {
> > -	case ZBD_HOST_AWARE:
> > -	case ZBD_HOST_MANAGED:
> > -		ret =3D zbd_reset_wp(td, f, offset, length);
> > -		if (ret < 0)
> > -			return ret;
> > -		break;
> > -	default:
> > -		break;
> > -	}
> > -
> > -	zone_idx_b =3D zbd_zone_idx(f, offset);
> > -	zb =3D &f->zbd_info->zone_info[zone_idx_b];
> > -	zone_idx_e =3D zbd_zone_idx(f, offset + length);
> > -	ze =3D &f->zbd_info->zone_info[zone_idx_e];
> > -	for (z =3D zb; z < ze; z++) {
> > -		pthread_mutex_lock(&z->mutex);
> > -		pthread_mutex_lock(&f->zbd_info->mutex);
> > -		f->zbd_info->sectors_with_data -=3D z->wp - z->start;
> > -		pthread_mutex_unlock(&f->zbd_info->mutex);
> > -		z->wp =3D z->start;
> > -		z->verify_block =3D 0;
> > -		pthread_mutex_unlock(&z->mutex);
> > -	}
> > -
> > -	td->ts.nr_zone_resets +=3D ze - zb;
> > -
> > -	return ret;
> > -}
> > -
> >  static unsigned int zbd_zone_nr(struct zoned_block_device_info
> *zbd_info,
> >  				struct fio_zone_info *zone)
> >  {
> > @@ -735,10 +687,36 @@ static unsigned int zbd_zone_nr(struct
> zoned_block_device_info *zbd_info,
> >  static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
> >  			  struct fio_zone_info *z)
> >  {
> > +	uint64_t offset =3D z->start;
> > +	uint64_t length =3D (z+1)->start - offset;
> > +	int ret =3D 0;
> > +
> > +	assert(is_valid_offset(f, offset + length - 1));
> > +
> >  	dprint(FD_ZBD, "%s: resetting wp of zone %u.\n", f->file_name,
> >  		zbd_zone_nr(f->zbd_info, z));
> > +	switch (f->zbd_info->model) {
> > +	case ZBD_HOST_AWARE:
> > +	case ZBD_HOST_MANAGED:
> > +		ret =3D zbd_reset_wp(td, f, offset, length);
> > +		if (ret < 0)
> > +			return ret;
> > +		break;
> > +	default:
> > +		break;
> > +	}
> >
> > -	return zbd_reset_range(td, f, z->start, zbd_zone_end(z) - z->start);
> > +	pthread_mutex_lock(&z->mutex);
>=20
> Your change is not affecting the locking model, but I wonder if it would =
not
> be
> better to lock the zone before calling zbd_reset_wp() so that the device =
side
> zone reset and the update "z->wp =3D z->start" are atomically executed...

I am seeing that zbd_reset_zone() is always called with the zone already lo=
cked
and we can remove that locking inside this function (need to add a note in =
the
description that the caller must hold z->mutex). Overall, the additional ch=
ange is

--- a/zbd.c
+++ b/zbd.c
@@ -691,24 +691,26 @@ static int zbd_reset_zone(struct thread_data *td, str=
uct fio_file *f,

        dprint(FD_ZBD, "%s: resetting wp of zone %u.\n", f->file_name,
                zbd_zone_nr(f->zbd_info, z));
+
+       pthread_mutex_lock(&f->zbd_info->mutex);
+
        switch (f->zbd_info->model) {
        case ZBD_HOST_AWARE:
        case ZBD_HOST_MANAGED:
                ret =3D zbd_reset_wp(td, f, offset, length);
-               if (ret < 0)
+               if (ret < 0) {
+                       pthread_mutex_unlock(&f->zbd_info->mutex);
                        return ret;
+               }
                break;
        default:
                break;
        }

-       pthread_mutex_lock(&z->mutex);
-       pthread_mutex_lock(&f->zbd_info->mutex);
        f->zbd_info->sectors_with_data -=3D z->wp - z->start;
        pthread_mutex_unlock(&f->zbd_info->mutex);
        z->wp =3D z->start;
        z->verify_block =3D 0;
-       pthread_mutex_unlock(&z->mutex);

        td->ts.nr_zone_resets++;

I tried this now and I don't see any problems. This probably needs to be a =
separate
patch. I can add it to this series. What do you suggest?

>=20
> > +	pthread_mutex_lock(&f->zbd_info->mutex);
> > +	f->zbd_info->sectors_with_data -=3D z->wp - z->start;
> > +	pthread_mutex_unlock(&f->zbd_info->mutex);
> > +	z->wp =3D z->start;
> > +	z->verify_block =3D 0;
> > +	pthread_mutex_unlock(&z->mutex);
> > +
> > +	td->ts.nr_zone_resets++;
> > +
> > +	return ret;
> >  }
> >
> >  /* The caller must hold f->zbd_info->mutex */
> >
>=20
> Anyway, since there does not seem to be any problem with the current
> locking
> scheme, looks good.
>=20
> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
>=20
> --
> Damien Le Moal
> Western Digital Research

