Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua1-f45.google.com ([209.85.222.45]:36373 "EHLO
        mail-ua1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728198AbeIQD1m (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 16 Sep 2018 23:27:42 -0400
Received: by mail-ua1-f45.google.com with SMTP id c12-v6so9572212uan.3
        for <fio@vger.kernel.org>; Sun, 16 Sep 2018 15:03:18 -0700 (PDT)
MIME-Version: 1.0
References: <CA+zhgFRR_SMf=CEhU8imgM+F_3hmGJV9+h_yU6qR9yQG6br48w@mail.gmail.com>
In-Reply-To: <CA+zhgFRR_SMf=CEhU8imgM+F_3hmGJV9+h_yU6qR9yQG6br48w@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sun, 16 Sep 2018 23:02:52 +0100
Message-ID: <CALjAwxhGmEV=G21Vaw0rRgmLy4BFs2Yhqw4K5yNS2MXwGFvUtQ@mail.gmail.com>
Subject: Re: No I/O performed by windowsaio/get_io_u: zero buflen
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: sundersmitha@gmail.com
Cc: fio <fio@vger.kernel.org>

On Sat, 15 Sep 2018 at 23:14, smitha sunder <sundersmitha@gmail.com> wrote:
>
> Hello all,
>
> I have a 30TB drive and I am running into an issue with random writes.
> I went through this thread :
> https://www.spinics.net/lists/fio/msg06294.html that seems to be fixed
> already.

I think that was something different regarding different blocksizes
per direction.

> I see the same issue with random reads as well.
> So not sure what is the issue here in my case; any help is greatly apprec=
iated.
>
>
> Read Capacity results:
>    Protection: prot_en=3D1, p_type=3D1, p_i_exponent=3D0 [type 2 protecti=
on]
>    Logical block provisioning: lbpme=3D1, lbprz=3D1
>    Last logical block address=3D58781073407 (0xdaf9fffff), Number of
> logical blocks=3D58781073408
>    Logical block length=3D512 bytes
>    Logical blocks per physical block exponent=3D3 [so physical block
> length=3D4096 bytes]
>    Lowest aligned logical block address=3D0
> Hence:
>    Device size: 30095909584896 bytes, 2.87017e+007 MiB, 30095.9 GB
>
>
> C:\Program Files (x86)\fio>fio --ioengine=3Dwindowsaio --group_reporting
> --direct=3D1 --size=3D100% --bs=3D4K --thread --filename=3D\\.\PhysicalDr=
ive1
> --name=3Dprecond --rw=3Drandwrite --iodepth=3D1 --numjobs=3D1
> --debug=3Dio,random

<snip>

> io       3372  fill: io_u 0A458780:
> off=3D0x144365e7d000,len=3D0x0,ddir=3D1,file=3D\\.\PhysicalDrive1
> io       3372  get_io_u: zero buflen on 0A458780
> io       3372  get_io_u failed
> io       3372  drop page cache \\.\PhysicalDrive1
> random   3372  off rand 17311067694306724737

That offset is crazy big - I'm sure it's bigger than a petabyte so my
guess is that something is overflowing. If you use --size=3D27g does the
job go through?

[...]

> I don=E2=80=99t see this issue if I use bs=3D8K or I use ba=3D512,8K, etc=
.

--=20
Sitsofe | http://sucs.org/~sits/

