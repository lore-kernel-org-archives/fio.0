Return-Path: <stephenmcameron@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20140904002343.24650.74664.stgit@beardog.cce.hp.com>
References: <20140904002343.24650.74664.stgit@beardog.cce.hp.com>
Date: Wed, 3 Sep 2014 20:18:19 -0500
Message-ID: <CADzpL0S+M65yLDPvJNAtVo0Fig7vOHveWqYWECd3YfD2Ae7VnA@mail.gmail.com>
Subject: Re: [PATCH] fio: fix hangs due to iodepth_low
From: Stephen Cameron <stephenmcameron@gmail.com>
Content-Type: multipart/alternative; boundary=089e01227912c8080205023320a0
To: Robert Elliott <elliott@hp.com>
Cc: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org, "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
List-ID: <fio@vger.kernel.org>

--089e01227912c8080205023320a0
Content-Type: text/plain; charset=UTF-8

Huh.  Wonder if that's what I hit a week or two ago.

-- steve



On Wed, Sep 3, 2014 at 7:23 PM, Robert Elliott <elliott@hp.com> wrote:

> With some combinations of iodepth, iodepth_batch, iodepth_batch_complete,
> and io_depth_low, do_io hangs after reaping the first set of completions
> since io_u_queued_complete is called requesting more completions than
> td->cur_depth.
>
> Example printing min_evts and td->cur_depth in the do/while loop:
> waiting on min=96 cd=627
> waiting on min=96 cd=531
> waiting on min=96 cd=435
> waiting on min=96 cd=339
> waiting on min=96 cd=243
> waiting on min=96 cd=147
> waiting on min=96 cd=51
> Jobs: 12 (f=12): [r(12)] [43.8% done] [0KB/0KB/0KB /s] [0/0/0 iops] [eta
> 00m:09s]
> ...
> Jobs: 12 (f=12): [r(12)] [0.0% done] [0KB/0KB/0KB /s] [0/0/0 iops] [eta
> 2863d:18h:28m:38s]
> <fio never exits>
>
> Fix this by adjusting min_evts to the current_depth if that is smaller.
>
> Tested with a jobfile including:
> iodepth=1011
> iodepth_batch=96
> iodepth_batch_complete=96
> iodepth_low=1
> runtime=15
> time_based
>
> Made the same change to do_verify, but not tested there.
>
> Signed-off-by: Robert Elliott <elliott@hp.com>
> ---
>  backend.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/backend.c b/backend.c
> index 7cb0a39..ce97f6d 100644
> --- a/backend.c
> +++ b/backend.c
> @@ -606,6 +606,8 @@ reap:
>                                  * and do the verification on them through
>                                  * the callback handler
>                                  */
> +                               if (min_events < td->cur_depth)
> +                                       min_events = td->cur_depth;
>                                 if (io_u_queued_complete(td, min_events,
> bytes_done) < 0) {
>                                         ret = -1;
>                                         break;
> @@ -873,6 +875,8 @@ reap:
>                                 fio_gettime(&comp_time, NULL);
>
>                         do {
> +                               if (min_evts < td->cur_depth)
> +                                       min_evts = td->cur_depth;
>                                 ret = io_u_queued_complete(td, min_evts,
> bytes_done);
>                                 if (ret < 0)
>                                         break;
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--089e01227912c8080205023320a0
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Huh.=C2=A0 Wonder if that&#39;s what I hit a week or =
two ago.<br><br></div>-- steve<br><br></div><div class=3D"gmail_extra"><br>=
<br><div class=3D"gmail_quote">On Wed, Sep 3, 2014 at 7:23 PM, Robert Ellio=
tt <span dir=3D"ltr">&lt;<a href=3D"mailto:elliott@hp.com" target=3D"_blank=
">elliott@hp.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"HOEnZb"><div class=3D"h5">With=
 some combinations of iodepth, iodepth_batch, iodepth_batch_complete,<br>
and io_depth_low, do_io hangs after reaping the first set of completions<br=
>
since io_u_queued_complete is called requesting more completions than<br>
td-&gt;cur_depth.<br>
<br>
Example printing min_evts and td-&gt;cur_depth in the do/while loop:<br>
waiting on min=3D96 cd=3D627<br>
waiting on min=3D96 cd=3D531<br>
waiting on min=3D96 cd=3D435<br>
waiting on min=3D96 cd=3D339<br>
waiting on min=3D96 cd=3D243<br>
waiting on min=3D96 cd=3D147<br>
waiting on min=3D96 cd=3D51<br>
Jobs: 12 (f=3D12): [r(12)] [43.8% done] [0KB/0KB/0KB /s] [0/0/0 iops] [eta =
00m:09s]<br>
...<br>
Jobs: 12 (f=3D12): [r(12)] [0.0% done] [0KB/0KB/0KB /s] [0/0/0 iops] [eta 2=
863d:18h:28m:38s]<br>
&lt;fio never exits&gt;<br>
<br>
Fix this by adjusting min_evts to the current_depth if that is smaller.<br>
<br>
Tested with a jobfile including:<br>
iodepth=3D1011<br>
iodepth_batch=3D96<br>
iodepth_batch_complete=3D96<br>
iodepth_low=3D1<br>
runtime=3D15<br>
time_based<br>
<br>
Made the same change to do_verify, but not tested there.<br>
<br>
Signed-off-by: Robert Elliott &lt;<a href=3D"mailto:elliott@hp.com">elliott=
@hp.com</a>&gt;<br>
---<br>
=C2=A0backend.c |=C2=A0 =C2=A0 4 ++++<br>
=C2=A01 files changed, 4 insertions(+), 0 deletions(-)<br>
<br>
diff --git a/backend.c b/backend.c<br>
index 7cb0a39..ce97f6d 100644<br>
--- a/backend.c<br>
+++ b/backend.c<br>
@@ -606,6 +606,8 @@ reap:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* and do the verification on t=
hem through<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* the callback handler<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (min_events &lt; td-&gt;cur_depth)=
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0min_event=
s =3D td-&gt;cur_depth;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (io_u_queued_complete(td, min_eve=
nts, bytes_done) &lt; 0) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D =
-1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;<b=
r>
@@ -873,6 +875,8 @@ reap:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fio_gettime(&amp;comp_time, NULL);<b=
r>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 do {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (min_evts &lt; td-&gt;cur_depth)<b=
r>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0min_evts =
=3D td-&gt;cur_depth;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D io_u_queued_complete(td, min=
_evts, bytes_done);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ret &lt; 0)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;<b=
r>
<br>
--<br>
To unsubscribe from this list: send the line &quot;unsubscribe fio&quot; in=
<br>
the body of a message to <a href=3D"mailto:majordomo@vger.kernel.org">major=
domo@vger.kernel.org</a><br>
More majordomo info at=C2=A0 <a href=3D"http://vger.kernel.org/majordomo-in=
fo.html" target=3D"_blank">http://vger.kernel.org/majordomo-info.html</a><b=
r>
</div></div></blockquote></div><br></div>

--089e01227912c8080205023320a0--

