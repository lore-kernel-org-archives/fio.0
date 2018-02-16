Return-Path: <fio-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:56269 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752984AbeBPAcr (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 15 Feb 2018 19:32:47 -0500
From: Jeff Furlong <jeff.furlong@wdc.com>
Subject: fio server/client disconnect bug
Date: Fri, 16 Feb 2018 00:32:45 +0000
Message-ID: <BN3PR0401MB1457692506FCB2E385AE2A2E8FCB0@BN3PR0401MB1457.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi All,
With the near latest fio version (fio-3.3-51-gf2cd) using server/client mod=
e, I occasionally see one client get disconnected early.  Hence, the client=
's IO summary output does not get reported at the end of the job.  The issu=
e seems to occur between 100 and 300 iterations of a job file.  Worse, the =
conditions for the early disconnect may be tied to the complexity of the jo=
b file (such as numjobs or IOPs of device).  Even worse, when using debug m=
ode, the failure seems to reduce to around 1000 iterations of a job file.

When running with

fio --client=3Dhost1 test_job_a --client=3Dhost2 test_job_b --debug=3Dproce=
ss,net

...
net      5027  client: handle host2
net      5027  client: got cmd op IOLOG from host2 (pdu=3D446)
net      5027  client: handle host2
client: host=3Dhost2 disconnected
net      5027  client: removed <host2>
net      5027  client: request eta (1)
net      5027  client: requested eta tag 0x1b52c20
net      5027  client: handle host1
net      5027  client: got cmd op TEXT from host1 (pdu=3D85)
<host1> net      5028  server: got op [SEND_ETA], pdu=3D0, tag=3D1b4a970
net      5027  client: handle host1
net      5027  client: got cmd op TEXT from host1 (pdu=3D61)
<host1> net      5028  server sending status
...

Then the normal output summary only shows the statistics from host1.  The h=
ost2 throughput, latency, etc. are never displayed.  However, the iops, bw,=
 and lat logs all seem to have been updated properly.  Sometimes host2 is d=
isconnected early; sometimes host1 is disconnected early.

Why might host2 be disconnected?  I see disconnects when using a switch wit=
h one hop and also with directly connecting host1 to host2.  So dropping ne=
twork packets seems unlikely.  Could the ETA update not be accurate?  Or is=
 it possible host2 finishes the job faster than host1 and closes the connec=
tion too early?

In the event host2's job file finishes early, should we still summarize the=
 IO traffic in the output?  How is that condition handled?

If you have suggestions on other debug options, I would appreciate.  Thanks=
.

Regards,
Jeff


