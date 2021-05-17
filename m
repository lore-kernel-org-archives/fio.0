Return-Path: <prvs=764a2290c=Niklas.Cassel@wdc.com>
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: Re: [PATCH 3/4] ioengines: add get_max_open_zones zoned block device
 operation
Date: Mon, 17 May 2021 08:43:24 +0000
Message-ID: <YKIsq+CLcuayfDTU@x1-carbon.lan>
References: <20210512223615.17239-1-Niklas.Cassel@wdc.com>
 <20210512223615.17239-4-Niklas.Cassel@wdc.com>
 <DM6PR04MB7081E5A56B9868AB2A259076E7519@DM6PR04MB7081.namprd04.prod.outlook.com>
 <YJ5njpKY5vPotYpi@x1-carbon.lan>
 <bfbc867cf61e97eaf8b831bfa5bcd453382a2982.camel@wdc.com>
In-Reply-To: <bfbc867cf61e97eaf8b831bfa5bcd453382a2982.camel@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D9C0B7D608D0154DB019194339A29B80@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On Sat, May 15, 2021 at 01:16:00AM +0000, Damien Le Moal wrote:
> On Fri, 2021-05-14 at 12:05 +0000, Niklas Cassel wrote:
> > On Thu, May 13, 2021 at 12:23:59AM +0000, Damien Le Moal wrote:
> > > On 2021/05/13 7:37, Niklas Cassel wrote:
> > > > From: Niklas Cassel <niklas.cassel@wdc.com>
> > > >=20
> > > > Define a new IO engine operation to get the maximum number of open =
zones.
> > > > Like the existing IO engine operations: .get_zoned_model, .report_z=
ones,
> > > > and .reset_wp, this new IO engine operation is only valid for zoned=
 block
> > > > devices.
> > > >=20
> > > > Similarly to the other zbd IO engine operations, also provide a def=
ault
> > > > implementation inside oslib/linux-blkzoned.c that will be used if t=
he
> > > > ioengine does not override it.
> > > >=20
> > > > The default Linux oslib implementation is implemented similarly to
> > > > blkzoned_get_zoned_model(), i.e. it will return a successful error =
code
> > > > even when the sysfs attribute does not exist.
> > > > This is because the sysfs max_open_zones attribute was introduced f=
irst
> > > > in Linux v5.9.
> > > > All error handling is still there, so an ioengine that provides its=
 own
> > > > implementation will still have its error code respected properly.
> > > >=20
> > > > Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> > > > ---

(snip)

> That said, there is a refinement needed I think, which is to ignore the d=
rive
> advertised max_open_zones if max_active_zones is 0.
>=20
> The reason is that for SMR drives, the max_open_zones limit is only meani=
ngful
> in the context of explicit zone open which fio does not do. For implicit =
zone
> open as used in fio, there will be no IO error for a write workload that
> simultaneously writes to more than max_open_zones since max_active_zones =
is
> always 0 (no limit) with SMR.
>=20
> Having the ability to run workloads that write to more than max_open_zone=
s is
> useful to measure the potential impact on performance of the drive implic=
it
> zone close & implicit zone open triggered by such workload.
>=20
> So I would suggest we change to something like this:
>=20
> 	if (!td->o.max_open_zones && f->zbd_info->max_active_zones) {
> 		/* User did not request a limit. Set limit to max supported
> */		zbd->max_open_zones =3D max_open_zones;
> 	} else if (td->o.max_open_zones < max_open_zones) {
> 		/* User requested a limit, limit is not too large */
> 		zbd->max_open_zones =3D td->o.max_open_zones;
> 	} else if (f->zbd_info->max_active_zones) {
> 		/* User requested a limit, but limit is too large */
> 		...
> 		return -EINVAL;
> 	}
>=20
> Thoughts ?

Even on a zoned block device with max active zones =3D=3D 0, with a max ope=
n
zones limit !=3D 0, writing to more zones than supported will, in addition
to the regular I/O, cause implicit open + implicit closed operations.

These operations will of course take time, time that would otherwise be
spent on I/O, meaning that the results you get would not be representative
of a drive's performance.

While I do agree that this test scenario could be benificial, I do think
that it is a very special type of test.

These patches have been merged already, but I don't see why you can't make
a patch that e.g. adds an ioengine that just opens (imp/exp) + closes zones=
.
(We had a filedelete ioengine merged recently, which tests how quickly
files than be unlinked.)
Or, if it is easier, you could add a new option to zbd.c --ignore_zbd_limit=
s,
so that you can specify an max open zones limit that is greater than what
the drive supports, in order to facilitate your test scenario.



Reasoning for my suggestion:
1) As you know, fio currently has no accounting of active zones.
It seems a bit awkward to parse max active zones from sysfs, when zbd.c
itself currently has no concept of active zones.
So it seems easier to e.g. add a new parameter that just ignores the device
limits, than to implement full support for active zones.

2) You are using detailed knowledge of how fio handles zones.
It does happen that fio currently uses writes without first doing an explic=
it
open zone, but should you really take that for granted?
If fio adds support for active zones, perhaps that implementation will chos=
e
to do implement it using explicit zone open, so that if the zone could be
opened, it will also be possible to write to that zone without I/O errors.
(As we have implemented in e.g. zonefs.)


Kind regards,
Niklas=

