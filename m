Return-Path: <prvs=4936ee857=shinichiro.kawasaki@wdc.com>
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH 2/6] zbd: Initialize open zones list referring zone status
 at fio start
Date: Wed, 19 Aug 2020 12:51:12 +0000
Message-ID: <20200819125110.jftoc2nrlrl4mnb2@shindev.dhcp.fujisawa.hgst.com>
References: <20200813045724.47475-1-shinichiro.kawasaki@wdc.com>
 <20200813045724.47475-3-shinichiro.kawasaki@wdc.com>
 <5ad0ea307ae5bce0871bd6c8f329d66b0f9f2ba9.camel@wdc.com>
In-Reply-To: <5ad0ea307ae5bce0871bd6c8f329d66b0f9f2ba9.camel@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C7BB1DE596DF8847A1D5728C8BB8874B@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>, Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On Aug 15, 2020 / 00:06, Dmitry Fomichev wrote:
> On Thu, 2020-08-13 at 13:57 +0900, Shin'ichiro Kawasaki wrote:
> > When fio starts write workloads to zones with open status, fio does not
> > reflect the zone status to open zone list. This results in inconsistent
> > open zone accounting.
> >=20
> > To avoid this inconsistency, initialize the open zone list referring th=
e
> > zone status by calling zbd_open_zone() function before workload start.
> > Since io_u is not available at that timing, make the function
> > independent from io_u.
> >=20
> > Of note is that fio counts open zones within the write target range.
> > Open zones out of the range are not counted or checked.
> >=20
> > Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > ---
> >  zbd.c | 21 ++++++++++++++++-----
> >  1 file changed, 16 insertions(+), 5 deletions(-)
> >=20
> > diff --git a/zbd.c b/zbd.c
> > index 20f64b58..123d5530 100644
> > --- a/zbd.c
> > +++ b/zbd.c
> > @@ -627,6 +627,9 @@ static int zbd_init_zone_info(struct thread_data *t=
d, struct fio_file *file)
> >  	return ret;
> >  }
> > =20
> > +static bool zbd_open_zone(struct thread_data *td, const struct fio_fil=
e *f,
> > +			  uint32_t zone_idx);
> > +
> >  int zbd_setup_files(struct thread_data *td)
> >  {
> >  	struct fio_file *f;
> > @@ -650,6 +653,8 @@ int zbd_setup_files(struct thread_data *td)
> > =20
> >  	for_each_file(td, f, i) {
> >  		struct zoned_block_device_info *zbd =3D f->zbd_info;
> > +		struct fio_zone_info *z;
> > +		int zi;
> > =20
> >  		if (!zbd)
> >  			continue;
> > @@ -665,6 +670,13 @@ int zbd_setup_files(struct thread_data *td)
> >  			log_err("'max_open_zones' value is limited by %u\n", ZBD_MAX_OPEN_Z=
ONES);
> >  			return 1;
> >  		}
> > +
> > +		for (zi =3D f->min_zone; zi < f->max_zone; zi++) {
> > +			z =3D &zbd->zone_info[zi];
> > +			if (z->cond =3D=3D ZBD_ZONE_COND_IMP_OPEN ||
> > +			    z->cond =3D=3D ZBD_ZONE_COND_EXP_OPEN)
> > +				zbd_open_zone(td, f, zi);
> > +		}
>=20
> What if zbd->max_open_zones is set less than the number of the currently
> open zones in [max_zone:min_zone] range? In this case, the loop above wil=
l
> open more zones than needed. Maybe this part should be changed to somethi=
ng
> like the code below?
>=20
> +		int zi, noz;
> ...
> +		for (zi =3D f->min_zone, noz =3D 0; zi < f->max_zone; zi++) {
> +			z =3D &zbd->zone_info[zi];
> +			if (z->cond =3D=3D ZBD_ZONE_COND_IMP_OPEN ||
> +			    z->cond =3D=3D ZBD_ZONE_COND_EXP_OPEN) {
> +				if (noz < zbd->max_open_zones)
> +					zbd_open_zone(td, f, zi);
> +				else
> +					zbd_reset_zone(td, f, zi);
> +				noz++;
> +			}
> +		}
>

Thank you for catching this. As you suggest, I will add the code to reset z=
ones
when number of open zones exceeds the limits. The code will be little bit m=
ore
complicated to cover both max_open_zones and job_max_open_zones.

--=20
Best Regards,
Shin'ichiro Kawasaki=

