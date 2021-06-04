Return-Path: <prvs=782ebe97f=shinichiro.kawasaki@wdc.com>
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH v2 1/3] t/zbd: Use max_open_zones that fio fetched from
 device
Date: Fri, 4 Jun 2021 10:33:55 +0000
Message-ID: <20210604103354.btwrzzhppcmiezli@shindev.dhcp.fujisawa.hgst.com>
References: <20210604053351.763028-1-shinichiro.kawasaki@wdc.com>
 <20210604053351.763028-2-shinichiro.kawasaki@wdc.com>
 <YLnePubuHuPCea/E@x1-carbon>
In-Reply-To: <YLnePubuHuPCea/E@x1-carbon>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A87247AB9528AD44A179DBBA02B14E2C@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Niklas Cassel <Niklas.Cassel@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

On Jun 04, 2021 / 08:03, Niklas Cassel wrote:
> On Fri, Jun 04, 2021 at 02:33:49PM +0900, Shin'ichiro Kawasaki wrote:
> > Recent commit d2f442bc0bd5 ("ioengines: add get_max_open_zones zoned
> > block device operation") modified fio to compare --max_open_zones optio=
n
> > value and max_open_zones reported by the device. The device limit is
> > fetched through sysfs or through an ioengine specific implementation.
> >=20
> > The test script currently try to fetch the max open zones limit using
> > libzbc tools or sg_inq. If either of these fail, default value 128 is
> > supplied. This default value can be too high when the test script is
> > run for certain zoned block devices, and can therefore result in fio
> > error and test case failure.
> >=20
> > To avoid the failure, modify the default value used in the test script
> > from 128 to 0. With this, --max_open_zones=3D0 is passed to fio, and it
> > makes fio use the max_open_zones reported by the device. Also add
> > comments to describe why the test script gets max_open_zones with tools=
.
> >=20
> > Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > ---
> >  t/zbd/functions | 15 ++++++++++++---
> >  1 file changed, 12 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/t/zbd/functions b/t/zbd/functions
> > index 40ffe1de..06973f79 100644
> > --- a/t/zbd/functions
> > +++ b/t/zbd/functions
> > @@ -173,15 +173,24 @@ last_online_zone() {
> >      fi
> >  }
> > =20
> > +# Get max_open_zones of SMR drives using sg_inq or libzbc tools. Two t=
est cases
> > +# 31 and 32 use this max_open_zones value. The test case 31 uses max_o=
pen_zones
> > +# to decide number of write target zones. The test case 32 passes max_=
open_zones
> > +# value to fio with --max_open_zones option. Of note is that fio itsel=
f as the
> > +# feature to get max_open_zones from the device through sysfs or ioeng=
ine
>=20
> has the feature?

Oops. Thanks for the catch.

>=20
> > +# specific implementation. This max_open_zones fetch by test script is=
 required
> > +# in case 1) ioengine lacks max_open_zones fetch feature, 2) Linux ker=
nel lacks
> > +# zoned block device support, or 3) Linux kernel supports zoned block =
devices
> > +# but lacks max_open_zones in sysfs.
>=20
> 1) ioengine lacks max_open_zones
> makes it sound like that is something that is needed,
> it is not, there is the oslib implementation.

Indeed.

>=20
> I think that you can replace 1, 2, 3 with something simpler like:
>=20
> ... is required in case fio is running on an old Linux kernel version whi=
ch
> lacks max_open_zones in sysfs.
>=20
> Or if you want something more specific:
>=20
> ... is required in case fio is running on an old Linux kernel version whi=
ch
> lacks max_oper_zones in sysfs, or which lacks zbd support completely.

Will reflect to v3. Thank you!

--=20
Best Regards,
Shin'ichiro Kawasaki=

