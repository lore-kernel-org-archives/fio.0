Return-Path: <prvs=4705a5bd9=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 1/3] configure: improve libzbc version check
Date: Mon, 27 Jul 2020 05:02:01 +0000
Message-ID: 
 <CY4PR04MB37518C4372FBF5B4203D468AE7720@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200727031638.28264-1-dmitry.fomichev@wdc.com>
 <20200727031638.28264-2-dmitry.fomichev@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

On 2020/07/27 12:16, Dmitry Fomichev wrote:=0A=
> Avoid parsing pkg-config output and just use --atleast-version to=0A=
> check if libzbc is present and has an up to date version. Since=0A=
> this process may fail because pkg-config is not installed, verify=0A=
> pkg-config presence and warn the user if it was not found.=0A=
> =0A=
> Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>=0A=
> ---=0A=
>  configure | 9 ++++++---=0A=
>  1 file changed, 6 insertions(+), 3 deletions(-)=0A=
> =0A=
> diff --git a/configure b/configure=0A=
> index 5925e94f..0c4a96ec 100755=0A=
> --- a/configure=0A=
> +++ b/configure=0A=
> @@ -2467,11 +2467,14 @@ int main(int argc, char **argv)=0A=
>  }=0A=
>  EOF=0A=
>  if compile_prog "" "-lzbc" "libzbc"; then=0A=
> -  libzbcvermaj=3D$(pkg-config --modversion libzbc | sed 's/\.[0-9]*\.[0-=
9]*//')=0A=
> -  if test "$libzbcvermaj" -ge "5" ; then=0A=
> +  if $(pkg-config --atleast-version=3D5 libzbc); then=0A=
>      libzbc=3D"yes"=0A=
> +    LIBS=3D"-lzbc $LIBS"=0A=
> +  elif pkg-config --version > /dev/null 2>&1; then=0A=
> +    print_config "libzbc engine" "libzbc version 5 or above required"=0A=
> +    libzbc=3D"no"=0A=
>    else=0A=
> -    print_config "libzbc engine" "Unsupported libzbc version (version 5 =
or above required)"=0A=
> +    print_config "libzbc engine" "missing pkg-config, can't check librar=
y version"=0A=
>      libzbc=3D"no"=0A=
>    fi=0A=
>  else=0A=
> =0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

