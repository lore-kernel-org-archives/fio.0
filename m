Return-Path: <asomers@gmail.com>
MIME-Version: 1.0
In-Reply-To: <51F696E7.1070206@kernel.dk>
References: <CAOtMX2if0xLLNngOm4uGgWcrze_61M+jCmHcv0pgNisYsWr_Dg@mail.gmail.com>
	<51F683EC.4090402@kernel.dk>
	<CAOtMX2ji_t2MOA_9akkyAkXd=R6sO7V1nWiBfesLFJ5SPg+fdw@mail.gmail.com>
	<51F696E7.1070206@kernel.dk>
Date: Thu, 29 Aug 2013 16:23:05 -0600
Message-ID: <CAOtMX2gHij_MPmGWfBQUR_Xed0=NoVOcy8cOJR9YeLisz-mwag@mail.gmail.com>
Subject: Re: --minimal does not work in client/server mode
From: asomers@gmail.com
Content-Type: multipart/alternative; boundary=047d7b5dbfc0c1f14504e51d8c21
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

--047d7b5dbfc0c1f14504e51d8c21
Content-Type: text/plain; charset=ISO-8859-1

Try this new set of patches.  These get json output working in
client/server mode.

https://gist.github.com/asomers/6105396


On Mon, Jul 29, 2013 at 10:23 AM, Jens Axboe <axboe@kernel.dk> wrote:

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
>

--047d7b5dbfc0c1f14504e51d8c21
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Try this new set of patches.=A0 These get json output work=
ing in client/server mode.<br><br><a href=3D"https://gist.github.com/asomer=
s/6105396">https://gist.github.com/asomers/6105396</a><br></div><div class=
=3D"gmail_extra">
<br><br><div class=3D"gmail_quote">On Mon, Jul 29, 2013 at 10:23 AM, Jens A=
xboe <span dir=3D"ltr">&lt;<a href=3D"mailto:axboe@kernel.dk" target=3D"_bl=
ank">axboe@kernel.dk</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_qu=
ote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex=
">
<div class=3D"im">On 07/29/2013 10:00 AM, <a href=3D"mailto:asomers@gmail.c=
om">asomers@gmail.com</a> wrote:<br>
&gt; I found a few more things that need to be suppressed in terse mode.<br=
>
&gt; The updated patch is here. =A0In addition to working with JSON output,=
<br>
&gt; we also need to check that the patch doesn&#39;t break disk statistics=
. =A0I<br>
&gt; haven&#39;t tried using those at all yet.<br>
&gt;<br>
&gt; <a href=3D"https://gist.github.com/asomers/6105396" target=3D"_blank">=
https://gist.github.com/asomers/6105396</a><br>
<br>
</div>I would suggest making a show_thread_status_all() that does something=
 ala:<br>
<br>
void show_thread_status_all()<br>
{<br>
=A0 =A0if (is_backend)<br>
=A0 =A0 =A0 =A0fio_server_send_ts(ts, rs);<br>
=A0 =A0else if (output_format =3D=3D FIO_OUTPUT_TERSE)<br>
=A0 =A0 =A0 =A0show_thread_status_terse(ts, rs);<br>
=A0 =A0else if (output_format =3D=3D FIO_OUTPUT_JSON) {<br>
=A0 =A0 =A0 =A0struct json_object *tmp =3D show_thread_status_json(ts, rs);=
<br>
<br>
=A0 =A0 =A0 =A0json_array_add_value_object(array, tmp);<br>
=A0 =A0} else<br>
=A0 =A0 =A0 =A0show_thread_status(ts, rs);<br>
}<br>
<br>
which should work for all. If you could check and fix the json bit too,<br>
bonus points, and I&#39;ll test and commit it. Thanks!<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
<br>
--<br>
Jens Axboe<br>
<br>
</font></span></blockquote></div><br></div>

--047d7b5dbfc0c1f14504e51d8c21--


