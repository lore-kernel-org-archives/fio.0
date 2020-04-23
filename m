Return-Path: <fio-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:4887 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbgDWHUI (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 23 Apr 2020 03:20:08 -0400
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: A few change to increase test coverage for zoned devices.
Date: Thu, 23 Apr 2020 07:20:06 +0000
Message-ID: <BY5PR04MB6900FEA6BC8DD5A9B1E3FFE5E7D30@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <BYAPR08MB5430F7F889911C8D049241F9ABD50@BYAPR08MB5430.namprd08.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Pierre Labat (plabat)" <plabat@micron.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2020/04/22 3:05, Pierre Labat (plabat) wrote:=0A=
> Hi,=0A=
> =0A=
> We (Micron San Jose CA) have a few FIO changes to propose. The general go=
al=0A=
> of these changes is to increase the test coverage for zoned devices. Belo=
w is=0A=
> a summary.=0A=
> =0A=
> 1. A ZNS namespace has a maximum number of open zones (aka number of zone=
s=0A=
> one can write in parallel) that may be smallish. There is another ZNS=0A=
> limitation that is the maximum number of "active" zones  (active=3Dzone i=
n=0A=
> state open or closed). This number can be much bigger than the maximum nu=
mber=0A=
> of open zones.=0A=
> =0A=
> This Fio change allows to test the device in regards to this maximum numb=
er=0A=
> of active zones.=0A=
> =0A=
> Fio is given a maximum number of active zones. The threads/jobs (their nu=
mber=0A=
> is limited to the maximum number open zones) write a bit into one active=
=0A=
> zone, close it, jumps to another active zone (open it (write implicit ope=
n))=0A=
> and so on. The writing threads keep ping ponging across the active zones=
=0A=
> writing a bit each time and then closing the zone. An active zone is=0A=
> re-opened when a writing thread write again in the zone (implicit open). =
As a=0A=
> consequence, the write load is spread across all active zones while never=
=0A=
> passing the max number of active zones.=0A=
=0A=
When you say "close the zone" do you mean an explicit close ? If yes, that =
is=0A=
one more system call (ioctl) and NVMe command to issue for every single wri=
te=0A=
command. Performance will be horrible.=0A=
=0A=
=0A=
> Then at some point some active zones get  full. When that happens they ar=
e=0A=
> not "active" anymore. Fio selects other zones automatically, they will be=
come=0A=
> active on the first write. As a consequence, over time, the active zones =
move=0A=
> across the namespace (but they stay in the window specified by fio). That=
=0A=
> gives a good workout to the device running it at its max limit of active=
=0A=
> zones and jumping (to write in a zone) at high rate from one zone to=0A=
> another.=0A=
=0A=
All of this is the exact description (minus the "close the zone") of what t=
he=0A=
current max_open_zone=3DX option does. It will select X zones for writing a=
nd will=0A=
keep writing these zones until they are full, at which point, other zones a=
re=0A=
selected. This means that you will always get the number of active zones an=
d the=0A=
number of implicitly open zones to be equal. If the fio command line specif=
ies=0A=
max_open_zones=3DX with X <=3D max active zones for the device, there will =
be no=0A=
write IO rejected by the drive.=0A=
=0A=
> =0A=
> 2. An application can "finish" a zone without writing it in full. For exa=
mple=0A=
> an app could only write half a zone and then finish it. That changes the=
=0A=
> state of the zone to "full". The app cannot write anymore in the zone. Th=
e=0A=
> zone will have to be reset at some point.=0A=
> =0A=
> We have a change in FIO that allows to test that. A new option tells FIO =
to=0A=
> stop writing in a zone when reaching some threshold and to "finish" it. A=
t=0A=
> that point, FIO sends a zone management command to finish the zone and=0A=
> consider the zone full (even if it is not actually full of app data).=0A=
=0A=
We could indeed add this fairly easily as that is how zone reset rate also=
=0A=
works. However, I personally do not see any good use case for the finish=0A=
operation. "because we can" not being the best justification for new code, =
it=0A=
may be good to put forward a use case. Of note is that fio is a performance=
=0A=
measurement tool, not a drive test tool, so implementing this for "testing"=
 the=0A=
finish operation does not sound to me like a good idea either.=0A=
=0A=
=0A=
> 3. Another change is relaxing the checks in zbd_verify_sizes() in regards=
 to=0A=
> read IO on zoned devices. The reading can start anywhere in a zone (below=
 the=0A=
> WP), it doesn't need to always start at the zone beginning.=0A=
=0A=
This is indeed true for sequential read workloads. But not for random reads=
. Are=0A=
you referring to sequential read ? That should be easy to fix, but again, t=
he=0A=
usefulness of this is not clear to me.=0A=
=0A=
> I would have to move these changes on latest fio and do some cleanup befo=
re=0A=
> having patches ready.=0A=
=0A=
ZNS needs zone capacity support too. We have patches ready to go for that o=
ne.=0A=
Waiting for kernel side patches first though, otherwise, testing is not pos=
sible.=0A=
=0A=
> =0A=
> Let me know if that make sense to add the above to fio.=0A=
> =0A=
> Best regards,=0A=
> =0A=
> Pierre=0A=
> =0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

