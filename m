Return-Path: <prvs=761aa9a9b=Niklas.Cassel@wdc.com>
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: Re: [PATCH 3/4] ioengines: add get_max_open_zones zoned block device
 operation
Date: Fri, 14 May 2021 12:05:35 +0000
Message-ID: <YJ5njpKY5vPotYpi@x1-carbon.lan>
References: <20210512223615.17239-1-Niklas.Cassel@wdc.com>
 <20210512223615.17239-4-Niklas.Cassel@wdc.com>
 <DM6PR04MB7081E5A56B9868AB2A259076E7519@DM6PR04MB7081.namprd04.prod.outlook.com>
In-Reply-To: 
 <DM6PR04MB7081E5A56B9868AB2A259076E7519@DM6PR04MB7081.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C2569EDDA5910843B648EC98536DEC8E@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Thu, May 13, 2021 at 12:23:59AM +0000, Damien Le Moal wrote:
> On 2021/05/13 7:37, Niklas Cassel wrote:
> > From: Niklas Cassel <niklas.cassel@wdc.com>
> >=20
> > Define a new IO engine operation to get the maximum number of open zone=
s.
> > Like the existing IO engine operations: .get_zoned_model, .report_zones=
,
> > and .reset_wp, this new IO engine operation is only valid for zoned blo=
ck
> > devices.
> >=20
> > Similarly to the other zbd IO engine operations, also provide a default
> > implementation inside oslib/linux-blkzoned.c that will be used if the
> > ioengine does not override it.
> >=20
> > The default Linux oslib implementation is implemented similarly to
> > blkzoned_get_zoned_model(), i.e. it will return a successful error code
> > even when the sysfs attribute does not exist.
> > This is because the sysfs max_open_zones attribute was introduced first
> > in Linux v5.9.
> > All error handling is still there, so an ioengine that provides its own
> > implementation will still have its error code respected properly.
> >=20
> > Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> > ---
> >  engines/skeleton_external.c | 13 ++++++
> >  ioengines.h                 |  4 +-
> >  oslib/blkzoned.h            |  7 +++
> >  oslib/linux-blkzoned.c      | 22 ++++++++++
> >  zbd.c                       | 87 ++++++++++++++++++++++++++++++++++---
> >  5 files changed, 127 insertions(+), 6 deletions(-)
> >=20
>=20
> 	if (!td->o.max_open_zones) {
> 		/* User did not request a limit. Set limit to max supported */
> 		zbd->max_open_zones =3D max_open_zones;
> 	} else if (td->o.max_open_zones < max_open_zones) {
> 		/* User requested a limit, limit is not too large */
> 		zbd->max_open_zones =3D td->o.max_open_zones;
> 	} else {
> 		/* User requested a limit, but limit is too large */
> 		...
> 		return -EINVAL;
> 	}
>=20
> > +
> > +out:
> > +	/* Ensure that the limit is not larger than FIO's internal limit */
> > +	zbd->max_open_zones =3D zbd->max_open_zones ?: ZBD_MAX_OPEN_ZONES;
> > +	dprint(FD_ZBD, "%s: using max open zones limit: %"PRIu32"\n",
> > +	       f->file_name, zbd->max_open_zones);
>=20
> It may be good to have a log_info() too here, no ?

Hello Damien,

Thank you for your review!

I don't have any problem with any of your review comments, except this one.

I'm not a fan on unconditionally printing the amount of max open zones bein=
g
used, so I think that keeping it for --debug=3Dzbd is fine.


1) If the user did specify a limit, why print the same limit as they reques=
ted?
2) If they did specify a limit that is too high, fio will exit with a print=
.

3) I guess we could print in the case where the user did not request a limi=
t,
and we implicitly set the limit to the device limit.

However, right now we don't have any zbd specific prints when starting fio,
e.g. when the user does not specify --zone_size, and we use zone size of
the drive.

So I don't think that actually using the max open zones that the drive
supports justifies a print, not even for case 3).


Kind regards,
Niklas=

