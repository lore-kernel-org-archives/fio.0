Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
References: <20190813020136.15798-1-bvanassche@acm.org> <20190813020136.15798-6-bvanassche@acm.org>
In-Reply-To: <20190813020136.15798-6-bvanassche@acm.org>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 13 Aug 2019 05:39:03 +0100
Message-ID: <CALjAwxjBiG9UsTfcB7zQohbtu7QofGhf3qvbi9T9TT-Kv=oeCw@mail.gmail.com>
Subject: Re: [PATCH 5/5] make test: Also run zbd tests
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>, fio <fio@vger.kernel.org>, Damien Le Moal <damien.lemoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On Tue, 13 Aug 2019 at 03:02, Bart Van Assche <bvanassche@acm.org> wrote:
>
> Include the ZBD tests in Travis runs such that the ZBD tests are run when
> a fio pull request is submitted from the github website.
>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  .travis.yml |  3 +++
>  Makefile    | 14 ++++++++++++++
>  2 files changed, 17 insertions(+)
>
> diff --git a/.travis.yml b/.travis.yml
> index 4a87fe6c45f8..26ed74ab7416 100644
> --- a/.travis.yml
> +++ b/.travis.yml
> @@ -1,4 +1,7 @@
>  language: c
> +sudo: required
> +# Choose trusty because the default dist (xenial) does not have null_blk
> +dist: trusty
>  os:
>    - linux
>  compiler:
> diff --git a/Makefile b/Makefile
> index fe02bf1df86f..803074e7db7f 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -530,6 +530,20 @@ doc: tools/plot/fio2gnuplot.1
>
>  test: fio
>         ./fio --minimal --thread --exitall_on_error --runtime=3D1s --name=
=3Dnulltest --ioengine=3Dnull --rw=3Drandrw --iodepth=3D2 --norandommap --r=
andom_generator=3Dtausworthe64 --size=3D16T --name=3Dverifyfstest --filenam=
e=3Dfiotestfile.tmp --unlink=3D1 --rw=3Dwrite --verify=3Dcrc32c --verify_st=
ate_save=3D0 --size=3D16K
> +       if modinfo null_blk >/dev/null 2>&1 &&                           =
      \
> +               sudo modprobe null_blk &&                                =
      \
> +               [ -e /sys/kernel/config/nullb ]; then                    =
      \
> +               git clone https://github.com/hgst/libzbc &&              =
      \
> +               (cd libzbc &&                                            =
      \
> +               ./autogen.sh &&                                          =
      \
> +               ./configure --prefix=3D/usr &&                           =
        \
> +               make -j &&                                               =
      \
> +               sudo make install) &&                                    =
      \
> +               sudo t/zbd/run-tests-against-regular-nullb &&            =
      \
> +               if modinfo null_blk | grep -q '^parm:[[:blank:]]*zoned:';=
 then \
> +                       sudo t/zbd/run-tests-against-zoned-nullb;        =
      \
> +               fi;                                                      =
      \
> +       fi
>
>  install: $(PROGS) $(SCRIPTS) tools/plot/fio2gnuplot.1 FORCE
>         $(INSTALL) -m 755 -d $(DESTDIR)$(bindir)
> --
> 2.22.0
>

I don't feel comfortable trying to clone a repo, run sudo, installing
stuff as root and loading a kernel module just because someone ran
"make test". Maybe we should introduce another target for this?

--=20
Sitsofe | http://sucs.org/~sits/

