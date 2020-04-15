Return-Path: <prvs=367229425=shinichiro.kawasaki@wdc.com>
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH] zbd: Fix I/O direction adjustment step for random
 read/write
Date: Wed, 15 Apr 2020 03:05:28 +0000
Message-ID: <20200415030527.fuvrfjpjsdixz34q@shindev.dhcp.fujisawa.hgst.com>
References: <20200414100017.266406-1-shinichiro.kawasaki@wdc.com>
 <BY5PR04MB6900394C987DCB70F353B332E7DB0@BY5PR04MB6900.namprd04.prod.outlook.com>
 <BY5PR04MB6900A95BCDD74273505C5D17E7DB0@BY5PR04MB6900.namprd04.prod.outlook.com>
In-Reply-To: 
 <BY5PR04MB6900A95BCDD74273505C5D17E7DB0@BY5PR04MB6900.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3E26ABC1380E8448B98DBBC1CFCD8DEF@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Alexey Dobriyan <adobriyan@gmail.com>
List-ID: <fio@vger.kernel.org>

On Apr 15, 2020 / 01:09, Damien Le Moal wrote:
> On 2020/04/15 10:03, Damien Le Moal wrote:
> > On 2020/04/14 19:00, Shin'ichiro Kawasaki wrote:
> >> Commit fb0259fb ("zbd: Ensure first I/O is write for random read/write=
 to
> >> sequential zones") introduced a step to change direction of io_u from
> >> read to write when that is the first I/O of the random read/write
> >> workload to zoned block devices. However, such direction adjustment
> >> results in inconsistent I/O length when read block size and write bloc=
k
> >> size are different.
> >>
> >> To avoid the inconsistency between I/O direction and I/O length,
> >> adjust the I/O direction before the I/O length is set. Move the step
> >> from zbd_adjust_block() to set_rw_ddir(). To minimize changes in
> >> set_rw_ddir(), introduce zbd_adjust_ddir() helper function.
> >>
> >> Fixes: fb0259fb ("zbd: Ensure first I/O is write for random read/write=
 to sequential zones")
> >> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> >> ---
> >>  io_u.c |  2 ++
> >>  zbd.c  | 34 ++++++++++++++++++++++++----------
> >>  zbd.h  |  2 ++
> >>  3 files changed, 28 insertions(+), 10 deletions(-)
> >>
> >> diff --git a/io_u.c b/io_u.c
> >> index 5d62a76c..234dd268 100644
> >> --- a/io_u.c
> >> +++ b/io_u.c
> >> @@ -746,6 +746,8 @@ static void set_rw_ddir(struct thread_data *td, st=
ruct io_u *io_u)
> >>  {
> >>  	enum fio_ddir ddir =3D get_rw_ddir(td);
> >> =20
> >> +	zbd_adjust_ddir(td, io_u, &ddir);
> >> +
> >>  	if (td_trimwrite(td)) {
> >>  		struct fio_file *f =3D io_u->file;
> >>  		if (f->last_pos[DDIR_WRITE] =3D=3D f->last_pos[DDIR_TRIM])
> >> diff --git a/zbd.c b/zbd.c
> >> index de0c5bf4..82810511 100644
> >> --- a/zbd.c
> >> +++ b/zbd.c
> >> @@ -1331,6 +1331,30 @@ void setup_zbd_zone_mode(struct thread_data *td=
, struct io_u *io_u)
> >>  	}
> >>  }
> >> =20
> >> +/**
> >> + * zbd_adjust_ddir - Adjust the I/O direction to zoned block devices.
> >=20
> > zbd_adjust_ddir - Adjust an I/O direction for zonemode=3Dzbd.

Thanks. Will rephrase as commented.

> >=20
> >> + *
> >> + * @td: FIO thread data.
> >> + * @io_u: FIO I/O unit.
> >> + * @ddir: Data direction to adjust.
> >> + */
> >> +void zbd_adjust_ddir(struct thread_data *td, struct io_u *io_u,
> >> +		     enum fio_ddir *ddir)
> >=20
> > Why use a pointer for ddir ? Simply have this function return an enum f=
io_ddir
> > similarly to what get_rw_ddir() does.
> >=20
> > enum fio_ddir zbd_adjust_ddir(struct thread_data *td, struct io_u *io_u=
,
> > 			      enum fio_ddir ddir)

Ok, it looks better to have simlairity with get_rw_ddir(). Will change as
suggested.

> >=20
> >> +{
> >> +	/*
> >> +	 * In case read direction is chosen for the first random I/O, fio wi=
th
> >> +	 * zonemode=3Dzbd stops because no data can be read from zoned block
> >> +	 * devices with all empty zones. Overwrite the first I/O direction a=
s
> >> +	 * write to make sure data to read exists.
> >> +	 */
> >> +	if (td->o.zone_mode =3D=3D ZONE_MODE_ZBD &&
> >> +	    td_rw(td) &&
> >> +	    *ddir =3D=3D DDIR_READ &&
> >> +	    !io_u->file->zbd_info->sectors_with_data &&
> >> +	    !td->o.read_beyond_wp)
> >> +		*ddir =3D DDIR_WRITE;
> >=20
> > Aouch. Really long condition... This is bad for performance for cases t=
hat do
> > not care about zonemode=3Dzbd. I think it is much better to split this =
and return
> > early for the cases that do not need change. So something like:
> >=20
> > enum fio_ddir zbd_adjust_ddir(struct thread_data *td, struct io_u *io_u=
,
> > 			      enum fio_ddir ddir)
> > {
> > 	if (td->o.zone_mode !=3D ZONE_MODE_ZBD ||
> > 	    ddir !=3D DDIR_READ)
> > 		return ddir;
> >=20
> > 	if (io_u->file->zbd_info->sectors_with_data ||
> > 	    td->o.read_beyond_wp)
> > 		return DDIR_READ;
> >=20
> > 	return DDIR_WRITE;
> > }
> >=20
> > That is a lot more readable in my opinion.
>=20
> Forgot to carry over your explanation comment. Better include it as that
> clarifies the code and why the change in direction is needed.

Thanks. Will modify the function as suggested keeping the comment. I think =
check
with td_rw() is required also to ensure that the workload mixes the read an=
d
write. I'll include it in the first if group.

>=20
> >=20
> >> +}
> >> +
> >>  /**
> >>   * zbd_adjust_block - adjust the offset and length as necessary for Z=
BD drives
> >>   * @td: FIO thread data.
> >> @@ -1364,16 +1388,6 @@ enum io_u_action zbd_adjust_block(struct thread=
_data *td, struct io_u *io_u)
> >>  	if (!zbd_zone_swr(zb))
> >>  		return io_u_accept;
> >> =20
> >> -	/*
> >> -	 * In case read direction is chosen for the first random I/O, fio wi=
th
> >> -	 * zonemode=3Dzbd stops because no data can be read from zoned block
> >> -	 * devices with all empty zones. Overwrite the first I/O direction a=
s
> >> -	 * write to make sure data to read exists.
> >> -	 */
> >> -	if (td_rw(td) && !f->zbd_info->sectors_with_data
> >> -	    && !td->o.read_beyond_wp)
> >> -		io_u->ddir =3D DDIR_WRITE;
> >> -
> >>  	/*
> >>  	 * Accept the I/O offset for reads if reading beyond the write point=
er
> >>  	 * is enabled.
> >> diff --git a/zbd.h b/zbd.h
> >> index 4eaf902e..196853ab 100644
> >> --- a/zbd.h
> >> +++ b/zbd.h
> >> @@ -82,6 +82,8 @@ int zbd_init(struct thread_data *td);
> >>  void zbd_file_reset(struct thread_data *td, struct fio_file *f);
> >>  bool zbd_unaligned_write(int error_code);
> >>  void setup_zbd_zone_mode(struct thread_data *td, struct io_u *io_u);
> >> +void zbd_adjust_ddir(struct thread_data *td, struct io_u *io_u,
> >> +		     enum fio_ddir *ddir);
> >>  enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u=
 *io_u);
> >>  char *zbd_write_status(const struct thread_stat *ts);
> >> =20
> >>
> >=20
> >=20
>=20
>=20
> --=20
> Damien Le Moal
> Western Digital Research
>=20

--=20
Best Regards,
Shin'ichiro Kawasaki=

