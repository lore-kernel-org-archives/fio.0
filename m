Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbgDUSEq (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 21 Apr 2020 14:04:46 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20614.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::614])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97421C0610D5
        for <fio@vger.kernel.org>; Tue, 21 Apr 2020 11:04:46 -0700 (PDT)
From: "Pierre Labat (plabat)" <plabat@micron.com>
Subject: A few change to increase test coverage for zoned devices.
Date: Tue, 21 Apr 2020 18:04:43 +0000
Message-ID: <BYAPR08MB5430F7F889911C8D049241F9ABD50@BYAPR08MB5430.namprd08.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

We (Micron San Jose CA) have a few FIO changes to propose. The general goal=
 of these changes is to increase the test coverage for zoned devices. Below=
 is a summary.

1. A ZNS namespace has a maximum number of open zones (aka number of zones =
one can write in parallel) that may be smallish. There is another ZNS limit=
ation that is the maximum number of "active" zones =A0(active=3Dzone in sta=
te open or closed). This number can be much bigger than the maximum number =
of open zones.

This Fio change allows to test the device in regards to this maximum number=
 of active zones.=20

Fio is given a maximum number of active zones. The threads/jobs (their numb=
er is limited to the maximum number open zones) write a bit into one active=
 zone, close it, jumps to another active zone (open it (write implicit open=
)) and so on. The writing threads keep ping ponging across the active zones=
 writing a bit each time and then closing the zone. An active zone is re-op=
ened when a writing thread write again in the zone (implicit open). As a co=
nsequence, the write load is spread across all active zones while never pas=
sing the max number of active zones.
Then at some point some active zones get=A0 full. When that happens they ar=
e not "active" anymore. Fio selects other zones automatically, they will be=
come active on the first write. As a consequence, over time, the active zon=
es move across the namespace (but they stay in the window specified by fio)=
. That gives a good workout to the device running it at its max limit of ac=
tive zones and jumping (to write in a zone) at high rate from one zone to a=
nother.

2. An application can "finish" a zone without writing it in full. For examp=
le an app could only write half a zone and then finish it. That changes the=
 state of the zone to "full". The app cannot write anymore in the zone. The=
 zone will have to be reset at some point.

We have a change in FIO that allows to test that. A new option tells FIO to=
 stop writing in a zone when reaching some threshold and to "finish" it. At=
 that point, FIO sends a zone management command to finish the zone and con=
sider the zone full (even if it is not actually full of app data).

3. Another change is relaxing the checks in zbd_verify_sizes() in regards t=
o read IO on zoned devices. The reading can start anywhere in a zone (below=
 the WP), it doesn't need to always start at the zone beginning.

I would have to move these changes on latest fio and do some cleanup before=
 having patches ready.

Let me know if that make sense to add the above to fio.

Best regards,

Pierre


