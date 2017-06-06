Return-Path: <fio-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:27545 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751291AbdFFRjw (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 6 Jun 2017 13:39:52 -0400
From: Jeff Furlong <jeff.furlong@wdc.com>
Subject: fio server errors
Date: Tue, 6 Jun 2017 17:39:49 +0000
Message-ID: <BN3PR0401MB1457EFC8350E7DAB393315B28FCB0@BN3PR0401MB1457.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi All,
When using the client/server mode, I'm having two issues.  First, I seeming=
ly randomly get an inflate error, which happens after several hours, and re=
producing it is challenging:

fio: inflate error -5
fio: failed decompressing log
fio: failed converting IO log

I have --write_iops_log turned on so guessing the IO log transferred across=
 the network is not working smoothly.  I don't have a reliable job file tha=
t reproduces the issue, unfortunately.

Second, I also get (less randomly) a timeout on SEND_ETA.  Here are the det=
ails:

# fio -version
fio-2.20-39-gc12d

# fio --client=3Dserver1 test.job --client=3Dserver2 test.job
client <server2>: timeout on SEND_ETA
client <server1>: timeout on SEND_ETA
fio: client: unable to find matching tag (76f680)

# cat test.job
[test_job]
ioengine=3Dlibaio
direct=3D1
rw=3Drandread
norandommap
randrepeat=3D0
iodepth=3D256
size=3D100%
numjobs=3D1
bs=3D4k
filename=3D/dev/nvme0n1
group_reporting
write_lat_log=3Dtest_job=20
runtime=3D3m

Any help would be appreciated.  Thanks.

Regards,
Jeff

