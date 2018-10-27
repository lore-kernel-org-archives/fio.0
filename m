Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk1-f173.google.com ([209.85.221.173]:37343 "EHLO
        mail-vk1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728301AbeJ0Se4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 27 Oct 2018 14:34:56 -0400
Received: by mail-vk1-f173.google.com with SMTP id y128-v6so901064vky.4
        for <fio@vger.kernel.org>; Sat, 27 Oct 2018 02:54:32 -0700 (PDT)
MIME-Version: 1.0
References: <3AF0240C-DE31-4E79-AB21-31D04B863142@emc.com> <CALjAwxjS4MXpf_K6mqE2vb=+sJ40iVgKQyLJ0zfEyR2JEBpfAQ@mail.gmail.com>
 <7D6A87DE-8A24-4E68-B750-78D7B2294DC6@emc.com> <DDAFB754-E033-4307-A7B7-826307095872@emc.com>
In-Reply-To: <DDAFB754-E033-4307-A7B7-826307095872@emc.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 27 Oct 2018 10:54:12 +0100
Message-ID: <CALjAwxgU9iZrKqJab+tV560oPMc_=dGSNbuN8JHb0e56XL2qWg@mail.gmail.com>
Subject: Re: Static linking and RDB/Rados
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Mark Beierl <Mark.Beierl@dell.com>
Cc: fio <fio@vger.kernel.org>

I'm afraid this is a classic Linux issue - trying to ship a binary
that works everywhere is very hard and thus we now have
docker/flatpak/snaps/appimage etc. Outside "app packagers" getting
past what you've seen is likely going to be a lot of work and would
likely involve having to ship all the dynamically libraries and mess
around with LD_LIBRARY (and even then you've had to build everything
on a "suitably old" distro to ensure the dynamic linking works)...

On Fri, 26 Oct 2018 at 22:24, Beierl, Mark <Mark.Beierl@dell.com> wrote:
>
> Sorry, this is still a no-go for RBD with static linking.
>
> I found a librbd.a in Xenial, but it requires a ton of statically linked =
libraries to be pulled in along with it:
>
> ldd /usr/lib/x86_64-linux-gnu/librbd.so
>         linux-vdso.so.1 =3D>  (0x00007ffccd124000)
>         librados.so.2 =3D> /usr/lib/x86_64-linux-gnu/librados.so.2 (0x000=
07faac9be2000)
>         libdl.so.2 =3D> /lib/x86_64-linux-gnu/libdl.so.2 (0x00007faac99de=
000)
>         libboost_thread.so.1.58.0 =3D> /usr/lib/x86_64-linux-gnu/libboost=
_thread.so.1.58.0 (0x00007faac97b8000)
>         libboost_random.so.1.58.0 =3D> /usr/lib/x86_64-linux-gnu/libboost=
_random.so.1.58.0 (0x00007faac95b0000)
>         libblkid.so.1 =3D> /lib/x86_64-linux-gnu/libblkid.so.1 (0x00007fa=
ac936f000)
>         libpthread.so.0 =3D> /lib/x86_64-linux-gnu/libpthread.so.0 (0x000=
07faac9152000)
>         librt.so.1 =3D> /lib/x86_64-linux-gnu/librt.so.1 (0x00007faac8f49=
000)
>         libboost_iostreams.so.1.58.0 =3D> /usr/lib/x86_64-linux-gnu/libbo=
ost_iostreams.so.1.58.0 (0x00007faac8d30000)
>         libboost_system.so.1.58.0 =3D> /usr/lib/x86_64-linux-gnu/libboost=
_system.so.1.58.0 (0x00007faac8b2c000)
>         libstdc++.so.6 =3D> /usr/lib/x86_64-linux-gnu/libstdc++.so.6 (0x0=
0007faac87a9000)
>         libm.so.6 =3D> /lib/x86_64-linux-gnu/libm.so.6 (0x00007faac84a000=
0)
>         libc.so.6 =3D> /lib/x86_64-linux-gnu/libc.so.6 (0x00007faac80d600=
0)
>         /lib64/ld-linux-x86-64.so.2 (0x000055ab4535a000)
>         libgcc_s.so.1 =3D> /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x00007fa=
ac7ebf000)
>         libnss3.so =3D> /nss-3.32/dist/Linux3.10_x86_64_cc_glibc_PTH_64_D=
BG.OBJ/lib/libnss3.so (0x00007faac7b4a000)
>         libsmime3.so =3D> /nss-3.32/dist/Linux3.10_x86_64_cc_glibc_PTH_64=
_DBG.OBJ/lib/libsmime3.so (0x00007faac7919000)
>         libnspr4.so =3D> /usr/lib/x86_64-linux-gnu/libnspr4.so (0x00007fa=
ac76d9000)
>         libuuid.so.1 =3D> /lib/x86_64-linux-gnu/libuuid.so.1 (0x00007faac=
74d4000)
>         libbz2.so.1.0 =3D> /lib/x86_64-linux-gnu/libbz2.so.1.0 (0x00007fa=
ac72c3000)
>         libz.so.1 =3D> /lib/x86_64-linux-gnu/libz.so.1 (0x00007faac70a900=
0)
>         libnssutil3.so =3D> /nss-3.32/dist/Linux3.10_x86_64_cc_glibc_PTH_=
64_DBG.OBJ/lib/libnssutil3.so (0x00007faac6e6f000)
>         libplc4.so =3D> /usr/lib/x86_64-linux-gnu/libplc4.so (0x00007faac=
6c6a000)
>         libplds4.so =3D> /usr/lib/x86_64-linux-gnu/libplds4.so (0x00007fa=
ac6a66000)
>
> I got most of them, but I cannot find any statically linked libnss3.a.  B=
uilding that from source [1] turned out to be a nightmare, so I=E2=80=99m a=
t a dead end again.
>
> [1] https://github.com/nss-dev/nss

--=20
Sitsofe | http://sucs.org/~sits/

