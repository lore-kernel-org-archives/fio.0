Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-dm3nam03on0072.outbound.protection.outlook.com ([104.47.41.72]:40984
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752061AbdBOW2N (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 15 Feb 2017 17:28:13 -0500
From: Todd Lawall <tlawall@pivot3.com>
Subject: Has anyone run into write_bw_log and write_io_log recording segments
 of low numbers?
Date: Wed, 15 Feb 2017 22:28:09 +0000
Message-ID: <DM5PR10MB1625AEDC8488B039FBE439BF9D5B0@DM5PR10MB1625.namprd10.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

I've been running fio on an iSCSI volume where I can monitor things like th=
e network traffic (to ensure that indeed it is flowing) as well as on the m=
achine the volume is hosted on.  I'm seeing a steady state of 300MB/s, but =
when I stop the FIO process and writes the detailed bandwidth and iops logs=
, there's segments where iops drop to 0, but bandwidth for the same time po=
int is somewhere around the single digits or teens. =20

Has anyone else seen this behavior?  Does anyone have an idea why I might b=
e seeing this?  Here is the job file I ran:

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

[fio-1]                                                                    =
                                                                           =
     =20
filename=3D\\.\PhysicalDrive2                                              =
                                                                           =
       =20
iodepth=3D1                                                                =
                                                                           =
       =20
blocksize=3D256k                                                           =
                                                                           =
       =20
readwrite=3Dwrite        =
