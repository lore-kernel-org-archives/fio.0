Return-Path: <fio-owner@vger.kernel.org>
Received: from esa2.dell-outbound.iphmx.com ([68.232.149.220]:18098 "EHLO
        esa2.dell-outbound.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932081AbdEDFwh (ORCPT
        <rfc822;fio@vger.kernel.org>); Thu, 4 May 2017 01:52:37 -0400
From: "Ruvinsky, Konstantin" <Konstantin.Ruvinsky@dell.com>
Subject: RE: fio output parameter
Date: Thu, 4 May 2017 05:42:42 +0000
Message-ID: <923FC40148D42D44A828D320CE66E06A72E56FDC@MX204CL01.corp.emc.com>
References: <BN3PR0401MB1457A4FAC025F769611F69268F160@BN3PR0401MB1457.namprd04.prod.outlook.com>
In-Reply-To: <BN3PR0401MB1457A4FAC025F769611F69268F160@BN3PR0401MB1457.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Furlong <jeff.furlong@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

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
