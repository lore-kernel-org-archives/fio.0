Return-Path: <brianclam@gmail.com>
MIME-Version: 1.0
In-Reply-To: <5228E546.401@kernel.dk>
References: <5228DDC8.9070201@kernel.dk> <1378410970250.8ab05bfc@Nodemailer> <5228E546.401@kernel.dk>
From: "Brian L." <brianclam@gmail.com>
Date: Fri, 13 Sep 2013 17:22:45 -0700
Message-ID: <CAAAK+WUEmp1jKHtE0QrmkqFD1ixAnUq3z92=6y2V2BDx4Y8Ghw@mail.gmail.com>
Subject: Re: Invalid argument error (EINVAL) on Lustre filesystem with
 ioengine=libaio enabled
Content-Type: multipart/alternative; boundary=001a1133eaca8e6a9f04e64cf932
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Juergen Salk <juergen.salk@uni-ulm.de>
List-ID: <fio@vger.kernel.org>

--001a1133eaca8e6a9f04e64cf932
Content-Type: text/plain; charset=ISO-8859-1

Btw, I was able to resolve by installing libaio-devel rpm.

Thanks.


Brian L.


On Thu, Sep 5, 2013 at 1:10 PM, Jens Axboe <axboe@kernel.dk> wrote:

> On 09/05/2013 01:56 PM, Brian Lam wrote:
> > I experienced an error when trying to use libaio on local disks. I will
> > check when I get back to my desk to see if it is similiar to your
> > errors.  I vaguely remember getting a segfault so I am not sure if they
> > are related.
>
> That sounds more like a build error, then. I'd make clean, configure,
> and make again to be sure.
>
> --
> Jens Axboe
>
>

--001a1133eaca8e6a9f04e64cf932
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Btw, I was able to resolve by installing libaio-devel rpm.=
<div><br></div><div style>Thanks.</div></div><div class=3D"gmail_extra"><br=
 clear=3D"all"><div><br>Brian L.</div>
<br><br><div class=3D"gmail_quote">On Thu, Sep 5, 2013 at 1:10 PM, Jens Axb=
oe <span dir=3D"ltr">&lt;<a href=3D"mailto:axboe@kernel.dk" target=3D"_blan=
k">axboe@kernel.dk</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quot=
e" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">

<div class=3D"im">On 09/05/2013 01:56 PM, Brian Lam wrote:<br>
&gt; I experienced an error when trying to use libaio on local disks. I wil=
l<br>
&gt; check when I get back to my desk to see if it is similiar to your<br>
&gt; errors. =A0I vaguely remember getting a segfault so I am not sure if t=
hey<br>
&gt; are related.<br>
<br>
</div>That sounds more like a build error, then. I&#39;d make clean, config=
ure,<br>
and make again to be sure.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
Jens Axboe<br>
<br>
</font></span></blockquote></div><br></div>

--001a1133eaca8e6a9f04e64cf932--


