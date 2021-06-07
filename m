Return-Path: <prvs=785b62de8=Niklas.Cassel@wdc.com>
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: Re: [PATCH 3/4] zbd: remove zbd_zoned_model ZBD_IGNORE
Date: Mon, 7 Jun 2021 09:08:40 +0000
Message-ID: <YL3iF4mMpbLstc9k@x1-carbon>
References: <20210604121843.6047-1-Niklas.Cassel@wdc.com>
 <20210604121843.6047-4-Niklas.Cassel@wdc.com>
 <DM6PR04MB7081011B97A6223675F4EFE7E73A9@DM6PR04MB7081.namprd04.prod.outlook.com>
In-Reply-To: 
 <DM6PR04MB7081011B97A6223675F4EFE7E73A9@DM6PR04MB7081.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8BFB3E49BD07F240939D7B5DEAFFFA71@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Sat, Jun 05, 2021 at 12:48:31AM +0000, Damien Le Moal wrote:
> On 2021/06/04 21:18, Niklas Cassel wrote:
> > From: Niklas Cassel <niklas.cassel@wdc.com>
> >=20
> > For a job with zonemode=3Dzbd, we do not want any file to be ignored.
> > Each file's file type in that job should be supported by either zbd.c
> > or the ioengine. If not, we should return an error.
> > This way, ZBD_IGNORE becomes redundant and can be removed.
> >=20
> > By removing ZBD_IGNORE, we know that all files belonging to a job that
> > has zonemode=3Dzbd set, will either be a zoned block device, or emulate
> > a zoned block device.
> >=20
> > This means that for jobs that have zonemode=3Dzbd, f->zbd_info will alw=
ays
> > be non-NULL. This will make the zbd code slightly easier to reason abou=
t
> > and to maintain.
> >=20
> > When removing zbd_zoned_model ZBD_IGNORE, define the new first enum val=
ue
> > as 0x1, so that we avoid potential ABI problems with existing binaries.
> >=20
> > Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> > ---
> >  engines/libzbc.c            | 3 +--
> >  engines/skeleton_external.c | 1 -
> >  oslib/linux-blkzoned.c      | 3 +--
> >  zbd.c                       | 3 +--
> >  zbd_types.h                 | 7 +++----
> >  5 files changed, 6 insertions(+), 11 deletions(-)
> >=20
> > diff --git a/engines/libzbc.c b/engines/libzbc.c
> > index 3dde93db..c3551bec 100644
> > --- a/engines/libzbc.c
> > +++ b/engines/libzbc.c
> > @@ -181,8 +181,7 @@ static int libzbc_get_zoned_model(struct thread_dat=
a *td, struct fio_file *f,
> >  	int ret;
> > =20
> >  	if (f->filetype !=3D FIO_TYPE_BLOCK && f->filetype !=3D FIO_TYPE_CHAR=
) {
> > -		*model =3D ZBD_IGNORE;
> > -		return 0;
> > +		return -EINVAL;
> >  	}
>=20
> Please drop the curly brackets.
>=20
> > =20
> >  	ret =3D libzbc_open_dev(td, f, &ld);
> > diff --git a/engines/skeleton_external.c b/engines/skeleton_external.c
> > index c79b6f11..cff83a10 100644
> > --- a/engines/skeleton_external.c
> > +++ b/engines/skeleton_external.c
> > @@ -156,7 +156,6 @@ static int fio_skeleton_close(struct thread_data *t=
d, struct fio_file *f)
> >  /*
> >   * Hook for getting the zoned model of a zoned block device for zonemo=
de=3Dzbd.
> >   * The zoned model can be one of (see zbd_types.h):
> > - * - ZBD_IGNORE: skip regular files
> >   * - ZBD_NONE: regular block device (zone emulation will be used)
> >   * - ZBD_HOST_AWARE: host aware zoned block device
> >   * - ZBD_HOST_MANAGED: host managed zoned block device
> > diff --git a/oslib/linux-blkzoned.c b/oslib/linux-blkzoned.c
> > index 6f89ec6f..8cb9c53a 100644
> > --- a/oslib/linux-blkzoned.c
> > +++ b/oslib/linux-blkzoned.c
> > @@ -141,8 +141,7 @@ int blkzoned_get_zoned_model(struct thread_data *td=
, struct fio_file *f,
> >  	char *model_str =3D NULL;
> > =20
> >  	if (f->filetype !=3D FIO_TYPE_BLOCK) {
> > -		*model =3D ZBD_IGNORE;
> > -		return 0;
> > +		return -EINVAL;
> >  	}
>=20
> Please drop the curly brackets.
>=20
> Also, missing in this patch: zbd_verify_sizes() has a "if (!f->zbd_info)"=
 check
> which I think should be changed into an assert.

Hello Damien,

zbd_verify_sizes()
does a:

	for_each_td() {
		for_each_file() {
			if (!f->zbd_info)
				continue;	=09
		}
	}

Considering that this is a for_each_td(), which will iterate over all
threads in the job file, I disagree with this comment.

A job file can have one job with
zonemode=3Dzbd

and in the same job file, another job without zonemode=3Dzbd, which targets
a completely different device, so I do think that we need to keep the
continue here.


Kind regards,
Niklas=

