Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
References: <20190813020136.15798-1-bvanassche@acm.org> <20190813020136.15798-6-bvanassche@acm.org>
 <CALjAwxjBiG9UsTfcB7zQohbtu7QofGhf3qvbi9T9TT-Kv=oeCw@mail.gmail.com> <aafcc9f9-67fc-10c8-1b6e-b9d8cd4621a3@acm.org>
In-Reply-To: <aafcc9f9-67fc-10c8-1b6e-b9d8cd4621a3@acm.org>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 13 Aug 2019 21:10:24 +0100
Message-ID: <CALjAwxi-NujdSFZPP48GZ=vovkmz43qyP1-8OzERJxJK0D3knQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] make test: Also run zbd tests
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>, fio <fio@vger.kernel.org>, Damien Le Moal <damien.lemoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On Tue, 13 Aug 2019 at 16:06, Bart Van Assche <bvanassche@acm.org> wrote:
>
> On 8/12/19 9:39 PM, Sitsofe Wheeler wrote:
> > On Tue, 13 Aug 2019 at 03:02, Bart Van Assche <bvanassche@acm.org> wrot=
e:
> >>   test: fio
> >>          ./fio --minimal --thread --exitall_on_error --runtime=3D1s --=
name=3Dnulltest --ioengine=3Dnull --rw=3Drandrw --iodepth=3D2 --norandommap=
 --random_generator=3Dtausworthe64 --size=3D16T --name=3Dverifyfstest --fil=
ename=3Dfiotestfile.tmp --unlink=3D1 --rw=3Dwrite --verify=3Dcrc32c --verif=
y_state_save=3D0 --size=3D16K
> >> +       if modinfo null_blk >/dev/null 2>&1 &&                        =
         \
> >> +               sudo modprobe null_blk &&                             =
         \
> >> +               [ -e /sys/kernel/config/nullb ]; then                 =
         \
> >> +               git clone https://github.com/hgst/libzbc &&           =
         \
> >> +               (cd libzbc &&                                         =
         \
> >> +               ./autogen.sh &&                                       =
         \
> >> +               ./configure --prefix=3D/usr &&                        =
           \
> >> +               make -j &&                                            =
         \
> >> +               sudo make install) &&                                 =
         \
> >> +               sudo t/zbd/run-tests-against-regular-nullb &&         =
         \
> >> +               if modinfo null_blk | grep -q '^parm:[[:blank:]]*zoned=
:'; then \
> >> +                       sudo t/zbd/run-tests-against-zoned-nullb;     =
         \
> >> +               fi;                                                   =
         \
> >> +       fi
> >>
> >>   install: $(PROGS) $(SCRIPTS) tools/plot/fio2gnuplot.1 FORCE
> >>          $(INSTALL) -m 755 -d $(DESTDIR)$(bindir)
> >>
> >
> > I don't feel comfortable trying to clone a repo, run sudo, installing
> > stuff as root and loading a kernel module just because someone ran
> > "make test". Maybe we should introduce another target for this?
>
> Hi Sitsofe,
>
> How about executing the new code only on Travis, e.g. by checking
> whether the TRAVIS environment variable has been set?

That's a bit better but I still think we could introduce a test_travis
target, have travis call that and run any extra commands we want...

--=20
Sitsofe | http://sucs.org/~sits/

