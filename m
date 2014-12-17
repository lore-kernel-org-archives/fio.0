Return-Path: <sendtold@gmail.com>
MIME-Version: 1.0
In-Reply-To: <5491EC80.7060004@kernel.dk>
References: <CAEyTGCfBk71jx-S-Qy=zxob+eZC+TRbx6xFr3NF-zEwKM0rp3w@mail.gmail.com>
	<5491EC80.7060004@kernel.dk>
Date: Wed, 17 Dec 2014 17:44:11 -0600
Message-ID: <CAEyTGCd4amTU9w7GcRY+Lz9ZFfhUaGqNTw0+-tYtTGH+Bv=CHg@mail.gmail.com>
Subject: Re: Huge eta with Read/Write Mix Job and job hangs
From: Lakshmi <sendtold@gmail.com>
Content-Type: multipart/alternative; boundary=e89a8f2351eb6c474d050a720d78
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

--e89a8f2351eb6c474d050a720d78
Content-Type: text/plain; charset=UTF-8

Hi Jens,
 I am using the latest version 2.1.10 .

Thanks

On Wed, Dec 17, 2014 at 2:50 PM, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 12/17/2014 01:22 PM, Lakshmi wrote:
> > Hi Jens,
> >   I am using the below job file, and this works fine when the numjobs is
> > less(ex: 5,10) however when I specify a huge numjobs , the job hangs and
> > shows a huge eta as shown in the attached figure.
> >
> > When I just run a 100% Reads (71K) or 100% writes(20K) separately  with
> > the below below parameters it works fine, but it is only when i do a mix
> > of reads and writes.
> >
> > Any idea what is going on and if i am missing something?
> > OS:RHEL7
> > HDDs(sdf):2x300GB Hdds on RAID10
> >
> > [test]
> >  name=test
> >  ioengine=posixaio
> >  invalidate=1
> >  iodepth=32
> >  bs=71K,20K
> >  group_reporting=1
> >  rw=randrw
> >  rwmixread=96
> >  rwmixwrite=4
> >  direct=1
> >  buffered=0
> >  size=1M
> >  time_based
> >  runtime=300
> >  filename=/dev/sdf
> >  numjobs=64
>
> Doesn't reproduce here. Please update to the latest fio version and see
> if it still reproduce, before I spend any time looking at this.
>
> --
> Jens Axboe
>
>

--e89a8f2351eb6c474d050a720d78
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div>Hi Jens,<br></div>=C2=A0I am using the latest ve=
rsion 2.1.10 .<br><br></div>Thanks<br></div><div class=3D"gmail_extra"><br>=
<div class=3D"gmail_quote">On Wed, Dec 17, 2014 at 2:50 PM, Jens Axboe <spa=
n dir=3D"ltr">&lt;<a href=3D"mailto:axboe@kernel.dk" target=3D"_blank">axbo=
e@kernel.dk</a>&gt;</span> wrote:<blockquote class=3D"gmail_quote" style=3D=
"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><div class=
=3D"HOEnZb"><div class=3D"h5">On 12/17/2014 01:22 PM, Lakshmi wrote:<br>
&gt; Hi Jens,<br>
&gt;=C2=A0 =C2=A0I am using the below job file, and this works fine when th=
e numjobs is<br>
&gt; less(ex: 5,10) however when I specify a huge numjobs , the job hangs a=
nd<br>
&gt; shows a huge eta as shown in the attached figure.<br>
&gt;<br>
&gt; When I just run a 100% Reads (71K) or 100% writes(20K) separately=C2=
=A0 with<br>
&gt; the below below parameters it works fine, but it is only when i do a m=
ix<br>
&gt; of reads and writes.<br>
&gt;<br>
&gt; Any idea what is going on and if i am missing something?<br>
&gt; OS:RHEL7<br>
&gt; HDDs(sdf):2x300GB Hdds on RAID10<br>
&gt;<br>
&gt; [test]<br>
&gt;=C2=A0 name=3Dtest<br>
&gt;=C2=A0 ioengine=3Dposixaio<br>
&gt;=C2=A0 invalidate=3D1<br>
&gt;=C2=A0 iodepth=3D32<br>
&gt;=C2=A0 bs=3D71K,20K<br>
&gt;=C2=A0 group_reporting=3D1<br>
&gt;=C2=A0 rw=3Drandrw<br>
&gt;=C2=A0 rwmixread=3D96<br>
&gt;=C2=A0 rwmixwrite=3D4<br>
&gt;=C2=A0 direct=3D1<br>
&gt;=C2=A0 buffered=3D0<br>
&gt;=C2=A0 size=3D1M<br>
&gt;=C2=A0 time_based<br>
&gt;=C2=A0 runtime=3D300<br>
&gt;=C2=A0 filename=3D/dev/sdf<br>
&gt;=C2=A0 numjobs=3D64<br>
<br>
</div></div>Doesn&#39;t reproduce here. Please update to the latest fio ver=
sion and see<br>
if it still reproduce, before I spend any time looking at this.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
Jens Axboe<br>
<br>
</font></span></blockquote></div></div>

--e89a8f2351eb6c474d050a720d78--

