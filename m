Return-Path: <greg.sullivan@sullivang.net>
MIME-Version: 1.0
In-Reply-To: <502A4D22.3090200@kernel.dk>
References: <CAHaS=Qz8_g=0RqV53G_PuSM7Apvbbn3ksuF5MvkFUo7vme40Fw@mail.gmail.com>
	<502A4D22.3090200@kernel.dk>
Date: Tue, 14 Aug 2012 23:10:30 +1000
Message-ID: <CAHaS=QxEGgwqN7nqBbMxEMXBRDKyo9JXKMR3tRnQoD3ZeMk_SA@mail.gmail.com>
Subject: Re: How to do strict synchronous i/o on Windows?
From: Greg Sullivan <greg.sullivan@sullivang.net>
Content-Type: multipart/alternative; boundary=90e6ba613aeee5742004c73988ac
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

--90e6ba613aeee5742004c73988ac
Content-Type: text/plain; charset=ISO-8859-1

Thanks Jens. I do in fact have an application that reads in exactly the
manner I described. I have monitored the queue depth - it does not rise
above 1.  It is a real time musical sample streamer.

Please consider this a new feature request for fio - thankyou.

Greg.
 On Aug 14, 2012 11:06 PM, "Jens Axboe" <axboe@kernel.dk> wrote:

> On 08/14/2012 08:24 AM, Greg Sullivan wrote:
> > I need to simulate strict synchronous, round robin i/o to a group of
> > files. I am on Windows 7 32-bit.
> > fio is very nearly working, except that even with a queue depth of 1,
> > it is still resulting in a disk queue that is > 1, because the
> > "iodepth" parameter is not global - it is per thread. (correct?)
> >
> > I've tried using the "sync" engine, however that doesn't work at all -
> > just spews out errors.
>
> That'll be the case for ANY platform and IO engine. If you have more
> than 1 thread or process going, you can have > 1 depth at the device
> side. The definition of a sync IO call is that the call doesn't return
> until the IO is done. If you have overlapped calls due to more than 1
> thread, then that is no longer true.
>
> What you are looking for is outside the scope of an application. You
> would have to limit the queue depth on the operating system side to
> achieve that. Or artificially limit fio in some way, which would not
> make a lot of sense imho.
>
> --
> Jens Axboe
>
>

--90e6ba613aeee5742004c73988ac
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<p>Thanks Jens. I do in fact have an application that reads in exactly the =
manner I described. I have monitored the queue depth - it does not rise abo=
ve 1.=A0 It is a real time musical sample streamer.</p>
<p>Please consider this a new feature request for fio - thankyou.</p>
<p>Greg.<br>
</p>
<div class=3D"gmail_quote">On Aug 14, 2012 11:06 PM, &quot;Jens Axboe&quot;=
 &lt;<a href=3D"mailto:axboe@kernel.dk">axboe@kernel.dk</a>&gt; wrote:<br t=
ype=3D"attribution"><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0=
 .8ex;border-left:1px #ccc solid;padding-left:1ex">
On 08/14/2012 08:24 AM, Greg Sullivan wrote:<br>
&gt; I need to simulate strict synchronous, round robin i/o to a group of<b=
r>
&gt; files. I am on Windows 7 32-bit.<br>
&gt; fio is very nearly working, except that even with a queue depth of 1,<=
br>
&gt; it is still resulting in a disk queue that is &gt; 1, because the<br>
&gt; &quot;iodepth&quot; parameter is not global - it is per thread. (corre=
ct?)<br>
&gt;<br>
&gt; I&#39;ve tried using the &quot;sync&quot; engine, however that doesn&#=
39;t work at all -<br>
&gt; just spews out errors.<br>
<br>
That&#39;ll be the case for ANY platform and IO engine. If you have more<br=
>
than 1 thread or process going, you can have &gt; 1 depth at the device<br>
side. The definition of a sync IO call is that the call doesn&#39;t return<=
br>
until the IO is done. If you have overlapped calls due to more than 1<br>
thread, then that is no longer true.<br>
<br>
What you are looking for is outside the scope of an application. You<br>
would have to limit the queue depth on the operating system side to<br>
achieve that. Or artificially limit fio in some way, which would not<br>
make a lot of sense imho.<br>
<br>
--<br>
Jens Axboe<br>
<br>
</blockquote></div>

--90e6ba613aeee5742004c73988ac--


