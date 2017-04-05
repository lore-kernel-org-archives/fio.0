Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f41.google.com ([209.85.213.41]:34212 "EHLO
        mail-vk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754199AbdDETrY (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 5 Apr 2017 15:47:24 -0400
Received: by mail-vk0-f41.google.com with SMTP id z204so17905303vkd.1
        for <fio@vger.kernel.org>; Wed, 05 Apr 2017 12:47:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BL2PR02MB19714074E460C8EA219FFA85810A0@BL2PR02MB1971.namprd02.prod.outlook.com>
References: <BL2PR02MB19714074E460C8EA219FFA85810A0@BL2PR02MB1971.namprd02.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 5 Apr 2017 20:46:53 +0100
Message-ID: <CALjAwxgrt8byoEsSkjaSNbPiXg69+P2bH=+yGpoFs3ZKpJNnRg@mail.gmail.com>
Subject: Re: FIO achieves only 50:50 of read:write IOPS when rwmix is not
 50:50 and achieves only about 40% of total IOPS
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: GV Govindasamy <gv.govindasamy@nutanix.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 5 April 2017 at 17:25, GV Govindasamy <gv.govindasamy@nutanix.com> wrote=
:
>
> In the following example, I would like 90 read ops and 10 write ops. Rega=
rdless of the values in "bssplit" or "bs" and "rwmixread/rwmixwrite" values=
, not able to see FIO doing 90:10 read:writes and total ops turns out to be=
 ~20+~20 =3D ~40 IOPS instead of 100.
>
> Am I missing something here?
>
> Thanks
> +GV
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> $ ./fio-2.19 --version (compiled with: ./configure --build-static; make o=
n CentOS release 6.7/3.10.0-229)
> fio-2.19
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> $ cat output/fio/bssplit_rwmix.fio
> [global]
> ioengine=3Dlibaio
> direct=3D1
> time_based
> norandommap
> group_reporting
> disk_util=3D0
> continue_on_error=3Dall
> rate_process=3Dpoisson
>
> [db-oltp-w]
> bssplit=3D8k/90:16k/10
> size=3D128G
> filename=3D/dev/sdg
> rw=3Drandrw
> iodepth=3D8
> rwmixread=3D90
> rwmixwrite=3D10
> rate_iops=3D90,10,0

I think the problem may lie with rate_process=3Dpoisson - if you remove
that does the workload perform better? Perhaps it is not treating the
read and write rates independently...

--=20
Sitsofe | http://sucs.org/~sits/
