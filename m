Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua1-f51.google.com ([209.85.222.51]:41845 "EHLO
        mail-ua1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbfBVWMQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 22 Feb 2019 17:12:16 -0500
Received: by mail-ua1-f51.google.com with SMTP id z24so3363084ual.8
        for <fio@vger.kernel.org>; Fri, 22 Feb 2019 14:12:16 -0800 (PST)
MIME-Version: 1.0
References: <CO2PR04MB2374AD34FB3EE52EC16FE6419F7F0@CO2PR04MB2374.namprd04.prod.outlook.com>
In-Reply-To: <CO2PR04MB2374AD34FB3EE52EC16FE6419F7F0@CO2PR04MB2374.namprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 22 Feb 2019 22:11:49 +0000
Message-ID: <CALjAwxg=j1OJ_uqV+S8NdSstOJk=23i9V3yo7bxWXcF91PT3Ow@mail.gmail.com>
Subject: Re: Question: can anyone tell me what QD exactly a device is received
 from this test script
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jing Booth <Jing.Booth@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On Fri, 22 Feb 2019 at 16:19, Jing Booth <Jing.Booth@wdc.com> wrote:
>
> Hi all,
>
> In the test script shown below, it has [global] section and [nvme0n1] sec=
tion. The test script is used to test a storage device. What queue depth do=
es the storage device receive? Thanks
>
> fio --name=3Dglobal --ba=3D16K --bs=3D16K --buffered=3D0 --ioengine=3Dlib=
aio --nice=3D-10 --rw=3Drandrw --size=3D100% --status-interval=3D1 --ramp_t=
ime=3D2 --runtime=3D5 --time_based --rwmixread=3D25 --group_reporting --num=
jobs=3D4 --iodepth=3D16 --norandommap --random_generator=3Dtausworthe64 --r=
andrepeat=3D0 --percentile_list=3D99:99.9:99.99:99.999:99.9999:99.99999:99.=
999999:99.9999999 --name=3Dnvme0n1 --filename=3D/dev/nvme0n1  --iodepth=3D6=
4

Something like 4 if you count all jobs together (because numjobs is 4)
but you can check for yourself by looking at the submit line in the IO
depths output that fio produces.

Did you see the warnings with the libaio engine in the
manual/documentation
(https://fio.readthedocs.io/en/latest/fio_doc.html#i-o-engine ) or the
warning in the iodepth option section
(https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-iodepth
)?

--=20
Sitsofe | http://sucs.org/~sits/

