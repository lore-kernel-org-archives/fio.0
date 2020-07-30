Return-Path: <prvs=4732f4b49=Dmitry.Fomichev@wdc.com>
From: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: RE: [PATCH v2 1/4] configure: improve libzbc version check
Date: Thu, 30 Jul 2020 23:09:45 +0000
Message-ID: 
 <MN2PR04MB59519F3A6FCC32DFCEC891B3E1710@MN2PR04MB5951.namprd04.prod.outlook.com>
References: <20200729210415.4166-1-dmitry.fomichev@wdc.com>
 <20200729210415.4166-2-dmitry.fomichev@wdc.com>
 <CY4PR04MB3751CCE0FB675C4906F9C414E7710@CY4PR04MB3751.namprd04.prod.outlook.com>
In-Reply-To: 
 <CY4PR04MB3751CCE0FB675C4906F9C414E7710@CY4PR04MB3751.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Sitsofe Wheeler <sitsofe@gmail.com>
List-ID: <fio@vger.kernel.org>



> -----Original Message-----
> From: Damien Le Moal <Damien.LeMoal@wdc.com>
> Sent: Thursday, July 30, 2020 12:54 AM
> To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>; Jens Axboe
> <axboe@kernel.dk>
> Cc: fio@vger.kernel.org; Shinichiro Kawasaki
> <shinichiro.kawasaki@wdc.com>
> Subject: Re: [PATCH v2 1/4] configure: improve libzbc version check
>=20
> On 2020/07/30 6:04, Dmitry Fomichev wrote:
> > Avoid parsing pkg-config output and just use --atleast-version to
> > check if libzbc is present and has an up to date version.
> >
> > Currently, support for libzbc ioengine is always included if libzbc is
> > found at the build system. Add the option to disable libzbc ioengine
> > support even if libzbc is found. This can be useful for
> > cross-compilation.
> >
> > Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
> > ---
> >  configure | 28 +++++++++++++++-------------
> >  1 file changed, 15 insertions(+), 13 deletions(-)
> >
> > diff --git a/configure b/configure
> > index 5925e94f..9a5f35f2 100755
> > --- a/configure
> > +++ b/configure
> > @@ -213,6 +213,8 @@ for opt do
> >    ;;
> >    --enable-libnbd) libnbd=3D"yes"
> >    ;;
> > +  --disable-libzbc) libzbc=3D"no"
> > +  ;;
> >    --disable-tcmalloc) disable_tcmalloc=3D"yes"
> >    ;;
> >    --enable-libaio-uring) libaio_uring=3D"yes"
> > @@ -256,6 +258,7 @@ if test "$show_help" =3D "yes" ; then
> >    echo "--with-ime=3D             Install path for DDN's Infinite Memo=
ry Engine"
> >    echo "--enable-libiscsi       Enable iscsi support"
> >    echo "--enable-libnbd         Enable libnbd (NBD engine) support"
> > +  echo "--disable-libzbc        Disable libzbc even if found"
>=20
> The message could simply be "Disable libzbc support".
>=20
> >    echo "--disable-tcmalloc	Disable tcmalloc support"
> >    echo "--enable-libaio-uring   Enable libaio emulated over io_uring"
> >    echo "--dynamic-libengines	Lib-based ioengines as dynamic libraries"
> > @@ -2454,9 +2457,6 @@ fi
> >
> >  ##########################################
> >  # libzbc probe
> > -if test "$libzbc" !=3D "yes" ; then
> > -  libzbc=3D"no"
> > -fi
> >  cat > $TMPC << EOF
> >  #include <libzbc/zbc.h>
> >  int main(int argc, char **argv)
> > @@ -2466,19 +2466,21 @@ int main(int argc, char **argv)
> >    return zbc_open("foo=3Dbar", O_RDONLY, &dev);
> >  }
> >  EOF
> > -if compile_prog "" "-lzbc" "libzbc"; then
> > -  libzbcvermaj=3D$(pkg-config --modversion libzbc | sed 's/\.[0-9]*\.[=
0-
> 9]*//')
> > -  if test "$libzbcvermaj" -ge "5" ; then
> > -    libzbc=3D"yes"
> > +if test "$libzbc" !=3D "no" ; then
>=20
> If you make this:
>=20
> if test "$libzbc" =3D "yes" ; then
>=20
> > +  if compile_prog "" "-lzbc" "libzbc"; then
> > +    minimum_libzbc=3D5
> > +    if $(pkg-config --atleast-version=3D$minimum_libzbc libzbc); then
> > +      libzbc=3D"yes"
> > +    else
> > +      print_config "libzbc engine" "libzbc version $minimum_libzbc or =
above
> required"
> > +      libzbc=3D"no"
> > +    fi
>=20
> then you can simplify the above by reversing the if condition,
>=20
> >    else
> > -    print_config "libzbc engine" "Unsupported libzbc version (version =
5 or
> above required)"
> > +    if test "$libzbc" =3D "yes" ; then
>=20
> and you do not need this if. Note that I think you need to initialize the=
 libzbc
> variable to "yes" by default for this to work.
>=20

Right now, there is no default for libzbc ioengine support. If libzbc is fo=
und by
configure, then libzbc ioengine will always be added. The new flag, --disab=
le-libzbc,
prevents adding support for libzbc ioengine in this case. If libzbc is not =
present,
fio configure is not failed with "feature not found".

Currently, no other feature in fio configure has the default option of "yes=
" and all
features that can be explicitly set to yes are set so by script command lin=
e options.
If a feature is set to yes and is not available, configure fails with "feat=
ure not found"
error. Do we really want configure to fail on any system that doesn't have =
libzbc
unless --disable-libzbc is added to the command line?

There is one feature option, "disable_lex",  with the default value, "". I =
guess we
could define libzbc option the same way to improve code clarity.

> > +      feature_not_found "libzbc" "libzbc or libzbc/zbc.h"
> > +    fi
> >      libzbc=3D"no"
> >    fi
> > -else
> > -  if test "$libzbc" =3D "yes" ; then
> > -      feature_not_found "libzbc" "libzbc or libzbc/zbc.h"
> > -  fi
> > -  libzbc=3D"no"
> >  fi
> >  print_config "libzbc engine" "$libzbc"
> >
> >
>=20
>=20
> --
> Damien Le Moal
> Western Digital Research

