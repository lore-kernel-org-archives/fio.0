Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-sn1nam01on0054.outbound.protection.outlook.com ([104.47.32.54]:49950
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752186AbdBOW5a (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 15 Feb 2017 17:57:30 -0500
From: Todd Lawall <tlawall@pivot3.com>
Subject: Re: Has anyone run into write_bw_log and write_io_log recording
 segments of low numbers?
Date: Wed, 15 Feb 2017 22:57:18 +0000
Message-ID: <DM5PR10MB16252D3CAB3A3F949AD3F6B09D5B0@DM5PR10MB1625.namprd10.prod.outlook.com>
References: <DM5PR10MB1625AEDC8488B039FBE439BF9D5B0@DM5PR10MB1625.namprd10.prod.outlook.com>
In-Reply-To: <DM5PR10MB1625AEDC8488B039FBE439BF9D5B0@DM5PR10MB1625.namprd10.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Sorry, forgot to mention that this is on a windows client, running version =
fio-2.16-1-g3ab9.


From: fio-owner@vger.kernel.org <fio-owner@vger.kernel.org> on behalf of To=
dd Lawall <tlawall@pivot3.com>
Sent: Wednesday, February 15, 2017 3:28 PM
To: fio@vger.kernel.org
Subject: Has anyone run into write_bw_log and write_io_log recording segmen=
ts of low numbers?
=A0  =20
I've been running fio on an iSCSI volume where I can monitor things like th=
e network traffic (to ensure that indeed it is flowing) as well as on the m=
achine the volume is hosted on.=A0 I'm seeing a steady state of 300MB/s, bu=
t when I stop  the FIO process and writes the detailed bandwidth and iops l=
ogs, there's segments where iops drop to 0, but bandwidth for the same time=
 point is somewhere around the single digits or teens.=A0

Has anyone else seen this behavior?=A0 Does anyone have an idea why I might=
 be seeing this?=A0 Here is the job file I ran:

[global]
ioengine=3Dwindowsaio
do_verify=3D0
offset=3D0
write_bw_log=3DC:\\haggis\\manualfio\\stats-running
write_iops_log=3DC:\\haggis\\manualfio\\stats-running
write_lat_log=3DC:\\haggis\\manualfio\\stats-running
verify=3Dcrc32c-intel
runtime=3D292000
thread

[fio-0]
filename=3D\\.\PhysicalDrive1
iodepth=3D1
blocksize=3D256k
readwrite=3Dwrite

[fio-1]=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0
filename=3D\\.\PhysicalDrive2=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
iodepth=3D1=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
blocksize=3D256k=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
readwrite=3Dwrite=A0=A0=A0=A0=A0=A0=A0 --
To unsubscribe from this list: send the line "unsubscribe fio" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at=A0 http://vger.kernel.org/majordomo-info.html


VGER.KERNEL.ORG - Majordomo info
vger.kernel.org
Very short Majordomo intro. Send request in email to address  To subscribe =
a list (``linux-kernel'' is given as an example), use following ...

    =
