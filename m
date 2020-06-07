Return-Path: <kumarjain10@gmail.com>
MIME-Version: 1.0
References: <CAFsSD_XNL1iA7LT1ChdL0ZFRT+_6TV9N+VerbTEJFYOvs4ZYXg@mail.gmail.com>
 <818b44df-741d-dfc6-6a1f-479b11ab556a@kernel.dk>
In-Reply-To: <818b44df-741d-dfc6-6a1f-479b11ab556a@kernel.dk>
From: harshit jain <kumarjain10@gmail.com>
Date: Sun, 7 Jun 2020 13:55:44 +0530
Message-ID: <CAFsSD_WNagn2tA97NXOBXrGA0gwVWBK8vcBUJkY_zjPurBtHHQ@mail.gmail.com>
Subject: Re: Sequential profile in FIO 3.7 in linux CentOS 7
Content-Type: multipart/alternative; boundary="00000000000058019005a77a3ea2"
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

--00000000000058019005a77a3ea2
Content-Type: text/plain; charset="UTF-8"

Thank you Jens Axobe for the help.

Well, after using the options you mentioned, the writes and reads to the
NVMe SSD are indeed sequential but it seems the tool is writing the entire
disk size and then reading it back.

Also I could see the writes are being issued to multiple sectors in one IO
transaction instead of single sector/LBA. Is this kind of fine tuning
possible to configure in FIO?

Basically I wanted the writes on particular sector to be followed by read
but one sector at a time.

Also is it possible to avoid the initial disk reads, I think it might be
happening due to file open and close every time I run the fio job.

Thanks and regards,
Harshit


On Fri, Jun 5, 2020, 6:32 PM Jens Axboe <axboe@kernel.dk> wrote:

> On 6/5/20 12:52 AM, harshit jain wrote:
> > Hi Jen's,
> >
> > I need help in creating an I/O profile wherein the LBA access are
> > sequential. Basically is it possible to create a profile wherein the
> > LBA pattern is write on LBA 0 followed by read on LBA 0 immediately
> > and so on?
> >
> > I am trying to generate the below mentioned sequence
> >
> > Write LBA0
> > Read LBA0
> >
> > Write LBA1
> > Read LBA1
> >
> > Write LBAn
> > Read LBAn
> >
> > And so on till all LBA sectors is covered.
> >
> > Any pointers would be much appreciated.
>
> Please send general queries etc to the mailing list, I've CC'ed it.
>
> For this use case, I'd just do a verify workload with a backlog of 1.
> That means that after 1 write, we'll verify it.
>
> rw=write
>
> verify=crc32c
>
> verify_backlog=1
>
>
> --
> Jens Axboe
>
>

--00000000000058019005a77a3ea2
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><div>Thank you Jens Axobe for the help.=C2=A0<div dir=3D"=
auto"><br></div><div dir=3D"auto">Well, after using the options you mention=
ed, the writes and reads to the NVMe SSD are indeed sequential but it seems=
 the tool is writing the entire disk size and then reading it back.</div><d=
iv dir=3D"auto"><br></div><div dir=3D"auto">Also I could see the writes are=
 being issued to multiple sectors in one IO transaction instead of single s=
ector/LBA. Is this kind of fine tuning possible to configure in FIO?</div><=
div dir=3D"auto"><br></div><div dir=3D"auto">Basically I wanted the writes =
on particular sector to be followed by read but one sector at a time.</div>=
<div dir=3D"auto"><br></div><div dir=3D"auto">Also is it possible to avoid =
the initial disk reads, I think it might be happening due to file open and =
close every time I run the fio job.=C2=A0</div><div dir=3D"auto"><br></div>=
<div dir=3D"auto">Thanks and=C2=A0regards,</div><div dir=3D"auto">Harshit</=
div><br><br><div class=3D"gmail_quote"><div dir=3D"ltr" class=3D"gmail_attr=
">On Fri, Jun 5, 2020, 6:32 PM Jens Axboe &lt;<a href=3D"mailto:axboe@kerne=
l.dk">axboe@kernel.dk</a>&gt; wrote:<br></div><blockquote class=3D"gmail_qu=
ote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex=
">On 6/5/20 12:52 AM, harshit jain wrote:<br>
&gt; Hi Jen&#39;s,<br>
&gt; <br>
&gt; I need help in creating an I/O profile wherein the LBA access are<br>
&gt; sequential. Basically is it possible to create a profile wherein the<b=
r>
&gt; LBA pattern is write on LBA 0 followed by read on LBA 0 immediately<br=
>
&gt; and so on?<br>
&gt; <br>
&gt; I am trying to generate the below mentioned sequence<br>
&gt; <br>
&gt; Write LBA0<br>
&gt; Read LBA0<br>
&gt; <br>
&gt; Write LBA1<br>
&gt; Read LBA1<br>
&gt; <br>
&gt; Write LBAn<br>
&gt; Read LBAn<br>
&gt; <br>
&gt; And so on till all LBA sectors is covered.<br>
&gt; <br>
&gt; Any pointers would be much appreciated.<br>
<br>
Please send general queries etc to the mailing list, I&#39;ve CC&#39;ed it.=
<br>
<br>
For this use case, I&#39;d just do a verify workload with a backlog of 1.<b=
r>
That means that after 1 write, we&#39;ll verify it.<br>
<br>
rw=3Dwrite=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 <br>
verify=3Dcrc32c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0<br>
verify_backlog=3D1=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 <br>
<br>
-- <br>
Jens Axboe<br>
<br>
</blockquote></div></div></div>

--00000000000058019005a77a3ea2--

