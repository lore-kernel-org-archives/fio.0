Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:36176 "EHLO
        mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729781AbeHAWQ6 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 1 Aug 2018 18:16:58 -0400
Received: by mail-vk0-f48.google.com with SMTP id y9-v6so9957812vky.3
        for <fio@vger.kernel.org>; Wed, 01 Aug 2018 13:29:26 -0700 (PDT)
MIME-Version: 1.0
References: <CANvN+ekqnT6YZ2LHPMzbF5hX4kSy+Tog9=8_+hoG+pz+JOrxsw@mail.gmail.com>
 <CALjAwxi5b_Zd74VQkxnu4M_sEpLPOHXVs9PUojzypLoTSw=4ag@mail.gmail.com>
In-Reply-To: <CALjAwxi5b_Zd74VQkxnu4M_sEpLPOHXVs9PUojzypLoTSw=4ag@mail.gmail.com>
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Wed, 1 Aug 2018 23:29:11 +0300
Message-ID: <CANvN+ekRKJ6r+bHpuHVzhunHn43=iY5abdxRKo4nUjrA7Fg72g@mail.gmail.com>
Subject: Re: Multi-threaded verification in the partitiioned device case
Content-Type: multipart/alternative; boundary="000000000000f45c150572658cff"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>

--000000000000f45c150572658cff
Content-Type: text/plain; charset="UTF-8"

On Wed, Aug 1, 2018, 21:44 Sitsofe Wheeler <sitsofe@gmail.com> wrote:

> Hi,
>
> On 1 August 2018 at 18:06, Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
> wrote:
> > As far as I understand, verification in the multi-threaded (num_jobs > 1)
> > case is neither supported nor recommended.
> >
> > I wonder if it also holds for the case of a multiple-threaded job being
> run
> > against a partitioned (using FIO's offset split machinery) device, with
> > thread per partition. Partitioning like this should very much avoid  any
> > inter-thread overlap, and seems to be safe to run in verify mode. I will
> > appreciate a comment on whether the simple reasoning above holds, or
> > something extra still needs to be done.
>
> If you can arrange for each "numjob" to write only to a region not
> touched by any other numjob/job then you can get a meaningful result.
> For example when fio is generating unique files for each numjob by
> itself there shouldn't be any problem (or warning). I guess another
> example would be using filename so all numjobs are using the same file
> but also using offset_increment
> (
> http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-offset-increment
> ) and an appropriate size together...
>

Yes, that's exactly what I meant by partitioning above. I also hope
verification doesn't depend in the random map, since otherwise in this case
one would have to take care of the map accesses to be atomic (presumably,
with offset_increment being properly aligned).

Thanks,
Andrey

>
> --
> Sitsofe | http://sucs.org/~sits/
>
-- 

Regards,
Andrey

--000000000000f45c150572658cff
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<br><br><div class=3D"gmail_quote"><div dir=3D"ltr">On Wed, Aug 1, 2018, 21=
:44 Sitsofe Wheeler &lt;<a href=3D"mailto:sitsofe@gmail.com">sitsofe@gmail.=
com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"marg=
in:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">Hi,<br>
<br>
On 1 August 2018 at 18:06, Andrey Kuzmin &lt;<a href=3D"mailto:andrey.v.kuz=
min@gmail.com" target=3D"_blank">andrey.v.kuzmin@gmail.com</a>&gt; wrote:<b=
r>
&gt; As far as I understand, verification in the multi-threaded (num_jobs &=
gt; 1)<br>
&gt; case is neither supported nor recommended.<br>
&gt;<br>
&gt; I wonder if it also holds for the case of a multiple-threaded job bein=
g run<br>
&gt; against a partitioned (using FIO&#39;s offset split machinery) device,=
 with<br>
&gt; thread per partition. Partitioning like this should very much avoid=C2=
=A0 any<br>
&gt; inter-thread overlap, and seems to be safe to run in verify mode. I wi=
ll<br>
&gt; appreciate a comment on whether the simple reasoning above holds, or<b=
r>
&gt; something extra still needs to be done.<br>
<br>
If you can arrange for each &quot;numjob&quot; to write only to a region no=
t<br>
touched by any other numjob/job then you can get a meaningful result.<br>
For example when fio is generating unique files for each numjob by<br>
itself there shouldn&#39;t be any problem (or warning). I guess another<br>
example would be using filename so all numjobs are using the same file<br>
but also using offset_increment<br>
(<a href=3D"http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-=
offset-increment" rel=3D"noreferrer" target=3D"_blank">http://fio.readthedo=
cs.io/en/latest/fio_doc.html#cmdoption-arg-offset-increment</a><br>
) and an appropriate size together...<br></blockquote></div><div><br></div>=
<div class=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"margi=
n:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"></blockquote></di=
v><div>Yes, that&#39;s exactly what I meant by partitioning above. I also h=
ope verification doesn&#39;t depend in the random map, since otherwise in t=
his case one would have to take care of the map accesses to be atomic (pres=
umably, with offset_increment being properly aligned).</div><div><br></div>=
<div>Thanks,</div><div>Andrey</div><div class=3D"gmail_quote"><blockquote c=
lass=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;=
padding-left:1ex">
<br>
-- <br>
Sitsofe | <a href=3D"http://sucs.org/~sits/" rel=3D"noreferrer" target=3D"_=
blank">http://sucs.org/~sits/</a><br>
</blockquote></div>-- <br><div dir=3D"ltr" class=3D"gmail_signature" data-s=
martmail=3D"gmail_signature"><p dir=3D"ltr">Regards,<br>
Andrey</p>
</div>

--000000000000f45c150572658cff--
