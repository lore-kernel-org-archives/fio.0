Return-Path: <fio-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:50410 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751517AbeGFVPd (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 6 Jul 2018 17:15:33 -0400
From: Jeff Furlong <jeff.furlong@wdc.com>
Subject: fio max blocksize
Date: Fri, 6 Jul 2018 21:15:31 +0000
Message-ID: <MWHPR04MB032082F03EB254879C04F26B8F470@MWHPR04MB0320.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi All,
Currently it looks like fio has a max blocksize of uint32_t.  So commands s=
uch as=20

# fio --name=3Dtest --ioengine=3Dlibaio --direct=3D1 --rw=3Dtrim --iodepth=
=3D1 --bs=3D4g --filename=3D/dev/nvme1n1 --number_ios=3D1 max value out of =
range: 4294967296 (4294967295 max)
fio: failed parsing bs=3D4g

will fail.  While I wouldn't normally do 4GB reads/writes, I would like to =
issue 4GB trims.  Otherwise I need to invoke a tool such as blkdiscard, but=
 then summarizing all job IO is very difficult.  I went through the process=
 of unsuccessfully changing the blocksize variables to uint64_t (failed get=
ting buflen), but not sure if I missed a minor detail or a major roadblock =
that would prevent it.  How could >4GB blocksizes be supported?  Thanks.

Regards,
Jeff

