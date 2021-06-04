Return-Path: <prvs=782ebe97f=shinichiro.kawasaki@wdc.com>
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH 1/3] t/zbd: Use max_open_zones that fio fetched from
 device
Date: Fri, 4 Jun 2021 03:00:16 +0000
Message-ID: <20210604030015.saoayk7benczfkhk@shindev.dhcp.fujisawa.hgst.com>
References: <20210601064753.734892-1-shinichiro.kawasaki@wdc.com>
 <20210601064753.734892-2-shinichiro.kawasaki@wdc.com>
 <DM6PR04MB7081B85BD9106F0824A9F8C5E73E9@DM6PR04MB7081.namprd04.prod.outlook.com>
 <YLXeeGfTOGa1xN/A@x1-carbon>
 <DM6PR04MB7081ADF2BC1F043F1A74B988E73E9@DM6PR04MB7081.namprd04.prod.outlook.com>
 <20210601090145.e3lckhkj37qi4uwj@shindev.dhcp.fujisawa.hgst.com>
 <YLYP0gb1oUKS2JDF@x1-carbon>
In-Reply-To: <YLYP0gb1oUKS2JDF@x1-carbon>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EB5CB431B9FC434994EDC493E747EAA0@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Niklas Cassel <Niklas.Cassel@wdc.com>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

On Jun 01, 2021 / 10:45, Niklas Cassel wrote:
> On Tue, Jun 01, 2021 at 09:01:45AM +0000, Shinichiro Kawasaki wrote:
> > On Jun 01, 2021 / 07:19, Damien Le Moal wrote:
> > > On 2021/06/01 16:15, Niklas Cassel wrote:
> > > > On Tue, Jun 01, 2021 at 07:01:18AM +0000, Damien Le Moal wrote:
> > > >> On 2021/06/01 15:48, Shin'ichiro Kawasaki wrote:
> > > >>> Recent commit d2f442bc0bd5 ("ioengines: add get_max_open_zones zo=
ned
> > > >>> block device operation") modified fio to compare --max_open_zoned=
 option
> > > >>
> > > >> s/max_open_zoned/max_open_zones
> >=20
> > Thanks. Will reflect.
> >=20
> > > >>
> > > >>> value and max_open_zones reported by the device. The device limit=
 is
> > > >>> fetched through sysfs or through an ioengine specific implementat=
ion.
> > > >>>
> > > >>> The test script currently try to fetch the max open zones limit u=
sing
> > > >>> libzbc tools or sg_inq. If either of these fail, default value 12=
8 is
> > > >>> supplied. This default value can be too high when the test script=
 is
> > > >>> run for certain zoned block devices, and can therefore result in =
fio
> > > >>> error and test case failure.
> > > >>
> > > >> If sysfs has the max_open_zones attribute file present, that value=
 should be
> > > >> retrieved first. libzbc and sg_inq should be used only if the sysf=
s attribute is
> > > >> not present, that is, when running on older kernels.
> > > >=20
> > > > Since we can assume that the test script and fio versions are updat=
ed in sync,
> > > > I don't see any point of duplicating the sysfs parsing in the test =
script.
> > > >=20
> > > > If the test script either specifies --max_open_zones=3D0 or omits t=
he parameter,
> > > > fio itself will either parse sysfs, or use libzbc to fetch the max =
limit.
> > >=20
> > > True. Unless the user is running the tests with some special max_open=
_zones, we
> > > should not try to grab any value then.
> > >=20
> > > >=20
> > > > So I think that the test script should only use those "methods" tha=
t fio
> > > > itself can't do.
> > > > Right now fio can parse sysfs and use libzbc.
> > > > The only remaining method is sg_inq. This only I assume that we wan=
t to
> > > > keep in the test. (I guess the alternative is to implement the
> > > > .get_max_open_zones() fio ioengine callback in engines/sg.c, that d=
oes
> > > > the same. But we probably don't want to do that, right?)
> > >=20
> > > No, we certainly do not. That would need a lot more code than that, e=
.g. to also
> > > detect zone model. That would mean basically re-implementing what lib=
zbc does
> > > inside the sg engine. And since we now have the libzbc engine, I do n=
ot see the
> > > point.
> > >=20
> > > >=20
> > > >>
> > > >>>
> > > >>> To avoid the failure, modify the default value used in the test s=
cript
> > > >>> from 128 to 0. With this, --max_open_zoned=3D0 is passed to fio, =
and it
> > > >>> makes fio use the max_open_zones reported by the device.
> > > >>
> > > >> Why pass anything at all since now fio will use the device reporte=
d limit by
> > > >> default if the user does not specify anything ?
> > > >=20
> > > > Sure, we can just omit the --max_open_zones parameter completely.
> > > > That might be more clear.
> >=20
> > I think still we need the --max_open_zones option in case the latest fi=
o is
> > run on older kernel which does not have max_open_zones in sysfs. In suc=
h case,
> > fio is not able to obtain the correct max_open_zones of the device (unl=
ess it
> > uses libzbc I/O engine).
> >=20
> > There are only two test cases which refers the max_open_zones that the =
test
> > script obtained: #31 and #32. The test case #31 has a check if the foun=
d
> > max_open_zones is zero or not to decide write target zone count. The
> > max_open_zones value is not used for --max_open_zones option (can not o=
mit it).
> > As for the test case #32, it specifies "--max_open_zones=3D$max_open_zo=
nes" to the
> > fio command. I assume this option is still valid and required for the o=
lder
> > kernels. We could add a check to the test script to specify this option=
 only
> > when max_open_zones is zero, but I think it's the better not to add suc=
h check
> > to keep the test script simpler.
>=20
> Test case 31 is just poorly designed IMHO.
>=20
> I don't like that it wants to know max_open_zones, but then it doesn't ev=
en
> send in that value to fio.
> The only reason why it fetches max_open_zones is to save time.
> We can come up with some other way, e.g. a random max limit, 10 GB, divid=
e
> that by zone_size. That is the amount of zones that we decide to write.
> And each zone is written fully.
>=20
> Then, since test case 31 is a random read test, just read the zones that =
we
> wrote. Right now we will write <=3D (all zones)/2, but we read _all_ zone=
s.
>=20
> Since half zones will be empty, this is not an accurate test of the rando=
m
> read performance.
>=20
> (Perhaps you could make the argument that all zones that you read from
> should be in zone state implicit open, but that does not seem to be the c=
ase
> currently, as many zones will most likely be empty.
> My suggestion is that we simply write each zone fully, that way, all zone=
s
> that we read from will be in zone state FULL.)

I think we are going beyond the scope of this patch series. The design of t=
he
test case may not be the best, but it is somewhat reasonable and valid. I w=
ish
we fix the test case failure first. Let's defer test design change or test
condition change at this moment until we really need to relook them.

>=20
>=20
>=20
>=20
> Test case 32:
>=20
> On fio master the test script currently checks sg_inq (scsi generic) or l=
ibzbc,
> else it defaults to 128.
>=20
> The max_open_zones() could look like this (regardless of kernel version):
> If sg_inq returns something: use the result as --max_open_zones.
> If sq_inq doesn't return something omit --max_open_zones completely (or s=
end
> in 0), and fio will try to parse sysfs (or use libzbc if libzbc ioengine =
was
> used). If fio fails (regardless of ioengine), it will default to 4096.
>=20
> -The default of 128 can be removed from the test script. 4096 is just as =
good
> random number when we cannot get the real value as 128.

Right, the patch does so.

> -The libzbc parsing can be removed from the test script.

Maybe this is a good idea, but I would like to defer it for later chance. I=
t
will need certain amount of effort to check libzbc tool condition corner ca=
ses.

> -No need to add sysfs parsing to the test script.

Right, the patch does not add it.

>=20
> We still need a max_open_zones() function in the test script to call sg_i=
nq.
> So the max_open_zones() function always has to be there. It is just the
> --max_open_zones parameter than sometimes can be excluded (or specified a=
s
> zero).
>=20
>=20
> BTW, do we really need to keep the sg_inc call at all?
> libzbc ioengine has both a SCSI and a SCSI generic backend.
> So right now, it seems that the only reason max_open_zones() function has
> for living is basically if someone runs fio against a SMR drive, on a ker=
nel
> older than v5.9, using an ioengine different from libzbc.

I also think the conditions you described above is what we aim. When older
kernel gets the burden for us, we can discuss later.

>=20
> That is probably reason enough for living. But we should definitely have =
a
> comment above the max_open_zones() function itself that states that this
> function only exists in case the user runs against an SMR drive, on an ol=
d
> kernel, with an ioengine !=3D libzbc ioengine. (And libzbc ioengine is pr=
obably
> the most appropriate ioengine is such a scenario.)

I agree to add the comments. Will add it and resend v2. I don't think libzb=
c is
the only ioengine for SMR drives even for older Linux kernels. The block la=
yer
has been supporting zoned block devices since kernel version 4.10. (This
discussion may depend on the definition of the word 'old', though :)

--=20
Best Regards,
Shin'ichiro Kawasaki=

