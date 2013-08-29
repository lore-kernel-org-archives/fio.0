Return-Path: <asomers@gmail.com>
MIME-Version: 1.0
In-Reply-To: <51F696E7.1070206@kernel.dk>
References: <CAOtMX2if0xLLNngOm4uGgWcrze_61M+jCmHcv0pgNisYsWr_Dg@mail.gmail.com>
	<51F683EC.4090402@kernel.dk>
	<CAOtMX2ji_t2MOA_9akkyAkXd=R6sO7V1nWiBfesLFJ5SPg+fdw@mail.gmail.com>
	<51F696E7.1070206@kernel.dk>
Date: Thu, 29 Aug 2013 16:26:02 -0600
Message-ID: <CAOtMX2h6mtRVQWCX2DCwoLxxcXUKWAGA8-gBfM3gu96QNKFmAA@mail.gmail.com>
Subject: Re: --minimal does not work in client/server mode
From: asomers@gmail.com
Content-Type: multipart/alternative; boundary=047d7b5dbfc04d76b304e51d97b3
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

--047d7b5dbfc04d76b304e51d97b3
Content-Type: text/plain; charset=ISO-8859-1

On Mon, Jul 29, 2013 at 10:23 AM, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 07/29/2013 10:00 AM, asomers@gmail.com wrote:
> > I found a few more things that need to be suppressed in terse mode.
> > The updated patch is here.  In addition to working with JSON output,
> > we also need to check that the patch doesn't break disk statistics.  I
> > haven't tried using those at all yet.
> >
> > https://gist.github.com/asomers/6105396
>
> I would suggest making a show_thread_status_all() that does something ala:
>
> void show_thread_status_all()
> {
>    if (is_backend)
>        fio_server_send_ts(ts, rs);
>    else if (output_format == FIO_OUTPUT_TERSE)
>        show_thread_status_terse(ts, rs);
>    else if (output_format == FIO_OUTPUT_JSON) {
>        struct json_object *tmp = show_thread_status_json(ts, rs);
>
>        json_array_add_value_object(array, tmp);
>    } else
>        show_thread_status(ts, rs);
> }
>
> which should work for all. If you could check and fix the json bit too,
> bonus points, and I'll test and commit it. Thanks!
>
>
> --
> Jens Axboe
>

Try this new set of patches.  They get json output working in client/server
mode. This is my third attempt to send them; your server keeps rejecting
gmail's HTML.  Sorry for the overposts.

https://gist.github.com/asomers/6105396

--047d7b5dbfc04d76b304e51d97b3
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><br><br>On Mon, Jul 29, 2013 at 10:23 AM, Jens Axboe &=
lt;<a href=3D"mailto:axboe@kernel.dk">axboe@kernel.dk</a>&gt; wrote:<br>&gt=
;<br>&gt; On 07/29/2013 10:00 AM, <a href=3D"mailto:asomers@gmail.com">asom=
ers@gmail.com</a> wrote:<br>
&gt; &gt; I found a few more things that need to be suppressed in terse mod=
e.<br>&gt; &gt; The updated patch is here. =A0In addition to working with J=
SON output,<br>&gt; &gt; we also need to check that the patch doesn&#39;t b=
reak disk statistics. =A0I<br>
&gt; &gt; haven&#39;t tried using those at all yet.<br>&gt; &gt;<br>&gt; &g=
t; <a href=3D"https://gist.github.com/asomers/6105396">https://gist.github.=
com/asomers/6105396</a><br>&gt;<br>&gt; I would suggest making a show_threa=
d_status_all() that does something ala:<br>
&gt;<br>&gt; void show_thread_status_all()<br>&gt; {<br>&gt; =A0 =A0if (is_=
backend)<br>&gt; =A0 =A0 =A0 =A0fio_server_send_ts(ts, rs);<br>&gt; =A0 =A0=
else if (output_format =3D=3D FIO_OUTPUT_TERSE)<br>&gt; =A0 =A0 =A0 =A0show=
_thread_status_terse(ts, rs);<br>
&gt; =A0 =A0else if (output_format =3D=3D FIO_OUTPUT_JSON) {<br>&gt; =A0 =
=A0 =A0 =A0struct json_object *tmp =3D show_thread_status_json(ts, rs);<br>=
&gt;<br>&gt; =A0 =A0 =A0 =A0json_array_add_value_object(array, tmp);<br>&gt=
; =A0 =A0} else<br>&gt; =A0 =A0 =A0 =A0show_thread_status(ts, rs);<br>
&gt; }<br>&gt;<br>&gt; which should work for all. If you could check and fi=
x the json bit too,<br>&gt; bonus points, and I&#39;ll test and commit it. =
Thanks!<br>&gt;<br>&gt;<br>&gt; --<br>&gt; Jens Axboe<br>&gt;<br><br>Try th=
is new set of patches. =A0They get json output working in client/server mod=
e. This is my third attempt to send them; your server keeps rejecting gmail=
&#39;s HTML. =A0Sorry for the overposts.<br>
<br><a href=3D"https://gist.github.com/asomers/6105396">https://gist.github=
.com/asomers/6105396</a></div>

--047d7b5dbfc04d76b304e51d97b3--


