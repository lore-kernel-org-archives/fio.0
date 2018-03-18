Return-Path: <kip.ingram@gmail.com>
MIME-Version: 1.0
In-Reply-To: <1ki9i1iq876vpc8n312a4fog.1521308394157@email.lge.com>
References: <1ki9i1iq876vpc8n312a4fog.1521308394157@email.lge.com>
From: Kip Ingram <kip.ingram@gmail.com>
Date: Sat, 17 Mar 2018 19:43:20 -0500
Message-ID: <CAH6SkxrbN4T34YUn1kgAFXoMPkBiiBv9fY535X+ww7v7GX7ROQ@mail.gmail.com>
Subject: Re: FIO's rdma engine...
Content-Type: multipart/alternative; boundary="94eb2c05dd8ec54beb0567a520aa"
To: "lsgunthorpe@gmail.com" <lsgunthorpe@gmail.com>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Stephen Bates <sbates@raithlin.com>
List-ID: <fio@vger.kernel.org>

--94eb2c05dd8ec54beb0567a520aa
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi guys.  Yes, I did realize that after not very much wheel spinning.  I
wound up using libaio, and immediately got my storage box to its
performance envelope.  There cheers to fio - it's a great tool.

On Sat, Mar 17, 2018 at 12:57 PM, lsgunthorpe@gmail.com <
lsgunthorpe@gmail.com> wrote:

> Hi Kip,
>
> The RDMA engine in FIO was designed to measure the performance of RDMA
> links similar to the perftest tool set.
>
> It does not test a block device at all. If I remember correctly 'rw'
> specifies whether the instance running is a client or server and the 'ver=
b'
> attribute specifies whether you are reading, writing, sending or recving.
> 'size' is required to specify the length of the test.
>
> So it doesn't sound like it's what you are looking for. I'd suggest
> setting up an NVMEof[1] target and initiator then run fio normally on the
> initiator.
>
> Logan
>
> [1] https://community.mellanox.com/docs/DOC-2504?forceNoRedirect=3Dtrue
>
> Dictated, not read.
>
> ------ Original message------
> *From: *Sitsofe Wheeler
> *Date: *Sat, Mar 17, 2018 02:48
> *To: *Jens Axboe;
> *Cc: *Kip Ingram;fio@vger.kernel.org;Stephen Bates;logang@deltatee.com;
> *Subject:*Re: FIO's rdma engine...
>
> On 23 January 2018 at 17:50, Jens Axboe  wrote:> On 1/23/18 10:48 AM, Kip=
 Ingram wrote:>> Hi Jens.  I'm trying to do some NVME over IB testing, and =
it seemed>> appropriate to use the rdma engine in FIO.  However, it's compl=
aining>> in various ways:>>>> 1. It says I have to specify the device size.=
  That's not a>> show-stopper, but it surprised me.>> 2. It says I have to =
use either read or write traffic - not mixed.>> That is a problem.>> 3. It =
says I can't use random addressing.  That's also a problem.>>>> Colleagues =
have set up devices this way and used one of our internal>> tools to do mix=
ed and random traffic.>>>> I don't see anything in the documents that imply=
 mixed and random>> shouldn't work - is there something I'm overlooking?>> =
CC'ing the fio list, please direct questions there and not to me> directly.=
CC'ing some RDMA folks.-- Sitsofe | http://sucs.org/~sits/
>
>

--94eb2c05dd8ec54beb0567a520aa
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi guys.=C2=A0 Yes, I did realize that after not very much=
 wheel spinning.=C2=A0 I wound up using libaio, and immediately got my stor=
age box to its performance envelope.=C2=A0 There cheers to fio - it&#39;s a=
 great tool.</div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote"=
>On Sat, Mar 17, 2018 at 12:57 PM, <a href=3D"mailto:lsgunthorpe@gmail.com"=
>lsgunthorpe@gmail.com</a> <span dir=3D"ltr">&lt;<a href=3D"mailto:lsguntho=
rpe@gmail.com" target=3D"_blank">lsgunthorpe@gmail.com</a>&gt;</span> wrote=
:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-le=
ft:1px #ccc solid;padding-left:1ex">






<div style=3D"margin-bottom:45px">
    <div style=3D"font-size:10pt">    <div style=3D"font-size:10pt" dir=3D"=
ltr"><div dir=3D"ltr" style=3D"margin-top:0;margin-bottom:0">Hi Kip,</div><=
div dir=3D"ltr" style=3D"margin-top:0;margin-bottom:0"><br></div><div dir=
=3D"ltr" style=3D"margin-top:0;margin-bottom:0">The RDMA engine in FIO was =
designed to measure the performance of RDMA links similar to the perftest t=
ool set.=C2=A0</div><div dir=3D"ltr" style=3D"margin-top:0;margin-bottom:0"=
><br></div><div dir=3D"ltr" style=3D"margin-top:0;margin-bottom:0">It does =
not test a block device at all. If I remember correctly &#39;rw&#39; specif=
ies whether the instance running is a client or server and the &#39;verb&#3=
9; attribute specifies whether you are reading, writing, sending or recving=
. &#39;size&#39; is required to specify the length of the test.</div><div d=
ir=3D"ltr" style=3D"margin-top:0;margin-bottom:0"><br></div><div dir=3D"ltr=
" style=3D"margin-top:0;margin-bottom:0">So it doesn&#39;t sound like it&#3=
9;s what you are looking for. I&#39;d suggest setting up an NVMEof[1] targe=
t and initiator then run fio normally on the initiator.</div><div dir=3D"lt=
r" style=3D"margin-top:0;margin-bottom:0"><br></div><div dir=3D"ltr" style=
=3D"margin-top:0;margin-bottom:0">Logan</div><div dir=3D"ltr" style=3D"marg=
in-top:0;margin-bottom:0"><br></div><div dir=3D"ltr" style=3D"margin-top:0;=
margin-bottom:0">[1]=C2=A0<a href=3D"https://community.mellanox.com/docs/DO=
C-2504?forceNoRedirect=3Dtrue" target=3D"_blank">https://community.<wbr>mel=
lanox.com/docs/DOC-2504?<wbr>forceNoRedirect=3Dtrue</a></div><div dir=3D"lt=
r" style=3D"margin-top:0;margin-bottom:0"><br></div><div id=3D"m_3317133722=
323892199SignatureBox" dir=3D"ltr" style=3D"margin-top:0;margin-bottom:0"><=
div dir=3D"ltr" style=3D"margin-top:0;margin-bottom:0;font-size:9pt;font-st=
yle:italic">Dictated, not read.</div></div></div><div style=3D"font-size:10=
pt" dir=3D"ltr"><div id=3D"m_3317133722323892199LGEmailHeader" dir=3D"ltr" =
style=3D"margin-top:0;margin-bottom:0"><div dir=3D"ltr" style=3D"margin-top=
:0;margin-bottom:0"><br></div><div dir=3D"ltr" style=3D"margin-top:0;margin=
-bottom:0">------ Original message------</div><div dir=3D"ltr" style=3D"mar=
gin-top:0;margin-bottom:0"><b>From: </b>Sitsofe Wheeler<u></u><u></u></div>=
<div dir=3D"ltr" style=3D"margin-top:0;margin-bottom:0"><b>Date: </b>Sat, M=
ar 17, 2018 02:48</div><div dir=3D"ltr" style=3D"margin-top:0;margin-bottom=
:0"><b>To: </b>Jens Axboe;</div><div dir=3D"ltr" style=3D"margin-top:0;marg=
in-bottom:0"><b>Cc: </b>Kip Ingram<a href=3D"mailto:;fio@vger.kernel.org" t=
arget=3D"_blank">;fio@vger.kernel.org</a>;<wbr>Stephen Bates<a href=3D"mail=
to:;logang@deltatee.com" target=3D"_blank">;logang@deltatee.com</a>;</div><=
div dir=3D"ltr" style=3D"margin-top:0;margin-bottom:0"><b>Subject:</b>Re: F=
IO&#39;s rdma engine...</div><div dir=3D"ltr" style=3D"margin-top:0;margin-=
bottom:0"><br></div></div><pre>On 23 January 2018 at 17:50, Jens Axboe <u><=
/u> wrote:&gt; On 1/23/18 10:48 AM, Kip Ingram wrote:&gt;&gt; Hi Jens.  I&#=
39;m trying to do some NVME over IB testing, and it seemed&gt;&gt; appropri=
ate to use the rdma engine in FIO.  However, it&#39;s complaining&gt;&gt; i=
n various ways:&gt;&gt;&gt;&gt; 1. It says I have to specify the device siz=
e.  That&#39;s not a&gt;&gt; show-stopper, but it surprised me.&gt;&gt; 2. =
It says I have to use either read or write traffic - not mixed.&gt;&gt; Tha=
t is a problem.&gt;&gt; 3. It says I can&#39;t use random addressing.  That=
&#39;s also a problem.&gt;&gt;&gt;&gt; Colleagues have set up devices this =
way and used one of our internal&gt;&gt; tools to do mixed and random traff=
ic.&gt;&gt;&gt;&gt; I don&#39;t see anything in the documents that imply mi=
xed and random&gt;&gt; shouldn&#39;t work - is there something I&#39;m over=
looking?&gt;&gt; CC&#39;ing the fio list, please direct questions there and=
 not to me&gt; <a href=3D"http://directly.CC" target=3D"_blank">directly.CC=
</a>&#39;ing some RDMA folks.-- Sitsofe | <a href=3D"http://sucs.org/~sits/=
" target=3D"_blank">http://sucs.org/~sits/</a><u></u></pre></div></div>


</div></blockquote></div><br></div>

--94eb2c05dd8ec54beb0567a520aa--

