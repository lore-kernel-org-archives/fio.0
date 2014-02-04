Return-Path: <grundler@google.com>
MIME-Version: 1.0
Sender: grundler@google.com
In-Reply-To: <CANCcNXcmQNNcgFthc+JENyz3noH8HY2JsLjNG7ZBk5_soZGf_g@mail.gmail.com>
References: <1391463077-14292-1-git-send-email-puthik@chromium.org>
	<CANEJEGuTmYm2k1M3BUmoxCVD99wCTyLjyRrT9HS=MMFBStrA5A@mail.gmail.com>
	<CANCcNXcmQNNcgFthc+JENyz3noH8HY2JsLjNG7ZBk5_soZGf_g@mail.gmail.com>
Date: Tue, 4 Feb 2014 11:21:58 -0800
Message-ID: <CANEJEGsNkBraCAANR+x7JkT4hJp0AR651NQws+bWsnYhgFB1rA@mail.gmail.com>
Subject: Re: [PATCH] fix rand_seed mismatches in verify phase
From: Grant Grundler <grundler@chromium.org>
Content-Type: text/plain; charset=UTF-8
To: Puthikorn Voravootivat <puthik@chromium.org>
Cc: Grant Grundler <grundler@chromium.org>, Jens Axboe <axboe@kernel.dk>, FIO List <fio@vger.kernel.org>, Gwendal Grignou <gwendal@chromium.org>
List-ID: <fio@vger.kernel.org>

On Tue, Feb 4, 2014 at 10:54 AM, Puthikorn Voravootivat
<puthik@chromium.org> wrote:
> I tried to run the same test with fio 2.1.3 and saw the same error.
> This error always occurs when rw=read or randread and verify_backlog=1
>
> Here is an example job file and error message.
>
> Job file:
> [md5-sync-1-0-1-1-1]
> filename=test213/fio/md5-sync-1-0-1-1-1
> loops=1
> direct=0
> iodepth=1
> ioengine=sync
> verify=md5
> size=1m
> bs=4k
> rw=read
> verifysort=1
> verify_backlog=1
>
> Error message:
> verify: bad magic header 869, wanted acca at file
> test213/fio/md5-sync-1-0-1-1-1 offset 585728, length 2290190

Jens,
To restate the obvious, this is an existing bug in 2.1.3 release.  Can
you review this patch please?  I believe it resolves the remaining
issues directly related to rand_seed verification.

My gut feeling (after having spent most of yesterday trying to track
this down) is there is a race condition in the usage of struct io_u
between the verify_backlog and the "workload" thread. In particular, I
was looking at the use of IO_U_F_FREE_DEF in order to see if an io_u
was bing marked free (put_io_u()) prematurely before the
verify_backlog was done. But I didn't find that (yet?).

All the "high touch" payload verification methods pass and "low touch"
(meta) verification fails most (not all) of the time.

thanks
grant


>
>
> On Mon, Feb 3, 2014 at 2:54 PM, Grant Grundler <grundler@chromium.org>
> wrote:
>>
>> On Mon, Feb 3, 2014 at 1:31 PM, Puthikorn Voravootivat
>> <puthik@chromium.org> wrote:
>> > In verify phase, the rand_seed generated on replay does not match
>> > the written rand_seed.
>> >
>> > Multiple problems are causing this:
>> > 1. In verify phase fio does not set io_u->rand_seed to compare with
>> >    hdr->rand_seed
>> > 2. In randrw scenario, fio log is stored in red-black tree in "sorted by
>> > LBA"
>> >    order.  Thus, it is imposible to replay the written order, or rather
>> >    generate the seeds again in the same order.
>> > 3. In write phase, the code currently will generate rand_seed, write
>> > data
>> >    and log rand_seed. When queuedepth > 1, it's possible the writes
>> > complete
>> >    in a different order than rand_seed was generated.  Thus when
>> > replaying
>> >    the log, the generated rand_seed might not match what was written.
>> > 4. verify_backlog option will start verification before all the data has
>> > been
>> >    written and it make rand_seed replay code broken with current design.
>> >
>> > Proposed fixes:
>> > 1. Use of existing verify_state to generate verify header.
>> >    (and assumes this was the original intention of verify_state). And
>> > also
>> >    adds code to replay rand_seed in verify phase.
>> > 2. If verifysort option is not enabled, store the write log in a list
>> > instead
>> >    of the red-black tree. Otherwise, don't attempt to verify the
>> > rand_seed
>> >    in the header.
>> > 3. In write phase,  generate rand_seed, log rand_seed, write data. I.e.
>> > log
>> >    IO transactions in the order generated, not completed.
>> > 4. Don't verify rand_seed when verify_backlog is enabled.
>>
>>
>> We are still seeing failures with rw=read + verify_backlog=1.
>> Investigating.
>>
>> Please send any feedback if you have a chance to look at this anyway.
>> We'll fix the C++ comment. :)
>>
>> cheers,
>> grant
>>
>> >
>> > Signed-off-by: Puthikorn Voravootivat <puthik@chromium.org>
>> > ---
>> >  backend.c | 13 +++++++++++++
>> >  io_u.c    |  6 ------
>> >  iolog.c   |  2 +-
>> >  verify.c  | 14 ++++++++++++--
>> >  4 files changed, 26 insertions(+), 9 deletions(-)
>> >
>> > diff --git a/backend.c b/backend.c
>> > index 93e6632..bf9d066 100644
>> > --- a/backend.c
>> > +++ b/backend.c
>> > @@ -697,6 +697,13 @@ static uint64_t do_io(struct thread_data *td)
>> >                  */
>> >                 if (td->o.verify != VERIFY_NONE && io_u->ddir ==
>> > DDIR_READ &&
>> >                     ((io_u->flags & IO_U_F_VER_LIST) || !td_rw(td))) {
>> > +
>> > +                       if (!td->o.verify_pattern_bytes) {
>> > +                               io_u->rand_seed =
>> > __rand(&td->__verify_state);
>> > +                               if (sizeof(int) != sizeof(long *))
>> > +                                       io_u->rand_seed *=
>> > __rand(&td->__verify_state);
>> > +                       }
>> > +
>> >                         if (td->o.verify_async)
>> >                                 io_u->end_io = verify_io_u_async;
>> >                         else
>> > @@ -707,6 +714,12 @@ static uint64_t do_io(struct thread_data *td)
>> >                 else
>> >                         td_set_runstate(td, TD_RUNNING);
>> >
>> > +               if (td_write(td) && io_u->ddir == DDIR_WRITE &&
>> > +                   td->o.do_verify &&
>> > +                   td->o.verify != VERIFY_NONE &&
>> > +                   !td->o.experimental_verify)
>> > +                       log_io_piece(td, io_u);
>> > +
>> >                 ret = td_io_queue(td, io_u);
>> >                 switch (ret) {
>> >                 case FIO_Q_COMPLETED:
>> > diff --git a/io_u.c b/io_u.c
>> > index 518d884..f68b213 100644
>> > --- a/io_u.c
>> > +++ b/io_u.c
>> > @@ -1623,12 +1623,6 @@ static void io_completed(struct thread_data *td,
>> > struct io_u *io_u,
>> >                                          utime_since_now(&td->start));
>> >                 }
>> >
>> > -               if (td_write(td) && idx == DDIR_WRITE &&
>> > -                   td->o.do_verify &&
>> > -                   td->o.verify != VERIFY_NONE &&
>> > -                   !td->o.experimental_verify)
>> > -                       log_io_piece(td, io_u);
>> > -
>> >                 icd->bytes_done[idx] += bytes;
>> >
>> >                 if (io_u->end_io) {
>> > diff --git a/iolog.c b/iolog.c
>> > index ec29971..017b235 100644
>> > --- a/iolog.c
>> > +++ b/iolog.c
>> > @@ -209,7 +209,7 @@ void log_io_piece(struct thread_data *td, struct
>> > io_u *io_u)
>> >          * drop the old one, which we rely on the rb insert/lookup for
>> >          * handling.
>> >          */
>> > -       if ((!td_random(td) || !td->o.overwrite) &&
>> > +       if (((!td->o.verifysort) || !td_random(td) || !td->o.overwrite)
>> > &&
>> >               (file_randommap(td, ipo->file) || td->o.verify ==
>> > VERIFY_NONE)) {
>> >                 INIT_FLIST_HEAD(&ipo->list);
>> >                 flist_add_tail(&ipo->list, &td->io_hist_list);
>> > diff --git a/verify.c b/verify.c
>> > index 568bae8..970b867 100644
>> > --- a/verify.c
>> > +++ b/verify.c
>> > @@ -72,10 +72,10 @@ void fill_verify_pattern(struct thread_data *td,
>> > void *p, unsigned int len,
>> >                 if (use_seed)
>> >                         __fill_random_buf(p, len, seed);
>> >                 else
>> > -                       io_u->rand_seed =
>> > fill_random_buf(&td->buf_state, p, len);
>> > +                       io_u->rand_seed =
>> > fill_random_buf(&td->__verify_state, p, len);
>> >                 return;
>> >         }
>> > -
>> > +
>> >         if (io_u->buf_filled_len >= len) {
>> >                 dprint(FD_VERIFY, "using already filled verify pattern
>> > b=%d len=%u\n",
>> >                         td->o.verify_pattern_bytes, len);
>> > @@ -718,6 +718,10 @@ int verify_io_u(struct thread_data *td, struct io_u
>> > *io_u)
>> >                         memswp(p, p + td->o.verify_offset, header_size);
>> >                 hdr = p;
>> >
>> > +               // Make rand_seed check pass when have verifysort or
>> > verify_backlog.
>> > +               if (td->o.verifysort || (td->flags & TD_F_VER_BACKLOG))
>> > +                       io_u->rand_seed = hdr->rand_seed;
>> > +
>> >                 ret = verify_header(io_u, hdr);
>> >                 switch (ret) {
>> >                 case 0:
>> > @@ -1056,6 +1060,12 @@ int get_next_verify(struct thread_data *td,
>> > struct io_u *io_u)
>> >                 remove_trim_entry(td, ipo);
>> >                 free(ipo);
>> >                 dprint(FD_VERIFY, "get_next_verify: ret io_u %p\n",
>> > io_u);
>> > +
>> > +               if (!td->o.verify_pattern_bytes) {
>> > +                       io_u->rand_seed = __rand(&td->__verify_state);
>> > +                       if (sizeof(int) != sizeof(long *))
>> > +                               io_u->rand_seed *=
>> > __rand(&td->__verify_state);
>> > +               }
>> >                 return 0;
>> >         }
>> >
>> > --
>> > 1.9.0.rc1.175.g0b1dcb5
>> >
>
>

