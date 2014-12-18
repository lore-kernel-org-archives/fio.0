Return-Path: <sendtold@gmail.com>
MIME-Version: 1.0
In-Reply-To: <549233BF.1020408@kernel.dk>
References: <CAEyTGCfpBS1jE09EkGVFyMU5mn4Rtpt6aozdyyid2bxke+QvVQ@mail.gmail.com>
	<CAEyTGCc1W7J60WXQ3uLFHxpsV-pM3tbqWPxTzjWWUcLgHyd8wg@mail.gmail.com>
	<549233BF.1020408@kernel.dk>
Date: Thu, 18 Dec 2014 11:08:32 -0600
Message-ID: <CAEyTGCdHacdp02U8iNe5TEkvkD25Qs-=BNTgw4q4N4DzFdWyhw@mail.gmail.com>
Subject: Re: Fwd: Huge eta with R/W mix job and job hangs
From: Lakshmi <sendtold@gmail.com>
Content-Type: multipart/alternative; boundary=047d7bfd05664d0ef2050a80a4dd
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

--047d7bfd05664d0ef2050a80a4dd
Content-Type: text/plain; charset=UTF-8

Hi Jens,
   Updated to 2.2.0 and I am still seeing the same issue.
==========================================

# fio FIO_Test.job
test: (g=0): rw=randrw, bs=71K-71K/20K-20K/20K-20K, ioengine=posixaio,
iodepth=32
...
fio-2.2.0
Starting 64 processes
Jobs: 10 (f=10):
[_(18),m(1),_(1),m(1),_(8),m(1),_(1),m(1),_(4),m(1),_(2),m(1),_(1),m(1),_(3),m(2),_(12),m(1),_(4)]
[1.9% done] [301.4MB/0KB/0KB /s] [4425/0/]
Jobs: 10 (f=10):
[_(18),m(1),_(1),m(1),_(8),m(1),_(1),m(1),_(4),m(1),_(2),m(1),_(1),m(1),_(3),m(2),_(12),m(1),_(4)]
[1.9% done] [0KB/0KB/0KB /s] [0/0/0 iops]
Jobs: 10 (f=10):
[_(18),m(1),_(1),m(1),_(8),m(1),_(1),m(1),_(4),m(1),_(2),m(1),_(1),m(1),_(3),m(2),_(12),m(1),_(4)]
[2.0% done] [0KB/0KB/0KB /s] [0/0/0 iops] [eta 26m:57s]
..................................

Jobs: 10 (f=10):
[_(18),m(1),_(1),m(1),_(8),m(1),_(1),m(1),_(4),m(1),_(2),m(1),_(1),m(1),_(3),m(2),_(12),m(1),_(4)]
[0.0% done] [0KB/0KB/0KB /s] [0/0/0 iops]Jobs: 10 (f=10):
[_(18),m(1),_(1),m(1),_(8),m(1),_(1),m(1),_(4),m(1),_(2),m(1),_(1),m(1),_(3),m(2),_(12),m(1),_(4)]
[0.0% done] [0KB/0KB/0KB /s] [0/0/0 iops]Killed1158050441d:06h:30m:16s]

Thanks
Ld

On Wed, Dec 17, 2014 at 7:54 PM, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 12/17/2014 04:46 PM, Lakshmi wrote:
> > Hi Jens,
> >  I am using the latest version of fio 2.1.10
>
> 2.1.10 was released back in June, there's been 11-14 since then. Just
> try 2.2.0, which was released today.
>
> --
> Jens Axboe
>
>

--047d7bfd05664d0ef2050a80a4dd
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div>Hi Jens,<br>=C2=A0 =C2=A0Updated to 2.2.0 and I =
am still seeing the same issue.<br>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D<br><span style=3D"font-family:monospace"><br># fio FIO_Test.jo=
b<br>test: (g=3D0): rw=3Drandrw, bs=3D71K-71K/20K-20K/20K-20K, ioengine=3Dp=
osixaio, iodepth=3D32</span><br>...<br><span style=3D"font-family:monospace=
">fio-2.2.0<br>Starting 64 processes<br>Jobs: 10 (f=3D10): [_(18),m(1),_(1)=
,m(1),_(8),m(1),_(1),m(1),_(4),m(1),_(2),m(1),_(1),m(1),_(3),m(2),_(12),m(1=
),_(4)] [1.9% done] [301.4MB/0KB/0KB /s] [4425/0/]<br>Jobs: 10 (f=3D10): [_=
(18),m(1),_(1),m(1),_(8),m(1),_(1),m(1),_(4),m(1),_(2),m(1),_(1),m(1),_(3),=
m(2),_(12),m(1),_(4)] [1.9% done] [0KB/0KB/0KB /s] [0/0/0 iops]<br>Jobs: 10=
 (f=3D10): [_(18),m(1),_(1),m(1),_(8),m(1),_(1),m(1),_(4),m(1),_(2),m(1),_(=
1),m(1),_(3),m(2),_(12),m(1),_(4)] [2.0% done] [0KB/0KB/0KB /s] [0/0/0 iops=
] [eta 26m:57s]<br>..................................<br><br>Jobs: 10 (f=3D=
10): [_(18),m(1),_(1),m(1),_(8),m(1),_(1),m(1),_(4),m(1),_(2),m(1),_(1),m(1=
),_(3),m(2),_(12),m(1),_(4)] [0.0% done] [0KB/0KB/0KB /s] [0/0/0 iops]Jobs:=
 10 (f=3D10): [_(18),m(1),_(1),m(1),_(8),m(1),_(1),m(1),_(4),m(1),_(2),m(1)=
,_(1),m(1),_(3),m(2),_(12),m(1),_(4)] [0.0% done] [0KB/0KB/0KB /s] [0/0/0 i=
ops]Killed1158050441d:06h:30m:16s]</span><br><br></div>Thanks<br></div>Ld<b=
r><div><div><div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">=
On Wed, Dec 17, 2014 at 7:54 PM, Jens Axboe <span dir=3D"ltr">&lt;<a href=
=3D"mailto:axboe@kernel.dk" target=3D"_blank">axboe@kernel.dk</a>&gt;</span=
> wrote:<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border=
-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On 12/17/2014 04:46=
 PM, Lakshmi wrote:<br>
&gt; Hi Jens,<br>
&gt;=C2=A0 I am using the latest version of fio 2.1.10<br>
<br>
</span>2.1.10 was released back in June, there&#39;s been 11-14 since then.=
 Just<br>
try 2.2.0, which was released today.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
Jens Axboe<br>
<br>
</font></span></blockquote></div></div></div></div></div></div>

--047d7bfd05664d0ef2050a80a4dd--

