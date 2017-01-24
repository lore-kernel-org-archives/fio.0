Return-Path: <andrey.v.kuzmin@gmail.com>
MIME-Version: 1.0
In-Reply-To: <fca1cdb1-aa66-b21f-d1a0-029ba895d3f2@gmail.com>
References: <90865544-f790-513c-97df-7e6a6af20ca8@gmail.com>
 <CANvN+en2ihATNgrbgzwNXAK87wNh+6jXHinmg2-VmHon31AJzA@mail.gmail.com>
 <061acabe-dbd0-ae07-cd69-772eccd15b21@gmail.com> <CANvN+em0cjWRnQWccdORKFEJk0OSeQOrZq+XE6kzPmqMPB--4g@mail.gmail.com>
 <49ef9d71-8e52-26e4-76f7-ea03fb331a38@gmail.com> <CALjAwxjmW-NgWEcH7+nKNN8U_oUxFoYa23dui9wM6WDqiShWhw@mail.gmail.com>
 <15418080-0bf6-ab40-c05f-69a3fb3d9cc3@gmail.com> <CALjAwxhsvfH0-D=4U6nkjFg109Z1ZgVRsOx37X+Lb-EqTf_jOA@mail.gmail.com>
 <6b2cacaf-2946-6046-51c2-b909c6ee0784@gmail.com> <CANvN+emLjb9idri9r42V3W9ia6v0EDGdJYFfhzq6rAuzGWec8Q@mail.gmail.com>
 <CANvN+emJBzMeUmjBw5PBSZc66LmjG8-Pz+39dBeL5GseMCdo6g@mail.gmail.com> <fca1cdb1-aa66-b21f-d1a0-029ba895d3f2@gmail.com>
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Tue, 24 Jan 2017 11:21:13 +0300
Message-ID: <CANvN+emQ0AYPgT0e6KMKphDTZAY=cW6FyroLw=smReHGpd-=TA@mail.gmail.com>
Subject: Re: 4x lower IOPS: Linux MD vs indiv. devices - why?
Content-Type: multipart/alternative; boundary=001a113fd9a2a743420546d2cce1
To: Tobias Oberstein <tobias.oberstein@gmail.com>
Cc: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

--001a113fd9a2a743420546d2cce1
Content-Type: text/plain; charset=UTF-8

On Jan 24, 2017 02:51, "Tobias Oberstein" <tobias.oberstein@gmail.com>
wrote:

The root cause behind the high cpu utilization is the IRQ load your eight
> NVMe drives generate, although context switching your 2048 threads also add
> a lot.
>

Indeed, the ctx switches and interrupts are in the millions/sec.

With engine=sync and numjobs=2048, I have

ctx_sw: 8828446
inter:  5780374

It's astonishing that this is even possible.


To cope with the unsustainable interrupt rate, you might want to give a
> shot to the psync engine with RWF_HIPRI option set, which turns on polling
> mode in the block layer (Jens has been very much behind it, so he's the guy
> in the know of the details).
>
> Polling avoids interrupts at the price of the somewhat inflated latency,
> but reduces the cpu load noticeably, so it may turn out a good option for
> your box specifically. Notice you'll need preadv2/pwrirev2 syscall support
> in your kernel.
>

I have run an exhaustive number of 30 tests using the different engines,
including pvsync2 + hipri.

Please find everything here

https://github.com/oberstet/scratchbox/blob/master/cruncher/
sync-engines/README.md

and in the containing folder there.

Using pvsync2 + hipri indeed changes the picture .. but not to the better =(



Surprising it didn't work for you since polling is very well suited for
your specific scenario.


The machine completely bogs down and the IOPS doesn't get higher.

Sidenote: would nice if FIO logged the total CPU and interrupt rates ..

Here is a screenshot while running pvsync2+hipri

http://picpaste.com/pics/Bildschirmfoto_vom_2017-01-23_23-
52-10-55NJYHu2.1485215076.png

--

My current preliminary conclusions on this box / workload:

- running psync is much better than sync



So you likely have a convincing case for Postgres guys to switch over to
pread/pwrite.

Regards,
Andrey

- all engines "above" psync only bring minor perf. gains
- Linux MD (pure striping, RAID-0) comes with rougly 45% overhead
- saturing the storage subsystem consumes nearly all CPU

Cheers,
/Tobias

PS: I have a small time window left (days) until this box goes into further
setup for production (which means, I cannot scratch the storage anymore) -
if you have anything you want me to try, let me know. I do my best to get
it tested. The hardware is probably not mainstream ..

--001a113fd9a2a743420546d2cce1
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><div><br><div class=3D"gmail_extra"><br><div class=3D"gma=
il_quote">On Jan 24, 2017 02:51, &quot;Tobias Oberstein&quot; &lt;<a href=
=3D"mailto:tobias.oberstein@gmail.com">tobias.oberstein@gmail.com</a>&gt; w=
rote:<br type=3D"attribution"><blockquote class=3D"quote" style=3D"margin:0=
 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><div class=3D"quoted=
-text"><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-=
left:1px #ccc solid;padding-left:1ex">
The root cause behind the high cpu utilization is the IRQ load your eight<b=
r>
NVMe drives generate, although context switching your 2048 threads also add=
<br>
a lot.<br>
</blockquote>
<br></div>
Indeed, the ctx switches and interrupts are in the millions/sec.<br>
<br>
With engine=3Dsync and numjobs=3D2048, I have<br>
<br>
ctx_sw: 8828446<br>
inter:=C2=A0 5780374<br>
<br>
It&#39;s astonishing that this is even possible.<div class=3D"quoted-text">=
<br>
<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
To cope with the unsustainable interrupt rate, you might want to give a<br>
shot to the psync engine with RWF_HIPRI option set, which turns on polling<=
br>
mode in the block layer (Jens has been very much behind it, so he&#39;s the=
 guy<br>
in the know of the details).<br>
<br>
Polling avoids interrupts at the price of the somewhat inflated latency,<br=
>
but reduces the cpu load noticeably, so it may turn out a good option for<b=
r>
your box specifically. Notice you&#39;ll need preadv2/pwrirev2 syscall supp=
ort<br>
in your kernel.<br>
</blockquote>
<br></div>
I have run an exhaustive number of 30 tests using the different engines, in=
cluding pvsync2 + hipri.<br>
<br>
Please find everything here<br>
<br>
<a href=3D"https://github.com/oberstet/scratchbox/blob/master/cruncher/sync=
-engines/README.md" rel=3D"noreferrer" target=3D"_blank">https://github.com=
/oberstet/sc<wbr>ratchbox/blob/master/cruncher/<wbr>sync-engines/README.md<=
/a><br>
<br>
and in the containing folder there.<br>
<br>
Using pvsync2 + hipri indeed changes the picture .. but not to the better =
=3D(<br></blockquote></div></div></div><div dir=3D"auto"><br></div><div dir=
=3D"auto"><br></div><div dir=3D"auto">Surprising it didn&#39;t work for you=
 since polling is very well suited for your specific scenario.</div><div di=
r=3D"auto"><div class=3D"gmail_extra"><div class=3D"gmail_quote"><blockquot=
e class=3D"quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;pad=
ding-left:1ex">
<br>
The machine completely bogs down and the IOPS doesn&#39;t get higher.<br>
<br>
Sidenote: would nice if FIO logged the total CPU and interrupt rates ..<br>
<br>
Here is a screenshot while running pvsync2+hipri<br>
<br>
<a href=3D"http://picpaste.com/pics/Bildschirmfoto_vom_2017-01-23_23-52-10-=
55NJYHu2.1485215076.png" rel=3D"noreferrer" target=3D"_blank">http://picpas=
te.com/pics/Bilds<wbr>chirmfoto_vom_2017-01-23_23-<wbr>52-10-55NJYHu2.14852=
15076.png</a><br>
<br>
--<br>
<br>
My current preliminary conclusions on this box / workload:<br>
<br>
- running psync is much better than sync<br></blockquote></div></div></div>=
<div dir=3D"auto"><br></div><div dir=3D"auto"><br></div><div dir=3D"auto">S=
o you likely have a convincing case for Postgres guys to switch over to pre=
ad/pwrite.</div><div dir=3D"auto"><br></div><div dir=3D"auto">Regards,</div=
><div dir=3D"auto">Andrey</div><div dir=3D"auto"><br></div><div dir=3D"auto=
"><div class=3D"gmail_extra"><div class=3D"gmail_quote"><blockquote class=
=3D"quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-le=
ft:1ex">
- all engines &quot;above&quot; psync only bring minor perf. gains<br>
- Linux MD (pure striping, RAID-0) comes with rougly 45% overhead<br>
- saturing the storage subsystem consumes nearly all CPU<br>
<br>
Cheers,<br>
/Tobias<br>
<br>
PS: I have a small time window left (days) until this box goes into further=
 setup for production (which means, I cannot scratch the storage anymore) -=
 if you have anything you want me to try, let me know. I do my best to get =
it tested. The hardware is probably not mainstream ..<br>
<br>
<br>
</blockquote></div><br></div></div></div>

--001a113fd9a2a743420546d2cce1--

