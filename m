Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <54288805.2020008@kernel.dk>
References: <542179FA.5040106@gmail.com>
	<CANvN+enrUD45Zp1CJKQ3kxQncHLyhp7hE1jr4AnzRD65oDTUvg@mail.gmail.com>
	<54228237.5000805@gmail.com>
	<CALjAwxg+o05=3YDOmXaKskrdg3AHU88T-pkqZw=QFQkwRTjdwA@mail.gmail.com>
	<CALjAwxirUW+v662QZ9zQG-2zuTNtE8xkpfaJqv=5ArLviqjhGw@mail.gmail.com>
	<5427716A.1080407@kernel.dk>
	<20140928103616.GA9991@sucs.org>
	<54281A0A.8050905@kernel.dk>
	<5428246F.7020506@kernel.dk>
	<20140928194419.GA24724@sucs.org>
	<54288805.2020008@kernel.dk>
Date: Mon, 29 Sep 2014 06:42:59 +0100
Message-ID: <CALjAwxiqmHgS-V6QME4Y+Z0my67Es7sU1QwhzjC8FwZqK4q4sA@mail.gmail.com>
Subject: Re: [Question] How to perform stride access?
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: multipart/alternative; boundary=f46d04447dfd4be4f805042dbdc2
To: Jens Axboe <axboe@kernel.dk>
Cc: Akira Hayakawa <ruby.wktk@gmail.com>, Andrey Kuzmin <andrey.v.kuzmin@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

--f46d04447dfd4be4f805042dbdc2
Content-Type: text/plain; charset=UTF-8

On 28 September 2014 23:13, Jens Axboe <axboe@kernel.dk> wrote:

> On 09/28/2014 01:44 PM, Sitsofe Wheeler wrote:
> > The patch fixes
> > fio --bs=4k --rw=write:4k --filename=/dev/shm/1M --name=go --io_limit=2M
> > but not
> > fio --bs=512k --rw=write --filename=/dev/shm/1M --name=go --number_io=4
>
> number_ios=x is implemented as a cap, not a forced "must complete this
> amount of ios to be done".
>

Ah I see. Now I look again the HOWTO even says it doesn't extend the number
of I/Os - I should have read more carefully!


> > or
> > fio --bs=4k --rw=write --filename=/dev/shm/1M --name=go --zoneskip=4k
> --zonesize=4k --io_limit=2M
>
> That one is a bit more tricky. Oh, try the attached (keep the previous
> applied).


 Latest patch fixes zone skipping for me too. Akira are things better for
you too?

-- 
Sitsofe | http://sucs.org/~sits/

--f46d04447dfd4be4f805042dbdc2
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote">On 2=
8 September 2014 23:13, Jens Axboe <span dir=3D"ltr">&lt;<a href=3D"mailto:=
axboe@kernel.dk" target=3D"_blank">axboe@kernel.dk</a>&gt;</span> wrote:<br=
><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1=
px #ccc solid;padding-left:1ex"><div class=3D"HOEnZb"><div class=3D"h5">On =
09/28/2014 01:44 PM, Sitsofe Wheeler wrote:<br>&gt; The patch fixes<br>
&gt; fio --bs=3D4k --rw=3Dwrite:4k --filename=3D/dev/shm/1M --name=3Dgo --i=
o_limit=3D2M<br>
&gt; but not<br>
&gt; fio --bs=3D512k --rw=3Dwrite --filename=3D/dev/shm/1M --name=3Dgo --nu=
mber_io=3D4<br>
<br>
</div></div>number_ios=3Dx is implemented as a cap, not a forced &quot;must=
 complete this<br>
amount of ios to be done&quot;.<br></blockquote><div><br></div><div>Ah I se=
e. Now I look again the HOWTO even says it doesn&#39;t extend the number of=
 I/Os - I should have read more carefully!</div><div>=C2=A0</div><blockquot=
e class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc sol=
id;padding-left:1ex"><span class=3D"">
&gt; or<br>
&gt; fio --bs=3D4k --rw=3Dwrite --filename=3D/dev/shm/1M --name=3Dgo --zone=
skip=3D4k --zonesize=3D4k --io_limit=3D2M<br>
<br>
</span>That one is a bit more tricky. Oh, try the attached (keep the previo=
us<br>
applied).</blockquote><div><br></div><div>=C2=A0Latest patch fixes zone ski=
pping for me too. Akira are things better for you too?</div></div><div><br>=
</div>-- <br>Sitsofe | <a href=3D"http://sucs.org/~sits/">http://sucs.org/~=
sits/</a>
</div></div>

--f46d04447dfd4be4f805042dbdc2--

