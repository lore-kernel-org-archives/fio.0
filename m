Return-Path: <puthik@google.com>
MIME-Version: 1.0
Sender: puthik@google.com
In-Reply-To: <CANEJEGuTmYm2k1M3BUmoxCVD99wCTyLjyRrT9HS=MMFBStrA5A@mail.gmail.com>
References: <1391463077-14292-1-git-send-email-puthik@chromium.org>
	<CANEJEGuTmYm2k1M3BUmoxCVD99wCTyLjyRrT9HS=MMFBStrA5A@mail.gmail.com>
Date: Tue, 4 Feb 2014 10:54:15 -0800
Message-ID: <CANCcNXcmQNNcgFthc+JENyz3noH8HY2JsLjNG7ZBk5_soZGf_g@mail.gmail.com>
Subject: Re: [PATCH] fix rand_seed mismatches in verify phase
From: Puthikorn Voravootivat <puthik@chromium.org>
Content-Type: multipart/alternative; boundary=001a1136c0bab09e2504f1992a9e
To: Grant Grundler <grundler@chromium.org>
Cc: Puthikorn Voravootivat <puthik@chromium.org>, Jens Axboe <axboe@kernel.dk>, FIO List <fio@vger.kernel.org>, Gwendal Grignou <gwendal@chromium.org>
List-ID: <fio@vger.kernel.org>

--001a1136c0bab09e2504f1992a9e
Content-Type: text/plain; charset=UTF-8

I tried to run the same test with fio 2.1.3 and saw the same error.
This error always occurs when rw=read or randread and verify_backlog=1

Here is an example job file and error message.

Job file:
[md5-sync-1-0-1-1-1]
filename=test213/fio/md5-sync-1-0-1-1-1
loops=1
direct=0
iodepth=1
ioengine=sync
verify=md5
size=1m
bs=4k
rw=read
verifysort=1
verify_backlog=1

Error message:
verify: bad magic header 869, wanted acca at file
test213/fio/md5-sync-1-0-1-1-1 offset 585728, length 2290190


On Mon, Feb 3, 2014 at 2:54 PM, Grant Grundler <grundler@chromium.org>wrote:

> On Mon, Feb 3, 2014 at 1:31 PM, Puthikorn Voravootivat
> <puthik@chromium.org> wrote:
> > In verify phase, the rand_seed generated on replay does not match
> > the written rand_seed.
> >
> > Multiple problems are causing this:
> > 1. In verify phase fio does not set io_u->rand_seed to compare with
> >    hdr->rand_seed
> > 2. In randrw scenario, fio log is stored in red-black tree in "sorted by
> LBA"
> >    order.  Thus, it is imposible to replay the written order, or rather
> >    generate the seeds again in the same order.
> > 3. In write phase, the code currently will generate rand_seed, write data
> >    and log rand_seed. When queuedepth > 1, it's possible the writes
> complete
> >    in a different order than rand_seed was generated.  Thus when
> replaying
> >    the log, the generated rand_seed might not match what was written.
> > 4. verify_backlog option will start verification before all the data has
> been
> >    written and it make rand_seed replay code broken with current design.
> >
> > Proposed fixes:
> > 1. Use of existing verify_state to generate verify header.
> >    (and assumes this was the original intention of verify_state). And
> also
> >    adds code to replay rand_seed in verify phase.
> > 2. If verifysort option is not enabled, store the write log in a list
> instead
> >    of the red-black tree. Otherwise, don't attempt to verify the
> rand_seed
> >    in the header.
> > 3. In write phase,  generate rand_seed, log rand_seed, write data. I.e.
> log
> >    IO transactions in the order generated, not completed.
> > 4. Don't verify rand_seed when verify_backlog is enabled.
>
>
> We are still seeing failures with rw=read + verify_backlog=1.
> Investigating.
>
> Please send any feedback if you have a chance to look at this anyway.
> We'll fix the C++ comment. :)
>
> cheers,
> grant
>
> >
> > Signed-off-by: Puthikorn Voravootivat <puthik@chromium.org>
> > ---
> >  backend.c | 13 +++++++++++++
> >  io_u.c    |  6 ------
> >  iolog.c   |  2 +-
> >  verify.c  | 14 ++++++++++++--
> >  4 files changed, 26 insertions(+), 9 deletions(-)
> >
> > diff --git a/backend.c b/backend.c
> > index 93e6632..bf9d066 100644
> > --- a/backend.c
> > +++ b/backend.c
> > @@ -697,6 +697,13 @@ static uint64_t do_io(struct thread_data *td)
> >                  */
> >                 if (td->o.verify != VERIFY_NONE && io_u->ddir ==
> DDIR_READ &&
> >                     ((io_u->flags & IO_U_F_VER_LIST) || !td_rw(td))) {
> > +
> > +                       if (!td->o.verify_pattern_bytes) {
> > +                               io_u->rand_seed =
> __rand(&td->__verify_state);
> > +                               if (sizeof(int) != sizeof(long *))
> > +                                       io_u->rand_seed *=
> __rand(&td->__verify_state);
> > +                       }
> > +
> >                         if (td->o.verify_async)
> >                                 io_u->end_io = verify_io_u_async;
> >                         else
> > @@ -707,6 +714,12 @@ static uint64_t do_io(struct thread_data *td)
> >                 else
> >                         td_set_runstate(td, TD_RUNNING);
> >
> > +               if (td_write(td) && io_u->ddir == DDIR_WRITE &&
> > +                   td->o.do_verify &&
> > +                   td->o.verify != VERIFY_NONE &&
> > +                   !td->o.experimental_verify)
> > +                       log_io_piece(td, io_u);
> > +
> >                 ret = td_io_queue(td, io_u);
> >                 switch (ret) {
> >                 case FIO_Q_COMPLETED:
> > diff --git a/io_u.c b/io_u.c
> > index 518d884..f68b213 100644
> > --- a/io_u.c
> > +++ b/io_u.c
> > @@ -1623,12 +1623,6 @@ static void io_completed(struct thread_data *td,
> struct io_u *io_u,
> >                                          utime_since_now(&td->start));
> >                 }
> >
> > -               if (td_write(td) && idx == DDIR_WRITE &&
> > -                   td->o.do_verify &&
> > -                   td->o.verify != VERIFY_NONE &&
> > -                   !td->o.experimental_verify)
> > -                       log_io_piece(td, io_u);
> > -
> >                 icd->bytes_done[idx] += bytes;
> >
> >                 if (io_u->end_io) {
> > diff --git a/iolog.c b/iolog.c
> > index ec29971..017b235 100644
> > --- a/iolog.c
> > +++ b/iolog.c
> > @@ -209,7 +209,7 @@ void log_io_piece(struct thread_data *td, struct
> io_u *io_u)
> >          * drop the old one, which we rely on the rb insert/lookup for
> >          * handling.
> >          */
> > -       if ((!td_random(td) || !td->o.overwrite) &&
> > +       if (((!td->o.verifysort) || !td_random(td) || !td->o.overwrite)
> &&
> >               (file_randommap(td, ipo->file) || td->o.verify ==
> VERIFY_NONE)) {
> >                 INIT_FLIST_HEAD(&ipo->list);
> >                 flist_add_tail(&ipo->list, &td->io_hist_list);
> > diff --git a/verify.c b/verify.c
> > index 568bae8..970b867 100644
> > --- a/verify.c
> > +++ b/verify.c
> > @@ -72,10 +72,10 @@ void fill_verify_pattern(struct thread_data *td,
> void *p, unsigned int len,
> >                 if (use_seed)
> >                         __fill_random_buf(p, len, seed);
> >                 else
> > -                       io_u->rand_seed =
> fill_random_buf(&td->buf_state, p, len);
> > +                       io_u->rand_seed =
> fill_random_buf(&td->__verify_state, p, len);
> >                 return;
> >         }
> > -
> > +
> >         if (io_u->buf_filled_len >= len) {
> >                 dprint(FD_VERIFY, "using already filled verify pattern
> b=%d len=%u\n",
> >                         td->o.verify_pattern_bytes, len);
> > @@ -718,6 +718,10 @@ int verify_io_u(struct thread_data *td, struct io_u
> *io_u)
> >                         memswp(p, p + td->o.verify_offset, header_size);
> >                 hdr = p;
> >
> > +               // Make rand_seed check pass when have verifysort or
> verify_backlog.
> > +               if (td->o.verifysort || (td->flags & TD_F_VER_BACKLOG))
> > +                       io_u->rand_seed = hdr->rand_seed;
> > +
> >                 ret = verify_header(io_u, hdr);
> >                 switch (ret) {
> >                 case 0:
> > @@ -1056,6 +1060,12 @@ int get_next_verify(struct thread_data *td,
> struct io_u *io_u)
> >                 remove_trim_entry(td, ipo);
> >                 free(ipo);
> >                 dprint(FD_VERIFY, "get_next_verify: ret io_u %p\n",
> io_u);
> > +
> > +               if (!td->o.verify_pattern_bytes) {
> > +                       io_u->rand_seed = __rand(&td->__verify_state);
> > +                       if (sizeof(int) != sizeof(long *))
> > +                               io_u->rand_seed *=
> __rand(&td->__verify_state);
> > +               }
> >                 return 0;
> >         }
> >
> > --
> > 1.9.0.rc1.175.g0b1dcb5
> >
>

--001a1136c0bab09e2504f1992a9e
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><span style=3D"font-family:arial,sans-serif;font-size:13px=
">I tried to run the same test with fio 2.1.3 and saw the same error.=C2=A0=
</span><div style=3D"font-family:arial,sans-serif;font-size:13px">This erro=
r always occurs when rw=3Dread or randread and verify_backlog=3D1<br>
</div><div style=3D"font-family:arial,sans-serif;font-size:13px"><br></div>=
<div style=3D"font-family:arial,sans-serif;font-size:13px">Here is an examp=
le job file and error message.<div><br></div><div>Job file:<br><div><div>[m=
d5-sync-1-0-1-1-1]</div>
<div>filename=3Dtest213/fio/md5-sync-1-0-1-1-1</div><div>loops=3D1</div><di=
v>direct=3D0</div><div>iodepth=3D1</div><div>ioengine=3Dsync</div><div>veri=
fy=3Dmd5</div><div>size=3D1m</div><div>bs=3D4k</div><div>rw=3Dread</div><di=
v>verifysort=3D1</div>
<div>verify_backlog=3D1</div></div><div><br></div><div>Error message:</div>=
<div>verify: bad magic header 869, wanted acca at file test213/fio/md5-sync=
-1-0-1-1-1 offset 585728, length 2290190</div></div></div></div><div class=
=3D"gmail_extra">
<br><br><div class=3D"gmail_quote">On Mon, Feb 3, 2014 at 2:54 PM, Grant Gr=
undler <span dir=3D"ltr">&lt;<a href=3D"mailto:grundler@chromium.org" targe=
t=3D"_blank">grundler@chromium.org</a>&gt;</span> wrote:<br><blockquote cla=
ss=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;pa=
dding-left:1ex">
<div class=3D"HOEnZb"><div class=3D"h5">On Mon, Feb 3, 2014 at 1:31 PM, Put=
hikorn Voravootivat<br>
&lt;<a href=3D"mailto:puthik@chromium.org">puthik@chromium.org</a>&gt; wrot=
e:<br>
&gt; In verify phase, the rand_seed generated on replay does not match<br>
&gt; the written rand_seed.<br>
&gt;<br>
&gt; Multiple problems are causing this:<br>
&gt; 1. In verify phase fio does not set io_u-&gt;rand_seed to compare with=
<br>
&gt; =C2=A0 =C2=A0hdr-&gt;rand_seed<br>
&gt; 2. In randrw scenario, fio log is stored in red-black tree in &quot;so=
rted by LBA&quot;<br>
&gt; =C2=A0 =C2=A0order. =C2=A0Thus, it is imposible to replay the written =
order, or rather<br>
&gt; =C2=A0 =C2=A0generate the seeds again in the same order.<br>
&gt; 3. In write phase, the code currently will generate rand_seed, write d=
ata<br>
&gt; =C2=A0 =C2=A0and log rand_seed. When queuedepth &gt; 1, it&#39;s possi=
ble the writes complete<br>
&gt; =C2=A0 =C2=A0in a different order than rand_seed was generated. =C2=A0=
Thus when replaying<br>
&gt; =C2=A0 =C2=A0the log, the generated rand_seed might not match what was=
 written.<br>
&gt; 4. verify_backlog option will start verification before all the data h=
as been<br>
&gt; =C2=A0 =C2=A0written and it make rand_seed replay code broken with cur=
rent design.<br>
&gt;<br>
&gt; Proposed fixes:<br>
&gt; 1. Use of existing verify_state to generate verify header.<br>
&gt; =C2=A0 =C2=A0(and assumes this was the original intention of verify_st=
ate). And also<br>
&gt; =C2=A0 =C2=A0adds code to replay rand_seed in verify phase.<br>
&gt; 2. If verifysort option is not enabled, store the write log in a list =
instead<br>
&gt; =C2=A0 =C2=A0of the red-black tree. Otherwise, don&#39;t attempt to ve=
rify the rand_seed<br>
&gt; =C2=A0 =C2=A0in the header.<br>
&gt; 3. In write phase, =C2=A0generate rand_seed, log rand_seed, write data=
. I.e. log<br>
&gt; =C2=A0 =C2=A0IO transactions in the order generated, not completed.<br=
>
&gt; 4. Don&#39;t verify rand_seed when verify_backlog is enabled.<br>
<br>
<br>
</div></div>We are still seeing failures with rw=3Dread + verify_backlog=3D=
1. Investigating.<br>
<br>
Please send any feedback if you have a chance to look at this anyway.<br>
We&#39;ll fix the C++ comment. :)<br>
<br>
cheers,<br>
grant<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
&gt;<br>
&gt; Signed-off-by: Puthikorn Voravootivat &lt;<a href=3D"mailto:puthik@chr=
omium.org">puthik@chromium.org</a>&gt;<br>
&gt; ---<br>
&gt; =C2=A0backend.c | 13 +++++++++++++<br>
&gt; =C2=A0io_u.c =C2=A0 =C2=A0| =C2=A06 ------<br>
&gt; =C2=A0iolog.c =C2=A0 | =C2=A02 +-<br>
&gt; =C2=A0verify.c =C2=A0| 14 ++++++++++++--<br>
&gt; =C2=A04 files changed, 26 insertions(+), 9 deletions(-)<br>
&gt;<br>
&gt; diff --git a/backend.c b/backend.c<br>
&gt; index 93e6632..bf9d066 100644<br>
&gt; --- a/backend.c<br>
&gt; +++ b/backend.c<br>
&gt; @@ -697,6 +697,13 @@ static uint64_t do_io(struct thread_data *td)<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (td-&gt;o.v=
erify !=3D VERIFY_NONE &amp;&amp; io_u-&gt;ddir =3D=3D DDIR_READ &amp;&amp;=
<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
((io_u-&gt;flags &amp; IO_U_F_VER_LIST) || !td_rw(td))) {<br>
&gt; +<br>
&gt; + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (!td-&gt;o.verify_pattern_bytes) {<br>
&gt; + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 io_u-&gt;rand_seed =3D __rand(&amp;t=
d-&gt;__verify_state);<br>
&gt; + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (sizeof(int) !=3D sizeof(long *))=
<br>
&gt; + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 io_u-&gt=
;rand_seed *=3D __rand(&amp;td-&gt;__verify_state);<br>
&gt; + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 }<br>
&gt; +<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 if (td-&gt;o.verify_async)<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 io_u-&gt;end_io =3D verify_io_u_a=
sync;<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 else<br>
&gt; @@ -707,6 +714,12 @@ static uint64_t do_io(struct thread_data *td)<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 td_set_runstate(td, TD_RUNNING);<br>
&gt;<br>
&gt; + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (td_write(td) &a=
mp;&amp; io_u-&gt;ddir =3D=3D DDIR_WRITE &amp;&amp;<br>
&gt; + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 td-&g=
t;o.do_verify &amp;&amp;<br>
&gt; + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 td-&g=
t;o.verify !=3D VERIFY_NONE &amp;&amp;<br>
&gt; + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 !td-&=
gt;o.experimental_verify)<br>
&gt; + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 log_io_piece(td, io_u);<br>
&gt; +<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D td_io_=
queue(td, io_u);<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 switch (ret) {=
<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 case FIO_Q_COM=
PLETED:<br>
&gt; diff --git a/io_u.c b/io_u.c<br>
&gt; index 518d884..f68b213 100644<br>
&gt; --- a/io_u.c<br>
&gt; +++ b/io_u.c<br>
&gt; @@ -1623,12 +1623,6 @@ static void io_completed(struct thread_data *td=
, struct io_u *io_u,<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0utime_since_now(&amp;td-&gt;start));<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
&gt;<br>
&gt; - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (td_write(td) &a=
mp;&amp; idx =3D=3D DDIR_WRITE &amp;&amp;<br>
&gt; - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 td-&g=
t;o.do_verify &amp;&amp;<br>
&gt; - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 td-&g=
t;o.verify !=3D VERIFY_NONE &amp;&amp;<br>
&gt; - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 !td-&=
gt;o.experimental_verify)<br>
&gt; - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 log_io_piece(td, io_u);<br>
&gt; -<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 icd-&gt;bytes_=
done[idx] +=3D bytes;<br>
&gt;<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (io_u-&gt;e=
nd_io) {<br>
&gt; diff --git a/iolog.c b/iolog.c<br>
&gt; index ec29971..017b235 100644<br>
&gt; --- a/iolog.c<br>
&gt; +++ b/iolog.c<br>
&gt; @@ -209,7 +209,7 @@ void log_io_piece(struct thread_data *td, struct i=
o_u *io_u)<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* drop the old one, which we rely on=
 the rb insert/lookup for<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* handling.<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
&gt; - =C2=A0 =C2=A0 =C2=A0 if ((!td_random(td) || !td-&gt;o.overwrite) &am=
p;&amp;<br>
&gt; + =C2=A0 =C2=A0 =C2=A0 if (((!td-&gt;o.verifysort) || !td_random(td) |=
| !td-&gt;o.overwrite) &amp;&amp;<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (file_randommap(td, i=
po-&gt;file) || td-&gt;o.verify =3D=3D VERIFY_NONE)) {<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 INIT_FLIST_HEA=
D(&amp;ipo-&gt;list);<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 flist_add_tail=
(&amp;ipo-&gt;list, &amp;td-&gt;io_hist_list);<br>
&gt; diff --git a/verify.c b/verify.c<br>
&gt; index 568bae8..970b867 100644<br>
&gt; --- a/verify.c<br>
&gt; +++ b/verify.c<br>
&gt; @@ -72,10 +72,10 @@ void fill_verify_pattern(struct thread_data *td, v=
oid *p, unsigned int len,<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (use_seed)<=
br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 __fill_random_buf(p, len, seed);<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else<br>
&gt; - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 io_u-&gt;rand_seed =3D fill_random_buf(&amp;td-&gt;buf_state, p,=
 len);<br>
&gt; + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 io_u-&gt;rand_seed =3D fill_random_buf(&amp;td-&gt;__verify_stat=
e, p, len);<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
&gt; -<br>
&gt; +<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (io_u-&gt;buf_filled_len &gt;=3D len) {=
<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dprint(FD_VERI=
FY, &quot;using already filled verify pattern b=3D%d len=3D%u\n&quot;,<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 td-&gt;o.verify_pattern_bytes, len);<br>
&gt; @@ -718,6 +718,10 @@ int verify_io_u(struct thread_data *td, struct io=
_u *io_u)<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 memswp(p, p + td-&gt;o.verify_offset, header_size);<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 hdr =3D p;<br>
&gt;<br>
&gt; + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 // Make rand_seed c=
heck pass when have verifysort or verify_backlog.<br>
&gt; + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (td-&gt;o.verify=
sort || (td-&gt;flags &amp; TD_F_VER_BACKLOG))<br>
&gt; + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 io_u-&gt;rand_seed =3D hdr-&gt;rand_seed;<br>
&gt; +<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D verify=
_header(io_u, hdr);<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 switch (ret) {=
<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 case 0:<br>
&gt; @@ -1056,6 +1060,12 @@ int get_next_verify(struct thread_data *td, str=
uct io_u *io_u)<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 remove_trim_en=
try(td, ipo);<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 free(ipo);<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dprint(FD_VERI=
FY, &quot;get_next_verify: ret io_u %p\n&quot;, io_u);<br>
&gt; +<br>
&gt; + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!td-&gt;o.verif=
y_pattern_bytes) {<br>
&gt; + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 io_u-&gt;rand_seed =3D __rand(&amp;td-&gt;__verify_state);<br>
&gt; + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (sizeof(int) !=3D sizeof(long *))<br>
&gt; + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 io_u-&gt;rand_seed *=3D __rand(&amp;=
td-&gt;__verify_state);<br>
&gt; + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
&gt;<br>
&gt; --<br>
&gt; 1.9.0.rc1.175.g0b1dcb5<br>
&gt;<br>
</div></div></blockquote></div><br></div>

--001a1136c0bab09e2504f1992a9e--

