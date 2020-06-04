Return-Path: <prvs=4173444a1=shinichiro.kawasaki@wdc.com>
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH] zbd: Fix max_open_zones checks
Date: Thu, 4 Jun 2020 01:43:33 +0000
Message-ID: <20200604014332.7hbgd56mheubo3wm@shindev.dhcp.fujisawa.hgst.com>
References: <20200527012013.87661-1-shinichiro.kawasaki@wdc.com>
 <CY4PR04MB3751A9C8F6D26E8E6D9794DFE7B10@CY4PR04MB3751.namprd04.prod.outlook.com>
In-Reply-To: 
 <CY4PR04MB3751A9C8F6D26E8E6D9794DFE7B10@CY4PR04MB3751.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C784FCD90F5D784F94538504568075A4@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Alexey Dobriyan <adobriyan@gmail.com>
List-ID: <fio@vger.kernel.org>

On May 27, 2020 / 03:50, Damien Le Moal wrote:
> On 2020/05/27 10:20, Shin'ichiro Kawasaki wrote:
> > Commit 219c662d3b12 ("zbd: introduce per job maximum open zones limit")
> > introduced job_max_open_zones option which limits the number of open
> > zones per job. It has similar role as max_open_zones option which limit=
s
> > the number of open zones for all jobs. It was intended that these two
> > options both work, but the commit replaced some checks for max_open_zon=
es
> > simply with checks for job_max_open_zones. Because of this, when
> > max_open_zones is set and job_max_open_zones is not set, fio fails to
> > limit the number of open zones. This resulted in test case #29 failure
> > of t/zbd/test-zbd-support script for regular null_blk devices.
> >=20
> > To fix the failure, modify the checks to target both job_max_open_zones
> > and max_open_zones.
> >=20
> > Fixes: 219c662d3b12 ("zbd: introduce per job maximum open zones limit")
> > Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > ---
> >  zbd.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/zbd.c b/zbd.c
> > index 72352db0..2a725c1f 100644
> > --- a/zbd.c
> > +++ b/zbd.c
> > @@ -997,7 +997,7 @@ static struct fio_zone_info *zbd_convert_to_open_zo=
ne(struct thread_data *td,
> > =20
> >  	assert(is_valid_offset(f, io_u->offset));
> > =20
> > -	if (td->o.job_max_open_zones) {
> > +	if (td->o.max_open_zones || td->o.job_max_open_zones) {
> >  		/*
> >  		 * This statement accesses f->zbd_info->open_zones[] on purpose
> >  		 * without locking.
> > @@ -1026,7 +1026,7 @@ static struct fio_zone_info *zbd_convert_to_open_=
zone(struct thread_data *td,
> > =20
> >  		zone_lock(td, f, z);
> >  		pthread_mutex_lock(&f->zbd_info->mutex);
> > -		if (td->o.job_max_open_zones =3D=3D 0)
> > +		if (td->o.max_open_zones =3D=3D 0 && td->o.job_max_open_zones =3D=3D=
 0)
> >  			goto examine_zone;
> >  		if (f->zbd_info->num_open_zones =3D=3D 0) {
> >  			pthread_mutex_unlock(&f->zbd_info->mutex);
> > @@ -1082,7 +1082,7 @@ examine_zone:
> >  	}
> >  	dprint(FD_ZBD, "%s(%s): closing zone %d\n", __func__, f->file_name,
> >  	       zone_idx);
> > -	if (td->o.job_max_open_zones)
> > +	if (td->o.max_open_zones || td->o.job_max_open_zones)
> >  		zbd_close_zone(td, f, open_zone_idx);
> >  	pthread_mutex_unlock(&f->zbd_info->mutex);
> > =20
> >=20
>=20
> Looks good.
>=20
> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>

Jens,

Could you consider to pick up this fix for upstream? I think it is good to =
keep
the max_open_zones option behavior same as before to avoid confusions.

--=20
Best Regards,
Shin'ichiro Kawasaki=

