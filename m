Return-Path: <prvs=84353bb0d=shinichiro.kawasaki@wdc.com>
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH 3/4] engines/libzbc: Enable trim for libzbc I/O engine
Date: Wed, 4 Aug 2021 06:39:05 +0000
Message-ID: <20210804063905.cq3xjq2szt3ptnax@shindev>
References: <20210728104752.923770-1-shinichiro.kawasaki@wdc.com>
 <20210728104752.923770-4-shinichiro.kawasaki@wdc.com>
 <596b2e633684d7bdef9652854481096994b82149.camel@wdc.com>
In-Reply-To: <596b2e633684d7bdef9652854481096994b82149.camel@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <692075CDE443424B8144C94087DB3494@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>, Damien Le Moal <Damien.LeMoal@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>
List-ID: <fio@vger.kernel.org>

On Aug 03, 2021 / 19:36, Dmitry Fomichev wrote:
> On Wed, 2021-07-28 at 19:47 +0900, Shin'ichiro Kawasaki wrote:
> > The trim workload to zoned block devices is supported as zone reset,
> > and
> > this feature is available for I/O engines which support both zoned
> > devices and trim workload. Libzbc I/O engine supports zoned but lacks
> > trim workload support. To enable trim support with libzbc I/O engine,
> > remove the check which inhibited trim from requests to libzbc I/O
> > engine. Also set file open flags for trim same as write, and call
> > zbd_do_io_u_trim() for trim I/O.
> >=20
> > Of note is that libzbc I/O engine now can support trim to sequential
> > write required zones, but still can not support os_trim() call and
> > BLKDISCARD ioctl for the conventional zones. The trim I/Os to
> > conventional zones are reported as an error.
> >=20
> > Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > ---
> > =A0engines/libzbc.c | 16 ++++++++++------
> > =A01 file changed, 10 insertions(+), 6 deletions(-)
> >=20
> > diff --git a/engines/libzbc.c b/engines/libzbc.c
> > index 7f2bc431..5b4c5e8e 100644
> > --- a/engines/libzbc.c
> > +++ b/engines/libzbc.c
> > @@ -14,6 +14,7 @@
> > =A0#include "fio.h"
> > =A0#include "err.h"
> > =A0#include "zbd_types.h"
> > +#include "zbd.h"
> > =A0
> > =A0struct libzbc_data {
> > =A0=A0=A0=A0=A0=A0=A0=A0struct zbc_device=A0=A0=A0=A0=A0=A0=A0*zdev;
> > @@ -63,7 +64,7 @@ static int libzbc_open_dev(struct thread_data *td,
> > struct fio_file *f,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -EINVAL;
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0
> > -=A0=A0=A0=A0=A0=A0=A0if (td_write(td)) {
> > +=A0=A0=A0=A0=A0=A0=A0if (td_write(td) || td_trim(td)) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!read_only)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0flags |=3D O_RDWR;
> > =A0=A0=A0=A0=A0=A0=A0=A0} else if (td_read(td)) {
> > @@ -71,10 +72,6 @@ static int libzbc_open_dev(struct thread_data *td,
> > struct fio_file *f,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0flags |=3D O_RDWR;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0else
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0flags |=3D O_RDONLY;
> > -=A0=A0=A0=A0=A0=A0=A0} else if (td_trim(td)) {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0td_verror(td, EINVAL, "li=
bzbc does not support
> > trim");
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0log_err("%s: libzbc does =
not support trim\n", f-
> > >file_name);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -EINVAL;
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0if (td->o.oatomic) {
> > @@ -411,7 +408,14 @@ static enum fio_q_status libzbc_queue(struct
> > thread_data *td, struct io_u *io_u)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret =3D zbc_flush(ld->z=
dev);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (ret)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0log_err("zbc_flush error %zd\n", ret);
> > -=A0=A0=A0=A0=A0=A0=A0} else if (io_u->ddir !=3D DDIR_TRIM) {
> > +=A0=A0=A0=A0=A0=A0=A0} else if (io_u->ddir =3D=3D DDIR_TRIM) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret =3D zbd_do_io_u_trim(=
td, io_u);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!ret) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0l=
og_err("libzbc does not support trim to "
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0"conventional zones\n");
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
et =3D EINVAL;
>=20
> Wouldn't that be more appropriate to just call os_trim() here and avoid
> this error? This way, any ZBD trim workload that succeeds without using
> libzbc would also succeed with using this engine... not the case with
> the code above.

os_trim() for Linux calls BLKDISCARD ioctl, which does not work for SG node=
.
Then, os_trim() call is not appropriate here.

One point to improve is the log_err() message I added. "Trim" and
"Conventional zone" does not have relation, then the message is confusing.
The error message is too much, probably. I will remove it and just return
EINVAL.

>=20
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0} else {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0log_err("Unsupported op=
eration %u\n", io_u->ddir);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret =3D -EINVAL;
> > =A0=A0=A0=A0=A0=A0=A0=A0}
>=20

--=20
Best Regards,
Shin'ichiro Kawasaki=

