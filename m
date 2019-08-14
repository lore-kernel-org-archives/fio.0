Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
References: <20190814201012.253060-1-bvanassche@acm.org> <20190814201012.253060-8-bvanassche@acm.org>
In-Reply-To: <20190814201012.253060-8-bvanassche@acm.org>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 14 Aug 2019 22:11:18 +0100
Message-ID: <CALjAwxjQ_dukjjVH6qnrZTJL-jbcsx6FgbfENJxvdsCJk5fUag@mail.gmail.com>
Subject: Re: [PATCH v3 7/7] Makefile: Add 'fulltest' target
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Wed, 14 Aug 2019 at 21:12, Bart Van Assche <bvanassche@acm.org> wrote:
>
> Make it easier to run the zoned block device tests.
>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  Makefile | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>
> diff --git a/Makefile b/Makefile
> index fe02bf1df86f..7c21ef8316f7 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -531,6 +531,21 @@ doc: tools/plot/fio2gnuplot.1
>  test: fio
>         ./fio --minimal --thread --exitall_on_error --runtime=3D1s --name=
=3Dnulltest --ioengine=3Dnull --rw=3Drandrw --iodepth=3D2 --norandommap --r=
andom_generator=3Dtausworthe64 --size=3D16T --name=3Dverifyfstest --filenam=
e=3Dfiotestfile.tmp --unlink=3D1 --rw=3Dwrite --verify=3Dcrc32c --verify_st=
ate_save=3D0 --size=3D16K
>
> +fulltest:
> +       sudo modprobe null_blk &&                                       \
> +       if [ ! -e /usr/include/libzbc/zbc.h ]; then                     \
> +         git clone https://github.com/hgst/libzbc &&                   \
> +         (cd libzbc &&                                                 \
> +          ./autogen.sh &&                                              \
> +          ./configure --prefix=3D/usr &&                                =
 \
> +          make -j &&                                                   \
> +          sudo make install)                                           \
> +       fi &&                                                           \
> +       sudo t/zbd/run-tests-against-regular-nullb &&                   \
> +       if [ -e /sys/module/null_blk/parameters/zoned ]; then           \
> +               sudo t/zbd/run-tests-against-zoned-nullb;               \
> +       fi
> +
>  install: $(PROGS) $(SCRIPTS) tools/plot/fio2gnuplot.1 FORCE
>         $(INSTALL) -m 755 -d $(DESTDIR)$(bindir)
>         $(INSTALL) $(PROGS) $(SCRIPTS) $(DESTDIR)$(bindir)
> @@ -541,3 +556,5 @@ install: $(PROGS) $(SCRIPTS) tools/plot/fio2gnuplot.1=
 FORCE
>         $(INSTALL) -m 644 $(SRCDIR)/tools/hist/fiologparser_hist.py.1 $(D=
ESTDIR)$(mandir)/man1
>         $(INSTALL) -m 755 -d $(DESTDIR)$(sharedir)
>         $(INSTALL) -m 644 $(SRCDIR)/tools/plot/*gpm $(DESTDIR)$(sharedir)=
/
> +
> +.PHONY: test fulltest
> --
> 2.22.0.rc1
>

Looks good. We just need to switch
https://github.com/axboe/fio/blob/master/.travis.yml over to run
both...

--=20
Sitsofe | http://sucs.org/~sits/

