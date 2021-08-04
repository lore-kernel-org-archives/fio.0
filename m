Return-Path: <prvs=84353bb0d=shinichiro.kawasaki@wdc.com>
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH 2/4] zbd: Support zone reset by trim
Date: Wed, 4 Aug 2021 06:32:14 +0000
Message-ID: <20210804063213.f7r7enkhn74rb2qa@shindev>
References: <20210728104752.923770-1-shinichiro.kawasaki@wdc.com>
 <20210728104752.923770-3-shinichiro.kawasaki@wdc.com>
 <c64f93bcd740905a63ef4b8eeb05a13bdd67d275.camel@wdc.com>
In-Reply-To: <c64f93bcd740905a63ef4b8eeb05a13bdd67d275.camel@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <7DA918EB2BCA99468E59F2DFDC311336@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>, Damien Le Moal <Damien.LeMoal@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>
List-ID: <fio@vger.kernel.org>

Dmitry, thank you for the review comments.

On Aug 03, 2021 / 19:36, Dmitry Fomichev wrote:
> On Wed, 2021-07-28 at 19:47 +0900, Shin'ichiro Kawasaki wrote:
> > Enable trim workload for zonemode=3Dzbd by modifying do_io_u_trim() to
> > call zoned block device unique function zbd_do_io_u_trim() which resets
> > target zone. This allows fio to emulate workloads which mix data
> > read/write and zone resets with zonemode=3Dzbd.
> >=20
> > To call reset zones, the trim I/O shall have offset aligned to zone
> > start and block size same as zone size. Reset zone is called only to
> > sequential write required zones and sequential write preferred zones.
> > Conventional zones are handled in same manner as regular block devices
> > by calling os_trim() function.
> >=20
> > When zones are reset with random trim workload, choose only non-empty
> > zones as trim target. This avoids meaningless trim to empty zones and
> > makes the workload more realistic. To find the non-empty zones, utilize
> > zbd_find_zone() helper function which is already used for read
> > workload,
> > specifying 1 byte as the minimum valid data size.
> >=20
> > Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > ---
> > =A0HOWTO=A0 |=A0 3 +++
> > =A0fio.1=A0 |=A0 2 ++
> > =A0io_u.c |=A0 9 ++++++++
> > =A0zbd.c=A0 | 71 ++++++++++++++++++++++++++++++++++++++++++++++++++++++=
----
> > =A0zbd.h=A0 |=A0 2 ++
> > =A05 files changed, 83 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/HOWTO b/HOWTO
> > index 59c7f1ff..f1fd2045 100644
> > --- a/HOWTO
> > +++ b/HOWTO
> > @@ -992,6 +992,9 @@ Target file/device
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0single zone. The :option:`zoneskip`
> > parameter
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0is ignored. :option:`zonerange` and
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0:option:`zonesize` must be identical.
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0Trim is handled using a zone reset
> > operation.
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0Trim only considers non-empty
> > sequential write
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0required and sequential write preferred
> > zones.
>=20
> The documentation changes could be moved to a separate patch. While
> looking at HOWTO file, I notice that libzbc is absent from the list of
> i/o engines there. Perhaps, since you are making changes to this file,
> you could add a small description of libzbc there and mention that it
> supports read, write and trim workloads when run against zoned block
> devices.

Okay, I will separate out changes in HOWTO and fio.1 into a patch. Will
add the description of libzbc i/o engine also.

>=20
> > =A0
> > =A0.. option:: zonerange=3Dint
> > =A0
> > diff --git a/fio.1 b/fio.1
> > index 6cc82542..ef319062 100644
> > --- a/fio.1
> > +++ b/fio.1
> > @@ -766,6 +766,8 @@ starts. The \fBzonecapacity\fR parameter is
> > ignored.
> > =A0Zoned block device mode. I/O happens sequentially in each zone, even
> > if random32ad4373
> > =A0I/O has been selected. Random I/O happens across all zones instead o=
f
> > being
> > =A0restricted to a single zone.
> > +Trim is handled using a zone reset operation. Trim only considers non-
> > empty
> > +sequential write required and sequential write preferred zones.
> > =A0.RE
> > =A0.RE
> > =A0.TP
> > diff --git a/io_u.c b/io_u.c
> > index 9a1cd547..696d25cd 100644
> > --- a/io_u.c
> > +++ b/io_u.c
> > @@ -2317,10 +2317,19 @@ int do_io_u_trim(const struct thread_data *td,
> > struct io_u *io_u)
> > =A0=A0=A0=A0=A0=A0=A0=A0struct fio_file *f =3D io_u->file;
> > =A0=A0=A0=A0=A0=A0=A0=A0int ret;
> > =A0
> > +=A0=A0=A0=A0=A0=A0=A0if (td->o.zone_mode =3D=3D ZONE_MODE_ZBD) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret =3D zbd_do_io_u_trim(=
td, io_u);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (ret =3D=3D io_u_compl=
eted)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eturn io_u->xfer_buflen;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (ret)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0g=
oto err;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +
> > =A0=A0=A0=A0=A0=A0=A0=A0ret =3D os_trim(f, io_u->offset, io_u->xfer_buf=
len);
> > =A0=A0=A0=A0=A0=A0=A0=A0if (!ret)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return io_u->xfer_bufle=
n;
> > =A0
> > +err:
> > =A0=A0=A0=A0=A0=A0=A0=A0io_u->error =3D ret;
> > =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > =A0#endif
> > diff --git a/zbd.c b/zbd.c
> > index f10b3267..39060ecd 100644
> > --- a/zbd.cpassing in an offset
>         modifier with a value of 8. If the suffix is used with a
> sequential I/O

I did not catch this part. May I ask to rephrase?

>=20
> > +++ b/zbd.c
> > @@ -375,12 +375,24 @@ static bool zbd_verify_bs(void)
> > =A0=A0=A0=A0=A0=A0=A0=A0int i, j, k;
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0for_each_td(td, i) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (td_trim(td) &&
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (td->o.min_bs[D=
DIR_TRIM] !=3D td-
> > >o.max_bs[DDIR_TRIM] ||
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 td->o.bsspli=
t_nr[DDIR_TRIM])) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0l=
og_info("bsrange and bssplit is not allowed
> > for trim with zonemode=3Dzbd\n");
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eturn false;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0for_each_file(td, f, j)=
 {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0uint64_t zone_size;
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0if (!f->zbd_info)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0continue;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0zone_size =3D f->zbd_info->zone_size;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (td_trim(td) && td->o.bs[DDIR_TRIM] !=3D
> > zone_size) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0log_info("%s: trim block size %llu is
> > not the zone size %llu\n",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 f->file_name, td-
> > >o.bs[DDIR_TRIM],
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (unsigned long
> > long)zone_size);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0return false;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0for (k =3D 0; k < FIO_ARRAY_SIZE(td->o.bs);
> > k++) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0if (td->o.verify !=3D VERIFY_NONE &&
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 zone_size % td->o.bs[k] !=3D 0) {
> > @@ -1528,9 +1540,6 @@ static void zbd_queue_io(struct thread_data
> > *td, struct io_u *io_u, int q,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_mutex_unlock(&z=
bd_info->mutex);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0z->wp =3D zone_end;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> > -=A0=A0=A0=A0=A0=A0=A0case DDIR_TRIM:
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0assert(z->wp =3D=3D z->st=
art);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> > =A0=A0=A0=A0=A0=A0=A0=A0default:
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > @@ -1910,8 +1919,23 @@ enum io_u_action zbd_adjust_block(struct
> > thread_data *td, struct io_u *io_u)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0(zbd_zone_capacity_end(zb) - io_u->offset),
> > min_bs);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto eof;
> > =A0=A0=A0=A0=A0=A0=A0=A0case DDIR_TRIM:
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* fall-through */
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Check random trim targ=
ets a non-empty zone */
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!td_random(td) || zb-=
>wp > zb->start)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0g=
oto accept;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Find out a non-empty z=
one to trim */
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0zone_unlock(zb);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0zl =3D get_zone(f, f->max=
_zone);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0zb =3D zbd_find_zone(td, =
io_u, 1, zb, zl);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (zb) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
o_u->offset =3D zb->start;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0d=
print(FD_ZBD, "%s: found new zone(%lld) for
> > trim\n",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 f->file_name, io_u->offset);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0g=
oto accept;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto eof;
> > =A0=A0=A0=A0=A0=A0=A0=A0case DDIR_SYNC:
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* fall-through */
> > =A0=A0=A0=A0=A0=A0=A0=A0case DDIR_DATASYNC:
> > =A0=A0=A0=A0=A0=A0=A0=A0case DDIR_SYNC_FILE_RANGE:
> > =A0=A0=A0=A0=A0=A0=A0=A0case DDIR_WAIT:
> > @@ -1952,3 +1976,42 @@ char *zbd_write_status(const struct
> > thread_stat *ts)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return NULL;
> > =A0=A0=A0=A0=A0=A0=A0=A0return res;
> > =A0}
> > +
> > +/**
> > + * zbd_do_io_u_trim - If reset zone is applicable, do reset zone
> > instead of trim
> > + *
> > + * @td: FIO thread data.
> > + * @io_u: FIO I/O unit.
> > + *
> > + * It is assumed that z->mutex is already locked.
> > + * Return io_u_completed when reset zone succeeds. Return 0 when the
> > target zone
> > + * does not have write pointer. On error, return negative errno.
> > + */
> > +int zbd_do_io_u_trim(const struct thread_data *td, struct io_u
> > *io_u)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0struct fio_file *f =3D io_u->file;
> > +=A0=A0=A0=A0=A0=A0=A0struct fio_zone_info *z;
> > +=A0=A0=A0=A0=A0=A0=A0uint32_t zone_idx;
> > +=A0=A0=A0=A0=A0=A0=A0int ret;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0zone_idx =3D zbd_zone_idx(f, io_u->offset);
> > +=A0=A0=A0=A0=A0=A0=A0z =3D get_zone(f, zone_idx);
> > +
> > +=A0=A0=A0=A0=A0=A0=A0if (!z->has_wp)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0if (io_u->offset !=3D z->start) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0log_err("Trim offset not =
at zone start (%lld)\n",
> > io_u->offset);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -EINVAL;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +
> > +=A0=A0=A0=A0=A0=A0=A0/*
> > +=A0=A0=A0=A0=A0=A0=A0 * Cast td to drop const modifier so that zbd_res=
et_zone()
> > can change td
> > +=A0=A0=A0=A0=A0=A0=A0 * members.
> > +=A0=A0=A0=A0=A0=A0=A0 */
>=20
> This comment is not really necessary.

Will remove it. Thanks.

--=20
Best Regards,
Shin'ichiro Kawasaki

>=20
> > +=A0=A0=A0=A0=A0=A0=A0ret =3D zbd_reset_zone((struct thread_data *)td, =
f, z);
> > +=A0=A0=A0=A0=A0=A0=A0if (ret < 0)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return ret;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0return io_u_completed;
> > +}
> > diff --git a/zbd.h b/zbd.h
> > index 39dc45e3..0a73b41d 100644
> > --- a/zbd.h
> > +++ b/zbd.h
> > @@ -17,6 +17,7 @@ struct fio_file;
> > =A0enum io_u_action {
> > =A0=A0=A0=A0=A0=A0=A0=A0io_u_accept=A0=A0=A0=A0=A0=3D 0,
> > =A0=A0=A0=A0=A0=A0=A0=A0io_u_eof=A0=A0=A0=A0=A0=A0=A0=A0=3D 1,
> > +=A0=A0=A0=A0=A0=A0=A0io_u_completed=A0 =3D 2,
> > =A0};
> > =A0
> > =A0/**
> > @@ -99,6 +100,7 @@ enum fio_ddir zbd_adjust_ddir(struct thread_data
> > *td, struct io_u *io_u,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 enum fio_ddir ddir);
> > =A0enum io_u_action zbd_adjust_block(struct thread_data *td, struct
> > io_u *io_u);
> > =A0char *zbd_write_status(const struct thread_stat *ts);
> > +int zbd_do_io_u_trim(const struct thread_data *td, struct io_u
> > *io_u);
> > =A0
> > =A0static inline void zbd_close_file(struct fio_file *f)
> > =A0{
> =

