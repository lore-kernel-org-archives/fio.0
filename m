Return-Path: <fio-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:23375 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752458AbdJTTIm (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 20 Oct 2017 15:08:42 -0400
From: Jeff Furlong <jeff.furlong@wdc.com>
Subject: fio offset with ba
Date: Fri, 20 Oct 2017 19:08:39 +0000
Message-ID: <BN3PR0401MB145727ED714B57825C91A8E78F430@BN3PR0401MB1457.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi All,
I don't quite follow the logic in the calculate offset function.  The offse=
t parameter recently allows a percentage.  Suppose we set it to 50% and wan=
t to block align the IO's starting at 50% of device capacity, then block al=
igned to 8KB.

# fio -version
fio-3.1-60-g71aa

# blockdev --getsize64 /dev/nvme1n1
3200631791616

# fio --name=3Dtest_job --ioengine=3Dlibaio --direct=3D1 --rw=3Dread --iode=
pth=3D1 --size=3D100% --bs=3D4k --filename=3D/dev/nvme1n1 --runtime=3D1s --=
offset=3D50% --log_offset=3D1 --write_iops_log=3Dtest_job --ba=3D8k

# cat test_job_iops.1.log
0, 1, 0, 4096, 1600315895808
0, 1, 0, 4096, 1600315899904
0, 1, 0, 4096, 1600315904000
0, 1, 0, 4096, 1600315908096

So we can see the device has 3200631791616 bytes, 50% of which is 160031589=
5808 bytes, which happens to be 4KB aligned, but not 8KB aligned.  Even tho=
ugh we set the --ba=3D8k parameter, the offset LBA as logged in the iops.1.=
log shows 4KB alignment.  Does --ba work for all IO's or only random IO's? =
 If all, does get_start_offset() control the raw offset value?  I don't see=
 why the min(ba, bs) is used in the calculation, but perhaps I am missing s=
omething.  Thanks.

Regards,
Jeff

