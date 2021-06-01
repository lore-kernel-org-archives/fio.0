Return-Path: <prvs=7797843ad=Niklas.Cassel@wdc.com>
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: Re: [PATCH 1/3] t/zbd: Use max_open_zones that fio fetched from
 device
Date: Tue, 1 Jun 2021 10:45:39 +0000
Message-ID: <YLYP0gb1oUKS2JDF@x1-carbon>
References: <20210601064753.734892-1-shinichiro.kawasaki@wdc.com>
 <20210601064753.734892-2-shinichiro.kawasaki@wdc.com>
 <DM6PR04MB7081B85BD9106F0824A9F8C5E73E9@DM6PR04MB7081.namprd04.prod.outlook.com>
 <YLXeeGfTOGa1xN/A@x1-carbon>
 <DM6PR04MB7081ADF2BC1F043F1A74B988E73E9@DM6PR04MB7081.namprd04.prod.outlook.com>
 <20210601090145.e3lckhkj37qi4uwj@shindev.dhcp.fujisawa.hgst.com>
In-Reply-To: <20210601090145.e3lckhkj37qi4uwj@shindev.dhcp.fujisawa.hgst.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <18E99038F06A334789FEC23A3EE9D577@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

On Tue, Jun 01, 2021 at 09:01:45AM +0000, Shinichiro Kawasaki wrote:
> On Jun 01, 2021 / 07:19, Damien Le Moal wrote:
> > On 2021/06/01 16:15, Niklas Cassel wrote:
> > > On Tue, Jun 01, 2021 at 07:01:18AM +0000, Damien Le Moal wrote:
> > >> On 2021/06/01 15:48, Shin'ichiro Kawasaki wrote:
> > >>> Recent commit d2f442bc0bd5 ("ioengines: add get_max_open_zones zone=
d
> > >>> block device operation") modified fio to compare --max_open_zoned o=
ption
> > >>
> > >> s/max_open_zoned/max_open_zones
>=20
> Thanks. Will reflect.
>=20
> > >>
> > >>> value and max_open_zones reported by the device. The device limit i=
s
> > >>> fetched through sysfs or through an ioengine specific implementatio=
n.
> > >>>
> > >>> The test script currently try to fetch the max open zones limit usi=
ng
> > >>> libzbc tools or sg_inq. If either of these fail, default value 128 =
is
> > >>> supplied. This default value can be too high when the test script i=
s
> > >>> run for certain zoned block devices, and can therefore result in fi=
o
> > >>> error and test case failure.
> > >>
> > >> If sysfs has the max_open_zones attribute file present, that value s=
hould be
> > >> retrieved first. libzbc and sg_inq should be used only if the sysfs =
attribute is
> > >> not present, that is, when running on older kernels.
> > >=20
> > > Since we can assume that the test script and fio versions are updated=
 in sync,
> > > I don't see any point of duplicating the sysfs parsing in the test sc=
ript.
> > >=20
> > > If the test script either specifies --max_open_zones=3D0 or omits the=
 parameter,
> > > fio itself will either parse sysfs, or use libzbc to fetch the max li=
mit.
> >=20
> > True. Unless the user is running the tests with some special max_open_z=
ones, we
> > should not try to grab any value then.
> >=20
> > >=20
> > > So I think that the test script should only use those "methods" that =
fio
> > > itself can't do.
> > > Right now fio can parse sysfs and use libzbc.
> > > The only remaining method is sg_inq. This only I assume that we want =
to
> > > keep in the test. (I guess the alternative is to implement the
> > > .get_max_open_zones() fio ioengine callback in engines/sg.c, that doe=
s
> > > the same. But we probably don't want to do that, right?)
> >=20
> > No, we certainly do not. That would need a lot more code than that, e.g=
. to also
> > detect zone model. That would mean basically re-implementing what libzb=
c does
> > inside the sg engine. And since we now have the libzbc engine, I do not=
 see the
> > point.
> >=20
> > >=20
> > >>
> > >>>
> > >>> To avoid the failure, modify the default value used in the test scr=
ipt
> > >>> from 128 to 0. With this, --max_open_zoned=3D0 is passed to fio, an=
d it
> > >>> makes fio use the max_open_zones reported by the device.
> > >>
> > >> Why pass anything at all since now fio will use the device reported =
limit by
> > >> default if the user does not specify anything ?
> > >=20
> > > Sure, we can just omit the --max_open_zones parameter completely.
> > > That might be more clear.
>=20
> I think still we need the --max_open_zones option in case the latest fio =
is
> run on older kernel which does not have max_open_zones in sysfs. In such =
case,
> fio is not able to obtain the correct max_open_zones of the device (unles=
s it
> uses libzbc I/O engine).
>=20
> There are only two test cases which refers the max_open_zones that the te=
st
> script obtained: #31 and #32. The test case #31 has a check if the found
> max_open_zones is zero or not to decide write target zone count. The
> max_open_zones value is not used for --max_open_zones option (can not omi=
t it).
> As for the test case #32, it specifies "--max_open_zones=3D$max_open_zone=
s" to the
> fio command. I assume this option is still valid and required for the old=
er
> kernels. We could add a check to the test script to specify this option o=
nly
> when max_open_zones is zero, but I think it's the better not to add such =
check
> to keep the test script simpler.

Test case 31 is just poorly designed IMHO.

I don't like that it wants to know max_open_zones, but then it doesn't even
send in that value to fio.
The only reason why it fetches max_open_zones is to save time.
We can come up with some other way, e.g. a random max limit, 10 GB, divide
that by zone_size. That is the amount of zones that we decide to write.
And each zone is written fully.

Then, since test case 31 is a random read test, just read the zones that we
wrote. Right now we will write <=3D (all zones)/2, but we read _all_ zones.

Since half zones will be empty, this is not an accurate test of the random
read performance.

(Perhaps you could make the argument that all zones that you read from
should be in zone state implicit open, but that does not seem to be the cas=
e
currently, as many zones will most likely be empty.
My suggestion is that we simply write each zone fully, that way, all zones
that we read from will be in zone state FULL.)




Test case 32:

On fio master the test script currently checks sg_inq (scsi generic) or lib=
zbc,
else it defaults to 128.

The max_open_zones() could look like this (regardless of kernel version):
If sg_inq returns something: use the result as --max_open_zones.
If sq_inq doesn't return something omit --max_open_zones completely (or sen=
d
in 0), and fio will try to parse sysfs (or use libzbc if libzbc ioengine wa=
s
used). If fio fails (regardless of ioengine), it will default to 4096.

-The default of 128 can be removed from the test script. 4096 is just as go=
od
random number when we cannot get the real value as 128.
-The libzbc parsing can be removed from the test script.
-No need to add sysfs parsing to the test script.

We still need a max_open_zones() function in the test script to call sg_inq=
.
So the max_open_zones() function always has to be there. It is just the
--max_open_zones parameter than sometimes can be excluded (or specified as
zero).


BTW, do we really need to keep the sg_inc call at all?
libzbc ioengine has both a SCSI and a SCSI generic backend.
So right now, it seems that the only reason max_open_zones() function has
for living is basically if someone runs fio against a SMR drive, on a kerne=
l
older than v5.9, using an ioengine different from libzbc.

That is probably reason enough for living. But we should definitely have a
comment above the max_open_zones() function itself that states that this
function only exists in case the user runs against an SMR drive, on an old
kernel, with an ioengine !=3D libzbc ioengine. (And libzbc ioengine is prob=
ably
the most appropriate ioengine is such a scenario.)


Kind regards,
Niklas=

