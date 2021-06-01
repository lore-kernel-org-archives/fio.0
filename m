Return-Path: <prvs=7797843ad=Niklas.Cassel@wdc.com>
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: Re: [PATCH 1/3] t/zbd: Use max_open_zones that fio fetched from
 device
Date: Tue, 1 Jun 2021 07:15:06 +0000
Message-ID: <YLXeeGfTOGa1xN/A@x1-carbon>
References: <20210601064753.734892-1-shinichiro.kawasaki@wdc.com>
 <20210601064753.734892-2-shinichiro.kawasaki@wdc.com>
 <DM6PR04MB7081B85BD9106F0824A9F8C5E73E9@DM6PR04MB7081.namprd04.prod.outlook.com>
In-Reply-To: 
 <DM6PR04MB7081B85BD9106F0824A9F8C5E73E9@DM6PR04MB7081.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C3D32974C99E514DA59E2C8E8C71E2F9@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

On Tue, Jun 01, 2021 at 07:01:18AM +0000, Damien Le Moal wrote:
> On 2021/06/01 15:48, Shin'ichiro Kawasaki wrote:
> > Recent commit d2f442bc0bd5 ("ioengines: add get_max_open_zones zoned
> > block device operation") modified fio to compare --max_open_zoned optio=
n
>=20
> s/max_open_zoned/max_open_zones
>=20
> > value and max_open_zones reported by the device. The device limit is
> > fetched through sysfs or through an ioengine specific implementation.
> >=20
> > The test script currently try to fetch the max open zones limit using
> > libzbc tools or sg_inq. If either of these fail, default value 128 is
> > supplied. This default value can be too high when the test script is
> > run for certain zoned block devices, and can therefore result in fio
> > error and test case failure.
>=20
> If sysfs has the max_open_zones attribute file present, that value should=
 be
> retrieved first. libzbc and sg_inq should be used only if the sysfs attri=
bute is
> not present, that is, when running on older kernels.

Since we can assume that the test script and fio versions are updated in sy=
nc,
I don't see any point of duplicating the sysfs parsing in the test script.

If the test script either specifies --max_open_zones=3D0 or omits the param=
eter,
fio itself will either parse sysfs, or use libzbc to fetch the max limit.

So I think that the test script should only use those "methods" that fio
itself can't do.
Right now fio can parse sysfs and use libzbc.
The only remaining method is sg_inq. This only I assume that we want to
keep in the test. (I guess the alternative is to implement the
.get_max_open_zones() fio ioengine callback in engines/sg.c, that does
the same. But we probably don't want to do that, right?)

>=20
> >=20
> > To avoid the failure, modify the default value used in the test script
> > from 128 to 0. With this, --max_open_zoned=3D0 is passed to fio, and it
> > makes fio use the max_open_zones reported by the device.
>=20
> Why pass anything at all since now fio will use the device reported limit=
 by
> default if the user does not specify anything ?

Sure, we can just omit the --max_open_zones parameter completely.
That might be more clear.

>=20
> >=20
> > Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > ---
> >  t/zbd/functions | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/t/zbd/functions b/t/zbd/functions
> > index 40ffe1de..1a7ea970 100644
> > --- a/t/zbd/functions
> > +++ b/t/zbd/functions
> > @@ -180,8 +180,8 @@ max_open_zones() {
> >  	if ! ${sg_inq} -e --page=3D0xB6 --len=3D20 --hex "$dev" \
> >  		 > /dev/null 2>&1; then
> >  	    # Non scsi device such as null_blk can not return max open zones.
>=20
> This comment is a little outdated since even nullblk now has a limit expo=
sed
> through sysfs (the limit may be 0 =3D=3D no limit). See above comment. sy=
sfs should
> be the first thing to look at.
>=20
> > -	    # Use default value.
> > -	    echo 128
> > +	    # Specify 0 to indicate fio to get max open zones from the device=
.
> > +	    echo 0
> >  	else
> >  	    ${sg_inq} -e --page=3D0xB6 --len=3D20 --hex "$dev" | tail -1 |
> >  		{
> >=20
>=20
>=20
> --=20
> Damien Le Moal
> Western Digital Research
> =

