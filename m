Return-Path: <fio-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:28041 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753490AbdEDQNh (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 4 May 2017 12:13:37 -0400
From: Jeff Furlong <jeff.furlong@wdc.com>
Subject: RE: fio output parameter
Date: Thu, 4 May 2017 16:13:35 +0000
Message-ID: <BN3PR0401MB1457AC7436AA6C34F61B33228FEA0@BN3PR0401MB1457.namprd04.prod.outlook.com>
References: <BN3PR0401MB1457A4FAC025F769611F69268F160@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <923FC40148D42D44A828D320CE66E06A72E56FDC@MX204CL01.corp.emc.com>
In-Reply-To: <923FC40148D42D44A828D320CE66E06A72E56FDC@MX204CL01.corp.emc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Ruvinsky, Konstantin" <Konstantin.Ruvinsky@dell.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Thanks.  Using --output on the command line will work for my simple example=
.  However, if I make two jobs in one file, then the --output parameter for=
ces all output into one file.

[test_job]
ioengine=3Dlibaio
direct=3D1
rw=3Drandread
iodepth=3D1
size=3D100%
numjobs=3D1
bs=3D4k
filename=3D/dev/nvme0n1
runtime=3D10s
time_based
output=3Dtest_job
[test_job2]
ioengine=3Dlibaio
direct=3D1
rw=3Drandread
iodepth=3D2
size=3D100%
numjobs=3D1
bs=3D4k
filename=3D/dev/nvme0n1
runtime=3D10s
time_based
output=3Dtest_job2

Maybe it's best to make one job file per fio job.

Regards,
Jeff


-----Original Message-----
From: Ruvinsky, Konstantin [mailto:Konstantin.Ruvinsky@dell.com]=20
Sent: Wednesday, May 3, 2017 10:43 PM
To: Jeff Furlong <jeff.furlong@wdc.com>; fio@vger.kernel.org
Subject: RE: fio output parameter

Hi,

You can use the following:

fio --output kuku.log test.txt

and remove output from the job file

Regards
Konstantin


-----Original Message-----
From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behal=
f Of Jeff Furlong
Sent: Wednesday, May 03, 2017 11:59 PM
To: fio@vger.kernel.org
Subject: fio output parameter

Hi All,
When in command line mode, the output parameter dumps the output to a file.=
  When in job mode, the output parameter cannot be used, so all output goes=
 to stdout.  Can the output parameter be used with job files?  Consider bel=
ow:

# fio -version
fio-2.19-59-gf52e9

#fio --name=3Dtest_job --ioengine=3Dlibaio --direct=3D1 --rw=3Drandread --i=
odepth=3D1 --size=3D100% --numjobs=3D1 --bs=3D4k --filename=3D/dev/nvme0n1 =
--runtime=3D10s --time_based --output=3Dtest_job

#cat text.txt
[test_job]
ioengine=3Dlibaio
direct=3D1
rw=3Drandread
iodepth=3D1
size=3D100%
numjobs=3D1
bs=3D4k
filename=3D/dev/nvme0n1
runtime=3D10s
time_based
output=3Dtest_job

# fio test.txt
Bad option <output=3Dtest_job>


Regards,
Jeff

--
To unsubscribe from this list: send the line "unsubscribe fio" in the body =
of a message to majordomo@vger.kernel.org More majordomo info at  http://vg=
er.kernel.org/majordomo-info.html
