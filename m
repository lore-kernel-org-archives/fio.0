Return-Path: <fio-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:60086 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727116AbeKQLNr (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 17 Nov 2018 06:13:47 -0500
From: Jeff Furlong <jeff.furlong@wdc.com>
Subject: fio backend bug
Date: Sat, 17 Nov 2018 00:59:04 +0000
Message-ID: <MWHPR04MB0320645703E3BFD7FA5EAA578FDE0@MWHPR04MB0320.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi All,
Consider a small fio job with limited IO and fixed cpu assignment:

# fio --name=3Dtest --filename=3D/dev/nvme2n1 --io_size=3D4k --ioengine=3Dl=
ibaio --cpus_allowed=3D1 --io_submit_mode=3Doffload
test: (g=3D0): rw=3Dread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-=
4096B, ioengine=3Dlibaio, iodepth=3D1
fio-3.12-8-gee63
Starting 1 process
test: No I/O performed by libaio, perhaps try --debug=3Dio option for detai=
ls?

However, if I remove the fixed cpu assignment, the job runs successfully:

# fio --name=3Dtest --filename=3D/dev/nvme2n1 --io_size=3D4k --ioengine=3Dl=
ibaio --io_submit_mode=3Doffload
test: (g=3D0): rw=3Dread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-=
4096B, ioengine=3Dlibaio, iodepth=3D1
fio-3.12-8-gee63
Starting 1 process

I see a coincidental recent patch 94574a7, however the above error occurs b=
efore and after such patch.  Does backend.c need to include some other cond=
ition for bytes_done?

Regards,
Jeff


