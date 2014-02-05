Return-Path: <axboe@kernel.dk>
Date: Wed, 5 Feb 2014 14:38:10 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] fix rand_seed mismatches in verify phase
Message-ID: <20140205213810.GD20626@kernel.dk>
References: <1391463077-14292-1-git-send-email-puthik@chromium.org>
 <CANEJEGuTmYm2k1M3BUmoxCVD99wCTyLjyRrT9HS=MMFBStrA5A@mail.gmail.com>
 <CANCcNXcmQNNcgFthc+JENyz3noH8HY2JsLjNG7ZBk5_soZGf_g@mail.gmail.com>
 <20140205182718.GG27534@kernel.dk>
 <CANEJEGsdxoLrJ7o22tVtCw1s8XwHeDJ7znwSYsFR6BvM7pQrPw@mail.gmail.com>
 <20140205193006.GH27534@kernel.dk>
 <CANEJEGtx5stx0FzorE1YJNhqaypRK79spv2x_oQtmUsuiLp=Ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANEJEGtx5stx0FzorE1YJNhqaypRK79spv2x_oQtmUsuiLp=Ag@mail.gmail.com>
To: Grant Grundler <grundler@chromium.org>
Cc: Puthikorn Voravootivat <puthik@chromium.org>, FIO List <fio@vger.kernel.org>, Gwendal Grignou <gwendal@chromium.org>
List-ID: <fio@vger.kernel.org>

On Wed, Feb 05 2014, Grant Grundler wrote:
> On Wed, Feb 5, 2014 at 11:30 AM, Jens Axboe <axboe@kernel.dk> wrote:
> ...
> > The below should take care of it. Juan's fix didn't account for verify
> > exceeding size=.
> 
> Ah...Juan didn't test with that option and Puthikorn did.
> 
> > diff --git a/backend.c b/backend.c
> > index bf9d066e012a..3ac72e771cb9 100644
> > --- a/backend.c
> > +++ b/backend.c
> > @@ -642,7 +642,7 @@ static uint64_t do_io(struct thread_data *td)
> >         uint64_t bytes_done[DDIR_RWDIR_CNT] = { 0, 0, 0 };
> >         unsigned int i;
> >         int ret = 0;
> > -       uint64_t bytes_issued = 0;
> > +       uint64_t total_bytes, bytes_issued = 0;
> >
> >         if (in_ramp_time(td))
> >                 td_set_runstate(td, TD_RAMP);
> > @@ -651,6 +651,10 @@ static uint64_t do_io(struct thread_data *td)
> >
> >         lat_target_init(td);
> >
> > +       total_bytes = td->o.size;
> > +       if (td->o.verify != VERIFY_NONE && td_write(td))
> > +               total_bytes += td->o.size;
> > +
> 
> The amount of verify IO depends on what percentage is write traffic.
> Is each thread strictly reader or writer?

It does indeed. Note I updated this to depend on verify_backlog as well,
since that is the important bit. Each thread can have any mix of
read/write/trim.

> I didn't think so or we wouldn't need "td->this_io_bytes[]" for
> DDIR_WRITE, DDIR_READ, and DDIR_TRIM at the same time.
> 
> >         while ((td->o.read_iolog_file && !flist_empty(&td->io_log_list)) ||
> >                 (!flist_empty(&td->trim_list)) || !io_bytes_exceeded(td) ||
> 
> I've gotten a bit hung up on what io_bytes_exceeded() uses (
> td->this_io_bytes[]), bytes_done[], and bytes_issued. Seems like we
> have three different mechanisms to do essentially the same thing. Can
> I rip two of them out and just count "issued IO" for WRITE/READ/TRIM?

this_io_bytes[] is per loop.
> 
> "io_bytes_exceeded()" is the only place I would expect this logic to
> live in this loop. Having additional "break" in the middle of the loop
> implies we've broken the original design.

The fix is a bit of a hack, but the original commit was a hack too. It
would be a lot better to track this explicitly. For now it's just an
upper cap, normally we expect other conditions to terminate it.

So I'd welcome a cleanup in this area for sure.

-- 
Jens Axboe


