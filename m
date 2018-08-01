Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f182.google.com ([209.85.217.182]:32969 "EHLO
        mail-ua0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387856AbeHALD6 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 1 Aug 2018 07:03:58 -0400
Received: by mail-ua0-f182.google.com with SMTP id i4-v6so12227308uak.0
        for <fio@vger.kernel.org>; Wed, 01 Aug 2018 02:19:10 -0700 (PDT)
MIME-Version: 1.0
References: <CAKTzs3R0S8q=tCkNZ99xqpJpjcAjDCphdSV_GvBbGKRA3GWOUw@mail.gmail.com>
 <CAB-428kzrUriC9SKetP+YJRdFefQRv0-=DVfeMyyFOiXim8svA@mail.gmail.com> <CALjAwxhYwwTZwb25uo6g8WZmQO3zTprjQr4ztvmdpKei-NEVRA@mail.gmail.com>
In-Reply-To: <CALjAwxhYwwTZwb25uo6g8WZmQO3zTprjQr4ztvmdpKei-NEVRA@mail.gmail.com>
From: Alireza Haghdoost <haghdoost@gmail.com>
Date: Wed, 1 Aug 2018 04:18:58 -0500
Message-ID: <CAB-428=uXP5L5AMrEq0ERRdOwFsRsnVw_vzJve8=S2VndgpCDg@mail.gmail.com>
Subject: Re: get err 5
Content-Type: multipart/alternative; boundary="000000000000e1d31f05725c2ff0"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>, =?UTF-8?B?2KLYsdi0INiu2KfZiNix24wg2LHYp9iv?= <arash.khavary@gmail.com>

--000000000000e1d31f05725c2ff0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 1, 2018 at 1:51 AM Sitsofe Wheeler <sitsofe@gmail.com> wrote:

> On 1 August 2018 at 07:39, Alireza Haghdoost <haghdoost@gmail.com> wrote:
> > Your jobs step on the foot of each other. You can=E2=80=99t write with =
multiple
> > process on the same LBA of a LUN on the same time. That is why you get
> error
> > 5 because one thread is writting an LBA and another thread modify if at
> the
> > same time. In this case either one can get unknown result.
>
> I agree with part of this statement (unknown result in the LBA) but
> I'm doubtful it would cause an error message of "I/O error". Disks
> definitely do accept simultaneous write I/Os against the same LBA but
> the problem becomes that in most cases the end result as to which data
> the LBA will contain is undefined. It's not illegal (in the sense that
> nothing prevents and nothing will error) it's just bad from a data
> integrity perspective (and since this wasn't a verify job...).



> I agree that it is not is not a felony two write on the same lba with
multiple threads.

Not sure what kind of storage device is used in this experience but some
storage devices *do* Lock a sector/chunk while it is being written. It
means the second in-inflight write hitting the same LBA/chunk will wait for
the first one.
Do the math to find out in this job file how many of these big in-flight
write the system can handle before it times-out the last one in the queue.

Now, does it cause err 5? I don=E2=80=99t know for sure. However. This is y=
et
another reason that might cause it.

--000000000000e1d31f05725c2ff0
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div><br></div><div><br><div class=3D"gmail_quote"><div dir=3D"ltr">On Wed,=
 Aug 1, 2018 at 1:51 AM Sitsofe Wheeler &lt;<a href=3D"mailto:sitsofe@gmail=
.com">sitsofe@gmail.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_=
quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1=
ex">On 1 August 2018 at 07:39, Alireza Haghdoost &lt;<a href=3D"mailto:hagh=
doost@gmail.com" target=3D"_blank">haghdoost@gmail.com</a>&gt; wrote:<br>
&gt; Your jobs step on the foot of each other. You can=E2=80=99t write with=
 multiple<br>
&gt; process on the same LBA of a LUN on the same time. That is why you get=
 error<br>
&gt; 5 because one thread is writting an LBA and another thread modify if a=
t the<br>
&gt; same time. In this case either one can get unknown result.<br>
<br>
I agree with part of this statement (unknown result in the LBA) but<br>
I&#39;m doubtful it would cause an error message of &quot;I/O error&quot;. =
Disks<br>
definitely do accept simultaneous write I/Os against the same LBA but<br>
the problem becomes that in most cases the end result as to which data<br>
the LBA will contain is undefined. It&#39;s not illegal (in the sense that<=
br>
nothing prevents and nothing will error) it&#39;s just bad from a data<br>
integrity perspective (and since this wasn&#39;t a verify job...).</blockqu=
ote><div dir=3D"auto"><br></div><blockquote class=3D"gmail_quote" style=3D"=
margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><br></blockq=
uote><div dir=3D"auto">I agree that it is not is not a felony two write on =
the same lba with multiple threads.=C2=A0</div><div dir=3D"auto"><br></div>=
<div dir=3D"auto">Not sure what kind of storage device is used in this expe=
rience but some storage devices *do* Lock a sector/chunk while it is being =
written. It means the second in-inflight write hitting the same LBA/chunk w=
ill wait for the first one.=C2=A0</div><div dir=3D"auto">Do the math to fin=
d out in this job file how many of these big in-flight write the system can=
 handle before it times-out the last one in the queue.</div><div dir=3D"aut=
o"><br></div><div dir=3D"auto">Now, does it cause err 5? I don=E2=80=99t kn=
ow for sure. However. This is yet another reason that might cause it.</div>=
<div dir=3D"auto"><br></div><div dir=3D"auto"><br></div></div></div>

--000000000000e1d31f05725c2ff0--
