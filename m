Return-Path: <fio-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:17212 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbgIDUQ2 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 4 Sep 2020 16:16:28 -0400
From: Jeffrey Lien <Jeff.Lien@wdc.com>
Subject: Inconsistent Status Intervals
Date: Fri, 4 Sep 2020 20:16:25 +0000
Message-ID: <BYAPR04MB5656DD4B26ACBCEDD6074E82EA2D0@BYAPR04MB5656.namprd04.prod.outlook.com>
References: <BYAPR04MB56568021114303501613DB1AEA2D0@BYAPR04MB5656.namprd04.prod.outlook.com>
In-Reply-To: <BYAPR04MB56568021114303501613DB1AEA2D0@BYAPR04MB5656.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>, "bvanassche@acm.org" <bvanassche@acm.org>
Cc: Siriporn Swart <Siriporn.Swart@wdc.com>, Jeff Furlong <jeff.furlong@wdc.com>, Kris Davis <Kris.Davis@wdc.com>



An issue with fio version 3.20 was reported to me by our performance team w=
here the status intervals for the iops and bw values gradually increase ove=
r the run time of the job.=A0 Eventually, the delta gets large enough that =
it causes issues with the python script that formats and summarizes the fio=
 output.=A0 I included an example of the output at the bottom of this email=
.=A0 =A0

I found this commit from Bart in version 3.18 that introduces the status in=
terval variability:
https://github.com/axboe/fio/commit/31eca641ad91634e5ffcf369cd756b0506a700c=
1
And then this commit from Vincent that makes it better but doesn't complete=
ly resolve the issue:
https://github.com/axboe/fio/commit/0f77d30d90b809fbf233b9474cc5d17c6bf7354=
1

I looked at both of these patches but am not familiar enough with the fio c=
ode to know how best to resolve the issue.=A0 Does anyone have any suggesti=
ons on what could be done to make the status intervals consistent?=A0=20

Example BW log=20

 Version 3.15 Output
1000, 802924, 1, 0
2000, 801532, 1, 0
3000, 774084, 1, 0
4000, 423840, 1, 0
5001, 428355, 1, 0
6000, 427228, 1, 0
7000, 424040, 1, 0
8000, 428556, 1, 0
9000, 425144, 1, 0
10000, 430824, 1, 0
11000, 426304, 1, 0
12000, 432148, 1, 0
13000, 422860, 1, 0
14000, 433216, 1, 0
15000, 427520, 1, 0
16000, 428940, 1, 0
17000, 429840, 1, 0
18000, 423876, 1, 0
19000, 430240, 1, 0
20000, 424224, 1, 0
21000, 429568, 1, 0
22000, 425660, 1, 0
23000, 430572, 1, 0
24001, 426569, 1, 0
25000, 432576, 1, 0
26000, 428800, 1, 0
27000, 428776, 1, 0
28000, 431152, 1, 0
29000, 426356, 1, 0
30000, 428288, 1, 0
31000, 427544, 1, 0
32000, 429144, 1, 0
33000, 426240, 1, 0

Version 3.20 Output
1000, 832088, 1, 0, 0
2000, 810048, 1, 0, 0
3000, 767012, 1, 0, 0
4001, 425120, 1, 0, 0
5001, 434592, 1, 0, 0
6002, 420224, 1, 0, 0
7002, 436056, 1, 0, 0
8003, 422568, 1, 0, 0
9003, 434752, 1, 0, 0
10004, 431520, 1, 0, 0
11004, 427456, 1, 0, 0
12005, 431680, 1, 0, 0
13005, 427420, 1, 0, 0
14005, 433104, 1, 0, 0
15006, 426756, 1, 0, 0
16006, 434096, 1, 0, 0
17007, 423008, 1, 0, 0
18007, 435200, 1, 0, 0
19008, 423164, 1, 0, 0
20008, 434088, 1, 0, 0
21009, 425660, 1, 0, 0
22009, 431480, 1, 0, 0
23010, 434312, 1, 0, 0
24010, 428032, 1, 0, 0
25010, 433120, 1, 0, 0
26011, 429184, 1, 0, 0
27011, 432576, 1, 0, 0
28012, 427552, 1, 0, 0
29012, 434400, 1, 0, 0
30013, 427008, 1, 0, 0
31013, 433012, 1, 0, 0
32014, 424940, 1, 0, 0
33014, 435144, 1, 0, 0


=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20



Jeff Lien
eSSD Core SW Tools & Drivers

Western Digital
2900 37th St NW
Building 108-1
Rochester, MN 55901
Email:=A0 mailto:Jeff.Lien@wdc.com
Office: +1-507-322-2416


