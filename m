Return-Path: <fio-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:11622 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750818AbeEKTFp (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 11 May 2018 15:05:45 -0400
From: Jeff Furlong <jeff.furlong@wdc.com>
Subject: RE: fio synchronization across client/server?
Date: Fri, 11 May 2018 19:05:40 +0000
Message-ID: <SN6PR04MB40648D6E3C70F5C1C3AA3BFA8F9F0@SN6PR04MB4064.namprd04.prod.outlook.com>
References: <BBE28C8D35EDEC48B06294CB3C6597278D2CD8@LAX-EX-MB3.datadirect.datadirectnet.com>
In-Reply-To: <BBE28C8D35EDEC48B06294CB3C6597278D2CD8@LAX-EX-MB3.datadirect.datadirectnet.com>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jim Reuter <jreuter@ddn.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Have you tried making a job file for each client, then running both clients=
 together with:

# fio --client=3Dhost1 job_a --client=3Dhost2 job_b --output=3Djob_output

That should keep the clients synchronized.  Unfortunately it means you need=
 a set of job files for each time you would normally stonewall.  Perhaps ad=
ding a stonewall-client feature would help.  Any time stonewall-client is s=
een, the client's jobs are paused until (all) the other client's jobfile al=
so encounters a stonewall-client.   Then, a set of job files could be colla=
psed to one job file per client.

Regards,
Jeff

-----Original Message-----
From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behal=
f Of Jim Reuter
Sent: Friday, May 11, 2018 11:11 AM
To: fio@vger.kernel.org
Subject: fio synchronization across client/server?

I am trying to figure out if something I want to do is possible with fio.  =
Large high performance storage systems often require load to be generated f=
rom multiple hosts over multiple interconnects to reach (and test) maximum =
performance.  But the fio documentation says nothing about how or if any sy=
nchronization is done between clients and servers (in the fio --client and =
--server meaning of these terms).

Let's begin with a trivial single node example:

[global]
bs=3D4k
iodepth=3D16
direct=3D1
ioengine=3Dlibaio
randrepeat=3D0
time_based
runtime=3D60

[rrsda]
rw=3Drandread
filename=3D/dev/sda
[rrsdb]
rw=3Drandread
filename=3D/dev/sdb

[rwsda]
stonewall
rw=3Drandwrite
filename=3D/dev/sda
[rrsdb]
rw=3Drandwrite
filename=3D/dev/sdb

The above will run concurrent random read workloads on /dev/sda and /dev/sd=
b, then switch to random write workloads on the same.  In my situation, wit=
h a multi-client external array storage, the two LUNs to test might be /dev=
/sda on host1 and /dev/sda on host2.  How do I achieve the above test but w=
ith the devices on different nodes using fio?  If I am reading the document=
ation correctly, using separate job files is an implicit stonewall, so I ca=
nnot just split the node specific parts from above into separate job files.=
=20

I could split this into completely separate job files for the randread and =
randwrite parts and have one for each node, but then these just run indepen=
dently, so I do not get the purpose of the client/server fio feature for th=
is.  Or I could just launch separate fio jobs on each node and hope they st=
art at roughly the same time, which is a hack and possibly highly variable,=
 which can skew results.  What am I missing?  Can fio do this?  If not, wha=
t is the real purpose of the client/server feature?

--
To unsubscribe from this list: send the line "unsubscribe fio" in the body =
of a message to majordomo@vger.kernel.org More majordomo info at  http://vg=
er.kernel.org/majordomo-info.html
