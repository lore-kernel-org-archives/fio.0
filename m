Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f169.google.com ([209.85.217.169]:34021 "EHLO
        mail-ua0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbeG2Vwu (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 29 Jul 2018 17:52:50 -0400
Received: by mail-ua0-f169.google.com with SMTP id r10-v6so6533102uao.1
        for <fio@vger.kernel.org>; Sun, 29 Jul 2018 13:21:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANyP7Cj4hNtq5aeQ-h1L3ZtyBch0GDfab+4E2cChnKJTwjYsLg@mail.gmail.com>
References: <CANyP7Cj4hNtq5aeQ-h1L3ZtyBch0GDfab+4E2cChnKJTwjYsLg@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sun, 29 Jul 2018 21:20:37 +0100
Message-ID: <CALjAwxgo0gYvmitK0GvLiYLQZvMAK2UeUJRAvWdVTrbmtioD0g@mail.gmail.com>
Subject: Re: What exactly is iodepth in fio?
Content-Type: multipart/alternative; boundary="000000000000c5d37005722915f8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeevan Patnaik <g1patnaik@gmail.com>
Cc: fio <fio@vger.kernel.org>

--000000000000c5d37005722915f8
Content-Type: text/plain; charset="UTF-8"

Hi,

On 28 July 2018 at 14:26, Jeevan Patnaik <g1patnaik@gmail.com> wrote:

> Hi,
>
> Is Iodepth of fio and queue depth of storage both same? Then, how is it
> possible to control queue depth with an iodepth parameter from fio
>
fio iodepth and the depth I/O your OS achieves submitting I/O down to
storage are linked but most certainly do not have to be the same and the
relationship is highly dependent on your operating system/storage/fio
ioengine used/fio parameters. Basically fio submits I/O a particular way to
your operating system. Depending on how you submit your I/O to your
operating system it can choose to submit it further down in a more
optimal/different fashion (e.g. by batching requests together, breaking
requests that are too big into smaller pieces, delaying I/O etc).
Additionally and as stated in the HOWTO (
http://fio.readthedocs.io/en/latest/fio_man.html#cmdoption-arg-iodepth ),
iodepth only affects asynchronous ioengines (and note that text includes
warnings about the need to use direct=1 on Linux).

command? Will that be creating parallel jobs, but then again there is an
> option to run jobs in parallel also (will that not be a trivial or
> conflicting?)
>
I'm going to give a brief summary but note I'm not trying to cover
caching/readahead/plugging/block device layers (e.g. RAID/LVM) etc:

A synchronous fio I/O engine submits a single I/O to the OS, waits for it
to be "acknowledged" as having been received and then sends another I/O
etc.

If an fio I/O engine is able to submit I/O to the OS in a truly
asynchronous fashion (see link above) then the key is that it does NOT have
to wait for earlier I/O to be "acknowledged" before submitting new I/O. If
the iodepth is only 1 it will have to behave in a fashion similar to a
synchronous I/O engine. However, let's say a jobs specifies an iodepth of
32. In that case up to 32 I/Os to be outstanding before fio will choose to
wait before submitting any more I/O (just what the watermarks are and how
much is submitted at a time is controlled by the iodepth_batch_* options.
This can be more efficient and achieve higher throughputs but often comes
with a cost of higher latency.

fio will not create parallel *fio jobs* just because of iodepth BUT
using parallel fio jobs is another way of increasing the amount of
simultaneous I/O being submitted at any given time (by using different
threads/processes) and using both on the same device will act in tandem (so
if you have two fio jobs submitting asynchronous I/O at an iodepth of 16
each your OS could be be actually receiving 32 I/Os at any given time).
There can be reasons for combining the two (e.g. you have multiple devices
and they are so fast that one CPU can't keep up even when submitting I/O
asynchronously).

> I am struggling to understand how fio is controlling it's workloads
> (especially about this iodepth). Can someone please explain the iodepth
> parameter in detail.
>
I will note you've also asked this question over on stackexchange (
https://unix.stackexchange.com/questions/459045/what-exactly-is-iodepth-in-fio
). You may want to link to https://www.spinics.net/lists/fio/msg07190.html
from there to help others who may have a similar question...

-- 
Sitsofe | http://sucs.org/~sits/

--000000000000c5d37005722915f8
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<div class=3D"gmail_extra"><br><div class=3D"gmail_quot=
e">On 28 July 2018 at 14:26, Jeevan Patnaik <span dir=3D"ltr">&lt;<a href=
=3D"mailto:g1patnaik@gmail.com" target=3D"_blank">g1patnaik@gmail.com</a>&g=
t;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0px 0=
px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex"><div =
dir=3D"ltr">

<p style=3D"margin:0px 0px 1em;padding:0px;border:0px;font-variant-numeric:=
inherit;font-variant-east-asian:inherit;font-stretch:inherit;line-height:in=
herit;font-family:Arial,&quot;Helvetica Neue&quot;,Helvetica,sans-serif;fon=
t-size:15px;vertical-align:baseline;box-sizing:inherit;clear:both;color:rgb=
(36,39,41);text-align:left;text-decoration-style:initial;text-decoration-co=
lor:initial">Hi,</p><p style=3D"margin:0px 0px 1em;padding:0px;border:0px;f=
ont-variant-numeric:inherit;font-variant-east-asian:inherit;font-stretch:in=
herit;line-height:inherit;font-family:Arial,&quot;Helvetica Neue&quot;,Helv=
etica,sans-serif;font-size:15px;vertical-align:baseline;box-sizing:inherit;=
clear:both;color:rgb(36,39,41);text-align:left;text-decoration-style:initia=
l;text-decoration-color:initial">Is Iodepth of fio and queue depth of stora=
ge both same? Then, how is it possible to control queue depth with an iodep=
th parameter from fio</p></div></blockquote><div>fio iodepth and the de<spa=
n style=3D"font-size:small;background-color:rgb(255,255,255);text-decoratio=
n-style:initial;text-decoration-color:initial;float:none;display:inline">pt=
h I/O your OS achieves submitting I/O down to storage are linked but most c=
ertainly do not have to be the same and=C2=A0</span>the relationshi<span st=
yle=3D"font-size:small;background-color:rgb(255,255,255);text-decoration-st=
yle:initial;text-decoration-color:initial;float:none;display:inline">p is=
=C2=A0</span>highly dependent on your operating system/storage/fio ioengine=
 used/fio parameters. Basically fio submits I/O a=C2=A0particular way to yo=
ur operating system. Depending on how you submit your I/O to your operating=
 system it can choose to submit it further down in a more optimal/different=
 fashion (e.g. by batching requests together, breaking requests that are to=
o big into smaller=C2=A0pieces, delaying I/O etc). Additionally and as stat=
ed in the HOWTO (<span style=3D"font-size:small;background-color:rgb(255,25=
5,255);text-decoration-style:initial;text-decoration-color:initial;float:no=
ne;display:inline"><a href=3D"http://fio.readthedocs.io/en/latest/fio_man.h=
tml#cmdoption-arg-iodepth">http://fio.readthedocs.io/en/latest/fio_man.html=
#cmdoption-arg-iodepth</a></span> ), iodepth only affects asynchronous ioen=
gines<span style=3D"font-size:small;background-color:rgb(255,255,255);text-=
decoration-style:initial;text-decoration-color:initial;float:none;display:i=
nline">=C2=A0(and note that text includes warnings about the need to use di=
rect=3D1 on Linux).</span><br><br></div><blockquote class=3D"gmail_quote" s=
tyle=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);pad=
ding-left:1ex"><div dir=3D"ltr"><p style=3D"margin:0px 0px 1em;padding:0px;=
border:0px;font-variant-numeric:inherit;font-variant-east-asian:inherit;fon=
t-stretch:inherit;line-height:inherit;font-family:Arial,&quot;Helvetica Neu=
e&quot;,Helvetica,sans-serif;font-size:15px;vertical-align:baseline;box-siz=
ing:inherit;clear:both;color:rgb(36,39,41);text-align:left;text-decoration-=
style:initial;text-decoration-color:initial">command? Will that be creating=
 parallel jobs, but then again there is an option to run jobs in parallel a=
lso (will that not be a trivial or conflicting?)</p></div></blockquote><div=
><span style=3D"font-size:small;background-color:rgb(255,255,255);text-deco=
ration-style:initial;text-decoration-color:initial;float:none;display:inlin=
e">I&#39;m going to give a brief summary but note I&#39;m not trying to cov=
er caching/readahead/plugging/block device layers (e.g. RAID/LVM) etc:</spa=
n><br></div><div><br></div><div>A synchronous fio I/O engine=C2=A0<span sty=
le=3D"font-size:small;background-color:rgb(255,255,255);text-decoration-sty=
le:initial;text-decoration-color:initial;float:none;display:inline">submits=
 a single I/O to the OS, waits for it to be &quot;acknowledged&quot; as hav=
ing been received and then sends another I/O etc.=C2=A0</span></div><div><b=
r></div><div>If an fio I/O engine is able to submit I/O to the OS in a trul=
y asynchronous fashion (see link above) then the key is that it does NOT ha=
ve to wait for earlier I/O to be &quot;acknowledged&quot; before submitting=
 new I/O. If the iodepth is only 1 it will have to behave in a fashion simi=
lar to a synchronous I/O engine. However, let&#39;s say a jobs specifies an=
=C2=A0iodepth of 32. In that case up to 32 I/Os to be outstanding before fi=
o will choose to wait before submitting any more I/O (just what the waterma=
rks are and how much is submitted at a time is controlled by the=C2=A0iodep=
th_batch_* options. This can be more efficient and achieve higher throughpu=
ts but often comes with a cost of higher latency.</div><div><br></div><div>=
<span style=3D"font-size:small;background-color:rgb(255,255,255);text-decor=
ation-style:initial;text-decoration-color:initial;float:none;display:inline=
">fio will not create=C2=A0parallel *fio jobs* just because of iodepth BUT =
using=C2=A0parallel fio jobs is another way of increasing the amount of=C2=
=A0</span><span style=3D"font-size:small;text-decoration-style:initial;text=
-decoration-color:initial;background-color:rgb(255,255,255);float:none;disp=
lay:inline">simultaneous</span><span style=3D"font-size:small;background-co=
lor:rgb(255,255,255);text-decoration-style:initial;text-decoration-color:in=
itial;float:none;display:inline"><span>=C2=A0</span>I/O being submitted at =
any given time (by using different threads/processes) and using both on the=
 same device will act in tandem (so if you have two fio jobs submitting asy=
nchronous I/O at an<span>=C2=A0</span></span><span style=3D"font-size:small=
;text-decoration-style:initial;text-decoration-color:initial;background-col=
or:rgb(255,255,255);float:none;display:inline">iodepth of 16 each your OS c=
ould be be actually receiving 32 I/Os at any given time). There can be reas=
ons for combining the two (e.g. you have multi<span style=3D"text-decoratio=
n-style:initial;text-decoration-color:initial;float:none;display:inline">pl=
e</span>=C2=A0devices and they are so fast that one CPU can&#39;t kee<span =
style=3D"text-decoration-style:initial;text-decoration-color:initial;float:=
none;display:inline">p u<span style=3D"font-size:small;background-color:rgb=
(255,255,255);text-decoration-style:initial;text-decoration-color:initial;f=
loat:none;display:inline">p even when submitting I/O asynchronously).</span=
></span></span><br></div><blockquote class=3D"gmail_quote" style=3D"margin:=
0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">=
<div dir=3D"ltr"><p style=3D"margin:0px 0px 1em;padding:0px;border:0px;font=
-variant-numeric:inherit;font-variant-east-asian:inherit;font-stretch:inher=
it;line-height:inherit;font-family:Arial,&quot;Helvetica Neue&quot;,Helveti=
ca,sans-serif;font-size:15px;vertical-align:baseline;box-sizing:inherit;cle=
ar:both;color:rgb(36,39,41);text-align:left;text-decoration-style:initial;t=
ext-decoration-color:initial"></p><p style=3D"margin:0px 0px 1em;padding:0p=
x;border:0px;font-variant-numeric:inherit;font-variant-east-asian:inherit;f=
ont-stretch:inherit;line-height:inherit;font-family:Arial,&quot;Helvetica N=
eue&quot;,Helvetica,sans-serif;font-size:15px;vertical-align:baseline;box-s=
izing:inherit;clear:both;color:rgb(36,39,41);text-align:left;text-decoratio=
n-style:initial;text-decoration-color:initial">I am struggling to understan=
d how fio is controlling it&#39;s workloads (especially about this iodepth)=
. Can someone please explain the iodepth parameter in detail.</p></div></bl=
ockquote><div>I will note you&#39;ve also asked this question over on stack=
exchange (<a href=3D"https://unix.stackexchange.com/questions/459045/what-e=
xactly-is-iodepth-in-fio">https://unix.stackexchange.com/questions/459045/w=
hat-exactly-is-iodepth-in-fio</a> ). You may want to link to=C2=A0<a href=
=3D"https://www.spinics.net/lists/fio/msg07190.html">https://www.spinics.ne=
t/lists/fio/msg07190.html</a> from there to help others who may have a simi=
lar question...</div></div><div><br></div>-- <br><div class=3D"gmail_signat=
ure">Sitsofe | <a href=3D"http://sucs.org/~sits/" target=3D"_blank">http://=
sucs.org/~sits/</a></div>
</div></div>

--000000000000c5d37005722915f8--
