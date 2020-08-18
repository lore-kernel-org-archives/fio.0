Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
References: <20200817234708.20701-1-dmitry.fomichev@wdc.com>
In-Reply-To: <20200817234708.20701-1-dmitry.fomichev@wdc.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 18 Aug 2020 09:00:02 +0100
Message-ID: <CALjAwxixHyY8b3y=oNkNpuMvqNoPGRXZy25kN7E14sZLuZ9Mhg@mail.gmail.com>
Subject: Re: [PATCH] configure: fix syntax error with NetBSD
Content-Type: text/plain; charset="UTF-8"
To: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, Tomohiro Kusumi <kusumi.tomohiro@gmail.com>, fio <fio@vger.kernel.org>, Damien Le Moal <damien.lemoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On Tue, 18 Aug 2020 at 00:48, Dmitry Fomichev <dmitry.fomichev@wdc.com> wrote:
>
> The recent patch to detect for pkg-config presence has introduced some
> bash-specific code to configure script. This lead to syntax errors
> while running configure under some other shells, such as (d)ash.
>
> Avoid ${!var} indirect substitution syntax and stop using "local"
> keyword which is non-POSIX-standard. Address a few minor shellcheck
> complaints about the code in same function.
>
> Fixes: 162f8c2a96ae181d7e4099af8e9f39b5eac6886e
> Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
> ---
>  configure | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/configure b/configure
> index dd7fe3d2..d3997b5f 100755
> --- a/configure
> +++ b/configure
> @@ -134,18 +134,18 @@ output_sym() {
>  }
>
>  check_min_lib_version() {
> -  local feature=$3
> +  _feature=$3
>
> -  if ${cross_prefix}pkg-config --atleast-version=$2 $1 > /dev/null 2>&1; then
> +  if "${cross_prefix}"pkg-config --atleast-version="$2" "$1" > /dev/null 2>&1; then
>      return 0
>    fi
> -  : ${feature:=${1}}
> -  if ${cross_prefix}pkg-config --version > /dev/null 2>&1; then
> -    if test ${!feature} = "yes" ; then
> -      feature_not_found "$feature" "$1 >= $2"
> +  : "${_feature:=${1}}"
> +  if "${cross_prefix}"pkg-config --version > /dev/null 2>&1; then
> +    if eval "echo \$$_feature" = "yes" ; then

Stuff this into another variable once (e.g. feature_var) and then just
use that variable.

> +      feature_not_found "$_feature" "$1 >= $2"
>      fi
>    else
> -    print_config "$1" "missing pkg-config, can't check $feature version"
> +    print_config "$1" "missing pkg-config, can't check $_feature version"
>    fi
>    return 1
>  }
> --
> 2.21.0
>


-- 
Sitsofe | http://sucs.org/~sits/

