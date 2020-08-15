Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728717AbgHOVv1 (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 15 Aug 2020 17:51:27 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF731C004592
        for <fio@vger.kernel.org>; Sat, 15 Aug 2020 11:48:21 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id a5so13745492ioa.13
        for <fio@vger.kernel.org>; Sat, 15 Aug 2020 11:48:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200804013828.1569-1-dmitry.fomichev@wdc.com>
 <20200804013828.1569-3-dmitry.fomichev@wdc.com> <CY4PR04MB3751C92C5E4A5048EB689BADE74B0@CY4PR04MB3751.namprd04.prod.outlook.com>
In-Reply-To: <CY4PR04MB3751C92C5E4A5048EB689BADE74B0@CY4PR04MB3751.namprd04.prod.outlook.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Date: Sun, 16 Aug 2020 03:47:44 +0900
Message-ID: <CAHndrBmszp=crv_bqHo7FxPsgJZOWBKF9Crv7bT0hHVcN92jmg@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] configure: check if pkg-config is installed
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

2020=E5=B9=B48=E6=9C=885=E6=97=A5(=E6=B0=B4) 16:06 Damien Le Moal <Damien.L=
eMoal@wdc.com>:
>
> On 2020/08/04 10:38, Dmitry Fomichev wrote:
> > A few libraries need to be newer than a specific version in order to be
> > supported by fio and pkg-config utility is used to verify the versions
> > of the installed libraries. Since this step may fail because pkg-config
> > is not installed, verify pkg-config presence and warn the user if it
> > could not be found.
> >
> > To avoid code duplication, add a common helper function to perform
> > these checks.

This line
"if test ${!feature} =3D "yes" ; then"
seems to have broken compilation on some BSD's.

[root@localhost fio]# uname
NetBSD
[root@localhost fio]# gmake clean && gmake
FIO_VERSION =3D fio-3.21-56-g0ce7e
Running configure ...
./configure: 144: Syntax error: Bad substitution
Makefile:19: config-host.mak: No such file or directory
gmake: *** [Makefile:10: config-host.mak] Error 2


> >
> > Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
> > ---
> >  configure | 45 +++++++++++++++++++++++++--------------------
> >  1 file changed, 25 insertions(+), 20 deletions(-)
> >
> > diff --git a/configure b/configure
> > index 81fd32bb..dd7fe3d2 100755
> > --- a/configure
> > +++ b/configure
> > @@ -133,6 +133,23 @@ output_sym() {
> >    echo "#define $1" >> $config_host_h
> >  }
> >
> > +check_min_lib_version() {
> > +  local feature=3D$3
> > +
> > +  if ${cross_prefix}pkg-config --atleast-version=3D$2 $1 > /dev/null 2=
>&1; then
> > +    return 0
> > +  fi
> > +  : ${feature:=3D${1}}
> > +  if ${cross_prefix}pkg-config --version > /dev/null 2>&1; then
> > +    if test ${!feature} =3D "yes" ; then
> > +      feature_not_found "$feature" "$1 >=3D $2"
> > +    fi
> > +  else
> > +    print_config "$1" "missing pkg-config, can't check $feature versio=
n"
> > +  fi
> > +  return 1
> > +}
> > +
> >  targetos=3D""
> >  cpu=3D""
> >
> > @@ -1521,18 +1538,17 @@ if test "$?" !=3D "0" ; then
> >    echo "configure: gtk and gthread not found"
> >    exit 1
> >  fi
> > -if ! ${cross_prefix}pkg-config --atleast-version 2.18.0 gtk+-2.0; then
> > -  echo "GTK found, but need version 2.18 or higher"
> > -  gfio=3D"no"
> > -else
> > +gfio=3D"yes"
> > +if check_min_lib_version gtk+-2.0 2.18.0 "gfio"; then
> >    if compile_prog "$GTK_CFLAGS" "$GTK_LIBS" "gfio" ; then
> > -    gfio=3D"yes"
> >      GFIO_LIBS=3D"$LIBS $GTK_LIBS"
> >      CFLAGS=3D"$CFLAGS $GTK_CFLAGS"
> >    else
> >      echo "Please install gtk and gdk libraries"
> >      gfio=3D"no"
> >    fi
> > +else
> > +  gfio=3D"no"
> >  fi
> >  LDFLAGS=3D$ORG_LDFLAGS
> >  fi
> > @@ -2182,15 +2198,11 @@ print_config "DDN's Infinite Memory Engine" "$l=
ibime"
> >  ##########################################
> >  # Check if we have libiscsi
> >  if test "$libiscsi" !=3D "no" ; then
> > -  minimum_libiscsi=3D1.9.0
> > -  if $(pkg-config --atleast-version=3D$minimum_libiscsi libiscsi); the=
n
> > +  if check_min_lib_version libiscsi 1.9.0; then
> >      libiscsi=3D"yes"
> >      libiscsi_cflags=3D$(pkg-config --cflags libiscsi)
> >      libiscsi_libs=3D$(pkg-config --libs libiscsi)
> >    else
> > -    if test "$libiscsi" =3D "yes" ; then
> > -      feature_not_found "libiscsi" "libiscsi >=3D $minimum_libiscsi"
> > -    fi
> >      libiscsi=3D"no"
> >    fi
> >  fi
> > @@ -2199,15 +2211,11 @@ print_config "iscsi engine" "$libiscsi"
> >  ##########################################
> >  # Check if we have libnbd (for NBD support)
> >  if test "$libnbd" !=3D "no" ; then
> > -  minimum_libnbd=3D0.9.8
> > -  if $(pkg-config --atleast-version=3D$minimum_libnbd libnbd); then
> > +  if check_min_lib_version libnbd 0.9.8; then
> >      libnbd=3D"yes"
> >      libnbd_cflags=3D$(pkg-config --cflags libnbd)
> >      libnbd_libs=3D$(pkg-config --libs libnbd)
> >    else
> > -    if test "$libnbd" =3D "yes" ; then
> > -      feature_not_found "libnbd" "libnbd >=3D $minimum_libnbd"
> > -    fi
> >      libnbd=3D"no"
> >    fi
> >  fi
> > @@ -2469,11 +2477,8 @@ int main(int argc, char **argv)
> >  EOF
> >  if test "$libzbc" !=3D "no" ; then
> >    if compile_prog "" "-lzbc" "libzbc"; then
> > -    minimum_libzbc=3D5
> > -    if $(pkg-config --atleast-version=3D$minimum_libzbc libzbc); then
> > -      libzbc=3D"yes"
> > -    else
> > -      print_config "libzbc engine" "libzbc version $minimum_libzbc or =
above required"
> > +    libzbc=3D"yes"
> > +    if ! check_min_lib_version libzbc 5; then
> >        libzbc=3D"no"
> >      fi
> >    else
> >
>
> Looks good.
>
> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
>
> --
> Damien Le Moal
> Western Digital Research

