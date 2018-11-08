Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vs1-f51.google.com ([209.85.217.51]:37975 "EHLO
        mail-vs1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbeKIHXZ (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 9 Nov 2018 02:23:25 -0500
Received: by mail-vs1-f51.google.com with SMTP id x64so12534542vsa.5
        for <fio@vger.kernel.org>; Thu, 08 Nov 2018 13:46:00 -0800 (PST)
MIME-Version: 1.0
References: <3AF0240C-DE31-4E79-AB21-31D04B863142@emc.com> <CALjAwxjS4MXpf_K6mqE2vb=+sJ40iVgKQyLJ0zfEyR2JEBpfAQ@mail.gmail.com>
 <7D6A87DE-8A24-4E68-B750-78D7B2294DC6@emc.com> <DDAFB754-E033-4307-A7B7-826307095872@emc.com>
 <CALjAwxgU9iZrKqJab+tV560oPMc_=dGSNbuN8JHb0e56XL2qWg@mail.gmail.com> <5FA4BA4C-1455-469C-A69E-EEE3BFD4E79D@emc.com>
In-Reply-To: <5FA4BA4C-1455-469C-A69E-EEE3BFD4E79D@emc.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 8 Nov 2018 21:45:34 +0000
Message-ID: <CALjAwxisfeKcMj2UqZ-JC6F4u4nVbnHg8kxAYXPJy_+hXt1cFA@mail.gmail.com>
Subject: Re: Static linking and RDB/Rados
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Mark Beierl <Mark.Beierl@dell.com>
Cc: fio <fio@vger.kernel.org>

On Thu, 8 Nov 2018 at 21:17, Beierl, Mark <Mark.Beierl@dell.com> wrote:
>
>
> On 2018-10-27, 05:54, "Sitsofe Wheeler" <sitsofe@gmail.com> wrote:
>
>     I'm afraid this is a classic Linux issue - trying to ship a binary
>     that works everywhere is very hard and thus we now have
>     docker/flatpak/snaps/appimage etc. Outside "app packagers" getting
>     past what you've seen is likely going to be a lot of work and would
>     likely involve having to ship all the dynamically libraries and mess
>     around with LD_LIBRARY (and even then you've had to build everything
>     on a "suitably old" distro to ensure the dynamic linking works)...
>
>     On Fri, 26 Oct 2018 at 22:24, Beierl, Mark <Mark.Beierl@dell.com> wro=
te:
>     >
>     > Sorry, this is still a no-go for RBD with static linking.
>     >
>     > I found a librbd.a in Xenial, but it requires a ton of statically l=
inked libraries to be pulled in along with it:
>     >
>     > ldd /usr/lib/x86_64-linux-gnu/librbd.so
>     >         linux-vdso.so.1 =3D>  (0x00007ffccd124000)
>     >         librados.so.2 =3D> /usr/lib/x86_64-linux-gnu/librados.so.2 =
(0x00007faac9be2000)
>     >         libdl.so.2 =3D> /lib/x86_64-linux-gnu/libdl.so.2 (0x00007fa=
ac99de000)
>     >         libboost_thread.so.1.58.0 =3D> /usr/lib/x86_64-linux-gnu/li=
bboost_thread.so.1.58.0 (0x00007faac97b8000)
>     >         libboost_random.so.1.58.0 =3D> /usr/lib/x86_64-linux-gnu/li=
bboost_random.so.1.58.0 (0x00007faac95b0000)
>     >         libblkid.so.1 =3D> /lib/x86_64-linux-gnu/libblkid.so.1 (0x0=
0007faac936f000)
>     >         libpthread.so.0 =3D> /lib/x86_64-linux-gnu/libpthread.so.0 =
(0x00007faac9152000)
>     >         librt.so.1 =3D> /lib/x86_64-linux-gnu/librt.so.1 (0x00007fa=
ac8f49000)
>     >         libboost_iostreams.so.1.58.0 =3D> /usr/lib/x86_64-linux-gnu=
/libboost_iostreams.so.1.58.0 (0x00007faac8d30000)
>     >         libboost_system.so.1.58.0 =3D> /usr/lib/x86_64-linux-gnu/li=
bboost_system.so.1.58.0 (0x00007faac8b2c000)
>     >         libstdc++.so.6 =3D> /usr/lib/x86_64-linux-gnu/libstdc++.so.=
6 (0x00007faac87a9000)
>     >         libm.so.6 =3D> /lib/x86_64-linux-gnu/libm.so.6 (0x00007faac=
84a0000)
>     >         libc.so.6 =3D> /lib/x86_64-linux-gnu/libc.so.6 (0x00007faac=
80d6000)
>     >         /lib64/ld-linux-x86-64.so.2 (0x000055ab4535a000)
>     >         libgcc_s.so.1 =3D> /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x0=
0007faac7ebf000)
>     >         libnss3.so =3D> /nss-3.32/dist/Linux3.10_x86_64_cc_glibc_PT=
H_64_DBG.OBJ/lib/libnss3.so (0x00007faac7b4a000)
>     >         libsmime3.so =3D> /nss-3.32/dist/Linux3.10_x86_64_cc_glibc_=
PTH_64_DBG.OBJ/lib/libsmime3.so (0x00007faac7919000)
>     >         libnspr4.so =3D> /usr/lib/x86_64-linux-gnu/libnspr4.so (0x0=
0007faac76d9000)
>     >         libuuid.so.1 =3D> /lib/x86_64-linux-gnu/libuuid.so.1 (0x000=
07faac74d4000)
>     >         libbz2.so.1.0 =3D> /lib/x86_64-linux-gnu/libbz2.so.1.0 (0x0=
0007faac72c3000)
>     >         libz.so.1 =3D> /lib/x86_64-linux-gnu/libz.so.1 (0x00007faac=
70a9000)
>     >         libnssutil3.so =3D> /nss-3.32/dist/Linux3.10_x86_64_cc_glib=
c_PTH_64_DBG.OBJ/lib/libnssutil3.so (0x00007faac6e6f000)
>     >         libplc4.so =3D> /usr/lib/x86_64-linux-gnu/libplc4.so (0x000=
07faac6c6a000)
>     >         libplds4.so =3D> /usr/lib/x86_64-linux-gnu/libplds4.so (0x0=
0007faac6a66000)
>     >
>     > I got most of them, but I cannot find any statically linked libnss3=
.a.  Building that from source [1] turned out to be a nightmare, so I=E2=80=
=99m at a dead end again.
>     >
>     > [1] https://github.com/nss-dev/nss
>
>     --
>     Sitsofe | http://sucs.org/~sits/
>
> Seeing as librbd is no longer available as a static library, what about t=
he following patch to configure, which *always* includes librbd as dynamic,=
 even when a static build is requested?
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> diff --git a/configure b/configure
> index 1f4e50b1..01d5ef57 100755
> --- a/configure
> +++ b/configure
> @@ -1663,8 +1663,12 @@ int main(int argc, char **argv)
>    return 0;
>  }
>  EOF
> -if test "$disable_rbd" !=3D "yes"  && compile_prog "" "-lrbd -lrados" "r=
bd"; then
> -  LIBS=3D"-lrbd -lrados $LIBS"
> +if test "$disable_rbd" !=3D "yes"  && compile_prog "" "-Wl,-Bdynamic -lr=
bd -lrados" "rbd"; then
> +  if test "$build_static" =3D "yes" ; then
> +    LIBS=3D"-Wl,-Bdynamic -lrbd -lrados -Wl,-Bstatic $LIBS"
> +  else
> +    LIBS=3D"-lrbd -lrados"
> +  fi
>    rbd=3D"yes"
>  fi
>  print_config "Rados Block Device engine" "$rbd"
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> It violates the request for static, but it isn=E2=80=99t possible with RB=
D anyway.  Thoughts?

Maybe there needs to be a "--try-static-first" option?

--=20
Sitsofe | http://sucs.org/~sits/

