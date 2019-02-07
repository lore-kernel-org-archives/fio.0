Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vs1-f52.google.com ([209.85.217.52]:42342 "EHLO
        mail-vs1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbfBGSGG (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 7 Feb 2019 13:06:06 -0500
Received: by mail-vs1-f52.google.com with SMTP id b74so473995vsd.9
        for <fio@vger.kernel.org>; Thu, 07 Feb 2019 10:06:06 -0800 (PST)
MIME-Version: 1.0
References: <48713691549531283@myt6-fe24916a5562.qloud-c.yandex.net>
In-Reply-To: <48713691549531283@myt6-fe24916a5562.qloud-c.yandex.net>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 7 Feb 2019 18:05:39 +0000
Message-ID: <CALjAwxg6-AJdvC3YJ0Nc8=BM31ZDa_nNBXG0_X+pOxN7R_FO2g@mail.gmail.com>
Subject: Re: slash problem windows
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: =?UTF-8?B?0J/RgNC+0YXQvtGA0L7QsiDQkNC70LXQutGB0LDQvdC00YA=?= <cauhuk@yandex.ru>
Cc: fio <fio@vger.kernel.org>

Hi there,

On Thu, 7 Feb 2019 at 09:21, =D0=9F=D1=80=D0=BE=D1=85=D0=BE=D1=80=D0=BE=D0=
=B2 =D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B0=D0=BD=D0=B4=D1=80 <cauhuk@yandex.r=
u> wrote:
>
> Hello!
> 3) verison: fio-3.12 (exe, download from bluestop)
> 2) Environment: Windows 10 professional x64 ver 1803
> 4) steps to reproduce:
> 4.1) download and unzip folder (path C: \ fio-3.12-x64)
> 4.2) creat test "readi.fio" with text:
> [global]
> ioengine =3D windowsaio
> rw =3D readwrite
> size =3D 1g
> directory =3D I \: \
> thread =3D 1
> [trivial-readwrite-1g]
> 4.3) launch test from powershell or cmd
> FIO created file, but after:
> trivial-readwrite-1g: Laying out IO file (1 file / 1024MiB)
> windowsaio: failed to open file "I: \ trivial-readwrite-1g.0.0"
> trivial-readwrite-1g: No I / O performed by windowsaio, perhaps try - deb=
ug =3D io option for details?
>
> 1) What i think about: it=E2=80=99s in windowsaio with the READWRITE comm=
and. Write operation or read operation are sucess. But reading after writin=
g catch trouble with windows path slash
> Path with folders is failed too : directory =3D I\:\s\  -> windowsaio: fa=
iled to open file "I:\s/trivial-readwrite-1g.0.0"

Have you seen the information in fio manual? There's a copy of it over
on https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-filename
...

--=20
Sitsofe | http://sucs.org/~sits/

