MIME-Version: 1.0
In-Reply-To: <CAFFT=UnmqonF2LSb9HNoiBQXeuWTA+La=B-fp54miv_NnTjg3Q@mail.gmail.com>
References: <CADp+U7ibiKciX8_cpzGzob4oL-UF-H+W7kYuiujovD0ba=hM6A@mail.gmail.com>
	<56464ACC.9030605@kernel.dk>
	<CADp+U7gHq5VJgRFzGXvHTKN8Tyz9NDUZGePDWQ548ciyJmGr7A@mail.gmail.com>
	<56465F00.1060504@kernel.dk>
	<CADp+U7i=OPhuF9+nB1MW0ScaPv5sX3mL4ASdJ-8AGrDMfX71oA@mail.gmail.com>
	<CAFXh1QgZNghYY9CKJY5BZA4=ARGzXWYVHBBpHxV724qu2Wd5Hw@mail.gmail.com>
	<564F798A.8050009@kernel.dk>
	<CAFFT=UnmqonF2LSb9HNoiBQXeuWTA+La=B-fp54miv_NnTjg3Q@mail.gmail.com>
Date: Fri, 20 Nov 2015 17:03:09 -0700
Message-ID: <CAKb3OG9GfNrypxFPMMRR1W2QTi=Pnt0AXnFzzjDv4cJ9k0ZuVA@mail.gmail.com>
Subject: Re: Running a separate fio process for each disk?
From: Jens Axboe <axboe@kernel.dk>
Content-Type: multipart/alternative; boundary=001a114fa21499cce8052501b79e
To: Akash Verma <akashv@google.com>
Cc: Caio Villela <caio@google.com>, Allen Schade <aschade@google.com>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

--001a114fa21499cce8052501b79e
Content-Type: text/plain; charset=UTF-8

Hi,

OK, I see. Can you pull the latest -git, and then run fio --cpuclock-test
on one of the boxes where you see the issue? It should have
commit 5896d827e1e2 or later.


On Fri, Nov 20, 2015 at 3:20 PM, Akash Verma <akashv@google.com> wrote:

> Hi Jens,
> The issue is not seen with non-cpu clock sources, or when using a
> single process (with individual threads, the only config I tried). We
> only see the issue when using multiple processes and the cpu clock
> source.
>
> On Fri, Nov 20, 2015 at 11:50 AM, Jens Axboe <axboe@kernel.dk> wrote:
> > On 11/20/2015 12:37 PM, Caio Villela wrote:
> >>
> >> Hello Allen and Jens,
> >>
> >> Sorry for the long output, this is just in case you want the details.
> >> Here is a simple explanation for the problem. I want to run a 15 minute
> >> random write, using 1 Meg requests, and measure throughput and latency.
> >> What seems to be the problem is that if the test system has a large
> >> number of drives - the system that I am testing here has 28 drives -
> >> then the time accounting seems to go bad for some of the processes.
> >> What you see below is that during the 15 minutes from start, all disks
> >> are getting hit the same, as they should. Then, after 15 minutes, there
> >> are 15 drives that are still running.... after 5 minutes over the
> >> specified 15 minutes, there is still one drive running. Then looking at
> >> the amount of IOs sent to each drive, the ones that ran on that excess
> >> time have much more IOs. FIO still reports that all drives ran for 15
> >> minutes, although some ran for more than 20 minutes.
> >>
> >> We will attempt to run a single process instead of 28 instances of FIO
> >> to see if this goes away.
> >
> >
> > Could you also check if adding clocksource=gettimeofday makes any
> > difference? This sounds very odd.
> >
> > Assuming this was run with fio -git?
> >
> >
> > --
> > Jens Axboe
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe fio" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--001a114fa21499cce8052501b79e
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<div><br></div><div>OK, I see. Can you pull the latest =
-git, and then run fio --cpuclock-test on one of the boxes where you see th=
e issue? It should have commit=C2=A05896d827e1e2 or later.</div><div><br></=
div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Fri,=
 Nov 20, 2015 at 3:20 PM, Akash Verma <span dir=3D"ltr">&lt;<a href=3D"mail=
to:akashv@google.com" target=3D"_blank">akashv@google.com</a>&gt;</span> wr=
ote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border=
-left:1px #ccc solid;padding-left:1ex">Hi Jens,<br>
The issue is not seen with non-cpu clock sources, or when using a<br>
single process (with individual threads, the only config I tried). We<br>
only see the issue when using multiple processes and the cpu clock<br>
source.<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
On Fri, Nov 20, 2015 at 11:50 AM, Jens Axboe &lt;<a href=3D"mailto:axboe@ke=
rnel.dk">axboe@kernel.dk</a>&gt; wrote:<br>
&gt; On 11/20/2015 12:37 PM, Caio Villela wrote:<br>
&gt;&gt;<br>
&gt;&gt; Hello Allen and Jens,<br>
&gt;&gt;<br>
&gt;&gt; Sorry for the long output, this is just in case you want the detai=
ls.<br>
&gt;&gt; Here is a simple explanation for the problem. I want to run a 15 m=
inute<br>
&gt;&gt; random write, using 1 Meg requests, and measure throughput and lat=
ency.<br>
&gt;&gt; What seems to be the problem is that if the test system has a larg=
e<br>
&gt;&gt; number of drives - the system that I am testing here has 28 drives=
 -<br>
&gt;&gt; then the time accounting seems to go bad for some of the processes=
.<br>
&gt;&gt; What you see below is that during the 15 minutes from start, all d=
isks<br>
&gt;&gt; are getting hit the same, as they should. Then, after 15 minutes, =
there<br>
&gt;&gt; are 15 drives that are still running.... after 5 minutes over the<=
br>
&gt;&gt; specified 15 minutes, there is still one drive running. Then looki=
ng at<br>
&gt;&gt; the amount of IOs sent to each drive, the ones that ran on that ex=
cess<br>
&gt;&gt; time have much more IOs. FIO still reports that all drives ran for=
 15<br>
&gt;&gt; minutes, although some ran for more than 20 minutes.<br>
&gt;&gt;<br>
&gt;&gt; We will attempt to run a single process instead of 28 instances of=
 FIO<br>
&gt;&gt; to see if this goes away.<br>
&gt;<br>
&gt;<br>
&gt; Could you also check if adding clocksource=3Dgettimeofday makes any<br=
>
&gt; difference? This sounds very odd.<br>
&gt;<br>
&gt; Assuming this was run with fio -git?<br>
&gt;<br>
&gt;<br>
&gt; --<br>
&gt; Jens Axboe<br>
&gt;<br>
</div></div><span class=3D"HOEnZb"><font color=3D"#888888">&gt; --<br>
&gt; To unsubscribe from this list: send the line &quot;unsubscribe fio&quo=
t; in<br>
&gt; the body of a message to <a href=3D"mailto:majordomo@vger.kernel.org">=
majordomo@vger.kernel.org</a><br>
&gt; More majordomo info at=C2=A0 <a href=3D"http://vger.kernel.org/majordo=
mo-info.html" rel=3D"noreferrer" target=3D"_blank">http://vger.kernel.org/m=
ajordomo-info.html</a><br>
</font></span></blockquote></div><br></div>

--001a114fa21499cce8052501b79e--

