Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-bn8nam11on2065.outbound.protection.outlook.com ([40.107.236.65]:6160
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726030AbgD0V2a (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 27 Apr 2020 17:28:30 -0400
From: "Pierre Labat (plabat)" <plabat@micron.com>
Subject: RE: [EXT] Re: A few change to increase test coverage for zoned
 devices.
Date: Mon, 27 Apr 2020 21:28:25 +0000
Message-ID: <BYAPR08MB543036480D062CFAE161F17BABAF0@BYAPR08MB5430.namprd08.prod.outlook.com>
References: <BYAPR08MB5430F7F889911C8D049241F9ABD50@BYAPR08MB5430.namprd08.prod.outlook.com>
 <BY5PR04MB6900FEA6BC8DD5A9B1E3FFE5E7D30@BY5PR04MB6900.namprd04.prod.outlook.com>
In-Reply-To: <BY5PR04MB6900FEA6BC8DD5A9B1E3FFE5E7D30@BY5PR04MB6900.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: "Luca Bert (lbert)" <lbert@micron.com>


Thanks for the comments Damien. See inline.

-----Original Message-----
From: Damien Le Moal <Damien.LeMoal@wdc.com>=20
Sent: Thursday, April 23, 2020 12:20 AM
To: Pierre Labat (plabat) <plabat@micron.com>; fio@vger.kernel.org
Subject: [EXT] Re: A few change to increase test coverage for zoned devices=
.

On 2020/04/22 3:05, Pierre Labat (plabat) wrote:
> Hi,
>=20
> We (Micron San Jose CA) have a few FIO changes to propose. The general=20
> goal of these changes is to increase the test coverage for zoned=20
> devices. Below is a summary.
>=20
> 1. A ZNS namespace has a maximum number of open zones (aka number of=20
> zones one can write in parallel) that may be smallish. There is=20
> another ZNS limitation that is the maximum number of "active" zones =20
> (active=3Dzone in state open or closed). This number can be much bigger=20
> than the maximum number of open zones.
>=20
> This Fio change allows to test the device in regards to this maximum=20
> number of active zones.
>=20
> Fio is given a maximum number of active zones. The threads/jobs (their=20
> number is limited to the maximum number open zones) write a bit into=20
> one active zone, close it, jumps to another active zone (open it=20
> (write implicit open)) and so on. The writing threads keep ping=20
> ponging across the active zones writing a bit each time and then=20
> closing the zone. An active zone is re-opened when a writing thread=20
> write again in the zone (implicit open). As a consequence, the write=20
> load is spread across all active zones while never passing the max number=
 of active zones.

When you say "close the zone" do you mean an explicit close ? If yes, that =
is one more system call (ioctl) and NVMe command to issue for every single =
write command. Performance will be horrible.

Pierre>
Agreed. This is a way to test explicit close. But beyond that no interest.
<Pierre

> Then at some point some active zones get  full. When that happens they=20
> are not "active" anymore. Fio selects other zones automatically, they=20
> will become active on the first write. As a consequence, over time,=20
> the active zones move across the namespace (but they stay in the=20
> window specified by fio). That gives a good workout to the device=20
> running it at its max limit of active zones and jumping (to write in a=20
> zone) at high rate from one zone to another.

All of this is the exact description (minus the "close the zone") of what t=
he current max_open_zone=3DX option does. It will select X zones for writin=
g and will keep writing these zones until they are full, at which point, ot=
her zones are selected. This means that you will always get the number of a=
ctive zones and the number of implicitly open zones to be equal. If the fio=
 command line specifies max_open_zones=3DX with X <=3D max active zones for=
 the device, there will be no write IO rejected by the drive.

Pierre>
That works, using the device ability to automatically close zones as the ma=
x number of open zones is passed.
<Pierre

>=20
> 2. An application can "finish" a zone without writing it in full. For=20
> example an app could only write half a zone and then finish it. That=20
> changes the state of the zone to "full". The app cannot write anymore=20
> in the zone. The zone will have to be reset at some point.
>=20
> We have a change in FIO that allows to test that. A new option tells=20
> FIO to stop writing in a zone when reaching some threshold and to=20
> "finish" it. At that point, FIO sends a zone management command to=20
> finish the zone and consider the zone full (even if it is not actually fu=
ll of app data).

We could indeed add this fairly easily as that is how zone reset rate also =
works. However, I personally do not see any good use case for the finish op=
eration. "because we can" not being the best justification for new code, it=
 may be good to put forward a use case. Of note is that fio is a performanc=
e measurement tool, not a drive test tool, so implementing this for "testin=
g" the finish operation does not sound to me like a good idea either.

Pierre>
About a use case, that would be a program filling up a number of zones with=
 the last one not being perfectly full. That set of zones corresponds to an=
 item of same lifespan. As this item is getting old or predicted to get [ve=
ry] old that last zoned would be finished. That would allow another zone to=
 become active.
<Pierre


> 3. Another change is relaxing the checks in zbd_verify_sizes() in=20
> regards to read IO on zoned devices. The reading can start anywhere in=20
> a zone (below the WP), it doesn't need to always start at the zone beginn=
ing.

This is indeed true for sequential read workloads. But not for random reads=
. Are you referring to sequential read ? That should be easy to fix, but ag=
ain, the usefulness of this is not clear to me.

Pierre>
About a use case. A program has some metadata pointing to some offset in th=
e middle of zone. The program is going to start reading sequentially from t=
here [using read ahead].=20
<Pierre

> I would have to move these changes on latest fio and do some cleanup=20
> before having patches ready.

ZNS needs zone capacity support too. We have patches ready to go for that o=
ne.
Waiting for kernel side patches first though, otherwise, testing is not pos=
sible.

Pierre>
I see. Good to know.
<Pierre

>=20
> Let me know if that make sense to add the above to fio.
>=20
> Best regards,
>=20
> Pierre
>=20
>=20


--
Damien Le Moal
Western Digital Research

