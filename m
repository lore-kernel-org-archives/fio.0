Return-Path: <konstantin.ruvinsky@gmail.com>
MIME-Version: 1.0
References: <CALKvLUnbsqZ8VDW5yKc8vbLU-3Sa4eMu2vb7u2vqm0NFQo+FZQ@mail.gmail.com>
 <e54427a7-8037-5aa2-06cc-0168b892eb89@kernel.dk>
In-Reply-To: <e54427a7-8037-5aa2-06cc-0168b892eb89@kernel.dk>
From: Konstantin Ruvinsky <konstantin.ruvinsky@gmail.com>
Date: Fri, 25 May 2018 05:46:21 +0300
Message-ID: <CALKvLUnFn+yxzrF1J5WQGQUJt0RG27Tp3EHfpWyaX2V3EO5ryw@mail.gmail.com>
Subject: Re: bssplit option HOWTO
Content-Type: multipart/alternative; boundary="000000000000aa5e0a056cfec642"
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

--000000000000aa5e0a056cfec642
Content-Type: text/plain; charset="UTF-8"

Jens,

Can you please do it instead me now?

Thanks


On Thu, 24 May 2018, 22:10 Jens Axboe, <axboe@kernel.dk> wrote:

> On 5/21/18 11:04 AM, Konstantin Ruvinsky wrote:
> > Hi
> >
> >
> >
> > In the last HOWTO is written:
> >
> >
> >
> >
> http://git.kernel.dk/?p=fio.git;a=blob;f=HOWTO;h=7680f9c7634a7e55044dba0a8ebdc6928fb3bfc0;hb=HEAD#l1429
> >
> >
> >
> >
> >
> > 1429       If you want a workload that has 50% 2k reads and 50% 4k
> reads, while
> >
> > 1430         having 90% 4k writes and 10% 8k writes, you would specify::
> >
> > 1431
> >
> > 1432                 bssplit=2k/50:4k/50,4k/90,8k/10
> >
> >
> >
> > Question:
> >
> > Has it be
> >
> >
> >
> > bssplit=2k/50:4k/50,4k/90:8k/10
>
> Yes, good patch. Care to send a patch?
>
> --
> Jens Axboe
>
>

--000000000000aa5e0a056cfec642
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto">Jens,<div dir=3D"auto"><br></div><div dir=3D"auto">Can yo=
u please do it instead me now?</div><div dir=3D"auto"><br></div><div dir=3D=
"auto">Thanks</div><div dir=3D"auto"><br></div></div><br><div class=3D"gmai=
l_quote"><div dir=3D"ltr">On Thu, 24 May 2018, 22:10 Jens Axboe, &lt;<a hre=
f=3D"mailto:axboe@kernel.dk">axboe@kernel.dk</a>&gt; wrote:<br></div><block=
quote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc=
 solid;padding-left:1ex">On 5/21/18 11:04 AM, Konstantin Ruvinsky wrote:<br=
>
&gt; Hi<br>
&gt; <br>
&gt; <br>
&gt; <br>
&gt; In the last HOWTO is written:<br>
&gt; <br>
&gt; <br>
&gt; <br>
&gt; <a href=3D"http://git.kernel.dk/?p=3Dfio.git;a=3Dblob;f=3DHOWTO;h=3D76=
80f9c7634a7e55044dba0a8ebdc6928fb3bfc0;hb=3DHEAD#l1429" rel=3D"noreferrer n=
oreferrer" target=3D"_blank">http://git.kernel.dk/?p=3Dfio.git;a=3Dblob;f=
=3DHOWTO;h=3D7680f9c7634a7e55044dba0a8ebdc6928fb3bfc0;hb=3DHEAD#l1429</a><b=
r>
&gt; <br>
&gt; <br>
&gt; <br>
&gt; <br>
&gt; <br>
&gt; 1429=C2=A0 =C2=A0 =C2=A0 =C2=A0If you want a workload that has 50% 2k =
reads and 50% 4k reads, while<br>
&gt; <br>
&gt; 1430=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0having 90% 4k writes and 10% 8k =
writes, you would specify::<br>
&gt; <br>
&gt; 1431<br>
&gt; <br>
&gt; 1432=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bssp=
lit=3D2k/50:4k/50,4k/90,8k/10<br>
&gt; <br>
&gt; <br>
&gt; <br>
&gt; Question:<br>
&gt; <br>
&gt; Has it be<br>
&gt; <br>
&gt; <br>
&gt; <br>
&gt; bssplit=3D2k/50:4k/50,4k/90:8k/10<br>
<br>
Yes, good patch. Care to send a patch?<br>
<br>
-- <br>
Jens Axboe<br>
<br>
</blockquote></div>

--000000000000aa5e0a056cfec642--

