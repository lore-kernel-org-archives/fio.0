Return-Path: <brianjamesarb@gmail.com>
MIME-Version: 1.0
In-Reply-To: <50F12401.8090606@kernel.dk>
References: <CABYizFKetDGfE_fOARgbehmJo_uDTqy32bMTQTDVyny-Nk5riQ@mail.gmail.com>
	<20130111091010.GA32674@kernel.dk>
	<50F12401.8090606@kernel.dk>
Date: Fri, 18 Jan 2013 12:25:58 -0500
Message-ID: <CABYizFLj4LSJApybuRfUfCiuqhVNac0T733BcMnpUOAivWhi7A@mail.gmail.com>
Subject: Re: fio is being killed by the oom-killer after fio verify runs for
 some time ~13 hours
From: brian arb <brianjamesarb@gmail.com>
Content-Type: multipart/alternative; boundary=f46d040890c195cf5204d39367c0
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

--f46d040890c195cf5204d39367c0
Content-Type: text/plain; charset=ISO-8859-1

adding the option --verify_backlog=1024 resolved my issue.
On a side note how would one determine what the optimum number is for this
option?


On Sat, Jan 12, 2013 at 3:51 AM, Jens Axboe <axboe@kernel.dk> wrote:

> On 2013-01-11 10:10, Jens Axboe wrote:
> > On Thu, Jan 10 2013, brian arb wrote:
> >> Seems fio is being killed by the oom-killer after fio verify runs for
> >> some time ~13 hours. What parameters can I tweak or how can I run my
> >> test differently so the test will be completed with out interruption?
> >
> > You are probably running into OOM issues since each completed write will
> > log some meta data to help verify that later. The easiest fix for you
> > would be to verify continously, setting a backlog of how old data can
> > get before being verified. See verify_backlog and verify_async for that.
> >
> > You should also upgrade your fio. Fio uses a random map for tracking
> > what has been written. It's static memory, so it wont cause your OOM
> > during runtime, but it will gobble up some memory when you start. If you
> > upgrade to 2.0.13 and use random_distribution=lfsr, then that memory
> > consumption will go away.
> >
> > There's room for a bit of improvement on fio for verification. Since IO
> > buffer contents and offsets etc are fully randomized with specific
> > seeding, it is possible to verify what has been written without storing
> > this meta data. Basically verify can just re-create the contents for
> > verification, instead of storing a checksum of it. That will cost some
> > CPU, but it will get you more predictable (and much lower) memory
> > consumption numbers. I will look into that. But as a starter, the above
> > suggestions should help you out.
>
> I committed the first part of this. Now I just need to double check that
> we re-seed properly, then we can dump the meta data storage for the
> "normal" verify workload (that has both a write and a read phase).
>
> --
> Jens Axboe
>
>

--f46d040890c195cf5204d39367c0
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

adding the option --verify_backlog=3D1024 resolved my issue.<div>On a side =
note how would one determine what the optimum number is for this option?</d=
iv><div><br></div><div><br><div class=3D"gmail_quote">On Sat, Jan 12, 2013 =
at 3:51 AM, Jens Axboe <span dir=3D"ltr">&lt;<a href=3D"mailto:axboe@kernel=
.dk" target=3D"_blank">axboe@kernel.dk</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"HOEnZb"><div class=3D"h5">On 2=
013-01-11 10:10, Jens Axboe wrote:<br>
&gt; On Thu, Jan 10 2013, brian arb wrote:<br>
&gt;&gt; Seems fio is being killed by the oom-killer after fio verify runs =
for<br>
&gt;&gt; some time ~13 hours. What parameters can I tweak or how can I run =
my<br>
&gt;&gt; test differently so the test will be completed with out interrupti=
on?<br>
&gt;<br>
&gt; You are probably running into OOM issues since each completed write wi=
ll<br>
&gt; log some meta data to help verify that later. The easiest fix for you<=
br>
&gt; would be to verify continously, setting a backlog of how old data can<=
br>
&gt; get before being verified. See verify_backlog and verify_async for tha=
t.<br>
&gt;<br>
&gt; You should also upgrade your fio. Fio uses a random map for tracking<b=
r>
&gt; what has been written. It&#39;s static memory, so it wont cause your O=
OM<br>
&gt; during runtime, but it will gobble up some memory when you start. If y=
ou<br>
&gt; upgrade to 2.0.13 and use random_distribution=3Dlfsr, then that memory=
<br>
&gt; consumption will go away.<br>
&gt;<br>
&gt; There&#39;s room for a bit of improvement on fio for verification. Sin=
ce IO<br>
&gt; buffer contents and offsets etc are fully randomized with specific<br>
&gt; seeding, it is possible to verify what has been written without storin=
g<br>
&gt; this meta data. Basically verify can just re-create the contents for<b=
r>
&gt; verification, instead of storing a checksum of it. That will cost some=
<br>
&gt; CPU, but it will get you more predictable (and much lower) memory<br>
&gt; consumption numbers. I will look into that. But as a starter, the abov=
e<br>
&gt; suggestions should help you out.<br>
<br>
</div></div>I committed the first part of this. Now I just need to double c=
heck that<br>
we re-seed properly, then we can dump the meta data storage for the<br>
&quot;normal&quot; verify workload (that has both a write and a read phase)=
.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
Jens Axboe<br>
<br>
</font></span></blockquote></div><br></div>

--f46d040890c195cf5204d39367c0--


