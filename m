Return-Path: <prvs=779e416ac=shinichiro.kawasaki@wdc.com>
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH 1/3] t/zbd: Use max_open_zones that fio fetched from
 device
Date: Tue, 1 Jun 2021 09:01:45 +0000
Message-ID: <20210601090145.e3lckhkj37qi4uwj@shindev.dhcp.fujisawa.hgst.com>
References: <20210601064753.734892-1-shinichiro.kawasaki@wdc.com>
 <20210601064753.734892-2-shinichiro.kawasaki@wdc.com>
 <DM6PR04MB7081B85BD9106F0824A9F8C5E73E9@DM6PR04MB7081.namprd04.prod.outlook.com>
 <YLXeeGfTOGa1xN/A@x1-carbon>
 <DM6PR04MB7081ADF2BC1F043F1A74B988E73E9@DM6PR04MB7081.namprd04.prod.outlook.com>
In-Reply-To: 
 <DM6PR04MB7081ADF2BC1F043F1A74B988E73E9@DM6PR04MB7081.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <540E1BC1AEC0984ABE45099AC36DF852@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: Niklas Cassel <Niklas.Cassel@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

On Jun 01, 2021 / 07:19, Damien Le Moal wrote:
> On 2021/06/01 16:15, Niklas Cassel wrote:
> > On Tue, Jun 01, 2021 at 07:01:18AM +0000, Damien Le Moal wrote:
> >> On 2021/06/01 15:48, Shin'ichiro Kawasaki wrote:
> >>> Recent commit d2f442bc0bd5 ("ioengines: add get_max_open_zones zoned
> >>> block device operation") modified fio to compare --max_open_zoned opt=
ion
> >>
> >> s/max_open_zoned/max_open_zones

Thanks. Will reflect.

> >>
> >>> value and max_open_zones reported by the device. The device limit is
> >>> fetched through sysfs or through an ioengine specific implementation.
> >>>
> >>> The test script currently try to fetch the max open zones limit using
> >>> libzbc tools or sg_inq. If either of these fail, default value 128 is
> >>> supplied. This default value can be too high when the test script is
> >>> run for certain zoned block devices, and can therefore result in fio
> >>> error and test case failure.
> >>
> >> If sysfs has the max_open_zones attribute file present, that value sho=
uld be
> >> retrieved first. libzbc and sg_inq should be used only if the sysfs at=
tribute is
> >> not present, that is, when running on older kernels.
> >=20
> > Since we can assume that the test script and fio versions are updated i=
n sync,
> > I don't see any point of duplicating the sysfs parsing in the test scri=
pt.
> >=20
> > If the test script either specifies --max_open_zones=3D0 or omits the p=
arameter,
> > fio itself will either parse sysfs, or use libzbc to fetch the max limi=
t.
>=20
> True. Unless the user is running the tests with some special max_open_zon=
es, we
> should not try to grab any value then.
>=20
> >=20
> > So I think that the test script should only use those "methods" that fi=
o
> > itself can't do.
> > Right now fio can parse sysfs and use libzbc.
> > The only remaining method is sg_inq. This only I assume that we want to
> > keep in the test. (I guess the alternative is to implement the
> > .get_max_open_zones() fio ioengine callback in engines/sg.c, that does
> > the same. But we probably don't want to do that, right?)
>=20
> No, we certainly do not. That would need a lot more code than that, e.g. =
to also
> detect zone model. That would mean basically re-implementing what libzbc =
does
> inside the sg engine. And since we now have the libzbc engine, I do not s=
ee the
> point.
>=20
> >=20
> >>
> >>>
> >>> To avoid the failure, modify the default value used in the test scrip=
t
> >>> from 128 to 0. With this, --max_open_zoned=3D0 is passed to fio, and =
it
> >>> makes fio use the max_open_zones reported by the device.
> >>
> >> Why pass anything at all since now fio will use the device reported li=
mit by
> >> default if the user does not specify anything ?
> >=20
> > Sure, we can just omit the --max_open_zones parameter completely.
> > That might be more clear.

I think still we need the --max_open_zones option in case the latest fio is
run on older kernel which does not have max_open_zones in sysfs. In such ca=
se,
fio is not able to obtain the correct max_open_zones of the device (unless =
it
uses libzbc I/O engine).

There are only two test cases which refers the max_open_zones that the test
script obtained: #31 and #32. The test case #31 has a check if the found
max_open_zones is zero or not to decide write target zone count. The
max_open_zones value is not used for --max_open_zones option (can not omit =
it).
As for the test case #32, it specifies "--max_open_zones=3D$max_open_zones"=
 to the
fio command. I assume this option is still valid and required for the older
kernels. We could add a check to the test script to specify this option onl=
y
when max_open_zones is zero, but I think it's the better not to add such ch=
eck
to keep the test script simpler.

> >=20
> >>
> >>>
> >>> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> >>> ---
> >>>  t/zbd/functions | 4 ++--
> >>>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/t/zbd/functions b/t/zbd/functions
> >>> index 40ffe1de..1a7ea970 100644
> >>> --- a/t/zbd/functions
> >>> +++ b/t/zbd/functions
> >>> @@ -180,8 +180,8 @@ max_open_zones() {
> >>>  	if ! ${sg_inq} -e --page=3D0xB6 --len=3D20 --hex "$dev" \
> >>>  		 > /dev/null 2>&1; then
> >>>  	    # Non scsi device such as null_blk can not return max open zone=
s.
> >>
> >> This comment is a little outdated since even nullblk now has a limit e=
xposed
> >> through sysfs (the limit may be 0 =3D=3D no limit). See above comment.=
 sysfs should
> >> be the first thing to look at.

Right. I will repharse as follows.

# Sg_inq can not get max_open_zones of non scsi devices.

> >>
> >>> -	    # Use default value.
> >>> -	    echo 128
> >>> +	    # Specify 0 to indicate fio to get max open zones from the devi=
ce.
> >>> +	    echo 0
> >>>  	else
> >>>  	    ${sg_inq} -e --page=3D0xB6 --len=3D20 --hex "$dev" | tail -1 |
> >>>  		{
> >>>
> >>
> >>
> >> --=20
> >> Damien Le Moal
> >> Western Digital Research
> >>
>=20
>=20
> --=20
> Damien Le Moal
> Western Digital Research
>=20


--=20
Best Regards,
Shin'ichiro Kawasaki=

