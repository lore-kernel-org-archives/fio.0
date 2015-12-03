Return-Path: <akashv@google.com>
MIME-Version: 1.0
In-Reply-To: <56550C49.4070700@kernel.dk>
References: <CADp+U7ibiKciX8_cpzGzob4oL-UF-H+W7kYuiujovD0ba=hM6A@mail.gmail.com>
 <56464ACC.9030605@kernel.dk> <CADp+U7gHq5VJgRFzGXvHTKN8Tyz9NDUZGePDWQ548ciyJmGr7A@mail.gmail.com>
 <56465F00.1060504@kernel.dk> <CADp+U7i=OPhuF9+nB1MW0ScaPv5sX3mL4ASdJ-8AGrDMfX71oA@mail.gmail.com>
 <CAFXh1QgZNghYY9CKJY5BZA4=ARGzXWYVHBBpHxV724qu2Wd5Hw@mail.gmail.com>
 <564F798A.8050009@kernel.dk> <CAFFT=UnmqonF2LSb9HNoiBQXeuWTA+La=B-fp54miv_NnTjg3Q@mail.gmail.com>
 <CAKb3OG9GfNrypxFPMMRR1W2QTi=Pnt0AXnFzzjDv4cJ9k0ZuVA@mail.gmail.com>
 <564FB905.7060609@kernel.dk> <5654876F.9080803@kernel.dk> <CAFFT=UnYcVN4s=eZ8Uj63VonEcuApfAQz1AoiOaVZqdrwgZLYw@mail.gmail.com>
 <56550C49.4070700@kernel.dk>
From: Akash Verma <akashv@google.com>
Date: Thu, 3 Dec 2015 10:54:42 -0800
Message-ID: <CAFFT=Uks8j+K7M0dfT0tS2aiRTOHCqu0S_3-DnKY2zL-K33T7g@mail.gmail.com>
Subject: Re: Running a separate fio process for each disk?
Content-Type: multipart/alternative; boundary=001a114f87d49ef6cd052602edf4
To: Jens Axboe <axboe@kernel.dk>
Cc: Michael Bella <mbella@google.com>, Caio Villela <caio@google.com>, Allen Schade <aschade@google.com>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

--001a114f87d49ef6cd052602edf4
Content-Type: text/plain; charset=UTF-8

Jens, I confirmed that the issue is not seen with the latest FIO (I used
version fio-2.2.12-15-gcdab).

On Tue, Nov 24, 2015 at 5:18 PM, Jens Axboe <axboe@kernel.dk> wrote:

> No worries, I know this week is a bit more problematic than usual. I'll
> hold off on the new release until I know.
>
>
>
> On 11/24/2015 01:51 PM, Akash Verma wrote:
>
>> Sorry for not getting back - I didn't get a chance to try the latest
>> git, and I'm off on vacation soon; I'm ccing Michael and Caio who
>> might have a chance to try it out before Thursday. Michael or Caio,
>> could you try run the two things Jens asked (the cpuclock test using
>> the FIO we've been currently using as well as the latest from Git; and
>> the regular multi-process FIO run with the latest git)?
>>
>> On Tue, Nov 24, 2015 at 7:51 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>
>>> Did you try current -git yet? I think it should work for both scenarios.
>>> It's a silly bug, would be great to have confirmation that it's fixed.
>>> Then
>>> I'll spin a new release.
>>>
>>>
>>>
>>> On 11/20/2015 05:21 PM, Jens Axboe wrote:
>>>
>>>>
>>>> And finally, there's a potential fix, if you run commit
>>>> 99afcdb53dc3 or later. So please do try that as well, and
>>>> see if that behaves any better for you.
>>>>
>>>>
>>>> On 11/20/2015 05:03 PM, Jens Axboe wrote:
>>>>
>>>>>
>>>>> Hi,
>>>>>
>>>>> OK, I see. Can you pull the latest -git, and then run fio
>>>>> --cpuclock-test on one of the boxes where you see the issue? It should
>>>>> have commit 5896d827e1e2 or later.
>>>>>
>>>>>
>>>>> On Fri, Nov 20, 2015 at 3:20 PM, Akash Verma <akashv@google.com
>>>>> <mailto:akashv@google.com>> wrote:
>>>>>
>>>>>      Hi Jens,
>>>>>      The issue is not seen with non-cpu clock sources, or when using a
>>>>>      single process (with individual threads, the only config I
>>>>> tried). We
>>>>>      only see the issue when using multiple processes and the cpu clock
>>>>>      source.
>>>>>
>>>>>      On Fri, Nov 20, 2015 at 11:50 AM, Jens Axboe <axboe@kernel.dk
>>>>>      <mailto:axboe@kernel.dk>> wrote:
>>>>>       > On 11/20/2015 12:37 PM, Caio Villela wrote:
>>>>>       >>
>>>>>       >> Hello Allen and Jens,
>>>>>       >>
>>>>>       >> Sorry for the long output, this is just in case you want the
>>>>>      details.
>>>>>       >> Here is a simple explanation for the problem. I want to run a
>>>>> 15
>>>>>      minute
>>>>>       >> random write, using 1 Meg requests, and measure throughput and
>>>>>      latency.
>>>>>       >> What seems to be the problem is that if the test system has a
>>>>> large
>>>>>       >> number of drives - the system that I am testing here has 28
>>>>> drives -
>>>>>       >> then the time accounting seems to go bad for some of the
>>>>> processes.
>>>>>       >> What you see below is that during the 15 minutes from start,
>>>>> all
>>>>>      disks
>>>>>       >> are getting hit the same, as they should. Then, after 15
>>>>>      minutes, there
>>>>>       >> are 15 drives that are still running.... after 5 minutes over
>>>>> the
>>>>>       >> specified 15 minutes, there is still one drive running. Then
>>>>>      looking at
>>>>>       >> the amount of IOs sent to each drive, the ones that ran on
>>>>> that
>>>>>      excess
>>>>>       >> time have much more IOs. FIO still reports that all drives ran
>>>>>      for 15
>>>>>       >> minutes, although some ran for more than 20 minutes.
>>>>>       >>
>>>>>       >> We will attempt to run a single process instead of 28
>>>>> instances
>>>>>      of FIO
>>>>>       >> to see if this goes away.
>>>>>       >
>>>>>       >
>>>>>       > Could you also check if adding clocksource=gettimeofday makes
>>>>> any
>>>>>       > difference? This sounds very odd.
>>>>>       >
>>>>>       > Assuming this was run with fio -git?
>>>>>       >
>>>>>       >
>>>>>       > --
>>>>>       > Jens Axboe
>>>>>       >
>>>>>      > --
>>>>>      > To unsubscribe from this list: send the line "unsubscribe fio"
>>>>> in
>>>>>      > the body of a message tomajordomo@vger.kernel.org
>>>>> <mailto:majordomo@vger.kernel.org>
>>>>>      > More majordomo info athttp://
>>>>> vger.kernel.org/majordomo-info.html
>>>>>
>>>>>
>>>>>
>>>>
>>>>
>>>
>>> --
>>> Jens Axboe
>>>
>>>
>
> --
> Jens Axboe
>
>

--001a114f87d49ef6cd052602edf4
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Jens, I confirmed that the issue is not seen with the late=
st FIO (I used version=C2=A0fio-2.2.12-15-gcdab).</div><div class=3D"gmail_=
extra"><br><div class=3D"gmail_quote">On Tue, Nov 24, 2015 at 5:18 PM, Jens=
 Axboe <span dir=3D"ltr">&lt;<a href=3D"mailto:axboe@kernel.dk" target=3D"_=
blank">axboe@kernel.dk</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_=
quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1=
ex">No worries, I know this week is a bit more problematic than usual. I&#3=
9;ll hold off on the new release until I know.<div class=3D"HOEnZb"><div cl=
ass=3D"h5"><br>
<br>
<br>
On 11/24/2015 01:51 PM, Akash Verma wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
Sorry for not getting back - I didn&#39;t get a chance to try the latest<br=
>
git, and I&#39;m off on vacation soon; I&#39;m ccing Michael and Caio who<b=
r>
might have a chance to try it out before Thursday. Michael or Caio,<br>
could you try run the two things Jens asked (the cpuclock test using<br>
the FIO we&#39;ve been currently using as well as the latest from Git; and<=
br>
the regular multi-process FIO run with the latest git)?<br>
<br>
On Tue, Nov 24, 2015 at 7:51 AM, Jens Axboe &lt;<a href=3D"mailto:axboe@ker=
nel.dk" target=3D"_blank">axboe@kernel.dk</a>&gt; wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
Did you try current -git yet? I think it should work for both scenarios.<br=
>
It&#39;s a silly bug, would be great to have confirmation that it&#39;s fix=
ed. Then<br>
I&#39;ll spin a new release.<br>
<br>
<br>
<br>
On 11/20/2015 05:21 PM, Jens Axboe wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
<br>
And finally, there&#39;s a potential fix, if you run commit<br>
99afcdb53dc3 or later. So please do try that as well, and<br>
see if that behaves any better for you.<br>
<br>
<br>
On 11/20/2015 05:03 PM, Jens Axboe wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
<br>
Hi,<br>
<br>
OK, I see. Can you pull the latest -git, and then run fio<br>
--cpuclock-test on one of the boxes where you see the issue? It should<br>
have commit 5896d827e1e2 or later.<br>
<br>
<br>
On Fri, Nov 20, 2015 at 3:20 PM, Akash Verma &lt;<a href=3D"mailto:akashv@g=
oogle.com" target=3D"_blank">akashv@google.com</a><br>
&lt;mailto:<a href=3D"mailto:akashv@google.com" target=3D"_blank">akashv@go=
ogle.com</a>&gt;&gt; wrote:<br>
<br>
=C2=A0 =C2=A0 =C2=A0Hi Jens,<br>
=C2=A0 =C2=A0 =C2=A0The issue is not seen with non-cpu clock sources, or wh=
en using a<br>
=C2=A0 =C2=A0 =C2=A0single process (with individual threads, the only confi=
g I tried). We<br>
=C2=A0 =C2=A0 =C2=A0only see the issue when using multiple processes and th=
e cpu clock<br>
=C2=A0 =C2=A0 =C2=A0source.<br>
<br>
=C2=A0 =C2=A0 =C2=A0On Fri, Nov 20, 2015 at 11:50 AM, Jens Axboe &lt;<a hre=
f=3D"mailto:axboe@kernel.dk" target=3D"_blank">axboe@kernel.dk</a><br>
=C2=A0 =C2=A0 =C2=A0&lt;mailto:<a href=3D"mailto:axboe@kernel.dk" target=3D=
"_blank">axboe@kernel.dk</a>&gt;&gt; wrote:<br>
=C2=A0 =C2=A0 =C2=A0 &gt; On 11/20/2015 12:37 PM, Caio Villela wrote:<br>
=C2=A0 =C2=A0 =C2=A0 &gt;&gt;<br>
=C2=A0 =C2=A0 =C2=A0 &gt;&gt; Hello Allen and Jens,<br>
=C2=A0 =C2=A0 =C2=A0 &gt;&gt;<br>
=C2=A0 =C2=A0 =C2=A0 &gt;&gt; Sorry for the long output, this is just in ca=
se you want the<br>
=C2=A0 =C2=A0 =C2=A0details.<br>
=C2=A0 =C2=A0 =C2=A0 &gt;&gt; Here is a simple explanation for the problem.=
 I want to run a 15<br>
=C2=A0 =C2=A0 =C2=A0minute<br>
=C2=A0 =C2=A0 =C2=A0 &gt;&gt; random write, using 1 Meg requests, and measu=
re throughput and<br>
=C2=A0 =C2=A0 =C2=A0latency.<br>
=C2=A0 =C2=A0 =C2=A0 &gt;&gt; What seems to be the problem is that if the t=
est system has a<br>
large<br>
=C2=A0 =C2=A0 =C2=A0 &gt;&gt; number of drives - the system that I am testi=
ng here has 28<br>
drives -<br>
=C2=A0 =C2=A0 =C2=A0 &gt;&gt; then the time accounting seems to go bad for =
some of the<br>
processes.<br>
=C2=A0 =C2=A0 =C2=A0 &gt;&gt; What you see below is that during the 15 minu=
tes from start, all<br>
=C2=A0 =C2=A0 =C2=A0disks<br>
=C2=A0 =C2=A0 =C2=A0 &gt;&gt; are getting hit the same, as they should. The=
n, after 15<br>
=C2=A0 =C2=A0 =C2=A0minutes, there<br>
=C2=A0 =C2=A0 =C2=A0 &gt;&gt; are 15 drives that are still running.... afte=
r 5 minutes over the<br>
=C2=A0 =C2=A0 =C2=A0 &gt;&gt; specified 15 minutes, there is still one driv=
e running. Then<br>
=C2=A0 =C2=A0 =C2=A0looking at<br>
=C2=A0 =C2=A0 =C2=A0 &gt;&gt; the amount of IOs sent to each drive, the one=
s that ran on that<br>
=C2=A0 =C2=A0 =C2=A0excess<br>
=C2=A0 =C2=A0 =C2=A0 &gt;&gt; time have much more IOs. FIO still reports th=
at all drives ran<br>
=C2=A0 =C2=A0 =C2=A0for 15<br>
=C2=A0 =C2=A0 =C2=A0 &gt;&gt; minutes, although some ran for more than 20 m=
inutes.<br>
=C2=A0 =C2=A0 =C2=A0 &gt;&gt;<br>
=C2=A0 =C2=A0 =C2=A0 &gt;&gt; We will attempt to run a single process inste=
ad of 28 instances<br>
=C2=A0 =C2=A0 =C2=A0of FIO<br>
=C2=A0 =C2=A0 =C2=A0 &gt;&gt; to see if this goes away.<br>
=C2=A0 =C2=A0 =C2=A0 &gt;<br>
=C2=A0 =C2=A0 =C2=A0 &gt;<br>
=C2=A0 =C2=A0 =C2=A0 &gt; Could you also check if adding clocksource=3Dgett=
imeofday makes any<br>
=C2=A0 =C2=A0 =C2=A0 &gt; difference? This sounds very odd.<br>
=C2=A0 =C2=A0 =C2=A0 &gt;<br>
=C2=A0 =C2=A0 =C2=A0 &gt; Assuming this was run with fio -git?<br>
=C2=A0 =C2=A0 =C2=A0 &gt;<br>
=C2=A0 =C2=A0 =C2=A0 &gt;<br>
=C2=A0 =C2=A0 =C2=A0 &gt; --<br>
=C2=A0 =C2=A0 =C2=A0 &gt; Jens Axboe<br>
=C2=A0 =C2=A0 =C2=A0 &gt;<br>
=C2=A0 =C2=A0 =C2=A0&gt; --<br>
=C2=A0 =C2=A0 =C2=A0&gt; To unsubscribe from this list: send the line &quot=
;unsubscribe fio&quot; in<br>
=C2=A0 =C2=A0 =C2=A0&gt; the body of a message <a href=3D"mailto:tomajordom=
o@vger.kernel.org" target=3D"_blank">tomajordomo@vger.kernel.org</a><br>
&lt;mailto:<a href=3D"mailto:majordomo@vger.kernel.org" target=3D"_blank">m=
ajordomo@vger.kernel.org</a>&gt;<br>
=C2=A0 =C2=A0 =C2=A0&gt; More majordomo info athttp://<a href=3D"http://vge=
r.kernel.org/majordomo-info.html" rel=3D"noreferrer" target=3D"_blank">vger=
.kernel.org/majordomo-info.html</a><br>
<br>
<br>
</blockquote>
<br>
<br>
</blockquote>
<br>
<br>
--<br>
Jens Axboe<br>
<br>
</blockquote></blockquote>
<br>
<br></div></div><span class=3D"HOEnZb"><font color=3D"#888888">
-- <br>
Jens Axboe<br>
<br>
</font></span></blockquote></div><br></div>

--001a114f87d49ef6cd052602edf4--

