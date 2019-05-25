Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr1-f48.google.com ([209.85.221.48]:44170 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726376AbfEYJFD (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 25 May 2019 05:05:03 -0400
Received: by mail-wr1-f48.google.com with SMTP id w13so3795560wru.11
        for <fio@vger.kernel.org>; Sat, 25 May 2019 02:05:02 -0700 (PDT)
MIME-Version: 1.0
References: <72b31a3d5cb84498b62265003e6882e2@ausx13mps316.AMER.DELL.COM>
In-Reply-To: <72b31a3d5cb84498b62265003e6882e2@ausx13mps316.AMER.DELL.COM>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 25 May 2019 10:05:00 +0100
Message-ID: <CALjAwxjN3mA6rrH22rX6hDiiYZT3t4qefpm0R70cZ1nQHOT8hQ@mail.gmail.com>
Subject: Re: Reverse Sequential with Offset
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Kurt.Dorsey@dell.com
Cc: fio <fio@vger.kernel.org>

Hi,

On Fri, 24 May 2019 at 13:36, <Kurt.Dorsey@dell.com> wrote:
>
> Hello,
>
> I am looking to do reverse sequential IO and am having some issues.
>
> Per the man page and docs this is the job I am using, utilizing the read:=
-64K   Read 32K then backtrack 64K
>
> fio --group_reporting=3D1 --name=3Dreverse_seq --filename=3D/dev/sdb --io=
depth=3D1 --rw=3Dread:-64K --offset=3D1024K --rwmixwrite=3D0  --bs=3D32K --=
description=3D32K_Reverse_Seq --random_generator=3Dtausworthe64 --randrepea=
t=3D1  --numjobs=3D1 --ba=3D4K --ioengine=3Dlibaio  --direct=3D1
>
> Looking at the block trace it is definitely doing a reverse sequential bu=
t it is starting at the LAST LBA of the device and working backwards to 0.
>   8,16  17        1     0.000000000 58480  Q   R 21781364224 + 64 [fio]
>   8,16  19        1     0.008029219     0  C   R 21781364224 + 64 [0]
>   8,16  19        2     0.008062815 58480  Q   R 21781364160 + 64 [fio]
>   8,16   0        1     0.008550943     0  C   R 21781364160 + 64 [0]
>   8,16   0        2     0.008599707 58480  Q   R 21781364096 + 64 [fio]
>
> Unfortunately it doesn't look like --offset is doing what I wanted. Looki=
ng at the man page  --offset will not work in this instance "Data before th=
e given offset will not be touched."
>
> Since there is a difference on Sequential (and Reverse Sequential) Perfor=
mance for HDDs depending on if you are working on the ID or OD I need to gi=
ve an offset to the job and then have it work backwards from that offset to=
 0 rather than work back from Max LBA to 0.
>
> Is there a way to do this or add this functionality?

It sounds like what you want is to control the end range/area fio is
working in... Since fio works in terms of bytes rather than LBAs have
you looked into using size
(https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-size)
which I think is mentioned in the fio man page documentation for
offset (https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-off=
set
)?

--=20
Sitsofe | http://sucs.org/~sits/

