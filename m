Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-px0-f182.google.com ([209.85.216.182]:61405 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab0A3FPP convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Sat, 30 Jan 2010 00:15:15 -0500
Received: by pxi12 with SMTP id 12so2322311pxi.33
        for <fio@vger.kernel.org>; Fri, 29 Jan 2010 21:15:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <f3177b9e1001292055v5a1ba090ne0e7e1c78db2b819@mail.gmail.com>
References: <f3177b9e1001292055v5a1ba090ne0e7e1c78db2b819@mail.gmail.com>
Date: Fri, 29 Jan 2010 22:15:14 -0700
Message-ID: <f3177b9e1001292115p777dfc4aqd55ec0ee52ce498@mail.gmail.com>
Subject: Re: Is --rwmixread not interpreted correctly from the command line?
From: Chris Worley <worleys@gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Never mind.  My bad.  The actual incantation didn't contain the --rwmixread.

Sorry,

Chris
On Fri, Jan 29, 2010 at 9:55 PM, Chris Worley <worleys@gmail.com> wrote:
> What am I doing wrong in this incantation?
>
> I was under the impression that everything preceding the first
> "--name" was like a "globals" section in a command file, yet, no
> matter what number follows "--rwmixread" in the following incantation,
> it allways does a 50/50 mix:
>
> fio =EF=BF=BD--rw=3Drandrw --bs=3D8k --rwmixread=3D0 --iodepth=3D256
> --output=3D/tmp/fio.out.txt --group_reporting --sync=3D0 --direct=3D1
> --randrepeat=3D0 --softrandommap=3D1 --ioengine=3Dlibaio --loops=3D10000
> --runtime=3D60 \
> =EF=BF=BD--name=3Dtest0 --filename=3D/dev/sda --numjobs=3D2 --size=3D1609=
1503001 \
> =EF=BF=BD--name=3Dtest1 --filename=3D/dev/sdb --numjobs=3D2 --size=3D1609=
1503001 \
> =EF=BF=BD--name=3Dtest2 --filename=3D/dev/sdc --numjobs=3D2 --size=3D1609=
1503001 \
> =EF=BF=BD--name=3Dtest3 --filename=3D/dev/sdd --numjobs=3D2 --size=3D1609=
1503001 \
> =EF=BF=BD--name=3Dtest4 --filename=3D/dev/sde --numjobs=3D2 --size=3D1609=
1503001 \
> =EF=BF=BD--name=3Dtest5 --filename=3D/dev/sdf --numjobs=3D2 --size=3D1609=
1503001 \
> =EF=BF=BD--name=3Dtest6 --filename=3D/dev/sdg --numjobs=3D2 --size=3D1609=
1503001 \
> =EF=BF=BD--name=3Dtest7 --filename=3D/dev/sdh --numjobs=3D2 --size=3D1609=
1503001
>
> How do I get the --rwmixread to work up-front?
>
> Thanks,
>
> Chris
>
