Return-Path: <prvs=479a3bc3e=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v3 1/4] configure: improve libzbc version check
Date: Wed, 5 Aug 2020 07:03:09 +0000
Message-ID: 
 <CY4PR04MB3751687D4398908B65A5CB87E74B0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200804013828.1569-1-dmitry.fomichev@wdc.com>
 <20200804013828.1569-2-dmitry.fomichev@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Sitsofe Wheeler <sitsofe@gmail.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

On 2020/08/04 10:38, Dmitry Fomichev wrote:=0A=
> Avoid parsing pkg-config output and just use --atleast-version to=0A=
> check if libzbc is present and has an up to date version.=0A=
> =0A=
> Currently, support for libzbc ioengine is always included if libzbc is=0A=
> found at the build system. Add the option to disable libzbc ioengine=0A=
> support even if libzbc is found. This can be useful for=0A=
> cross-compilation.=0A=
> =0A=
> Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>=0A=
> ---=0A=
>  configure | 29 ++++++++++++++++-------------=0A=
>  1 file changed, 16 insertions(+), 13 deletions(-)=0A=
> =0A=
> diff --git a/configure b/configure=0A=
> index 5925e94f..81fd32bb 100755=0A=
> --- a/configure=0A=
> +++ b/configure=0A=
> @@ -152,6 +152,7 @@ march_set=3D"no"=0A=
>  libiscsi=3D"no"=0A=
>  libnbd=3D"no"=0A=
>  libaio_uring=3D"no"=0A=
> +libzbc=3D""=0A=
>  dynamic_engines=3D"no"=0A=
>  prefix=3D/usr/local=0A=
>  =0A=
> @@ -213,6 +214,8 @@ for opt do=0A=
>    ;;=0A=
>    --enable-libnbd) libnbd=3D"yes"=0A=
>    ;;=0A=
> +  --disable-libzbc) libzbc=3D"no"=0A=
> +  ;;=0A=
>    --disable-tcmalloc) disable_tcmalloc=3D"yes"=0A=
>    ;;=0A=
>    --enable-libaio-uring) libaio_uring=3D"yes"=0A=
> @@ -256,6 +259,7 @@ if test "$show_help" =3D "yes" ; then=0A=
>    echo "--with-ime=3D             Install path for DDN's Infinite Memory=
 Engine"=0A=
>    echo "--enable-libiscsi       Enable iscsi support"=0A=
>    echo "--enable-libnbd         Enable libnbd (NBD engine) support"=0A=
> +  echo "--disable-libzbc        Disable libzbc even if found"=0A=
>    echo "--disable-tcmalloc	Disable tcmalloc support"=0A=
>    echo "--enable-libaio-uring   Enable libaio emulated over io_uring"=0A=
>    echo "--dynamic-libengines	Lib-based ioengines as dynamic libraries"=
=0A=
> @@ -2454,9 +2458,6 @@ fi=0A=
>  =0A=
>  ##########################################=0A=
>  # libzbc probe=0A=
> -if test "$libzbc" !=3D "yes" ; then=0A=
> -  libzbc=3D"no"=0A=
> -fi=0A=
>  cat > $TMPC << EOF=0A=
>  #include <libzbc/zbc.h>=0A=
>  int main(int argc, char **argv)=0A=
> @@ -2466,19 +2467,21 @@ int main(int argc, char **argv)=0A=
>    return zbc_open("foo=3Dbar", O_RDONLY, &dev);=0A=
>  }=0A=
>  EOF=0A=
> -if compile_prog "" "-lzbc" "libzbc"; then=0A=
> -  libzbcvermaj=3D$(pkg-config --modversion libzbc | sed 's/\.[0-9]*\.[0-=
9]*//')=0A=
> -  if test "$libzbcvermaj" -ge "5" ; then=0A=
> -    libzbc=3D"yes"=0A=
> +if test "$libzbc" !=3D "no" ; then=0A=
> +  if compile_prog "" "-lzbc" "libzbc"; then=0A=
> +    minimum_libzbc=3D5=0A=
> +    if $(pkg-config --atleast-version=3D$minimum_libzbc libzbc); then=0A=
> +      libzbc=3D"yes"=0A=
> +    else=0A=
> +      print_config "libzbc engine" "libzbc version $minimum_libzbc or ab=
ove required"=0A=
> +      libzbc=3D"no"=0A=
> +    fi=0A=
>    else=0A=
> -    print_config "libzbc engine" "Unsupported libzbc version (version 5 =
or above required)"=0A=
> +    if test "$libzbc" =3D "yes" ; then=0A=
> +      feature_not_found "libzbc" "libzbc or libzbc/zbc.h"=0A=
> +    fi=0A=
>      libzbc=3D"no"=0A=
>    fi=0A=
> -else=0A=
> -  if test "$libzbc" =3D "yes" ; then=0A=
> -      feature_not_found "libzbc" "libzbc or libzbc/zbc.h"=0A=
> -  fi=0A=
> -  libzbc=3D"no"=0A=
>  fi=0A=
>  print_config "libzbc engine" "$libzbc"=0A=
>  =0A=
> =0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

