Return-Path: <fio-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:1041 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750716AbdECU7C (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 3 May 2017 16:59:02 -0400
From: Jeff Furlong <jeff.furlong@wdc.com>
Subject: fio output parameter
Date: Wed, 3 May 2017 20:58:57 +0000
Message-ID: <BN3PR0401MB1457A4FAC025F769611F69268F160@BN3PR0401MB1457.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

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

