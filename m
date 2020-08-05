Return-Path: <prvs=479a3bc3e=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v3 2/4] configure: check if pkg-config is installed
Date: Wed, 5 Aug 2020 07:05:01 +0000
Message-ID: 
 <CY4PR04MB3751C92C5E4A5048EB689BADE74B0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200804013828.1569-1-dmitry.fomichev@wdc.com>
 <20200804013828.1569-3-dmitry.fomichev@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Sitsofe Wheeler <sitsofe@gmail.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

On 2020/08/04 10:38, Dmitry Fomichev wrote:=0A=
> A few libraries need to be newer than a specific version in order to be=
=0A=
> supported by fio and pkg-config utility is used to verify the versions=0A=
> of the installed libraries. Since this step may fail because pkg-config=
=0A=
> is not installed, verify pkg-config presence and warn the user if it=0A=
> could not be found.=0A=
> =0A=
> To avoid code duplication, add a common helper function to perform=0A=
> these checks.=0A=
> =0A=
> Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>=0A=
> ---=0A=
>  configure | 45 +++++++++++++++++++++++++--------------------=0A=
>  1 file changed, 25 insertions(+), 20 deletions(-)=0A=
> =0A=
> diff --git a/configure b/configure=0A=
> index 81fd32bb..dd7fe3d2 100755=0A=
> --- a/configure=0A=
> +++ b/configure=0A=
> @@ -133,6 +133,23 @@ output_sym() {=0A=
>    echo "#define $1" >> $config_host_h=0A=
>  }=0A=
>  =0A=
> +check_min_lib_version() {=0A=
> +  local feature=3D$3=0A=
> +=0A=
> +  if ${cross_prefix}pkg-config --atleast-version=3D$2 $1 > /dev/null 2>&=
1; then=0A=
> +    return 0=0A=
> +  fi=0A=
> +  : ${feature:=3D${1}}=0A=
> +  if ${cross_prefix}pkg-config --version > /dev/null 2>&1; then=0A=
> +    if test ${!feature} =3D "yes" ; then=0A=
> +      feature_not_found "$feature" "$1 >=3D $2"=0A=
> +    fi=0A=
> +  else=0A=
> +    print_config "$1" "missing pkg-config, can't check $feature version"=
=0A=
> +  fi=0A=
> +  return 1=0A=
> +}=0A=
> +=0A=
>  targetos=3D""=0A=
>  cpu=3D""=0A=
>  =0A=
> @@ -1521,18 +1538,17 @@ if test "$?" !=3D "0" ; then=0A=
>    echo "configure: gtk and gthread not found"=0A=
>    exit 1=0A=
>  fi=0A=
> -if ! ${cross_prefix}pkg-config --atleast-version 2.18.0 gtk+-2.0; then=
=0A=
> -  echo "GTK found, but need version 2.18 or higher"=0A=
> -  gfio=3D"no"=0A=
> -else=0A=
> +gfio=3D"yes"=0A=
> +if check_min_lib_version gtk+-2.0 2.18.0 "gfio"; then=0A=
>    if compile_prog "$GTK_CFLAGS" "$GTK_LIBS" "gfio" ; then=0A=
> -    gfio=3D"yes"=0A=
>      GFIO_LIBS=3D"$LIBS $GTK_LIBS"=0A=
>      CFLAGS=3D"$CFLAGS $GTK_CFLAGS"=0A=
>    else=0A=
>      echo "Please install gtk and gdk libraries"=0A=
>      gfio=3D"no"=0A=
>    fi=0A=
> +else=0A=
> +  gfio=3D"no"=0A=
>  fi=0A=
>  LDFLAGS=3D$ORG_LDFLAGS=0A=
>  fi=0A=
> @@ -2182,15 +2198,11 @@ print_config "DDN's Infinite Memory Engine" "$lib=
ime"=0A=
>  ##########################################=0A=
>  # Check if we have libiscsi=0A=
>  if test "$libiscsi" !=3D "no" ; then=0A=
> -  minimum_libiscsi=3D1.9.0=0A=
> -  if $(pkg-config --atleast-version=3D$minimum_libiscsi libiscsi); then=
=0A=
> +  if check_min_lib_version libiscsi 1.9.0; then=0A=
>      libiscsi=3D"yes"=0A=
>      libiscsi_cflags=3D$(pkg-config --cflags libiscsi)=0A=
>      libiscsi_libs=3D$(pkg-config --libs libiscsi)=0A=
>    else=0A=
> -    if test "$libiscsi" =3D "yes" ; then=0A=
> -      feature_not_found "libiscsi" "libiscsi >=3D $minimum_libiscsi"=0A=
> -    fi=0A=
>      libiscsi=3D"no"=0A=
>    fi=0A=
>  fi=0A=
> @@ -2199,15 +2211,11 @@ print_config "iscsi engine" "$libiscsi"=0A=
>  ##########################################=0A=
>  # Check if we have libnbd (for NBD support)=0A=
>  if test "$libnbd" !=3D "no" ; then=0A=
> -  minimum_libnbd=3D0.9.8=0A=
> -  if $(pkg-config --atleast-version=3D$minimum_libnbd libnbd); then=0A=
> +  if check_min_lib_version libnbd 0.9.8; then=0A=
>      libnbd=3D"yes"=0A=
>      libnbd_cflags=3D$(pkg-config --cflags libnbd)=0A=
>      libnbd_libs=3D$(pkg-config --libs libnbd)=0A=
>    else=0A=
> -    if test "$libnbd" =3D "yes" ; then=0A=
> -      feature_not_found "libnbd" "libnbd >=3D $minimum_libnbd"=0A=
> -    fi=0A=
>      libnbd=3D"no"=0A=
>    fi=0A=
>  fi=0A=
> @@ -2469,11 +2477,8 @@ int main(int argc, char **argv)=0A=
>  EOF=0A=
>  if test "$libzbc" !=3D "no" ; then=0A=
>    if compile_prog "" "-lzbc" "libzbc"; then=0A=
> -    minimum_libzbc=3D5=0A=
> -    if $(pkg-config --atleast-version=3D$minimum_libzbc libzbc); then=0A=
> -      libzbc=3D"yes"=0A=
> -    else=0A=
> -      print_config "libzbc engine" "libzbc version $minimum_libzbc or ab=
ove required"=0A=
> +    libzbc=3D"yes"=0A=
> +    if ! check_min_lib_version libzbc 5; then=0A=
>        libzbc=3D"no"=0A=
>      fi=0A=
>    else=0A=
> =0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

