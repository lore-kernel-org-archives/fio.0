Return-Path: <prvs=4732f4b49=Dmitry.Fomichev@wdc.com>
From: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: RE: [PATCH v2 2/4] configure: check if pkg-config is installed
Date: Thu, 30 Jul 2020 23:10:17 +0000
Message-ID: 
 <MN2PR04MB5951014D567FC00446496FC4E1710@MN2PR04MB5951.namprd04.prod.outlook.com>
References: <20200729210415.4166-1-dmitry.fomichev@wdc.com>
 <20200729210415.4166-3-dmitry.fomichev@wdc.com>
 <CY4PR04MB3751447CD156144A978738D3E7710@CY4PR04MB3751.namprd04.prod.outlook.com>
In-Reply-To: 
 <CY4PR04MB3751447CD156144A978738D3E7710@CY4PR04MB3751.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Sitsofe Wheeler <sitsofe@gmail.com>
List-ID: <fio@vger.kernel.org>



> -----Original Message-----
> From: Damien Le Moal <Damien.LeMoal@wdc.com>
> Sent: Thursday, July 30, 2020 1:03 AM
> To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>; Jens Axboe
> <axboe@kernel.dk>
> Cc: fio@vger.kernel.org; Shinichiro Kawasaki
> <shinichiro.kawasaki@wdc.com>
> Subject: Re: [PATCH v2 2/4] configure: check if pkg-config is installed
>=20
> On 2020/07/30 6:04, Dmitry Fomichev wrote:
> > A few libraries need to be newer than a specific version in order to be
> > supported by fio and pkg-config utility is used to verify the versions
> > of the installed libraries. Since this step may fail because pkg-config
> > is not installed, verify pkg-config presence and warn the user if it
> > could not be found.
> >
> > To avoid code duplication, add a common helper function to perform
> > these checks.
> >
> > Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
> > ---
> >  configure | 45 +++++++++++++++++++++++++--------------------
> >  1 file changed, 25 insertions(+), 20 deletions(-)
> >
> > diff --git a/configure b/configure
> > index 9a5f35f2..01fa5d1c 100755
> > --- a/configure
> > +++ b/configure
> > @@ -133,6 +133,23 @@ output_sym() {
> >    echo "#define $1" >> $config_host_h
> >  }
> >
> > +check_min_lib_version() {
> > +  local feature
> > +
> > +  if ${cross_prefix}pkg-config --atleast-version=3D$2 $1 > /dev/null 2=
>&1;
> then
> > +    return 0
> > +  fi
> > +  if ${cross_prefix}pkg-config --version > /dev/null 2>&1; then
> > +    feature=3D${3:=3D$1}
> > +    if test ${!feature} =3D "yes" ; then
> > +      feature_not_found "" "$1 >=3D $2"
> > +    fi
> > +  else
> > +    print_config "$1" "missing pkg-config, can't check library version=
"
> > +  fi
> > +  return 1
> > +}
> > +
> >  targetos=3D""
> >  cpu=3D""
> >
> > @@ -1520,18 +1537,17 @@ if test "$?" !=3D "0" ; then
> >    echo "configure: gtk and gthread not found"
> >    exit 1
> >  fi
> > -if ! ${cross_prefix}pkg-config --atleast-version 2.18.0 gtk+-2.0; then
> > -  echo "GTK found, but need version 2.18 or higher"
> > -  gfio=3D"no"
> > -else
> > +gfio=3D"yes"
>=20
> I do not think adding this line is necessary. You can just keep the below
> gfio=3D"yes" assignment, no ?
>=20
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
> > @@ -2181,15 +2197,11 @@ print_config "DDN's Infinite Memory Engine"
> "$libime"
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
>=20
> Why do you remove this ? You only need to remove the "if" but should keep
> the
> feature_not_found call.

The feature_not_found call is now part of check_min_lib_version() function =
code.
I think it is the right thing to do to avoid code duplication. Also, this u=
nifies the
script behavior when an out of date library is found - the message in libzb=
c case
will be similar to libiscsi and libnbd.

>=20
> >      libiscsi=3D"no"
> >    fi
> >  fi
> > @@ -2198,15 +2210,11 @@ print_config "iscsi engine" "$libiscsi"
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
>=20
> Same here.

I need to mention that this patch has been tested against all the four libr=
aries affected.

>=20
> >      libnbd=3D"no"
> >    fi
> >  fi
> > @@ -2468,11 +2476,8 @@ int main(int argc, char **argv)
> >  EOF
> >  if test "$libzbc" !=3D "no" ; then
> >    if compile_prog "" "-lzbc" "libzbc"; then
> > -    minimum_libzbc=3D5
> > -    if $(pkg-config --atleast-version=3D$minimum_libzbc libzbc); then
> > -      libzbc=3D"yes"
> > -    else
> > -      print_config "libzbc engine" "libzbc version $minimum_libzbc or =
above
> required"
> > +    libzbc=3D"yes"
> > +    if ! check_min_lib_version libzbc 5; then
>=20
> OK. So my comment on the previous patch is addressed here. But I still do
> not
> see an initialization of libzbc to "yes"

Replied in the email for the other patch, the way it works now might actual=
ly be ok...

>=20
> >        libzbc=3D"no"
> >      fi
> >    else
> >
>=20
>=20
> --
> Damien Le Moal
> Western Digital Research

