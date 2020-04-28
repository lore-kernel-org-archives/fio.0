Return-Path: <fio-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:33341 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726233AbgD1CLG (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 27 Apr 2020 22:11:06 -0400
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [EXT] Re: A few change to increase test coverage for zoned
 devices.
Date: Tue, 28 Apr 2020 02:11:02 +0000
Message-ID: <BY5PR04MB69001CCB1A45748604F8C294E7AC0@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <BYAPR08MB5430F7F889911C8D049241F9ABD50@BYAPR08MB5430.namprd08.prod.outlook.com>
 <BY5PR04MB6900FEA6BC8DD5A9B1E3FFE5E7D30@BY5PR04MB6900.namprd04.prod.outlook.com>
 <BYAPR08MB543036480D062CFAE161F17BABAF0@BYAPR08MB5430.namprd08.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Pierre Labat (plabat)" <plabat@micron.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: "Luca Bert (lbert)" <lbert@micron.com>

On 2020/04/28 6:28, Pierre Labat (plabat) wrote:=0A=
> =0A=
> Thanks for the comments Damien. See inline.=0A=
> =0A=
> -----Original Message----- From: Damien Le Moal <Damien.LeMoal@wdc.com> S=
ent:=0A=
> Thursday, April 23, 2020 12:20 AM To: Pierre Labat (plabat)=0A=
> <plabat@micron.com>; fio@vger.kernel.org Subject: [EXT] Re: A few change =
to=0A=
> increase test coverage for zoned devices.=0A=
> =0A=
> On 2020/04/22 3:05, Pierre Labat (plabat) wrote:=0A=
>> Hi,=0A=
>> =0A=
>> We (Micron San Jose CA) have a few FIO changes to propose. The general g=
oal=0A=
>> of these changes is to increase the test coverage for zoned devices. Bel=
ow=0A=
>> is a summary.=0A=
>> =0A=
>> 1. A ZNS namespace has a maximum number of open zones (aka number of zon=
es=0A=
>> one can write in parallel) that may be smallish. There is another ZNS=0A=
>> limitation that is the maximum number of "active" zones (active=3Dzone i=
n=0A=
>> state open or closed). This number can be much bigger than the maximum=
=0A=
>> number of open zones.=0A=
>> =0A=
>> This Fio change allows to test the device in regards to this maximum num=
ber=0A=
>> of active zones.=0A=
>> =0A=
>> Fio is given a maximum number of active zones. The threads/jobs (their =
=0A=
>> number is limited to the maximum number open zones) write a bit into one=
=0A=
>> active zone, close it, jumps to another active zone (open it (write=0A=
>> implicit open)) and so on. The writing threads keep ping ponging across =
the=0A=
>> active zones writing a bit each time and then closing the zone. An activ=
e=0A=
>> zone is re-opened when a writing thread write again in the zone (implici=
t=0A=
>> open). As a consequence, the write load is spread across all active zone=
s=0A=
>> while never passing the max number of active zones.=0A=
> =0A=
> When you say "close the zone" do you mean an explicit close ? If yes, tha=
t is=0A=
> one more system call (ioctl) and NVMe command to issue for every single w=
rite=0A=
> command. Performance will be horrible.=0A=
> =0A=
> Pierre> Agreed. This is a way to test explicit close. But beyond that no=
=0A=
> interest. <Pierre=0A=
=0A=
For testing a device function, like zone explicit close), something like nv=
mecli=0A=
and the new libnvme it is built on will be far better tools. fio is for=0A=
performance testing, not device conformance testing. Granted, it ends up do=
ing=0A=
that indirectly by exercising the drive, but that does not mean that we sho=
uld=0A=
patch fio for doing drive functional tests.=0A=
=0A=
> =0A=
>> Then at some point some active zones get  full. When that happens they a=
re=0A=
>> not "active" anymore. Fio selects other zones automatically, they will=
=0A=
>> become active on the first write. As a consequence, over time, the activ=
e=0A=
>> zones move across the namespace (but they stay in the window specified b=
y=0A=
>> fio). That gives a good workout to the device running it at its max limi=
t=0A=
>> of active zones and jumping (to write in a zone) at high rate from one z=
one=0A=
>> to another.=0A=
> =0A=
> All of this is the exact description (minus the "close the zone") of what=
 the=0A=
> current max_open_zone=3DX option does. It will select X zones for writing=
 and=0A=
> will keep writing these zones until they are full, at which point, other=
=0A=
> zones are selected. This means that you will always get the number of act=
ive=0A=
> zones and the number of implicitly open zones to be equal. If the fio com=
mand=0A=
> line specifies max_open_zones=3DX with X <=3D max active zones for the de=
vice,=0A=
> there will be no write IO rejected by the drive.=0A=
> =0A=
> Pierre> That works, using the device ability to automatically close zones=
 as=0A=
> the max number of open zones is passed. <Pierre=0A=
> =0A=
>> =0A=
>> 2. An application can "finish" a zone without writing it in full. For =
=0A=
>> example an app could only write half a zone and then finish it. That =0A=
>> changes the state of the zone to "full". The app cannot write anymore in=
=0A=
>> the zone. The zone will have to be reset at some point.=0A=
>> =0A=
>> We have a change in FIO that allows to test that. A new option tells FIO=
 to=0A=
>> stop writing in a zone when reaching some threshold and to "finish" it. =
At=0A=
>> that point, FIO sends a zone management command to finish the zone and=
=0A=
>> consider the zone full (even if it is not actually full of app data).=0A=
> =0A=
> We could indeed add this fairly easily as that is how zone reset rate als=
o=0A=
> works. However, I personally do not see any good use case for the finish=
=0A=
> operation. "because we can" not being the best justification for new code=
, it=0A=
> may be good to put forward a use case. Of note is that fio is a performan=
ce=0A=
> measurement tool, not a drive test tool, so implementing this for "testin=
g"=0A=
> the finish operation does not sound to me like a good idea either.=0A=
> =0A=
> Pierre> About a use case, that would be a program filling up a number of=
=0A=
> zones with the last one not being perfectly full. That set of zones=0A=
> corresponds to an item of same lifespan. As this item is getting old or=
=0A=
> predicted to get [very] old that last zoned would be finished. That would=
=0A=
> allow another zone to become active. <Pierre=0A=
=0A=
Well, since offset & io_size get aligned to zones, I cannot think of a case=
=0A=
where fio would leave a zone not full. Not 100% sure about it though. Would=
 need=0A=
to check again. But yes, in the context of a very limited number of active =
zones=0A=
for a device, adding the capability to finish zones would be OK I guess.=0A=
=0A=
>> 3. Another change is relaxing the checks in zbd_verify_sizes() in regard=
s=0A=
>> to read IO on zoned devices. The reading can start anywhere in a zone=0A=
>> (below the WP), it doesn't need to always start at the zone beginning.=
=0A=
> =0A=
> This is indeed true for sequential read workloads. But not for random rea=
ds.=0A=
> Are you referring to sequential read ? That should be easy to fix, but ag=
ain,=0A=
> the usefulness of this is not clear to me.=0A=
> =0A=
> Pierre> About a use case. A program has some metadata pointing to some of=
fset=0A=
> in the middle of zone. The program is going to start reading sequentially=
=0A=
> from there [using read ahead]. <Pierre=0A=
=0A=
OK. Valid I think, but putting this in the context of fio as a performance =
tool,=0A=
does it matter if reads start from a zone boundary as opposed to within a z=
one ?=0A=
Performance should be the same, for a decent device that is. It certainly i=
s the=0A=
same for SMR HDDs, and I do not expect measurable differences for ZNS drive=
s either.=0A=
=0A=
The problem with not forcing zone alignment is with the interaction with ve=
rify=0A=
and zone resets for read+write workloads. Everything becomes very difficult=
,=0A=
especially verify handling. While I may be wrong, it looks to me like a lot=
 of=0A=
changes for not much gains in terms of performance evaluation capabilities.=
 But=0A=
please feel free to prove me wrong by sending patches :)=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

