Return-Path: <fio-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:48021 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbfBVQRl (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 22 Feb 2019 11:17:41 -0500
From: Jing Booth <Jing.Booth@wdc.com>
Subject: Question: can anyone tell me what QD exactly a device is received
 from this test script
Date: Fri, 22 Feb 2019 16:17:39 +0000
Message-ID: <CO2PR04MB2374AD34FB3EE52EC16FE6419F7F0@CO2PR04MB2374.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi all,

In the test script shown below, it has [global] section and [nvme0n1] secti=
on. The test script is used to test a storage device. What queue depth does=
 the storage device receive? Thanks

fio --name=3Dglobal --ba=3D16K --bs=3D16K --buffered=3D0 --ioengine=3Dlibai=
o --nice=3D-10 --rw=3Drandrw --size=3D100% --status-interval=3D1 --ramp_tim=
e=3D2 --runtime=3D5 --time_based --rwmixread=3D25 --group_reporting --numjo=
bs=3D4 --iodepth=3D16 --norandommap --random_generator=3Dtausworthe64 --ran=
drepeat=3D0 --percentile_list=3D99:99.9:99.99:99.999:99.9999:99.99999:99.99=
9999:99.9999999 --name=3Dnvme0n1 --filename=3D/dev/nvme0n1  --iodepth=3D64

