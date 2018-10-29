Return-Path: <bmohanraj91@gmail.com>
MIME-Version: 1.0
References: <97B23BED-1883-400F-A28C-752554717124@emc.com>
In-Reply-To: <97B23BED-1883-400F-A28C-752554717124@emc.com>
From: Mohanraj B <bmohanraj91@gmail.com>
Date: Mon, 29 Oct 2018 20:07:45 +0530
Message-ID: <CAFF4W0XbBv5=hrx6tPYvO75=amvsUgJ=V7ctsNRa7bwX3F4tmw@mail.gmail.com>
Subject: Re:
Content-Type: multipart/alternative; boundary="000000000000d9eeb705795f037e"
To: "Beierl, Mark" <Mark.Beierl@dell.com>
Cc: Jens Axboe <axboe@kernel.dk>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

--000000000000d9eeb705795f037e
Content-Type: text/plain; charset="UTF-8"

Thanks Axboe and Mark.

On Mon 29 Oct, 2018, 7:50 PM Beierl, Mark, <Mark.Beierl@dell.com> wrote:

> On 2018-10-27, 12:55, "fio-owner@vger.kernel.org on behalf of Jens Axboe"
> <fio-owner@vger.kernel.org on behalf of axboe@kernel.dk> wrote:
>
>     [EXTERNAL EMAIL]
>     Please report any suspicious attachments, links, or requests for
> sensitive information.
>
>
>     On 10/26/18 6:54 AM, Mohanraj B wrote:
>     > Hello,
>     >
>     > I am trying to check how option --clocksource works.
>     >
>     >
>     > bash# fio --name job1 --size 10m --clocksource 2
>     >         valid values: gettimeofday Use gettimeofday(2) for timing
>     >                     : clock_gettime Use clock_gettime(2) for timing
>     >                     : cpu        Use CPU private clock
>     >
>     > fio: failed parsing clocksource=2
>     >
>     > bash# fio --name job1 --size 10m --clocksource gettimeofday(2)
>     > bash: syntax error near unexpected token `('
>     >
>     > Below command works fine.
>     > bash# fio --name job1 --size 10m --clocksource gettimeofday
>     >
>     > It runs without error but quiet not sure how to see the effect of
> this
>     > option. also tried other options - clock_gettime, cpu gettimeofday
> and
>     > dont see any difference.
>     >
>     > Also is there any error in documentation passing gettimeofday(2)
>     > throws parse error.
>
>     The format is 'value' 'help', so you'd want to do:
>
>     --clocksource=gettimeofday
>
>     for instance.
>
>     --
>     Jens Axboe
>
> Hello, Mohanraj
>
> The help output that you see above states that using
> --clocksource=gettimeofday will use the gettimeofday function as defined in
> the man page in the section (2), which is where all the system calls
> manuals are stored.  The (2) is  not meant to be part of the command line,
> it is part of the description of the help text, which tells you where to
> find more information on what is being used to implement the clocksource.
>
> Hope that helps clarify the help text.
>
> Regards,
> Mark
>
>
>
>

--000000000000d9eeb705795f037e
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto">Thanks Axboe and Mark.</div><br><div class=3D"gmail_quote=
"><div dir=3D"ltr">On Mon 29 Oct, 2018, 7:50 PM Beierl, Mark, &lt;<a href=
=3D"mailto:Mark.Beierl@dell.com">Mark.Beierl@dell.com</a>&gt; wrote:<br></d=
iv><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left=
:1px #ccc solid;padding-left:1ex">On 2018-10-27, 12:55, &quot;<a href=3D"ma=
ilto:fio-owner@vger.kernel.org" target=3D"_blank" rel=3D"noreferrer">fio-ow=
ner@vger.kernel.org</a> on behalf of Jens Axboe&quot; &lt;<a href=3D"mailto=
:fio-owner@vger.kernel.org" target=3D"_blank" rel=3D"noreferrer">fio-owner@=
vger.kernel.org</a> on behalf of <a href=3D"mailto:axboe@kernel.dk" target=
=3D"_blank" rel=3D"noreferrer">axboe@kernel.dk</a>&gt; wrote:<br>
<br>
=C2=A0 =C2=A0 [EXTERNAL EMAIL] <br>
=C2=A0 =C2=A0 Please report any suspicious attachments, links, or requests =
for sensitive information.<br>
<br>
<br>
=C2=A0 =C2=A0 On 10/26/18 6:54 AM, Mohanraj B wrote:<br>
=C2=A0 =C2=A0 &gt; Hello,<br>
=C2=A0 =C2=A0 &gt; <br>
=C2=A0 =C2=A0 &gt; I am trying to check how option --clocksource works.<br>
=C2=A0 =C2=A0 &gt; <br>
=C2=A0 =C2=A0 &gt; <br>
=C2=A0 =C2=A0 &gt; bash# fio --name job1 --size 10m --clocksource 2<br>
=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0valid values: gettimeof=
day Use gettimeofday(2) for timing<br>
=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0: clock_gettime Use clock_gettime(2) for timing<br>
=C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0: cpu=C2=A0 =C2=A0 =C2=A0 =C2=A0 Use CPU private clock<=
br>
=C2=A0 =C2=A0 &gt; <br>
=C2=A0 =C2=A0 &gt; fio: failed parsing clocksource=3D2<br>
=C2=A0 =C2=A0 &gt; <br>
=C2=A0 =C2=A0 &gt; bash# fio --name job1 --size 10m --clocksource gettimeof=
day(2)<br>
=C2=A0 =C2=A0 &gt; bash: syntax error near unexpected token `(&#39;<br>
=C2=A0 =C2=A0 &gt; <br>
=C2=A0 =C2=A0 &gt; Below command works fine.<br>
=C2=A0 =C2=A0 &gt; bash# fio --name job1 --size 10m --clocksource gettimeof=
day<br>
=C2=A0 =C2=A0 &gt; <br>
=C2=A0 =C2=A0 &gt; It runs without error but quiet not sure how to see the =
effect of this<br>
=C2=A0 =C2=A0 &gt; option. also tried other options - clock_gettime, cpu ge=
ttimeofday and<br>
=C2=A0 =C2=A0 &gt; dont see any difference.<br>
=C2=A0 =C2=A0 &gt; <br>
=C2=A0 =C2=A0 &gt; Also is there any error in documentation passing gettime=
ofday(2)<br>
=C2=A0 =C2=A0 &gt; throws parse error.<br>
<br>
=C2=A0 =C2=A0 The format is &#39;value&#39; &#39;help&#39;, so you&#39;d wa=
nt to do:<br>
<br>
=C2=A0 =C2=A0 --clocksource=3Dgettimeofday<br>
<br>
=C2=A0 =C2=A0 for instance.<br>
<br>
=C2=A0 =C2=A0 -- <br>
=C2=A0 =C2=A0 Jens Axboe<br>
<br>
Hello, Mohanraj<br>
<br>
The help output that you see above states that using --clocksource=3Dgettim=
eofday will use the gettimeofday function as defined in the man page in the=
 section (2), which is where all the system calls manuals are stored.=C2=A0=
 The (2) is=C2=A0 not meant to be part of the command line, it is part of t=
he description of the help text, which tells you where to find more informa=
tion on what is being used to implement the clocksource.<br>
<br>
Hope that helps clarify the help text.<br>
<br>
Regards,<br>
Mark<br>
<br>
<br>
<br>
</blockquote></div>

--000000000000d9eeb705795f037e--

